//
//  RegisterViewController.m
//  MHProject
//
//  Created by 杜宾 on 15/6/17.
//  Copyright (c) 2015年 杜宾. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIPlaceHolderTextView.h"
#import "RegistInterfaceViewController.h"
@interface RegisterViewController ()<UIWebViewDelegate>
{
    
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    [self initData];
    
    [self initNav];
}
//数据
-(void)initData
{
    [MHAsiNetworkAPI registerAgreementWithSuccessBlock:^(id returnData)
     {
         DEF_DEBUG(@"注册协议接口返回的数据：%@",returnData);
         NSString *ret = returnData[@"ret"];
         NSString *msg = returnData[@"msg"];
         if ([ret isEqualToString:@"0"])
         {
             NSDictionary *dataDict =returnData[@"data"];
             NSString *content =dataDict[@"url"];
             [self initUIWithUrl:content];
         }
         else
         {
             SHOW_ALERT(msg);
         }

     } failureBlock:^(NSError *error) {
     } showHUD:YES];
}

//导航栏
-(void)initNav
{
    [self showNavBarWithTwoBtnHUDByNavTitle:@"询法律师的服务条款" rightTitle:@"关闭" inView:self.view isBack:NO];

}

-(void)initUIWithUrl:(NSString*)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - 64)];
    [self.view addSubview:webview];
    webview.scalesPageToFit = YES;
    webview.delegate = self;
    webview.scalesPageToFit = YES;
    webview.backgroundColor = [UIColor clearColor];
    webview.paginationMode =UIWebPaginationModeUnpaginated;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [webview loadRequest:request];
    [self.view addSubview:webview];
    
}
// 导航栏左按钮 点击, 子类重写这个方法
- (void)rightNavItemClick
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [DataHander showDlg];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [DataHander hideDlg];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [DataHander hideDlg];
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
