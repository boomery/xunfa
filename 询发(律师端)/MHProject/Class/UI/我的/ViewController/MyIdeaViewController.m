//
//  MyIdeaViewController.m
//  MHProject
//
//  Created by 张好志 on 15/6/24.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "MyIdeaViewController.h"
#import "MyIdeaTableViewCell.h"
#import "QuestionListDetailViewController.h"
@interface MyIdeaViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (nonatomic,strong) UITableView    *myIdeaTableView;
@property (nonatomic,strong) NSMutableArray *myIdeaArray;
@end

@implementation MyIdeaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = DEF_RGB_COLOR(244, 244, 244);
    
    [self initData];
    
    [self initNav];
    
    [self initUI];
    
    [self getMyIdeaDataByHttpRequest];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark -- 网络请求相关
//我的主意
-(void)getMyIdeaDataByHttpRequest
{
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = DEF_API_MyIdea;
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    [DataHander showDlg];
    [MHAsiNetworkAPI getMyIdeaInfoByuid:uid
                              timestamp:timeStamp
                                   sign:sign
                           SuccessBlock:^(id returnData)
    {
        DEF_DEBUG(@"我的主意接口返回数据%@",returnData);
        NSString *ret = returnData[@"ret"];
        NSString *msg = returnData[@"msg"];
        //给界面赋值
        if ([ret isEqualToString:@"0"])
        {
            NSArray *array = returnData[@"data"];
            if (array.count==0)
            {
                [DataHander showInfoWithTitle:@"亲，您还没有出过主意哦"];
            }
            else
            {
                [DataHander hideDlg];
                for (NSDictionary *dict in array)
                {
                    [self.myIdeaArray addObject:dict];
                }
                [self.myIdeaTableView reloadData];
            }
        }
        else
        {
            [DataHander hideDlg];
            SHOW_ALERT(msg);
        }
        //
    } failureBlock:^(NSError *error) {
    } showHUD:NO];
}

#pragma mark -- 初始化相关
-(void)initNav
{
    [self showNavBarDefaultHUDByNavTitle:@"我出的主意" inView:self.view isBack:YES];

//    [self addNavBarTitle:@"我出的主意"];
//    [self addLeftNavBarBtnByImg:@"menu-left-back" andWithText:@""];
}

- (void)leftNavItemClick
{
    [super leftNavItemClick];
    [MobClick event:@"LawMyIdea_Back"];
}
-(void)initUI
{
    self.myIdeaTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, DEF_SCREEN_WIDTH,DEF_SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.myIdeaTableView.delegate = self;
    self.myIdeaTableView.dataSource = self;
    self.myIdeaTableView.backgroundColor = [UIColor clearColor];
    self.myIdeaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.myIdeaTableView];
}

-(void)initData
{
    self.myIdeaArray = [[NSMutableArray  alloc]init];
//    self.myIdeaArray = [[NSMutableArray alloc]initWithArray:@[@{@"introduce":@"老公有了外遇请私家侦探查一下，老公有了外遇请私家侦探查一下，老公有了外遇请私家侦探查一下，老公有了外遇请私家侦探查一下，老公有了外遇请私家侦探查一下",@"primary":@"原问题"},@{@"introduce":@"老公有了外遇请私家侦探查一下",@"primary":@"原问题"}]];
}

#pragma mark - UITableViewDetegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myIdeaArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"myIdeaCell";
    MyIdeaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[MyIdeaTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.questionBtn addTarget:self action:@selector(lookQuestionDetailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.questionBtn.tag = indexPath.row+300;
    
    NSDictionary *dict =self.myIdeaArray[indexPath.row];
    [cell  loadCellWithDict:dict];

    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict =self.myIdeaArray[indexPath.row];
    return [MyIdeaTableViewCell heightForCellWithDict:dict];
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    SHOW_ALERT(@"功能正在开发，请稍后。。。");
//}

#pragma mark --按钮点击事件
-(void)lookQuestionDetailBtnClick:(UIButton*)sender
{
    NSDictionary *dictionary = self.myIdeaArray[sender.tag - 300];
    QuestionListDetailViewController *detail = [[QuestionListDetailViewController alloc] init];
    detail.questionID = dictionary[@"question_id"];
    [MobClick event:@"LawMyIdea_Click" attributes:@{@"question_ID":dictionary[@"question_id"]}];
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
