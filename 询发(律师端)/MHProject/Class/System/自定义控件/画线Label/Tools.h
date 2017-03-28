//
//  Tools.h
//  BestShopping
//
//  Created by Andy on 15/1/13.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

//不同的ios版本,调用不同的方法,实现相同的功能
+(CGSize)sizeOfStr:(NSString *)str
           andFont:(UIFont *)font
        andMaxSize:(CGSize)size
  andLineBreakMode:(NSLineBreakMode)mode;


@end
