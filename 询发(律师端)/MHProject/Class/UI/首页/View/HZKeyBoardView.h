//
//  HZKeyBoardView.h
//  TestKey
//
//  Created by 张好志 on 15/6/21.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
@interface HZKeyBoardView : UIView

@property (strong,nonatomic) UIButton    *changeVoiceBtn;
@property (strong,nonatomic) HPGrowingTextView *inputTF;
@property (strong,nonatomic) UIButton    *sendBtn;
@property (strong,nonatomic) UIButton    *pressSpeakBtn;

@end
