//
//  QLeftLabelTextField.h
//  Fuyph
//
//  Created by Andy on 15-1-22.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLeftLabelTextField : UIView

@property (nonatomic,strong) UILabel *leftLbl;

@property (nonatomic,strong) UITextField *rightField;

@property (nonatomic,strong) UILabel *rightLbl;

@property (nonatomic,strong) UIButton *rightImageBtn;


@property (nonatomic,assign) BOOL canEdit;

@end
