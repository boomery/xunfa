//
//  EditeInfoViewController.m
//  MHProject
//
//  Created by 张好志 on 15/6/25.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#define FieldHeight 43
#define SpaceHeight TRANSFORM_HEIGHT(10.0)
#define DEF_BirthTFTag 308

#import "EditeInfoViewController.h"
#import "UIPlaceHolderTextView.h"
#import "MHKeyboard.h"
#import "CityModel.h"
#import "TownShipModel.h"
@interface EditeInfoViewController ()<UIActionSheetDelegate, UIMyDatePickerDelegate,UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate, CustomPickerViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSMutableArray *cityArr;
@property (nonatomic, assign) NSInteger selectedCityIndex;

@end

@implementation EditeInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSMutableArray *cityArray = [[NSMutableArray alloc] init];
    self.cityArr = cityArray;
    
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
            
            [_cityArr addObject:model];
        }
    }
    
    [self creatContScrollView];
    [self initNav];
    [self initUI];
    //添加个人信息
    [self addUIDataByHttpRequestDict:self.userInfoDict];
}
#pragma mark - 请求相关
//修改个人信息
-(void)changeUserInfoByHttpRequest
{
    //
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = [NSString stringWithFormat:@"%@%@",DEF_API_Lawyer,uid];
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    NSString *birthStr = nil;
    if ([NSString isBlankString:self.birthTF.rightField.text]) {
        self.birthTF.rightField.text = @"保密";//规定1是保密
    }
    else if (![NSString isBlankString:self.emailTF.rightField.text] && ![TSRegularExpressionUtil validateEmail:self.emailTF.rightField.text])
    {
        SHOW_ALERT(@"亲，请输入您正确的邮箱");
    }
    else
    {
        if ([self.birthTF.rightField.text isEqualToString:@"保密"])
        {
            birthStr = @"1";
        }
        else
        {
            birthStr = self.birthTF.rightField.text;
        }
        
        //将保存的城市信息转化为id，方便后台检索
        NSString *addressString = self.addressTF.rightField.text;
        NSArray *addressArray = [addressString componentsSeparatedByString:@" "];
        NSString *cityId = nil;
        NSString *townId = nil;
        if (addressArray.count > 1)
        {
            NSString *city = addressArray[0];
            NSString *town = addressArray[1];
            for (CityModel *model in self.cityArr)
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

        [MHAsiNetworkAPI changeLawerInfoByuid:uid
                                    timestamp:timeStamp
                                         sign:sign
                                    lawyer_id:uid
                                       avatar:nil
                                        birth:birthStr
                                          sex:self.sexTF.rightField.text
                               lawyer_company:self.companyTF.rightField.text
                                   work_title:self.situationTF.rightField.text
                                        email:self.emailTF.rightField.text
                                         city:cityId
                                       region:townId
                                    introduce:self.suggestionTextView.text
                                 SuccessBlock:^(id returnData)
        {
            DEF_DEBUG(@"修改个人信息接口返回数据%@",returnData);
            
            NSString *ret = returnData[@"ret"];
            NSString *msg = returnData[@"msg"];
            //         NSDictionary *data = returnData[@"data"];
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
}

-(void)initNav
{
    [self showNavBarWithTwoBtnHUDByNavTitle:@"编辑资料" leftImage:@"menu-left-back" leftTitle:@"" rightImage:@"" rightTitle:@"保存" inView:self.view isBack:YES];
}
#pragma mark - 点击事件
- (void)leftNavItemClick
{
    [MobClick event:@"LawMyInfoEdit1_Back"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initUI
{
    self.contentScrollView.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTap:)];
    tap.numberOfTapsRequired = 1;
    [self.contentScrollView addGestureRecognizer:tap];
    [MHKeyboard addRegisterTheViewNeedMHKeyboard:self.contentScrollView];

    float x = 10;
    float y = 10;
    //
    self.nameTF = [[QLeftLabelTextField alloc] initWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-20 , FieldHeight)];
    self.nameTF.leftLbl.text = @"姓       名";
    self.nameTF.rightField.placeholder = @"询法用户";
    self.nameTF.rightField.delegate= self;
    self.nameTF.rightImageBtn.hidden = YES;
    self.nameTF.canEdit = NO;
    self.nameTF.leftLbl.textColor = DEF_RGB_COLOR(159, 159, 159);
    self.nameTF.leftLbl.font = DEF_Font(16.0);
    self.nameTF.rightField.textColor =  DEF_RGB_COLOR(159, 159, 159);
    self.nameTF.rightField.font = DEF_Font(16.0);
    [self.contentScrollView addSubview:self.nameTF];
    
    //
    y+= FieldHeight+SpaceHeight;
    self.zhiyeLicenseTF = [[QLeftLabelTextField alloc] initWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-20 , FieldHeight)];
    self.zhiyeLicenseTF.leftLbl.text = @"执业证号";
    self.zhiyeLicenseTF.rightField.text = @"000000";
    self.zhiyeLicenseTF.canEdit = NO;
    self.zhiyeLicenseTF.rightImageBtn.hidden = YES;
    self.zhiyeLicenseTF.leftLbl.textColor = DEF_RGB_COLOR(159, 159, 159);
    self.zhiyeLicenseTF.leftLbl.font = DEF_Font(16.0);
    self.zhiyeLicenseTF.rightField.textColor =  DEF_RGB_COLOR(159, 159, 159);
    self.zhiyeLicenseTF.rightField.font = DEF_Font(16.0);

    [self.contentScrollView addSubview:self.zhiyeLicenseTF];
   
    //
    y+= FieldHeight+SpaceHeight;
    self.identityCardTF = [[QLeftLabelTextField alloc] initWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-20 , FieldHeight)];
    self.identityCardTF.leftLbl.text = @"身份证号";
    self.identityCardTF.rightField.text = @"310000000000000";
    self.identityCardTF.canEdit = NO;
    self.identityCardTF.rightImageBtn.hidden = YES;
    self.identityCardTF.leftLbl.textColor = DEF_RGB_COLOR(159, 159, 159);
    self.identityCardTF.leftLbl.font = DEF_Font(16.0);
    self.identityCardTF.rightField.textColor =  DEF_RGB_COLOR(159, 159, 159);
    self.identityCardTF.rightField.font = DEF_Font(16.0);   [self.contentScrollView addSubview:self.identityCardTF];

    self.picker = [[UIMyDatePicker alloc] initWithDelegate:self];
    self.picker.frame = CGRectMake(0, DEF_SCREEN_HEIGHT-64, DEF_SCREEN_WIDTH, 260);
    //
    y+= FieldHeight+SpaceHeight;
    self.birthTF = [[QLeftLabelTextField alloc] initWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-20 , FieldHeight)];
    self.birthTF.leftLbl.text = @"出生年月";
    self.birthTF.rightField.placeholder = @"保密";
    self.birthTF.rightField.inputView = self.picker;
    self.birthTF.rightImageBtn.hidden = YES;
    self.birthTF.rightField.tag = DEF_BirthTFTag;
    self.birthTF.rightField.delegate = self;
    self.birthTF.leftLbl.textColor = DEF_RGB_COLOR(51, 51, 51);
    self.birthTF.leftLbl.font = DEF_Font(16.0);
    self.birthTF.rightField.textColor =  DEF_RGB_COLOR(159, 159, 159);
    self.birthTF.rightField.font = DEF_Font(16.0);
    self.picker = [[UIMyDatePicker alloc] initWithDelegate:self];
    self.picker.frame = CGRectMake(0, DEF_SCREEN_HEIGHT-64, DEF_SCREEN_WIDTH, 260);
    self.birthTF.rightField .inputView = self.picker;
    [self.contentScrollView addSubview:self.birthTF];

    //
    y+= FieldHeight+SpaceHeight;
    self.sexTF = [[QLeftLabelTextField alloc] initWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-20 , FieldHeight)];
    self.sexTF.leftLbl.text = @"性       别";
    self.sexTF.rightField.placeholder = @"请选择您的性别";
    self.sexTF.rightField.delegate= self;
    self.sexTF.rightImageBtn.hidden = YES;
    self.sexTF.leftLbl.textColor = DEF_RGB_COLOR(51, 51, 51);
    self.sexTF.leftLbl.font = DEF_Font(16.0);
    self.sexTF.rightField.textColor =  DEF_RGB_COLOR(159, 159, 159);
    self.sexTF.rightField.font = DEF_Font(16.0);
    [self.contentScrollView addSubview:self.sexTF];
    
    UIButton *selectCWBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectCWBtn.frame = self.sexTF.frame;
    selectCWBtn.backgroundColor = [UIColor clearColor];
    [selectCWBtn addTarget:self action:@selector(chengWeiTFBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentScrollView addSubview:selectCWBtn];
    
    //所在律师所
    y+= FieldHeight+SpaceHeight;
    self.companyTF = [[QLeftLabelTextField alloc] initWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-20 , FieldHeight)];
    self.companyTF.leftLbl.text = @"所在律所";
    self.companyTF.rightField.placeholder = @"请输入律所";
    self.companyTF.rightField.delegate= self;
    self.companyTF.rightImageBtn.hidden = YES;
    self.companyTF.leftLbl.textColor = DEF_RGB_COLOR(51, 51, 51);
    self.companyTF.leftLbl.font = DEF_Font(16.0);
    self.companyTF.rightField.textColor =  DEF_RGB_COLOR(159, 159, 159);
    self.companyTF.rightField.font = DEF_Font(16.0);

    [self.contentScrollView addSubview:self.companyTF];
    
    //职务
    y+= FieldHeight+SpaceHeight;
    self.situationTF = [[QLeftLabelTextField alloc] initWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-20 , FieldHeight)];
    self.situationTF.leftLbl.text = @"职       务";
    self.situationTF.rightField.placeholder = @"请输入您的职务";
    self.situationTF.rightField.delegate= self;
    self.situationTF.rightImageBtn.hidden = YES;
    self.situationTF.leftLbl.textColor = DEF_RGB_COLOR(51, 51, 51);
    self.situationTF.leftLbl.font = DEF_Font(16.0);
    self.situationTF.rightField.textColor =  DEF_RGB_COLOR(159, 159, 159);
    self.situationTF.rightField.font = DEF_Font(16.0);
    [self.contentScrollView addSubview:self.situationTF];
    //
    y+= FieldHeight+SpaceHeight;
    self.emailTF = [[QLeftLabelTextField alloc] initWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-20 , FieldHeight)];
    self.emailTF.leftLbl.text = @"邮       箱";
    self.emailTF.rightField.placeholder = @"请输入邮箱";
    self.emailTF.rightField.delegate= self;
    self.emailTF.rightImageBtn.hidden = YES;
    self.emailTF.leftLbl.textColor = DEF_RGB_COLOR(51, 51, 51);
    self.emailTF.leftLbl.font = DEF_Font(16.0);
    self.emailTF.rightField.textColor =  DEF_RGB_COLOR(159, 159, 159);
    self.emailTF.rightField.font = DEF_Font(16.0);

    [self.contentScrollView addSubview:self.emailTF];
    
    //
    y+= FieldHeight+SpaceHeight;
    self.addressTF = [[QLeftLabelTextField alloc] initWithFrame:CGRectMake(x, y, DEF_SCREEN_WIDTH-20 , FieldHeight)];
    self.addressTF.leftLbl.text = @"所  在  地";
    self.addressTF.rightField.delegate= self;
    self.addressTF.rightField.placeholder = @"请选择您的地址";
    self.addressTF.rightImageBtn.hidden = YES;
    self.addressTF.leftLbl.textColor = DEF_RGB_COLOR(51, 51, 51);
    self.addressTF.leftLbl.font = DEF_Font(16.0);
    self.addressTF.rightField.textColor =  DEF_RGB_COLOR(159, 159, 159);
    self.addressTF.rightField.font = DEF_Font(16.0);

    [self.contentScrollView addSubview:self.addressTF];
    
    CityCustomPickerView *picker = [[CityCustomPickerView alloc] init];
    picker.frame = CGRectMake(0, DEF_SCREEN_HEIGHT-64, DEF_SCREEN_WIDTH, 260);
    picker.delegate = self;
    self.addressTF.rightField .inputView = picker;
    picker.pickerView.dataSource = self;
    picker.pickerView.delegate = self;
    self.cityPicker = picker;
    //
    y+= FieldHeight;
    UILabel *userLB = [[UILabel alloc]initWithFrame:CGRectMake(x, y+5, DEF_SCREEN_WIDTH-20, 30)];
    userLB.text = @"个人简介";
    [self.contentScrollView addSubview:userLB];

    y+= FieldHeight;
    self.suggestionTextView = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(x, DEF_BOTTOM(userLB)+5, DEF_SCREEN_WIDTH-20,130/568.0 *DEF_SCREEN_HEIGHT)];
    self.suggestionTextView.scrollEnabled = YES;
    self.suggestionTextView.font        = [UIFont systemFontOfSize:16];
    self.suggestionTextView.textColor   = DEF_RGB_COLOR(51, 51, 51);
    self.suggestionTextView.placeholder =@"还没有内容，快来完善你的个人简介";
    self.suggestionTextView.placeholderColor = DEF_RGB_COLOR(159, 159, 159);
    self.suggestionTextView.delegate    = self;
    self.suggestionTextView.layer.cornerRadius = 5;
    self.suggestionTextView.returnKeyType = UIReturnKeyDone;
    self.suggestionTextView.clipsToBounds = YES;
    self.suggestionTextView.layer.borderWidth = LINE_HEIGHT;
    self.suggestionTextView.layer.borderColor = DEF_RGB_COLOR(202, 202, 202).CGColor;
    [self.contentScrollView addSubview:self.suggestionTextView];

    self.contentScrollView.contentSize = CGSizeMake(DEF_SCREEN_WIDTH, y+DEF_HEIGHT(self.suggestionTextView)+10);
