//
//  BaseViewController.m
//  PerfectProject
//
//  Created by DuBin on 14/11/19.
//  Copyright (c) 2014年 Andy All rights reserved.
//

#import "BaseViewController.h"
#define DEF_iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Do any additional setup after loading the view.
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    // iOS7顶部屏幕适配
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
#endif
    
    // 默认背景色
    self.view.backgroundColor = DEF_RGB_COLOR(244, 244, 244);
}


#pragma mark - 错误提示
/**
 *  错误提示
 *
 *  @param msg 提示的内容
 */
- (void)errorTipHUDByMsg:(NSString *)msg
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil
                                                 message:msg
                                                delegate:nil
                                       cancelButtonTitle:@"好"
                                       otherButtonTitles:nil, nil];
    [av show];
}






#pragma mark --
#pragma mark -- 自定义假的导航条

#pragma mark - 显示默认的NavBar
/**
 *  显示默认的NavBar
 *
 *  @param navTitle 标题
 *  @param view     显示在指定的view上
 */
- (void)showNavBarDefaultHUDByNavTitle:(NSString *)navTitle
                                inView:(UIView *)view
{
    // 背景
    UIView *navBarView          = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_WIDTH(view), 64)];
    navBarView.backgroundColor  = DEF_RGB_COLOR(250,250, 250);
    [view addSubview:navBarView];
    
    // 文字
    UILabel *navLabel       = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, DEF_WIDTH(navBarView), DEF_HEIGHT(navBarView)-20)];
    navLabel.textAlignment  = NSTextAlignmentCenter;
//    navLabel.font           = [UIFont boldSystemFontOfSize:22];
    navLabel.font           = [UIFont boldSystemFontOfSize:18];
    navLabel.textColor      = DEF_RGB_COLOR(51, 51, 51);
    navLabel.text           = navTitle;
    [navBarView addSubview:navLabel];
    
    //
    UILabel *lineLB = [[UILabel alloc]initWithFrame:CGRectMake(0, DEF_HEIGHT(navBarView)- LINE_HEIGHT, DEF_SCREEN_WIDTH,LINE_HEIGHT)];
    lineLB.backgroundColor = DEF_RGB_COLOR(202, 202, 202);
    [navBarView addSubview:lineLB];
}

#pragma mark - 显示默认的NavBar 左侧返回按钮
/**
 *  显示默认的NavBar
 *
 *  @param navTitle 标题
 *  @param view     显示在指定的view上
 */
- (void)showNavBarDefaultHUDByNavTitle:(NSString *)navTitle
                                inView:(UIView *)view
                                isBack: (BOOL)isBack
{
    // 背景
    UIView *navBarView          = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_WIDTH(view), 64)];
    navBarView.backgroundColor  = DEF_RGB_COLOR(250,250, 250);
    [view addSubview:navBarView];
    
    // 文字
    UILabel *navLabel       = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, DEF_WIDTH(navBarView), DEF_HEIGHT(navBarView)-20)];
    navLabel.textAlignment  = NSTextAlignmentCenter;
//    navLabel.font           = [UIFont boldSystemFontOfSize:22];
    navLabel.font           = [UIFont boldSystemFontOfSize:18];
    navLabel.textColor      = DEF_RGB_COLOR(51, 51, 51);
    navLabel.text           = navTitle;
    [navBarView addSubview:navLabel];
    
    if (isBack == YES)
    {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 20, 60, 44);
        [backBtn setImage:[UIImage imageNamed:@"menu-left-back"] forState:UIControlStateNormal];
        backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0,15,0,30)];
        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backBtn setExclusiveTouch:YES];
        backBtn.backgroundColor = [UIColor clearColor];
        [backBtn addTarget:self action:@selector(leftNavItemClick) forControlEvents:UIControlEventTouchUpInside];
        [navBarView addSubview:backBtn];
    }
    
    UILabel *lineLB = [[UILabel alloc]initWithFrame:CGRectMake(0, DEF_HEIGHT(navBarView)- LINE_HEIGHT, DEF_SCREEN_WIDTH,LINE_HEIGHT)];
    lineLB.backgroundColor = DEF_RGB_COLOR(202, 202, 202);
    [navBarView addSubview:lineLB];}

#pragma mark - 显示导航条上边的右侧返回按钮
/**
 *  显示默认的NavBar
 *
 *  @param navTitle 标题
 *  @param view     显示在指定的view上
 */
- (void)showNavBarWithTwoBtnHUDByNavTitle:(NSString *)navTitle
                               rightTitle:(NSString *)rightTitle
                                   inView:(UIView *)view
                                   isBack:(BOOL)isBack
{
    // 背景
    UIView *navBarView          = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_WIDTH(view), 64)];
    navBarView.backgroundColor = [UIColor redColor];
    navBarView.backgroundColor  = DEF_RGB_COLOR(250,250, 250);
    [view addSubview:navBarView];
    
    // 文字
    UILabel *navLabel       = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, DEF_WIDTH(navBarView), DEF_HEIGHT(navBarView)-20)];
    navLabel.textAlignment  = NSTextAlignmentCenter;
