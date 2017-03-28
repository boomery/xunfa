//
//  HZVoiceAskKeyBoardView.m
//  MHProject
//
//  Created by 张好志 on 15/6/26.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "HZVoiceAskKeyBoardView.h"

@implementation HZVoiceAskKeyBoardView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //
        self.backgroundColor = DEF_RGB_COLOR(246, 246, 246);
        
        //
        self.leftCheckBox = [[MyCheckBox alloc] initWithFrame:CGRectMake(10, 15, 50, 20)];
        self.leftCheckBox.selected = YES;
        self.leftCheckBox.rightLbl.text = @"公开";
        [self addSubview:self.leftCheckBox];
        
        UIView *myBtnView = [[UIView alloc]initWithFrame:CGRectMake(DEF_RIGHT(self.leftCheckBox)+10, 10, DEF_SCREEN_WIDTH-80, 30)];
        myBtnView.backgroundColor = DEF_RGB_COLOR(61, 189, 244);
        myBtnView.layer.masksToBounds = YES;
        myBtnView.layer.cornerRadius = 3;
        [self addSubview:myBtnView];
        
        UIImageView *shareImage = [[UIImageView alloc]initWithFrame:CGRectMake(myBtnView.width/2-30,10 , 7, 13)];
        shareImage.image = [UIImage imageNamed:@"microphone"];
        [myBtnView addSubview:shareImage];
        
        //
        UIButton *voiceAskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        voiceAskBtn.frame = CGRectMake(DEF_RIGHT(shareImage), 0, 70, 30);
        [voiceAskBtn setTitle:@"语音提问" forState:UIControlStateNormal];
        voiceAskBtn.titleLabel.textAlignment = 0;
        [voiceAskBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        voiceAskBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [myBtnView addSubview:voiceAskBtn];
        
        self.voiceAskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.voiceAskBtn.frame = myBtnView.bounds;
        self.voiceAskBtn.backgroundColor = [UIColor clearColor];
        [myBtnView addSubview:self.voiceAskBtn];
        
        
    }
    return self;
}

#pragma mark -- 按钮点击事件
- (void)btnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
