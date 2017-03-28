//
//  HZKeyBoardView.m
//  TestKey
//
//  Created by 张好志 on 15/6/21.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "HZKeyBoardView.h"
#import "MHKeyboard.h"

@implementation HZKeyBoardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //
        self.backgroundColor = DEF_RGB_COLOR(250, 250, 250);
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, LINE_HEIGHT)];
        topLine.backgroundColor = DEF_RGB_COLOR(202, 202, 202);
        [self addSubview:topLine];
        //
        self.changeVoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.changeVoiceBtn.frame = CGRectMake(12, 20/3.0, 36, 36);
        [self.changeVoiceBtn setBackgroundImage:[UIImage imageNamed:@"voice"] forState:UIControlStateSelected];
        [self.changeVoiceBtn setBackgroundImage:[UIImage imageNamed:@"botm_keyset"] forState:UIControlStateNormal];
        self.changeVoiceBtn.backgroundColor = [UIColor clearColor];
        self.changeVoiceBtn.selected = YES;
        [self addSubview:self.changeVoiceBtn];
        
        //
        HPGrowingTextView *inputTF = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(200/3.0-10, 20/3.0, DEF_SCREEN_WIDTH-DEF_WIDTH(self.changeVoiceBtn)-30-80+25, 36)];
        inputTF.layer.borderWidth = LINE_HEIGHT;
        inputTF.layer.borderColor = [DEF_RGB_COLOR(202, 202, 202) CGColor];
        inputTF.contentInset = UIEdgeInsetsMake(0, 3, 0, 2);
        inputTF.internalTextView.returnKeyType = UIReturnKeySend;
        inputTF.minNumberOfLines = 1;
        inputTF.maxNumberOfLines = 4;
        //        inputTF.returnKeyType = UIReturnKeySend; //just as an example
        inputTF.font = [UIFont systemFontOfSize:15.0f];
        inputTF.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        inputTF.backgroundColor = [UIColor whiteColor];
        self.inputTF = inputTF;
        self.inputTF.layer.cornerRadius = 5;
        self.inputTF.clipsToBounds = YES;
        [self addSubview:self.inputTF];
        
        //
        self.sendBtn = [[UIButton alloc] initForAutoLayout];
        [self addSubview:self.sendBtn];
        [self.sendBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.inputTF withOffset:5];
        [self.sendBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-12];
        [self.sendBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:20/3.0];
        [self.sendBtn autoSetDimension:ALDimensionHeight toSize:36];
        self.sendBtn.backgroundColor = DEF_RGB_COLOR(60, 153, 230);
        [self.sendBtn setTitle:@"提交" forState:UIControlStateNormal];
        self.sendBtn.layer.cornerRadius = 5;
        self.sendBtn.clipsToBounds = YES;
        self.sendBtn.showsTouchWhenHighlighted = YES;
        
        //
        self.pressSpeakBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.pressSpeakBtn.frame = CGRectMake(DEF_RIGHT(self.changeVoiceBtn)+15, 7, DEF_SCREEN_WIDTH-DEF_RIGHT(self.changeVoiceBtn)-10-15, 36);
        self.pressSpeakBtn.backgroundColor = DEF_RGB_COLOR(60, 153, 230);
        [self.pressSpeakBtn setTitle:@"语音输入" forState:UIControlStateNormal];
        self.pressSpeakBtn.layer.cornerRadius = 5;
        self.pressSpeakBtn.clipsToBounds = YES;
        [self addSubview:self.pressSpeakBtn];
        self.pressSpeakBtn.userInteractionEnabled = YES;
        self.pressSpeakBtn.hidden = YES;
        self.pressSpeakBtn.showsTouchWhenHighlighted = YES;
    }
    return self;
}

#pragma mark -- 按钮点击事件
- (void)changeVoiceBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected==YES)
    {
        self.pressSpeakBtn.hidden = YES;
        self.inputTF.hidden = NO;
        self.sendBtn.hidden = NO;
    }
    else
    {
        self.pressSpeakBtn.hidden = NO;
        self.inputTF.hidden = YES;
        self.sendBtn.hidden = YES;
    }
    [self.inputTF resignFirstResponder];
    
}
- (void)sendBtnClick:(UIButton *)sender
{
    self.inputTF.text = @"";
    [self.inputTF resignFirstResponder];
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
