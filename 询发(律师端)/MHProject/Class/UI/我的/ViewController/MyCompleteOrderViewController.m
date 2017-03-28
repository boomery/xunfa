//
//  MyCompleteOrderViewController.m
//  MHProject
//
//  Created by 张好志 on 15/8/25.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "MyCompleteOrderViewController.h"
#import "OrderInfoView.h"

@interface MyCompleteOrderViewController ()

@property(nonatomic,strong)OrderInfoView   *orderNumberView;//预约单编号
@property(nonatomic,strong)OrderInfoView   *meetPersonView;//约见人
@property(nonatomic,strong)OrderInfoView   *meetPhoneNumberView;//联系电话
@property(nonatomic,strong)OrderInfoView   *getPointView;//时间


@property(nonatomic,strong)UILabel   *appointmentLab;//时间
@property(nonatomic,strong)UILabel   *meetingDateLab;//时间
@property(nonatomic,strong)UILabel   *lawyerConfirmLab;//时间
@property(nonatomic,strong)UILabel   *userConfirmLab;//时间

@end

@implementation MyCompleteOrderViewController
-(void)getOrderDetailByHttpRequestWithOrderID:(NSString *)orderID
{
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = [NSString stringWithFormat:@"%@/%@",DEF_API_Get_f2fOrder,orderID];
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    [MHAsiNetworkAPI showOrderWithuid:uid
                            timestamp:timeStamp
                                 sign:sign
                              orderID:orderID
                         SuccessBlock:^(id returnData)
     {
         DEF_DEBUG(@"我的订单详情：%@",returnData);
         
         NSString *ret = returnData[@"ret"];
         NSString *msg = returnData[@"msg"];
         if ([ret isEqualToString:@"0"])
         {
             NSDictionary *dict = returnData[@"data"];
             
             //根据数据创建界面
             [self initUIWithOrderDetailDict:dict];
         }
         else
         {
             SHOW_ALERT(msg);
         }
     } failureBlock:^(NSError *error) {
         
     } showHUD:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
    [self initNav];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark -- 初始化
-(void)initNav
{
    [self showNavBarDefaultHUDByNavTitle:@"预约详情" inView:self.view isBack:YES];
}
-(void)initData
{
    [self getOrderDetailByHttpRequestWithOrderID:self.orderID];
}
-(void)initUIWithOrderDetailDict:(NSDictionary *)dict
{
    /*
     "coupon_amount" = 0;
     "coupon_id" = 0;
     "created_at" = "08-27 11:08";
     "lawyer_id" = 13;
     "lawyer_mobile" = 15136123242;
     "lawyer_name" = "\U5f20\U597d\U5fd7";
     "meet_date" = "2015-9-20 14:00 - 16";
     "meet_date_is_mod" = 0;
     "meet_price" = 200;
     "pay_amount" = 0;
     "pay_type" = "\U652f\U4ed8\U5b9d\U652f\U4ed8";
     state = "\U7528\U6237\U5df2\U53d6\U6d88";
     "user_id" = 1;
     "user_mobile" = 18516111573;
     "user_name" = "\U5c0f\U4e0d\U61c2";
     */
    
    if (self.contentScrollView) {
        [self.contentScrollView removeFromSuperview];
    }
    [self creatContScrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //
    UILabel *tipLb = [[UILabel alloc]initWithFrame:CGRectMake(12 ,0, DEF_SCREEN_WIDTH-24, 44)];
    tipLb.backgroundColor = [UIColor clearColor];
    tipLb.textColor = DEF_RGB_COLOR(60, 62, 70);
    tipLb.font = [UIFont systemFontOfSize:17];
    tipLb.text = @"您的预约信息如下";
    [self.contentScrollView addSubview:tipLb];

    //
    float lineHeight = DEF_SCREEN_IS_6plus ?1/2.0 :1/3.0;
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0,44.0-lineHeight, DEF_SCREEN_WIDTH, lineHeight)];
    line.backgroundColor = DEF_RGB_COLOR(214, 214, 217);
    [self.contentScrollView addSubview:line];

    //
    float y = 44;
    self.orderNumberView = [[OrderInfoView alloc]initWithFrame:CGRectMake(0, y, DEF_SCREEN_WIDTH, 176.0/3.0)];
    self.orderNumberView.myInfoLeft.text= @"预约单编号";
    self.orderNumberView.myInfoRight.text= self.orderID;
    [self.contentScrollView addSubview:self.orderNumberView];
    
    y += 176.0/3.0;
    self.meetPersonView = [[OrderInfoView alloc]initWithFrame:CGRectMake(0, y, DEF_SCREEN_WIDTH, 176.0/3.0)];
    self.meetPersonView.myInfoLeft.text= @"约见人";
    self.meetPersonView.myInfoRight.text=dict[@"user_name"];
    [self.contentScrollView addSubview:self.meetPersonView];

    y += 176.0/3.0;
    self.meetPhoneNumberView = [[OrderInfoView alloc]initWithFrame:CGRectMake(0, y, DEF_SCREEN_WIDTH, 176.0/3.0)];
    self.meetPhoneNumberView.myInfoLeft.text= @"联系电话";
    self.meetPhoneNumberView.myInfoRight.text= dict[@"user_mobile"];
    [self.contentScrollView addSubview:self.meetPhoneNumberView];

    y += 176.0/3.0;
    self.getPointView = [[OrderInfoView alloc]initWithFrame:CGRectMake(0, y, DEF_SCREEN_WIDTH, 176.0/3.0)];
    self.getPointView.myInfoLeft.text= @"获得积点";
    self.getPointView.myInfoRight.text= dict[@"coupon_amount"];
    [self.contentScrollView addSubview:self.getPointView];
    
    y += 176.0/3.0 + 40.0/3.0;
    UIView *bottomBgView = [[UIView alloc]initWithFrame:CGRectMake(0, y, DEF_SCREEN_WIDTH, 580/3.0)];
    bottomBgView.backgroundColor = [UIColor whiteColor];
    bottomBgView.layer.borderColor = DEF_RGB_COLOR(214, 214, 217).CGColor;
    bottomBgView.layer.borderWidth = LINE_HEIGHT;
    [self.contentScrollView addSubview:bottomBgView];
    
    float vSpace = 68/3.0;
    float Y = vSpace;
    UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(12, Y, 85, 20)];
    timeLab.textColor = DEF_RGB_COLOR(111, 111, 111);
    timeLab.font = DEF_Font(18.0);
    timeLab.text = @"预约时间:";
    [bottomBgView addSubview:timeLab];
    float labWidth =  DEF_SCREEN_WIDTH - DEF_WIDTH(timeLab)-12;
    self.appointmentLab = [[UILabel alloc]initWithFrame:CGRectMake(DEF_RIGHT(timeLab), Y, labWidth, 20)];
    self.appointmentLab.textColor = DEF_RGB_COLOR(51, 51, 51);
    self.appointmentLab.font = DEF_Font(18.0);
    self.appointmentLab.text = @"2015年7月16日上午";
    self.appointmentLab.text = dict[@"created_at"];
    [bottomBgView addSubview:self.appointmentLab];

    
    Y += vSpace+20;
    UILabel *meetingLab = [[UILabel alloc]initWithFrame:CGRectMake(12, Y, 85, 20)];
    meetingLab.textColor = DEF_RGB_COLOR(111, 111, 111);
    meetingLab.font = DEF_Font(18.0);
    meetingLab.text = @"会面时间:";
    [bottomBgView addSubview:meetingLab];
    self.meetingDateLab = [[UILabel alloc]initWithFrame:CGRectMake(DEF_RIGHT(meetingLab), Y, labWidth, 20)];
    self.meetingDateLab.textColor = DEF_RGB_COLOR(51, 51, 51);
    self.meetingDateLab.font = DEF_Font(18.0);
    self.meetingDateLab.text = @"2015年7月17日";
    self.meetingDateLab.text = dict[@"meet_date"];
    [bottomBgView addSubview:self.meetingDateLab];

    Y += vSpace+20;
    UILabel *lawyerLab = [[UILabel alloc]initWithFrame:CGRectMake(12, Y, 120, 20)];
    lawyerLab.textColor = DEF_RGB_COLOR(111, 111, 111);
    lawyerLab.font = DEF_Font(18.0);
    lawyerLab.text = @"律师确认时间:";
    [bottomBgView addSubview:lawyerLab];
    float lawyerWidth =  DEF_SCREEN_WIDTH - DEF_WIDTH(lawyerLab)-12;
    self.lawyerConfirmLab = [[UILabel alloc]initWithFrame:CGRectMake(DEF_RIGHT(lawyerLab), Y, lawyerWidth, 20)];
    self.lawyerConfirmLab.textColor = DEF_RGB_COLOR(51, 51, 51);
    self.lawyerConfirmLab.font = DEF_Font(18.0);
    self.lawyerConfirmLab.text = @"7月21日 12:20:21";
    [bottomBgView addSubview:self.lawyerConfirmLab];
    
    Y += vSpace+20;
    UILabel *userLab = [[UILabel alloc]initWithFrame:CGRectMake(12, Y, 120, 20)];
    userLab.textColor = DEF_RGB_COLOR(111, 111, 111);
    userLab.font = DEF_Font(18.0);
    userLab.text = @"用户确认时间:";
    [bottomBgView addSubview:userLab];
    
    self.userConfirmLab = [[UILabel alloc]initWithFrame:CGRectMake(DEF_RIGHT(userLab), Y, lawyerWidth, 20)];
    self.userConfirmLab.textColor = DEF_RGB_COLOR(51, 51, 51);
    self.userConfirmLab.font = DEF_Font(18.0);
    self.userConfirmLab.text = @"7月22日 12:20:21";
    [bottomBgView addSubview:self.userConfirmLab];

    
    y += 580/3.0;
    self.contentScrollView.contentSize = CGSizeMake(DEF_SCREEN_WIDTH, y+10);
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
