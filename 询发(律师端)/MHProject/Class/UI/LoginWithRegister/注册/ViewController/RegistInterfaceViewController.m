//
//  RegistInterfaceViewController.m
//  MHProject
//
//  Created by 杜宾 on 15/8/5.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "RegistInterfaceViewController.h"
#import "PersonInfoViewController.h"
#import "RegisterViewController.h"
#define DEF_SpaceHeigh 20.0/736.0*DEF_SCREEN_HEIGHT

@interface RegistInterfaceViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *phoneTextField;
@property(nonatomic,strong)UITextField *verTextField;
@property(nonatomic,strong)UIButton    *codeBtn;
@property(nonatomic,strong)UIButton    *cysleButton;


@end

@implementation RegistInterfaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    [self initUI];
}
//导航栏
-(void)initNav
{
    [self showNavBarDefaultHUDByNavTitle:@"注册" inView:self.view isBack:YES];
}
// 创建视图
-(void)initUI
{
    //1、电话号码
    UIView *phoneBgView = [self getMyBgView:CGRectMake(12, 64+DEF_SpaceHeigh, DEF_SCREEN_WIDTH-24, 44)];
    phoneBgView.layer.cornerRadius = 2;
    phoneBgView.clipsToBounds = YES;
    [self.view addSubview:phoneBgView];
    //电话图片
    UIImageView *telImageView = [self getMyImageView:CGRectMake(7.5, 7.5, 30, 30) imageName:@"phonetelephone"];
    [phoneBgView addSubview:telImageView];
    //电话之后的线条
    UILabel *lineLB = [[UILabel alloc]initWithFrame:CGRectMake(DEF_RIGHT(telImageView)+7.5, 0,  DEF_SCREEN_WIDTH==320 ?0.5:1.0/3.0, DEF_HEIGHT(phoneBgView))];
    lineLB.backgroundColor = [UIColor lightGrayColor];
    [phoneBgView addSubview:lineLB];
    //电话输入框
    self.phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(DEF_RIGHT(lineLB)+10, 0, DEF_WIDTH(phoneBgView)-DEF_WIDTH(telImageView)-12.5-20, DEF_HEIGHT(phoneBgView))];
    self.phoneTextField.placeholder = @"请输入手机号码";
    self.phoneTextField.text = self.mobilNumberStr;
    self.phoneTextField.delegate = self;
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTextField.textColor = [UIColor blackColor];
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.phoneTextField setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    [self.phoneTextField setValue:DEF_RGB_COLOR(142, 142, 147) forKeyPath:@"_placeholderLabel.textColor"];
    [phoneBgView addSubview:self.phoneTextField];
    
    //
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(DEF_LEFT(phoneBgView), DEF_BOTTOM(phoneBgView), DEF_WIDTH(phoneBgView), 40)];
    [self.view addSubview:lab];
//    lab.backgroundColor = [UIColor redColor];
    lab.text = @"请使用您名片上的工作手机号码注册用户";
    lab.font = DEF_Font(16.0);
    lab.textColor = DEF_RGB_COLOR(142, 142, 147);
    
    //2、验证码相关
    //发送验证码的按钮
    self.codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.codeBtn .frame = CGRectMake(DEF_SCREEN_WIDTH-100-12, DEF_BOTTOM(phoneBgView)+44,100,DEF_HEIGHT(phoneBgView));
    self.codeBtn .layer.masksToBounds = YES;
    self.codeBtn .layer.cornerRadius = 3;
    [self.codeBtn  setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.codeBtn  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.codeBtn .backgroundColor = [UIColor orangeColor];
    self.codeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.codeBtn  addTarget:self action:@selector(codeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.codeBtn ];
    //输入验证码的View
    UIView *verificationView = [[UIView alloc]initWithFrame:CGRectMake(DEF_LEFT(phoneBgView), DEF_BOTTOM(phoneBgView) + 44,DEF_SCREEN_WIDTH-100-24-16, 44)];
    verificationView.layer.masksToBounds = YES;
    verificationView.layer.cornerRadius = 3;
    verificationView.layer.borderWidth =  DEF_SCREEN_WIDTH==320 ?0.5:1.0/3.0;
    verificationView.layer.borderColor = DEF_RGB_COLOR(214, 214, 217).CGColor;
    verificationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:verificationView];
    //
    self.verTextField = [[UITextField alloc]initWithFrame:CGRectMake(10 , 0, DEF_WIDTH(verificationView) ,DEF_HEIGHT(verificationView))];
