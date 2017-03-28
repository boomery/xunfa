//
//  MyViewController.m
//  MHProject
//
//  Created by 杜宾 on 15/5/11.
//  Copyright (c) 2015年 杜宾. All rights reserved.
//
#define BACK_IMAGE_HEIGHT TRANSFORM_HEIGHT((378)/3.0)
#import "MessageManager.h"
#import "MyViewController.h"
#import "MyInfoViewController.h"
#import "DotDetailViewController.h"
#import "IntegralDetailViewController.h"
#import "NewsViewController.h"
#import "MyRaceQuestionViewController.h"
#import "MyIdeaViewController.h"
#import "MyCollectionViewController.h"
#import "SettingViewController.h"
#import "LawyerCommentViewController.h"
#import "FDActionSheet.h"
#import "ASIFormDataRequest.h"
#import "HZUtil.h"
#import "UIImage+Resize.h"
#import "UIView+MHExtension.h"
#import "TopButtonBottomLabelView.h"
#import "MyOrderViewController.h"
#import "ApplyAppointmentViewController.h"
@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL _isApplied;
}
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic,strong)UIImageView *headImageBgView;
@property (nonatomic,strong)UIButton *headImageBtn;
@property(nonatomic,strong)UIImage   *headImage;

@property (nonatomic,strong)UILabel  *nickNameLB;
@property (nonatomic,strong)UILabel  *userInfoLB;

@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,strong)NSArray *leftVcArray;

@property (nonatomic, strong) TopButtonBottomLabelView  *scoreView;
@property (nonatomic, strong) TopButtonBottomLabelView  *questionNumView;
@property (nonatomic, strong) TopButtonBottomLabelView  *ideaNumView;

@property (nonatomic, strong) NSArray *imageNameArray;

@property (nonatomic, strong) NSString *meet_is_on;


@end

@implementation MyViewController
#pragma mark -- 请求相关
//获取个人信息
-(void)getInfoByHttpRequest
{
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = [NSString stringWithFormat:@"%@%@",DEF_API_Lawyer,uid];
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    [MHAsiNetworkAPI getLawyerInfoByuid:uid timestamp:timeStamp sign:sign lawyer_id:uid SuccessBlock:^(id returnData) {
        DEF_DEBUG(@"个人信息接口返回数据%@",returnData);
        
        NSString *ret = returnData[@"ret"];
        
        //给界面赋值
        if ([ret isEqualToString:@"0"])
        {
            NSDictionary *data = returnData[@"data"];
            self.userInfoDict = data;
            self.meet_is_on = data[@"meet_is_on"];
            //这个字段就是为了 当城市信息返回的数据变动的时候使用
            NSString  *serverCity_version = data[@"city_version"];
            DEF_PERSISTENT_SET_OBJECT(serverCity_version, DEF_server_City_version);
            
            [self addUIDataByHttpRequestDict:data];
        }
        else
        {
            //            SHOW_ALERT(msg);
        }
        
    } failureBlock:^(NSError *error) {
    } showHUD:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = DEF_RGB_COLOR(238, 238, 238);
   
    [self creatContScrollView];
    [self uiHUD];
    [self setNavUI];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getInfoByHttpRequest];
    [self.myInfoTableView reloadData];
}

