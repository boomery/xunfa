//
//  UIMyDatePicker.h
//
//  Created by Andy on 14-10-30.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIMyDatePicker;

@protocol  UIMyDatePickerDelegate <NSObject>

- (void)myDatePicker:(UIMyDatePicker *)picker tapedCancel:(BOOL)cancel;
- (void)secureButtonClick;

@end

@interface UIMyDatePicker : UIView

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, weak) id <UIMyDatePickerDelegate>delegate;

- (instancetype) initWithDelegate:(id <UIMyDatePickerDelegate>)delegate;

- (void)showDatePickerView;
- (void)showDatePickerAboveTabBar;
- (void)cancelDatePickerView;

@end
