//
//  XYAlertViewManager.m
//  DDMates
//
//  Created by Andy on 7/25/12.
//  Copyright (c) 2012 TelenavSoftware, Inc. All rights reserved.
//

#import "XYAlertViewManager.h"
#import "XYLoadingView.h"
#import "XYAlertView.h"

#define AlertViewWidth 280.0f
#define AlertViewHeight 175.0f

CGRect XYScreenBounds()
{
    CGRect bounds = [UIScreen mainScreen].bounds;
    UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
    if (UIDeviceOrientationUnknown == orient)
        orient = UIDeviceOrientationPortrait;

    if (UIInterfaceOrientationIsLandscape(orient))
    {
        CGFloat width = bounds.size.width;
        bounds.size.width = bounds.size.height;
        bounds.size.height = width;
    }
    return bounds;
}

@implementation XYAlertViewManager

static XYAlertViewManager *sharedAlertViewManager = nil;

+(XYAlertViewManager*)sharedAlertViewManager
{
    @synchronized(self)
    {
        if(!sharedAlertViewManager)
            sharedAlertViewManager = [[XYAlertViewManager alloc] init];
    }
    
    return sharedAlertViewManager;
}

-(id)init 
{
    self = [super init];
    if(self)
    {
        _alertViewQueue = [[NSMutableArray alloc] init];
        _isDismissing = NO;
    }
    
    return self;
}

-(void)dealloc
{
    [_alertViewQueue removeAllObjects];
    [_loadingTimer invalidate];
}

#pragma mark - private

-(UIImage*)buttonImageByStyle:(XYButtonStyle)style state:(UIControlState)state
{
    switch(style)
    {
        default:
        case XYButtonStyleGray:
            return [[UIImage imageNamed:(state == UIControlStateNormal ? @"button-no" : @"button-no")] stretchableImageWithLeftCapWidth:22 topCapHeight:22];
        case XYButtonStyleGreen:
            return [[UIImage imageNamed:(state == UIControlStateNormal ? @"button-go" : @"button-go")] stretchableImageWithLeftCapWidth:22 topCapHeight:22];
    }
}

-(void)prepareLoadingToDisplay:(XYLoadingView*)entity
{
    CGRect screenBounds = XYScreenBounds();
    if(!_blackBG)
    {
        _blackBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height)];
        _blackBG.backgroundColor = [UIColor blackColor];
        _blackBG.opaque = YES;
        _blackBG.alpha = 0.5f;
        _blackBG.userInteractionEnabled = YES;
    }
    
    _alertView = nil;
    _alertView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alertView_loading.png"]];
    _alertView.center = CGPointMake(screenBounds.size.width / 2, screenBounds.size.height / 2);
    
    _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, 30)];
    _loadingLabel.textAlignment = DEF_TextAlignmentCenter;
    _loadingLabel.backgroundColor = [UIColor clearColor];
    _loadingLabel.textColor = [UIColor whiteColor];
    _loadingLabel.font = [UIFont boldSystemFontOfSize:14];
    _loadingLabel.text = entity.message;
    _loadingLabel.numberOfLines = 2;
}

