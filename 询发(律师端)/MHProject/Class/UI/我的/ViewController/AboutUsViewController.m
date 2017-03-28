//
//  AboutUsViewController.m
//  MHProject
//
//  Created by 张好志 on 15/7/17.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "AboutUsViewController.h"
@interface AboutUsViewController ()<UIWebViewDelegate>

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];

    [self initData];
}
//数据
-(void)initData
{
    [MHAsiNetworkAPI getAboutUsInfoWithSuccessBlock:^(id returnData) {
        HiddenLoadingView(self.view);
        DEF_DEBUG(@"关于询法接口返回的数据：%@",returnData);
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
        HiddenLoadingView(self.view);
    } showHUD:NO];
}

//导航栏
-(void)initNav
{
    [self showNavBarDefaultHUDByNavTitle:@"关于询法" inView:self.view isBack:YES];
}

// 创建视图
-(void)initUIWithUrl:(NSString*)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT-64)];
    webview.delegate = self;
    webview.scalesPageToFit = YES;
    webview.paginationMode =UIWebPaginationModeUnpaginated;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [webview loadRequest:request];
    [self.view addSubview:webview];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [DataHander  showDlg];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [DataHander hideDlg];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [DataHander  hideDlg];
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
