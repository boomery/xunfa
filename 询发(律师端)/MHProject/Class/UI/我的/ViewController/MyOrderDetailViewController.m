//
//  MyOrderDetailViewController.m
//  MHProject
//
//  Created by 张好志 on 15/8/24.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "MyOrderDetailViewController.h"
#import "OrderInfoView.h"
#import "CustomDatePickerView.h"
#import "MyOrderViewController.h"

@interface MyOrderDetailViewController ()<MyCustomDatePickerViewDelegate>

@property(nonatomic,strong)UIScrollView *myInfoScrollView;
@property(nonatomic,strong)OrderInfoView   *orderNumberView;//预约单编号
@property(nonatomic,strong)OrderInfoView   *orderLawyerView;//预约律师
@property(nonatomic,strong)OrderInfoView   *orderPhoneNumberView;//律师电话
@property(nonatomic,strong)OrderInfoView   *meetPersonView;//约见人
@property(nonatomic,strong)OrderInfoView   *meetPhoneNumberView;//联系电话
@property(nonatomic,strong)OrderInfoView   *meetTimeView;//时间
@property(nonatomic,strong)OrderInfoView   *predictMoneyView;//预计收费

@property(nonatomic,strong)UIButton     *evaluateLawyerBtn;//评价律师服务
@property(nonatomic,strong)UIButton     *platformHelpBtn;//平台帮助
@property(nonatomic,strong)UIButton     *cancleMeetingBtn;//取消约见
@property(nonatomic,strong)NSArray *timeHourArr;//日期选择器
@property(nonatomic,strong)NSString *hourStr;//选择整点

@property(nonatomic,strong)NSDictionary *allDataDict;//选择整点

@property(nonatomic,strong)CustomDatePickerView *myDatePickerView;

@property(nonatomic,strong)UIView *mengBanView;

@end

@implementation MyOrderDetailViewController

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

#pragma mark -- viewLifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initData];
    
    [self initNav];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        //
    DEF_DEBUG(@"订单id：%@",self.orderID);
}


