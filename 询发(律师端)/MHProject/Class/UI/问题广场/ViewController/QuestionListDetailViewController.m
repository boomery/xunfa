//
//  QuestionListDetailViewController.m
//  MHProject
//
//  Created by 张好志 on 15/7/6.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "QuestionListDetailViewController.h"
#import "HeaderView.h"
#import "QuestionDetailCell.h"
#import "RaiseIdeaViewController.h"
#import "HZUtil.h"
#import "UserCenterViewController.h"
#import "QuestionHuDongViewController.h"
#import "MyInfoViewController.h"
#import "MCFireworksButton.h"
@interface QuestionListDetailViewController () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property(nonatomic,strong)NSMutableArray *allDataArr;;// 用户评论
@property(nonatomic,strong)UILabel *indexLable;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)UIButton *reportBtn;

@end

@implementation QuestionListDetailViewController
#pragma mark -- 网络请求相关
-(void)getQuestionDetailRequest
{
    if (self.questionDetailDict)
    {
        [self reloadHeaderView];
        [self initUI];
        [self getQuestionAnswer];
        return;
    }
    NSString *question_idStr = self.questionID;
    __weak QuestionListDetailViewController *weakSelf = self;
    
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = [NSString stringWithFormat:@"%@/%@",DEF_API_Question_AllDetail,question_idStr];
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    [MHAsiNetworkAPI getQuestionAllDetailWithUid:uid timestamp:timeStamp sign:sign Question_id:question_idStr SuccessBlock:^(id returnData) {
        NSString *ret = returnData[@"ret"];
        NSString *msg = returnData[@"msg"];
        if ([ret isEqualToString:@"0"])
        {
            NSDictionary *dataDict =returnData[@"data"];
            NSDictionary *detailDict =dataDict[@"question"];
            weakSelf.questionDetailDict = detailDict;
            [weakSelf initUI];
            [weakSelf reloadHeaderView];
            [weakSelf getQuestionAnswer];
        }
        else
        {
            SHOW_ALERT(msg);
        }
    } failureBlock:^(NSError *error) {
    } showHUD:YES];
}
- (void)getQuestionAnswer
{
    __weak QuestionListDetailViewController *weakSelf = self;
    
    [MHAsiNetworkAPI getQuestionDetailQuestion_id:self.questionID SuccessBlock:^(id returnData) {
        NSString *ret = returnData[@"ret"];
        NSString *msg = returnData[@"msg"];
        if ([ret isEqualToString:@"0"])
        {
            NSDictionary *dataDict =returnData[@"data"];
            //            NSDictionary *detailDict =dataDict[@"question"];
            
            [weakSelf.allDataArr removeAllObjects];
            //律师回复数据
            NSArray *answerArr = dataDict[@"answer"];
            
            NSMutableArray *replyArr = [[NSMutableArray alloc]init];
            for (NSDictionary *answerDic in answerArr)
            {
                [replyArr addObject:answerDic];
            }
            if ([replyArr count] > 0)
            {
                [weakSelf.allDataArr addObject:replyArr];
            }
            
            //用户评论的数据
            NSArray *pingArr = dataDict[@"ping"];
            NSMutableArray *commentArr = [[NSMutableArray alloc]init];
            for (NSDictionary *pingDic in pingArr)
            {
                [commentArr addObject:pingDic];
            }
            if ([commentArr count] > 0)
            {
                [weakSelf.allDataArr addObject:commentArr];
            }
            //
            [weakSelf.questionDetalTableView reloadData];
        }
        else
        {
            SHOW_ALERT(msg);
        }
    } failureBlock:^(NSError *error) {
    } showHUD:YES];
}
//添加收藏
- (void)addMyFavoriteQuestionToServerWith:(UIButton *)btn
{
    //
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = DEF_API_AddFavoriteQuestion;
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    NSString *questionID =self.questionDetailDict[@"question_id"];
    //
    [MHAsiNetworkAPI addMyFavoriteQuestionInfoByuid:uid
                                          timestamp:timeStamp
                                               sign:sign
                                        question_id:questionID
                                       SuccessBlock:^(id returnData)
     {
         DEF_DEBUG(@"添加收藏接口返回的数据：%@",returnData);
         
         NSString *ret = returnData[@"ret"];
         NSString *msg = returnData[@"msg"];
         //        NSDictionary *data = returnData[@"data"];
         //给界面赋值
         if ([ret isEqualToString:@"0"])
         {
             [DataHander showSuccessWithTitle:@"收藏成功"];
             [self.questionDetailDict setValue:@"1" forKey:@"is_favorite"];
             btn.selected = YES;
             if (self.reloadBlock)
             {
                 self.reloadBlock();
             }
         }
         else
         {
             SHOW_ALERT(msg);
         }
     } failureBlock:^(NSError *error) {
     } showHUD:NO];
}
//删除收藏
- (void)deleteMyFavoriteQuestionToServerWith:(UIButton *)btn
{
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = DEF_API_DeleteMyFavorite;
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    [MHAsiNetworkAPI deleteMyFavoriteInfoByuid:uid
                                     timestamp:timeStamp
                                          sign:sign
                                           act:@"question"
                                         idStr:self.questionDetailDict[@"question_id"]
                                  SuccessBlock:^(id returnData)
     {
         DEF_DEBUG(@"删除收藏：%@",returnData);
         NSString *ret = returnData[@"ret"];
         NSString *msg = returnData[@"msg"];
         if ([ret isEqualToString:@"0"])
         {
             [DataHander showSuccessWithTitle:@"取消收藏"];
             [self.questionDetailDict setValue:@"0" forKey:@"is_favorite"];
             btn.selected = NO;
             if (self.reloadBlock)
             {
                 self.reloadBlock();
             }
         }
         else
         {
             SHOW_ALERT(msg);
         }
         
     } failureBlock:^(NSError *error) {
     } showHUD:NO];
}
//举报
-(void)reportQuestionToServer
{
    NSString *questionID =self.questionDetailDict[@"question_id"];
    //
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = [NSString stringWithFormat:@"%@/%@",DEF_API_tip_offQuestion,questionID];
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    [MHAsiNetworkAPI reportQuestionToServerWithuid:uid
                                         timestamp:timeStamp
                                              sign:sign
                                               qid:questionID
                                               act:@"question"
                                      SuccessBlock:^(id returnData)
     {
         NSString *ret = returnData[@"ret"];
         NSString *msg = returnData[@"msg"];
         if ([ret isEqualToString:@"0"])
         {
             [DataHander showSuccessWithTitle:@"举报成功"];
             [self.questionDetailDict setValue:@"1" forKey:@"is_tipoff"];

             UIButton *btn = (UIButton *)[self.view viewWithTag:100];
             [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
             [btn setTitle:@"已举报" forState:UIControlStateNormal];
             btn.enabled = NO;
         }
         else
         {
             SHOW_ALERT(msg);
         }
         
     } failureBlock:^(NSError *error) {
     } showHUD:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initData];
    [self initNav];
}

- (void)dealloc
{
    
}
#pragma mark - 初始化
- (void)initData
{
    self.allDataArr = [[NSMutableArray alloc]init];
    [self getQuestionDetailRequest];
}

-(void)initUI
{
    [self.questionDetalTableView removeFromSuperview];
    [self.bottomView removeFromSuperview];
    
    //4、表
    self.questionDetalTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT-64 - 50) style:UITableViewStyleGrouped];
    self.questionDetalTableView.delegate = self;
    self.questionDetalTableView.dataSource = self;
    self.questionDetalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.questionDetalTableView];
    self.questionDetalTableView.backgroundColor = [UIColor clearColor];
    self.questionDetalTableView.tableHeaderView =self.headerView;
    self.questionDetalTableView.showsVerticalScrollIndicator = NO;
    [self creatBottomView];
}
- (void)reloadHeaderView
{
    float fontSize = 16;
    
    float height =  [HZUtil getHeightWithString:self.questionDetailDict[@"content"] fontSize:fontSize width:DEF_SCREEN_WIDTH-20];
    //表头
    //1、表头问题
    NSArray *imageArr = self.questionDetailDict[@"image"];
    if ([imageArr count] > 0)//有图片的问题
    {
        self.headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, height + 193) withDictionary:self.questionDetailDict isContainImage:YES];
    }
    else//没有图片的问题
    {
        self.headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, height + 83) withDictionary:self.questionDetailDict isContainImage:NO];
    }
    self.headerView.backgroundColor = [UIColor whiteColor];
    //2、收藏
    [self.headerView.collecBtn addTarget:self action:@selector(collecBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //3、举报
    [self.headerView.reportBtn addTarget:self action:@selector(reportBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.headerView.reportBtn.tag = 100;
    self.reportBtn = self.headerView.reportBtn;
    self.questionDetalTableView.tableHeaderView = self.headerView;
    [self.questionDetalTableView reloadData];
}
-(void)initNav
{
    [self showNavBarDefaultHUDByNavTitle:@"问题详情" inView:self.view isBack:YES];
//    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:shareBtn];
//    shareBtn.frame = CGRectMake(DEF_SCREEN_WIDTH - 54, 20, 44, 44);
//    [shareBtn setImage:[UIImage imageNamed:@"top_menu_share" ] forState:UIControlStateNormal];
//    shareBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
//创建底部视图
-(void)creatBottomView
{
    //下方
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,DEF_SCREEN_HEIGHT- 50, DEF_SCREEN_WIDTH, 50)];
    bottomView.backgroundColor = DEF_RGBA_COLOR(255, 255, 255, 1);
    bottomView.layer.borderWidth = LINE_HEIGHT;
    bottomView.layer.borderColor = DEF_RGB_COLOR(214, 213, 217).CGColor;
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:bottomBtn];
    bottomBtn.layer.masksToBounds = YES;
    bottomBtn.layer.cornerRadius = 3;
    bottomBtn.frame = CGRectMake(24, 8, DEF_SCREEN_WIDTH-48, 34);
    [bottomBtn setImage:[UIImage imageNamed:@"botm_edit"] forState:UIControlStateNormal];
    NSString *uidStr = self.questionDetailDict[@"uid"];
    NSString *userId = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    if ([uidStr isEqualToString:userId])
    {
        [bottomBtn setTitle:@"我也来说两句" forState:UIControlStateNormal];
        if (DEF_SCREEN_WIDTH == 320.0)
        {
            bottomBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 80, 0, DEF_SCREEN_WIDTH/2);
        }
    }
    else
    {
        [bottomBtn setTitle:@"我给TA出个主意" forState:UIControlStateNormal];
        if (DEF_SCREEN_WIDTH == 320.0)
        {
            bottomBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 70.0, 0, DEF_SCREEN_WIDTH/2);
        }
    }
    //
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomBtn.titleLabel.font = DEF_Font(13.5);
    [bottomBtn addTarget:self action:@selector(giveIdeaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.backgroundColor = DEF_RGB_COLOR(60, 153, 230);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <=0)
    {
        CGPoint point = CGPointMake(0, 0);
        scrollView.contentOffset = point;
        return;
    }
}
#pragma mark - UITableViewDetegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.allDataArr.count +1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.allDataArr.count > section)
    {
        NSArray *array = self.allDataArr[section];
        return array.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    QuestionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[QuestionDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIView *backgroundView = [[UIView alloc] initWithFrame:cell.frame];
        [cell addSubview:backgroundView];
        backgroundView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
        cell.selectedBackgroundView = backgroundView;
    }
    
    self.indexPath = indexPath;
    
    //头像的点击事件
    [cell.userImageBtn addTarget:self action:@selector(userImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.userImageBtn.indexPath = indexPath;
    cell.userImageBtn.tag = indexPath.row;
    
    //点赞的事件
    [cell.praiseBtn addTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.praiseBtn.tag = indexPath.row;
    cell.praiseBtn.indexPath = indexPath;
    
    //个人评价
    NSArray *array = self.allDataArr[indexPath.section];
    NSDictionary *commentDict = [array objectAtIndex:indexPath.row];
    NSString *select = commentDict[@"selected_state"];
    
    //
    if (indexPath.row == 0) {
        cell.topImageLine.hidden = NO;
    }
    //
    if (indexPath.row == array.count-1)
    {
        cell.bottomShortLineImage.hidden = YES;
        cell.cellLastLine.hidden = NO;
    }
    else
    {
        cell.cellLastLine.hidden = YES;
        cell.bottomShortLineImage.hidden = NO;
    }
    
    //    判断是不是律师回复 是的话需要点击有变化，没有则没有变化
    if (!select)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell loadCellWithDict:commentDict WithHeadName:self.questionDetailDict[@"name"]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = self.allDataArr[indexPath.section];
    //个人评价
    NSDictionary *commentDict = [array objectAtIndex:indexPath.row];
    return  [QuestionDetailCell heightForCellWithDict:commentDict];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    if (self.allDataArr.count > section)
    {
        NSArray *array = self.allDataArr[self.indexPath.section];
        NSDictionary *dict = array[self.indexPath.row];
        NSString *select = dict[@"selected_state"];
        
        UIImageView *topLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, LINE_HEIGHT)];
        topLine.backgroundColor = DEF_RGB_COLOR(228, 228, 228);
        [view addSubview:topLine];
        
        UIImageView *bottomLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, DEF_SCREEN_WIDTH, LINE_HEIGHT)];
        bottomLine.backgroundColor = DEF_RGB_COLOR(228, 228, 228);
        [view addSubview:bottomLine];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, DEF_SCREEN_WIDTH - 20, 40)];
        lable.textColor = DEF_RGB_COLOR(111, 111, 111);
        lable.font = DEF_Font(16.0);
        [view addSubview:lable];
        if ([self.allDataArr count] == 2)
        {
            if (section == 0)
            {
                lable.text = @"律师回复";
            }
            else{
                lable.text = @"大家出的主意";
            }
        }
        else
        {
            if (select)
            {
                lable.text = @"律师回复";
            }
            else
            {
                lable.text = @"大家出的主意";
            }
        }
        return view;
    }
    UIImageView *topLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, LINE_HEIGHT)];
    topLine.backgroundColor = DEF_RGB_COLOR(214, 214, 217);
    [view addSubview:topLine];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *array = self.allDataArr[indexPath.section];
    NSDictionary *dict = array[indexPath.row];
    NSString *select = dict[@"selected_state"];
    if (select)
    {
        [MobClick event:@"LawQDetail_QandA" attributes:@{@"answer_ID":dict[@"id"]}];
        NSString *loginUid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
        NSString *lawyer_id = dict[@"lawyer_id"];
        QuestionHuDongViewController * VC = [[QuestionHuDongViewController alloc]init];
        VC.questionDetailDict = self.questionDetailDict;
        VC.answerDict = dict;
        VC.canEdit = [loginUid isEqualToString:lawyer_id];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark -- 按钮点击事件
//提出主意按钮点击事件
- (void)giveIdeaBtnClick:(UIButton *)sender
{
    [MobClick event:@"LawQDetail_Idea"];
    if (DEF_PERSISTENT_GET_OBJECT(DEF_loginToken))
    {
        RaiseIdeaViewController *vc =[[RaiseIdeaViewController alloc]init];
        __weak QuestionListDetailViewController *weakSelf = self;
        vc.giveIdeaSuccessBlock = ^{
            [weakSelf getQuestionAnswer];
            NSInteger ping_num = [weakSelf.questionDetailDict[@"ping_num"] integerValue] + 1;
            if (weakSelf.reloadBlock)
            {
                weakSelf.reloadBlock();
            }
            [weakSelf.questionDetailDict setValue:[NSString stringWithFormat:@"%zd",ping_num] forKey:@"ping_num"];
            weakSelf.headerView.rightBottomLable.text = [NSString stringWithFormat:@"%zd个主意",ping_num];
            
        };
        vc.questionDetailDict = self.questionDetailDict;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        SHOW_ALERT(@"亲，请先登录");
    }
}

- (void)leftNavItemClick
{
    [MobClick event:@"LawQDetail_Back"];
    [self.navigationController popViewControllerAnimated:YES];
}

//头像的点击事件
-(void)userImageBtnClick:(LawerHearImageBtn *)btn
{
    NSArray *btnArr = self.allDataArr[btn.indexPath.section];
    NSDictionary *dict = btnArr[btn.tag];
    NSString *userType = dict[@"user_type"];
    NSString *uid = dict[@"lawyer_id"];
    NSString *userId = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    if ([userType isEqualToString:@"2"])
    {
        //    判断是不是点击的自己的头像
        if ([uid isEqualToString:userId])
        {
            MyInfoViewController *myInfoView = [[MyInfoViewController alloc]init];
            myInfoView.userInfoDict = dict;
            [self.navigationController pushViewController:myInfoView animated:YES];
        }
        else
        {
            [MobClick event:@"LawQDetail_Lawer" attributes:@{@"lawyer_ID":dict[@"lawyer_id"]}];
            //      点击律师头像进去律师信息界面
            UserCenterViewController *userCenter = [[UserCenterViewController alloc]init];
            userCenter.diction = dict;
            [self.navigationController pushViewController:userCenter animated:YES];
        }
    }
}
// 收藏
-(void)collecBtnClick:(UIButton *)btn
{
    if (DEF_PERSISTENT_GET_OBJECT(DEF_loginToken))
    {
        if (btn.selected == NO)
        {
            [self addMyFavoriteQuestionToServerWith:btn];
        }
        else
        {
            [self deleteMyFavoriteQuestionToServerWith:btn];
        }
    }
    else
    {
        SHOW_ALERT(@"亲，请先登录");
//        [[AppDelegate appDelegate] presentLoginNav];
    }
    
}
//举报
-(void)reportBtnClick:(UIButton *)btn
{
    if (DEF_PERSISTENT_GET_OBJECT(DEF_loginToken))
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲，您确定要举报吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else
    {
        SHOW_ALERT(@"亲，请先登录");
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [self reportQuestionToServer];
    }
}
//点赞
-(void)praiseBtnClick:(MCFireworksButton *)btn
{
    btn.enabled = NO;
    if (DEF_PERSISTENT_GET_OBJECT(DEF_loginToken))
    {
        NSArray *btnArr = self.allDataArr[btn.indexPath.section];
        NSDictionary *dict = btnArr[btn.tag];
        [MobClick event:@"LawQDetail_ClickGood" attributes:@{@"answer_ID":dict[@"id"]}];
        NSString *selected_state = dict[@"selected_state"];
        NSString *actStr = nil;
        if (selected_state)
        {
            actStr = @"answer";
        }
        else
        {
            actStr = @"ping";
        }
        NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
        NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
        NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
        NSString *url = [NSString stringWithFormat:@"%@/%@",DEF_API_pointPraise,dict[@"id"]];
        NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
        __weak QuestionListDetailViewController *weakSelf = self;
        [MHAsiNetworkAPI pointPraiseQuestionToServerWithuid:uid timestamp:timeStamp sign:sign qid:dict[@"id"] act:actStr SuccessBlock:^(id returnData) {
            
            NSString *ret = returnData[@"ret"];
            //       NSString *msg = returnData[@"msg"];
            //给界面赋值
            if ([ret isEqualToString:@"0"])
            {
                btn.enabled = YES;
                btn.selected = YES;
                [btn popOutsideWithDuration:1];
                [btn setImage:[UIImage imageNamed:@"ic_laud_o"] forState:UIControlStateNormal];
                [btn animate];
                NSInteger pingNum = [dict[@"like_num"] integerValue] +1;
                [dict setValue:[NSString stringWithFormat:@"%ld",(long)pingNum] forKey:@"like_num"];
                [weakSelf.questionDetalTableView reloadData];
            }
            else
            {
                btn.enabled = YES;
                SHOW_ALERT(@"亲，您已经点过赞了!");
            }
        } failureBlock:^(NSError *error) {
            btn.enabled = YES;
        } showHUD:NO];
    }
    else
    {
        btn.enabled = YES;
        SHOW_ALERT(@"亲，请先登录");
    }
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
