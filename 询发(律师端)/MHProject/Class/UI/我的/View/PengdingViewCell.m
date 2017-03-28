//
//  PengdingViewCell.m
//  MHProject
//
//  Created by 杜宾 on 15/8/25.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "PengdingViewCell.h"

@implementation PengdingViewCell
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
    //    底部背景图
    UIView *pendingView = [[UIView alloc]initForAutoLayout];
    [self addSubview:pendingView];
    [pendingView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(12, 0, 0, 0)];
    [pendingView autoSetDimension:ALDimensionHeight toSize:82];
    pendingView.backgroundColor = [UIColor whiteColor];
    pendingView.layer.borderWidth = LINE_HEIGTH;
    pendingView.layer.borderColor = DEF_RGB_COLOR(214, 213, 218).CGColor;
    
    //    用户头像
    self.userPhotoImage = [[UIImageView alloc]initForAutoLayout];
    [pendingView addSubview:self.userPhotoImage];
    [self.userPhotoImage autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:pendingView withOffset:10];
    [self.userPhotoImage autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:pendingView withOffset:12];
    [self.userPhotoImage autoSetDimensionsToSize:CGSizeMake(36, 36)];
    self.userPhotoImage.contentMode = UIViewContentModeScaleToFill;
    self.userPhotoImage.layer.masksToBounds = YES;
    self.userPhotoImage.layer.cornerRadius = 18;
    
    //    用户名字
    self.nameLab = [[UILabel alloc]initForAutoLayout];
    [pendingView addSubview:self.nameLab];
    self.nameLab.textColor = DEF_RGB_COLOR(111, 111, 111);
    self.nameLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [self.nameLab autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.userPhotoImage withOffset:5];
    [self.nameLab autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.userPhotoImage withOffset:12];
    [self.nameLab autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.userPhotoImage withOffset:-5];
    [self.nameLab autoSetDimension:ALDimensionWidth toSize:48];
    
    //    订单时间
    self.timeLab = [[UILabel alloc]initForAutoLayout];
    [pendingView addSubview:self.timeLab];
    self.timeLab.textAlignment = 2;
    self.timeLab.textColor = DEF_RGB_COLOR(159, 159, 159);
    self.timeLab.font = DEF_Font(12.0);
    [self.timeLab autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.nameLab];
    [self.timeLab autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:pendingView withOffset:-12];
    [self.timeLab autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.nameLab];
    [self.timeLab autoSetDimension:ALDimensionWidth toSize:100];
    
    
    //    订单内容
    self.contentLale = [[UILabel alloc]initForAutoLayout];
    [pendingView addSubview:self.contentLale];
    self.contentLale.textColor= DEF_RGB_COLOR(51, 51, 51);
    [self.contentLale autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.userPhotoImage];
    [self.contentLale autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userPhotoImage withOffset:8];
    [self.contentLale autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:pendingView withOffset:-12];
    if (DEF_SCREEN_WIDTH == 320.0)
    {
        self.contentLale.font = DEF_Font(12.5);
        [self.contentLale autoPinEdge:ALEdgeRight toEdge:
         ALEdgeRight ofView:pendingView withOffset:-80];
    }
    else{
        self.contentLale.font = DEF_Font(16.0);
        [self.contentLale autoPinEdge:ALEdgeRight toEdge:
         ALEdgeRight ofView:pendingView withOffset:-100];
    }
//    self.contentLale.backgroundColor = [UIColor redColor];
    
    //   订单状态
    self.pendingStatusLab = [[UILabel alloc]initForAutoLayout];
    [pendingView addSubview:self.pendingStatusLab];
    self.pendingStatusLab.textColor= DEF_RGB_COLOR(60, 153, 230);
    [self.pendingStatusLab autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentLale];
    [self.pendingStatusLab autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentLale];
    [self.pendingStatusLab autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:pendingView withOffset:-12];
    if (DEF_SCREEN_WIDTH == 320.0)
    {
        self.pendingStatusLab.font = DEF_Font(12.5);
        [self.pendingStatusLab autoSetDimension:ALDimensionWidth toSize:68];
    }
    else{
        self.pendingStatusLab.font = DEF_Font(16.0);
        [self.pendingStatusLab autoSetDimension:ALDimensionWidth toSize:88];
    }
    self.pendingStatusLab.textAlignment = 2;
    
}

-(void)loaPendingCellWithDict:(NSDictionary *)dict
{
    
    /*
     "coupon_amount" = 0;
     "coupon_id" = 0;
     "created_at" = "08-27 10:42";
     "lawyer_id" = 13;
     "lawyer_mobile" = 15136123242;
     "meet_date" = "2015-9-20 14:00 - 16";
     "meet_date_is_mod" = 0;
     "meet_price" = 200;
     "order_avatar" = "http://121.41.72.233/group1/M00/00/28/Cqj2ylXNjJ2AaC91AAbgNCgh9fg567.png";
     "order_description" = "\U4e0e\U60a8\U9884\U7ea6\U4e862015\U5e7408\U670827\U65e517\U70b9\U7684\U4f1a\U9762";
     "order_name" = "\U5c0f\U4e0d\U61c2";
     "pay_amount" = 0;
     "pay_type" = "\U652f\U4ed8\U5b9d\U652f\U4ed8";
     state = 1;
     "state_tip" = "\U5df2\U652f\U4ed8";
     "user_id" = 1;
     "user_mobile" = 18516111573;
     */
    
    [self.userPhotoImage sd_setImageWithURL:[NSURL URLWithString:@"order_avatar"] placeholderImage:[UIImage imageNamed:@"admin"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    self.nameLab.text = dict[@"order_name"];
    self.timeLab.text = dict[@"created_at"];
    self.contentLale.text = dict[@"order_description"];
    self.pendingStatusLab.text = dict[@"state_tip"];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