-(void)prepareAlertToDisplay:(XYAlertView*)entity
{
    CGRect screenBounds = XYScreenBounds();
    if(!_blackBG)
    {
        _blackBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height)];
        _blackBG.backgroundColor = [UIColor blackColor];
        _blackBG.opaque = YES;
        _blackBG.alpha = 0.5f;
        _blackBG.userInteractionEnabled = YES;
    }

    _alertView = nil;
    _alertView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@""] stretchableImageWithLeftCapWidth:34 topCapHeight:44]];
    _alertView.backgroundColor = [UIColor whiteColor];
    _alertView.userInteractionEnabled = YES;
    _alertView.frame = CGRectMake(0, 0, AlertViewWidth, AlertViewHeight);
    _alertView.center = CGPointMake(screenBounds.size.width / 2, screenBounds.size.height / 2);
    _alertView.layer.cornerRadius = 5;
    _alertView.clipsToBounds = YES;

    //
    UILabel *_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, AlertViewWidth, 44)];
    _titleLabel.textAlignment = DEF_TextAlignmentCenter;
    _titleLabel.backgroundColor = DEF_RGB_COLOR(255, 114, 53);
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:22];
    _titleLabel.text = entity.title;
    [_alertView addSubview:_titleLabel];
    
    //
    UILabel *_messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 44, AlertViewWidth-24, 80)];
    _messageLabel.textAlignment = DEF_TextAlignmentCenter;
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.textColor = DEF_RGB_COLOR(51, 51, 51);
    _messageLabel.font = [UIFont systemFontOfSize:17];
    _messageLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _messageLabel.numberOfLines = 3;
    [_alertView addSubview:_messageLabel];

    //调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:entity.message];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [entity.message length])];
    _messageLabel.attributedText = attributedString;
    _messageLabel.textAlignment = DEF_TextAlignmentCenter;
    
    //
    UILabel *_lineLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 127, AlertViewWidth, LINE_HEIGHT)];
    _lineLb.backgroundColor = [UIColor lightGrayColor];
    [_alertView addSubview:_lineLb];
    

//    float buttonWidth = (AlertViewWidth - 100.0f) / entity.buttons.count;
//    float buttonPadding = 100.0f / (entity.buttons.count - 1 + 2 * 2);
    float buttonWidth = (AlertViewWidth-2.0) / entity.buttons.count;
    float buttonPadding = 2.0 / (entity.buttons.count - 1 + 2 * 2);
    for(int i = 0; i < entity.buttons.count; i++)
    {
        NSString *buttonTitle = [entity.buttons objectAtIndex:i];
        XYButtonStyle style = [[entity.buttonsStyle objectAtIndex:i] intValue];

        UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:buttonTitle forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:17];
//        _button.titleLabel.shadowOffset = CGSizeMake(1, 1);
        [_button setTitleColor:DEF_RGB_COLOR(111, 111, 111) forState:UIControlStateNormal];
//        [_button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button setBackgroundImage:[self buttonImageByStyle:style state:UIControlStateNormal]
                           forState:UIControlStateNormal];
        [_button setBackgroundImage:[self buttonImageByStyle:style state:UIControlStateHighlighted]
                           forState:UIControlStateHighlighted];
//        _button.clipsToBounds = YES;
//        _button.layer.cornerRadius = 22;
        _button.frame = CGRectMake(buttonPadding * 2 + buttonWidth * i + buttonPadding * i, 128,buttonWidth, 44);
        _button.tag = i;
        [_button addTarget:self action:@selector(onButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:_button];
        
        //下方按钮中间的线条
        if (entity.buttons.count==2)
        {
            UILabel *medileLineLb = [[UILabel alloc] initWithFrame:CGRectMake(AlertViewWidth/2.0-0.5, _button.frame.origin.y, LINE_HEIGHT,_button.frame.size.height)];
            medileLineLb.backgroundColor = [UIColor lightGrayColor];
            [_alertView addSubview:medileLineLb];
        }
    }
}

-(void)updateLoadingAnimation
{
    CGAffineTransform transform = _alertView.transform;
    transform = CGAffineTransformRotate(transform, M_PI / 20);
    _alertView.transform = transform;
}

-(void)checkoutInStackAlertView
{
    if(_alertViewQueue.count > 0)
    {
        id entity = [_alertViewQueue lastObject];

        [_loadingTimer invalidate];
        _loadingTimer = nil;
        [_alertView removeFromSuperview];
        [_blackBG removeFromSuperview];
        [_loadingLabel removeFromSuperview];
        
        if([entity isKindOfClass:[XYAlertView class]])
        {
            [self prepareAlertToDisplay:entity];
            [self showAlertViewWithAnimation:entity];
        }
        else if([entity isKindOfClass:[XYLoadingView class]])
        {
            [self prepareLoadingToDisplay:entity];
            [self showLoadingViewWithAnimation:entity];
        }
    }
}

