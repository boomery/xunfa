//
//  TextFieldPickerView.m
//  MHProject
//
//  Created by 杜宾 on 15/6/30.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "TextFieldPickerView.h"

@implementation TextFieldPickerView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (void)setSelectRow:(NSInteger)index
{
    if (index >=0 ) {
        [self.pickView selectRow:index inComponent:0 animated:YES];// 选中哪一列
    }
}
- (void)drawRect:(CGRect)rect
{
    self.pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 120)];// 新建pickerView, 我是在3.5上运行的, 6/6plus或许宽度不同.
    self.pickView.dataSource = self;
    self.pickView.delegate = self;
    self.inputView = self.pickView;// 重点！ 这样点击TextField就会弹出pickerView了.
    
//    / default selected item /
    [self setText:[self.dataArray objectAtIndex:0]];// 设置TextField默认显示pickerView第一列的内容
}
#pragma mark - UIPickerView dataSource, delegate
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_dataArray count];
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.dataArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.text = [_dataArray objectAtIndex:row];
}
#pragma mark - inputAccessoryView with toolbar
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)done:(id)sender {
    [self resignFirstResponder];
    [super resignFirstResponder];
}
/* 创建toolbar */
- (UIView *)inputAccessoryView
{
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        return nil;
//    } else {
        if (!self.inputAccessoryView)
        {
            self.inputAccessoryView = [[UIToolbar alloc] init];
            self.inputAccessoryView.barStyle = UIBarStyleBlackTranslucent;
            self.inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            [self.inputAccessoryView sizeToFit];
            CGRect frame = self.inputAccessoryView.frame;
            frame.size.height = 30.0f;
            self.inputAccessoryView.frame = frame;
            
            UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
            UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            
            NSArray *array = [NSArray arrayWithObjects:flexibleSpaceLeft, doneBtn, nil, nil];
            [self.inputAccessoryView setItems:array];
        }  
        return self.inputAccessoryView;
 
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
