//
//  MyInfoViewController.m
//  MHProject
//
//  Created by 张好志 on 15/6/18.
//  Copyright (c) 2015年 Andy. All rights reserved.
//
#define SpaceHeight 10
#define BACK_IMAGE_HEIGHT TRANSFORM_HEIGHT(276/3.0*2)

#import "MyInfoViewController.h"
#import "HomeViewController.h"
#import "MyViewController.h"
#import "AboutPersonView.h"
#import "HZUtil.h"
#import "EditeInfoViewController.h"
#import "FDActionSheet.h"
#import "ASIFormDataRequest.h"
#import "ProfessionalInformationViewController.h"
#import "UIImage+Resize.h"
#import "UIView+MHExtension.h"
#import "UserLawyerInfoView.h"
#import "CaptureViewController.h"
#import "VPImageCropperViewController.h"
@interface MyInfoViewController ()<FDActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ASIHTTPRequestDelegate, UIScrollViewDelegate>

@property(nonatomic,strong)UIImageView     *topBgImageView;//模糊图
@property(nonatomic,strong)UIButton        *headImageBtn;
@property(nonatomic,strong)UILabel         *nameLB;
@property(nonatomic,strong)UILabel         *addressLB;
@property(nonatomic,strong)UILabel         *lawyerCompanyLB;
@property(nonatomic,strong)UIView          *shanchangView; //律师执业证号码

@property(nonatomic,strong)UIView          *lawyerLicensedBgView; //律师执业证号码
@property(nonatomic,strong)UILabel         *lawyerLicensedLB;
@property(nonatomic,strong)UIView          *emailBgView; //邮箱背景
@property(nonatomic,strong)UILabel         *emailLB;
@property(strong,nonatomic)AboutPersonView *aboutPersonView;
@property(strong,nonatomic)AboutPersonView *caseView;

@property(nonatomic,strong)NSMutableString *imageKeyString;//
@property(nonatomic,strong)UIImage         *headImage;

@property(nonatomic,strong)UIButton         *imageButton;
@property (nonatomic, copy) NSString *imageKey;

@property(nonatomic,strong)UserLawyerInfoView *practiceView;//执业证号
@property(nonatomic,strong)UserLawyerInfoView *beiJingView;//执业证号
@property(nonatomic,strong)UserLawyerInfoView *xiangGuanView;//执业证号
@property(nonatomic,strong)UserLawyerInfoView *jobView;//执业证号

@end

@implementation MyInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = DEF_RGB_COLOR(238, 238, 238);
    self.navigationController.navigationBarHidden = YES;
    [self creatContScrollView];
    self.contentScrollView.frame = CGRectMake(0, 64, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT-64-40);
    self.contentScrollView.delegate = self;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self initUI];
    [self initNav];
    [self getInfoByHttpRequest];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.contentScrollView.delegate = nil;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.contentScrollView.delegate = self;
}
#pragma mark - 初始化
-(void)initNav
{
    [self showNavBarDefaultHUDByNavTitle:@"个人资料" inView:self.view isBack:YES];
}
#pragma mark - 点击事件
- (void)leftNavItemClick
{
    [MobClick event:@"LawMyInfo_Back"];
    [self.navigationController popViewControllerAnimated:YES];
}

