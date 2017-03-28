//
//  PersonInfoViewController.m
//  MHProject
//
//  Created by 杜宾 on 15/6/19.
//  Copyright (c) 2015年 杜宾. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "MHKeyboard.h"
#import "LoginViewController.h"
#import "UploadPhotoViewController.h"

@interface PersonInfoViewController ()<UIActionSheetDelegate, UITextFieldDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) UITextField *loginPasswordTF; //设置登录密码
@property (nonatomic,strong) UITextField *RepeatTF; //重复密码
@property (nonatomic,strong) UITextField *nameTF; //姓名
@property (nonatomic,strong) UITextField *appellationTF; //称谓
@property (nonatomic,strong) UITextField *emailTF; //邮箱


@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    
    [self initUI];
}
-(void)initNav
{
    //    导航栏
    [self showNavBarDefaultHUDByNavTitle:@"个人信息" inView:self.view isBack:YES];
}

-(void)initUI
{
    
    [self creatContScrollView];
    self.contentScrollView.contentSize = CGSizeMake(DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT-54);
//
    UIView *loginView = [[UIView alloc]initWithFrame:CGRectMake(0,0, DEF_SCREEN_WIDTH, 51)];
    [self.contentScrollView addSubview:loginView];
    loginView.layer.borderWidth = 0.5;
    loginView.layer.borderColor = DEF_RGB_COLOR(214, 214, 217).CGColor;
    loginView.backgroundColor = [UIColor whiteColor];
    self.loginPasswordTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, DEF_SCREEN_WIDTH - 15, 51)];
    self.loginPasswordTF.placeholder = @"设置您的登录密码";
    [self.loginPasswordTF setValue:DEF_RGB_COLOR(100, 99, 105) forKeyPath:@"_placeholderLabel.textColor"];
    self.loginPasswordTF.delegate = self;
    self.loginPasswordTF.secureTextEntry = YES;
    [loginView addSubview:self.loginPasswordTF];
    
    //
    UIView *passwordView = [[UIView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(loginView), DEF_SCREEN_WIDTH, 51)];
    [self.contentScrollView addSubview:passwordView];
    passwordView.layer.borderWidth = 0.5;
    passwordView.layer.borderColor = DEF_RGB_COLOR(214, 214, 217).CGColor;
    passwordView.backgroundColor = [UIColor whiteColor];
    self.RepeatTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, DEF_SCREEN_WIDTH - 15, 51)];
    self.RepeatTF.placeholder = @"重复密码";
    self.RepeatTF.secureTextEntry = YES;
    self.RepeatTF.delegate = self;
    [self.RepeatTF setValue:DEF_RGB_COLOR(100, 99, 105) forKeyPath:@"_placeholderLabel.textColor"];
    [passwordView addSubview:self.RepeatTF];
    
    //
    UIView *nameView = [[UIView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(passwordView)+20, DEF_SCREEN_WIDTH, 51)];
    [self.contentScrollView addSubview:nameView];
    nameView.layer.borderWidth = 0.5;
    nameView.layer.borderColor = DEF_RGB_COLOR(214, 214, 217).CGColor;
    nameView.backgroundColor = [UIColor whiteColor];
    self.nameTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, DEF_SCREEN_WIDTH - 15, 51)];
    self.nameTF.placeholder = @"姓名（务必填写你的真实姓名）";
    self.nameTF.delegate = self;
    [self.nameTF setValue:DEF_RGB_COLOR(100, 99, 105) forKeyPath:@"_placeholderLabel.textColor"];
    [nameView addSubview:self.nameTF];

    //
    UIView *titlesView = [[UIView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(nameView), DEF_SCREEN_WIDTH, 51)];
    [self.contentScrollView addSubview:titlesView];
    titlesView.layer.borderWidth = 0.5;
    titlesView.layer.borderColor = DEF_RGB_COLOR(214, 214, 217).CGColor;
    titlesView.backgroundColor = [UIColor whiteColor];
    self.appellationTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, DEF_SCREEN_WIDTH - 15, 51)];
    self.appellationTF.delegate = self;
    self.appellationTF.placeholder = @"身份证号(务必填写正确)";
    [self.appellationTF setValue:DEF_RGB_COLOR(100, 99, 105) forKeyPath:@"_placeholderLabel.textColor"];
    [titlesView addSubview:self.appellationTF];
    //
    UIView *emailView = [[UIView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(titlesView), DEF_SCREEN_WIDTH, 51)];
    [self.contentScrollView addSubview:emailView];
    emailView.layer.borderWidth = 0.5;
    emailView.layer.borderColor = DEF_RGB_COLOR(214, 214, 217).CGColor;
    emailView.backgroundColor = [UIColor whiteColor];
    self.emailTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, DEF_SCREEN_WIDTH - 15, 51)];
    self.emailTF.placeholder = @"律师执业证号(务必填写正确)";
    [self.emailTF setValue:DEF_RGB_COLOR(100, 99, 105) forKeyPath:@"_placeholderLabel.textColor"];
    self.emailTF.keyboardType = UIKeyboardTypePhonePad;
    self.emailTF.delegate = self;
    [emailView addSubview:self.emailTF];
