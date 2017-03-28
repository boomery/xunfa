//
//  ApplyAppointmentViewController.m
//  MHProject
//
//  Created by ZhangChaoxin on 15/8/25.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "ApplyAppointmentViewController.h"
#import "QLeftLabelTextField.h"
#import "FieldViewController.h"
#import "CityCustomPickerView.h"
#import "CityModel.h"
#import "TownShipModel.h"
#import "UIPlaceHolderTextView.h"
#import "FDActionSheet.h"
#import "ASIFormDataRequest.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CaptureViewController.h"
#import "MHKeyboard.h"
#import "JSONKit.h"
#define FieldHeight 44
#define SpaceHeight 12
@interface ApplyAppointmentViewController () <CustomPickerViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CaptureViewControllerDelegate, UIScrollViewDelegate, UIAlertViewDelegate>
{
    NSString *_productID;
}
@property (nonatomic, copy) NSString *imageKey;
@property (nonatomic, assign) NSInteger selectedCityIndex;
@property (nonatomic, strong) NSMutableArray *cityArray;
//保存律师的擅长领域，在选择擅长领域界面使用(数组包含字符串形式)
@property (nonatomic, strong) NSMutableArray *filedsArray;
//保存律师的擅长领域，在选择擅长领域界面使用(字典形式)
@property (nonatomic, strong) NSMutableArray *selectDictArray;
@property (nonatomic, strong) CityCustomPickerView *cityPicker;
@property (nonatomic, strong) QLeftLabelTextField *priceTF;
@property (nonatomic, strong) QLeftLabelTextField *sloganTF;
@property (nonatomic, strong) QLeftLabelTextField *filedTF;
@property (nonatomic, strong) QLeftLabelTextField *locationTF;
@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) UIPlaceHolderTextView *suggestionTextView;
@end

@implementation ApplyAppointmentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatContScrollView];
    self.contentScrollView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [MHKeyboard addRegisterTheViewNeedMHKeyboard:self.contentScrollView];
    self.filedsArray = [[NSMutableArray alloc] init];
    self.cityArray = [[NSMutableArray alloc] init];
    [self initCity];
    [self initNav];
    [self initUI];
    [self setData];
}

