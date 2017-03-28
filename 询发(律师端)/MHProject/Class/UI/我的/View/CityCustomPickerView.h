//
//  CityCustomPickerView.h
//  MHProject
//
//  Created by 杜宾 on 15/7/2.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CityCustomPickerView;
@protocol CustomPickerViewDelegate <NSObject>

@optional

-(void)customPickerView:(CityCustomPickerView*)pickerView didClickCancelButton:(UIButton *)cancelButton;
-(void)customPickerView:(CityCustomPickerView*)pickerView didClickConfirmButton:(UIButton *)confirmButton;

@end


@interface CityCustomPickerView : UIView
/**
 *  取消的按钮
 */
@property(nonatomic,strong)UIButton *cancelButton;

/**
 *  确定的按钮
 */
@property(nonatomic,strong)UIButton *confirmButton;

/// pickerView
@property(nonatomic,strong)UIPickerView *pickerView;


/// 代理
@property(nonatomic,assign)id  <CustomPickerViewDelegate> delegate;


@end