//    bgView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH,  y+DEF_HEIGHT(self.suggestionTextView)+10);
//    _bottomView = bgView;
}

//给界面添加数据
-(void)addUIDataByHttpRequestDict:(NSDictionary *)dict
{
    NSString *name = dict[@"name"];
    NSString *lawyer_license = dict[@"lawyer_license"];
    NSString *id_number = dict[@"id_number"];
    NSString *birth = dict[@"birth"];
    NSString *sex = dict[@"sex"];
    NSString *email = dict[@"email"];
    NSString *city = dict[@"city"];
    NSString *region = dict[@"region"];
    NSString *introduce = dict[@"introduce"];
    NSString *lawyer_company = dict[@"lawyer_company"];
    NSString *work_title = dict[@"work_title"];
    if ([work_title isKindOfClass:[NSNull class]])
    {
        work_title = nil;
    }
    if ([birth isEqualToString:@"1"])
    {
        birth = @"保密";
    }
    //姓名
    self.nameTF.rightField.text = name;
    //执业证号
    self.zhiyeLicenseTF.rightField.text = lawyer_license;
    //身份证号
    self.identityCardTF.rightField.text = id_number;
    //出生年月
    self.birthTF.rightField.text = birth;
    //性别
    self.sexTF.rightField.text = sex;
    //所在律所
    self.companyTF.rightField.text = lawyer_company;
    //职务
    self.situationTF.rightField.text = work_title;
    //邮箱
    self.emailTF.rightField.text = email;
    //所在地
    if (region)
    {
        self.addressTF.rightField.text = [city stringByAppendingString:[NSString stringWithFormat:@" %@",region]];
    }
    else
    {
        self.addressTF.rightField.text = city;
    }
    //个人介绍
    self.suggestionTextView.text = introduce;
}

