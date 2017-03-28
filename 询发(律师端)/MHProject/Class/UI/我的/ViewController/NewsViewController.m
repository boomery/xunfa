//
//  NewsViewController.m
//  MHProject
//
//  Created by 张好志 on 15/6/24.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "QuestionHuDongViewController.h"
#import "NewsViewController.h"
#import "MessageManager.h"
#import "MyInfoNewTableViewCell.h"
#import "QuestionModel.h"
#import "QuestionListDetailViewController.h"
@interface NewsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property(strong,nonatomic)UITableView    *myInformationTableView;
@property(strong,nonatomic)NSMutableArray *myInforArray;

@end

@implementation NewsViewController

#pragma mark -- 请求相关
//我的消息
-(void)getMyMessageDataByHttpRequest
{
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = DEF_API_getMyMessage;
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    [DataHander showDlg];
    [MHAsiNetworkAPI getMyMessageWithuid:uid timestamp:timeStamp sign:sign SuccessBlock:^(id returnData) {
        DEF_DEBUG(@"我的消息接口返回数据%@",returnData);
        NSString *ret = returnData[@"ret"];
        NSString *msg = returnData[@"msg"];
        //给界面赋值
        if ([ret isEqualToString:@"0"])
        {
            NSArray *dataArr = returnData[@"data"];
            if (dataArr.count==0)
            {
                [DataHander showInfoWithTitle:@"亲，暂无消息"];
            }
            else
            {
                [DataHander hideDlg];
                CGFloat unreadNumber = 0;
                [self.myInforArray removeAllObjects];
                
                for (NSDictionary *myInfoDict in dataArr)
                {
                    NSString *is_read = myInfoDict[@"is_read"];
                    if ([is_read isEqualToString:@"0"])
                    {
                        unreadNumber++;
                    }
                    [self.myInforArray addObject:myInfoDict];
                }
                [self.myInformationTableView reloadData];
                [MessageManager setUnreadMessageWithNSInetgerNumber:unreadNumber];
            }
        }
        else
        {
            [DataHander hideDlg];
            SHOW_ALERT(msg);
        }
        
    } failureBlock:^(NSError *error) {
    } showHUD:NO];
}

#pragma mark -- view lifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
    
    [self initNav];
    //
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMyMessageDataByHttpRequest) name:@"reloadNews" object:nil];
    [self getMyMessageDataByHttpRequest];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -- 初始化
-(void)initNav
{
    [self showNavBarDefaultHUDByNavTitle:@"我的消息" inView:self.view isBack:NO];
}
- (void)leftNavItemClick
{
    [MobClick event:@"LawMsg_Back"];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initUI
{
    if (!self.myInformationTableView)
    {
        self.myInformationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - 64-50) style:UITableViewStylePlain];
        self.automaticallyAdjustsScrollViewInsets = YES;
        self.myInformationTableView.backgroundColor = [UIColor clearColor];
        self.myInformationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.myInformationTableView.delegate = self;
        self.myInformationTableView.dataSource = self;
        [self.view addSubview:self.myInformationTableView];
    }
}
-(void)initData
{
    self.myInforArray = [[NSMutableArray alloc]init];
}

#pragma mark - UITableViewDategate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myInforArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"mynewsCell";
    
    MyInfoNewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[MyInfoNewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dic = self.myInforArray[indexPath.row];
    [cell loadCellWithDict:dic];

    //
    if (indexPath.row==0) {
        cell.topLine.hidden = YES;
    }else{
        cell.topLine.hidden = NO;
    }
    if (indexPath.row==self.myInforArray.count-1) {
        cell.bottomLine.hidden = NO;
    }else{
        cell.bottomLine.hidden = YES;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.myInforArray[indexPath.row];
    return [MyInfoNewTableViewCell heightForCellWithDict:dic];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.myInforArray[indexPath.row];
    NSString *qid = dic[@"qid"];
    NSString *aid = dic[@"aid"];
    NSString *messageId = dic[@"id"];
    [MobClick event:@"LawMsg_Click" attributes:@{@"message_ID":messageId}];
    NSString *isRead = dic[@"is_read"];
    if ([isRead isEqualToString:@"0"])
    {
        [self updateMessageWithID:messageId];
        [MessageManager minusUnreadMessage];
    }
    //进入互动页面
    if (aid)
    {
        QuestionHuDongViewController *hudVC = [[QuestionHuDongViewController alloc] init];
        hudVC.hidesBottomBarWhenPushed = YES;
        hudVC.messageID = messageId;
        hudVC.questionID = qid;
        hudVC.answerID = aid;
        hudVC.canEdit = YES;
        hudVC.isFromNews = YES;
        [self.navigationController pushViewController:hudVC animated:YES];
    }
    //进入详情页面
    else
    {
        QuestionListDetailViewController *detail = [[QuestionListDetailViewController alloc] init];
        detail.hidesBottomBarWhenPushed = YES;
        detail.questionID = qid;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (void)updateMessageWithID:(NSString *)messageID
{
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = [NSString stringWithFormat:@"%@/%@",DEF_API_updateMessage,messageID];
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    [MHAsiNetworkAPI updateMyMessageWithuid:uid timestamp:timeStamp sign:sign messageID:messageID SuccessBlock:^(id returnData) {
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}
- (void)didReceiveMemoryWarning
{
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
