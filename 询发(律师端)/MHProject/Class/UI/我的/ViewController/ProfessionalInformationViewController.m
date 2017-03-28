//
//  ProfessionalInformationViewController.m
//  MHProject
//
//  Created by 张好志 on 15/7/14.
//  Copyright (c) 2015年 Andy. All rights reserved.
//
#define FieldHeight 44
#define SpaceHeight 12
#import "ProfessionalInformationViewController.h"
#import "HZUtil.h"
#import "FDActionSheet.h"
#import "ASIFormDataRequest.h"
#import "QLeftLabelTextField.h"
#import "UIPlaceHolderTextView.h"
#import "MHKeyboard.h"
#import "FieldViewController.h"
#import "JSONKit.h"
#import "UIImage+Resize.h"
#import "CaptureViewController.h"
#import "VPImageCropperViewController.h"
#define ORIGINAL_MAX_WIDTH 640
@interface ProfessionalInformationViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UITextViewDelegate, CaptureViewControllerDelegate, VPImageCropperDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UIImage *headImage;
@property (nonatomic, strong) UIButton *imageButton;
//保存律师的擅长领域，在选择擅长领域界面使用(数组包含字符串形式)
@property (nonatomic, strong) NSMutableArray *filedsArray;
//保存律师的擅长领域，在选择擅长领域界面使用(字典形式)
@property (nonatomic, strong) NSMutableArray *selectDictArray;

@property (nonatomic, strong) QLeftLabelTextField *filedTF;
@property (nonatomic, strong) QLeftLabelTextField *educationTF;
@property (nonatomic, strong) QLeftLabelTextField *languageTF;
@property (nonatomic, strong) QLeftLabelTextField *qulificationTF;
@property (nonatomic, strong) UIPlaceHolderTextView *experienceTextView;
@property (nonatomic, strong) UIPlaceHolderTextView *caseTextView;
@property (nonatomic, copy) NSString *imageKey;
@end

@implementation ProfessionalInformationViewController

