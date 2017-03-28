//
//  EditeInfoViewController.h
//  MHProject
//
//  Created by 张好志 on 15/6/25.
//  Copyright (c) 2015年 Andy. All rights reserved.
//编辑资料

#import "BaseViewController.h"
#import "QLeftLabelTextField.h"
#import "UIMyDatePicker.h"
#import "CityCustomPickerView.h"
@class UIPlaceHolderTextView;
@interface EditeInfoViewController : BaseViewController

@property (nonatomic, strong) QLeftLabelTextField *nameTF;
@property (nonatomic, strong) QLeftLabelTextField *zhiyeLicenseTF;
@property (nonatomic, strong) QLeftLabelTextField *identityCardTF;
@property (nonatomic, strong) QLeftLabelTextField *birthTF;
@property (nonatomic, strong) QLeftLabelTextField *sexTF;

@property (nonatomic, strong) QLeftLabelTextField *companyTF;
@property (nonatomic, strong) QLeftLabelTextField *situationTF;
@property (nonatomic, strong) QLeftLabelTextField *emailTF;
@property (nonatomic, strong) QLeftLabelTextField *addressTF;
@property (nonatomic, strong) UIPlaceHolderTextView *suggestionTextView;

@property (nonatomic, strong) UIMyDatePicker *picker;
@property (nonatomic, strong) CityCustomPickerView *cityPicker;


@property (nonatomic, strong) NSDictionary *userInfoDict;

@property (nonatomic, copy) void(^saveBlock)();

@property(nonatomic,strong)UIView *bottomView;
@end