#pragma mark -- 初始化
//给界面添加数据
-(void)addUIDataByHttpRequestDict:(NSDictionary *)dict
{
//    NSString *topBgImageUrl = dict[@"photo"];
    NSString *headImageUrl = dict[@"avatar"];
    NSString *name = dict[@"name"];
    NSString *mobile = dict[@"mobile"];
    
    NSString *score_num = dict[@"point"];
    NSString *ping_num = dict[@"ping_num"];
    NSString *question_num = dict[@"race_num"];
    
    //    模糊图
//    [self.headImageBgView sd_setImageWithURL:[NSURL URLWithString:topBgImageUrl] placeholderImage:[UIImage imageNamed:@"vague-admin"]];
//     //1、头像
    [self.headImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:headImageUrl]
                                           forState:UIControlStateNormal
                                   placeholderImage:[UIImage imageNamed:@"admin"]
                                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         if (image){
             DEF_DEBUG(@"图片存在：%@",imageURL);
         }
     }];
    
    //
    if (name) {
        self.nickNameLB.text = name;
    }else{
        self.nickNameLB.text = mobile;
    }
    self.scoreView.bottomLabelText = score_num;
    self.questionNumView.bottomLabelText = question_num;
    self.ideaNumView.bottomLabelText = ping_num;
}
- (void)initData
{
    self.titleArray = @[@[@"个人资料",@"积点明细",@"积分明细",@"查看评价"],@[@"我的预约",@"我的抢答",@"我的主意",@"我的收藏"],@[@"设置"]];
    self.imageNameArray = @[@[@"ic_admin_admin",@"ic_admin_ad",@"ic_admin_card",@"ic_admin_appraise"],@[@"ic_admin_order",@"ic_admin_rob",@"ic_admin_idea",@"ic_admin_collect"],@[@"ic_admin_install"]];
}
- (void)setNavUI
{
    // 自定义的导航栏
    [self showNavBarDefaultHUDByNavTitle:@"个人中心" inView:self.view isBack:NO];
}
- (void)uiHUD
{
    UIView *topBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, DEF_SCREEN_WIDTH, TRANSFORM_HEIGHT((378+105+159)/3.0))];
    topBgView.backgroundColor = [UIColor clearColor];
    
    //背景视图
    self.headImageBgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, DEF_WIDTH(topBgView),BACK_IMAGE_HEIGHT)];
    self.headImageBgView.userInteractionEnabled = YES;
    self.headImageBgView.image = [UIImage imageNamed:@"admin_bg"];
    self.headImageBgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.headImageBgView];
    
    //1、头像背景视图
    self.headImageBtn = [[UIButton alloc] initForAutoLayout];
    [topBgView addSubview:self.headImageBtn];
    [self.headImageBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:topBgView withOffset:TRANSFORM_HEIGHT(30.0)];
    [self.headImageBtn autoAlignAxis:ALAxisVertical toSameAxisOfView:topBgView];
