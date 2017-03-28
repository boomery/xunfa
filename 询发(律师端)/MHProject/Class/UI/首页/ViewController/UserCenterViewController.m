//
//  UserCenterViewController.m
//  MHProject
//
//  Created by 杜宾 on 15/6/24.
//  Copyright (c) 2015年 Andy. All rights reserved.
//
#define BACK_IMAGE_HEIGHT 219

#import "UserCenterViewController.h"
#import "AboutPersonView.h"
#import "HZUtil.h"
#import "UserCenterBtn.h"
#import "LawyerCommentViewController.h"
#import "ShareView.h"
#import "UIImageView+WebCache.h"
#import "UIView+MHExtension.h"
#import "userCenterCustomView.h"
#import "UserLawyerInfoView.h"
@interface UserCenterViewController () <UIScrollViewDelegate>
{
    UIButton *indexBtn;
    
    ShareView *shareView;
    UIView *nameView;
}

@property(nonatomic,strong)UIScrollView     *userCenterScrollView;
@property(nonatomic,strong)UIImageView      *topImageView; // 底部的模糊图
@property(nonatomic,strong)UIView           *adeptView; //擅长领域
@property(nonatomic,strong)NSDictionary     *lawyerDict;
@property(nonatomic,strong)NSMutableArray   *lawerCommentArray;
@property(nonatomic,strong)UILabel          *evalueLable;//评价LB
@property(nonatomic,strong)userCenterCustomView *datiView;//评价LB
@property(nonatomic,strong)userCenterCustomView *dejiView;//评价LB
@property(nonatomic,strong)userCenterCustomView *jingliView;//评价LB
@property(nonatomic,strong)userCenterCustomView *pingjiaView;//评价LB

@property(nonatomic,strong)UserLawyerInfoView *practiceView;//执业证号

@property(nonatomic,strong)UserLawyerInfoView *beiJingView;//执业证号
@property(nonatomic,strong)UserLawyerInfoView *xiangGuanView;//执业证号
@property(nonatomic,strong)UserLawyerInfoView *jobView;//执业证号


@property(nonatomic,strong)UIButton *collecBtn;

@end

@implementation UserCenterViewController

#pragma mark -- http网络请求相关
- (void)addMyFavoriteLawerToServerWithBtn:(UIButton *)btn
{
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = DEF_API_AddFavoriteLawer;
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    __weak UserCenterViewController *weakSelf = self;
    [MHAsiNetworkAPI addMyFavoriteLawerToServerWithuid:uid
                                             timestamp:timeStamp
                                                  sign:sign
                                             lawyer_id:self.diction[@"lawyer_id"]
                                          SuccessBlock:^(id returnData)
     {
         DEF_DEBUG(@"添加收藏律师接口返回的数据：%@",returnData);
         
         NSString *ret = returnData[@"ret"];
         NSString *msg = returnData[@"msg"];
         //        NSDictionary *data = returnData[@"data"];
         DEF_DEBUG(@"%@",self.lawyerDict);
         
         //给界面赋值
         if ([ret isEqualToString:@"0"])
         {
             [DataHander showSuccessWithTitle:@"收藏成功"];
             btn.selected = YES;
             if (weakSelf.reloadBlock)
             {
                 weakSelf.reloadBlock();
             }
         }
         else
         {
             SHOW_ALERT(msg);
         }
     } failureBlock:^(NSError *error) {
     } showHUD:NO];
}
//删除我收藏的律师
-(void)deleteMyFavoriteLawerToserver:(UIButton *)btn
{
    //    NSString *lawerID = @"";
    //
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = DEF_API_DeleteMyFavorite;
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    __weak UserCenterViewController *weakSelf = self;
    [MHAsiNetworkAPI deleteMyFavoriteInfoByuid:uid
                                     timestamp:timeStamp
                                          sign:sign
                                           act:@"lawyer"
                                         idStr:self.diction[@"lawyer_id"]
                                  SuccessBlock:^(id returnData)
     {
         DEF_DEBUG(@"删除收藏的律师：%@",returnData);
         
         NSString *ret = returnData[@"ret"];
         NSString *msg = returnData[@"msg"];
         if ([ret isEqualToString:@"0"])
         {
             [DataHander showSuccessWithTitle:@"取消收藏"];
             btn.selected = NO;
             if (weakSelf.reloadBlock)
             {
                 weakSelf.reloadBlock();
             }
         }
         else
         {
             SHOW_ALERT(msg);
         }
     } failureBlock:^(NSError *error) {
     } showHUD:NO];
}

