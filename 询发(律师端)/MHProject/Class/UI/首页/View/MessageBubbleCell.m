//
//  MessageBubbleCell.m
//  MHProject
//
//  Created by ZhangChaoxin on 15/7/7.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "MessageBubbleCell.h"
#import "UIImageView+WebCache.h"
#import "HZUtil.h"
@interface MessageBubbleCell ()

@property (nonatomic, strong) NSLayoutConstraint *headImageButtonLeftConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bubbleImageViewLeftConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bubbleImageViewHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bubbleImageViewWidthConstraint;
@property (nonatomic, strong) NSArray *contentLabelConstraints;

@end

@implementation MessageBubbleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor clearColor];
        
        //用户头像
        UIButton *headImageButton = [[UIButton alloc] initForAutoLayout];
        [self addSubview:headImageButton];
        headImageButton.layer.cornerRadius = width(15.0);
        headImageButton.clipsToBounds = YES;
        [headImageButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:0];
        _headImageButtonLeftConstraint = [headImageButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:10];
        [headImageButton autoSetDimensionsToSize:CGSizeMake(width(30.0), width(30.0))];
        _headImageButton = headImageButton;
        
        //聊天气泡
        UIImageView *bubbleImageView = [[UIImageView alloc ]initForAutoLayout];
        [self addSubview:bubbleImageView];
        [bubbleImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:0];
        _bubbleImageViewLeftConstraint = [bubbleImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:headImageButton withOffset:2];
        _bubbleImageViewHeightConstraint = [_bubbleImageView autoSetDimension:ALDimensionHeight toSize:0];
        _bubbleImageViewWidthConstraint = [bubbleImageView autoSetDimension:ALDimensionWidth toSize:0];
        _bubbleImageView = bubbleImageView;
        
        //聊天内容
        UILabel *contentLabel = [[UILabel alloc] initForAutoLayout];
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont systemFontOfSize:13.5];
        [bubbleImageView addSubview:contentLabel];
        _contentLabelConstraints = [contentLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        _contentLabel = contentLabel;
    }
    return self;
}

- (void)refreshCellWithDictionary:(NSDictionary *)dictionary
{
    NSString *type = dictionary[@"type"];
    NSString * contentString = dictionary[@"content"];
    if ([NSString isBlankString:contentString])
    {
        contentString = @"";
    }
    NSString *imageUrlString = dictionary[@"avatar"];
    CGFloat height = [HZUtil getHeightWithString:contentString fontSize:13.5 width:width(210.0)];
    CGFloat width = [HZUtil getWidthWithString:contentString fontSize:13.5 width:width(210.0)];
    //头像
    [self.headImageButton sd_setImageWithURL:[NSURL URLWithString:imageUrlString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"admin"]];
    NSLayoutConstraint *leftConstriant = _contentLabelConstraints[1];
    NSLayoutConstraint *rightConstriant = _contentLabelConstraints[3];
    _contentLabel.text = contentString;
    //用户的消息
    if ([type isEqualToString:@"1"])
    {
        UIImage *image = [UIImage imageNamed:@"bubble_left"];
        _bubbleImageView.image = [[UIImage imageNamed:@"bubble_left"] stretchableImageWithLeftCapWidth:floor(image.size.width/3.0) topCapHeight:floor(image.size.height/3.0)];
        //重置偏移量，消除重用问题
        _headImageButtonLeftConstraint.constant = 10;
        _bubbleImageViewLeftConstraint.constant = 2;
        
        _bubbleImageViewHeightConstraint.constant = height+10;
        _bubbleImageViewWidthConstraint.constant = width+30;
        
        leftConstriant.constant = 17;
        rightConstriant.constant = -5;
    }
    //律师的消息
    else if ([type isEqualToString:@"2"])
    {
        UIImage *image = [UIImage imageNamed:@"bubble_left"];
        _bubbleImageView.image = [[UIImage imageNamed:@"bubble_right"] stretchableImageWithLeftCapWidth:floor(image.size.width/3.0) topCapHeight:floor(image.size.height/3.0)];
  
        _headImageButtonLeftConstraint.constant = DEF_SCREEN_WIDTH-50;
        _bubbleImageViewLeftConstraint.constant = -width-70;
        
        _bubbleImageViewHeightConstraint.constant = height+10;
        _bubbleImageViewWidthConstraint.constant = width+30;
        
        leftConstriant.constant = 10;
        rightConstriant.constant = -15;
    }
}

+ (CGFloat)heightForCellWithDictionary:(NSDictionary *)dictionary
{
    NSString * contentString = dictionary[@"content"];
    if ([NSString isBlankString:contentString])
    {
        contentString = @"";
    }
    CGFloat height = [HZUtil getHeightWithString:contentString fontSize:13.5 width:width(210.0)];
    return height + 40;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
