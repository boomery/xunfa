//
//  AppDelegate.m
//  MHProject
//
//  Created by Andy on 15/4/20.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "GuideView.h"
#import "HomeViewController.h"
#import "IndustryTagViewController.h"
#import "QuestionSquareViewController.h"
#import "NewsViewController.h"
#import "MyViewController.h"
#import "SoundManager.h"
#import "MessageManager.h"
#import "GPSLocationManager.h"
#import "LoginViewController.h"

#import "MobClick.h"
/*
 * 科大讯飞相关
 */
#import <iflyMSC/IFlySetting.h>
#import <iflyMSC/IFlySpeechUtility.h>
#import "IFlyFlowerCollector.h"

/*
 * 分享相关
 */

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>

#define APPID_VALUE @"553079c8"
#define TIMEOUT_VALUE         @"20000"     // timeout   连接超时的时间，以ms为单位

#import "YQB_SSKeychain.h"

/*
 * 分享相关
 */

//#import <ShareSDK/ShareSDK.h>
//#import "WXApi.h"
//#import "WeiboApi.h"
//#import "WeiboSDK.h"


@interface AppDelegate ()

// 网络状态实时监听
@property (strong, nonatomic) Reachability *reachability;

@end

@implementation AppDelegate

#pragma mark -
+ (AppDelegate *)appDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initPush];
    DEF_PERSISTENT_SET_OBJECT([AppDelegate getDeviceID], DEF_UUID);//保存设备id

    //1、时间戳相关
    //获取服务器的时间戳保存到本地，在后台执行定时器
    [self getServerTimestaps];
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(getTimestamp) object:nil];
    [thread start];
    
    //2、实时监听网络状态
    [self startRealTimeNetworkStatus];
    
    //3、科大讯飞的SDK
    [self initKeDaVoiceSDK];
    
    //4、分享集成
    [self initShareSDK];
    
//    友盟统计相关
     [self initMobClick];
    
//     //开启GPS定位
//    [self gpsLocate];
    
    //5、构造window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    //6、加载主界面
    [self changeMainController];
    
    NSDictionary*userInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    if(userInfo)
    {
        [self application:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
    }
//    NSLog(@"launchOptions:%@",launchOptions);
    
    
    //7、显示引导页
    [self showGuideHUD];
    
//    //找出自定义字体的名字
//    [[CMManager sharedCMManager] printCustomFontName];

    return YES;
}
#pragma mark -- 推送相关

-(void)initPush
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                             categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge)];
    }
}

//获取DeviceToken成功
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    DEF_DEBUG(@"DeviceToken: %@",deviceToken);
    
    //DeviceToken: <bcabbd1f b4a8185d c2466293 eb9fb16b 4b6c8a65 26b05e55 aa0a678a 2973fb9a>
    //去掉<> 和空格
    //这里进行的操作，是将Device Token发送到服务端
    NSString *newDeviceToken = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
   
    
    if (![NSString isBlankString:newDeviceToken])
    {
        DEF_PERSISTENT_SET_OBJECT(newDeviceToken, DEF_Device_token);
    }
    //如果律师id存在的话（代表登录成功）再次将最新的deviceToken发给后台
    if (DEF_PERSISTENT_GET_OBJECT(DEF_UserID))
    {
        newDeviceToken = DEF_PERSISTENT_GET_OBJECT(DEF_Device_token);
        [self postPushInfoToServerByHttpRequestWithDeviceToken:newDeviceToken];
    }
}
#pragma mark - 友盟统计
- (void)initMobClick
{
    [MobClick startWithAppkey:@"55a4d6fa67e58e1677002176" reportPolicy:REALTIME channelId:nil];
    //    [MobClick setLogEnabled:YES];
    [MobClick setBackgroundTaskEnabled:YES];
}

-(void)postPushInfoToServerByHttpRequestWithDeviceToken:(NSString *)deviceToken
{
    //显示版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];// app名称
    NSString *app_Name = @"询法-律师版";
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];// app版本
    
    [MHAsiNetworkAPI pushToServerWithApp_name:app_Name
                                  app_version:app_Version
                                   device_uid:DEF_PERSISTENT_GET_OBJECT(DEF_UUID)
                                 device_token:deviceToken
                                 SuccessBlock:^(id returnData)
     {
         DEF_DEBUG(@"推送信息接口返回数据%@",returnData);
         
         NSString *ret = returnData[@"ret"];
         NSString *msg = returnData[@"msg"];
         //         NSDictionary *data = returnData[@"data"];
         //给界面赋值
         if ([ret isEqualToString:@"0"])
         {
             
         }
         else
         {
             SHOW_ALERT(msg);
         }
         
     } failureBlock:^(NSError *error) {
         
     } showHUD:NO];
}

