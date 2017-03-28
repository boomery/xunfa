//
//  ResetPassWordViewController.m
//  MHProject
//
//  Created by 杜宾 on 15/6/27.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "ResetPassWordViewController.h"
#import "LoginViewController.h"

@interface ResetPassWordViewController ()<UITextFieldDelegate>
{
    UIImageView *lineImageView;
    UIImageView *telePhonImage;
}
@property (nonatomic,strong) UITextField *phoneTextField;
@property (nonatomic,strong) UITextField *passWordViewField;
@property (nonatomic,strong) UITextField *confirmPassWordField;

@end

@implementation ResetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    
    [self initUI];
}
#pragma mark -- 初始化导航条
- (void)initNav
{
    [self showNavBarDefaultHUDByNavTitle:@"重置密码" inView:self.view isBack:YES];

//    [self addNavBarTitle:@"重置密码"];
//    [self addLeftNavBarBtnByImg:@"menu-left-back" andWithText:@""];
}
-(void)initUI
{
    //
    float vHeight = 16;//竖间距
    float height = 44;//高
    float width =  DEF_SCREEN_WIDTH - 22;//宽
    float hX = 11;//X
    
    //电话
    UIView *phoneView = [[UIView alloc]initWithFrame:CGRectMake(hX, vHeight+64, width, height)];
    [self addViewWith:phoneView WithImage:[UIImage imageNamed:@"phone-teleph"]];
    [self.view addSubview:phoneView];
    self.phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(DEF_RIGHT(lineImageView) +10 , 0, DEF_WIDTH(phoneView) - DEF_WIDTH(telePhonImage) ,DEF_HEIGHT(phoneView))];
    self.phoneTextField .text = self.phoneStr;
    self.phoneTextField.userInteractionEnabled = NO;
    [self.phoneTextField  setValue:DEF_RGB_COLOR(100, 99, 105) forKeyPath:@"_placeholderLabel.textColor"];
    self.phoneTextField.delegate = self;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [phoneView addSubview:self.phoneTextField ];
    
    //设置密码
    UIView *passWordView = [[UIView alloc]initWithFrame:CGRectMake(hX, DEF_BOTTOM(phoneView) + vHeight, width, height)];
    [self addViewWith:passWordView WithImage:[UIImage imageNamed:@"key-key"]];
    [self.view addSubview:passWordView];
    self.passWordViewField = [[UITextField alloc]initWithFrame:CGRectMake(DEF_RIGHT(lineImageView) +10 , 0, DEF_WIDTH(phoneView) - DEF_WIDTH(telePhonImage) ,DEF_HEIGHT(phoneView))];
    self.passWordViewField .placeholder = @"请输入密码";
    [self.passWordViewField  setValue:DEF_RGB_COLOR(100, 99, 105) forKeyPath:@"_placeholderLabel.textColor"];
    self.passWordViewField.secureTextEntry = YES;
    self.passWordViewField.delegate = self;
    self.passWordViewField .keyboardType = UIKeyboardTypeDefault;
    [passWordView addSubview:self.passWordViewField ];
    
    //确认密码
    UIView *confirmPassWordView = [[UIView alloc]initWithFrame:CGRectMake(hX, DEF_BOTTOM(passWordView) + vHeight, width, height)];
    [self addViewWith:confirmPassWordView WithImage:[UIImage imageNamed:@"key-key"]];
    [self.view addSubview:confirmPassWordView];
    self.confirmPassWordField = [[UITextField alloc]initWithFrame:CGRectMake(DEF_RIGHT(lineImageView) +10 , 0, DEF_WIDTH(phoneView) - DEF_WIDTH(telePhonImage) ,DEF_HEIGHT(phoneView))];
    self.confirmPassWordField .placeholder = @"新密码确认";
    [self.confirmPassWordField  setValue:DEF_RGB_COLOR(100, 99, 105) forKeyPath:@"_placeholderLabel.textColor"];
    self.confirmPassWordField.secureTextEntry = YES;
    self.confirmPassWordField.delegate = self;
    self.confirmPassWordField .keyboardType = UIKeyboardTypeDefault;
    [confirmPassWordView addSubview:self.confirmPassWordField ];
    
    //3、注册button
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(DEF_LEFT(phoneView), DEF_BOTTOM(confirmPassWordView) + 20, DEF_WIDTH(phoneView), 44);
    registerBtn.layer.masksToBounds = YES;
    registerBtn.layer.cornerRadius = 3;
    registerBtn.backgroundColor = [UIColor colorWithRed:0.25 green:0.61 blue:0.89 alpha:1];
    [registerBtn setTitle:@"确定" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(conformBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.showsTouchWhenHighlighted = YES;
    [self.view addSubview:registerBtn];
}
#pragma mark --集成视图
// 添加图标和图片
-(void)addViewWith:(UIView *)view WithImage:(UIImage *)image
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 3;
    view.layer.borderWidth = 1;
    view.layer.borderColor = DEF_RGB_COLOR(214, 214, 217).CGColor;
    view.backgroundColor = [UIColor whiteColor];
    
    //电话图标
    telePhonImage = [[UIImageView alloc]initWithImage:image];
    telePhonImage.frame = CGRectMake(7.5, 7.5, 30, 30);
    [view addSubview:telePhonImage];
    

    //边上的横线
    lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake([telePhonImage right] + 10, 0, LINE_HEIGHT, [view height])];
    lineImageView.backgroundColor = DEF_RGB_COLOR(234, 234, 234);
    [view addSubview:lineImageView];
}

-(void)conformBtnClick:(UIButton *)btn
{
    if ([NSString isBlankString:self.phoneTextField.text])
    {
        SHOW_ALERT(@"亲，请输入您的电话号码");
    }
    else if ([NSString isBlankString:self.passWordViewField.text])
    {
        SHOW_ALERT(@"亲，请输入您的密码");
    }
    else if (self.passWordViewField.text.length<=5)
    {
        SHOW_ALERT(@"亲，请输入至少6位的密码");
    }
    else if ([NSString isBlankString:self.confirmPassWordField.text])
    {
        SHOW_ALERT(@"亲，请输入您的确认密码");
    }
    else if (![self.passWordViewField.text isEqualToString:self.confirmPassWordField.text])
    {
        SHOW_ALERT(@"亲，两次密码输入不一致");
    }
    else
    {
        [MHAsiNetworkAPI changePassWordWithMobile:self.phoneTextField.text
                                           recode:self.recodeStr
                                         password:self.passWordViewField.text
                                     SuccessBlock:^(id returnData)
         {
             DEF_DEBUG(@"修改密码借口返回的数据%@",returnData);
             
             NSString *ret = returnData[@"ret"];
             NSString *msg = returnData[@"msg"];
             if ([ret isEqualToString:@"0"])
             {
                 NSArray *vcArray = self.navigationController.childViewControllers;
                 for (UIViewController *vc in vcArray)
                 {
                     if ([vc isKindOfClass: [LoginViewController class]])
                     {
                         LoginViewController *loginVC= (LoginViewController *)vc;
                         loginVC.telPhoneTF.text = self.phoneTextField.text;
                         loginVC.passWordPhoneTF.text = self.passWordViewField.text;
                         //    密码设置成功则跳到登陆界面，使用新密码登陆
                         [self.navigationController popToViewController:loginVC animated:YES];
                     }
                 }
             }
             else
             {
                 SHOW_ALERT(msg);
             }
         } failureBlock:^(NSError *error) {
         } showHUD:NO];
    }
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
