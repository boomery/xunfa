//
//  MyCollectionViewController.m
//  MHProject
//
//  Created by 张好志 on 15/6/24.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "QuestionModel.h"
#import "QuestionCustomCell.h"
#import "QuestionListDetailViewController.h"
#import "LawerTableViewCell.h"
#import "UserCenterViewController.h"
#import "MycollectionQuestionCell.h"
#import "MyCollectionLawyerNewCell.h"

#define  questionTableViewTag 222
#define  lawerTableViewTag  223


@interface MyCollectionViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UITableView *questionTableView;
@property (nonatomic,strong) UITableView *lawerTableView;
@property (nonatomic,strong) NSMutableArray *questionsArray;
@property (nonatomic,strong) NSMutableArray *lawersArray;
@property (nonatomic,assign) NSInteger index;

//@property (nonatomic,strong) NSMutableArray *

@end

@implementation MyCollectionViewController

#pragma mark -- 网络请求相关
//我收藏的问题
-(void)getMyFavoriteQuestionDataByHttpRequest
{
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = DEF_API_MyFavoriteQuestion;
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    [DataHander showDlg];
    [MHAsiNetworkAPI getMyFavoriteQuestionInfoByuid:uid timestamp:timeStamp sign:sign SuccessBlock:^(id returnData) {
        DEF_DEBUG(@"我收藏的问题接口返回数据%@",returnData);
        NSString *ret = returnData[@"ret"];
        NSString *msg = returnData[@"msg"];
        
        //给界面赋值
        if ([ret isEqualToString:@"0"])
        {
            [self.questionsArray removeAllObjects];
            NSArray *dataArr = returnData[@"data"];
            if (dataArr.count == 0)
            {
//                [DataHander showInfoWithTitle:@"亲，您还没有收藏问题"];
            }
            else
            {
                for (NSDictionary *dic in dataArr)
                {
                    [self.questionsArray addObject:dic];
                }
            }
            [DataHander hideDlg];
            [self.questionTableView reloadData];
        }
        else
        {
            [DataHander hideDlg];
            SHOW_ALERT(msg);
        }
    } failureBlock:^(NSError *error) {
    } showHUD:NO];
}
//我收藏的律师
-(void)getMyFavoriteLawerDataByHttpRequest
{
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = DEF_API_MyFavoriteLawer;
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    [DataHander showDlg];
    [MHAsiNetworkAPI getMyFavoriteLawersInfoByuid:uid
                                        timestamp:timeStamp
                                             sign:sign
                                     SuccessBlock:^(id returnData)
     {
         DEF_DEBUG(@"我收藏的律师接口返回数据%@",returnData);
         
         //
         NSString *ret = returnData[@"ret"];
         NSString *msg = returnData[@"msg"];
         
         //给界面赋值
         if ([ret isEqualToString:@"0"])
         {
             [self.lawersArray removeAllObjects];
             NSMutableArray *dataArr = returnData[@"data"];
             if (dataArr.count == 0)
             {
//                 [DataHander showInfoWithTitle:@"亲，您还没有收藏律师"];
             }
             else
             {
                 for (NSDictionary *dic in dataArr)
                 {
                     [self.lawersArray addObject:dic];
                 }
             }
             [DataHander hideDlg];
             [self.lawerTableView reloadData];
         }
         else
         {
             [DataHander hideDlg];
             SHOW_ALERT(msg);
         }
     } failureBlock:^(NSError *error) {
     } showHUD:NO];
}

#pragma mark -- view lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatContScrollView];
    
    [self initData];
    
    [self initNav];
    
    [self initUI];
    
    [self getMyFavoriteQuestionDataByHttpRequest];
}

