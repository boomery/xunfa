//
//  AnimateLabel.m
//  Delegate
//
//  Created by ZhangChaoxin on 15/7/22.
//  Copyright (c) 2015年 ZhangChaoxin. All rights reserved.
//

#import "AnimateLabel.h"
#define FREQUECY 0.01
@interface AnimateLabel ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGRect tempRect;
@property (nonatomic, assign) CGRect comingRect;

@property (nonatomic, assign) Direction direction;
@property (nonatomic, copy) NSString *comingText;

@property (nonatomic, assign) BOOL isAnimating;

@property (nonatomic, copy) NSAttributedString *originalAttributeText;
@property (nonatomic, copy) NSAttributedString *comingAttributeText;
@end

@implementation AnimateLabel


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
    }
    return self;
}

- (void)setAttributeText:(NSAttributedString *)attributeText withDirection:(Direction)direction
{
    self.attributedText = attributeText;
    _originalAttributeText = self.attributedText;
    _comingAttributeText = attributeText;
    [self startAnimationWithDirection:direction];
}
- (void)startAnimationWithDirection:(Direction)direction
{
    if (self.isAnimating)
    {
        return;
    }
    _direction = direction;
    self.isAnimating = YES;
    _timer = [NSTimer scheduledTimerWithTimeInterval:FREQUECY target:self selector:@selector(timerAction:) userInfo:[NSNumber numberWithInteger:direction] repeats:YES];
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:_timer forMode:NSRunLoopCommonModes];
    _tempRect = self.bounds;
    if (direction == DirectionLeft)
    {
        _comingRect = CGRectMake(CGRectGetWidth(self.frame), 0, self.bounds.size.width, self.bounds.size.height);
    }
    else if (direction == DirectionRight)
    {
        _comingRect = CGRectMake(-CGRectGetWidth(self.frame), 0, self.bounds.size.width, self.bounds.size.height);
    }
}

- (void)timerAction:(id)userInfo
{
    if (_direction == DirectionLeft)
    {
        _tempRect.origin.x -= 1;
        _comingRect.origin.x -= 1;
    }
    else
    {
        _tempRect.origin.x += 1;
        _comingRect.origin.x += 1;
    }
    [self setNeedsDisplay];
    if (_comingRect.origin.x == 2)
    {
        [self stopAnimation];
    }
}

- (void)drawTextInRect:(CGRect)rect
{
    if (!_comingAttributeText)
    {
        [super drawTextInRect:rect];
        return;
    }
    [super drawTextInRect:_comingRect];
}

- (void)stopAnimation
{
    self.isAnimating = NO;
    [_timer invalidate];
    _timer = nil;
}
@end
