//
//  MyInformationCell.m
//  MHProject
//
//  Created by 杜宾 on 15/6/24.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "MyInformationCell.h"

#define topSpace 18

@implementation MyInformationCell
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
    
    _pointView = [[UIImageView alloc]initForAutoLayout];
    [self addSubview:_pointView];
    _pointView.image = [UIImage imageNamed:@"dot-orange"];
    _pointView.contentMode = UIViewContentModeScaleAspectFit;
    [_pointView autoPinEdge:ALEdgeLeft  toEdge:ALEdgeLeft ofView:self withOffset:16];
    [_pointView autoPinEdge:ALEdgeTop  toEdge:ALEdgeTop ofView:self withOffset:20];
    [_pointView autoSetDimensionsToSize:CGSizeMake(24.0, 24.0)];
    
    //上面的线
    self.upLine = [[UIImageView alloc]initForAutoLayout];
    [self addSubview:_upLine];
    _upLine.backgroundColor = DEF_RGB_COLOR(218, 218, 218);
    [_upLine autoPinEdge:ALEdgeLeft  toEdge:ALEdgeLeft ofView:_pointView withOffset:12];
    [_upLine autoPinEdge:ALEdgeTop  toEdge:ALEdgeTop ofView:self withOffset:0];
    [_upLine autoSetDimensionsToSize:CGSizeMake(1, 24)];
    
    //日期
    _dateLable = [[UILabel alloc]initForAutoLayout];
    [self addSubview:_dateLable];
    _dateLable.font = DEF_Font(13.5);
    [_dateLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.pointView withOffset:5];
    [_dateLable autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.pointView withOffset:2];
    _dateLable.textColor = DEF_RGB_COLOR(111, 111, 111);
    _dateLable.numberOfLines = 2;
    [_dateLable autoSetDimensionsToSize:CGSizeMake(40, 40)];
    
    //
    _bgView = [[UIView alloc]initForAutoLayout];
    [self addSubview:_bgView];
    _bgView.layer.borderWidth = LINE_HEIGHT;
    _bgView.layer.borderColor = DEF_RGB_COLOR(202, 202, 202).CGColor;
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 3;
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.dateLable withOffset:8];
    [_bgView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:20];
    [_bgView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-TRANSFORM_WIDTH(52/3*2)];
    [_bgView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:0];
    
    //
//    float fontSize;
//    if (DEF_SCREEN_IS_6)
//    {
//        fontSize = 15;
//    }
//    else
//    {
//        fontSize = 16;
//    }
    _questionLable = [[UILabel alloc]initForAutoLayout];
    [_bgView addSubview:_questionLable];
    self.questionLable.numberOfLines = 0;
    self.questionLable.font = [UIFont systemFontOfSize:16];
    [_questionLable autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.bgView withOffset:5.0];
    [_questionLable autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.bgView withOffset:-5.0];
    [_questionLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_bgView withOffset:5];
    [_questionLable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_bgView withOffset:-5];
    _questionLable.textColor = DEF_RGB_COLOR(51, 51, 51);
//    _questionLable.backgroundColor = [UIColor redColor];
    
    
    
    _downLine = [[UIImageView alloc]initForAutoLayout];
    [self addSubview:_downLine];
    _downLine.backgroundColor = DEF_RGB_COLOR(218, 218, 218);
    [_downLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_pointView withOffset:12];
    [_downLine autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.pointView withOffset:-4];
    [_downLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:0];
    [_downLine autoSetDimension:ALDimensionWidth toSize:1];
    DEF_DEBUG(@"%f",DEF_SCREEN_WIDTH - _questionLable.width);
}

//
-(void)loadCellWithDict:(NSDictionary *)dict
{
    _dateLable.text = dict[@"created_at"];
    self.questionLable.text = dict[@"content"];
//
//    self.questionLable.text = [NSString stringWithFormat:@"%@lksjlskdflksdjflksjflksjdflkjdslkfjsklksjlskdflksdjflksjflksjdflkjdslkfjsk",dict[@"content"]];
    NSString *pointColorStr = dict[@"is_read"];
//    为0 是未读消息  否则是已读消息
    if ([pointColorStr isEqualToString:@"0"]){
        _pointView.image = [UIImage imageNamed:@"dot-orange"];
    }else{
        _pointView.image = [UIImage imageNamed:@"dot-blue"];
    }
}
+(float)heightForCellWithDict:(NSDictionary *)dict
{
    NSString *detailStr = dict[@"content"];
//    NSString *detailStr = [NSString stringWithFormat:@"%@lksjlskdflksdjflksjflksjdflkjdslkfjsklksjlskdflksdjflksjflksjdflkjdslkfjsk",dict[@"content"]];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGSize ziTiSize = [detailStr boundingRectWithSize:CGSizeMake(DEF_SCREEN_WIDTH-(24 +16 +5+40+8) - TRANSFORM_WIDTH(52/3*2), 3000)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    float height = ziTiSize.height+35;
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