-(void)initNav
{
//    判断是否开通约见申请
    if ([self.meet_is_on intValue] == 0)
    {
          [self showNavBarWithTwoBtnHUDByNavTitle:@"约见开通申请" leftImage:@"menu-left-back" leftTitle:@"" rightImage:@"" rightTitle:@"提交审核" inView:self.view isBack:YES];
    }
    else{
            [self showNavBarWithTwoBtnHUDByNavTitle:@"修改约见资料" leftImage:@"menu-left-back" leftTitle:@"" rightImage:@"" rightTitle:@"提交审核" inView:self.view isBack:YES];
    }

}
- (QLeftLabelTextField *)createQTFWithFrame:(CGRect)frame
{
    QLeftLabelTextField *qTF = [[QLeftLabelTextField alloc] initWithFrame:frame];
    qTF.leftLbl.textColor = DEF_RGB_COLOR(111, 111, 111);
    qTF.leftLbl.font = DEF_Font(16.0);
    qTF.rightField.textColor =  DEF_RGB_COLOR(159, 159, 159);
    qTF.rightField.font = DEF_Font(16.0);
    qTF.rightField.returnKeyType = UIReturnKeyDone;
    qTF.rightImageBtn.hidden = YES;
    [self.contentScrollView addSubview:qTF];
    return qTF;
}
-(void)initUI
{
    float x = 12;
    float y = 20;
    
    QLeftLabelTextField *priceTF = [self createQTFWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-24 , FieldHeight)];
    priceTF.leftLbl.text = @"约见价格";
    priceTF.rightField.placeholder = @"200 元/小时";
    priceTF.canEdit = NO;
    self.priceTF = priceTF;
    
    //
    y+= FieldHeight+SpaceHeight;
    QLeftLabelTextField *sloganTF = [self createQTFWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-24 , FieldHeight)];
    
    [sloganTF.rightField addTarget:self action:@selector(textFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
    sloganTF.rightField.tag = 16;
    sloganTF.rightField.placeholder = @"口号不得超过十六个字";
    sloganTF.leftLbl.text = @"约见口号";
    sloganTF.rightField.delegate = self;
    self.sloganTF = sloganTF;
    
    //
    y+= FieldHeight+SpaceHeight;
    QLeftLabelTextField *filedTF = [self createQTFWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-24 , FieldHeight)];
    filedTF.rightField.font = FONT;

    filedTF.leftLbl.text = @"擅长领域";
    filedTF.rightField.placeholder = @"请选择您的擅长领域";
    self.filedTF = filedTF;
    
    UIButton *filedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filedButton.frame = filedTF.frame;
    [filedButton addTarget:self action:@selector(selectField) forControlEvents:UIControlEventTouchUpInside];
    [self.contentScrollView addSubview:filedButton];
    
    UIImageView *smallArrow = [[UIImageView alloc] init];
    smallArrow.frame = CGRectMake(self.filedTF.width - 25, 17, 5, 10);
    smallArrow.image = [UIImage imageNamed:@"arrow-right"];
    [filedTF addSubview:smallArrow];
    
    //
    y+= FieldHeight+SpaceHeight;
    QLeftLabelTextField *locationTF = [self createQTFWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-24 , FieldHeight)];
    locationTF.rightField.delegate= self;
    locationTF.leftLbl.text = @"所 在 地";
    locationTF.rightField.placeholder = @"请选择您的地址";
    self.locationTF = locationTF;
    
    CityCustomPickerView *picker = [[CityCustomPickerView alloc] init];
    picker.frame = CGRectMake(0, DEF_SCREEN_HEIGHT-64, DEF_SCREEN_WIDTH, 260);
    picker.delegate = self;
    locationTF.rightField .inputView = picker;
    picker.pickerView.dataSource = self;
    picker.pickerView.delegate = self;
    self.cityPicker = picker;
    
    y+= FieldHeight +SpaceHeight;
    UIView *photoView = [[UIView alloc] initWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH - 24, (DEF_SCREEN_WIDTH-24)*(390.0/640)+46)];
    photoView.clipsToBounds = YES;
    photoView.layer.cornerRadius = 5;
    photoView.backgroundColor = [UIColor whiteColor];
    [self.contentScrollView addSubview:photoView];
    
    UIButton *photoButton = [[UIButton alloc] initForAutoLayout];
    [photoView addSubview:photoButton];
    [photoButton addTarget:self action:@selector(uploadButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [photoButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(38, 8, 8, 8)];
    photoButton.backgroundColor = [UIColor grayColor];
    self.photoButton = photoButton;
    
    //编辑图
    UIImageView *editImageView = [[UIImageView alloc] initForAutoLayout];
    [photoButton addSubview:editImageView];
    [editImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:photoButton withOffset:12];
    [editImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:photoButton withOffset:-12];
    [editImageView autoSetDimensionsToSize:CGSizeMake(18, 17)];
    editImageView.image = [UIImage imageNamed:@"revise_edit"];
    
    UILabel *tipLabel = [[UILabel alloc] initForAutoLayout];
    [photoView addSubview:tipLabel];
    tipLabel.textColor = DEF_RGB_COLOR(111, 111, 111);
    [tipLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:photoView withOffset:8];
    [tipLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:photoView withOffset:8];
    [tipLabel autoSetDimensionsToSize:CGSizeMake(100, 22)];
    tipLabel.font = DEF_Font(16.0);
    tipLabel.text = @"修改展示图";
    
    y+= photoView.height + SpaceHeight;
    UILabel *userLB = [[UILabel alloc]initWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-20, 30)];
    userLB.textColor = DEF_RGB_COLOR(111, 111, 111);
    userLB.text = @"约见介绍";
    [self.contentScrollView addSubview:userLB];
    
    y+= FieldHeight;
    self.suggestionTextView = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(x, DEF_BOTTOM(userLB)+5, DEF_SCREEN_WIDTH-20,130/568.0 *DEF_SCREEN_HEIGHT)];
    self.suggestionTextView.scrollEnabled = YES;
    self.suggestionTextView.font        = [UIFont systemFontOfSize:16];
    self.suggestionTextView.textColor   = DEF_RGB_COLOR(111, 111, 111);
    self.suggestionTextView.placeholderColor = DEF_RGB_COLOR(159, 159, 159);
    self.suggestionTextView.placeholder = @"介绍不得超过三十个字";
    self.suggestionTextView.tag = 30;
    self.suggestionTextView.delegate    = self;
    self.suggestionTextView.returnKeyType = UIReturnKeyDone;
    self.suggestionTextView.layer.cornerRadius = 5;
    self.suggestionTextView.clipsToBounds = YES;
    self.suggestionTextView.layer.borderWidth = LINE_HEIGHT;
    self.suggestionTextView.layer.borderColor = DEF_RGB_COLOR(202, 202, 202).CGColor;
    [self.contentScrollView addSubview:self.suggestionTextView];
    
    y+= self.suggestionTextView.height + SpaceHeight;
    self.contentScrollView.contentSize = CGSizeMake(0, y);
}
- (void)setData
{
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = [NSString stringWithFormat:@"%@",DEF_API_applyForBeingOrderLawyer];
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    //修改约见资料
    if (!self.infoDict)
    {
        __weak ApplyAppointmentViewController *weakSelf = self;
        [MHAsiNetworkAPI lookOverOrderLawyerInfoWithuid:uid timestamp:timeStamp sign:sign SuccessBlock:^(id returnData) {
            NSString *ret = returnData[@"ret"];
            NSString *msg = returnData[@"msg"];
            if ([ret isEqualToString:@"0"])
            {
                NSArray *data = returnData[@"data"];
                if (data.count > 0)
                {
                    NSDictionary *dict = data[0];
                    weakSelf.sloganTF.rightField.text = dict[@"title"];
                    _productID = dict[@"id"];
                    NSArray *categoryArray = dict[@"category"];
                    weakSelf.filedTF.rightField.text = [weakSelf stringWithJsonArray:categoryArray];
                    NSString *city = dict[@"city"];
                    NSString *region = dict[@"region"];
                    
                    //所在地
                    if (region)
                    {
                        weakSelf.locationTF.rightField.text = [city stringByAppendingString:[NSString stringWithFormat:@" %@",region]];
                    }
                    else
                    {
                        weakSelf.locationTF.rightField.text = city;
                    }
                    
                    [weakSelf.photoButton sd_setBackgroundImageWithURL:[NSURL URLWithString:dict[@"photo"]] forState:UIControlStateNormal];
                    weakSelf.suggestionTextView.text = dict[@"intr"];
                }
            }
            else
            {
                SHOW_ALERT(msg);
            }
        } failureBlock:^(NSError *error) {
            
        } showHUD:YES];
        return;
    }

    //第一次开通
    self.filedTF.rightField.text = [self stringWithJsonArray:self.infoDict[@"category"]];
    NSString *city = self.infoDict[@"city"];
    NSString *region = self.infoDict[@"region"];
    
    //所在地
    if (region)
    {
        self.locationTF.rightField.text = [city stringByAppendingString:[NSString stringWithFormat:@" %@",region]];
    }
    else
    {
        self.locationTF.rightField.text = city;
    }

    [self.photoButton sd_setBackgroundImageWithURL:[NSURL URLWithString:self.infoDict[@"photo"]] forState:UIControlStateNormal];
}
- (void)initCity
{
    //获取城市信息，（首次加载下载该文件，保存到本地，在此进入直接从本地取值）
    NSString *city_version = DEF_PERSISTENT_GET_OBJECT(DEF_local_City_version);
    NSString *serverCity_version = DEF_PERSISTENT_GET_OBJECT(DEF_server_City_version);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",city_version]];   // 保存文件的名称
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath] || ![serverCity_version isEqualToString:city_version])
    {
        [self getCityRequester];
    }
    else
    {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        NSArray *array = dict[@"data"];
        for (NSDictionary *dict in array)
        {
            CityModel *model = [[CityModel alloc]initWithDict:dict];
            
            [self.cityArray addObject:model];
        }
    }

}
#pragma mark - 点击上传图片
- (void)uploadButtonClick
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

