//
//  TabBarController.m
//  MHProject
//
//  Created by ZhangChaoxin on 15/7/6.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController () <TabBarViewDelegate>
{
    BOOL _isFirst;
}
@end

@implementation TabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isFirst = YES;
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isFirst)
    {
        _isFirst = NO;
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.tabBarView = [[TabBarView alloc] initWithFrame:CGRectMake(0, 0, DEF_WIDTH(delegate.window), DEF_TAB_BAR_HEIGHT)];
        self.tabBarView.delegate = self;
        [self.tabBar addSubview:self.tabBarView];
    }
}
#pragma mark - TabBarViewDelegate
- (void)tabBarView:(TabBarView *)tabBarView didSelectAtIndex:(NSInteger)index
{
    if (index == 0)
    {
        self.tabBarView.raceRedDot.hidden = YES;
    }
    self.selectedIndex = index;
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