#pragma mark - 点击取消编辑状态
- (void)bgTap:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}
#pragma mark - 选择性别
-(void)chengWeiTFBtnClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    [self.picker cancelDatePickerView];
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",@"保密", nil];
    [sheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        self.sexTF.rightField.text = @"男";
    }
    else if (buttonIndex==1)
    {
        self.sexTF.rightField.text = @"女";
    }
    else if (buttonIndex==2)
    {
        self.sexTF.rightField.text = @"保密";
    }
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
                
                [_cityArr addObject:model];
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

#pragma mark - 保存个人资料
-(void)rightNavItemClick
{
    [MobClick event:@"LawMyInfoEdit1_Save"];
    [self.view endEditing:YES];
    [self changeUserInfoByHttpRequest];
}
#pragma mark - CustomPickerViewDelegate
- (void)customPickerView:(CityCustomPickerView *)pickerView didClickCancelButton:(UIButton *)cancelButton
{
    [self.view endEditing:YES];
}
- (void)customPickerView:(CityCustomPickerView *)pickerView didClickConfirmButton:(UIButton *)confirmButton
{
    CityModel *city = self.cityArr[[pickerView.pickerView selectedRowInComponent:0]];
    NSInteger selecedIndex = [pickerView.pickerView selectedRowInComponent:1];
    if (city.townMutableArray.count > selecedIndex)
    {
        TownShipModel *town = city.townMutableArray[selecedIndex];
        self.addressTF.rightField.text = [[NSString stringWithFormat:@"%@ ",city.district_name] stringByAppendingString:town.townshipName];
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
        return self.cityArr.count;
    }
    else
    {
        if (self.cityArr.count > 0)
        {
            CityModel *model = self.cityArr[self.selectedCityIndex];
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
        CityModel * model=self.cityArr[row];
        return model.district_name;
    }
    else
    {
        CityModel * model=self.cityArr[self.selectedCityIndex];
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

#pragma mark - UIMyDatePickerDelegate
-(void)myDatePicker:(UIMyDatePicker *)picker tapedCancel:(BOOL)cancel
{
    [picker cancelDatePickerView];
    [self.view endEditing:YES];
    
    if (!cancel) {
        NSString *str = [NSDate stringFromDate:picker.datePicker.date withFormat:@"yyyy-MM-dd"];

        self.birthTF.rightField.text = str;
    }
}

- (void)secureButtonClick
{
    [self.view endEditing:YES];
    self.birthTF.rightField.text = @"保密";
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

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.addressTF.rightField])
    {
        NSString *address = self.addressTF.rightField.text;
        NSRange range = [address rangeOfString:@" "];
        if (range.location != NSNotFound)
        {
            NSString *city = [address substringToIndex:range.location];
            NSString *district = [address substringFromIndex:range.location+1];
            NSInteger componentIndex = 0;
            NSInteger rowIndex = 0;
            for (CityModel *cityModel in self.cityArr)
            {
                if ([cityModel.district_name isEqualToString:city])
                {
                    componentIndex = [self.cityArr indexOfObject:cityModel];
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
    else if ([textField isEqual:self.birthTF.rightField])
    {
        NSString *birth = self.birthTF.rightField.text;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSDate *date = [formatter dateFromString:birth];
        if (date)
        {
            self.picker.datePicker.date = date;
        }
    }
}
// 结束编辑的时候下键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
