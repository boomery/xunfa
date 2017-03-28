//
//  PhoneOrderViewController.m
//  MHProject
//
//  Created by 张好志 on 15/6/24.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "PhoneOrderViewController.h"

@interface PhoneOrderViewController ()

@end

@implementation PhoneOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
    [self initNav];
    
    [self initUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

-(void)initNav
{
    [self showNavBarDefaultHUDByNavTitle:@"电话订单" inView:self.view isBack:YES];

//    [self addNavBarTitle:self.title];
//    [self addLeftNavBarBtnByImg:@"menu-left-back" andWithText:@""];
    
}
-(void)initUI
{
    
}

-(void)initData
{
    
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
