//
//  WithdrawApplyForViewController.m
//  MHProject
//
//  Created by 张好志 on 15/7/21.
//  Copyright (c) 2015年 Andy. All rights reserved.
//
#define FieldHeight 44
#define SpaceHeight 20

#import "WithdrawApplyForViewController.h"
#import "HZUtil.h"
#import "WithdrawSettingViewController.h"

@interface WithdrawApplyForViewController ()<UITextFieldDelegate>


@end

@implementation WithdrawApplyForViewController
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
- (void)viewDidLoad {
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
    [self showNavBarWithTwoBtnHUDByNavTitle:@"提现申请" leftImage:@"menu-left-back" leftTitle:@"" rightImage:@"" rightTitle:@"修改账号" inView:self.view isBack:YES];
}

-(void)initUIWithMoneyAccountDict:(NSDictionary*)dict
{
    float x = 12;
    float y = 64+SpaceHeight;
    //
    self.nameTF = [[QLeftLabelTextField alloc] initWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-24 , FieldHeight)];
    self.nameTF.leftLbl.text = @"姓       名";
    self.nameTF.leftLbl.textColor = DEF_RGB_COLOR(149, 149, 149);
    self.nameTF.leftLbl.font = [UIFont systemFontOfSize:16];
    self.nameTF.rightField.textColor = DEF_RGB_COLOR(149, 149, 149);
    self.nameTF.rightField.font = [UIFont systemFontOfSize:16];
    NSString *nameStr = dict[@"name"];
//    NSString *newName = [nameStr substringToIndex:nameStr.length-2];
    self.nameTF.rightField.placeholder = nameStr ;
    self.nameTF.rightField.delegate= self;
    self.nameTF.rightImageBtn.hidden = YES;
    self.nameTF.canEdit = NO;
    [self.view addSubview:self.nameTF];
    
    //
    y+= FieldHeight+SpaceHeight;
    self.payAccountNumberTF = [[QLeftLabelTextField alloc] initWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-24 , FieldHeight)];
    self.payAccountNumberTF.leftLbl.textColor = DEF_RGB_COLOR(149, 149, 149);
    self.payAccountNumberTF.leftLbl.font = [UIFont systemFontOfSize:16];
    self.payAccountNumberTF.rightField.textColor = DEF_RGB_COLOR(149, 149, 149);
    self.payAccountNumberTF.rightField.font = [UIFont systemFontOfSize:16];
    self.payAccountNumberTF.leftLbl.text = @"账       号";
    self.payAccountNumberTF.rightField.text = dict[@"account"];
    self.payAccountNumberTF.canEdit = NO;
    self.payAccountNumberTF.rightImageBtn.hidden = YES;
    [self.view addSubview:self.payAccountNumberTF];
    
    y+= FieldHeight+SpaceHeight;
    //
    NSString *pointNumberCount = dict[@"total_dot"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"可提取积点：%@ 点",pointNumberCount]];
    [str addAttribute:NSForegroundColorAttributeName value:DEF_RGB_COLOR(255, 113,53) range:NSMakeRange(6,pointNumberCount.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(6, pointNumberCount.length)];
    [str addAttribute:NSForegroundColorAttributeName value:DEF_RGB_COLOR(159, 159, 159) range:NSMakeRange(str.length-1,1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.5] range:NSMakeRange(str.length-1, 1)];
    //
    UILabel *explainLB = [[UILabel alloc]initWithFrame:CGRectMake(x+10, y, DEF_SCREEN_WIDTH-30, 22)];
    explainLB.textAlignment = NSTextAlignmentLeft;
    explainLB.textColor = DEF_RGB_COLOR(159, 159, 159);
    explainLB.numberOfLines = 0;
    explainLB.font = [UIFont systemFontOfSize:16];
    explainLB.attributedText = str;
    [self.view addSubview:explainLB];
    
    y= DEF_BOTTOM(explainLB)+12;
    self.pointTF = [[QLeftLabelTextField alloc] initWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-24 , FieldHeight)];
    self.pointTF.leftLbl.textColor = [UIColor blackColor];
    self.pointTF.leftLbl.font = [UIFont systemFontOfSize:16];
    self.pointTF.rightField.textColor = DEF_RGB_COLOR(110, 110, 110);
    self.pointTF.rightField.font = [UIFont systemFontOfSize:16];
    self.pointTF.leftLbl.text = @"积       点";
    self.pointTF.rightField.placeholder = @"请输入积点数量";
    self.pointTF.rightField.keyboardType = UIKeyboardTypeNumberPad;
    self.pointTF.rightField.text = @"";
    self.pointTF.canEdit = YES;
    self.pointTF.rightField.delegate = self;
    self.pointTF.rightImageBtn.hidden = YES;
    [self.view addSubview:self.pointTF];
    
    y= DEF_BOTTOM(self.pointTF)+16;
    UILabel *tipLB = [[UILabel alloc]initWithFrame:CGRectMake(22, y, DEF_SCREEN_WIDTH-44, FieldHeight)];
    tipLB.textAlignment = NSTextAlignmentLeft;
    tipLB.textColor = DEF_RGB_COLOR(159, 159, 159);
    tipLB.numberOfLines = 0;
    tipLB.font = [UIFont systemFontOfSize:13.5];
    tipLB.text = @"我们会在*日将您的积点折现给您。\n折现比例为 “1个积点兑换壹圆人民币”";
    [self.view addSubview:tipLB];

    y= DEF_BOTTOM(tipLB)+40;
    UIButton *commitAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitAccountBtn.showsTouchWhenHighlighted = YES;
    commitAccountBtn.frame =CGRectMake(x,y,DEF_SCREEN_WIDTH-24, 44);
//    [commitAccountBtn setTitle:@"保存账户" forState:UIControlStateNormal];
    [commitAccountBtn setTitle:@"确定" forState:UIControlStateNormal];
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
    [MobClick event:@"LawCashGet_Submit"];

    //1、设置参数
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = DEF_API_dot_to_moneyApply;
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    if ([NSString isBlankString:self.pointTF.rightField.text])
    {
        SHOW_ALERT(@"请输入提现积点");
    }
    else
    {
        //2、发起请求
        [MHAsiNetworkAPI applyForDotToMoneyWithuid:uid timestamp:timeStamp sign:sign dot_num:self.pointTF.rightField.text amount:self.pointTF.rightField.text account:self.payAccountNumberTF.rightField.text SuccessBlock:^(id returnData) {
            DEF_DEBUG(@"提现申请接口返回的数据：%@",returnData);
            NSString *ret = returnData[@"ret"];
            NSString *msg = returnData[@"msg"];
            if ([ret intValue]==0)
            {
                SHOW_ALERT(@"提现申请成功");
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
-(void)rightNavItemClick
{
    [MobClick event:@"LawCashGet_Setup"];
    WithdrawSettingViewController *vc =[[WithdrawSettingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 点击事件
- (void)leftNavItemClick
{
    [MobClick event:@"LawCashGet_Back"];
    [self.navigationController popViewControllerAnimated:YES];
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
