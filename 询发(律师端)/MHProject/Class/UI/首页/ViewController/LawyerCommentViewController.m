//
//  LawerCommentViewController.m
//  MHProject
//
//  Created by 张好志 on 15/6/26.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "LawyerCommentViewController.h"
#import "LawyerCommentCell.h"

@interface LawerCommentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
}

@property (nonatomic,strong) UITableView    *lawerCommentTableView;


@end

@implementation LawerCommentViewController

//#pragma mark -- http网络请求相关
#pragma mark -- http网络请求相关
-(void)getLawyerPingDataByHttpRequest
{
    NSString *lawyerId = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = DEF_API_LawerPing;
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    [DataHander showDlg];
    [MHAsiNetworkAPI getLawerPingWithUid:uid timestamp:timeStamp sign:sign lawyer_id:lawyerId SuccessBlock:^(id returnData) {
        DEF_DEBUG(@"律师的评价信息返回的数据：%@",returnData);
        
        NSString *msg = returnData[@"msg"];
        NSString *ret = returnData[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            NSArray *dataArray = returnData[@"data"];
            if (dataArray.count == 0)
            {
                [DataHander showInfoWithTitle:@"暂无评价"];
            }
            else
            {
                [DataHander hideDlg];
                NSMutableArray *lawercommerArr = [[NSMutableArray alloc]init];
                for (NSDictionary *dict in dataArray)
                {
                    [lawercommerArr addObject:dict];
                }
                [self.lawyerCommentArray addObjectsFromArray:lawercommerArr];
                [self.lawerCommentTableView reloadData];
            }
        }
        else
        {
            [DataHander hideDlg];
            SHOW_ALERT(msg);
        }
        
    } failureBlock:^(NSError *error) {
    } showHUD:NO];
}

#pragma mark -- view lifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
    [self initUI];
}
#pragma mark -- 初始化相关
-(void)initData
{
    if (!self.lawyerCommentArray)
    {
        [self showNavBarDefaultHUDByNavTitle:@"我的评价" inView:self.view isBack:YES];
        self.lawyerCommentArray = [[NSMutableArray alloc] init];
        [self getLawyerPingDataByHttpRequest];
    }
    else
    {
        [self setNavUI];
    }
}
- (void)setNavUI
{
    if (self.lawyerCommentArray.count == 0)
    {
        [DataHander showInfoWithTitle:@"亲，暂无评价"];
    }

    NSString *lawyerName = self.lawyerInfoDict[@"name"];
    // 自定义的导航栏
    NSString *title = [NSString stringWithFormat:@"%@的评价",lawyerName];
    [self showNavBarDefaultHUDByNavTitle:title inView:self.view isBack:YES];
}
- (void)initUI
{
    self.lawerCommentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, DEF_SCREEN_WIDTH,DEF_SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.lawerCommentTableView.delegate = self;
    self.lawerCommentTableView.dataSource = self;
    self.lawerCommentTableView.backgroundColor = [UIColor clearColor];
    self.lawerCommentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.lawerCommentTableView];
}

#pragma mark - UITableViewDetegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.lawyerCommentArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"lawerCommentCell";
    LawerCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[LawerCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    NSDictionary *dict =self.lawyerCommentArray[indexPath.section];
    
    [cell loadCellWithDict:dict];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict =self.lawyerCommentArray[indexPath.section];
    return [LawerCommentCell heightForCellWithDict:dict];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 10;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 20)];
//    headerView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
//    headerView.backgroundColor = [UIColor redColor];
//    return headerView;
//}
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
