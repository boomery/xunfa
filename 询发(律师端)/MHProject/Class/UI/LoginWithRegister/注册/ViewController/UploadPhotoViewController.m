//
//  UploadPhotoViewController.m
//  MHProject
//
//  Created by 杜宾 on 15/8/5.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "UploadPhotoViewController.h"
#import "FDActionSheet.h"
#import "CaptureViewController.h"
#import "VPImageCropperViewController.h"
#import "LoginViewController.h"
#import "ASIFormDataRequest.h"
#import "HZShowImageView.h"
//#import "i"
@interface uploadImageTapGestureRecognizer : UITapGestureRecognizer
@property (nonatomic, strong) UIImageView *uploadImageView;
@end

@implementation uploadImageTapGestureRecognizer
@end

@interface UploadPhotoViewController ()<FDActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,
                 UIAlertViewDelegate>
@property(nonatomic,strong)UIImageView *photoImageView;
@property(nonatomic,strong)UIButton *titleBtn;
@property(nonatomic,strong)NSString *imageKeyStr;
@property(nonatomic,strong)UILabel *sampleLab;
@property(nonatomic,strong)UIView *imageView;
@property(nonatomic,strong)NSMutableArray *imageArr;

@end

@implementation UploadPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    [self initUI];
}
//导航栏
-(void)initNav
{
    [self showNavBarDefaultHUDByNavTitle:@"上传照片" inView:self.view isBack:YES];
}
#pragma mark - 点击事件
- (void)leftNavItemClick
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的认证照片还未上传,如果返回则无法通过律师资格审核请在本页点击“拍摄照片”制作您的三合一照片,您确定要退出吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
      [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)initUI
{
    self.imageArr = [[NSMutableArray alloc]init];
    [self creatContScrollView];
    self.contentScrollView.frame = CGRectMake(0, 64, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - 64 - 44);

    UILabel *textLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, DEF_SCREEN_WIDTH , 40)];
    textLab.text = @"上传一张包含身份证、执业证、名片的照片，以便我们审核您的照片。";
    textLab.textColor = DEF_RGB_COLOR(111, 111, 111);
    textLab.font = DEF_Font(13.5);
    textLab.numberOfLines = 2;
    textLab.textAlignment = 1;
    [self.contentScrollView addSubview:textLab];
    
    _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentScrollView addSubview:_titleBtn];
    _titleBtn.frame = CGRectMake((DEF_SCREEN_WIDTH - 192)/2, DEF_BOTTOM(textLab)+12, 192, 33);
    _titleBtn.layer.masksToBounds = YES;
    _titleBtn.layer.cornerRadius = 3;
    _titleBtn.backgroundColor = DEF_RGB_COLOR(60, 153, 230);
    [_titleBtn setImage:[UIImage imageNamed:@"upload_camear"] forState:UIControlStateNormal];
    [_titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_titleBtn setTitle:@"  上传照片" forState:UIControlStateNormal];
    [_titleBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    
    
    _sampleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(_titleBtn)+34, DEF_SCREEN_WIDTH, 20)];
    _sampleLab.text = @"请参照下方样例拍摄并上传照片";
    _sampleLab.textColor = DEF_RGB_COLOR(111, 111, 111);
    _sampleLab.font = DEF_Font(13.5);
    _sampleLab.textAlignment = 1;
    [self.contentScrollView addSubview:_sampleLab];
    
    
    UIView *sampleView = [[UIView alloc]initWithFrame:CGRectMake(DEF_LEFT(_titleBtn), DEF_BOTTOM(_sampleLab)+12, DEF_WIDTH(_titleBtn), 210)];
    [self.contentScrollView addSubview:sampleView];
    sampleView.backgroundColor = [UIColor whiteColor];
    sampleView.layer.borderColor = DEF_RGB_COLOR(202, 202, 202).CGColor;
    sampleView.layer.borderWidth = LINE_HEIGHT;
    sampleView.layer.masksToBounds = YES;
    sampleView.layer.cornerRadius = 3;
    _imageView = sampleView;

    UIImageView *sampleImageView =[[UIImageView alloc]initWithFrame:CGRectMake(8, 8, DEF_WIDTH(sampleView) - 16, DEF_HEIGHT(sampleView) - 16)];
    sampleImageView.userInteractionEnabled = YES;
    sampleImageView.image = [UIImage imageNamed:@"license_map"];
    [self.imageArr addObject:sampleImageView.image];
    uploadImageTapGestureRecognizer *tap = [[uploadImageTapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1;
    tap.uploadImageView = sampleImageView;
    [sampleImageView addGestureRecognizer:tap];
    [sampleView addSubview:sampleImageView];
    
    
    
//    拍照
    _photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, DEF_BOTTOM(_titleBtn)+12, DEF_SCREEN_WIDTH - 20, 210)];
    _photoImageView.userInteractionEnabled = YES;
    _photoImageView.backgroundColor = [UIColor whiteColor];
    _photoImageView.hidden = YES;
    _photoImageView.layer.borderColor = DEF_RGB_COLOR(202, 202, 202).CGColor;
    _photoImageView.layer.borderWidth = LINE_HEIGHT;
    [self.contentScrollView addSubview:_photoImageView];


    //   确认按钮
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(0,DEF_SCREEN_HEIGHT - 44 , DEF_SCREEN_WIDTH, 44);
    confirmBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];

    [confirmBtn setTitle:@"提交审核" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        confirmBtn.backgroundColor = DEF_RGB_COLOR(60, 153, 230);
    confirmBtn.showsTouchWhenHighlighted = YES;
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
//    self.contentScrollView.backgroundColor = [UIColor redColor];
    
    self.contentScrollView.contentSize = CGSizeMake(DEF_SCREEN_WIDTH,DEF_HEIGHT(textLab)+DEF_HEIGHT(_titleBtn)+DEF_HEIGHT(_sampleLab)+DEF_HEIGHT(sampleView)+20+12+34+12);

}
- (void)tap:(uploadImageTapGestureRecognizer *)recognizer
{
    
//    NSInteger index = recognizer.view.tag;
    DEF_DEBUG(@"%@",self.imageArr);
    HZShowImageView *showImageView = [[HZShowImageView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT) withImageArray:self.imageArr  clickIndex:0];
    [showImageView show];
}

