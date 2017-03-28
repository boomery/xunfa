//
//  SettingViewController.m
//  MHProject
//
//  Created by 张好志 on 15/6/24.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "SettingViewController.h"
#import "FeedBackViewController.h"
#import "AboutUsViewController.h"
#import "ShareView.h"

#define DEF_PushSwitch @"openPush"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property(nonatomic,strong)ShareView *shareView;
@property (nonatomic,strong) UILabel        *newsIsOpenLB;
@property (nonatomic,strong) UITableView    *settingTableView;
@property (nonatomic,strong) NSMutableArray *settingArray;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
    [self initNav];
    
    [self initUI];
    
//    [self onCheckVersion];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark -- 初始化
-(void)initNav
{
    [self showNavBarDefaultHUDByNavTitle:@"设置" inView:self.view isBack:YES];
}
#pragma mark - 点击事件
- (void)leftNavItemClick
{
    [MobClick event:@"LawSetup_Back"];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initUI
{
    //
    UIView *topBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 110.0)];
    topBgView.backgroundColor= [UIColor clearColor];
    //
    UIView *newsBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 12, DEF_WIDTH(topBgView), 44)];
    newsBgView.backgroundColor = [UIColor whiteColor];
    [topBgView addSubview:newsBgView];
    //
    UILabel  *newsLB = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, DEF_WIDTH(newsBgView)/2, DEF_HEIGHT(newsBgView))];
    newsLB.text = @"接收新消息通知";
    newsLB.font = [UIFont systemFontOfSize:16];
    newsLB.textColor = DEF_RGB_COLOR(51, 51, 51);
    [newsBgView addSubview:newsLB];
    //
    self.newsIsOpenLB = [[UILabel alloc]initWithFrame:CGRectMake(DEF_WIDTH(newsBgView)/2, 0, DEF_WIDTH(newsBgView)/2-12, DEF_HEIGHT(newsBgView))];
    self.newsIsOpenLB.text = @"已开启";
    self.newsIsOpenLB.font = [UIFont systemFontOfSize:16];
    self.newsIsOpenLB.textColor = DEF_RGB_COLOR(111, 111, 111);
    self.newsIsOpenLB.textAlignment = 2;
    [newsBgView addSubview:self.newsIsOpenLB];
    if ([[UIDevice currentDevice].systemVersion integerValue] >= 8.0)
    {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication]currentUserNotificationSettings];
        if (setting.types == UIUserNotificationTypeNone)
        {
            self.newsIsOpenLB.text = @"已关闭";
        }
    }
    else
    {
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone)
        {
            self.newsIsOpenLB.text = @"已关闭";
        }
    }
    //
    UILabel  *tipLB = [[UILabel alloc]initWithFrame:CGRectMake(12, DEF_BOTTOM(newsBgView), DEF_SCREEN_WIDTH-24,DEF_HEIGHT(topBgView)-10-DEF_HEIGHT(newsBgView))];
    tipLB.text = @"如果你要关闭或开启询法的新消息通知，请在iPhone的“设置” - “通知”功能中，找到应用程序“询法-律师版”更改";
    tipLB.textColor = DEF_RGB_COLOR(159, 159, 159);
    tipLB.numberOfLines = 0;
    if (DEF_SCREEN_WIDTH==320) {
        tipLB.font = [UIFont systemFontOfSize:12];
    }else{
        tipLB.font = [UIFont systemFontOfSize:13.5];
    }
    [topBgView addSubview:tipLB];
    
    //
    self.settingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, DEF_SCREEN_WIDTH,DEF_SCREEN_HEIGHT-64-40) style:UITableViewStylePlain];
    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
    self.settingTableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    self.settingTableView.rowHeight = 44;
    [self.view addSubview:self.settingTableView];
    if (DEF_SCREEN_WIDTH==320) {
        self.settingTableView.scrollEnabled = YES;
    }else{
        self.settingTableView.scrollEnabled = NO;
    }
    [self creatBottomView];
    self.settingTableView.tableHeaderView  =topBgView;
}
-(void)creatBottomView
{
    //
    UIButton *loginOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginOutBtn.frame = CGRectMake(0,DEF_SCREEN_HEIGHT - 44, DEF_SCREEN_WIDTH, 44);
    [loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginOutBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    loginOutBtn.backgroundColor =  [UIColor colorWithRed:0.25 green:0.61 blue:0.89 alpha:1];
    [loginOutBtn addTarget:self action:@selector(loginOutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginOutBtn];
}

-(void)initData
{
    self.settingArray = [[NSMutableArray alloc]initWithObjects:@[@"意见反馈"],@[@""],@[@"关于询法"],@[@"把询法-律师版告诉好友"],@[@"客服电话：400-859-0918"], nil];
}

#pragma mark - UITableViewDetegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.settingArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"lawerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor =DEF_RGB_COLOR(51, 51, 51);
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    NSArray *array = self.settingArray[indexPath.section];
    cell.textLabel.text = array[indexPath.row];
//    if (indexPath.section==1)
//    {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(DEF_SCREEN_WIDTH-60, 7, 80, 30.0f)];
//        [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
//        NSString *isPush = DEF_PERSISTENT_GET_OBJECT(DEF_PushSwitch);
//        if ([isPush isEqualToString:@"1"]) {
//            switchView.on = YES;
//        }else{
//            switchView.on = NO;
//        }
//        [cell addSubview:switchView];
//    }
    if (indexPath.section == self.settingArray.count-1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        UIImageView *telImageView = [[UIImageView alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH-42, 7, 30, 30)];
        telImageView.backgroundColor = [UIColor clearColor];
        telImageView.image = [UIImage imageNamed:@"install_green_phone"];
        [cell addSubview:telImageView];
    }
    if (indexPath.section == 1)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"清理缓存";
//        cell.textLabel.text = [NSString stringWithFormat:@"清理缓存(%.2fM)",(unsigned long)[[SDImageCache sharedImageCache] getSize]/1024/1024.0];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 12.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            [MobClick event:@"LawSetup_EditSug"];

            FeedBackViewController *vc = [[FeedBackViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            [MobClick event:@"LawSetup_Clean"];

            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] clearDisk];
            [DataHander showSuccessWithTitle:@"清理成功"];
            [tableView reloadData];
        }
            break;
        case 2:
        {
            [MobClick event:@"LawSetup_AboutUs"];
            AboutUsViewController *vc = [[AboutUsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            [self shareBtnClick:nil];
        }
            break;
        case 4:
        {
            [self tellSomeOneWithPhoneNumber:@"4008590918"];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 分享
//自定义分享
- (void)shareBtnClick:(UIButton *)btn
{
    [MobClick event:@"LawQDetail_Share"];
    NSString *shareStr = @"下载询法律师版，进入移动法律服务时代。";
    if (shareStr.length>20) {
        shareStr = [shareStr substringToIndex:20];
        shareStr = [NSString stringWithFormat:@"%@...【分享自询法-律师版】",shareStr];
    }else{
        shareStr = [NSString stringWithFormat:@"%@【分享自询法-律师版】",shareStr];
    }
    NSString *shareText = shareStr;
    // 分享的图标
    UIImage *shareImage =[UIImage imageNamed:@"shareIconImage.png"];
    //分享
    _shareView        = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT)];
    _shareView.shareTitle        = @"来询法找到您的客户";
    _shareView.shareThumbImage   = shareImage;
    _shareView.shareDescription  = shareText;
    _shareView.controller        = self;
    _shareView.shareURLStr       = @"http://www.findsolution.cn/lawyer-download.html";
    
    
    [[AppDelegate appDelegate].window addSubview:_shareView];
    
    //
    [_shareView doSomethingAfterShareCompletion:^{
        
    }];
    
    [_shareView sinaShare:^{
        
    }];
    
    //    点击取消按钮
    [_shareView cancleShare:^{
        
    }];
    //    点击屏幕
    [_shareView closeShar:^{
        
    }];
}
#pragma mark -- 按钮点击事件
//注销登录
- (void)loginOutBtnClick:(UIButton*)sender
{
    [MobClick event:@"LawSetup_Logout"];
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = DEF_API_login_out;
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    [MHAsiNetworkAPI loginOutWithUid:uid
                           timestamp:timeStamp
                                sign:sign
                        SuccessBlock:^(id returnData)
     {
         DEF_DEBUG(@"退出登录：%@",returnData);
//         NSString *msg = returnData[@"msg"];
//         NSString *ret = returnData[@"ret"];
//         if ([ret isEqualToString:@"0"])
//         {
//         }
//         else
//         {
//             SHOW_ALERT(msg);
//         }
         
         //退出登录移除账户和密码
         DEF_PERSISTENT_REMOVE(DEF_LoginMobilPhone);
         DEF_PERSISTENT_REMOVE(DEF_LoginPassWord);

         //退出登录移除用户id和token
         DEF_PERSISTENT_REMOVE(DEF_loginToken);
         DEF_PERSISTENT_REMOVE(DEF_UserID);
         [[AppDelegate appDelegate]changeMainController];
     } failureBlock:^(NSError *error) {
     } showHUD:YES];
}

//消息开关
-(void)switchAction:(UISwitch *)sender
{
    if (sender.on==YES)
    {
//        self.newsIsOpenLB.text = @"已开启";
        DEF_PERSISTENT_SET_OBJECT(@"1", DEF_PushSwitch);
        [self permitOrForbidNotifyWithEnable_notify:@"1"];
    }
    else if (sender.on==NO)
    {
//        self.newsIsOpenLB.text = @"已关闭";
        DEF_PERSISTENT_SET_OBJECT(@"-1", DEF_PushSwitch);
        [self permitOrForbidNotifyWithEnable_notify:@"-1"];
    }
}
//是否允许通知enable_notify  消息通知开关(1是开启，-1是关闭)
-(void)permitOrForbidNotifyWithEnable_notify:(NSString *)enable_notify
{
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = [NSString stringWithFormat:@"%@%@",DEF_API_Lawyer,uid];
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    [MHAsiNetworkAPI permitOrForbidNotifyWithuid:uid timestamp:timeStamp sign:sign enable_notify:enable_notify SuccessBlock:^(id returnData) {
        DEF_DEBUG(@"消息通知接口返回的数据：%@",returnData);
        
        NSString *ret = returnData[@"ret"];
        NSString *msg = returnData[@"msg"];
        if ([ret isEqualToString:@"0"])
        {
            
        }
        else
        {
            SHOW_ALERT(msg);
        }

    } failureBlock:^(NSError *error) {
    } showHUD:YES];
}

//检测版本更新
-(void)onCheckVersion
{
    
  
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    DEF_DEBUG(@"%@",currentVersion);
    
    NSString *URL = @"https://itunesconnect.apple.com/WebObjects/iTunesConnect.woa/ra/ng/app/1025259813";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
    NSData *jsonData = [results dataUsingEncoding:NSUTF8StringEncoding];
    DEF_DEBUG(@"%@",results);
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&err];
    if (err)
    {
        DEF_DEBUG(@"%@解析失败",err);
    }
    
    NSArray *infoArray = [dic objectForKey:@"results"];
    if ([infoArray count]) {
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
        
        if (![lastVersion isEqualToString:currentVersion]) {
            //trackViewURL = [releaseInfo objectForKey:@"trackVireUrl"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
            alert.tag = 10000;
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"此版本为最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 10001;
            [alert show];
        }
    }
//   */
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000) {
        if (buttonIndex==1) {
            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com"];
            [[UIApplication sharedApplication]openURL:url];
        }
    }
}


//打电话
-(void)tellSomeOneWithPhoneNumber:(NSString*)phone
{
    UIWebView*callWebview =[[UIWebView alloc] init];
    
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",phone];
    
    NSURL *telURL =[NSURL URLWithString:telUrl];// 貌似tel:// 或者 tel: 都行
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    //记得添加到view上
    [self.view addSubview:callWebview];
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
