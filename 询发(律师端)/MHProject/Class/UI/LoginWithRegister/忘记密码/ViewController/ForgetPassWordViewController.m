//
//  ForgetPassWordViewController.m
//  MHProject
//
//  Created by 张好志 on 15/6/19.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "ForgetPassWordViewController.h"
#import "ResetPassWordViewController.h"

@interface ForgetPassWordViewController () <UITextFieldDelegate>
{
    UIImageView *lineImageView;
    UIImageView *telePhonImage;
    UIButton *codeBtn;
}
@property (nonatomic,strong) UITextField *phoneTextField;
@property (nonatomic,strong) UITextField *verTextField;

@end

@implementation ForgetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    
    [self initUI];
}
#pragma mark -- 初始化导航条
- (void)initNav
{
    [self showNavBarDefaultHUDByNavTitle:@"忘记密码" inView:self.view isBack:YES];

//    [self addLeftNavBarBtnByImg:@"menu-left-back" andWithText:@""];
//    [self addNavBarTitle:@"忘记密码"];
}
// 创建视图
-(void)initUI
{
    //1、输入手机号的View
    UIView *phoneView = [[UIView alloc]initWithFrame:CGRectMake(11, 16+64, DEF_SCREEN_WIDTH - 22, 44)];
    [self addViewWith:phoneView WithImage:[UIImage imageNamed:@"phone-teleph"]];
    [self.view addSubview:phoneView];
    //
    self.phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(DEF_RIGHT(lineImageView) +10 , 0, DEF_WIDTH(phoneView) - DEF_WIDTH(telePhonImage) ,DEF_HEIGHT(phoneView))];
    self.phoneTextField.placeholder = @"请输入手机号";
    [self.phoneTextField setValue:DEF_RGB_COLOR(100, 99, 105) forKeyPath:@"_placeholderLabel.textColor"];
    self.phoneTextField.text =self.phoneStr;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [phoneView addSubview:self.phoneTextField];
    
    //2、输入验证码的View
    UIView *verificationView = [[UIView alloc]initWithFrame:CGRectMake(11, DEF_BOTTOM(phoneView) + 20, 195.0/320*DEF_SCREEN_WIDTH, 44)];
    verificationView.layer.masksToBounds = YES;
    verificationView.layer.cornerRadius = 3;
    verificationView.layer.borderWidth = 1;
    verificationView.layer.borderColor = DEF_RGB_COLOR(214, 214, 217).CGColor;
    verificationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:verificationView];
    //
    self.verTextField = [[UITextField alloc]initWithFrame:CGRectMake(10 , 0, DEF_WIDTH(verificationView) ,DEF_HEIGHT(verificationView))];
    self.verTextField.placeholder = @"请输入验证码";
    self.verTextField.delegate = self;
    [self.verTextField setValue:DEF_RGB_COLOR(100, 99, 105) forKeyPath:@"_placeholderLabel.textColor"];
    [verificationView addSubview:self.verTextField];
    
    //发送验证码的按钮
    codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    codeBtn.frame = CGRectMake(DEF_RIGHT(verificationView) + 26, DEF_TOP(verificationView), DEF_SCREEN_WIDTH-DEF_WIDTH(verificationView)-DEF_LEFT(verificationView)-36, DEF_HEIGHT(verificationView));
    codeBtn.layer.masksToBounds = YES;
    codeBtn.layer.cornerRadius = 3;
    [codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (DEF_SCREEN_WIDTH==320) {
        codeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }else{
        codeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    }
    codeBtn.backgroundColor = DEF_RGB_COLOR(253, 114, 63);
    [codeBtn addTarget:self action:@selector(codeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:codeBtn];
    
    //3、注册button
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(DEF_LEFT(phoneView), DEF_BOTTOM(verificationView) + 20, DEF_WIDTH(phoneView), 44);
    registerBtn.layer.masksToBounds = YES;
    registerBtn.layer.cornerRadius = 3;
    registerBtn.backgroundColor = [UIColor colorWithRed:0.25 green:0.61 blue:0.89 alpha:1];
    [registerBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.showsTouchWhenHighlighted = YES;
    [self.view addSubview:registerBtn];
}

#pragma mark - 按钮点击事件
//下一步
-(void)registerBtnClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if ([NSString isBlankString:self.phoneTextField.text])
    {
        SHOW_ALERT(@"亲，请输入您的电话号码");
    }
    else if ([NSString isBlankString:self.verTextField.text])
    {
        SHOW_ALERT(@"请输入验证码");
    }
    else
    {
        //
        [MHAsiNetworkAPI checkRecodeWithMobile:self.phoneTextField.text
                                        recode:self.verTextField.text
                                  SuccessBlock:^(id returnData)
         {
             DEF_DEBUG(@"验证验证码返回数据%@",returnData);
             
             NSString *ret = returnData[@"ret"];
             //            NSString *msg = returnData[@"msg"];
             NSDictionary *data = returnData[@"data"];
             NSString *recodeStr =data[@"is_pass"];
             
             if ([ret isEqualToString:@"0"]&&[recodeStr isEqualToString:@"1"])
             {
                 ResetPassWordViewController *resetPassWord = [[ResetPassWordViewController alloc]init];
                 resetPassWord.phoneStr = self.phoneTextField.text;
                 resetPassWord.recodeStr = self.verTextField.text;
                 [self.navigationController pushViewController:resetPassWord animated:YES];
             }
             else
             {
                 SHOW_ALERT(@"验证码不正确");
             }
             
         } failureBlock:^(NSError *error) {
         } showHUD:NO];
    }
    
}
//获取验证码
-(void)codeBtnClick:(UIButton *)btn
{
    if ([NSString isBlankString:self.phoneTextField.text])
    {
        SHOW_ALERT(@"亲，请输入您的电话号码");
    }
    else
    {
        //
        [MHAsiNetworkAPI getForgetRecodeWithMobile:self.phoneTextField.text SuccessBlock:^(id returnData) {
            DEF_DEBUG(@"获取 验证码返回数据%@",returnData);
            
            NSString *ret = returnData[@"ret"];
            NSString *msg = returnData[@"msg"];
            if ([ret isEqualToString:@"0"])
            {
                SHOW_ALERT(@"验证码发送成功，请注意查收");
            }
            else
            {
                SHOW_ALERT(msg);
            }
        } failureBlock:^(NSError *error) {
            
        } showHUD:YES];
        [btn setEnabled:NO];
        [self countDownByTimeout:30];
    }
}

//获取倒计时时间
-(void)countDownByTimeout:(int)timeNum
{
    //    倒计时时间
    __block int timeout = timeNum;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //    每秒执行
    dispatch_source_set_timer(_time, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_time, ^{
        if (timeout <= 0)
        {
            //            倒计时结束，关闭
            dispatch_source_cancel(_time);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //                设置界面的按钮显示，根据自己的需求设置
                [codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                codeBtn.backgroundColor = [UIColor orangeColor];
                
                [codeBtn setEnabled:YES];
            });
        }
        else
        {
            NSString *strTime = [NSString stringWithFormat:@"倒计时:%i s",timeout];
            
            dispatch_async(dispatch_get_main_queue()
                           , ^{
                               [codeBtn setTitle:strTime forState:UIControlStateNormal];
                               codeBtn.backgroundColor = [UIColor colorWithRed:0.79 green:0.79 blue:0.79 alpha:1];
                               if (DEF_SCREEN_WIDTH==320) {
                                   codeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                               }else{
                                   codeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
                               }
                               
                           });
            timeout--;
        }
    });
    dispatch_resume(_time);
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
    telePhonImage.frame = CGRectMake(7.5, 7.7, 30, 30);
    [view addSubview:telePhonImage];
    

    //边上的横线
    lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake([telePhonImage right] + 7.5, 0, LINE_HEIGHT, [view height])];
    lineImageView.backgroundColor = DEF_RGB_COLOR(234, 234, 234);
    [view addSubview:lineImageView];
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
