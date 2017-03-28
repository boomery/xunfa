//
//  WithdrawSettingViewController.m
//  MHProject
//
//  Created by 张好志 on 15/7/21.
//  Copyright (c) 2015年 Andy. All rights reserved.
//
#define FieldHeight 44
#define SpaceHeight 20.0


#import "WithdrawSettingViewController.h"

@interface WithdrawSettingViewController ()<UITextFieldDelegate,UIAlertViewDelegate>

@end

@implementation WithdrawSettingViewController

#pragma mark -- 网络请求相关
-(void)getMoneyAccountInfo
{
    //1、设置参数
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = DEF_API_MyDotMoneyAccount;
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    [MHAsiNetworkAPI getMoneyAccountInfoByuid:uid timestamp:timeStamp sign:sign SuccessBlock:^(id returnData) {
        DEF_DEBUG(@"获取提现的支付宝账户信息返回的数据:%@",returnData);
        NSString *ret = returnData[@"ret"];
        NSString *msg = returnData[@"msg"];
        if ([ret intValue]==0)
        {
            NSDictionary *moneyAccountDict = returnData[@"data"];
            
            [self initUIWithMoneyAccountDict:moneyAccountDict];
        }
        else
        {
            SHOW_ALERT(msg);
        }
    } failureBlock:^(NSError *error) {
    } showHUD:YES];
}

#pragma mark -- ViewlifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNav];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMoneyAccountInfo];
}
#pragma mark --初始化
-(void)initNav
{
    [self showNavBarDefaultHUDByNavTitle:@"提现设置" inView:self.view isBack:YES];
}
#pragma mark - 点击事件
- (void)leftNavItemClick
{
    [MobClick event:@"LawCashSetup_Back"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initUIWithMoneyAccountDict:(NSDictionary *)dict
{
    float x = 12;
    float y = 64+15.0;
    
    UILabel *tipPayLB = [[UILabel alloc]initWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-24, 22)];
    tipPayLB.textAlignment = NSTextAlignmentLeft;
    tipPayLB.textColor = DEF_RGB_COLOR(51, 51, 51);
    tipPayLB.numberOfLines = 0;
    if (DEF_SCREEN_WIDTH==320) {
        tipPayLB.font = [UIFont systemFontOfSize:16];
    }else{
        tipPayLB.font = [UIFont systemFontOfSize:18];
    }
    tipPayLB.text = @"为兑现积点，请提供您的支付宝账号”";
    tipPayLB.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipPayLB];
    
    y =DEF_BOTTOM(tipPayLB)+22.0;
    //
    self.nameTF = [[QLeftLabelTextField alloc] initWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-24 , FieldHeight)];
    self.nameTF.leftLbl.text = @"姓       名";
    self.nameTF.leftLbl.textColor = DEF_RGB_COLOR(159, 159, 159);
    self.nameTF.leftLbl.font = [UIFont systemFontOfSize:16];
    self.nameTF.rightField.textColor = DEF_RGB_COLOR(159, 159, 159);
    self.nameTF.rightField.font = [UIFont systemFontOfSize:16];
    NSString *nameStr = dict[@"name"];
//    NSString *newName = [nameStr substringToIndex:nameStr.length-2];
    self.nameTF.rightField.placeholder = nameStr;
    self.nameTF.rightField.delegate= self;
    self.nameTF.rightImageBtn.hidden = YES;
    self.nameTF.canEdit = NO;
    [self.view addSubview:self.nameTF];
    
    //
    y+= FieldHeight+SpaceHeight;
    self.payAccountNumberTF = [[QLeftLabelTextField alloc] initWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-24 , FieldHeight)];
    self.payAccountNumberTF.leftLbl.textColor = DEF_RGB_COLOR(51, 51, 51);
    self.payAccountNumberTF.leftLbl.font = [UIFont systemFontOfSize:16];
    self.payAccountNumberTF.rightField.textColor = DEF_RGB_COLOR(111, 111, 111);
    self.payAccountNumberTF.rightField.font = [UIFont systemFontOfSize:16];
    self.payAccountNumberTF.leftLbl.text = @"账       号";
    self.payAccountNumberTF.rightField.text = dict[@"account"];
    self.payAccountNumberTF.rightField.placeholder = @"请输入您的支付宝账户";
    self.payAccountNumberTF.canEdit = YES;
    self.payAccountNumberTF.rightField.delegate = self;
    self.payAccountNumberTF.rightImageBtn.hidden = YES;
    [self.view addSubview:self.payAccountNumberTF];
    
    y+= FieldHeight+SpaceHeight;
    UILabel *explainLB = [[UILabel alloc]initWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-24, 44)];
    explainLB.textAlignment = NSTextAlignmentLeft;
    explainLB.textColor = DEF_RGB_COLOR(159, 159, 159);
    explainLB.numberOfLines = 2;
    explainLB.font = [UIFont systemFontOfSize:16];
    explainLB.text = @"说明：必须使用您实名注册的支付宝账号。";
    explainLB.backgroundColor = [UIColor clearColor];
    [self.view addSubview:explainLB];
    
    y= DEF_BOTTOM(explainLB)+40;
    UIButton *commitAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitAccountBtn.showsTouchWhenHighlighted = YES;
    commitAccountBtn.frame =CGRectMake(x,y,DEF_SCREEN_WIDTH-24, 44);
    [commitAccountBtn setTitle:@"提交账户" forState:UIControlStateNormal];
    commitAccountBtn.backgroundColor =DEF_RGB_COLOR(60, 153, 230);
    commitAccountBtn.layer.cornerRadius = 3;
    commitAccountBtn.clipsToBounds = YES;
    [commitAccountBtn setExclusiveTouch:YES];
    commitAccountBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [commitAccountBtn addTarget:self action:@selector(commitAccountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitAccountBtn];
}

#pragma mark -- 按钮点击事件
//提交账户
-(void)commitAccountBtnClick:(UIButton *)sender
{
    [MobClick event:@"LawCashSetup_Submit"];

    //
    [self.view endEditing:YES];
    if ([NSString isBlankString:self.payAccountNumberTF.rightField.text])
    {
        SHOW_ALERT(@"亲，请输入您的支付宝账户");
    }
    else
    {
        NSString *attentionStr = [NSString stringWithFormat:@"您确定要使用%@该支付宝账户吗？",self.payAccountNumberTF.rightField.text];
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:attentionStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        //1、设置参数
        NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
        NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
        NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
        NSString *url = DEF_API_MyDotMoneyAccount;
        NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
        
        [MHAsiNetworkAPI settingMoneyAccountByuid:uid timestamp:timeStamp sign:sign account:self.payAccountNumberTF.rightField.text SuccessBlock:^(id returnData)
         {
             DEF_DEBUG(@"提现账户的设置接口返回的数据：%@",returnData);
             NSString *ret = returnData[@"ret"];
             NSString *msg = returnData[@"msg"];
             if ([ret intValue]==0)
             {
                 SHOW_ALERT(@"兑现账户设置成功");
                 DEF_PERSISTENT_SET_OBJECT(@"提现设置账户成功", DEF_ApplyForMoney);
                 [self.navigationController popViewControllerAnimated:YES];
             }
             else
             {
                 SHOW_ALERT(msg);
             }
         } failureBlock:^(NSError *error) {
             
         } showHUD:YES];
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