#pragma mark -- http网络请求相关
-(void)getLawyerPingDataByHttpRequest
{
    NSString *lawyerId = self.diction[@"lawyer_id"];
    
    
    
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = DEF_API_LawerPing;
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    [MHAsiNetworkAPI getLawerPingWithUid:uid timestamp:timeStamp sign:sign lawyer_id:lawyerId SuccessBlock:^(id returnData) {
        DEF_DEBUG(@"律师的评价信息返回的数据：%@",returnData);
        
        NSString *msg = returnData[@"msg"];
        NSString *ret = returnData[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            NSArray *dataArray = returnData[@"data"];
            NSMutableArray *lawercommerArr = [[NSMutableArray alloc]init];
            for (NSDictionary *dict in dataArray)
            {
                [lawercommerArr addObject:dict];
            }
            self.pingjiaView.topNumberLabl.text = [NSString stringWithFormat:@"%lu",(unsigned long)lawercommerArr.count];
            
            [self.lawerCommentArray addObjectsFromArray:lawercommerArr];
        }
        else{
            SHOW_ALERT(msg);
        }
        
    } failureBlock:^(NSError *error) {
    } showHUD:NO];
}
#pragma mark -- view lifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavUI];
    
    [self getRequestData];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark -- 初始化相关
// 导航
-(void)setNavUI
{
    [self showNavBarDefaultHUDByNavTitle:@"律师信息" inView:self.view isBack:YES];
    //分享和收藏
//    UIButton *sharBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:sharBtn];
//    sharBtn.frame = CGRectMake(DEF_SCREEN_WIDTH - 45, 24, 35, 35);
//    [sharBtn setImage:[UIImage imageNamed:@"icb-share"] forState:UIControlStateNormal];
//    [sharBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
//    sharBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

//分享
-(void)shareClick:(UIButton *)btn
{
    [self shareBtnClick];
}
-(void)collecBtn:(UIButton *)btn
{
    if (btn.selected == NO)
    {
        [self addMyFavoriteLawerToServerWithBtn:btn];
    }
    else
    {
        [self deleteMyFavoriteLawerToserver:btn];
    }
}
-(void)getRequestData
{
    self.lawerCommentArray = [[NSMutableArray alloc]init];
    NSString *lawyerId = self.diction[@"lawyer_id"];
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = [NSString stringWithFormat:@"%@%@",DEF_API_Lawyer,lawyerId];
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    
    [MHAsiNetworkAPI getLawyerInfoByuid:uid timestamp:timeStamp sign:sign lawyer_id:lawyerId SuccessBlock:^(id returnData){
        
        DEF_DEBUG(@"%@",returnData);
        
        NSString *ret = returnData[@"ret"];
        NSString *msg = returnData[@"msg"];
        //给界面赋值
        if ([ret isEqualToString:@"0"])
        {
            NSDictionary *dict = returnData[@"data"];
            [self initUIWithDiction:dict];
        }
        else
        {
            SHOW_ALERT(msg);
        }
    } failureBlock:^(NSError *error) {
    } showHUD:NO];
}

// 界面
-(void)initUIWithDiction:(NSDictionary *)dict
{
    self.lawyerDict = dict;
    //创建大的底视图
    if (!self.userCenterScrollView)
    {
        self.userCenterScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - 64)];
        self.userCenterScrollView.showsVerticalScrollIndicator = NO;
        self.userCenterScrollView.delegate = self;
        [self.view addSubview:self.userCenterScrollView];
    }
    //顶部视图
    [self userCenterTopView];
    CGFloat height = DEF_HEIGHT(self.topImageView) + DEF_HEIGHT(nameView)*4+DEF_HEIGHT(self.beiJingView)+DEF_HEIGHT(self.xiangGuanView)+DEF_HEIGHT(self.jobView)+ DEF_HEIGHT(self.aboutPersonView) + 80;
    if (height <= DEF_SCREEN_HEIGHT-64)
    {
        height = DEF_SCREEN_HEIGHT;
    }
    
    NSString *is_favorite = self.lawyerDict[@"is_favorite"];
    if ([is_favorite intValue] == 0)
    {
        self.collecBtn.selected = NO;
    }
    else
    {
        self.collecBtn.selected = YES;
    }
}

