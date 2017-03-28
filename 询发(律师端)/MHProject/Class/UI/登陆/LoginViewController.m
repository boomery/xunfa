//
//  LoginViewController.m
//  MHProject
//
//  Created by 杜宾 on 15/6/15.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "MyViewController.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置背景的视图
    UIImageView * bgImageView= [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgImageView.image =[UIImage imageNamed:@"p2_1登录（1）.png"];
    [self.view addSubview:bgImageView];

    [self addView];
    
}
- (void)addView
{
    
    CGFloat userTFx =self.view.bounds.size.width*(50.0/320);
    CGFloat userTFy =self.view.bounds.size.height*(220.0/568);
    CGFloat userTFWidth =self.view.bounds.size.width*(240.0/320);
    CGFloat userTFHeight =self.view.bounds.size.height*(30.0/568);
    //输入账户
    UITextField * userTF =[[UITextField alloc]initWithFrame:CGRectMake(userTFx,userTFy , userTFWidth, userTFHeight)];
    userTF.textColor =[UIColor whiteColor];
    //    userTF.placeholder =@"请填写账号";
    userTF.borderStyle =UITextBorderStyleNone;
    userTF.keyboardType=UIKeyboardTypeDefault;
    [userTF addTarget:self action:@selector(downKeyBoard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:userTF];
    
    //输入密码
    UITextField * passWordTF =[[UITextField alloc]initWithFrame:CGRectMake(userTF.frame.origin.x, userTF.frame.origin.y+2*userTFHeight, userTFWidth, userTFHeight)];
    passWordTF.textColor =[UIColor whiteColor];
    //userTF.placeholder =@"请填写密码";
    passWordTF.borderStyle =UITextBorderStyleNone;
    passWordTF.keyboardType=UIKeyboardTypeDefault;
    [passWordTF addTarget:self action:@selector(downKeyBoard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:passWordTF];
    
    //登陆
    CGFloat loginBtnx =self.view.bounds.size.width*(10.0/320);
    CGFloat loginBtny =passWordTF.frame.origin.y+userTFHeight+self.view.bounds.size.height*(34.0/568);
    CGFloat loginBtnWidth =self.view.bounds.size.width*(300.0/320);
    CGFloat loginBtnHeight =self.view.bounds.size.height*(40.0/568);
    UIButton *loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame =CGRectMake(loginBtnx,loginBtny,loginBtnWidth,loginBtnHeight);
    [loginBtn setExclusiveTouch:YES];
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    //下方注册和忘记密码
    CGFloat registerBtnx =self.view.bounds.size.width*(90.0/320);
    CGFloat registerBtny =self.view.frame.size.height-self.view.frame.size.height*(35.0/568);
    CGFloat registerBtnWidth =self.view.bounds.size.width*(70.0/320);
    CGFloat registerBtnHeight =self.view.bounds.size.height*(30.0/568);
    //注册
    UIButton *registerBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame =CGRectMake(registerBtnx,registerBtny,registerBtnWidth, registerBtnHeight);
    [registerBtn setExclusiveTouch:YES];
    [registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:registerBtn];
    
    
    //忘记密码
    UIButton *forggetPasswordBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    forggetPasswordBtn.frame =CGRectMake(registerBtn.frame.origin.x+registerBtnWidth+self.view.bounds.size.width*(10.0/320), registerBtn.frame.origin.y, registerBtnWidth, registerBtnHeight);
    [forggetPasswordBtn setExclusiveTouch:YES];
    [forggetPasswordBtn addTarget:self action:@selector(forggetPasswordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forggetPasswordBtn];
    
    
//    userTF.backgroundColor =[UIColor redColor];
//    passWordTF.backgroundColor =[UIColor redColor];
//    loginBtn.backgroundColor =[UIColor redColor];
//    registerBtn.backgroundColor =[UIColor redColor];
//    forggetPasswordBtn.backgroundColor =[UIColor redColor];
}

//登录事件
-(void)loginBtnClick:(UIButton *)btn
{

#warning 暂时不判断
    [[NSUserDefaults standardUserDefaults]setObject:@"login" forKey:@"login"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[AppDelegate appDelegate]addLoginVC];
        
    });

    
}

//注册按钮
-(void)registerBtnClick:(UIButton *)btn
{
    
    RegisterViewController *regist = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:regist animated:YES];
    
    
}
- (void)downKeyBoard:(UITextField *)sender
{
    [sender resignFirstResponder];
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
