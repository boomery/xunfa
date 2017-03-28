//
//  MyOrderViewController.m
//  MHProject
//
//  Created by 张好志 on 15/8/25.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyTitleBar.h"
#import "PengdingViewCell.h"
#import "CompletedCell.h"
#import "MyOrderDetailViewController.h"
#import "MyCompleteOrderViewController.h"
#import "ApplyAppointmentViewController.h"

@interface MyOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)MyTitleBar *titleBar;
@property (nonatomic,assign) NSInteger index;
@property(nonatomic,strong)UITableView *pendingTableView;
@property(nonatomic,strong)UITableView *completedTableView;
@property(nonatomic,strong)NSMutableArray *pendingArray;//未完成的数组
@property(nonatomic,strong)NSMutableArray *completedArray;//已完成的数组

@end

@implementation MyOrderViewController

/*
   21.律师未完成的订单，22.律师已完成的订单
 */
//未完成的请求
-(void)getPendingDataByHttpRequest
{
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = DEF_API_Get_f2fMyOrder;
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    [DataHander showDlg];
    [MHAsiNetworkAPI getMyOrderWithuid:uid
                             timestamp:timeStamp
                                  sign:sign
                                  type:@"21"
                          SuccessBlock:^(id returnData)
     {
         DEF_DEBUG(@"我的未完成订单接口返回的数据：%@",returnData);
         
         NSString *ret = returnData[@"ret"];
         NSString *msg = returnData[@"msg"];
         if ([ret isEqualToString:@"0"])
         {
             [self.pendingArray removeAllObjects];
             NSArray *dataArray = returnData[@"data"];
             if (dataArray.count==0)
             {
                 [DataHander showInfoWithTitle:@"亲，无数据"];
             }
             else
             {
                 [DataHander hideDlg];
                 [self.pendingArray addObjectsFromArray:dataArray];
             }
         }
         else
         {
             [DataHander hideDlg];
             SHOW_ALERT(msg);
         }
         
         [self.pendingTableView reloadData];
     } failureBlock:^(NSError *error) {
         SHOW_ALERT(@"亲，网络通讯异常");
         [DataHander hideDlg];
     } showHUD:NO];
}
// 已完成的请求
-(void)getCompletedDataByHttpRequest
{
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = DEF_API_Get_f2fMyOrder;
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    [DataHander showDlg];
    [MHAsiNetworkAPI getMyOrderWithuid:uid
                             timestamp:timeStamp
                                  sign:sign
                                  type:@"22"
                          SuccessBlock:^(id returnData)
     {
         DEF_DEBUG(@"我的已完成订单接口返回的数据：%@",returnData);
         
         NSString *ret = returnData[@"ret"];
         NSString *msg = returnData[@"msg"];
         if ([ret isEqualToString:@"0"])
         {
             //
             [self.completedArray removeAllObjects];
             
             NSArray *dataArray = returnData[@"data"];
             if (dataArray.count==0)
             {
                 [DataHander showInfoWithTitle:@"亲，无数据"];
             }
             else
             {
                 [DataHander hideDlg];
                 [self.completedArray addObjectsFromArray:dataArray];
             }
         }
         else
         {
             [DataHander hideDlg];
             SHOW_ALERT(msg);
         }
         
         [self.completedTableView reloadData];
     } failureBlock:^(NSError *error) {
         SHOW_ALERT(@"亲，网络通讯异常");
         [DataHander hideDlg];
     } showHUD:NO];
}

#pragma mark -- viewLifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
    
    [self initNav];
    
    //未完成的数据
    [self getPendingDataByHttpRequest];
}

#pragma mark -- 初始化
-(void)initNav
{
    [self showNavBarWithTwoBtnHUDByNavTitle:@"我的预约单" leftImage:@"menu-left-back" leftTitle:@"" rightImage:@"" rightTitle:@"约见资料" inView:self.view isBack:YES];
}
-(void)rightNavItemClick
{
    //约见资料
    ApplyAppointmentViewController *app = [[ApplyAppointmentViewController alloc]init];
    app.meet_is_on = @"1";
    [self.navigationController pushViewController:app animated:YES];
}