// 个人资料的 ui界面
-(void)initMyinfoUIWithData:(NSDictionary *)data
{
    [self.contentScrollView removeAllSubviews];
    [self.bottomView removeFromSuperview];
    [self.topBgImageView removeFromSuperview];
    [self.imageButton removeFromSuperview];
    
    //律师形象展示背景图
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:data[@"photo"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"vague-admin"]];
    imageButton.backgroundColor = [UIColor lightGrayColor];
    [imageButton addTarget:self action:@selector(uploadPhoto:) forControlEvents:UIControlEventTouchUpInside];
    imageButton.frame = CGRectMake(0, 64 - self.contentScrollView.contentOffset.y, DEF_SCREEN_WIDTH, BACK_IMAGE_HEIGHT);
    [self.view insertSubview:imageButton belowSubview:self.contentScrollView];
    self.imageButton = imageButton;
    
    //覆盖在背景图位置的按钮
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.backgroundColor = [UIColor clearColor];
    [clearButton addTarget:self action:@selector(uploadPhoto:) forControlEvents:UIControlEventTouchUpInside];
    clearButton.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, BACK_IMAGE_HEIGHT);
    [self.contentScrollView addSubview:clearButton];
    
    //编辑图
    UIImageView *editImageView = [[UIImageView alloc] init];
    editImageView.frame = CGRectMake(imageButton.width - TRANSFORM_WIDTH(35.0), TRANSFORM_HEIGHT(10.0), TRANSFORM_WIDTH(15.0), TRANSFORM_HEIGHT(15.0));
    editImageView.image = [UIImage imageNamed:@"revise_edit"];
    [self.contentScrollView addSubview:editImageView];
    
    //    姓名和地址
    UIView *nameView = [[UIView alloc]initWithFrame:CGRectMake(0, DEF_HEIGHT(self.imageButton), DEF_SCREEN_WIDTH, 43)];
    nameView.backgroundColor = [UIColor whiteColor];
    [self.contentScrollView addSubview:nameView];
    
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, DEF_HEIGHT(nameView))];
    nameLab.text = data[@"name"];
    nameLab.textAlignment = 0;
    nameLab.textColor = DEF_RGB_COLOR(61, 61, 71);
    nameLab.font = DEF_Font(16);
    self.nameLB = nameLab;
    [nameView addSubview:nameLab];
    
    UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 42, DEF_SCREEN_WIDTH, LINE_HEIGHT)];
    lineLab.backgroundColor =DEF_RGB_COLOR(214, 214, 217);
    [nameView addSubview:lineLab];
    
    UILabel *addressLable = [[UILabel alloc]initWithFrame:CGRectMake(DEF_WIDTH(nameView)-DEF_SCREEN_WIDTH/2-10, 0, DEF_SCREEN_WIDTH/2, DEF_HEIGHT(nameView))];
    addressLable.text =[NSString stringWithFormat:@"%@  %@",data[@"city"],data[@"region"]];
//    data[@"address"];
    addressLable.textAlignment = 2;
    addressLable.textColor = DEF_RGB_COLOR(61, 61, 71);
    addressLable.font = DEF_Font(16);
    self.addressLB = addressLable;
    [nameView addSubview:addressLable];
    
    //    律所
    UIView *lawyerView = [[UIView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(nameView), DEF_SCREEN_WIDTH, 43)];
    lawyerView.backgroundColor = [UIColor whiteColor];
    [self.contentScrollView addSubview:lawyerView];
    
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
    lawyerAddressLable.text =data[@"lawyer_company"];
    lawyerAddressLable.textAlignment = 0;
    lawyerAddressLable.textColor = DEF_RGB_COLOR(61, 61, 71);
    lawyerAddressLable.font = DEF_Font(16);
    self.lawyerCompanyLB = lawyerAddressLable;
    [lawyerView addSubview:lawyerAddressLable];
    
    UILabel *lawyerHehou = [[UILabel alloc]initWithFrame:CGRectMake(DEF_WIDTH(lawyerView) - 100, 0, 90, DEF_HEIGHT(lawyerView))];
    lawyerHehou.text = data[@"work_title"];
    lawyerHehou.textAlignment = 0;
    lawyerHehou.textColor = DEF_RGB_COLOR(61, 61, 71);
    lawyerHehou.font = DEF_Font(16);
    lawyerHehou.textAlignment = 2;
    [lawyerView addSubview:lawyerHehou];
    
    //    执业证号
    self.practiceView = [[UserLawyerInfoView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(lawyerView), DEF_SCREEN_WIDTH, DEF_HEIGHT(lawyerView))];
    [self.contentScrollView addSubview:self.practiceView];
    self.practiceView.myInfoRight.text = data[@"lawyer_license"];
    self.practiceView.myInfoLeft.text = @"执业证号: ";
    
    //    擅长领域
    UIView *shanChangView = [[UIView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(self.practiceView), DEF_SCREEN_WIDTH, DEF_HEIGHT(lawyerView))];
    shanChangView.backgroundColor = [UIColor whiteColor];
    [self.contentScrollView addSubview:shanChangView];
    
    UILabel *adeptLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, DEF_HEIGHT(shanChangView))];
    adeptLable.text = @"擅长领域: ";
    adeptLable.textAlignment = 0;
    adeptLable.textColor = DEF_RGB_COLOR(61, 61, 71);
    adeptLable.font = DEF_Font(16);
    [shanChangView addSubview:adeptLable];
    
    //    擅长的标签
    NSArray *adeptArr = data[@"category"];
    NSMutableArray *shanArr = [[NSMutableArray alloc]init];
    
    float sWidth;
    if (DEF_SCREEN_WIDTH == 320.0)
    {
        sWidth = 68;
        
    }else
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
    self.shanchangView = shanChangView;
    
    //    第三部分
    float userY = DEF_BOTTOM(shanChangView)+8;
    float userHeight = 0.0;
    
    //    教育背景
    NSString *jiaoyuStr = data[@"edu_background"];
    NSString *xiangguanStr = data[@"work_qualification"];
    NSString *jobStr = data[@"work_language"];
    
    
    if (![NSString isBlankString:jiaoyuStr])
    {
        self.beiJingView = [[UserLawyerInfoView alloc]initWithFrame:CGRectMake(0, userY, DEF_SCREEN_WIDTH, 43)];
        self.beiJingView.myInfoLeft.text = @"教育背景: ";
        self.beiJingView.myInfoRight.text = jiaoyuStr;
        [self.contentScrollView addSubview:self.beiJingView];
        userHeight = DEF_BOTTOM(self.beiJingView)+8;
    }
