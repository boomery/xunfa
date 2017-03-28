//
//  UserCenterBtn.h
//  MHProject
//
//  Created by 杜宾 on 15/6/24.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCenterBtn : UIButton

@property(nonatomic,strong)UIImageView *picImageView;

-(id)initWithFrame:(CGRect)frame WithImage:(UIImage *)imagePic WithTitle:(NSString *)title;
@end
