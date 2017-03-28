//
//  CustomDatePickerView.m
//  MHProject
//
//  Created by 杜宾 on 15/8/28.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "CustomDatePickerView.h"

@implementation CustomDatePickerView
-(id)initWithDelegate:(id<MyCustomDatePickerViewDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.delegate = delegate;
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 44)];
        [self addSubview:titleView];
        titleView.backgroundColor = [UIColor colorWithRed:0.87 green:0.88 blue:0.88 alpha:1];
        
        
        UIButton *certain = [UIButton buttonWithType:UIButtonTypeCustom];
        [certain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        certain.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [certain setTitleColor:[UIColor colorWithRed:0.37 green:0.73 blue:0.47 alpha:1] forState:UIControlStateNormal];
        [certain setTitle:@"完成" forState:UIControlStateNormal];
        certain.frame = CGRectMake(DEF_SCREEN_WIDTH - 60 , 0, 60, 44);
        certain.layer.cornerRadius = 3.f;
        [certain addTarget:self action:@selector(certain) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:certain];
        
        
        UIButton *lawyerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH - 60, 44)];
        [lawyerBtn setTitle:@"  与律师沟通后确认时间" forState:UIControlStateNormal];
        [lawyerBtn setTitleColor:[UIColor colorWithRed:0.37 green:0.73 blue:0.47 alpha:1] forState:UIControlStateNormal];
        lawyerBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [lawyerBtn addTarget:self action:@selector(lawyerBtn:) forControlEvents:UIControlEventTouchUpInside];
        lawyerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [titleView addSubview:lawyerBtn];
        

        
        // 建立 UIDatePicker
        self.datePicker = [[UIDatePicker alloc]init];
        // 時區的問題請再找其他協助 不是本篇重點
        self.datePicker.frame = CGRectMake(0, 44, DEF_SCREEN_WIDTH, 200 - 44);
        NSLocale *datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        self.datePicker.locale = datelocale;
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        self.datePicker.minimumDate = [NSDate date];
        self.datePicker.backgroundColor = [UIColor whiteColor];
        [self addSubview: self.datePicker];
        
        if (DEF_SCREEN_WIDTH == 320.0)
        {
            self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - 152, 44, 152, 200 - 44)];
        }
        else if (DEF_SCREEN_IS_6)
        {
            self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - 182, 44, 182, 200 - 44)];
        }
        else
        {
            self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - 200, 44, 200, 200 - 44)];
        }
        self.pickerView.backgroundColor = [UIColor whiteColor];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self addSubview:self.pickerView];


    }
    return self;
}
#pragma MyCustomDatePickerDelegate
//点击完成的时候
- (void)certain
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectDatepicke:)])
    {
        [self.delegate selectDatepicke:self];
    }
}
//点击字体的时候
-(void)lawyerBtn:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectLawyerCorfirm:)])
    {
        [self.delegate selectLawyerCorfirm:self];
    }
 
}


#pragma UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    UILabel *myView = nil;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
    myView.textAlignment = 1;
    myView.text = [self.timeArr objectAtIndex:row];
    myView.font = [UIFont systemFontOfSize:25];         //用label来设置字体大小
    myView.backgroundColor = [UIColor clearColor];
    return myView;
    
}
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
//
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 32;
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 50;
}
// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.timeArr count];;
}
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.timeArr objectAtIndex:row];
    
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    self.hourStr = [self.timeArr objectAtIndex:row];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
