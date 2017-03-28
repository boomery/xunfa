//
//  HomeViewController.m
//  BMProject
//
//  Created by 杜宾 on 15/4/19.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "CategoryDeatilViewController.h"
#import "QuestionListCell.h"
#import "QuestionListDetailViewController.h"
#import "QuestionModel.h"
#import "IndustryTagViewController.h"
#import "SearchListViewController.h"
#import "NewsViewController.h"


#define Limit  @"10"
//#define BIG_SPACE  80

@interface CategoryDeatilViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>

@end

@implementation CategoryDeatilViewController

#pragma mark -- http网络请求相关
-(void)requestTableDataWithRefresh:(BOOL)refreshFlag
{
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    if (!uid)
    {
        uid = @"0";//未登录情况下
    }
    NSString *pageNum = [NSString stringWithFormat:@"%ld",self.pageNumber];
    
    [DataHander showDlg];
    [MHAsiNetworkAPI getQuestionListWithUserID:uid
                                      page_num:pageNum
                                         limit:Limit
                                   category_id:self.categoryID
                                  SuccessBlock:^(id returnData)
    {
        DEF_DEBUG(@"问题列表：%@",returnData);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"home.plist"]];   // 保存文件的名称
        [returnData writeToFile:filePath atomically:YES];
        DEF_PERSISTENT_SET_OBJECT(@"保存首页数据", @"key");
        
        NSString *ret = returnData[@"ret"];
        NSString *msg = returnData[@"msg"];
        if ([ret integerValue]==0)
        {
            NSMutableArray *questionList = returnData[@"data"];
            if (questionList.count == 0)
            {
                if (refreshFlag)
                {
                    [DataHander showInfoWithTitle:@"亲，当前分类下暂无问题"];
                }
                else
                {
                    [DataHander showInfoWithTitle:@"亲，没有更多问题了"];
                    self.questionListTableView.hasMoreData = NO;
                    self.pageNumber --;
                }
            }
            else
            {
                [DataHander hideDlg];
                if (refreshFlag)
                {
                    [self.questionListArray removeAllObjects];
                }
                else
                {
                    self.questionListTableView.hasMoreData = YES;
                }
                for (NSDictionary *dict in questionList)
                {
                    [self.questionListArray addObject:dict];
                }
            }
        }
        else
        {
            [DataHander hideDlg];
            SHOW_ALERT(msg);
        }
        [self tableViewEndLoading];
        [self.questionListTableView reloadData];
    } failureBlock:^(NSError *error) {
    } showHUD:NO];
}

#pragma mark -- view lifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
    
    [self setNavUI];
}
- (void)dealloc
{
    
}
#pragma mark -- 初始化
- (void)initData
{
    self.questionListArray = [[NSMutableArray alloc]init];
    self.pageNumber = 0;
    [self requestTableDataWithRefresh:YES];
}
- (void)setNavUI
{
    [self showNavBarDefaultHUDByNavTitle:self.title inView:self.view isBack:YES];
}
- (void)initUI
{
    //
    self.questionListTableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 64,DEF_SCREEN_WIDTH , DEF_SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.questionListTableView .delegate = self;
    self.questionListTableView .dataSource = self;
    self.questionListTableView .pullingDelegate = self;
    self.questionListTableView.backgroundColor = [UIColor clearColor];
    self.questionListTableView .separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.questionListTableView ];
}

#pragma mark  --
#pragma mark - UITableViewDetegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.questionListArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    QuestionListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[QuestionListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    NSDictionary *questionDict = [self.questionListArray objectAtIndex:indexPath.row];
    [cell loadCellWithDict:questionDict];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *lawerDict = [self.questionListArray objectAtIndex:indexPath.row];
    
    return  [QuestionListCell heightForCellWithDict:lawerDict];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionListDetailViewController *detail = [[QuestionListDetailViewController alloc]init];
    NSDictionary *dict = [self.questionListArray objectAtIndex:indexPath.row];
    __weak CategoryDeatilViewController *weakSelf = self;
    detail.reloadBlock = ^{
        [weakSelf.questionListTableView reloadData];
    };
    detail.questionID = dict[@"question_id"];
    detail.questionDetailDict = *&dict;
    [MobClick event:@"LawQList_QClick" attributes:@{@"question_ID":dict[@"question_id"]}];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark-- 下拉刷新上啦加载
#pragma mark- pullReflreshDelegate
-(void)tableViewEndLoading
{
    [self.questionListTableView tableViewDidFinishedLoading];
}
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    self.pageNumber = 0;
    [self requestTableDataWithRefresh:YES];
}
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    self.pageNumber ++;
    [self requestTableDataWithRefresh:NO];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.questionListTableView tableViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.questionListTableView tableViewDidEndDragging:scrollView];
}
- (NSDate *)pullingTableViewRefreshingFinishedDate
{
    return [NSDate date];
}
- (NSDate *)pullingTableViewLoadingFinishedDate
{
    return [NSDate date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
