//
//  LawerCommentCell.m
//  MHProject
//
//  Created by 张好志 on 15/6/26.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "LawyerCommentCell.h"
#import "UIButton+WebCache.h"

@implementation LawerCommentCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
       
        UIView *bgView = [[UIView alloc]initForAutoLayout];
        [self addSubview:bgView];
        [bgView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
        [bgView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
        [bgView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
        [bgView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:10];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.borderColor = DEF_RGB_COLOR(228, 228, 228).CGColor;
        bgView.layer.borderWidth = LINE_HEIGHT;
        
        
        //律师头像
        self.userImageBtn = [[UIButton alloc]initForAutoLayout];
        [self addSubview:self.userImageBtn];
        [self.userImageBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgView withOffset:12];
        [self.userImageBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:bgView withOffset:12 ];
        [self.userImageBtn autoSetDimensionsToSize:CGSizeMake(34, 34)];
        self.userImageBtn.layer.masksToBounds = YES;
        self.userImageBtn.layer.cornerRadius = 17;
        self.userImageBtn.clipsToBounds = YES;
        self.userImageBtn.backgroundColor = [UIColor redColor];
        
        //用户名
        self.userNameLB = [[UILabel alloc] initForAutoLayout];
        [bgView addSubview:self.userNameLB];
        self.userNameLB.textColor = DEF_RGB_COLOR(111, 111, 111);
        self.userNameLB.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.5];
        
        [self.userNameLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.userImageBtn withOffset:10 ];
        [self.userNameLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.userImageBtn];
        [self.userNameLB autoSetDimension:ALDimensionWidth toSize:294/3.0 relation:NSLayoutRelationLessThanOrEqual];
        [self.userNameLB autoSetDimension:ALDimensionHeight toSize:30];
        
        
                //        //星星
        self.startView = [[StarsView alloc] initWithStarSize:CGSizeMake(15, 15) space:2.5 numberOfStar:5];
        [bgView addSubview:self.startView];
        if (DEF_SCREEN_WIDTH == 320.0)
        {
            [self.startView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.userImageBtn withOffset:294/3.0];
        }
        else
        {
            [self.startView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.userImageBtn withOffset:294/3.0+10];
        }
        [self.startView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.userImageBtn withOffset:7];
        [self.startView autoSetDimension:ALDimensionHeight toSize:30];
        self.startView.selectable = NO;

        //
        self.timeLB = [[UILabel alloc] initForAutoLayout];
        [bgView addSubview:self.timeLB];
        self.timeLB.text = @"LV 10";
        self.timeLB.font = [UIFont systemFontOfSize:12];
        self.timeLB.textColor = DEF_RGB_COLOR(159, 159, 159);
        self.timeLB.textAlignment = 2;
        [self.timeLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-12];
        [self.timeLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.userImageBtn withOffset:7];
        [self.timeLB autoSetDimensionsToSize:CGSizeMake(100, 20)];
        
        self.commentContentLB = [[UILabel alloc] initForAutoLayout];
        [bgView addSubview:self.commentContentLB];
        self.commentContentLB.textColor = DEF_RGB_COLOR(51, 51, 51);
        self.commentContentLB.font = DEF_Font(16);
        self.commentContentLB.numberOfLines = 0;
        [self.commentContentLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgView withOffset:12];
        [self.commentContentLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bgView withOffset:-12];
        [self.commentContentLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userImageBtn withOffset:10];
        [self.commentContentLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:bgView withOffset:-12];
    }
    return self;
}

-(void)loadCellWithDict:(NSMutableDictionary *)dict
{
    [self.userImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:dict[@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"admin"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            DEF_DEBUG(@"有图片");
        }
    }];
    self.userNameLB.text =  dict[@"name"];
    self.startView.score =  [dict[@"ping_score"] integerValue];
    self.timeLB.text = dict[@"created_at"];
    
    if (![NSString isBlankString:dict[@"ping_content"]])
    {
        self.commentContentLB.text = [NSString stringWithFormat:@"%@",dict[@"ping_content"]];
    }
    else{
        self.commentContentLB.text = @"未填写评价内容";
    }
    
}
+(float)heightForCellWithDict:(NSDictionary *)dict
{
    //主意：上方头像50 下方擅长分类10
    
    NSString *detailStr = dict[@"ping_content"];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGSize ziTiSize = [detailStr boundingRectWithSize:CGSizeMake(DEF_SCREEN_WIDTH-24, 3000)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    float height =ziTiSize.height+83;
    return height;
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