//注册消息推送失败
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString *str = [NSString stringWithFormat: @"Error:%@", error];
    DEF_DEBUG(@"您获取的设备失败的失败原因为：%@",str);
}
//处理收到的消息推送
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    DEF_DEBUG(@"Receive remote notification : %@",userInfo);
    for (id key in userInfo)
    {
        DEF_DEBUG(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
    NSDictionary *infoDict = [userInfo objectForKey:@"aps"];
    NSNumber *lqid = infoDict[@"qid"];
    NSString *qid = [NSString stringWithFormat:@"%@",lqid];
//    NSString *message = [infoDict objectForKey:@"alert"];
//    SHOW_ALERT(message);
    
    //用户追问消息
    if (infoDict[@"aid"])
    {
        //未读消息数增加
        [MessageManager addNewUnreadMessage];
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
        {
            SoundManager *manager = [SoundManager sharedSoundManager];
            //只有从消息进入互动页面，该属性才有值。不在该页面才播放音效
            if (!self.chattingTarget || ![qid isEqualToString:self.chattingQuestion])
            {
                [manager musicPlayByName:@"bubble"];
            }
        }
        //下方，我的。红点显示
        self.tabBarController.tabBarView.messageRedDot.hidden = NO;
        //如果已经选择我的，则刷新该表。显示表中红点
        if (self.tabBarController.selectedIndex == 2)
        {
            BaseNavViewController *baseNav = (BaseNavViewController *)self.tabBarController.selectedViewController;
            if ([baseNav.topViewController isKindOfClass:[MyViewController class]])
            {
                MyViewController *myVC = (MyViewController *)baseNav.topViewController;
                [myVC.myInfoTableView reloadData];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadNews" object:nil];
    }
    //新问题提示消息
    else
    {
        //如果不是在第一个页面，收到通知则显示小红点。在点击第一个时隐藏
        if (self.tabBarController.selectedIndex != 0)
        {
            self.tabBarController.tabBarView.raceRedDot.hidden = NO;
        }
        if (![self.lastQuestion_ID isEqualToString:qid] && self.isAtHome)
        {
            //在抢答首页时push页面
            [[NSNotificationCenter defaultCenter]postNotificationName:DEF_PushNews object:nil userInfo:userInfo];
        }
        self.lastQuestion_ID = qid;
    }
}

#pragma mark - 推送的小红点的点击消失事件
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // 清空badge数量为0
    [[AppDelegate appDelegate] setAppIconBadgeNumber:0];
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // 清空badge数量为0
    [[AppDelegate appDelegate] setAppIconBadgeNumber:0];
}
- (void)setAppIconBadgeNumber:(NSInteger)badge
{
    NSInteger newBadge = (badge == 0) ? 0 : badge + [DEF_PERSISTENT_GET_OBJECT(@"def_badge") integerValue];;
    
    DEF_PERSISTENT_SET_OBJECT([NSNumber numberWithInteger:newBadge], @"def_badge");
    
    // 设置badge数量
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:newBadge];
}

+ (NSString *)getDeviceID
{
    // CFUUID
    NSString *appID         = @"dragon_falvwenwen@163.com";
    NSString *serviceName   = [NSString stringWithFormat:@"%@.%@", [NSBundle mainBundle].bundleIdentifier, appID];
    NSString *uuidStr       = [YQB_SSKeychain passwordForService:serviceName account:@"UUID"];
    
    if (uuidStr.length == 0)
    {
        /*
         //IDFA
         NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
         
         if (LogSwtich == 1) {
         NSLog(@"[ IDFA: %@ ]", idfa);
         }
         
         return idfa;
         */
        
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        assert(uuid != NULL);
        uuidStr = [NSString stringWithFormat:@"%@",CFUUIDCreateString(NULL, uuid)];
        
        [YQB_SSKeychain setPassword:uuidStr forService:serviceName account:@"UUID"];
    }
    if ([NSString isBlankString:uuidStr])
    {
        uuidStr = @"0";
    }
    DEF_DEBUG(@"[ 设备唯一ID CFUUID: %@ ]", uuidStr);
    
    return uuidStr;
}

#pragma mark -- 集成科大讯飞SDK
-(void)initKeDaVoiceSDK
{
    //设置log等级，此处log为默认在app沙盒目录下的msc.log文件
    [IFlySetting setLogFile:LVL_ALL];
    
    //输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    //设置msc.log的保存路径
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,timeout=%@",APPID_VALUE,TIMEOUT_VALUE];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];

}

#pragma mark -- 切换控制器
//
-(void)changeMainController
{
    if ([self isLogin]==YES)
    {
        //设置rootViewController
        [self initTabBarControllerHUD];
        //底部导航栏
    }
    else
    {
        [self gotoLoginVC];
    }
}
-(void)gotoLoginVC
{
    // 登录
    LoginViewController *login = [[LoginViewController alloc]init];
    UINavigationController *base = [[UINavigationController alloc]initWithRootViewController:login];
    self.window.rootViewController  = base;
}
//判断是否登录
-(BOOL)isLogin
{
    NSString *loginToken = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    if (loginToken)
    {
        return YES;
    }
    else{
        return NO;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 初始化界面，设置rootViewController
- (void)initTabBarControllerHUD
{
    //抢答
    BaseNavViewController *homeNav  = [[BaseNavViewController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    homeNav.delegate = self;
    homeNav.navigationBarHidden = YES;

    //广场
    BaseNavViewController *questionNav    = [[BaseNavViewController alloc] initWithRootViewController:[[QuestionSquareViewController alloc] init]];
    questionNav.delegate = self;
    questionNav.navigationBarHidden = YES;

    //
    BaseNavViewController *newsNav    = [[BaseNavViewController alloc] initWithRootViewController:[[NewsViewController alloc] init]];
    newsNav.delegate = self;
    newsNav.navigationBarHidden = YES;
    
    //
    BaseNavViewController *myNav    = [[BaseNavViewController alloc] initWithRootViewController:[[MyViewController alloc] init]];
    myNav.delegate = self;
    myNav.navigationBarHidden = YES;

    // 组合主界面
    self.tabBarController                   = [[TabBarController alloc] init];
    self.tabBarController.delegate          = self;
    self.tabBarController.viewControllers   = [NSArray arrayWithObjects:homeNav,questionNav,newsNav,myNav, nil];

    // 设置rootViewController
    self.window.rootViewController = self.tabBarController;
}

#pragma mark - 显示引导页
- (void)showGuideHUD
{
    // 引导页
    if (![DEF_PERSISTENT_GET_OBJECT(@"showGuide") boolValue])
    {
        DEF_PERSISTENT_SET_OBJECT([NSNumber numberWithBool:YES], @"showGuide");
        GuideView *guide = [[GuideView alloc] initWithFrame:self.window.bounds];
        [self.window addSubview:guide];
    }
}
#pragma mark - 水印
- (void)addCompanyWatermark
{
      //添加水印
//    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"watermark"]];
//    iv.frame        = CGRectMake(0, DEF_HEIGHT(self.window) - 12, DEF_WIDTH(self.window), 12);
//    [self.window addSubview:iv];
//    [self.window bringSubviewToFront:iv];
    
    
    //文字水印
    UILabel *l          = [[UILabel alloc] initWithFrame:CGRectMake(0, DEF_HEIGHT(self.window) - 20, DEF_WIDTH(self.window), 20)];
    l.backgroundColor   = [[UIColor whiteColor] colorWithAlphaComponent:.75];
    l.font              = [UIFont systemFontOfSize:10];
    l.textColor         = [UIColor blueColor];
    l.text              = @"Copyright (c) 2015年 Law of wisdom company. All rights reserved.";
    l.textAlignment     = NSTextAlignmentCenter;
    [self.window addSubview:l];
    [self.window bringSubviewToFront:l];
   
}

#pragma mark -
#pragma mark - 实时监听网络状态
- (void)startRealTimeNetworkStatus
{
    // 开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil
     ];
    self.reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [self.reachability startNotifier];
}
- (void)reachabilityChanged:(NSNotification* )note
{
    Reachability *curReach  = [note object];
    NetworkStatus status    = [curReach currentReachabilityStatus];
    DEF_DEBUG(@"网络状态值: %ld", (long)status);
    // 根据网络状态值，在这里做你想做的事
    
    // ...
}

#pragma mark -
#pragma mark - GPS定位
- (void)gpsLocate
{
    // 防止循环引用
    __unsafe_unretained typeof([GPSLocationManager sharedGPSLocationManager]) gps = [GPSLocationManager sharedGPSLocationManager];
    
    // 开启定位
    [gps startGPSLocation];
    
    // 定位结果
    gps.gpsFailureBlock = ^(){
        // 定位失败
    };
    
    gps.gpsSuccessBlock = ^(CLLocationDistance longitude, CLLocationDistance latitude){
        
        // 停止定位
        [gps stopGPSLocation];
        
        // 定位成功
        DEF_DEBUG(@"定位成功，经度:%f, 纬度:%f", longitude, latitude);
        
        // 逆编译地区
        [gps gpsLocationInfoByLong:longitude lat:latitude locationInfo:^(CLPlacemark *gpsInfo) {
            //
            DEF_DEBUG(@"写法一，当前地理位置信息: %@", gpsInfo);
            
            // 获取城市
            NSString *city = gpsInfo.locality;
            if (!city)
            {
                
                // 四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = gpsInfo.administrativeArea;
            }
            DEF_DEBUG(@"city = %@", city);
            
            NSMutableString *mutable = [[NSMutableString alloc] initWithString:city];
            
            if ([mutable rangeOfString:@"市辖区"].location != NSNotFound)
            {
                [mutable deleteCharactersInRange:NSMakeRange([mutable length]-3, 3)];
                city = mutable;
            }
        }];
    };
}


#pragma mark --分享相关
- (void)initShareSDK
{
    [ShareSDK registerApp:@"955e3350af3c"];//字符串api20为您的ShareSDK的AppKey
    [ShareSDK connectSinaWeiboWithAppKey:@"2472768246"
                               appSecret:@"620efc7969c065e98095170e2a034397"
                             redirectUri:@"http://www.findsolution.cn"];
    
    [ShareSDK connectWeChatTimelineWithAppId:@"wx861ea25f76b51922"
                                   appSecret:@"4b17d12d1fb3367617d20d2ae9051fbf"
                                   wechatCls:[WXApi class]];
    
    [ShareSDK connectWeChatSessionWithAppId:@"wx861ea25f76b51922"
                                  appSecret:@"4b17d12d1fb3367617d20d2ae9051fbf"
                                  wechatCls:[WXApi class]];
    
    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    TencentOAuth *oAuth = [[TencentOAuth alloc] initWithAppId:@"1104713363" andDelegate:nil];
    [ShareSDK connectQZoneWithAppKey:@"1104788374"
                           appSecret:@"12VUP5Iw9vRkY7LT"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [ShareSDK handleOpenURL:url wxDelegate:self];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
}

#pragma mark -- 时间戳相关
-(void)getServerTimestaps
{
    [MHAsiNetworkAPI getTimestampBySuccessBlock:^(id returnData) {
        DEF_DEBUG(@"获取时间戳返回数据%@",returnData);
        NSString *ret = returnData[@"ret"];
        if ([ret isEqualToString:@"0"])
        {
            //            NSString *msg = returnData[@"msg"];
            NSDictionary *data = returnData[@"data"];
            NSString *timestamp = data[@"timestamp"];
            // NSString *password = data[@"password"];
            DEF_PERSISTENT_SET_OBJECT(timestamp, DEF_ServerTimestap);
        }
        else
        {
            DEF_PERSISTENT_SET_OBJECT(@"0", DEF_ServerTimestap);
        }
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}
- (void)getTimestamp
{
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] run];

}
- (void)timerAction
{
    self.timeCount ++;
    NSString *time =[NSString stringWithFormat:@"%ld",(long)self.timeCount];
    DEF_PERSISTENT_SET_OBJECT(time, DEF_timestamp);
//    NSLog(@"定时器:%@",DEF_PERSISTENT_GET_OBJECT(DEF_timestamp));
}

@end
