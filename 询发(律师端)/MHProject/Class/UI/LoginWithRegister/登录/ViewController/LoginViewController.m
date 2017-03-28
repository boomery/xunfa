//
//  LoginViewController.m
//  MHProject
//
//  Created by 张好志 on 15/6/15.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "MyViewController.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "MHKeyboard.h"
#import "ForgetPassWordViewController.h"
#import "CMManager.h"
#import "TSRegularExpressionUtil.h"
#import "RegistInterfaceViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    self.navigationController.navigationBarHidden = YES;
    
    [self initNav];

    [self initUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *mobile = DEF_PERSISTENT_GET_OBJECT(DEF_LoginMobilPhone);
    NSString *passWord = DEF_PERSISTENT_GET_OBJECT(DEF_LoginPassWord);
    self.telPhoneTF.text = mobile;
    self.passWordPhoneTF.text = passWord;
}
#pragma mark -- 初始化导航条
- (void)initNav
{
    [self showNavBarWithTwoBtnHUDByNavTitle:@"登录" rightTitle:@"忘记密码" inView:self.view isBack:NO];
}
#pragma mark -- 初始化界面
- (void)initUI
{
    //1、电话号码
    UIView *phoneBgView = [self getMyBgView:CGRectMake(10, 15+64, DEF_SCREEN_WIDTH-20, 45)];
    phoneBgView.layer.cornerRadius = 2;
    phoneBgView.clipsToBounds = YES;
    [self.view addSubview:phoneBgView];
    //
    UIImageView *telImageView = [self getMyImageView:CGRectMake(7.5, 7.5, 30, 30) imageName:@"phone-teleph"];
    telImageView.contentMode =UIViewContentModeScaleAspectFit;
    [phoneBgView addSubview:telImageView];
    
    UILabel *lineLB = [[UILabel alloc]initWithFrame:CGRectMake(DEF_RIGHT(telImageView)+7.5, 0, LINE_HEIGHT, DEF_HEIGHT(phoneBgView))];
    lineLB.backgroundColor = DEF_RGB_COLOR(228, 228, 228);
    [phoneBgView addSubview:lineLB];
    //
    self.telPhoneTF = [[UITextField alloc] initWithFrame:CGRectMake(DEF_RIGHT(lineLB)+10, 0, DEF_WIDTH(phoneBgView)-DEF_WIDTH(telImageView)-12.5-20, DEF_HEIGHT(phoneBgView))];
    self.telPhoneTF.placeholder = @"请输入手机号码";
//    self.telPhoneTF.text = @"18516111573";
    self.telPhoneTF.textColor = [UIColor blackColor];
    self.telPhoneTF.keyboardType = UIKeyboardTypeNumberPad;
    if (DEF_640_960)
    {
        [self.telPhoneTF setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    }
    [self.telPhoneTF setValue:DEF_RGB_COLOR(111, 111, 111) forKeyPath:@"_placeholderLabel.textColor"];
    [phoneBgView addSubview:self.telPhoneTF];
    
    //2、密码
    UIView *passWordBgView = [self getMyBgView:CGRectMake(DEF_LEFT(phoneBgView),DEF_BOTTOM(phoneBgView)+10, DEF_SCREEN_WIDTH-20, 45)];
    phoneBgView.layer.cornerRadius = 3;
    phoneBgView.clipsToBounds = YES;
    [self.view addSubview:passWordBgView];
    //
    UIImageView *passWordImageView = [self getMyImageView:CGRectMake(7.5, 7.5, 30, 30) imageName:@"key-key"];
    telImageView.contentMode =UIViewContentModeScaleAspectFit;
    [passWordBgView addSubview:passWordImageView];
    //
    UILabel *passWordlineLB = [[UILabel alloc]initWithFrame:CGRectMake(DEF_RIGHT(passWordImageView)+7.5, 0, LINE_HEIGHT, DEF_HEIGHT(passWordBgView))];
    passWordlineLB.backgroundColor =  DEF_RGB_COLOR(228, 228, 228);
    [passWordBgView addSubview:passWordlineLB];
    //
    self.passWordPhoneTF = [[UITextField alloc] initWithFrame:CGRectMake(DEF_RIGHT(passWordlineLB)+10, 0, DEF_WIDTH(passWordBgView)-DEF_WIDTH(passWordImageView)-7.5-20, DEF_HEIGHT(passWordBgView))];
    self.passWordPhoneTF.placeholder = @"密码";
    self.passWordPhoneTF.textColor = [UIColor blackColor];
    self.passWordPhoneTF.keyboardType = UIKeyboardTypeDefault;
    if (DEF_640_960)
    {
        [self.passWordPhoneTF setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    }
    [self.passWordPhoneTF setValue:DEF_RGB_COLOR(111, 111, 111) forKeyPath:@"_placeholderLabel.textColor"];
    self.passWordPhoneTF.secureTextEntry  = YES;
    [passWordBgView addSubview:self.passWordPhoneTF];
//    self.passWordPhoneTF.text = @"123456";
    //登录
    UIButton *loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame =CGRectMake(DEF_LEFT(phoneBgView),DEF_BOTTOM(passWordBgView)+10,DEF_WIDTH(phoneBgView),DEF_HEIGHT(phoneBgView));
    [loginBtn setExclusiveTouch:YES];
    loginBtn.backgroundColor =DEF_RGB_COLOR(60, 153, 230);
    loginBtn.layer.cornerRadius = 3;
    loginBtn.clipsToBounds = YES;
    loginBtn.showsTouchWhenHighlighted = YES;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    //注册
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.showsTouchWhenHighlighted = YES;
    registerBtn.frame =CGRectMake(DEF_LEFT(loginBtn),DEF_BOTTOM(loginBtn)+10,DEF_WIDTH(loginBtn), DEF_HEIGHT(loginBtn));
    [registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    registerBtn.backgroundColor =DEF_RGB_COLOR(255, 113, 53);
    registerBtn.layer.cornerRadius = 3;
    registerBtn.clipsToBounds = YES;
    [registerBtn setExclusiveTouch:YES];
    [registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
}

#pragma mark -- 登录事件
-(void)loginBtnClick:(UIButton *)btn
{
    [self.view endEditing:YES];
    if ([NSString isBlankString:self.telPhoneTF.text])
    {
        SHOW_ALERT(@"请输入电话号码");
    }
    else if ([NSString isBlankString:self.passWordPhoneTF.text])
    {
        SHOW_ALERT(@"亲，请输入您的密码");
    }
    else if (self.passWordPhoneTF.text.length<=5)
    {
        SHOW_ALERT(@"亲，请输入至少6位的密码");
    }
    else
    {
        //
        [MHAsiNetworkAPI loginWithMobile:self.telPhoneTF.text password:self.passWordPhoneTF.text SuccessBlock:^(id returnData) {
            DEF_DEBUG(@"登录接口返回数据%@",returnData);
            
            NSString *ret = returnData[@"ret"];
            NSString *msg = returnData[@"msg"];
            if ([ret isEqualToString:@"0"])
            {
                NSDictionary *data = returnData[@"data"];
                NSString *token = data[@"token"];
                NSString *user_id =[NSString stringWithFormat:@"%@", data[@"user_id"]];
                
                
                //1、保存用户id和token
                DEF_PERSISTENT_SET_OBJECT(token,DEF_loginToken);
                DEF_PERSISTENT_SET_OBJECT(user_id, DEF_UserID);
                
                //2、将从苹果推送服务器获得deviceToken传给服务器
                NSString *newDeviceToken=DEF_PERSISTENT_GET_OBJECT(DEF_Device_token);
                [self postPushInfoToServerByHttpRequestWithDeviceToken:newDeviceToken];
            }
            else
            {
                SHOW_ALERT(msg);
            }
        } failureBlock:^(NSError *error) {
            NSLog(@"description:%@",error.description);
        } showHUD:YES];
    }
}

#pragma mark -- 注册事件
-(void)registerBtnClick:(UIButton *)btn
{
    [self.view endEditing:YES];
    RegistInterfaceViewController *regist = [[RegistInterfaceViewController alloc]init];
    regist.mobilNumberStr = self.telPhoneTF.text;
    [self.navigationController pushViewController:regist animated:YES];
}

#pragma mark -- 导航条按钮点击事件
- (void)leftNavItemClick
{
    [self.view endEditing:YES];
//    [MHKeyboard removeRegisterTheViewNeedMHKeyboard];
    [AppDelegate appDelegate].window.rootViewController = nil;
}
 -(void)rightNavItemClick
{
    [self.view endEditing:YES];
    ForgetPassWordViewController *vc =[[ForgetPassWordViewController alloc]init];
    vc.phoneStr = self.telPhoneTF.text;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)postPushInfoToServerByHttpRequestWithDeviceToken:(NSString *)deviceToken
{
    //显示版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];// app名称
    NSString *app_Name = @"询法-律师版";
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];// app版本
    
    [MHAsiNetworkAPI pushToServerWithApp_name:app_Name
                                  app_version:app_Version
                                   device_uid:DEF_PERSISTENT_GET_OBJECT(DEF_UUID)
                                 device_token:deviceToken
                                 SuccessBlock:^(id returnData)
     {
         DEF_DEBUG(@"推送信息接口返回数据%@",returnData);
         
         NSString *ret = returnData[@"ret"];
         NSString *msg = returnData[@"msg"];
         //         NSDictionary *data = returnData[@"data"];
         //给界面赋值
         if ([ret isEqualToString:@"0"])
         {
             //3、切换主界面
             [[AppDelegate appDelegate] changeMainController];
         }
         else
         {
             SHOW_ALERT(msg);
         }
         
     } failureBlock:^(NSError *error) {
         
     } showHUD:NO];
}

#pragma mark - 集成View
-(UIView *)getMyBgView:(CGRect)frame
{
    UIView *bgView = [[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = DEF_RGB_COLOR(214, 214, 217).CGColor;
    bgView.layer.borderWidth = 1;
    return bgView;
}
-(UIImageView *)getMyImageView:(CGRect)frame
                     imageName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    imageView.frame = frame;
    imageView.contentMode =  UIViewContentModeScaleAspectFit;
    return imageView;
}
#pragma mark -- UITextFieldDelegate
// 结束编辑的时候下键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
