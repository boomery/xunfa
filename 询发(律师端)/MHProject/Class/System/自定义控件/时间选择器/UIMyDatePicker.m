//
//  UIMyDatePicker.m
//
//  Created by Andy on 14-10-30.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import "UIMyDatePicker.h"
//#import "UIView+Genie.h"

@implementation UIMyDatePicker

- (instancetype)initWithDelegate:(id<UIMyDatePickerDelegate>)delegate
{
    if (self = [super init])
    {
        self.delegate = delegate;
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        self.datePicker.locale = locale;
        self.datePicker.maximumDate = [NSDate date];
//        NSTimeInterval dateSec = -2208960000;
//        self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:dateSec];
//        self.datePicker.maximumDate = [NSDate date];
        self.datePicker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        self.datePicker.backgroundColor = [UIColor whiteColor];
        self.datePicker.frame = CGRectMake(0, 44, DEF_SCREEN_WIDTH, 216);
        [self addSubview:self.datePicker];
        
        UIToolbar *tool = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 44)];
        tool.userInteractionEnabled = YES;
        tool.translucent = NO;
        tool.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Left_ditu"]];
//        tool.backgroundColor = [UIColor whiteColor];
        [self addSubview:tool];
        
        UIButton *certain = [UIButton buttonWithType:UIButtonTypeCustom];
        [certain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        certain.titleLabel.font = [UIFont systemFontOfSize:17.0];
        //        certain.backgroundColor = UIColorFromRGB(0xFD7953);
        [certain setTitle:@"完成" forState:UIControlStateNormal];
        [certain setTitleColor:DEF_RGB_COLOR(61, 189, 244) forState:UIControlStateNormal];
        certain.frame = CGRectMake(DEF_SCREEN_WIDTH - 60 , 12, 40, 17);
        certain.layer.cornerRadius = 3.f;
        [certain addTarget:self action:@selector(certain) forControlEvents:UIControlEventTouchUpInside];
        //
        [tool addSubview:certain];
        
        //
        
        UIButton *secureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [secureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        secureButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [secureButton setTitleColor:[UIColor colorWithRed:0.37 green:0.73 blue:0.47 alpha:1] forState:UIControlStateNormal];
        //        certain.backgroundColor = UIColorFromRGB(0xFD7953);
        [secureButton setTitle:@"保密" forState:UIControlStateNormal];
        [secureButton setTitleColor:DEF_RGB_COLOR(61, 189, 244) forState:UIControlStateNormal];
        secureButton.frame = CGRectMake(DEF_SCREEN_WIDTH - 120 , 12, 40, 17);
        secureButton.layer.cornerRadius = 3.f;
        [secureButton addTarget:self action:@selector(secureButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [tool addSubview:secureButton];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancel.titleLabel.font = [UIFont systemFontOfSize:17.0];
        //        cancel.backgroundColor = UIColorFromRGB(0xFD7953);
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:DEF_RGB_COLOR(61, 189, 244) forState:UIControlStateNormal];
        cancel.layer.cornerRadius = 3.f;
        [cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        cancel.frame = CGRectMake(10, 12, 40, 17);
        [tool addSubview:cancel];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:CGRectMake(frame.origin.x, frame.origin.y, DEF_SCREEN_WIDTH,260)];
}

- (void)certain
{
    [self cancelDatePickerView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(myDatePicker:tapedCancel:)])
    {
        [self.delegate myDatePicker:self tapedCancel:NO];
    }
}


- (void)cancel
{
    [self cancelDatePickerView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(myDatePicker:tapedCancel:)])
    {
        [self.delegate myDatePicker:self tapedCancel:YES];
    }
}

- (void)secureButtonClick
{
    [self cancelDatePickerView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(secureButtonClick)])
    {
        [self.delegate secureButtonClick];
    }
}
#pragma mark - animate
- (void)showDatePickerView
{
//   [UIView animateWithDuration:0.3 animations:^{
//       self.frame = CGRectMake(self.frame.origin.x, DEF_SCREEN_HEIGHT - 64 - 260, DEF_SCREEN_WIDTH, 260);
//   } completion:^(BOOL finished) {
//       self.hidden = NO;
//   }];
//    [self genieInTransitionWithDuration:0.3 destinationRect:CGRectInset(self.frame, 0.5, 0.5) destinationEdge:BCRectEdgeBottom completion:^{
//        self.hidden = NO;
//    }];
}

- (void)showDatePickerAboveTabBar
{
//    [UIView animateWithDuration:0.3 animations:^{
//        self.frame = CGRectMake(self.frame.origin.x, DEF_SCREEN_HEIGHT - 64 - 260 - 48, DEF_SCREEN_WIDTH, 260);
//    } completion:^(BOOL finished) {
//        self.hidden = NO;
//    }];
    //    [self genieInTransitionWithDuration:0.3 destinationRect:CGRectInset(self.frame, 0.5, 0.5) destinationEdge:BCRectEdgeBottom completion:^{
    //        self.hidden = NO;
    //    }];
}

- (void)cancelDatePickerView
{
//    [UIView animateWithDuration:0.3 animations:^{
//        self.frame = CGRectMake(self.frame.origin.x, DEF_SCREEN_HEIGHT+self.height, DEF_SCREEN_WIDTH, 260);
//    } completion:^(BOOL finished) {
//        self.hidden = NO;
//    }];
}


@end