#pragma mark -- 初始化
-(void)initNav
{
    [self showNavBarDefaultHUDByNavTitle:self.title inView:self.view isBack:YES];
}
- (void)leftNavItemClick
{
    [super leftNavItemClick];
    [MobClick event:@"LawMyFav_Back"];
}
-(void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSArray *titles = @[@"问题",@"律师"];
    self.titleBar = [[MyTitleBar alloc] initWithFrame:CGRectMake(0, 64, DEF_SCREEN_WIDTH, 40) withTitleArray:titles];
    __block MyCollectionViewController *weakSelf = self;
    self.titleBar.titleBlock = ^(long index){
        weakSelf.index = index;
        if (index==0)
        {
            [MobClick event:@"LawMyFav_TabQuestion"];
            [weakSelf getMyFavoriteQuestionDataByHttpRequest];
            
        }
        else
        {
            [MobClick event:@"LawMyFav_TabLaw"];
            [weakSelf getMyFavoriteLawerDataByHttpRequest];
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.contentScrollView.contentOffset = CGPointMake(index*DEF_SCREEN_WIDTH, 0);
        }];
    };
    [self.view addSubview:self.titleBar];
    //分页
    self.contentScrollView.contentSize = CGSizeMake(DEF_SCREEN_WIDTH*2,0);
    self.contentScrollView.pagingEnabled = YES;
    //    self.contentScrollView.delegate = self;
    self.contentScrollView.scrollEnabled = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    
    float y = 40;
    self.questionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, y, DEF_SCREEN_WIDTH,DEF_SCREEN_HEIGHT-64-y-10) style:UITableViewStylePlain];
    self.questionTableView.delegate = self;
    self.questionTableView.dataSource = self;
    self.questionTableView.tag = questionTableViewTag;
    self.questionTableView.backgroundColor = [UIColor clearColor];
    self.questionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentScrollView addSubview:self.questionTableView];
    
    self.lawerTableView = [[UITableView alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH, DEF_TOP(self.questionTableView), DEF_WIDTH(self.questionTableView),DEF_SCREEN_HEIGHT-64-y) style:UITableViewStylePlain];
    self.lawerTableView.delegate = self;
    self.lawerTableView.dataSource = self;
    self.lawerTableView.tag = lawerTableViewTag;
    self.lawerTableView.backgroundColor = [UIColor clearColor];
    self.lawerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentScrollView addSubview:self.lawerTableView];
}