#pragma mark -- view lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.filedsArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    [self initUI];

    [self initNav];
    
    [self setData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
}
#pragma mark - 初始化
-(void)initNav
{
    [self showNavBarWithTwoBtnHUDByNavTitle:@"职业信息" leftImage:@"menu-left-back" leftTitle:@"" rightImage:@"" rightTitle:@"保存" inView:self.view isBack:YES];
}
#pragma mark - 点击事件
- (void)leftNavItemClick
{
    [MobClick event:@"LawMyInfoEdit2_Back"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initUI
{
    [self creatContScrollView];
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
    [MHKeyboard addRegisterTheViewNeedMHKeyboard:self.contentScrollView];
    float x = 12;
    float y = 12;
    //
    
    //
    self.filedTF = [[QLeftLabelTextField alloc] initWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-24 , FieldHeight)];
    self.filedTF.leftLbl.text = @"擅长领域";
    self.filedTF.rightField.font = FONT;
    self.filedTF.rightField.placeholder = @"请选择您的擅长领域";
    self.filedTF.rightField.textColor = DEF_RGB_COLOR(159, 159, 159);
    self.filedTF.rightImageBtn.hidden = YES;
    self.filedTF.rightField.delegate = self;
    self.filedTF.rightField.returnKeyType = UIReturnKeyDone;
    [self.contentScrollView addSubview:self.filedTF];
    UIButton *filedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filedButton.frame = self.filedTF.frame;
    [filedButton addTarget:self action:@selector(selectField) forControlEvents:UIControlEventTouchUpInside];
    [self.contentScrollView addSubview:filedButton];
    
    
    UIImageView *smallArrow = [[UIImageView alloc] init];
    smallArrow.frame = CGRectMake(self.filedTF.width - 25, 17, 5, 10);
    smallArrow.image = [UIImage imageNamed:@"arrow-right"];
    [self.filedTF addSubview:smallArrow];
    y+= self.filedTF.height + SpaceHeight;
    
    self.educationTF = [[QLeftLabelTextField alloc] initWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-2*x , FieldHeight)];
    self.educationTF.leftLbl.text = @"教育背景";
    self.educationTF.rightField.placeholder = @"请输入教育背景";
    self.educationTF.rightField.textColor = DEF_RGB_COLOR(159, 159, 159);
    self.educationTF.rightImageBtn.hidden = YES;
    self.educationTF.rightField.delegate = self;
    self.educationTF.rightField.returnKeyType = UIReturnKeyDone;
    [self.contentScrollView addSubview:self.educationTF];
    y+= self.educationTF.height + SpaceHeight;

    //
    self.languageTF = [[QLeftLabelTextField alloc] initWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-24, FieldHeight)];
    self.languageTF.leftLbl.text = @"擅长语言";
    self.languageTF.rightField.placeholder = @"请输入您的擅长语言";
    self.languageTF.rightField.textColor = DEF_RGB_COLOR(159, 159, 159);
    self.languageTF.rightImageBtn.hidden = YES;
    self.languageTF.rightField.delegate = self;
    self.languageTF.rightField.returnKeyType = UIReturnKeyDone;
    [self.contentScrollView addSubview:self.languageTF];
    y+= self.languageTF.height;

    /*
    UILabel *experienceLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH - 2*x, FieldHeight)];
    experienceLabel.font = FONT;
    experienceLabel.text = @"工作经历";
    [self.contentScrollView addSubview:experienceLabel];
    y+= experienceLabel.height;

    self.experienceTextView = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-24,220)];
    self.experienceTextView.scrollEnabled = YES;
    self.experienceTextView.font        = FONT;
    self.experienceTextView.textColor   = [UIColor blackColor];
    self.experienceTextView.placeholder =@"最多输入三百字";
    self.experienceTextView.placeholderColor = DEF_RGB_COLOR(178, 196, 205);
    self.experienceTextView.delegate    = self;
    self.experienceTextView.layer.cornerRadius = 5;
    self.experienceTextView.tag = 300;
    self.experienceTextView.clipsToBounds = YES;
    [self.contentScrollView addSubview:self.experienceTextView];
    y+= self.experienceTextView.height;
    
    UILabel *caseLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-2*x, FieldHeight)];
    caseLabel.font = FONT;
    caseLabel.text = @"案例介绍";
    [self.contentScrollView addSubview:caseLabel];
    y+= caseLabel.height;

    self.caseTextView = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-24, 220)];
    self.caseTextView.scrollEnabled = YES;
    self.caseTextView.font        = DEF_Font(16);
    self.caseTextView.textColor   = [UIColor blackColor];
    self.caseTextView.placeholder =@"最多输入五百字";
    self.caseTextView.placeholderColor = DEF_RGB_COLOR(178, 196, 205);
    self.caseTextView.delegate    = self;
    self.caseTextView.layer.cornerRadius = 5;
    self.caseTextView.tag = 500;
    self.caseTextView.clipsToBounds = YES;
    self.caseTextView.delegate = self;
    self.caseTextView.returnKeyType = UIReturnKeyDone;
    [self.contentScrollView addSubview:self.caseTextView];
    y+= self.caseTextView.height + SpaceHeight;
     */

    if (y < DEF_SCREEN_HEIGHT - 64)
    {
        y = DEF_SCREEN_HEIGHT;
    }
    [self.contentScrollView setContentSize:CGSizeMake(0, y)];
}
- (NSString *)stringWithJsonArray:(NSArray *)array
{
    NSString *filedsString = @"";
    [self.filedsArray removeAllObjects];
    for (NSDictionary *filedDict in array)
    {
        filedsString = [filedsString stringByAppendingString:[NSString stringWithFormat:@"%@ ",[filedDict allValues][0]]];
        [self.filedsArray addObject:[filedDict allValues][0]];
    }
    return filedsString;
}
- (NSString *)stringWithArray:(NSArray *)array
{
    NSString *filedsString = @"";
    [self.filedsArray removeAllObjects];
    for (NSDictionary *filedDict in array)
    {
        filedsString = [filedsString stringByAppendingString:[NSString stringWithFormat:@"%@ ",filedDict[@"name"]]];
        [self.filedsArray addObject:filedDict[@"name"]];
    }
    return filedsString;
}
-(void)setData
{
    NSString *photo = self.userInfoDict[@"photo"];
    NSArray *filedsArray = self.userInfoDict[@"category"];
    NSString *filedsString = [self stringWithJsonArray:filedsArray];
    NSString *education = self.userInfoDict[@"edu_background"];
    NSString *language = self.userInfoDict[@"work_language"];
    NSString *experience = self.userInfoDict[@"work_history"];
    NSString *caseText = self.userInfoDict[@"work_case"];
    NSString *qualification = self.userInfoDict[@"work_qualification"];

    if (photo.length > 0)
    {
        [self.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:photo] forState:UIControlStateNormal];
    }
    self.filedTF.rightField.text = filedsString;
    self.educationTF.rightField.text = education;
    self.languageTF.rightField.text = language;
    self.qulificationTF.rightField.text = qualification;
    self.experienceTextView.text = experience;
    self.caseTextView.text = caseText;
}
#pragma mark - 保存律师职业信息
- (void)rightNavItemClick
{
    [MobClick event:@"LawMyInfoEdit2_Save"];
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = [NSString stringWithFormat:@"%@%@",DEF_API_Lawyer,uid];
    NSMutableArray *filedsArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in self.selectDictArray)
    {
        NSDictionary *newDict = @{dict[@"id"]:dict[@"name"]};
        [filedsArray addObject:newDict];
    }
    NSString *jsonFiledsString = nil;

    if (filedsArray.count > 0)
    {
        jsonFiledsString = [filedsArray JSONString];
    }
    
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    [MHAsiNetworkAPI changeLawerProfessionalInfoByuid:uid timestamp:timeStamp sign:sign lawyer_id:uid photo:self.imageKey category:jsonFiledsString edu_background:self.educationTF.rightField.text work_language:self.languageTF.rightField.text work_qualification:self.qulificationTF.rightField.text work_history:self.experienceTextView.text work_case:self.caseTextView.text SuccessBlock:^(id returnData) {
        NSString *ret = returnData[@"ret"];
        NSString *msg = returnData[@"msg"];
        //给界面赋值
        if ([ret isEqualToString:@"0"])
        {
            self.saveBlock();
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            SHOW_ALERT(msg);
        }
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}

#pragma mark - 进入领域选择
- (void)selectField
{
    FieldViewController *field = [[FieldViewController alloc] init];
    field.selectedFieldsArray = [NSMutableArray arrayWithArray:self.filedsArray];
    __weak ProfessionalInformationViewController *weakSelf = self;
    field.saveBlock = ^(NSMutableArray *selectDictArray){
        weakSelf.filedTF.rightField.text = [self stringWithArray:selectDictArray];
        weakSelf.selectDictArray = selectDictArray;
    };
    [self.navigationController pushViewController:field animated:YES];
}

#pragma mark - UITextFieldDelegate
//本处根据tag判断需要限制的字数
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *toBeString = textView.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > textView.tag) {
                textView.text = [toBeString substringToIndex:textView.tag];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > textView.tag) {
            textView.text = [toBeString substringToIndex:textView.tag];
        }
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
#pragma mark - VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    __weak ProfessionalInformationViewController *weakSelf = self;
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
#pragma mark- 缩放图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

