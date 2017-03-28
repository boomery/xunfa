//
//  IntegralDetailViewController.m
//  MHProject
//
//  Created by 张好志 on 15/7/16.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "DotDetailViewController.h"
#import "PointDetailCell.h"
#import "WithdrawSettingViewController.h"
#import "WithdrawApplyForViewController.h"
#import "IntegralTableViewCell.h"

@interface DotDetailViewController ()

@end

@implementation DotDetailViewController
#pragma mark -- http网络请求相关
-(void)requestTableDataWithRefresh:(BOOL)refreshFlag
{
    //
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = DEF_API_GetMyDot;
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];

    //
    [DataHander showDlg];
    [MHAsiNetworkAPI getMyDotWithuid:uid
                           timestamp:timeStamp
                                sign:sign
                        SuccessBlock:^(id returnData)
     {
         DEF_DEBUG(@"积点明细列表：%@",returnData);
         NSString *ret = returnData[@"ret"];
         NSString *msg = returnData[@"msg"];
         if ([ret integerValue]==0)
         {
             NSMutableArray *questionList = returnData[@"data"];
             if (refreshFlag)
             {
                 [self.pointArray removeAllObjects];
                 if (questionList.count==0)
                 {
                     [DataHander showInfoWithTitle:@"亲，您还没有积点，可以通过解答问题获得积点哦"];
                 }
                 else
                 {
                     [DataHander hideDlg];
                     for (NSDictionary *dict in questionList)
                     {
                         [self.pointArray addObject:dict];
                     }
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self initData];

    [self initUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initNav];
    [self requestTableDataWithRefresh:YES];
}

#pragma mark --初始化
-(void)initNav
{
    NSString  *applyforMoneyString = DEF_PERSISTENT_GET_OBJECT(DEF_ApplyForMoney);
    if (applyforMoneyString)
    {
        [self showNavBarWithTwoBtnHUDByNavTitle:@"积点明细" leftImage:@"menu-left-back" leftTitle:@"" rightImage:@"" rightTitle:@"提现申请" inView:self.view isBack:YES];
    }
    else
    {
        [self showNavBarWithTwoBtnHUDByNavTitle:@"积点明细" leftImage:@"menu-left-back" leftTitle:@"" rightImage:@"" rightTitle:@"兑现设置" inView:self.view isBack:YES];
    }
}
#pragma mark - 点击事件
- (void)leftNavItemClick
{
    [MobClick event:@"LawCash_Back"];
    [self.navigationController popViewControllerAnimated:YES];
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
//    if (indexPath.row == 0)
//    {
//        cell.upLine.hidden = YES;
//    }
//    if ( indexPath.row==self.pointArray.count-1) {
//        cell.downLine.hidden = YES;
//    }
//    
    //
    NSDictionary *dict =self.pointArray[indexPath.row];
    [cell loadCellWithDotDict:dict];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [IntegralTableViewCell heightForCellWithDict:nil];
}

#pragma mark -- 按钮点击事件
-(void)rightNavItemClick
{
    

    NSString  *applyforMoneyString = DEF_PERSISTENT_GET_OBJECT(DEF_ApplyForMoney);
    if (applyforMoneyString)
    {
        [MobClick event:@"LawCash_Setup"];
        WithdrawApplyForViewController *VC = [[WithdrawApplyForViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }
    else
    {
        [MobClick event:@"LawCash_Get"];
        WithdrawSettingViewController *VC = [[WithdrawSettingViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }
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