-(void)onButtonTapped:(id)sender
{
    [self dismiss:[_alertViewQueue lastObject] button:((UIButton*)sender).tag];
}

#pragma mark - animation

-(void)showAlertViewWithAnimation:(id)entity
{
    if([entity isKindOfClass:[XYAlertView class]])
    {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    //    if(!keyWindow)
        {
            NSArray *windows = [UIApplication sharedApplication].windows;
            if(windows.count > 0) keyWindow = [windows lastObject];
    //            keyWindow = [windows objectAtIndex:0];
        }
        
        _blackBG.alpha = 0.0f;
        CGRect frame = _alertView.frame;
        frame.origin.y = -AlertViewHeight;
        _alertView.frame = frame;
        [keyWindow addSubview:_blackBG];
        [keyWindow addSubview:_alertView];
        
        [UIView animateWithDuration:0.2f animations:^{
            _blackBG.alpha = 0.5f;
            _alertView.center = CGPointMake(XYScreenBounds().size.width / 2, XYScreenBounds().size.height / 2);
        }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}

-(void)dismissAlertViewWithAnimation:(id)entity button:(int)buttonIndex
{
    if([entity isKindOfClass:[XYAlertView class]])
    {
        [UIView animateWithDuration:0.2f
                         animations:
         ^{
             _blackBG.alpha = 0.0f;
             CGRect frame = _alertView.frame;
             frame.origin.y = -AlertViewHeight;
             _alertView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             [_alertView removeFromSuperview];
             [_blackBG removeFromSuperview];
             
             [_alertViewQueue removeLastObject];
             _isDismissing = NO;

             if(((XYAlertView*)entity).blockAfterDismiss)
                 ((XYAlertView*)entity).blockAfterDismiss(buttonIndex);

             [self checkoutInStackAlertView];
         }];
    }
}

-(void)showLoadingViewWithAnimation:(id)entity
{
    if([entity isKindOfClass:[XYLoadingView class]])
    {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    //    if(!keyWindow)
        {
            NSArray *windows = [UIApplication sharedApplication].windows;
            if(windows.count > 0) keyWindow = [windows lastObject];
    //            keyWindow = [windows objectAtIndex:0];
        }
        
        _blackBG.alpha = 0.0f;
        CGRect frame = _alertView.frame;
        frame.origin.y = -AlertViewHeight;
        _alertView.frame = frame;
        frame = _loadingLabel.frame;
        frame.origin.y = XYScreenBounds().size.height;
        _loadingLabel.frame = frame;
        [keyWindow addSubview:_blackBG];
        [keyWindow addSubview:_alertView];
        [keyWindow addSubview:_loadingLabel];
        
        _loadingTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateLoadingAnimation) userInfo:nil repeats:YES];
        
        [UIView animateWithDuration:0.2f animations:^{
            _blackBG.alpha = 0.5f;
            _alertView.center = CGPointMake(XYScreenBounds().size.width / 2, XYScreenBounds().size.height / 2);
            CGRect frame = _loadingLabel.frame;
            frame.origin.y = _alertView.frame.origin.y + _alertView.frame.size.height + 10;
            _loadingLabel.frame = frame;
        }
                         completion:^(BOOL finished) {
                         }];
    }
}

-(void)dismissLoadingViewWithAnimation:(id)entity
{
    if([entity isKindOfClass:[XYLoadingView class]])
    {
        [UIView animateWithDuration:0.2f
                         animations:
         ^{
             _blackBG.alpha = 0.0f;
             CGRect frame = _alertView.frame;
             frame.origin.y = -AlertViewHeight;
             _alertView.frame = frame;
             frame = _loadingLabel.frame;
             frame.origin.y = XYScreenBounds().size.height;
             _loadingLabel.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             [_loadingTimer invalidate];
             _loadingTimer = nil;
             [_alertView removeFromSuperview];
             [_blackBG removeFromSuperview];
             [_loadingLabel removeFromSuperview];

             [_alertViewQueue removeLastObject];

             _isDismissing = NO;

             [self checkoutInStackAlertView];
         }];
    }
}