//    if (![NSString isBlankString:xiangguanStr])
//    {
//        self.xiangGuanView = [[UserLawyerInfoView alloc]init];
//        self.xiangGuanView.myInfoLeft.text = @"相关资质: ";
//        self.xiangGuanView.myInfoRight.text = xiangguanStr;
//        [self.contentScrollView addSubview:self.xiangGuanView];
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
        [self.contentScrollView addSubview:self.jobView];
        
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
    
    NSString *str =data[@"introduce"];
    float heigh =  [HZUtil getHeightWithString:str fontSize:16 width:DEF_SCREEN_WIDTH-20];
    //上面名字LB高度35，下方空白处高度30.
    self.aboutPersonView = [[AboutPersonView alloc]initWithFrame:CGRectMake(0, userHeight, DEF_SCREEN_WIDTH,55.0+heigh) withData:str];
    [self.contentScrollView addSubview:self.aboutPersonView];
    userHeight = DEF_BOTTOM(self.aboutPersonView)+8;

//    NSString *work_case =data[@"work_case"];
//    float work_caseheight =  [HZUtil getHeightWithString:work_case fontSize:16 width:DEF_SCREEN_WIDTH-20];
//    //上面名字LB高度35，下方空白处高度30.
//    self.caseView = [[AboutPersonView alloc]initWithFrame:CGRectMake(0, userHeight, DEF_SCREEN_WIDTH,55.0+work_caseheight) withData:work_case];
//    self.caseView.nameLB.text = @"案例介绍：";
//    [self.contentScrollView addSubview:self.caseView];
//    userHeight = DEF_BOTTOM(self.caseView)+18;
    
    if (userHeight <= DEF_SCREEN_HEIGHT-64)
    {
        userHeight = DEF_SCREEN_HEIGHT -64;
    }
    //设置scrollView
    self.contentScrollView.contentSize = CGSizeMake(DEF_SCREEN_WIDTH, userHeight);
    [self creatBottomView];
}

#pragma mark - 上传图片
- (void)uploadPhoto:(UIButton *)button
{
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
        if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
            SHOW_ALERT(@"需要访问您的相机。\n请启用-设置/隐私/相机");
            return;
        }

        //先判断相机是否可用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
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
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:^{
                
            }];
        }
        
    }
}
//相机的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:@"public.image"]){
            
            //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始，哈哈
            UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            
            
            //图片压缩，因为原图都是很大的，不必要传原图
            UIImage *scaleImage = [self scaleImage:originImage toScale:0.5];
            //        CGFloat folderSize2 =[HZUtil getImageSizeWithImage:scaleImage];
            
            //将图片传递给截取界面进行截取并设置回调方法（协议）
            CaptureViewController *captureView = [[CaptureViewController alloc] init];
            captureView.delegate = self;
            captureView.image = scaleImage;
            //隐藏UIImagePickerController本身的导航栏
            [self presentViewController:captureView animated:YES completion:^{
            }];
        }
    }];
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
        
        self.imageButton.frame = CGRectMake(0, 0, newW, newH);
        self.imageButton.center = CGPointMake(self.contentScrollView.center.x, self.imageButton.center.y + 64);
    }
    else
    {
        CGFloat offsetY = scrollView.contentOffset.y;
        self.imageButton.mh_y = -offsetY * 0.9 + 64;
    }
}
#pragma mark- 缩放图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
#pragma mark - VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    __weak MyInfoViewController *weakSelf = self;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        [weakSelf postImageDataByHttpRequestToServerWithImage:editedImage];
    }];
}
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController
{
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - CaptureViewControllerDelegate
- (void)DoneEditForImage:(UIImage *)image
{
    [self postImageDataByHttpRequestToServerWithImage:image];
}

//发送图片到服务器
-(void)postImageDataByHttpRequestToServerWithImage:(UIImage *)image
{
    [DataHander  showDlg];
    NSData *imgData = UIImageJPEGRepresentation(image,0.3);
    //
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
    __weak MyInfoViewController *weakSelf = self;
    __weak ASIFormDataRequest *weakRequest = request;
    [request setCompletionBlock:^{
        [DataHander hideDlg];
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
            NSString *url = dataDict[@"url"];
            weakSelf.imageKey = imageKey;
            [weakSelf.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            [self saveImage];
        }
        else
        {
            SHOW_ALERT(msg);
        }
        
    }];
    [request setFailedBlock:^{
        [DataHander  hideDlg];
        SHOW_ALERT(@"亲，上传失败，请重新上传");
    }];
    [request startAsynchronous];
    
}

#pragma mark - 请求相关
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
        NSString *msg = returnData[@"msg"];
        
        //给界面赋值
        if ([ret isEqualToString:@"0"])
        {
            NSDictionary *data = returnData[@"data"];
            self.userInfoDict = data;
            [self initMyinfoUIWithData:self.userInfoDict];
        }
        else
        {
            SHOW_ALERT(msg);
        }
    } failureBlock:^(NSError *error) {
    } showHUD:YES];
}