#pragma mark -- 初始化
-(void)initNav
{
    [self showNavBarDefaultHUDByNavTitle:@"我的预约单" inView:self.view isBack:YES];
}
- (void)leftNavItemClick
{
    //    [MobClick event:@"MyFav_Back"];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initData
{
//    时间
    self.timeHourArr = [[NSArray alloc]initWithObjects:@"1:00",@"2:00",@"3:00",@"4:00",@"5:00",@"6:00",@"7:00",@"8:00",@"9:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00",@"24:00",nil];

    [self getOrderDetailByHttpRequestWithOrderID:self.orderID];
}
-(void)initUIWithOrderDetailDict:(NSDictionary *)dict
{
    self.allDataDict = dict;
    
    /*
     "coupon_amount" = 0;
     "coupon_id" = 0;
     "lawyer_id" = 13;
     "lawyer_mobile" = 15136123242;
     "lawyer_name" = "\U5f20\U597d\U5fd7";
     "meet_date" = "2015-9-20 14:00 - 16";
     "meet_date_is_mod" = 0;
     "meet_price" = 200;
     "pay_type" = "\U652f\U4ed8\U5b9d\U652f\U4ed8";
     state = "\U5df2\U652f\U4ed8";

     
     "pay_amount" = 0;
     "created_at" = "08-27 10:42";
     "user_id" = 1;
     "user_mobile" = 18516111573;
     "user_name" = "\U5c0f\U4e0d\U61c2";
     */
    
    if (self.contentScrollView){
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
    float width = 172.0/3.0;
    
    self.orderNumberView = [[OrderInfoView alloc]initWithFrame:CGRectMake(0, y, DEF_SCREEN_WIDTH, width)];
    self.orderNumberView.myInfoLeft.text= @"预约单编号";
    self.orderNumberView.myInfoRight.text= self.orderID;
    [self.contentScrollView addSubview:self.orderNumberView];
    
    y += width;
    self.orderLawyerView = [[OrderInfoView alloc]initWithFrame:CGRectMake(0, y, DEF_SCREEN_WIDTH, width)];
    self.orderLawyerView.myInfoLeft.text= @"预约人";
    self.orderLawyerView.myInfoRight.text= dict[@"user_name"];
    [self.contentScrollView addSubview:self.orderLawyerView];

    y += width;
    self.orderPhoneNumberView = [[OrderInfoView alloc]initWithFrame:CGRectMake(0, y, DEF_SCREEN_WIDTH, width)];
    self.orderPhoneNumberView.myInfoLeft.text= @"联系电话";
    [self.orderPhoneNumberView.myInfoRight autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.orderPhoneNumberView withOffset:-50];
    self.orderPhoneNumberView.myInfoRight.text= dict[@"user_mobile"];
    if (DEF_SCREEN_WIDTH==320) {
        //在5和4下可以显示完全
        self.orderPhoneNumberView.myInfoRight.textAlignment= 0;
    }
    [self.contentScrollView addSubview:self.orderPhoneNumberView];
    UIButton *telBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    telBtn.frame = CGRectMake(DEF_SCREEN_WIDTH-47, ((width)-35)/2.0, 35, 35);
    [telBtn setBackgroundImage:[UIImage imageNamed:@"install_green_phone"] forState:UIControlStateNormal];
    telBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [telBtn addTarget:self action:@selector(telBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.orderPhoneNumberView addSubview:telBtn];
    
    y += width;
    self.meetTimeView = [[OrderInfoView alloc]initWithFrame:CGRectMake(0, y, DEF_SCREEN_WIDTH, width)];
    [self.meetTimeView.myInfoRight autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.meetTimeView withOffset:-50];
    self.meetTimeView.myInfoLeft.text= @"时间";
    self.meetTimeView.myInfoRight.text=dict[@"created_at"];//@"7月16日上午";
    [self.contentScrollView addSubview:self.meetTimeView];
    
    UIButton *dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dateBtn.frame = CGRectMake(DEF_SCREEN_WIDTH-47, ((width)-35)/2.0, 35, 35);
    [dateBtn setBackgroundImage:[UIImage imageNamed:@"la_blue_day"] forState:UIControlStateNormal];
    dateBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [dateBtn addTarget:self action:@selector(dateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.meetTimeView addSubview:dateBtn];
//    dateBtn.backgroundColor = [UIColor redColor];

    y += width;
    self.predictMoneyView = [[OrderInfoView alloc]initWithFrame:CGRectMake(0, y, DEF_SCREEN_WIDTH, width)];
    self.predictMoneyView.myInfoLeft.text= @"已付费";
    self.predictMoneyView.myInfoRight.text = [NSString stringWithFormat:@"%@元",dict[@"pay_amount"]];
    self.predictMoneyView.myInfoRight.textColor = DEF_RGB_COLOR(255, 84, 46);
    [self.contentScrollView addSubview:self.predictMoneyView];
//    NSString *predictMoneyStr = [NSString stringWithFormat:@"%@",dict[@"pay_amount"]];//@"200元/小时";
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",predictMoneyStr]];
//    [str addAttribute:NSForegroundColorAttributeName value:DEF_RGB_COLOR(255, 84, 46) range:NSMakeRange(0,3)];
//    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 3)];
//    self.predictMoneyView.myInfoRight.attributedText = str;
    
    y += width+20;
    float height;
    if (DEF_SCREEN_WIDTH == 320.0){
        height = 40;
    }else{
        height = 50;
    }
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, y, DEF_SCREEN_WIDTH-24, height)];
    tipLabel.numberOfLines = 0;
    tipLabel.textColor = DEF_RGB_COLOR(100, 99, 105);
    if (DEF_SCREEN_WIDTH == 320.0){
        tipLabel.font = [UIFont systemFontOfSize:10];
    }else if(DEF_SCREEN_IS_6){
        tipLabel.font = [UIFont systemFontOfSize:12.5];
    }else{
        tipLabel.font = [UIFont systemFontOfSize:14];
    }
    tipLabel.text = @"温馨提示：请您及时电话联系客户确认约见时间和所需资料。\n                 以便你们的见面更有效，祝您的业务拓展顺利。";
    [self.contentScrollView addSubview:tipLabel];
    
    
    //创建下方的按钮(如果律师确认约见后，确认约见按钮改为灰色的不可点击状态)
    y += width+260/3.0;
    //
    self.evaluateLawyerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.evaluateLawyerBtn.frame = CGRectMake(12,y , (DEF_SCREEN_WIDTH-36)/2.0, 44);
    self.evaluateLawyerBtn.backgroundColor = DEF_RGB_COLOR(73, 156, 227);
    self.evaluateLawyerBtn.layer.cornerRadius = 5;
    self.evaluateLawyerBtn.clipsToBounds = YES;
    [self.evaluateLawyerBtn setTitle:@"确认约见" forState:UIControlStateNormal];
    [self.evaluateLawyerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.evaluateLawyerBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [self.evaluateLawyerBtn addTarget:self action:@selector(evaluateLawyerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentScrollView addSubview:self.evaluateLawyerBtn];
    //
    self.platformHelpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.platformHelpBtn.frame = CGRectMake(self.evaluateLawyerBtn.frame.size.width+24,y , (DEF_SCREEN_WIDTH-36)/2.0, 44);
    self.platformHelpBtn.backgroundColor = DEF_RGB_COLOR(73, 156, 227);
    self.platformHelpBtn.layer.cornerRadius = 5;
    self.platformHelpBtn.clipsToBounds = YES;
    [self.platformHelpBtn setTitle:@"取消约见" forState:UIControlStateNormal];
    [self.platformHelpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.platformHelpBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [self.platformHelpBtn addTarget:self action:@selector(platformHelpBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentScrollView addSubview:self.platformHelpBtn];

    //
    self.contentScrollView.contentSize = CGSizeMake(DEF_SCREEN_WIDTH, y+50);
}

#pragma mark -- 按钮点击事件
//打电话
-(void)telBtnClick:(UIButton *)sender
{
    [self tellSomeOneWithPhoneNumber:@"4008590918"];
}
-(void)dateBtnClick:(UIButton *)btn
{
    self.mengBanView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self.mengBanView addGestureRecognizer:tap];
    
    
    self.mengBanView.backgroundColor = [UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:0.5];
    [self.view addSubview:self.mengBanView];
    
    if (!self.myDatePickerView) {
        self.myDatePickerView = [[CustomDatePickerView alloc]initWithDelegate:self];
    }
    self.myDatePickerView.frame = CGRectMake(0, DEF_SCREEN_HEIGHT -200 , DEF_SCREEN_WIDTH, 200);
    self.myDatePickerView.timeArr = self.timeHourArr;
    self.myDatePickerView.hourStr = self.hourStr;
    [self.myDatePickerView.pickerView selectRow:[self.hourStr intValue] inComponent:0 animated:YES];

    [self.mengBanView addSubview:self.myDatePickerView];
    
}
-(void)tapClick
{
    [self.mengBanView removeFromSuperview];
}
//打电话
-(void)tellSomeOneWithPhoneNumber:(NSString*)phone
{
    UIWebView*callWebview =[[UIWebView alloc] init];
    
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",phone];
    
    NSURL *telURL =[NSURL URLWithString:telUrl];// 貌似tel:// 或者 tel: 都行
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    //记得添加到view上
    [self.view addSubview:callWebview];
}


//取消约见
-(void)cancleMeetingBtnClick:(UIButton *)sender
{
    DEF_DEBUG(@"取消约见");
    
}
//评价律师
-(void)evaluateLawyerBtnClick:(UIButton *)sender
{
    DEF_DEBUG(@"%@",self.allDataDict);
    DEF_DEBUG(@"确认约见");
    
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",DEF_API_Get_f2fOrder,self.orderID];
    
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    NSString *coupon_id = self.allDataDict[@"coupon_id"];
NSString *coupon_amount = self.allDataDict[@"coupon_amount"];
     NSString *pay_type = self.allDataDict[@"pay_type"];
   NSString *pay_amount = self.allDataDict[@"pay_amount"];
    NSString *meet_date = self.allDataDict[@"meet_date"];
        NSString *state = self.allDataDict[@"state"];

    

    [MHAsiNetworkAPI changeOrderWithuid:uid
                              timestamp:timeStamp
                                   sign:sign
                                orderID:self.orderID
                              coupon_id:coupon_id
                          coupon_amount:coupon_amount
                               pay_type:pay_type
                             pay_amount:pay_amount
                              meet_date:meet_date
                                  state:state SuccessBlock:^(id returnData) {
                                      NSString *ret = returnData[@"ret"];
                                      
                                      NSString *msg = returnData[@"msg"];
                                      
                                      //        给界面赋值
                                      
                                      if ([ret intValue] == 0)
                                          
                                      {
                                          
                                          if (self.ReloadDataBlock)
                                          {
                                              self.ReloadDataBlock();
                                           }
                                          self.evaluateLawyerBtn.enabled = NO;
                                          self.evaluateLawyerBtn.backgroundColor = [UIColor grayColor];
                                          NSArray *arrayVC =self.navigationController.viewControllers;
                                          for (UIViewController *VC in arrayVC)
                                          {
                                              if ([VC isKindOfClass:[MyOrderViewController class]])
                                              {
                                               
                                                  MyOrderViewController *orderVC= (MyOrderViewController *)VC;
                                                  [self.navigationController popToViewController:orderVC animated:YES];
                                                  
                                              }
                                          }
                                          
                                          
                                      }
                                      
                                      else{
                                          
                                          SHOW_ALERT(msg);
                                          
                                      }
                                      

    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];

    
    
    
    
}
//平台帮助
-(void)platformHelpBtnClick:(UIButton *)sender
{
    DEF_DEBUG(@"平台帮助");
    [self tellSomeOneWithPhoneNumber:@"4008590918"];
}
#pragma MyCustomDatePickerDelegate
// 选择日期
-(void)selectDatepicke:(CustomDatePickerView *)picker
{
    //    结束编辑
    [self.mengBanView removeFromSuperview];
    //    回到底部 不用每次删除再创建
    
    NSDate *date=[picker.datePicker date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyy-MM-dd";
    NSString *timeStr=[formatter stringFromDate:date];
    if (picker.hourStr.length == 0)
    {
        self.meetTimeView.myInfoRight.text = [NSString stringWithFormat:@"%@ %@",timeStr,@"1:00"];
    }
    else
    {
         self.meetTimeView.myInfoRight.text = [NSString stringWithFormat:@"%@ %@",timeStr,picker.hourStr];
    }
}
//选择与律师沟通后确认的
-(void)selectLawyerCorfirm:(CustomDatePickerView *)datePick
{
    //    [self.dateView.rightField resignFirstResponder];
    //
    //    self.dateView.rightField.text = @"";
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