#pragma mark - public

-(XYAlertView*)showAlertView:(NSString*)message btnTitle:(NSString *)btnTitle
{
    XYAlertView *alertView = [XYAlertView alertViewWithTitle:@""
                                                     message:message
                                                     buttons:[NSArray arrayWithObjects:btnTitle, nil]
                                                afterDismiss:nil];
    [self show:alertView];
    
    return alertView;
}

-(XYLoadingView*)showLoadingView:(NSString*)message
{
    XYLoadingView *loadingView = [XYLoadingView loadingViewWithMessage:message];
    [self show:loadingView];
    
    return loadingView;
}

-(void)show:(id)entity
{
    if([entity isKindOfClass:[XYAlertView class]] || [entity isKindOfClass:[XYLoadingView class]])
    {
        if(_isDismissing == YES && _alertViewQueue.count > 0)
        {
            [_alertViewQueue insertObject:entity atIndex:_alertViewQueue.count - 1];
        }
        else
        {
            [_alertViewQueue addObject:entity];
            
            [_loadingTimer invalidate];
            _loadingTimer = nil;
            [_alertView removeFromSuperview];
            [_blackBG removeFromSuperview];
            [_loadingLabel removeFromSuperview];
            
            if([entity isKindOfClass:[XYAlertView class]])
            {
                [self prepareAlertToDisplay:entity];
                [self showAlertViewWithAnimation:entity];
            }
            else if([entity isKindOfClass:[XYLoadingView class]])
            {
                [self prepareLoadingToDisplay:entity];
                [self showLoadingViewWithAnimation:entity];
            }
        }
    }
}

-(void)dismiss:(id)entity
{
    [self dismiss:entity button:0];
}

-(void)dismiss:(id)entity button:(int)buttonIndex
{
    if(_alertViewQueue.count <= 0)
        return;

    if([entity isKindOfClass:[XYAlertView class]] || [entity isKindOfClass:[XYLoadingView class]])
    {
        _isDismissing = YES;
        
        if([entity isEqual:[_alertViewQueue lastObject]])
        {
            if([entity isKindOfClass:[XYAlertView class]])
                [self dismissAlertViewWithAnimation:entity button:buttonIndex];
            else if([entity isKindOfClass:[XYLoadingView class]])
                [self dismissLoadingViewWithAnimation:entity];
        }
        else
        {
            [_alertViewQueue removeObject:entity];
            if([entity isKindOfClass:[XYAlertView class]])
                ((XYAlertView*)entity).blockAfterDismiss(buttonIndex);
        }
    }
}

-(void)dismissLoadingView:(id)entity withFailedMessage:(NSString*)message
{
    if(_alertViewQueue.count <= 0)
        return;
    
    if([entity isEqual:[_alertViewQueue lastObject]] && [entity isKindOfClass:[XYLoadingView class]])
    {
        _isDismissing = YES;

        XYAlertView *alertView = [XYAlertView alertViewWithTitle:@"注意"
                                                         message:message
                                                         buttons:[NSArray arrayWithObjects:@"确定", nil]
                                                    afterDismiss:nil];
        
        [_alertViewQueue insertObject:alertView atIndex:_alertViewQueue.count - 1];

        [self dismissLoadingViewWithAnimation:entity];
    }
}

-(void)cleanupAllViews
{
    [_loadingTimer invalidate];
    _loadingTimer = nil;
    [_alertView removeFromSuperview];
    _alertView = nil;
    [_blackBG removeFromSuperview];
    [_loadingLabel removeFromSuperview];

    [_alertViewQueue removeAllObjects];
}

@end