// 顶部视图
-(void)userCenterTopView
{
    //底部的模糊图
    self.topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, DEF_SCREEN_WIDTH, BACK_IMAGE_HEIGHT)];
    self.topImageView.userInteractionEnabled = YES;
    NSString *photoUrlString = self.lawyerDict[@"photo"];
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:photoUrlString] placeholderImage:[UIImage imageNamed:@"vague"]];
    [self.view insertSubview:self.topImageView atIndex:0];
    
    
//    UIView *bgView = [[UIView alloc] initWithFrame:self.topImageView.frame];
//    bgView.backgroundColor = [UIColor clearColor];
//    [self.userCenterScrollView addSubview:bgView];
    
    self.collecBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.userCenterScrollView addSubview:self.collecBtn];
    self.collecBtn.layer.masksToBounds = YES;
    self.collecBtn.layer.cornerRadius = 3;
    self.collecBtn.frame = CGRectMake(DEF_SCREEN_WIDTH - 58, 20 , 46, 23);
    [_collecBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [_collecBtn setTitleColor:DEF_RGB_COLOR(255 , 137 , 0) forState:UIControlStateNormal];
    [_collecBtn setTitleColor:DEF_RGB_COLOR(255 , 137 , 0) forState:UIControlStateSelected];
    _collecBtn.titleLabel.font = DEF_Font(12.0);
    _collecBtn.titleLabel.textAlignment = 2;
    
    [self.collecBtn setImage:[UIImage imageNamed:@"ic_right_collect"] forState:UIControlStateNormal];
    [self.collecBtn setImage:[UIImage imageNamed:@"ic_right_collect_a"] forState:UIControlStateSelected];
    _collecBtn.backgroundColor = [UIColor whiteColor];
    [self.collecBtn addTarget:self action:@selector(collecBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    if (photoUrlString.length != 0)
    {
        //头像
        UIImageView *headImageView = [[UIImageView alloc]initForAutoLayout];
        [self.topImageView addSubview:headImageView];
        [headImageView autoCenterInSuperview];
        [headImageView autoSetDimensionsToSize:CGSizeMake(216/3.0, 216/3.0)];
        [headImageView sd_setImageWithURL:[NSURL URLWithString:self.lawyerDict[@"avatar"]] placeholderImage:[UIImage imageNamed:@"admin"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        headImageView.layer.masksToBounds = YES;
        headImageView.layer.cornerRadius = 216/6.0;
        //    headImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    //律师信息
    UIImageView *ShadowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, BACK_IMAGE_HEIGHT, DEF_SCREEN_WIDTH, 50)];
    ShadowImageView.userInteractionEnabled = YES;
    ShadowImageView.backgroundColor = [UIColor whiteColor];
    [self.userCenterScrollView addSubview:ShadowImageView];
    
    //    答题数
    float y = 12.3;
    float height = 25.0;
    float width =DEF_SCREEN_WIDTH/4;
    
    //    答题
    self.datiView = [[userCenterCustomView alloc]initWithFrame:CGRectMake(0, y,width, height)];
    [ShadowImageView addSubview:self.datiView];
    self.datiView.topNumberLabl.text = self.lawyerDict[@"race_num"];
    self.datiView.topLable.text = @"答题数";
    
    //    询法等级
    self.dejiView = [[userCenterCustomView alloc]initWithFrame:CGRectMake(DEF_RIGHT(self.datiView), y, width, height)];
    [ShadowImageView addSubview:self.dejiView];
    self.dejiView.topNumberLabl.text = self.lawyerDict[@"lv"];
    self.dejiView.topLable.text = @"询法等级";
    
    //    经历View
    self.jingliView = [[userCenterCustomView alloc]initWithFrame:CGRectMake(DEF_RIGHT(self.dejiView), y,width, height)];
    [ShadowImageView addSubview:self.jingliView];
    self.jingliView.topNumberLabl.text = self.lawyerDict[@"year"];
    self.jingliView.topLable.text = @"执业年限";
    
    //    评价
    self.pingjiaView = [[userCenterCustomView alloc]initWithFrame:CGRectMake(DEF_RIGHT(self.jingliView), y, width, height)];
    [ShadowImageView addSubview:self.pingjiaView];
    self.pingjiaView.topNumberLabl.text = self.lawyerDict[@"ping_num"];
    self.pingjiaView.topLable.text = @"评价";
    self.pingjiaView.topLable.textColor = DEF_RGB_COLOR(59, 136, 219);
    self.pingjiaView.topNumberLabl.textColor = DEF_RGB_COLOR(59, 136, 219);
    
    UIButton *pingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ShadowImageView addSubview:pingBtn];
    pingBtn.frame = CGRectMake(DEF_SCREEN_WIDTH - width, 0, width, DEF_HEIGHT(ShadowImageView));
    [pingBtn addTarget:self action:@selector(evaluateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *arrowImagePic = [[UIImageView alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - width/2+15, 20, 6, 10)];
    [ShadowImageView addSubview:arrowImagePic];
    arrowImagePic.contentMode = UIViewContentModeScaleAspectFit;
    arrowImagePic.image = [UIImage imageNamed:@"arrow-right"];
    
    //    姓名和地址
    nameView = [[UIView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(ShadowImageView)+8, DEF_SCREEN_WIDTH, 43)];
    nameView.backgroundColor = [UIColor whiteColor];
    [self.userCenterScrollView addSubview:nameView];
    
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, DEF_HEIGHT(nameView))];
    nameLab.text = self.lawyerDict[@"name"];
    nameLab.textAlignment = 0;
    nameLab.textColor = DEF_RGB_COLOR(61, 61, 71);
    nameLab.font = DEF_Font(16);
    [nameView addSubview:nameLab];
    
    UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 42, DEF_SCREEN_WIDTH, LINE_HEIGHT)];
    lineLab.backgroundColor =DEF_RGB_COLOR(214, 214, 217);
    [nameView addSubview:lineLab];
    
    UILabel *addressLable = [[UILabel alloc]initWithFrame:CGRectMake(DEF_WIDTH(nameView)-DEF_SCREEN_WIDTH/2-10, 0, DEF_SCREEN_WIDTH/2, DEF_HEIGHT(nameView))];
    addressLable.text = [self.lawyerDict[@"city"] stringByAppendingString:self.lawyerDict[@"region"]];
    addressLable.textAlignment = 2;
    addressLable.textColor = DEF_RGB_COLOR(61, 61, 71);
    addressLable.font = DEF_Font(16);
    [nameView addSubview:addressLable];
    
    //    律所
    UIView *lawyerView = [[UIView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(nameView), DEF_SCREEN_WIDTH, 43)];
    lawyerView.backgroundColor = [UIColor whiteColor];
    [self.userCenterScrollView addSubview:lawyerView];
    
    UILabel *lawyerLineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 42, DEF_SCREEN_WIDTH, LINE_HEIGHT)];
    lawyerLineLab.backgroundColor =DEF_RGB_COLOR(214, 214, 217);
    [lawyerView addSubview:lawyerLineLab];
    
    UILabel *lawyerLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 55, DEF_HEIGHT(lawyerView))];
    lawyerLab.text = @"律 所 :";
    lawyerLab.textAlignment = 0;
    lawyerLab.textColor = DEF_RGB_COLOR(61, 61, 71);
    lawyerLab.font = DEF_Font(16);
    [lawyerView addSubview:lawyerLab];
    
    UILabel *lawyerAddressLable = [[UILabel alloc]initWithFrame:CGRectMake(DEF_RIGHT(lawyerLab), 0, 180, DEF_HEIGHT(lawyerView))];
    lawyerAddressLable.text =self.lawyerDict[@"lawyer_company"];
    lawyerAddressLable.textAlignment = 0;
    lawyerAddressLable.textColor = DEF_RGB_COLOR(61, 61, 71);
    lawyerAddressLable.font = DEF_Font(16);
    [lawyerView addSubview:lawyerAddressLable];
    
    UILabel *lawyerHehou = [[UILabel alloc]initWithFrame:CGRectMake(DEF_WIDTH(lawyerView) - 100, 0, 90, DEF_HEIGHT(lawyerView))];
    lawyerHehou.text = self.lawyerDict[@"work_title"];
    lawyerHehou.textAlignment = 0;
    lawyerHehou.textColor = DEF_RGB_COLOR(61, 61, 71);
    lawyerHehou.font = DEF_Font(16);
    lawyerHehou.textAlignment = 2;
    [lawyerView addSubview:lawyerHehou];
    
    //    执业证号
    self.practiceView = [[UserLawyerInfoView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(lawyerView), DEF_SCREEN_WIDTH, DEF_HEIGHT(lawyerView))];
    [self.userCenterScrollView addSubview:self.practiceView];
    self.practiceView.myInfoRight.text = self.lawyerDict[@"lawyer_license"];
    self.practiceView.myInfoLeft.text = @"执业证号: ";
    
    //    擅长领域
    UIView *shanChangView = [[UIView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(self.practiceView), DEF_SCREEN_WIDTH, DEF_HEIGHT(lawyerView))];
    shanChangView.backgroundColor = [UIColor whiteColor];
    [self.userCenterScrollView addSubview:shanChangView];
    
    UILabel *adeptLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, DEF_HEIGHT(shanChangView))];
    adeptLable.text = @"擅长领域 :";
    adeptLable.textAlignment = 0;
    adeptLable.textColor = DEF_RGB_COLOR(61, 61, 71);
    adeptLable.font = DEF_Font(16);
    [shanChangView addSubview:adeptLable];
    
    //擅长的标签
    NSArray *adeptArr = self.lawyerDict[@"category"];
    NSMutableArray *shanArr = [[NSMutableArray alloc]init];
    
    float sWidth;
    if (DEF_SCREEN_WIDTH == 320.0)
    {
        sWidth = 68;
        
    }
    else
    {
        sWidth = 76;
    }
    float hSpace = 10;
    for (int i=0; i<adeptArr.count; i++)
    {
        NSDictionary *dict = adeptArr[i];
        NSArray *nameArray = [dict allValues];
        NSString *nameStr = nameArray[0];
        [shanArr addObject:nameStr];
        
        UILabel *shangchangLab = [[UILabel alloc]initWithFrame:CGRectMake(DEF_RIGHT(adeptLable)+i*(sWidth+hSpace), 7.5, sWidth, 28)];
        shangchangLab.text = shanArr[i];
        shangchangLab.textColor = DEF_RGB_COLOR(61, 61, 71);
        shangchangLab.font = DEF_Font(16);
        shangchangLab.backgroundColor = DEF_RGB_COLOR(242, 241, 244);
        shangchangLab.textAlignment = 1;
        shangchangLab.layer.masksToBounds = YES;
        shangchangLab.layer.cornerRadius = 3;
        [shanChangView addSubview:shangchangLab];
    }
    
    UILabel *slineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 43, DEF_SCREEN_WIDTH, LINE_HEIGHT)];
    slineLab.backgroundColor =DEF_RGB_COLOR(214, 214, 217);
    [shanChangView addSubview:slineLab];
    
    //    第三部分
    float userY = DEF_BOTTOM(shanChangView)+8;
    float userHeight = 0.0;
    
    //    教育背景
    NSString *jiaoyuStr = self.lawyerDict[@"edu_background"];
    NSString *xiangguanStr = self.lawyerDict[@"work_qualification"];
    NSString *jobStr = self.lawyerDict[@"work_language"];
    
    if (![NSString isBlankString:jiaoyuStr])
    {
        self.beiJingView = [[UserLawyerInfoView alloc]initWithFrame:CGRectMake(0, userY, DEF_SCREEN_WIDTH, 43)];
        self.beiJingView.myInfoLeft.text = @"教育背景: ";
        self.beiJingView.myInfoRight.text = jiaoyuStr;
        [self.userCenterScrollView addSubview:self.beiJingView];
        userHeight = DEF_BOTTOM(self.beiJingView)+8;
    }