//    navLabel.font           = [UIFont boldSystemFontOfSize:22];
    navLabel.font           = [UIFont boldSystemFontOfSize:18];
    navLabel.textColor      = DEF_RGB_COLOR(51, 51, 51);
    navLabel.text           = navTitle;
    [navBarView addSubview:navLabel];
    
    if (isBack == YES)
    {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 20, 60, 44);
        [backBtn setImage:[UIImage imageNamed:@"menu-left-back"] forState:UIControlStateNormal];
        backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0,15,0,30)];
        backBtn.backgroundColor = [UIColor clearColor];
        [backBtn addTarget:self action:@selector(leftNavItemClick) forControlEvents:UIControlEventTouchUpInside];
        [navBarView addSubview:backBtn];
    }
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(DEF_WIDTH(navBarView)-80, 27, 70, 30);
    [rightBtn setTitle:rightTitle forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    rightBtn.titleLabel.textAlignment =NSTextAlignmentRight;
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if ([rightTitle isEqualToString:@"忘记密码"])
    {
        [rightBtn setTitleColor:[UIColor colorWithRed:0.25 green:0.61 blue:0.89 alpha:1] forState:UIControlStateNormal];
    }
    rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [rightBtn addTarget:self action:@selector(rightNavItemClick) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:rightBtn];
    
    UILabel *lineLB = [[UILabel alloc]initWithFrame:CGRectMake(0, DEF_HEIGHT(navBarView)- LINE_HEIGHT, DEF_SCREEN_WIDTH,LINE_HEIGHT)];
    lineLB.backgroundColor = DEF_RGB_COLOR(202, 202, 202);
    [navBarView addSubview:lineLB];
}
- (void)showNavBarWithTwoBtnHUDByNavTitle:(NSString *)navTitle
                                leftImage:(NSString *)leftImage
                                leftTitle:(NSString *)leftTitle
                               rightImage:(NSString *)rightImage
                               rightTitle:(NSString *)rightTitle
                                   inView:(UIView *)view
                                   isBack:(BOOL)isBack
{
    // 背景
    UIView *navBarView          = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_WIDTH(view), 64)];
    navBarView.backgroundColor  = DEF_RGB_COLOR(250,250, 250);
    [view addSubview:navBarView];
    
    // 文字
    UILabel *navLabel       = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, DEF_WIDTH(navBarView), DEF_HEIGHT(navBarView)-20)];
    navLabel.textAlignment  = NSTextAlignmentCenter;
//    navLabel.font           = [UIFont boldSystemFontOfSize:22];
    navLabel.font           = [UIFont boldSystemFontOfSize:18];
    navLabel.textColor      = DEF_RGB_COLOR(51, 51, 51);
    navLabel.text           = navTitle;
    [navBarView addSubview:navLabel];
    
    if (isBack == YES)
    {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 20, 80, 44);
        [backBtn setTitle:leftTitle forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:leftImage] forState:UIControlStateNormal];
        backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0,15,0,50)];
        [backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
        if ([leftImage isEqualToString:@"list"]) {
            [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,30)];
        }
        backBtn.backgroundColor = [UIColor clearColor];
        [backBtn addTarget:self action:@selector(leftNavItemClick) forControlEvents:UIControlEventTouchUpInside];
        [navBarView addSubview:backBtn];
    }
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(DEF_WIDTH(navBarView)-70, 27, 70, 30);
    [rightBtn setTitle:rightTitle forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    rightBtn.titleLabel.textAlignment =NSTextAlignmentRight;
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if ([rightTitle isEqualToString:@""])
    {
        [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0,40,0,10)];
    }
    if ([rightTitle isEqualToString:@""]&&[rightImage isEqualToString:@"search_blue"])
    {
        [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0,30,0,20)];
    }

    if (![rightTitle isEqualToString:@""] &&[rightImage isEqualToString:@""])
    {
        rightBtn.frame = CGRectMake(DEF_WIDTH(navBarView)-60, 27,50.0,30);
        rightBtn.backgroundColor = DEF_RGB_COLOR(62, 153, 230);
        rightBtn.layer.cornerRadius = 3;
        rightBtn.clipsToBounds = YES;
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        if ([rightTitle isEqualToString:@"兑现设置"]||[rightTitle isEqualToString:@"修改账号"]||[rightTitle isEqualToString:@"提现申请"] || [rightTitle isEqualToString:@"提交审核"]|| [rightTitle isEqualToString:@"约见资料"])
        {
            rightBtn.frame = CGRectMake(DEF_WIDTH(navBarView)-80, 29, 70, 26);
            rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            rightBtn.layer.cornerRadius = 2;
            rightBtn.clipsToBounds = YES;
        }
    }
