//
//  IntegralTableViewCell.m
//  MHProject
//
//  Created by 张好志 on 15/7/23.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "IntegralTableViewCell.h"

@implementation IntegralTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        //
        self.titleLB = [[UILabel alloc]initForAutoLayout];
        [self addSubview:self.titleLB];
        [self.titleLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:8];
        [self.titleLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:12];
        [self.titleLB autoSetDimensionsToSize:CGSizeMake(DEF_SCREEN_WIDTH-72-24, 20)];
        self.titleLB.font = [UIFont systemFontOfSize:16.0];
        self.titleLB.textColor = DEF_RGB_COLOR(51, 51, 51);
//        self.titleLB.backgroundColor = [UIColor orangeColor];
        
        //
        self.dateLB = [[UILabel alloc]initForAutoLayout];
        [self addSubview:self.dateLB];
        [self.dateLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:8];
        [self.dateLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-12];
        [self.dateLB autoSetDimensionsToSize:CGSizeMake(72, 20)];
        self.dateLB.font = [UIFont systemFontOfSize:12.0];
        self.dateLB.textColor = DEF_RGB_COLOR(159, 159, 159);
        self.dateLB.textAlignment = NSTextAlignmentRight;

        //
        self.balanceLB = [[UILabel alloc]initForAutoLayout];
        [self addSubview:self.balanceLB];
        [self.balanceLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLB withOffset:0];
        [self.balanceLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:12];
        [self.balanceLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-5];
        [self.balanceLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-72-24];
        self.balanceLB.font = [UIFont systemFontOfSize:12.0];
        self.balanceLB.textColor = DEF_RGB_COLOR(111, 111, 111);
//        self.balanceLB.text = @"余额：233";
//        self.balanceLB.backgroundColor = [UIColor redColor];
        //
        self.integralCountLB = [[UILabel alloc]initForAutoLayout];
        [self addSubview:self.integralCountLB];
        [self.integralCountLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.dateLB withOffset:0];
        [self.integralCountLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-12];
        [self.integralCountLB autoSetDimensionsToSize:CGSizeMake(60, 20)];
        self.integralCountLB.textAlignment = NSTextAlignmentRight;
        self.integralCountLB.font = [UIFont systemFontOfSize:22.0];
        self.integralCountLB.textColor = DEF_RGB_COLOR(51, 51, 51);
//        self.integralCountLB.text = @"+2";
//        self.integralCountLB.backgroundColor = [UIColor blueColor];
        //
        UILabel *lineLB = [[UILabel alloc]initForAutoLayout];
        [self addSubview:lineLB];
        lineLB.backgroundColor = DEF_RGB_COLOR(202, 202, 202);
        [lineLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:0];
        [lineLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:0];
        [lineLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:0];
        [lineLB autoSetDimensionsToSize:CGSizeMake(DEF_SCREEN_WIDTH,LINE_HEIGHT)];
    }
    return self;
}

-(void)loadCellWithDict:(NSMutableDictionary *)dict
{
    /*
     {
     content = "\U63d0\U95ee\U83b7\U5f97\U79ef\U5206";
     "created_at" = "07-08 09:33";
     num = "+10";
     },
     */
    
    //
    self.dateLB .text = [NSString stringWithFormat:@"%@",dict[@"created_at"]];
    self.integralCountLB.text =[NSString stringWithFormat:@"%@",dict[@"num"]];
    self.titleLB.text = dict[@"content"];
    
    self.balanceLB.text = [NSString stringWithFormat:@"积分余额：%@",dict[@"total"]];
}
+(float)heightForCellWithDict:(NSDictionary *)dict
{
    return 56.0;
}


#pragma mark -- 积点
-(void)loadCellWithDotDict:(NSMutableDictionary *)dict
{
    /*
     {
     content = "\U63d0\U95ee\U83b7\U5f97\U79ef\U5206";
     "created_at" = "07-08 09:33";
     num = "+10";
     },
     */
    
    //
    self.dateLB .text = [NSString stringWithFormat:@"%@",dict[@"created_at"]];
    self.integralCountLB.text =[NSString stringWithFormat:@"%@",dict[@"num"]];
    self.titleLB.text = dict[@"content"];
    
    NSString *total = [NSString stringWithFormat:@"%@",dict[@"total"]];
    if ([NSString isBlankString:total]) {
        total = 0;
    }
    self.balanceLB.text = [NSString stringWithFormat:@"积点余额：%@",total];

}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
