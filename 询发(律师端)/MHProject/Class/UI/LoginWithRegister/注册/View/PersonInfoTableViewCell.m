//
//  PersonInfoTableViewCell.m
//  MHProject
//
//  Created by 张好志 on 15/6/23.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "PersonInfoTableViewCell.h"

@implementation PersonInfoTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 1)];
        self.lineImageView.backgroundColor = DEF_RGB_COLOR(234, 234, 234);
        [self addSubview:self.lineImageView];
        
        
        self.inputTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, DEF_SCREEN_WIDTH, 51)];
        [self.inputTF setValue:DEF_RGB_COLOR(100, 99, 105) forKeyPath:@"_placeholderLabel.textColor"];
        [self addSubview:self.inputTF];
        
        self.arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - 20, 31, 20, 20)];
        self.arrowImage.image = [UIImage imageNamed:@"arrow"];
        self.arrowImage.hidden = YES;
        [self addSubview:self.arrowImage];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