-(void)initData
{
    self.questionsArray = [[NSMutableArray alloc]init];
    self.lawersArray = [[NSMutableArray alloc]init];
}
#pragma mark - UITableViewDetegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.index == 0)
    {
        return self.questionsArray.count;
    }
    else
    {
        return  self.lawersArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 0)
    {
        static NSString *cellIdentifier = @"cell";
        MycollectionQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell = [[MycollectionQuestionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *questionDict = [self.questionsArray objectAtIndex:indexPath.row];
        [cell loadCellWithDict:questionDict];
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"lawerCell";
        MyCollectionLawyerNewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell = [[MyCollectionLawyerNewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];

        }
        
        [cell.lawerHeadImageBtn addTarget:self action:@selector(headImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.lawerHeadImageBtn.tag = indexPath.row;
        
        NSDictionary *lawerDict = [self.lawersArray objectAtIndex:indexPath.row];
        [cell loadCellWithDict:lawerDict];
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 0)
    {
        NSDictionary *lawerDict = [self.questionsArray objectAtIndex:indexPath.row];
        
        return  [MycollectionQuestionCell heightForCellWithDict:lawerDict];
    }
    else
    {
//        NSDictionary *lawerDict = [self.lawersArray objectAtIndex:indexPath.row];
//        
//        return [MyCollectionLawyerNewCell heightForCellWithDict:lawerDict];
        return 10+10+34+8+10+20+10;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 0)
    {
        //        收藏的问题
        NSDictionary *lawerDict = [self.questionsArray objectAtIndex:indexPath.row];
        QuestionListDetailViewController *detail = [[QuestionListDetailViewController alloc]init];
        detail.questionID = lawerDict[@"question_id"];
        [MobClick event:@"LawMyFav_ClickQ" attributes:@{@"question_ID":lawerDict[@"question_id"]}];
        __weak MyCollectionViewController *weakSelf = self;
        detail.reloadBlock = ^{
            [weakSelf getMyFavoriteQuestionDataByHttpRequest];
        };
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if (self.index == 1)
    {
        NSDictionary *lawerDict = [self.lawersArray objectAtIndex:indexPath.row];
        UserCenterViewController *center = [[UserCenterViewController alloc]init];
        center.diction = lawerDict;
        [MobClick event:@"LawMyFav_ClickL" attributes:@{@"lawyer_ID":lawerDict[@"lawyer_id"]}];
        __weak MyCollectionViewController *weakSelf = self;
        center.reloadBlock = ^{
            [weakSelf getMyFavoriteLawerDataByHttpRequest];
        };
        [self.navigationController pushViewController:center animated:YES];

    }
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{//设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [self.questionTableView setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}
-(void)tableView:(UITableView *)tableView commitEditingStyle :( UITableViewCellEditingStyle)editingStyle forRowAtIndexPath :( NSIndexPath *)indexPath
{
    if(self.index == 0)
    {
        //        删除收藏的问题
        NSDictionary *questionDict = [self.questionsArray objectAtIndex:indexPath.row];
        
        
        
        NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
        NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
        NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
        NSString *url = DEF_API_DeleteMyFavorite;
        NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
        
        
        [MHAsiNetworkAPI deleteMyFavoriteInfoByuid:uid
                                         timestamp:timeStamp
                                              sign:sign
                                               act:@"question"
                                             idStr:questionDict[@"question_id"]
                                      SuccessBlock:^(id returnData)
         {
             [self.questionsArray removeObjectAtIndex:indexPath.row];
             [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
             [tableView reloadData];
             
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
         } showHUD:NO];
    }
    else
    {
        //        删除收藏的律师
        NSDictionary *lawersDict = [self.lawersArray objectAtIndex:indexPath.row];
        NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
        NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
        NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
        NSString *url = DEF_API_DeleteMyFavorite;
        NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
        [MHAsiNetworkAPI deleteMyFavoriteInfoByuid:uid
                                         timestamp:timeStamp
                                              sign:sign
                                               act:@"lawyer"
                                             idStr:lawersDict[@"lawyer_id"]
                                      SuccessBlock:^(id returnData)
         {
             DEF_DEBUG(@"%@",returnData);
             
             [self.lawersArray removeObjectAtIndex:indexPath.row];
             [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
             [tableView reloadData];
             
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
         } showHUD:NO];
    }
}
//改变删除按钮上的文字
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
#pragma mark -- UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    if (scrollView.contentOffset.x<DEF_SCREEN_WIDTH)
    //    {
    //        [self.titleBar setIndex:0];
    //    }
    //    else
    //    {
    //        [self.titleBar setIndex:1];
    //    }
}

#pragma mark -- 按钮点击事件
-(void)lawerPhoneBtnClick:(UIButton *)sender
{
    //    NSString *phone = self.lawersArray[sender.tag-200];
    if (sender.selected==YES)
    {
        NSString *phone = @"58890221";
        if (!phone)
        {
            //1、这种类型得到打电话会跳出应用程序
            //        NSString *allString = [NSString stringWithFormat:@"tel:10086"];
            //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
            
            //2、这种类型得到打电话在本应用程序之中
            UIWebView*callWebview =[[UIWebView alloc] init];
            NSString *telUrl = [NSString stringWithFormat:@"tel:%@",phone];
            NSURL *telURL =[NSURL URLWithString:telUrl];// 貌似tel:// 或者 tel: 都行
            [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
            [self.view addSubview:callWebview];        //记得添加到view上
        }
    }
    else
    {
        SHOW_ALERT(@"亲，您所拨打的律师不在线哦");
    }
}

-(void)headImageBtnClick:(UIButton *)btn
{
    NSDictionary *lawerDict = [self.lawersArray objectAtIndex:btn.tag];
    UserCenterViewController *center = [[UserCenterViewController alloc]init];
    center.diction = lawerDict;
    __weak MyCollectionViewController *weakSelf = self;
    center.reloadBlock = ^{
        [weakSelf getMyFavoriteLawerDataByHttpRequest];
    };
    [self.navigationController pushViewController:center animated:YES];
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
