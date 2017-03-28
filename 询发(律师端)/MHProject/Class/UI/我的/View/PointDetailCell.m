//
//  PointDetailCell.m
//  MHProject
//
//  Created by 张好志 on 15/7/7.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "PointDetailCell.h"

@implementation PointDetailCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //小圆点
        self.pointView = [[UIImageView alloc]initForAutoLayout];
        [self addSubview:self.pointView];
        [self.pointView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:10 ];
        [self.pointView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:20 ];
        [self.pointView autoSetDimensionsToSize:CGSizeMake(10, 10)];
        self.pointView.image = [UIImage imageNamed:@"dot-blue"];
        self.pointView.contentMode = UIViewContentModeScaleAspectFit;
        
        //上线
        self.upLine = [[UIView alloc]initForAutoLayout];
        [self addSubview:self.upLine];
        [self.upLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.pointView withOffset:4.5];
        [self.upLine autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:0];
        [self.upLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.pointView withOffset:0];
        [self.upLine autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.pointView withOffset:-4.5];
        self.upLine.backgroundColor = DEF_RGB_COLOR(214, 214, 217);
        
        //时间标签
        self.dateLable = [[UILabel alloc]initForAutoLayout];
        [self addSubview:self.dateLable];
        [self.dateLable autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.pointView withOffset:-10];
        [self.dateLable autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.pointView withOffset:10];
        [self.dateLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.pointView withOffset:5];
        [self.dateLable autoSetDimensionsToSize:CGSizeMake(40, 10)];
        self.dateLable .text = @"03/26";
        if (DEF_SCREEN_WIDTH==320) {
            self.dateLable .font = [UIFont systemFontOfSize:12];
        }else{
            self.dateLable .font = [UIFont systemFontOfSize:15];
        }
        self.dateLable .textColor = DEF_RGB_COLOR(142, 142, 147);
//        self.dateLable.backgroundColor = [UIColor redColor];

        //下线
        self.downLine = [[UIView alloc]initForAutoLayout];
        [self addSubview:self.downLine];
        [self.downLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.pointView withOffset:4.5];
        [self.downLine autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.pointView withOffset:0];
        [self.downLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:0];
        [self.downLine autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.pointView withOffset:-4.5];
        self.downLine.backgroundColor = DEF_RGB_COLOR(214, 214, 217);

        //左侧积点增加减少背景
        self.pointBgView = [[UIView alloc]initForAutoLayout];
        [self addSubview:self.pointBgView];
        [self.pointBgView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.dateLable withOffset:5];
        [self.pointBgView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:10];
        [self.pointBgView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-10];
        [self.pointBgView autoSetDimensionsToSize:CGSizeMake(80, 40)];
        self.pointBgView.layer.borderWidth = 1;
        self.pointBgView.layer.borderColor = DEF_RGB_COLOR(214, 214, 217).CGColor;
        self.pointBgView.layer.masksToBounds = YES;
        self.pointBgView.layer.cornerRadius = 8;
        self.pointBgView.backgroundColor = [UIColor whiteColor];

        //
        self.pointLB = [[UILabel alloc]initForAutoLayout];
        [self.pointBgView addSubview:self.pointLB];
        [self.pointLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.pointBgView withOffset:0];
        [self.pointLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.pointBgView withOffset:0];
        [self.pointLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.pointBgView withOffset:0];
        [self.pointLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.pointBgView withOffset:0];
        self.pointLB.textAlignment = 1;
        self.pointLB.textColor = DEF_RGB_COLOR(255, 122, 67);
//        self.pointLB.textColor = DEF_RGB_COLOR(178, 178, 178);
        self.pointLB.text = @"+5积分";

        
        //右侧详情
        self.detailBgView = [[UIView alloc]initForAutoLayout];
        [self addSubview:self.detailBgView];
        [self.detailBgView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.pointBgView withOffset:10];
        [self.detailBgView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:10];
        [self.detailBgView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-10];
        [self.detailBgView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-10];
        self.detailBgView.layer.borderWidth = 1;
        self.detailBgView.layer.borderColor = DEF_RGB_COLOR(214, 214, 217).CGColor;
        self.detailBgView.layer.masksToBounds = YES;
        self.detailBgView.layer.cornerRadius = 8;
        self.detailBgView.backgroundColor = [UIColor whiteColor];
        
        
        //
        self.pointDetailLB = [[UILabel alloc]initForAutoLayout];
        [self addSubview:self.pointDetailLB];
        [self.pointDetailLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.detailBgView withOffset:10];
        [self.pointDetailLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.detailBgView withOffset:0];
        [self.pointDetailLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.detailBgView withOffset:0];
        [self.pointDetailLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.detailBgView withOffset:0];
        self.pointDetailLB.textAlignment = 0;
        self.pointDetailLB.textColor = DEF_RGB_COLOR(111, 111, 111);
        self.pointDetailLB.text = @"用户采纳答案";
        
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
    self.dateLable .text = [NSString stringWithFormat:@"%@",dict[@"created_at"]];

    //
    NSString *num =dict[@"num"];
    NSString *type = [num substringToIndex:1];
    if ([type isEqualToString:@"+"])
    {
        self.pointLB.textColor = DEF_RGB_COLOR(255, 122, 67);
    }
    else if ([type isEqualToString:@"-"]){
        self.pointLB.textColor = DEF_RGB_COLOR(178, 178, 178);
    }
    self.pointLB.text = [NSString stringWithFormat:@"%@积分",dict[@"num"]];
    
    //
    self.pointDetailLB.text = dict[@"content"];
}
+(float)heightForCellWithDict:(NSDictionary *)dict
{
    return 60.0/568 *DEF_SCREEN_HEIGHT;
}


-(void)loadCellWithPointDict:(NSDictionary *)dict
{
    /*
     {
     content = "\U63d0\U95ee\U83b7\U5f97\U79ef\U5206";
     "created_at" = "07-08 09:33";
     num = "+10";
     },
     */
    
    //
    self.dateLable .text = [NSString stringWithFormat:@"%@",dict[@"created_at"]];
    
    //
    NSString *num =dict[@"num"];
    NSString *type = [num substringToIndex:1];
    if ([type isEqualToString:@"+"])
    {
        self.pointLB.textColor = DEF_RGB_COLOR(255, 122, 67);
    }
    else if ([type isEqualToString:@"-"]){
        self.pointLB.textColor = DEF_RGB_COLOR(178, 178, 178);
    }
    self.pointLB.text = [NSString stringWithFormat:@"%@积点",dict[@"num"]];
    
    //
    self.pointDetailLB.text = dict[@"content"];
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
