//
//  QuestionSquareViewController.m
//  MHProject
//
//  Created by 张好志 on 15/7/3.
//  Copyright (c) 2015年 Andy. All rights reserved.
//
#define Limit  @"10"

#import "QuestionSquareViewController.h"
#import "QuestionListCell.h"
#import "QuestionListDetailViewController.h"
#import "SearchListViewController.h"

@interface QuestionSquareViewController ()

@end

@implementation QuestionSquareViewController

#pragma mark -- http网络请求相关
-(void)requestTableDataWithRefresh:(BOOL)refreshFlag
{
    //1、配置请求参数
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    if (!uid)
    {
        uid = @"0";//未登录情况下
    }
    if (!self.categoryID) {
        self.categoryID = @"0";//如果类别id不存在就设置为0（代表问题广场界面的数据）
    }
    NSString *pageNum = [NSString stringWithFormat:@"%ld",self.pageNumber];
    
    [DataHander showDlg];
    //2、发起请求
    [MHAsiNetworkAPI getQuestionListWithUserID:uid
                                      page_num:pageNum
                                         limit:Limit
                                   category_id:self.categoryID
                                  SuccessBlock:^(id returnData)
     {
         DEF_DEBUG(@"问题列表返回的数据：%@",returnData);
         
         NSString *ret = returnData[@"ret"];
         NSString *msg = returnData[@"msg"];
         if ([ret integerValue]==0)
         {
             NSMutableArray *questionList = returnData[@"data"];
             if (questionList.count == 0)
             {
                 if (refreshFlag)
                 {
                     [self.questionListArray removeAllObjects];
                     [DataHander showInfoWithTitle:@"亲，当前分类下暂无问题"];
                 }
                 else
                 {
                     [DataHander showInfoWithTitle:@"亲，没有更多问题了"];
                     self.tableView.hasMoreData = NO;
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
                     self.tableView.hasMoreData = YES;
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
         [self.tableView reloadData];
     } failureBlock:^(NSError *error) {
         [self tableViewEndLoading];
     } showHUD:NO];
}

#pragma mark -- view Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self setNavUI];
    
    [self initUI];
}

#pragma mark - UI

- (void)setNavUI
{
    // 自定义的导航栏
    if (self.categoryName) {
        [self showNavBarDefaultHUDByNavTitle:self.categoryName inView:self.view isBack:YES];
    }else{
        [self showNavBarWithTwoBtnHUDByNavTitle:@"问题列表" leftImage:@"" leftTitle:@"" rightImage:@"search_blue" rightTitle:@"" inView:self.view isBack:NO];
    }
}
- (void)initUI
{
    float height = self.categoryName ?(DEF_SCREEN_HEIGHT - 64):(DEF_SCREEN_HEIGHT - 64-50);
    self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 64,DEF_SCREEN_WIDTH ,  height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.pullingDelegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
}

- (void)initData
{
    self.questionListArray = [[NSMutableArray alloc]init];
    self.pageNumber = 0;
    [self requestTableDataWithRefresh:YES];
}

#pragma mark - UITableViewDetegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.questionListArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"questionListCell";
    QuestionListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[QuestionListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:cell.frame];
        [cell addSubview:backgroundView];
        backgroundView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
        cell.selectedBackgroundView = backgroundView;
    }
    //
    NSDictionary *questionDict = [self.questionListArray objectAtIndex:indexPath.row];
    [cell loadCellWithDict:questionDict];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *questionDict = [self.questionListArray objectAtIndex:indexPath.row];
    CGFloat height = [QuestionListCell heightForCellWithDict:questionDict];
    return  height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    QuestionListDetailViewController *vc = [[QuestionListDetailViewController alloc] init];
    NSDictionary *questionDict = [self.questionListArray objectAtIndex:indexPath.row];
    __weak QuestionSquareViewController *weakSelf = self;
    vc.reloadBlock = ^{
        [weakSelf.tableView reloadData];
    };
    vc.questionID = questionDict[@"question_id"];
    vc.questionDetailDict = *&questionDict;
    [MobClick event:@"LawQList_QClick" attributes:@{@"question_ID":questionDict[@"question_id"]}];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 按钮点击事件
- (void)rightNavItemClick
{
    [MobClick event:@"LawQList_Search"];
    SearchListViewController *searchList = [[SearchListViewController alloc]init];
    searchList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchList animated:YES];
}


#pragma mark-- 下拉刷新上啦加载
#pragma mark- pullReflreshDelegate
-(void)tableViewEndLoading
{
    [self.tableView tableViewDidFinishedLoading];
}
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    self.pageNumber = 0;
    [MobClick event:@"LawQList_ListUP"];
    [self requestTableDataWithRefresh:YES];
}
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    self.pageNumber ++;
    [MobClick event:@"LawQList_Down"];
    [self requestTableDataWithRefresh:NO];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView tableViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.tableView tableViewDidEndDragging:scrollView];
}
- (NSDate *)pullingTableViewRefreshingFinishedDate
{
    return [NSDate date];
}
- (NSDate *)pullingTableViewLoadingFinishedDate
{
    return [NSDate date];
}

- (void)didReceiveMemoryWarning
{
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
