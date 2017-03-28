//
//  HomeViewController.m
//  BMProject
//
//  Created by 杜宾 on 15/4/19.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "HomeViewController.h"
#import "QuestionCustomCell.h"
#import "QuestionModel.h"
#import "RaceQuestionViewController.h"
#import "HomeOpenCell.h"
#import "AnimateLabel.h"
#import "MobClick.h"
#import "MyRaceQuestionViewController.h"
#define Def_homeOpenTableViewTag 1001
#define Def_homehomeCloseTableViewTag 1002

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    NSMutableArray *tableViewData;
    int _setClickCount ;
}
@property(nonatomic,strong)AnimateLabel *questionLab;
@property (nonatomic,strong)UISwitch *theSwitch;
@property (nonatomic,strong)NSString *lawyerCount;
@end

@implementation HomeViewController
- (instancetype)init
{
    if (self = [super init])
    {
        tableViewData = [[NSMutableArray alloc] init];   
    }
    return self;
}

-(void)setLawyerCount:(NSString *)lawyerCount
{
    _lawyerCount =lawyerCount;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initData];
    
    //在抢答回复界面，抢答成功之后在这个界面的成功的提示
    if (self.showRaceSuccessTipStr) {
        [self showRaceSuccessAttentionView];
    }
}
-(void)showRaceSuccessAttentionView
{
    NSArray *array = [[NSArray alloc]initWithObjects:@"继续抢答",@"查看抢答", nil];
    XYAlertView *alertView=[XYAlertView alertViewWithTitle:@"抢答成功" message:@"抢答问题请在\n“我的”--“我的抢答”菜单中查看" buttons:array afterDismiss:^(int buttonIndex) {
        if (buttonIndex==0)
        {
            
        }
        else
        {
            self.showRaceSuccessTipStr =nil;
            MyRaceQuestionViewController *infoVC = [[MyRaceQuestionViewController alloc]init];
            infoVC.title = @"我的抢答";
            infoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:infoVC animated:YES];
        }
    }];
    [alertView show];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [AppDelegate appDelegate].isAtHome = NO;
}
- (void)viewDidAppear:(BOOL)animated
{
    [AppDelegate appDelegate].isAtHome = YES;
}
#pragma mark - view lifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToRaceQuestion:) name:DEF_PushNews object:nil];
    // Do any additional setup after loading the view.
    [self initUI];
    [self setNavUI];
}

- (void)initData
{
    [self requestTableDataWithRefresh:YES];
}

#pragma mark - 开启抢答开关自动进入抢答页面
- (void)pushToRaceQuestion:(NSNotification *)notification
{
    [self initData];
    if (self.theSwitch.isOn)
    {
        NSString *qid = notification.userInfo[@"aps"][@"qid"];
        if (qid)
        {
            RaceQuestionViewController *race = [[RaceQuestionViewController alloc] init];
            race.hidesBottomBarWhenPushed = YES;
            race.questionID = qid;
            [self.navigationController pushViewController:race animated:YES];
        }
    }
}

#pragma mark - NavUI
- (void)setNavUI
{
    [self showNavBarWithTwoBtnHUDByNavTitle:@"抢答列表" leftImage:@"" leftTitle:@"" rightImage:@"" rightTitle:@"" inView:self.view isBack:NO];
}

