//
//  FeedBackViewController.m
//  MHProject
//
//  Created by 张好志 on 15/6/30.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "FeedBackViewController.h"
#import "UIPlaceHolderTextView.h"

@interface FeedBackViewController () <UITextViewDelegate>

@property (nonatomic, strong) UIPlaceHolderTextView *suggestionTextView;

@end

@implementation FeedBackViewController

#pragma mark -- http网络请求相关
-(void)postMyIssuesToServer
{
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = DEF_API_FeedBackIssues;
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];

    //显示版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];// app版本
    NSString *appVersionString = [NSString stringWithFormat:@"iOS询法-律师版%@",app_Version];
    
    [DataHander showDlg];
    [MHAsiNetworkAPI feedBackIssuesWithuid:uid
                                 timestamp:timeStamp
                                      sign:sign
                               app_version:appVersionString
                                   content:self.suggestionTextView.text
                              SuccessBlock:^(id returnData)
     {
         DEF_DEBUG(@"反馈意见接口返回的数据：%@",returnData);
         
         NSString *ret = returnData[@"ret"];
         NSString *msg = returnData[@"msg"];
         if ([ret isEqualToString:@"0"]) {
             [DataHander showSuccessWithTitle:@"提交成功" completionBlock:^{
                 [self.navigationController popViewControllerAnimated:YES];
             }];
         }
         else
         {
             [DataHander hideDlg];
             SHOW_ALERT(msg);
         }
    } failureBlock:^(NSError *error) {
    } showHUD:NO];
}

#pragma mark -- view LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    
    [self initUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
#pragma mark --初始化
-(void)initNav
{
    [self showNavBarWithTwoBtnHUDByNavTitle:@"意见反馈" leftImage:@"menu-left-back" leftTitle:@"" rightImage:@"" rightTitle:@"保存" inView:self.view isBack:YES];
}

-(void)initUI
{
    UILabel  *newsLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 74, DEF_SCREEN_WIDTH-20, 20)];
    newsLB.text = @"您的意见对我们进步很重要(4-200字)";
    newsLB.textColor = DEF_RGB_COLOR(100, 99, 105);
    newsLB.font = DEF_Font(13.5);
    [self.view addSubview:newsLB];
    
    self.suggestionTextView = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(10, DEF_BOTTOM(newsLB)+10, DEF_SCREEN_WIDTH-20,225)];
    self.suggestionTextView.tag = 200;
    self.suggestionTextView.font        = [UIFont systemFontOfSize:13.5];
    self.suggestionTextView.textColor   = [UIColor blackColor];
    self.suggestionTextView.placeholder =@" 在此输入你的问题描述";
    self.suggestionTextView.placeholderColor = DEF_RGB_COLOR(142, 142, 147);
    self.suggestionTextView.delegate    = self;
    self.suggestionTextView.layer.cornerRadius = 5;
    self.suggestionTextView.clipsToBounds = YES;
    self.suggestionTextView.layer.borderColor = DEF_RGB_COLOR(214, 213, 218).CGColor;
    self.suggestionTextView.layer.borderWidth = LINE_HEIGHT;
;
    [self.view addSubview:self.suggestionTextView];}

#pragma mark -- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *toBeString = textView.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > textView.tag) {
                textView.text = [toBeString substringToIndex:textView.tag];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > textView.tag) {
            textView.text = [toBeString substringToIndex:textView.tag];
        }
    }
}
#pragma mark -- 导航条右侧按钮点击事件
-(void)rightNavItemClick
{
    //
    [self.view endEditing:YES];
    
    //发送请求
    if ([NSString isBlankString:self.suggestionTextView.text]) {
        SHOW_ALERT(@"亲，请输入您的意见");
    }
    else if (self.suggestionTextView.text.length >=4)
    {
        [self postMyIssuesToServer];
    }
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