#pragma mark - UIImagePickerControllerDelegate
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
    __weak ApplyAppointmentViewController *weakSelf = self;
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
            [weakSelf.photoButton sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
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

#pragma mark- 缩放图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
#pragma mark - 获取城市列表
-(void)getCityRequester
{
    NSString *localCity_version = DEF_PERSISTENT_GET_OBJECT(DEF_local_City_version);
    NSString *serverCity_version = DEF_PERSISTENT_GET_OBJECT(DEF_server_City_version);
    
    //    ShowLoadingView(self.view, @"loading");
    [MHAsiNetworkAPI getCityBySuccessBlock:^(id returnData) {
        DEF_DEBUG(@"获取城市信息：%@",returnData);
        
        NSString *ret = returnData[@"ret"];
        NSString *msg = returnData[@"msg"];
        //         NSDictionary *data = returnData[@"data"];
        //给界面赋值
        if ([ret isEqualToString:@"0"])
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",serverCity_version]];   // 保存文件的名称
            if ([returnData writeToFile:filePath atomically:YES])
            {
                DEF_PERSISTENT_SET_OBJECT(serverCity_version, DEF_local_City_version);
                NSString *oldFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",localCity_version]];   // 保存文件的名称
                [[NSFileManager defaultManager] removeItemAtPath:oldFilePath error:nil];
            }
            NSArray *array = returnData[@"data"];
            for (NSDictionary *dict in array)
            {
                CityModel *model = [[CityModel alloc]initWithDict:dict];
                [self.cityArray addObject:model];
            }
        }
        else
        {
            SHOW_ALERT(msg);
        }
        //        HiddenLoadingView(self.view);
    } failureBlock:^(NSError *error) {
        //        HiddenLoadingView(self.view);
    } showHUD:YES];
}
#pragma mark - UITextFieldDelegate
-(void)textFiledEditChanged:(UITextField *)textField
{
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > textField.tag) {
                textField.text = [toBeString substringToIndex:textField.tag];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > textField.tag) {
            textField.text = [toBeString substringToIndex:textField.tag];
        }
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.locationTF.rightField])
    {
        NSString *address = self.locationTF.rightField.text;
        NSRange range = [address rangeOfString:@" "];
        if (range.location != NSNotFound)
        {
            NSString *city = [address substringToIndex:range.location];
            NSString *district = [address substringFromIndex:range.location+1];
            NSInteger componentIndex = 0;
            NSInteger rowIndex = 0;
            for (CityModel *cityModel in self.cityArray)
            {
                if ([cityModel.district_name isEqualToString:city])
                {
                    componentIndex = [self.cityArray indexOfObject:cityModel];
                    for (TownShipModel *model in cityModel.townMutableArray)
                    {
                        if ([model.townshipName isEqualToString:district])
                        {
                            rowIndex = [cityModel.townMutableArray indexOfObject:model];
                            break;
                        }
                    }
                    break;
                }
            }
            self.selectedCityIndex = componentIndex;
            [self.cityPicker.pickerView selectRow:componentIndex inComponent:0 animated:YES];
            [self.cityPicker.pickerView selectRow:rowIndex inComponent:1 animated:YES];
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"])
    {
        //结束编辑
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
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
#pragma mark - CustomPickerViewDelegate
- (void)customPickerView:(CityCustomPickerView *)pickerView didClickCancelButton:(UIButton *)cancelButton
{
    [self.view endEditing:YES];
}
- (void)customPickerView:(CityCustomPickerView *)pickerView didClickConfirmButton:(UIButton *)confirmButton
{
    CityModel *city = self.cityArray[[pickerView.pickerView selectedRowInComponent:0]];
    NSInteger selecedIndex = [pickerView.pickerView selectedRowInComponent:1];
    if (city.townMutableArray.count > selecedIndex)
    {
        TownShipModel *town = city.townMutableArray[selecedIndex];
        self.locationTF.rightField.text = [[NSString stringWithFormat:@"%@ ",city.district_name] stringByAppendingString:town.townshipName];
    }
    [self.view endEditing:YES];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return  2;
}

//显示每个分区有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.cityArray.count;
    }
    else
    {
        if (self.cityArray.count > 0)
        {
            CityModel *model = self.cityArray[self.selectedCityIndex];
            return model.townMutableArray.count;;
        }
        return 0;
    }
}
//每个分区显示的内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0)
    {
        CityModel * model=self.cityArray[row];
        return model.district_name;
    }
    else
    {
        CityModel * model=self.cityArray[self.selectedCityIndex];
        TownShipModel *model1 = model.townMutableArray[row];
        return model1.townshipName;
    }
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0)
    {
        //        [pickerView selectRow:0 inComponent:1 animated:YES];
        self.selectedCityIndex = row;
        [pickerView reloadComponent:1];
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view   endEditing:YES];
}
#pragma mark - 选择擅长领域
- (void)selectField
{
    FieldViewController *field = [[FieldViewController alloc] init];
    field.selectedFieldsArray = [NSMutableArray arrayWithArray:self.filedsArray];
    __weak ApplyAppointmentViewController *weakSelf = self;
    field.saveBlock = ^(NSMutableArray *selectDictArray){
        weakSelf.filedTF.rightField.text = [self stringWithArray:selectDictArray];
        weakSelf.selectDictArray = selectDictArray;
    };
    [self.navigationController pushViewController:field animated:YES];
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
#pragma mark - 返回
- (void)leftNavItemClick
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否放弃对资料的修改？" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"继续编辑", nil];
    [alertView show];
    
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - 提交审核
- (void)rightNavItemClick
{
    if (self.sloganTF.rightField.text.length == 0 || self.suggestionTextView.text.length == 0)
    {
        [DataHander showInfoWithTitle:@"口号或介绍不能为空"];
        return;
    }
//    判断是否开通了申请，如果开通了就是提交审核的接口 否则就是修改接口
    if ([self.meet_is_on intValue] == 0)
    {
//        提交审核
        [self commitAudit];
    }
    else
    {
//        修改审核
        [self modifyAudit];
    }
}

#pragma mark -  提交审核
-(void)commitAudit
{
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = [NSString stringWithFormat:@"%@",DEF_API_applyForBeingOrderLawyer];
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];

    //将擅长领域组装为Json字符串
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
    
    //将保存的城市信息转化为id，方便后台检索
    NSString *addressString = self.locationTF.rightField.text;
    NSArray *addressArray = [addressString componentsSeparatedByString:@" "];
    NSString *cityId = nil;
    NSString *townId = nil;
    if (addressArray.count > 1)
    {
        NSString *city = addressArray[0];
        NSString *town = addressArray[1];
        for (CityModel *model in self.cityArray)
        {
            if ([model.district_name isEqualToString:city])
            {
                cityId = model.district_id;
                for (TownShipModel *subModel in model.townMutableArray)
                {
                    if ([subModel.townshipName isEqualToString:town])
                    {
                        townId = subModel.township_id;
                        break;
                    }
                }
                break;
            }
        }
    }
    
    [DataHander showDlg];
    [MHAsiNetworkAPI applyForBeingOrderLawyerWithuid:uid timestamp:timeStamp sign:sign lawyer_id:uid category:jsonFiledsString city:cityId region:townId photo:self.imageKey price:@"200" title:self.sloganTF.rightField.text intr:self.suggestionTextView.text SuccessBlock:^(id returnData) {
        NSString *ret = returnData[@"ret"];
        NSString *msg = returnData[@"msg"];
        if ([ret isEqualToString:@"0"])
        {
            [DataHander showSuccessWithTitle:@"提交审核成功" completionBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        else
        {
            [DataHander hideDlg];
            SHOW_ALERT(msg);
        }
    } failureBlock:^(NSError *error) {
        [DataHander hideDlg];
    } showHUD:NO];
    
}

#pragma mark -  修改审核
-(void)modifyAudit
{
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = [NSString stringWithFormat:@"%@/%@",DEF_API_applyForBeingOrderLawyer,_productID];
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    //将擅长领域组装为Json字符串
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
    
    //将保存的城市信息转化为id，方便后台检索
    NSString *addressString = self.locationTF.rightField.text;
    NSArray *addressArray = [addressString componentsSeparatedByString:@" "];
    NSString *cityId = nil;
    NSString *townId = nil;
    if (addressArray.count > 1)
    {
        NSString *city = addressArray[0];
        NSString *town = addressArray[1];
        for (CityModel *model in self.cityArray)
        {
            if ([model.district_name isEqualToString:city])
            {
                cityId = model.district_id;
                for (TownShipModel *subModel in model.townMutableArray)
                {
                    if ([subModel.townshipName isEqualToString:town])
                    {
                        townId = subModel.township_id;
                        break;
                    }
                }
                break;
            }
        }
    }
    
    [DataHander showDlg];
    [MHAsiNetworkAPI changeOrderLawyerInfoWithuid:uid timestamp:timeStamp sign:sign lawyer_id:uid product_id:_productID category:jsonFiledsString city:cityId region:townId photo:self.imageKey price:@"200" title:self.sloganTF.rightField.text intr:self.suggestionTextView.text SuccessBlock:^(id returnData) {
        NSString *ret = returnData[@"ret"];
        NSString *msg = returnData[@"msg"];
        if ([ret isEqualToString:@"0"])
        {
            [DataHander showSuccessWithTitle:@"提交审核成功" completionBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        else
        {
            [DataHander hideDlg];
            SHOW_ALERT(msg);
        }

    } failureBlock:^(NSError *error) {
        [DataHander hideDlg];

    } showHUD:NO];
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