//   确认按钮
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(10, DEF_BOTTOM(emailView)+16, DEF_SCREEN_WIDTH - 20, 50);
    [confirmBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.layer.cornerRadius = 3;
    confirmBtn.backgroundColor = DEF_RGB_COLOR(60, 153, 230);
    confirmBtn.showsTouchWhenHighlighted = YES;
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentScrollView addSubview:confirmBtn];
    
//    监听键盘
    [MHKeyboard addRegisterTheViewNeedMHKeyboard:self.contentScrollView];
    self.contentScrollView.delegate = self;
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.contentScrollView endEditing:YES];
}
#pragma mark - UITableViewDetagate

-(void)confirmBtnClick:(UIButton *)sender
{
    if ([NSString isBlankString:self.loginPasswordTF.text])
    {
        SHOW_ALERT(@"亲，请输入您的密码");
    }
    else if (self.loginPasswordTF.text.length<=5)
    {
        SHOW_ALERT(@"亲，请输入至少6位的密码");
    }
    else if ([NSString isBlankString:self.RepeatTF.text])
    {
        SHOW_ALERT(@"亲，请输入您的确认密码");
    }
    else if (![self.loginPasswordTF.text isEqualToString:self.RepeatTF.text])
    {
        SHOW_ALERT(@"亲，两次密码输入不一致");
    }
    else if ([NSString isBlankString:self.nameTF.text])
    {
        SHOW_ALERT(@"亲，您的名字不能为空");
    }
    else if (![CMManager validateIdentityCard:self.appellationTF.text])
    {
        SHOW_ALERT(@"亲，身份证号不正确");
        
    }
    else if ([NSString isBlankString:self.emailTF.text])
    {
        SHOW_ALERT(@"亲，您的律师执业证号不能为空");
    }
    else if ([self.emailTF.text length] < 17)
    {
        SHOW_ALERT(@"亲，您的律师执业证号不正确");
    }
    else
    {
        [MHAsiNetworkAPI lawyerRegisterWithMobile:self.mobil
                                           recode:self.recode
                                                 password:self.loginPasswordTF.text
                                             name:self.nameTF.text
                                        id_number:self.appellationTF.text
                                   lawyer_license:self.emailTF.text
                                     SuccessBlock:^(id returnData) {
                                         DEF_DEBUG(@"%@",returnData);
                                         NSString *ret = returnData[@"ret"];
                                         NSString *msg = returnData[@"msg"];
                                         NSDictionary *data = returnData[@"data"];
                                         if ([ret isEqualToString:@"0"])
                                         {
                                             DEF_PERSISTENT_SET_OBJECT(self.loginPasswordTF.text, DEF_LoginPassWord);

                                                 UploadPhotoViewController *upload = [[UploadPhotoViewController alloc]init];
                                             upload.lawyerId = data[@"lawyer_id"];
                                             upload.token = data[@"token"];
                                                 [self.navigationController pushViewController:upload animated:YES];
                                         }
                                         else
                                         {
                                             SHOW_ALERT(msg);
                                         }
                                         

                                         } failureBlock:^(NSError *error) {
                                             
                                         } showHUD:NO];
    }

//    UploadPhotoViewController *upload = [[UploadPhotoViewController alloc]init];
//    [self.navigationController pushViewController:upload animated:YES];
////
}
#pragma mark - UITextFieldDelegate
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
