//
//  MainNavViewController.m
//  PerfectProject
//
//  Created by ZhangHaoZhi on 15/2/26.
//  Copyright (c) 2015年 M.H Co.,Ltd. All rights reserved.
//

#import "MainNavViewController.h"

@interface MainNavViewController ()

@end

@implementation MainNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 隐藏 navigation bar
    [self setNavigationBarHidden:YES animated:NO];
//    self.navigationController.navigationBar.barTintColor = [UIColor yellowColor];//不能放init处

    
    
    // 构造首页
//    self.homeViewController = [[HomeViewController alloc] initWithNibName:nil bundle:nil];
//    [self pushViewController:self.homeViewController animated:NO];
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
