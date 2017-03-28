//
//  CustomDatePickerView.h
//  MHProject
//
//  Created by 杜宾 on 15/8/28.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomDatePickerView;
@protocol MyCustomDatePickerViewDelegate <NSObject>

-(void)selectDatepicke:(CustomDatePickerView *)picker;

-(void)selectLawyerCorfirm:(CustomDatePickerView *)datePick;
@end


@interface CustomDatePickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong)UIDatePicker *datePicker;
@property (nonatomic, strong)UIPickerView *pickerView;
@property (nonatomic, strong)NSArray *timeArr;
@property (nonatomic, strong)NSString *hourStr;
@property (nonatomic,weak)id<MyCustomDatePickerViewDelegate>delegate;
-(id)initWithDelegate:(id<MyCustomDatePickerViewDelegate>)delegate;



@end
