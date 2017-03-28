//
//  MyQuestionViewController.m
//  MHProject
//
//  Created by 张好志 on 15/6/24.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "MyRaceQuestionViewController.h"
#import "MyRaceTableViewCell.h"
#import "QuestionListDetailViewController.h"
@interface MyRaceQuestionViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *myQuestionTableView;
@property (nonatomic,strong) NSMutableArray *myQuestionsArray;

@end

@implementation MyRaceQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
    [self initNav];
    
    [self initUI];
    
    [self getMyAnwerDataByHttpRequest];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
#pragma mark -- 网络请求相关
#pragma mark -- 网络请求相关
//我的抢答
-(void)getMyAnwerDataByHttpRequest
{
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = DEF_API_getMyRaceQuestionAnswer;
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    [DataHander showDlg];
    [MHAsiNetworkAPI getMyRaceQuestionAnswerWithuid:uid
                                          timestamp:timeStamp
                                               sign:sign
                                       SuccessBlock:^(id returnData)
    {
        DEF_DEBUG(@"我的抢答接口返回数据%@",returnData);
        NSString *ret = returnData[@"ret"];
        NSString *msg = returnData[@"msg"];
     
        //给界面赋值
        if ([ret isEqualToString:@"0"])
        {
            NSArray *array = returnData[@"data"];
            if (array.count==0)
            {
                [DataHander showInfoWithTitle:@"亲，您还没有抢答过问题，请到抢答模块前去抢答"];
            }
            else
            {
                [DataHander hideDlg];
                for (NSDictionary *dict in array)
                {
                    [self.myQuestionsArray addObject:dict];
                }
            }
        }
        else
        {
            [DataHander hideDlg];
            SHOW_ALERT(msg);
        }
        //
        [self.myQuestionTableView reloadData];
    } failureBlock:^(NSError *error) {
    } showHUD:NO];
    
}
#pragma mark -- 初始化
-(void)initNav
{
    [self showNavBarDefaultHUDByNavTitle:@"我的抢答" inView:self.view isBack:YES];
}
- (void)leftNavItemClick
{
    [super leftNavItemClick];
    [MobClick event:@"LawMyAnswer_Back"];
}
-(void)initUI
{
    self.myQuestionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, DEF_SCREEN_WIDTH,DEF_SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.myQuestionTableView.delegate = self;
    self.myQuestionTableView.dataSource = self;
    self.myQuestionTableView.backgroundColor = [UIColor clearColor];
    self.myQuestionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.myQuestionTableView];
}
-(void)initData
{
    self.myQuestionsArray = [[NSMutableArray alloc]init];
}
#pragma mark -- UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myQuestionsArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"myIdeaCell";
    MyRaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[MyRaceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIView *backgroundView = [[UIView alloc] initWithFrame:cell.frame];
        [cell addSubview:backgroundView];
        backgroundView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
        cell.selectedBackgroundView = backgroundView;
    }
    NSDictionary *dict =self.myQuestionsArray[indexPath.row];
    [cell loadCellWithRaceQuestionDict:dict];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict =self.myQuestionsArray[indexPath.row];
    return [MyRaceTableViewCell heightForCellWithRaceQuestionDict:dict];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict =self.myQuestionsArray[indexPath.row];
    QuestionListDetailViewController *detail = [[QuestionListDetailViewController alloc] init];
    detail.questionID = dict[@"question_id"];
    [MobClick event:@"LawMyAnswer_Click" attributes:@{@"question_ID":dict[@"question_id"]}];
    [self.navigationController pushViewController:detail animated:YES];
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
