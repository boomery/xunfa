//
//  HomeCloseCell.m
//  MHProject
//
//  Created by 杜宾 on 15/7/3.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "HomeCloseCell.h"

@implementation HomeCloseCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initCell];
    }
    return self;
}
-(void)initCell
{
//    底部的背景图
    self.bgView = [[UIView alloc]initForAutoLayout];
    [self addSubview:self.bgView];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.bgView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:0];
    [self.bgView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:0];
    [self.bgView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:0];
    [self.bgView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:10];
    
    //律师头像
    self.userImageBtn = [[UIButton alloc]initForAutoLayout];
    [self.bgView addSubview:self.userImageBtn];
    [self.userImageBtn autoSetDimensionsToSize:CGSizeMake(width(26.0), width(26.0))];
    [self.userImageBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:10 ];
    [self.userImageBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.bgView withOffset:10 ];
    self.userImageBtn.layer.cornerRadius = width(13.0);
    self.userImageBtn.clipsToBounds = YES;

    //提问者
    self.name = [[UILabel alloc] initForAutoLayout];
    [self.bgView addSubview:self.name];
    self.name.text = @"山子问:";
    self.name.font = [UIFont systemFontOfSize:17];
    self.name.textColor = DEF_RGB_COLOR(142, 147, 147);
    [self.name autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.userImageBtn withOffset:10 ];
    [self.name autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.bgView withOffset:13];
    [self.name autoSetDimensionsToSize:CGSizeMake(width(100.0), height(20.0))];

//    日期
    self.dateLable = [[UILabel alloc]initForAutoLayout];
    [self.bgView addSubview:self.dateLable];
    self.dateLable.font = [UIFont systemFontOfSize:13];
    self.dateLable.textColor = DEF_RGB_COLOR(111, 111, 111);
    //    self.dateLable.text = @"03-03 18:00";
    self.dateLable.textAlignment = 2;
    //    右边
    [self.dateLable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.bgView withOffset:-10];
    //    上
    [self.dateLable autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.bgView withOffset:13];
    //    下
    //    size
    [self.dateLable autoSetDimensionsToSize:CGSizeMake(width(80.0), height(20.0))];

    
//    问题
    self.questionLable = [[UILabel alloc] initForAutoLayout];
    [self addSubview:self.questionLable];
    self.questionLable.textColor = DEF_RGB_COLOR(100, 99, 105);
    self.questionLable.numberOfLines = 0;
    [self.questionLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.userImageBtn withOffset:0];
    [self.questionLable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.bgView withOffset:-10];
    [self.questionLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userImageBtn withOffset:10];
    [self.questionLable autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.bgView withOffset:-40];
    
    
    UIImageView *tagImagePic = [[UIImageView alloc]initForAutoLayout];
    [self.bgView addSubview:tagImagePic];
    tagImagePic.image = [UIImage imageNamed:@"s-tag"];
    tagImagePic.contentMode = UIViewContentModeScaleAspectFit;
    //    左边
    [tagImagePic autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.userImageBtn withOffset:0];
    //    上
    [tagImagePic autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.questionLable withOffset: 10];
    //    下
    [tagImagePic autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.bgView withOffset:- 10];
    //    size
    [tagImagePic autoSetDimension:ALDimensionWidth toSize:width(15.0)];
    
    
    self.leftBottomLable = [[UILabel alloc]initForAutoLayout];
    [self.bgView addSubview:self.leftBottomLable];
    _leftBottomLable.font = [UIFont systemFontOfSize:10];
    _leftBottomLable.textColor = DEF_RGB_COLOR(0, 160, 233);
    _leftBottomLable.text = @"经济纠纷";
    //    左边
    [self.leftBottomLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:tagImagePic withOffset:0];
    //    上
    [self.leftBottomLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.questionLable withOffset:10];
    //    下
    [self.leftBottomLable autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.bgView withOffset:-10];
    //    size
    [self.leftBottomLable autoSetDimension:ALDimensionWidth toSize:width(60.0)];
    
    
    
    self.rightBottomLable = [[UILabel alloc]initForAutoLayout];
    [self.bgView addSubview:self.rightBottomLable];
    self.rightBottomLable.font = [UIFont systemFontOfSize:10];
    _rightBottomLable.textColor = DEF_RGB_COLOR(178, 196, 205);
    self.rightBottomLable.text = @"20人出主意";
    //    右边
    [self.rightBottomLable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.questionLable withOffset:0];
    //    上
    [self.rightBottomLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.questionLable withOffset:10];
    //    下
    [self.rightBottomLable autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-10];
    //    size
    [self.rightBottomLable autoSetDimension:ALDimensionWidth toSize:width(80.0)];
    //
    
    
    //
    UIImageView *sIdeaImagePic = [[UIImageView alloc]initForAutoLayout];
    [self.bgView addSubview:sIdeaImagePic];
    sIdeaImagePic.image = [UIImage imageNamed:@"s-idea"];
    sIdeaImagePic.contentMode = UIViewContentModeScaleAspectFit;
    //    左边
    [sIdeaImagePic autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.rightBottomLable withOffset:0];
    //    上
    [sIdeaImagePic autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.questionLable withOffset:10];
    //    下
    [sIdeaImagePic autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-10];
    //    size
    [sIdeaImagePic autoSetDimension:ALDimensionWidth toSize:width(15.0)];

    
}
-(void)loadCellWithDict:(NSDictionary *)dict
{
    self.questionLable.text = [NSString stringWithFormat:@"%@",dict[@"introduce"]];
    self.leftBottomLable.text = @"刑事治安";
    self.rightBottomLable.text = [NSString stringWithFormat:@"%@:%@",@"6",@"出主意"];
    self.dateLable.text = @"02-15 16:40";
    self.name.text = @"山子问:";
    [self.userImageBtn setImage:[UIImage imageNamed:@"boss"] forState:UIControlStateNormal];
    
    
}
+(float)heightForCellWithDict:(NSDictionary *)dict
{
    //主意 下方擅长分类30
    NSString *detailStr = dict[@"introduce"];
      NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGSize ziTiSize = [detailStr boundingRectWithSize:CGSizeMake(DEF_SCREEN_WIDTH-20, 3000)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    float height = ziTiSize.height+ height(100.0);
    return height;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
