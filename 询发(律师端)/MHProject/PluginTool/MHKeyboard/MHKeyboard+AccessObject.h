//
//  MHKeyboard+AccessObject.h
//  MHProject
//
//  Created by MengHuan on 15/5/13.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import "MHKeyboard.h"
#import <objc/runtime.h>
#import "MHKeyboardObjects.h"

@interface MHKeyboard (AccessObject)

+ (MHKeyboardObjects *)objects;

@end