#pragma mark - 界面初始化
- (void)initUI
{
    self.homeCloseTableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 64+45, DEF_SCREEN_WIDTH , DEF_SCREEN_HEIGHT - 64 - 50.0-44) style:UITableViewStylePlain];
    self.homeCloseTableView.headerOnly = YES;
    self.homeCloseTableView.delegate = self;
    self.homeCloseTableView.dataSource = self;
    self.homeCloseTableView.pullingDelegate = self;
    self.homeCloseTableView.tag = Def_homehomeCloseTableViewTag;
    self.homeCloseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.homeCloseTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.homeCloseTableView];
    [self topView];
}
-(void)topView
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, DEF_SCREEN_WIDTH, 55)];
    [self.view addSubview:topView];
    topView.backgroundColor   = [UIColor whiteColor];

    //抢答问题
    self.questionLab = [[AnimateLabel alloc]initWithFrame:CGRectMake(10, 0, 220,54)];
    self.questionLab.font = [UIFont systemFontOfSize:16];
    self.questionLab.textColor = DEF_RGB_COLOR(111, 111, 111);
    self.questionLab.numberOfLines = 0;
    [topView addSubview:self.questionLab];

    //开关
    self.theSwitch = [[UISwitch alloc]initForAutoLayout];
    [topView addSubview:self.theSwitch];
    [self.theSwitch autoAlignAxis:ALAxisHorizontal toSameAxisOfView:topView];
    [self.theSwitch autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:topView withOffset:10];
    [self.theSwitch autoSetDimension:ALDimensionWidth toSize:80];
    [self.theSwitch addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventValueChanged];
    if (DEF_PERSISTENT_GET_OBJECT(@"autoRace"))
    {
        BOOL isAuto = [DEF_PERSISTENT_GET_OBJECT(@"autoRace") boolValue];
        self.theSwitch.on = isAuto;
        if (isAuto)
        {
            [self addCurrentIsRaceQuestionLawyerNumberWithNumber:self.lawyerCount];
        }
        else
        {
            [self.questionLab setAttributeText:[[NSAttributedString alloc] initWithString:@"允许问题自动抢答"] withDirection:DirectionLeft];
        }
    }
    else
    {
        self.theSwitch.on = YES;
        DEF_PERSISTENT_SET_OBJECT([NSNumber numberWithBool:YES], @"autoRace");
        [self addCurrentIsRaceQuestionLawyerNumberWithNumber:self.lawyerCount];
    }
    
    UILabel *lineLB = [[UILabel alloc]initWithFrame:CGRectMake(0,DEF_HEIGHT(topView)-LINE_HEIGHT, DEF_SCREEN_WIDTH,LINE_HEIGHT)];
    lineLB.backgroundColor = DEF_RGB_COLOR(202, 202, 202);
    [topView addSubview:lineLB];
}

#pragma mark - 刷新数据
-(void)requestTableDataWithRefresh:(BOOL)refreshFlag
{
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = DEF_API_RaceQuestionsList;
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    [DataHander showDlg];
    [MHAsiNetworkAPI getRaceQuestionListWithuid:uid timestamp:timeStamp sign:sign SuccessBlock:^(id returnData)
     {
         [self tableViewEndLoading];
         DEF_DEBUG(@"问题列表：%@",returnData);
         //正在抢答的律师数量
         NSString *lawyerCount = [NSString stringWithFormat:@"%@",returnData[@"num"]];
         self.lawyerCount =lawyerCount;
         [self addCurrentIsRaceQuestionLawyerNumberWithNumber:lawyerCount];

         //
         NSString *ret = returnData[@"ret"];
         NSString *msg = returnData[@"msg"];
         if ([ret integerValue]==0)
         {
             NSMutableArray *questionList = returnData[@"data"];
             DEF_DEBUG(@"问题列表数组个数：%ld",(unsigned long)questionList.count);
             if (questionList.count == 0)
             {
                 if (refreshFlag)
                 {
                     [tableViewData removeAllObjects];
                     [DataHander showInfoWithTitle:@"亲，暂时没有问题"];
                 }
             }
             else
             {
                 [DataHander hideDlg];
                 if (refreshFlag)
                 {
                     [tableViewData removeAllObjects];
                 }
                 for (NSDictionary *dict in questionList)
                 {
                     [tableViewData addObject:dict];
                 }
             }
         }
         else
         {
             [DataHander hideDlg];
             SHOW_ALERT(msg);
         }
         [self.homeCloseTableView reloadData];
     } failureBlock:^(NSError *error) {
         [self tableViewEndLoading];
     } showHUD:NO];
}