//    [self.headImageBtn autoCenterInSuperview];
    [self.headImageBtn autoSetDimensionsToSize:CGSizeMake(TRANSFORM_HEIGHT(216/3.0), TRANSFORM_HEIGHT(216/3.0))];
    self.headImageBtn.userInteractionEnabled =YES;
    self.headImageBtn.layer.cornerRadius = TRANSFORM_HEIGHT(216/3.0)/2.0;
    self.headImageBtn.clipsToBounds = YES;
    self.headImageBtn.backgroundColor = [UIColor orangeColor];
    self.headImageBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.headImageBtn.layer.borderWidth = 4/3.0;
    [self.headImageBtn setBackgroundImage:[UIImage imageNamed:@"admin"] forState:UIControlStateNormal];
    [self.headImageBtn addTarget:self action:@selector(headImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *cameraImageView = [[UIImageView alloc] initForAutoLayout];
    [topBgView addSubview:cameraImageView];
    cameraImageView.image = [UIImage imageNamed:@"ic_admin_camera"];
    [cameraImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.headImageBtn withOffset:TRANSFORM_HEIGHT(56.0)];
    [cameraImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.headImageBtn withOffset:TRANSFORM_HEIGHT(55.0)];
    [cameraImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.headImageBtn];
    [cameraImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.headImageBtn];

    UIView *bottomView = [[UIView alloc] initForAutoLayout];
    [topBgView addSubview:bottomView];
    [bottomView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(TRANSFORM_HEIGHT(378/3.0), 0, 0, 0)];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initForAutoLayout];
    [topBgView addSubview:lineView];
    [lineView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:bottomView withOffset:TRANSFORM_HEIGHT(40)];
    [lineView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bottomView withOffset:12];
    [lineView autoSetDimensionsToSize:CGSizeMake(DEF_SCREEN_WIDTH-12, LINE_HEIGHT)];
    lineView.backgroundColor = DEF_RGB_COLOR(244, 244, 244);

    //2、头像名字标签
    self.nickNameLB = [[UILabel alloc]initForAutoLayout];
    [topBgView addSubview:self.nickNameLB];
    [self.nickNameLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:topBgView withOffset:12];
    [self.nickNameLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:lineView withOffset:-12];
    [self.nickNameLB autoSetDimension:ALDimensionWidth toSize:DEF_SCREEN_WIDTH];
    
    self.nickNameLB.backgroundColor = [UIColor clearColor];
    self.nickNameLB.textAlignment = 0;
    self.nickNameLB.textColor = DEF_RGB_COLOR(51, 51, 51);
    if (DEF_SCREEN_WIDTH==320) {
        self.nickNameLB.font = [UIFont systemFontOfSize:14];
    }else{
        self.nickNameLB.font = [UIFont systemFontOfSize:16];
    }
//    self.nickNameLB.text = @"15136123242(Andy)";
    //
    //3、积分、问题数、出主意
    NSArray *titleArray = @[@"积分",@"抢答",@"主意"];
    NSArray *imageNameArray= @[@"ic_admin_sm_card",@"ic_admin_top_rob",@"ic_admin_sm_idea"];
    CGFloat width = (DEF_SCREEN_WIDTH - 12*4)/3.0;
    CGFloat interval = 12;
    for (int i = 0; i < 3; i++)
    {
        TopButtonBottomLabelView *view = [[TopButtonBottomLabelView alloc] init];
        view.topButton.tag = i;
        [view.topButton addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        view.frame = CGRectMake(interval +i*(width +interval), TRANSFORM_HEIGHT((378+105)/3.0), width, TRANSFORM_HEIGHT(159/3.0));
        [topBgView addSubview:view];
        view.topButtonTitle = titleArray[i];
        view.topButtonImage = [UIImage imageNamed:imageNameArray[i]];
        switch (i) {
            case 0:
            {
                self.scoreView = view;
                view.bottomLabelColor = [UIColor colorWithRed:0.99 green:0.53 blue:0.44 alpha:1];
            }
                break;
            case 1:
            {
                self.questionNumView = view;
                view.bottomLabelColor = [UIColor colorWithRed:0.27 green:0.69 blue:0.53 alpha:1];
                view.topButtonTitleColor =[UIColor colorWithRed:0.27 green:0.69 blue:0.53 alpha:1];
            }
                break;
            case 2:
            {
                self.ideaNumView = view;
                view.bottomLabelColor = DEF_RGB_COLOR(60, 153, 230);                
                view.topButtonTitleColor =  DEF_RGB_COLOR(60, 153, 230);
            }
                break;
            default:
                break;
        }
    }
    
    //4、下方表视图
    self.myInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT-64-50) style:UITableViewStylePlain];
    self.myInfoTableView.backgroundColor = [UIColor clearColor];
    self.myInfoTableView.delegate = self;
    self.myInfoTableView.dataSource = self;
    self.myInfoTableView.scrollEnabled = YES;
    self.myInfoTableView.rowHeight = 44.0;
    self.myInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.myInfoTableView];
    self.myInfoTableView.tableHeaderView = topBgView;
    self.myInfoTableView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.contentSize = CGSizeMake(DEF_SCREEN_WIDTH, DEF_HEIGHT(self.myInfoTableView)+DEF_HEIGHT(topBgView));
}

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
        
        self.headImageBgView.frame = CGRectMake(0, 0, newW, newH);
        self.headImageBgView.center = CGPointMake(self.contentScrollView.center.x, self.headImageBgView.center.y + 64);
        if (yOffset <= -70)
        {
            DEF_DEBUG(@"%@",NSStringFromCGRect(self.headImageBgView.frame));
        }
    }
    else
    {
        CGFloat offsetY = scrollView.contentOffset.y;
        self.headImageBgView.mh_y = -offsetY * 0.9 + 64;
    }
}