-(void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self creatContScrollView];
    
    NSArray *titles = @[@"待处理",@"已完成"];
    self.titleBar = [[MyTitleBar alloc] initWithFrame:CGRectMake(0, 64, DEF_SCREEN_WIDTH, 40) withTitleArray:titles];
    __block MyOrderViewController *weakSelf = self;
    self.titleBar.titleBlock = ^(long index){
        weakSelf.index = index;
        if (index == 0)
        {
            //            未完成的数据请求
            [weakSelf getPendingDataByHttpRequest];
        }
        else
        {
            //            已完成的请求数据
            [weakSelf getCompletedDataByHttpRequest];
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.contentScrollView.contentOffset = CGPointMake(index*DEF_SCREEN_WIDTH, 0);
        }];
        
    };
    [self.view addSubview:self.titleBar];

    //    分页
    self.contentScrollView.contentSize = CGSizeMake(DEF_SCREEN_WIDTH*2,0);
    self.contentScrollView.pagingEnabled = YES;
    //    self.contentScrollView.delegate = self;
    self.contentScrollView.scrollEnabled = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;

    float y = 40;
    //    未处理
    self.pendingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, y, DEF_SCREEN_WIDTH,DEF_SCREEN_HEIGHT-64-y) style:UITableViewStylePlain];
    self.pendingTableView.delegate = self;
    self.pendingTableView.dataSource = self;
    //    self.myOrderTableView.tag = questionTableViewTag;
    self.pendingTableView.backgroundColor = [UIColor clearColor];
    self.pendingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.pendingTableView.rowHeight = 94;
    self.pendingTableView.showsVerticalScrollIndicator = NO;
    [self.contentScrollView addSubview:self.pendingTableView];
    
    //    已完成
    self.completedTableView = [[UITableView alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH, DEF_TOP(self.pendingTableView), DEF_WIDTH(self.pendingTableView),DEF_SCREEN_HEIGHT-64-y) style:UITableViewStylePlain];
    self.completedTableView.delegate = self;
    self.completedTableView.dataSource = self;
    //    self.myOrderCompletedTableView.tag = lawerTableViewTag;
    self.completedTableView.backgroundColor = [UIColor clearColor];
    self.completedTableView.showsVerticalScrollIndicator = NO;
    self.completedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.completedTableView.rowHeight = 94;
    [self.contentScrollView addSubview:self.completedTableView];

}
-(void)initData
{
    self.pendingArray = [[NSMutableArray alloc]init];
    self.completedArray = [[NSMutableArray alloc]init];
}
#pragma mark - UITableViewDetegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.index == 0)
    {
        return self.pendingArray.count;
    }
    else
    {
        return  self.completedArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 0)
    {
        static NSString *cellIdentifier = @"cell";
        PengdingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell = [[PengdingViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        NSDictionary *dict = self.pendingArray[indexPath.row];
        [cell loaPendingCellWithDict:dict];
        return cell;
    }
    else
    {
        static NSString *completedCellIdentifier = @"Cell";
        CompletedCell *cell = [tableView dequeueReusableCellWithIdentifier:completedCellIdentifier];
        if (!cell)
        {
            cell = [[CompletedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:completedCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        
        //
        NSDictionary *dict = self.completedArray[indexPath.row];
        [cell loadCompletedCellWithDict:dict];
        
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 0)
    {
        NSDictionary *dict = self.pendingArray[indexPath.row];
        MyOrderDetailViewController *vc = [[MyOrderDetailViewController alloc]init];
        vc.orderID = dict[@"order_id"];
        vc.ReloadDataBlock = ^{
            [self getPendingDataByHttpRequest];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        NSDictionary *dict = self.completedArray[indexPath.row];
        MyCompleteOrderViewController *vc = [[MyCompleteOrderViewController alloc]init];
        vc.orderID = dict[@"order_id"];
        [self.navigationController pushViewController:vc animated:YES];
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