//发送图片到服务器
-(void)postImageDataByHttpRequestToServerWithImage:(UIImage *)image
{
//    获取图片的大小
//    CGFloat folderSize =[HZUtil getImageSizeWithImage:image];
//    NSLog(@"图片大小:%.2f",folderSize);
//    
//    NSData *imgData;
//    if (folderSize>1) {
//        imgData = UIImageJPEGRepresentation(image,0.5);
//    }
//    //压缩图片，如果大于10M就压缩
//    if (folderSize>10.0) {
//        imgData = UIImageJPEGRepresentation(image,10.0/folderSize);
//    }
//    CGSize imageSize = [image size];
//    CGFloat scale = 640.0/imageSize.width;
//    CGSize size = CGSizeMake(640, imageSize.height*scale);
//    UIImage *resizedImage = [image imageCompressForSize:image targetSize:size];
    NSData *imgData = UIImagePNGRepresentation(image);
    
    //
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = DEF_API_UserUploadImage;
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    NSString *str = [NSString stringWithFormat:@"%@?uid=%@&timestamp=%@&sign=%@",url,uid,timeStamp,sign];
    NSURL *completeUrl = [NSURL URLWithString:str];
    [DataHander  showDlg];
#pragma mark 使用ASIHttpRequest 上传图片和数据
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:completeUrl];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request setRequestMethod:@"POST"];
    [request addData:imgData withFileName:@"file" andContentType:@"image/png" forKey:@"body"];
    [request addData:imgData forKey:@"file"];
    __weak ProfessionalInformationViewController *weakSelf = self;
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
            NSString *imageKey = dataDict[@"key"];
            NSString *url = dataDict[@"url"];
            weakSelf.imageKey = imageKey;
            [weakSelf.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
        }
        else
        {
            SHOW_ALERT(msg);
        }
        [DataHander  hideDlg];
    }];
    [request setFailedBlock:^{
        SHOW_ALERT(@"亲，上传失败，请重新上传");
        [DataHander  hideDlg];
    }];
    [request startAsynchronous];
    
}
#pragma mark -- UITextFieldDelegate
// 结束编辑的时候下键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.view endEditing:YES];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
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
