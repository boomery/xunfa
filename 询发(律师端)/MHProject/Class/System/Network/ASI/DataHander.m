//
//  DataHander.m
//  CaCaXian
//
//  Created by Andy on 13-4-27.
//  Copyright (c) 2013年 Andy. All rights reserved.
//

#import "DataHander.h"
#import "AppDelegate.h"

@implementation DataHander
static DataHander* dataHander = nil;
@synthesize isNeed;
@synthesize rowDic;
+(DataHander *)sharedDataHander
{
    @synchronized(self){
        if (dataHander == nil) {
            dataHander = [[self alloc] init];
           
        }
    }
    return dataHander;
}

+ (void)showDlg
{
    NSString *loadString = NSLocalizedString(@"loading", @"");
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0.24 green:0.6 blue:0.9 alpha:1]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD showWithStatus:loadString maskType:SVProgressHUDMaskTypeClear];
}
+ (void)hideDlg
{
    [SVProgressHUD dismiss];
}

+ (void)showErrorWithTitle:(NSString *)title
{
    NSString *errorString = NSLocalizedString(title, @"");
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0.24 green:0.6 blue:0.9 alpha:1]];
    [SVProgressHUD showErrorWithStatus:errorString maskType:SVProgressHUDMaskTypeNone];
}

+ (void)showSuccessWithTitle:(NSString *)title
{
    NSString *errorString = NSLocalizedString(title, @"");
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0.24 green:0.6 blue:0.9 alpha:1]];
    [SVProgressHUD showSuccessWithStatus:errorString maskType:SVProgressHUDMaskTypeNone];
}

+ (void)showSuccessWithTitle:(NSString *)title completionBlock:(void(^)())completionBlock
{
    NSString *errorString = NSLocalizedString(title, @"");
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0.24 green:0.6 blue:0.9 alpha:1]];
    [SVProgressHUD showSuccessWithStatus:errorString maskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD sharedView].dismissBlock = ^{
        if (completionBlock)
        {
            completionBlock();
        }
    };
}
+ (void)showInfoWithTitle:(NSString *)title
{
    NSString *errorString = NSLocalizedString(title, @"");
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0.24 green:0.6 blue:0.9 alpha:1]];
    [SVProgressHUD showInfoWithStatus:errorString maskType:SVProgressHUDMaskTypeNone];
}

-(id)init{
    
    if(self = [super init])
    {
        isNeed = NO;
    }
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}
- (oneway void)release
{
    ///oneway用在分布式对象的API，这些API可以在不同的线程，甚至是不同的程序。oneway关键字只用在返回类型为void的消息定义中， 因为oneway是异步的，其消息预计不会立即返回。
}
- (id)autorelease
{
    return self;
}
-(void)dealloc
{
    mbProgressHud = nil;
    [super dealloc];
}
@end