//上传照片
-(void)imageBtnClick:(UIButton *)btn
{
    
    DEF_DEBUG(@"上传照片");
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
//    UIImage *imageV = [self scaleImage:img toScale:0.5];

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
    NSData *imgData = UIImageJPEGRepresentation(image,0.3);
    NSString *uid =self.lawyerId;
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = self.token;
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
//    __weak UploadPhotoViewController *weakSelf = self;
    __weak ASIFormDataRequest *weakRequest = request;
    [request setCompletionBlock:^{
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
           self.imageKeyStr = dataDict[@"key"];
            if (self.imageKeyStr != nil)
            {
                _photoImageView.hidden = NO;
                _photoImageView.image = image;
                _sampleLab.frame = CGRectMake(0, DEF_BOTTOM(_photoImageView)+12, DEF_SCREEN_WIDTH, 20);
                _imageView.frame = CGRectMake(DEF_LEFT(_titleBtn), DEF_BOTTOM(_sampleLab)+12, DEF_WIDTH(_titleBtn), 210);
                [_titleBtn setTitle:@" 修改照片" forState:UIControlStateNormal];
                
                self.contentScrollView.contentSize = CGSizeMake(DEF_SCREEN_WIDTH,DEF_BOTTOM(_imageView)+20);
            }
        }
        else
        {
            SHOW_ALERT(msg);
        }
        [DataHander hideDlg];
    }];
    [request setFailedBlock:^{
        SHOW_ALERT(@"亲，上传失败，请重新上传");
        [DataHander  hideDlg];
    }];
    [request startAsynchronous];
    
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
//提交审核
-(void)confirmBtnClick:(UIButton *)btn
{
    
    if ([NSString isBlankString:self.imageKeyStr])
    {
        SHOW_ALERT(@"请上传照片");
    }
    else
    {
        NSString *uid =self.lawyerId;
        NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
        NSString *token = self.token;
        NSString *url = [NSString stringWithFormat:@"%@",DEF_API_LawyerAudit];
        NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
        [MHAsiNetworkAPI uploadLawyerPhotoWithuid:uid timestamp:timeStamp sign:sign audit_pic:self.imageKeyStr SuccessBlock:^(id returnData) {
            
            DEF_DEBUG(@"%@",returnData);
            NSString *ret = returnData[@"ret"];
            NSString *msg = returnData[@"msg"];
            
            if ([ret isEqualToString:@"0"])
            {
                
                NSArray *array = self.navigationController.childViewControllers;
                for (BaseViewController *vc in array) {
                    if ([vc isKindOfClass:[LoginViewController class]]) {
                        LoginViewController *detailVC = (LoginViewController *)vc;
                        [self.navigationController popToViewController:detailVC animated:YES];
                    }
                }
                SHOW_ALERT(msg)
            }
            else
            {
                SHOW_ALERT(msg);
            }
            
            
        } failureBlock:^(NSError *error) {
            
        } showHUD:NO];
 
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
