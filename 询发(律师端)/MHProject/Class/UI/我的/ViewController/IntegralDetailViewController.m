//
//  PointDetailViewController.m
//  MHProject
//
//  Created by 张好志 on 15/6/24.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "IntegralDetailViewController.h"
#import "PointDetailCell.h"

#import "IntegralTableViewCell.h"

@interface IntegralDetailViewController ()

@end

@implementation IntegralDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initData];
    
    [self initNav];
    
    [self initUI];
    
    //
    [self requestTableDataWithRefresh:YES];
}

#pragma mark -- http网络请求相关
-(void)requestTableDataWithRefresh:(BOOL)refreshFlag
{
    
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = DEF_API_GetMyPoint;
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    [DataHander showDlg];
    [MHAsiNetworkAPI getMyPointWithuid:uid
                             timestamp:timeStamp
                                  sign:sign
                          SuccessBlock:^(id returnData)
     {
         DEF_DEBUG(@"积分明细列表：%@",returnData);
         NSString *ret = returnData[@"ret"];
         NSString *msg = returnData[@"msg"];
         if ([ret integerValue]==0)
         {
             NSMutableArray *questionList = returnData[@"data"];
           
                 if (questionList.count==0)
                 {
                     [DataHander showInfoWithTitle:@"亲，您还没有积分，可以通过解答问题获得积分哦"];
                 }
                 else
                 {
                     if (refreshFlag)
                     {
                         [self.pointArray removeAllObjects];
                     }
                     [DataHander hideDlg];
                     for (NSDictionary *dict in questionList)
                     {
                         [self.pointArray addObject:dict];
                     }
                 }
         }
         else
         {
             [DataHander hideDlg];
             SHOW_ALERT(msg);
         }
         [self.pointDetailTableView reloadData];
     } failureBlock:^(NSError *error) {
     } showHUD:NO];
}


#pragma mark --初始化
-(void)initNav
{
    [self showNavBarDefaultHUDByNavTitle:@"积分明细" inView:self.view isBack:YES];

//    [self addNavBarTitle:@"积分明细"];
//    [self addLeftNavBarBtnByImg:@"menu-left-back" andWithText:@""];
}
-(void)initUI
{
    if (!self.pointDetailTableView)
    {
        self.pointDetailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        self.automaticallyAdjustsScrollViewInsets = YES;
        self.pointDetailTableView.backgroundColor = [UIColor clearColor];
        self.pointDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.pointDetailTableView.delegate = self;
        self.pointDetailTableView.dataSource = self;
        [self.view addSubview:self.pointDetailTableView];
    }
}

-(void)initData
{
    self.pointArray = [[NSMutableArray alloc]init];
}


#pragma mark - UITableViewDategate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pointArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell";
    
    IntegralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[IntegralTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //
    NSDictionary *dict =self.pointArray[indexPath.row];
    [cell loadCellWithDict:dict];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [IntegralTableViewCell heightForCellWithDict:nil];
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
