-(void)saveImage
{
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = [NSString stringWithFormat:@"%@%@",DEF_API_Lawyer,uid];
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    [MHAsiNetworkAPI changeLawerProfessionalInfoByuid:uid timestamp:timeStamp sign:sign lawyer_id:uid photo:self.imageKey category:nil edu_background:nil work_language:nil work_qualification:nil work_history:nil work_case:nil SuccessBlock:^(id returnData) {
        NSString *ret = returnData[@"ret"];
        NSString *msg = returnData[@"msg"];
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
//编辑资料
-(void)creatBottomView
{
    //下方
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,DEF_SCREEN_HEIGHT -TRANSFORM_HEIGHT(40.0), DEF_SCREEN_WIDTH, TRANSFORM_HEIGHT(40.0))];
    _bottomView.backgroundColor = DEF_RGBA_COLOR(255, 255, 255, 0.8);
    [self.view addSubview:_bottomView];
    
    //
    UILabel *lineLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 0.5)];
    lineLB.backgroundColor = DEF_RGB_COLOR(196, 196, 196);
    [_bottomView addSubview:lineLB];
    
    //
    UIButton *editeInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editeInfoBtn.frame = CGRectMake([_bottomView width]/4, 10, [_bottomView width]/2, 30);
    [editeInfoBtn transformFrameToFitScreenWithLayoutRect:CGRectMake(20, 5, 130, 30)];
    [editeInfoBtn setTitle:@"编辑资料" forState:UIControlStateNormal];
    [editeInfoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    editeInfoBtn.layer.cornerRadius = 5;
    editeInfoBtn.clipsToBounds = YES;
    editeInfoBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    editeInfoBtn.backgroundColor = [UIColor colorWithRed:0.26 green:0.6 blue:0.87 alpha:1];
    [editeInfoBtn addTarget:self action:@selector(editeInfoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    editeInfoBtn.tag = 505;
    [_bottomView addSubview:editeInfoBtn];
    
    UIButton *professionalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [professionalBtn transformFrameToFitScreenWithLayoutRect:CGRectMake(170, 5, 130, 30)];
    [professionalBtn setTitle:@"职业信息" forState:UIControlStateNormal];
    [professionalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    professionalBtn.layer.cornerRadius = 5;
    professionalBtn.clipsToBounds = YES;
    professionalBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    professionalBtn.backgroundColor = [UIColor colorWithRed:0.26 green:0.6 blue:0.87 alpha:1];
    [professionalBtn addTarget:self action:@selector(editeInfoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    professionalBtn.tag = 506;
    [_bottomView addSubview:professionalBtn];
}
#pragma mark - 进入编辑资料
-(void)editeInfoBtnClick:(UIButton *)btn
{
    NSString *userId = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSDictionary *userInfo = @{@"userId":userId};
    switch (btn.tag) {
        case 505:
        {
            DEF_DEBUG(@"编辑资料");
            [MobClick event:@"LawMyInfo_Edit" attributes:userInfo];
            EditeInfoViewController *vc = [[EditeInfoViewController alloc]init];
            vc.userInfoDict =self.userInfoDict;
            __weak MyInfoViewController *weakSelf = self;
            vc.saveBlock = ^{
                [weakSelf getInfoByHttpRequest];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 506:
        {
            DEF_DEBUG(@"职业信息");
             [MobClick event:@"LawMyInfo_Edit2" attributes:userInfo];
            ProfessionalInformationViewController *vc = [[ProfessionalInformationViewController alloc]init];
            vc.userInfoDict =self.userInfoDict;
            __weak MyInfoViewController *weakSelf = self;
            vc.saveBlock = ^{
                [weakSelf getInfoByHttpRequest];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
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
