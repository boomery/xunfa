//
//  TextFieldPickerView.h
//  MHProject
//
//  Created by 杜宾 on 15/6/30.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldPickerView : UITextField<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong)UIPickerView *pickView;
@property (nonatomic, strong) NSArray *dataArray;// pickerView的数据源, 比如 yes, no
@property (nonatomic, strong) UIToolbar *inputAccessoryView;// 键盘上方的toolbal, 用于加入done按钮完成输入
- (void)setSelectRow:(NSInteger)index;// 选中列  
@end