#pragma mark - 是否允许自动抢答
-(void)automaticRaceQuestionWithEnable_race:(NSString *)enable_race
{
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = [NSString stringWithFormat:@"%@%@",DEF_API_Lawyer,uid];
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    [MHAsiNetworkAPI automaticRaceQuestionByuid:uid timestamp:timeStamp sign:sign enable_race:enable_race SuccessBlock:^(id returnData) {
        DEF_DEBUG(@"自动抢答接口返回的数据：%@",returnData);
        
        NSString *ret = returnData[@"ret"];
        NSString *msg = returnData[@"msg"];
        if ([ret isEqualToString:@"0"])
        {
            DEF_PERSISTENT_SET_OBJECT([NSNumber numberWithBool:self.theSwitch.isOn], @"autoRace");
        }
        else
        {
            SHOW_ALERT(msg);
        }
    } failureBlock:^(NSError *error) {
    } showHUD:YES];
}

#pragma mark - 添加多少位律师正在抢答的数据
-(void)addCurrentIsRaceQuestionLawyerNumberWithNumber:(NSString *)lawyerCount
{
    if (self.theSwitch.isOn)
    {
        if ([NSString isBlankString:lawyerCount]) {
            lawyerCount = @"0";
        }
        float rangelength = lawyerCount.length;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"有%@位律师正在抢答问题",lawyerCount]];
        [str addAttribute:NSForegroundColorAttributeName value:DEF_RGB_COLOR(255, 113, 53) range:NSMakeRange(1,rangelength)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(1, rangelength)];
        self.questionLab.attributedText = str;
    }
}

#pragma mark - 开启或者关闭抢答
-(void)switchBtnClick:(UISwitch *)swi
{
    // enable_race   抢答开关(1是开启，-1是关闭)默认是1开启状态
    if (swi.on==YES)
    {
        [MobClick event:@"LawGetQ_on"];
        //
        if ([NSString isBlankString:_lawyerCount])
        {
            _lawyerCount = @"0";
        }
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"有%@位律师正在抢答问题",_lawyerCount]];
        [str addAttribute:NSForegroundColorAttributeName value:DEF_RGB_COLOR(248, 90, 40) range:NSMakeRange(1,_lawyerCount.length)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(1, _lawyerCount.length)];
        [self.questionLab setAttributeText:str withDirection:DirectionRight];
        
        [self automaticRaceQuestionWithEnable_race:@"1"];
    }
    else
    {
        [MobClick event:@"LawGetQ_Off"];
        [self.questionLab setAttributeText:[[NSAttributedString alloc] initWithString:@"允许问题自动抢答"] withDirection:DirectionLeft];
        [self automaticRaceQuestionWithEnable_race:@"-1"];
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableViewData count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    HomeOpenCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[HomeOpenCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIView  *backView = [[UIView alloc]initWithFrame:cell.bounds];
        cell.selectedBackgroundView = backView;
        backView.backgroundColor = DEF_RGB_COLOR(250, 250, 250);        
        
    }
    cell.backgroundColor = [UIColor clearColor];
    NSDictionary *questionDict = [tableViewData objectAtIndex:indexPath.row];
    [cell loadCellWithDict:questionDict];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *lawerDict = [tableViewData objectAtIndex:indexPath.row];
    CGFloat height = [HomeOpenCell heightForCellWithDict:lawerDict];
    return  height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (tableViewData.count > button.tag)
//    {
    NSDictionary *dict = [tableViewData objectAtIndex:indexPath.row];

        RaceQuestionViewController *raceViewController = [[RaceQuestionViewController alloc] init];
        raceViewController.questionDetailDict = dict;
        [MobClick event:@"LawGetQ_Click" attributes:@{@"question_ID":dict[@"id"]}];
        raceViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:raceViewController animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 下拉刷新上啦加载
#pragma mark - pullReflreshDelegate
-(void)tableViewEndLoading
{
    [self.homeCloseTableView tableViewDidFinishedLoading];
}
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    [MobClick event:@"LawGetQ_UP"];
    [self requestTableDataWithRefresh:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.homeCloseTableView tableViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.homeCloseTableView tableViewDidEndDragging:scrollView];
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