//    if (![NSString isBlankString:xiangguanStr])
//    {
//        self.xiangGuanView = [[UserLawyerInfoView alloc]init];
//        self.xiangGuanView.myInfoLeft.text = @"相关资质: ";
//        self.xiangGuanView.myInfoRight.text = xiangguanStr;
//        [self.userCenterScrollView addSubview:self.xiangGuanView];
//        
//        if (self.beiJingView)
//        {
//            self.xiangGuanView.frame =CGRectMake(0, userY+43, DEF_SCREEN_WIDTH, 43);
//        }
//        else
//        {
//            self.xiangGuanView.frame =CGRectMake(0, userY, DEF_SCREEN_WIDTH, 43);
//        }
//        userHeight = DEF_BOTTOM(self.xiangGuanView)+8;
//    }
    if (![NSString isBlankString:jobStr])
    {
        self.jobView = [[UserLawyerInfoView alloc]init];
        self.jobView.myInfoLeft.text = @"工作语言: ";
        self.jobView.myInfoRight.text = jobStr;
        [self.userCenterScrollView addSubview:self.jobView];
        
        if (self.beiJingView && self.xiangGuanView)
        {
            self.jobView.frame = CGRectMake(0, DEF_BOTTOM(self.xiangGuanView), DEF_SCREEN_WIDTH, 43);
        }
        else if (self.beiJingView || self.xiangGuanView)
        {
            self.jobView.frame = CGRectMake(0, userY+43, DEF_SCREEN_WIDTH, 43);
        }
        else
        {
            self.jobView.frame = CGRectMake(0, userY, DEF_SCREEN_WIDTH, 43);
            
        }
        userHeight = DEF_BOTTOM(self.jobView)+8;
    }
    if ([NSString isBlankString:jiaoyuStr] && [NSString isBlankString:xiangguanStr] && [NSString isBlankString:jobStr])
    {
        //        如果三个都是空
        userHeight = userY;
    }
    
    NSString *str =self.lawyerDict[@"introduce"];
    float heigh =  [HZUtil getHeightWithString:str fontSize:16 width:DEF_SCREEN_WIDTH-20];
    //上面名字LB高度35，下方空白处高度30.
    self.aboutPersonView = [[AboutPersonView alloc]initWithFrame:CGRectMake(0, userHeight, DEF_SCREEN_WIDTH,55.0+heigh) withData:str];
    [self.userCenterScrollView addSubview:self.aboutPersonView];
    userHeight = DEF_BOTTOM(self.aboutPersonView)+8;
    