#pragma mark - 点击顶部三个项目
- (void)topButtonClick:(UIButton *)button
{
    switch (button.tag)
    {
        case 0:
        {
            [MobClick event:@"LawMy_Point2"];
            IntegralDetailViewController *infoVC = [[IntegralDetailViewController alloc]init];
            infoVC.hidesBottomBarWhenPushed = YES;
            infoVC.title = @"积分明细";
            [self.navigationController pushViewController:infoVC animated:YES];
        }
            break;
        case 1:
        {
            [MobClick event:@"LawMy_Answer2"];
            MyRaceQuestionViewController *infoVC = [[MyRaceQuestionViewController alloc]init];
            infoVC.title = @"我的抢答";
            infoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:infoVC animated:YES];

        }
            break;
        case 2:
        {
            [MobClick event:@"LawMy_Idea2"];
            MyIdeaViewController *infoVC = [[MyIdeaViewController alloc]init];
            infoVC.title = @"我的主意";
            infoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:infoVC animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    CGFloat height = LINE_HEIGHT;
    
    UIImageView *topLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, height)];
    topLine.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.86 alpha:1];
    [view addSubview:topLine];
    
    if (section > self.titleArray.count -1)
    {
        return view;
    }
    UIImageView *bottomLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 8-height/2.0, DEF_SCREEN_WIDTH, height/2.0)];
    bottomLine.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.86 alpha:1];
    [view addSubview:bottomLine];
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count+1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section > self.titleArray.count-1)
    {
        return 0;
    }
    NSArray *titleArray = self.titleArray[section];
    return titleArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"leftMenuCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textAlignment = 0;
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:cell.frame];
        [cell addSubview:backgroundView];
        backgroundView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
        cell.selectedBackgroundView = backgroundView;
        
        CGFloat height = LINE_HEIGHT;

        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(12, cell.bounds.size.height-height, DEF_SCREEN_WIDTH, height)];
        line.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
        line.tag = 666;
        [cell addSubview:line];
        
        UILabel *titleLabel = [[UILabel alloc] initForAutoLayout];
        titleLabel.tag = 100;
        titleLabel.font = DEF_Font(16);
        titleLabel.textColor = DEF_RGB_COLOR(100, 99, 105);
        [cell addSubview:titleLabel];
        [titleLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:cell];
        [titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:cell.imageView withOffset:3];
        [titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:cell.imageView];
        [titleLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:cell.imageView];
        [titleLabel autoSetDimension:ALDimensionWidth toSize:200 relation:NSLayoutRelationLessThanOrEqual];
    }
    UIView *redDot = [cell viewWithTag:101];
    redDot.hidden = YES;
    
    NSArray *titleArray = self.titleArray[indexPath.section];
    NSArray *imageNameArray = self.imageNameArray[indexPath.section];
    cell.imageView.image = [UIImage imageNamed:imageNameArray[indexPath.row]];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    titleLabel.text = titleArray[indexPath.row];
    [titleLabel sizeToFit];
    
    //    隐藏每个区最后一个cell的底边线
    UILabel *lineL = (UILabel *)[cell viewWithTag:666];
    if (indexPath.row == titleArray.count-1)
    {
        lineL.hidden = YES;
        
    }else
    {
        lineL.hidden = NO;
    }
    if (indexPath.section == 2)
    {
        lineL.hidden = NO;
        lineL.frame = CGRectMake(0, cell.bounds.size.height-LINE_HEIGHT, DEF_SCREEN_WIDTH, LINE_HEIGHT);
    }
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *titleArray = self.titleArray[indexPath.section];
    if (indexPath.section == 0)
    {
        
        switch (indexPath.row)
        {
            case 0:
            {
                [MobClick event:@"LawMy_Info"];
                MyInfoViewController *infoVC = [[MyInfoViewController alloc]init];
                infoVC.title = titleArray[indexPath.row];
                infoVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:infoVC animated:YES];
            }
                break;
            case 1:
            {
                [MobClick event:@"LawMy_Cash"];
                DotDetailViewController *infoVC = [[DotDetailViewController alloc]init];
                infoVC.title = titleArray[indexPath.row];
                infoVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:infoVC animated:YES];
            }
                break;
            case 2:
            {
                [MobClick event:@"LawMy_Point"];
                IntegralDetailViewController *infoVC = [[IntegralDetailViewController alloc]init];
                infoVC.hidesBottomBarWhenPushed = YES;
                infoVC.title = titleArray[indexPath.row];
                [self.navigationController pushViewController:infoVC animated:YES];
            }
                break;
            case 3:
            {
                [MobClick event:@"LawMy_Comment"];
                LawerCommentViewController *infoVC = [[LawerCommentViewController alloc]init];
                infoVC.lawyerInfoDict = self.userInfoDict;
                infoVC.hidesBottomBarWhenPushed = YES;
                infoVC.title = titleArray[indexPath.row];
                [self.navigationController pushViewController:infoVC animated:YES];
            }
                break;
        }
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                if ([self.meet_is_on intValue] == 1)
                {
                    MyOrderViewController *infoVC = [[MyOrderViewController alloc]init];
                    infoVC.hidesBottomBarWhenPushed = YES;
                    infoVC.title = titleArray[indexPath.row];
                    [self.navigationController pushViewController:infoVC animated:YES];
                }
                else
                {
                    ApplyAppointmentViewController *applyVC = [[ApplyAppointmentViewController alloc] init];
                    applyVC.infoDict = self.userInfoDict;
                    applyVC.meet_is_on = self.meet_is_on;
                    applyVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:applyVC animated:YES];
                }
            }
                break;