//    [self.verTextField addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.verTextField.placeholder = @"请输入验证码";
    [self.verTextField setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    [self.verTextField setValue:DEF_RGB_COLOR(142, 142, 147) forKeyPath:@"_placeholderLabel.textColor"];
    self.verTextField.delegate = self;
    [verificationView addSubview:self.verTextField];
    
    //3、注册button
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(DEF_LEFT(phoneBgView), DEF_BOTTOM(verificationView) + DEF_SpaceHeigh, DEF_WIDTH(phoneBgView), 44);
    registerBtn.layer.masksToBounds = YES;
    registerBtn.layer.cornerRadius = 3;
    registerBtn.backgroundColor = DEF_RGB_COLOR(60, 153, 230);
    [registerBtn setTitle:@"开始注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.showsTouchWhenHighlighted = YES;
    [self.view addSubview:registerBtn];
    _cysleButton = registerBtn;

    //
    UIView *protocolView = [[UIView alloc]initWithFrame:CGRectMake((DEF_SCREEN_WIDTH - 235)/2, DEF_BOTTOM(registerBtn)+10, 235, 44)];
    [self.view addSubview:protocolView];
    
    UIButton *cycleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [protocolView addSubview:cycleBtn];
    cycleBtn.frame = CGRectMake(0, 0, 30, 44);
    [cycleBtn setImage:[UIImage imageNamed:@"not_selected"] forState:UIControlStateNormal];
    [cycleBtn setImage:[UIImage imageNamed:@"pitch_on"] forState:UIControlStateSelected];
    cycleBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cycleBtn addTarget:self action:@selector(cycleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cycleBtn.selected = YES;
    //    cycleBtn.backgroundColor = [UIColor redColor];
    
    UILabel *protocollable = [[UILabel alloc]initWithFrame:CGRectMake(DEF_RIGHT(cycleBtn), 0, 135, 44)];
    protocollable.text = @"我已经阅读并同意";
    protocollable.font = DEF_Font(16.0);
    protocollable.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    [protocolView addSubview:protocollable];
    //
    UIButton *protocolBtn = [[UIButton alloc]initWithFrame:CGRectMake(DEF_RIGHT(protocollable), 0, 70, 44)];
    [protocolBtn setTitle:@"服务声明" forState:UIControlStateNormal];
    protocolBtn.titleLabel.font = DEF_Font(16.0);
    [protocolBtn setTitleColor:[UIColor colorWithRed:0.11 green:0.65 blue:0.87 alpha:1] forState:UIControlStateNormal];
    protocolBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [protocolBtn addTarget:self action:@selector(protocolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [protocolView addSubview:protocolBtn];

}
- (void)returnClick
{
    [self.verTextField resignFirstResponder];
}
- (void) protocolBtnClick:(UIButton *)btn
{
    RegisterViewController *pro = [[RegisterViewController alloc]init];
    [self presentViewController:pro animated:YES completion:nil];
}

- (void) cycleBtnClick:(UIButton *)btn
{
    [self.view endEditing:YES];
    btn.selected = !btn.selected;
    
    if (btn.selected == NO)
    {
        self.cysleButton.enabled = NO;
        self.cysleButton.backgroundColor = [UIColor colorWithRed:0.92 green:0.93 blue:0.93 alpha:1];
        [self.cysleButton setTitleColor:[UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1] forState:UIControlStateNormal];
    }
    else
    {
        self.cysleButton.enabled = YES;
        self.cysleButton.backgroundColor = DEF_RGB_COLOR(61, 189, 244);
        [self.cysleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 集成View
-(UIView *)getMyBgView:(CGRect)frame
{
    UIView *bgView = [[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = DEF_RGB_COLOR(214, 214, 217).CGColor;
    bgView.layer.borderWidth = LINE_HEIGHT;
    return bgView;
}
-(UIImageView *)getMyImageView:(CGRect)frame
                     imageName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    imageView.frame = frame;
    imageView.contentMode =UIViewContentModeScaleAspectFit;
    return imageView;
}

//注册接口
-(void)registerBtnClick:(UIButton *)btn
{
    
    [self.view endEditing:YES];
//
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
        [MHAsiNetworkAPI checkRecodeWithMobile:self.phoneTextField.text recode:self.verTextField.text SuccessBlock:^(id returnData) {
            DEF_DEBUG(@"验证验证码返回数据%@",returnData);
            NSString *ret = returnData[@"ret"];
            NSString *msg = returnData[@"msg"];
            NSDictionary *data = returnData[@"data"];
            NSString *recodeStr =data[@"is_pass"];
            
            if ([ret isEqualToString:@"0"]&&[recodeStr isEqualToString:@"1"])
            {
                //保存手机号码
                DEF_PERSISTENT_SET_OBJECT(self.phoneTextField.text, DEF_LoginMobilPhone);
                
                PersonInfoViewController *personInfo = [[PersonInfoViewController alloc]init];
                personInfo.mobil = self.phoneTextField.text;
                personInfo.recode = self.verTextField.text;
                [self.navigationController pushViewController:personInfo animated:YES];
            }
            else
            {
                SHOW_ALERT(msg);
            }
        } failureBlock:^(NSError *error) {
        } showHUD:YES];
    }
//    PersonInfoViewController *personInfo = [[PersonInfoViewController alloc]init];
//            personInfo.mobil = self.phoneTextField.text;
//            personInfo.recode = self.verTextField.text;
//                    [self.navigationController pushViewController:personInfo animated:YES];
}

//获取验证码
-(void)codeBtnClick:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    if ([NSString isBlankString:self.phoneTextField.text])
    {
        SHOW_ALERT(@"亲，请输入您的电话号码");
    }
    else
    {
        [MHAsiNetworkAPI getRecodeWithMobile:self.phoneTextField.text SuccessBlock:^(id returnData) {
            DEF_DEBUG(@"获取 验证码返回数据%@",returnData);
            
            NSString *ret = returnData[@"ret"];
            NSString *msg = returnData[@"msg"];
//            NSDictionary *data = returnData[@"data"];
//            NSString *recodeStr =data[@"recode"];
            
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
        //
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
                [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                _codeBtn.backgroundColor = [UIColor orangeColor];
                
                [_codeBtn setEnabled:YES];
            });
        }
        else
        {
            NSString *strTime = [NSString stringWithFormat:@"倒计时 : %i s",timeout];
            
            dispatch_async(dispatch_get_main_queue()
                           , ^{
                               [_codeBtn setTitle:strTime forState:UIControlStateNormal];
                               _codeBtn.backgroundColor = [UIColor grayColor];
                               _codeBtn.titleLabel.font = DEF_Font(16.0);
                           });
            timeout--;
        }
    });
    dispatch_resume(_time);
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
