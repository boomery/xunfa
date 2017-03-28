//
//  AnimateLabel.h
//  Delegate
//
//  Created by ZhangChaoxin on 15/7/22.
//  Copyright (c) 2015年 ZhangChaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    DirectionLeft = 0,
    DirectionRight
}Direction;

@interface AnimateLabel : UILabel

- (void)setAttributeText:(NSAttributedString *)attributeText withDirection:(Direction)direction;

@end