//            case 1:
//            {
//                [MobClick event:@"LawMy_Msg"];
//                [MessageManager setUnreadMessageWithNumber:@"0"];
//                NewsViewController *infoVC = [[NewsViewController alloc]init];
//                infoVC.hidesBottomBarWhenPushed = YES;
//                infoVC.title = titleArray[indexPath.row];
//                [self.navigationController pushViewController:infoVC animated:YES];
//            }
//                break;
            case 1:
            {
                [MobClick event:@"LawMy_Answer"];
                MyRaceQuestionViewController *infoVC = [[MyRaceQuestionViewController alloc]init];
                infoVC.title = titleArray[indexPath.row];
                infoVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:infoVC animated:YES];
            }
                break;
            case 2:
            {
                [MobClick event:@"LawMy_Idea"];
                MyIdeaViewController *infoVC = [[MyIdeaViewController alloc]init];
                infoVC.title = titleArray[indexPath.row];
                infoVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:infoVC animated:YES];
            }
                break;
            case 3:
            {
                [MobClick event:@"LawMy_Fav"];
                MyCollectionViewController *infoVC = [[MyCollectionViewController alloc]init];
                infoVC.title = titleArray[indexPath.row];
                infoVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:infoVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 2)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                [MobClick event:@"LawMy_Setup"];
                SettingViewController *infoVC = [[SettingViewController alloc]init];
                infoVC.title = titleArray[indexPath.row];
                infoVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:infoVC animated:YES];
            }
                break;
        }
    }
}

