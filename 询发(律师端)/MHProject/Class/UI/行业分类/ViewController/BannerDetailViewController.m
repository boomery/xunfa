//
//  BannerDetailViewController.m
//  MHProject
//
//  Created by 张好志 on 15/7/24.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "BannerDetailViewController.h"
@interface BannerDetailViewController ()<UIWebViewDelegate>

@end

@implementation BannerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    
    [self initUIWithUrl:self.bannerURL];
}

//导航栏
-(void)initNav
{
    [self showNavBarDefaultHUDByNavTitle:self.bannerNameStr inView:self.view isBack:YES];
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
    [DataHander  hideDlg];
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
