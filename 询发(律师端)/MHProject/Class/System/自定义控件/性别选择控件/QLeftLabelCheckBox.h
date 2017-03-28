//
//  QLeftLabelCheckBox.h
//
//  Created by Andy on 15-1-22.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLeftLabelCheckBox : UIView

@property (nonatomic,strong) UILabel *leftLbl;

@property (nonatomic,strong) UIButton *openBt;

@property (nonatomic,assign) long selectedIndex;

@property (nonatomic,strong) NSArray *titleArray;

@property (nonatomic,assign) BOOL canEdit;

-(instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)arr;

@end
