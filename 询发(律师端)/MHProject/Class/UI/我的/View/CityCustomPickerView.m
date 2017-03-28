//
//  CityCustomPickerView.m
//  MHProject
//
//  Created by 杜宾 on 15/7/2.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "CityCustomPickerView.h"

@implementation CityCustomPickerView
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        // 取消的 按钮
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitleColor:DEF_RGB_COLOR(61, 189, 244) forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setFrame:CGRectMake(20, 20, 40, 30)];
        [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
        // 确定的按钮
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmButton setTitleColor:DEF_RGB_COLOR(61, 189, 244) forState:UIControlStateNormal];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setFrame:CGRectMake(DEF_SCREEN_WIDTH-60, 20, 40, 30)];
        [confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirmButton];
        
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, DEF_SCREEN_WIDTH, 200)];
        [self addSubview:pickerView];
        _pickerView = pickerView;
    }
    
    return self;
}

#pragma mark- 点击按钮的事件
-(void)cancelButtonClick:(UIButton*)cancelButton
{
    if ([self.delegate respondsToSelector:@selector(customPickerView:didClickCancelButton:)])
    {
        [self.delegate customPickerView:self didClickCancelButton:cancelButton];
    }
}
         
- (void)confirmButtonClick:(UIButton *)confirmButton
{
    if ([self.delegate respondsToSelector:@selector(customPickerView:didClickConfirmButton:)])
    {
        [self.delegate customPickerView:self didClickConfirmButton:confirmButton];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