//    if ([rightImage isEqualToString:@""]) {
//        
//        [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 10)];
//    }
    [rightBtn setImage:[UIImage imageNamed:rightImage] forState:UIControlStateNormal];
    rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [rightBtn addTarget:self action:@selector(rightNavItemClick) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:rightBtn];
    
    //
    if ([rightImage isEqualToString:@""]&&[rightTitle isEqualToString:@""]) {
        rightBtn.enabled = NO;
    }
    UILabel *lineLB = [[UILabel alloc]initWithFrame:CGRectMake(0, DEF_HEIGHT(navBarView)- LINE_HEIGHT, DEF_SCREEN_WIDTH,LINE_HEIGHT)];
    lineLB.backgroundColor = DEF_RGB_COLOR(202, 202, 202);
    [navBarView addSubview:lineLB];
}

#pragma mark - 点击事件
- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
// 导航栏左按钮 点击, 子类重写这个方法
- (void)rightNavItemClick
{
    
    
}

























#pragma mark - 导航栏左按钮
- (void)addLeftNavBarBtnByImg:(NSString *)img andWithText:(NSString *)text
{
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0.,0.,22/2,38/2);
    if ([img isEqualToString:@"list"]) {
        leftButton.frame = CGRectMake(0.,0.,50/2,44/2);
    }
    if (![text isEqualToString:@""] && ![img isEqualToString:@""]) { // 图文,这个暂不好写死，需要根据图片的尺寸和文字的多少去定义，这个需要在类里重写方法
        
    }
    else if (![text isEqualToString:@""]) { // 文字
        leftButton.frame = CGRectMake(0.,0.,75,50/2);
        leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    //    else if (![img isEqualToString:@""]) {// 图片 默认，不做处理
    //
    //    }
    [leftButton setBackgroundImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftNavItemClick) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:text forState:UIControlStateNormal];
    
    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
}
#pragma mark - 导航栏右边按钮
- (void)addRightNavBarBtnByImg:(NSString *)img andWithText:(NSString *)text
{
    // 如果没有的话，不添加，传人的参数是 @“”
    if([img isEqualToString:@""] && [text isEqualToString:@""])
    {
        return;
    }
    //自定义的rightBarButtonItem
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0.,0.,50/2,50/2);
    if ([img isEqualToString:@"share"]) {
        rightBtn.frame = CGRectMake(0.,0.,44/2,10/2);
    }
    [rightBtn setTitle:text forState:UIControlStateNormal];
    
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn setExclusiveTouch:YES];
    //    if (![text isEqualToString:@""] && ![img isEqualToString:@""]) { // 图文,这个暂不好写死，需要根据图片的尺寸和文字的多少去定义，这个需要在类里重写方法
    //
    //
    //    }
    
    if (![text isEqualToString:@""]) { // 纯文字
        rightBtn.frame = CGRectMake(0.,0.,75,50/2);
        rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    [rightBtn addTarget:self action:@selector(rightNavItemClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    rightBtn.titleLabel.textColor = [UIColor blackColor];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem* rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}
- (void)addRIghtButtonWithTitle:(NSString *)title
{
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0.,0.,TRANSFORM_WIDTH(50.0),TRANSFORM_HEIGHT(25.0));
    rightBtn.backgroundColor = DEF_RGB_COLOR(62, 155, 230);
    rightBtn.layer.cornerRadius = 5;
    rightBtn.clipsToBounds = YES;
    rightBtn.titleLabel.textColor = [UIColor blackColor];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];

    [rightBtn addTarget:self action:@selector(rightNavItemClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    UIBarButtonItem* rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}
#pragma mark - 自定义 导航栏 的标题
- (void) addNavBarTitle:(NSString *)title
{
    //自定义 title 颜色
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    t.font = [UIFont systemFontOfSize:22];//22
    t.textColor = [UIColor blackColor];
    t.backgroundColor = [UIColor clearColor];
    t.textAlignment = NSTextAlignmentCenter;
    t.text = title;
    
    self.navigationItem.titleView = t;
    
}
-(void)creatContScrollView{
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT-64)];
    [self.view addSubview:self.contentScrollView];
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

#pragma mark -
#pragma mark - 支持重力感应，屏幕旋转
- (BOOL)shouldAutorotate
{
    // 开启自动旋转，通过supportedInterfaceOrientations来指定旋转的方向
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    // 指定旋转的方向
    
    return UIInterfaceOrientationMaskAll;
//    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
//    return UIInterfaceOrientationMaskPortrait;
}

@end
