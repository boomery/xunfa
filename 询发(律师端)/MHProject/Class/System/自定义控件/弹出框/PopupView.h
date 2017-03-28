//
//  PopupView.h
//  MSCDemo
//
//  Created by Andy on 13-6-7.
//  Copyright (c) 2013年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupView : UIView
{
    UILabel         *_textLabel;
    int             _queueCount;
}
@property (strong) UIView*  ParentView;
- (void) setText:(NSString *) text;

@end