#pragma mark - 上传头像相关
-(void)headImageBtnClick:(UIButton *)sender
{
    [MobClick endEvent:@"LawMy_Pic"];
    FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从相册选取", nil];
    [sheet show];
}
//actionSheet代理方法
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            SHOW_ALERT(@"需要访问您的相机。\n请启用-设置/隐私/相机");
            return;
        }

        //先判断相机是否可用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:^{
                
            }];
        }
    }
    else
    {
        //选择图片
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:^{
                
            }];
        }
        
    }
}
//相机的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    
    self.headImage = img;
    
    [DataHander  showDlg];

    [picker dismissViewControllerAnimated:YES completion:^{
        //开辟分线程上传图片
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 处理耗时操作的代码块...
            if (img)
            {
                [self postImageDataByHttpRequestToServerWithImage:img];
            }
            else
            {
                return ;
            }
        });
        
    }];
}
//发送图片到服务器
-(void)postImageDataByHttpRequestToServerWithImage:(UIImage *)image
{
    //    //获取图片的大小
    //    CGFloat folderSize =[HZUtil getImageSizeWithImage:image];
    //    NSLog(@"图片大小:%.2f",folderSize);
    //    //压缩图片，如果大于10M就压缩
    //    NSData *imgData = UIImageJPEGRepresentation(image,1.0);
    //    if (folderSize>10.0) {
    //        imgData = UIImageJPEGRepresentation(image,10.0/folderSize);
    //    }
    //
//    UIImage *resizedImage = [image imageCompressForSize:image targetSize:CGSizeMake(500, 500)];
//    NSData *imgData = UIImagePNGRepresentation(resizedImage);
    
    NSData *imgData = UIImageJPEGRepresentation(image,0.3);
    
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = DEF_API_UserUploadImage;
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    NSString *str = [NSString stringWithFormat:@"%@?uid=%@&timestamp=%@&sign=%@",url,uid,timeStamp,sign];
    NSURL *completeUrl = [NSURL URLWithString:str];
    
#pragma mark 使用ASIHttpRequest 上传图片和数据
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:completeUrl];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request setRequestMethod:@"POST"];
    [request addData:imgData withFileName:@"file" andContentType:@"image/png" forKey:@"body"];
    [request addData:imgData forKey:@"file"];
    __weak ASIFormDataRequest *weakRequest = request;
    [request setCompletionBlock:^{
        //        NSLog(@"上传图片返回的数据%@",request.responseString);
        NSString *responseString = [[NSString alloc] initWithData:weakRequest.responseData
                                                         encoding:NSUTF8StringEncoding];
        id returnData = [JsonManager JSONValue:responseString];
        NSDictionary *dict = returnData;
        //{"ret":"0","msg":"","data":{"key":"group1\/M00\/00\/00\/wKjHNlWRFtaAf5fUAAACEdEnQ0I967.png","url":"http:\/\/192.168.199.54\/group1\/M00\/00\/00\/wKjHNlWRFtaAf5fUAAACEdEnQ0I967.png"},"0":"png"}
        NSString *ret = dict[@"ret"];
        NSString *msg = dict[@"msg"];
        if ([ret isEqualToString:@"0"])
        {
            NSDictionary *dataDict = dict[@"data"];
            NSString *imageKey = dataDict[@"key"];
            NSString *imageKeyStr = [NSString stringWithFormat:@",%@",imageKey];
            [self changeUserHeadImageByHttpRequestWithKeyString:imageKeyStr];
        }
        else{
            SHOW_ALERT(msg);
        }
        [DataHander hideDlg];
    }];
    [request setFailedBlock:^{
        SHOW_ALERT(@"亲，上传失败，请重新上传");
        [DataHander hideDlg];
    }];
    [request startAsynchronous];
}
//修改个人信息
-(void)changeUserHeadImageByHttpRequestWithKeyString:(NSString *)imageKey
{
    //
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = [NSString stringWithFormat:@"%@%@",DEF_API_Lawyer,uid];
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    
    [MHAsiNetworkAPI changeLawerInfoByuid:uid
                                timestamp:timeStamp
                                     sign:sign
                                lawyer_id:uid
                                   avatar:imageKey birth:nil sex:nil lawyer_company:nil work_title:nil email:nil city:nil region:nil introduce:nil SuccessBlock:^(id returnData)
     {
         DEF_DEBUG(@"上传头像信息接口返回数据%@",returnData);
         
         NSString *ret = returnData[@"ret"];
         NSString *msg = returnData[@"msg"];
         //         NSDictionary *data = returnData[@"data"];
         //给界面赋值
         if ([ret isEqualToString:@"0"])
         {
             [self.headImageBtn setBackgroundImage:self.headImage forState:UIControlStateNormal];
             HiddenLoadingView(self.view);
         }
         else
         {
             SHOW_ALERT(msg);
             HiddenLoadingView(self.view);
         }
     } failureBlock:^(NSError *error) {
         HiddenLoadingView(self.view);
     } showHUD:YES];
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