//    NSString *work_case =self.lawyerDict[@"work_case"];
//    float work_caseheigh =  [HZUtil getHeightWithString:work_case fontSize:16 width:DEF_SCREEN_WIDTH-20];
//    //上面名字LB高度35，下方空白处高度30.
//    self.caseView = [[AboutPersonView alloc]initWithFrame:CGRectMake(0, userHeight, DEF_SCREEN_WIDTH,55.0+work_caseheigh) withData:work_case];
//    self.caseView.nameLB.text = @"案例介绍：";
//    [self.userCenterScrollView addSubview:self.caseView];
//    userHeight = DEF_BOTTOM(self.caseView)+8;

    if (userHeight <= DEF_SCREEN_HEIGHT-64)
    {
        userHeight = DEF_SCREEN_HEIGHT;
    }
    //设置scrollView
    self.userCenterScrollView.contentSize = CGSizeMake(DEF_SCREEN_WIDTH, userHeight);
    [self getLawyerPingDataByHttpRequest];
}
#pragma maek -- 按钮点击事件
//律师评价事件
-(void)evaluateBtnClick:(UIButton *)btn
{
    DEF_DEBUG(@"评论");
    LawerCommentViewController *VC = [[LawerCommentViewController alloc]init];
    VC.lawyerInfoDict = self.diction;
    VC.lawyerCommentArray = self.lawerCommentArray;
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;
    if (yOffset <= 0)
    {
        CGFloat offsetY = -scrollView.contentOffset.y;
        CGFloat oldH = BACK_IMAGE_HEIGHT;
        CGFloat oldW = DEF_SCREEN_WIDTH;
        
        CGFloat newH = oldH + offsetY;
        CGFloat newW = oldW * (newH/oldH);
        
        self.topImageView.frame = CGRectMake(0, 0, newW, newH);
        self.topImageView.center = CGPointMake(self.userCenterScrollView.center.x, self.topImageView.center.y + 64);
    }
    else
    {
        CGFloat offsetY = scrollView.contentOffset.y;
        self.topImageView.mh_y = -offsetY * 0.9 + 64;
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

#pragma mark -- 友盟分享相关
//自定义分享
- (void)shareBtnClick
{
    NSString *shareText = @"询法分享";
    
    // 分享的图标
    UIImage *shareImage =[UIImage imageNamed:@"arrow.png"];
    //分享
    shareView        = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT)];
    //[[ShareView alloc]initWithFrame:self.view.frame];
    shareView.shareTitle        = @"分享内容";
    shareView.shareThumbImage   = shareImage;
    shareView.shareDescription  = shareText;
    shareView.controller        = self;
    shareView.shareURLStr       = @"http://www.ipe.org.cn/PollutionMapApp_DownLoad.aspx";
    
    
    
    [[AppDelegate appDelegate].window addSubview:shareView];
    
    //
    [shareView doSomethingAfterShareCompletion:^{
        
    }];
    
    [shareView sinaShare:^{
//        NSLog(@"新浪微博分享特殊");
        
    }];
    
    [shareView cancleShare:^{
        
    }];
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
