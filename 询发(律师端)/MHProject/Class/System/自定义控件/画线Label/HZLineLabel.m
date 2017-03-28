//
//  WMLineLabel.m
//  BestShopping
//
//  Created by Andyon 15/1/13.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "HZLineLabel.h"
#import "Tools.h"

@implementation HZLineLabel

/**
 *  处理警告
 *
 *  @param code
 *
 *  @return
 */
#define SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING(code)                        \
_Pragma("clang diagnostic push")                                        \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")     \
code;                                                                   \
_Pragma("clang diagnostic pop")                                         \


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}


-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_target respondsToSelector:_action])
    {
        SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING([_target performSelector:_action withObject:self]);
    }
}


- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if (UIControlEventTouchUpInside & controlEvents)
    {
        _target = target;
        _action = action;
    }
}



- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:rect];
    
    //    CGSize textSize = [[self text] sizeWithFont:[self font]];
    CGSize textSize = [Tools sizeOfStr:self.text andFont:self.font andMaxSize:CGSizeMake(DEF_SCREEN_WIDTH, MAXFLOAT) andLineBreakMode:0];
    
    CGFloat strikeWidth = textSize.width;
    CGRect lineRect;
    CGFloat origin_x;
    CGFloat origin_y;
    
    
    if ([self textAlignment] == NSTextAlignmentRight)
    {
        
        origin_x = rect.size.width - strikeWidth;
        
    }
    else if ([self textAlignment] == NSTextAlignmentCenter)
    {
        
        origin_x = (rect.size.width - strikeWidth)/2 ;
        
    }
    else
    {
        origin_x = 0;
    }
    
    
    if (self.lineType == LineTypeUp)
    {
        
        origin_y =  2;
    }
    
    if (self.lineType == LineTypeMiddle)
    {
        
        origin_y =  rect.size.height/2;
    }
    
    if (self.lineType == LineTypeDown)
    {//下画线
        
        origin_y = rect.size.height - 4;
    }
    
    lineRect = CGRectMake(origin_x , origin_y, strikeWidth, 1);
    
    if (self.lineType != LineTypeNone)
        
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGFloat R, G, B, A;
        UIColor *uiColor = self.lineColor;
        CGColorRef color = [uiColor CGColor];
        int numComponents = CGColorGetNumberOfComponents(color);
        
        if( numComponents == 4)
        {
            const CGFloat *components = CGColorGetComponents(color);
            R = components[0];
            G = components[1];
            B = components[2];
            A = components[3];
            
            CGContextSetRGBFillColor(context, R, G, B, 1.0);
        }
        
        CGContextFillRect(context, lineRect);
    }
}

@end
