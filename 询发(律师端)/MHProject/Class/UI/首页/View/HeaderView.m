//
//  HeaderView.m
//  MHProject
//
//  Created by 杜宾 on 15/6/17.
//  Copyright (c) 2015年 杜宾. All rights reserved.
//

#import "HeaderView.h"
#import "HZUtil.h"
#import "UIImageView+WebCache.h"
#import "HZShowImageView.h"
@interface ImageViewTapGestureRecognizer : UITapGestureRecognizer
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ImageViewTapGestureRecognizer
@end

@implementation HeaderView

- (id)initWithFrame:(CGRect)frame withDictionary:(NSDictionary *)data isContainImage:(BOOL)isContainImage
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _data = data;
        UIView *topView = [[UIView alloc] initForAutoLayout];
        topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:topView];
        [topView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:0];
        [topView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:0];
        [topView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:0];
        [topView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:0];
        //
        //姓名
        UILabel *questionNameLable = [[UILabel alloc]initForAutoLayout];
        [topView addSubview:questionNameLable];
        questionNameLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.5];
        [questionNameLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:topView withOffset:10];
        [questionNameLable autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:topView withOffset:10];
        questionNameLable.text = data[@"name"];
        questionNameLable.textColor = [UIColor colorWithRed:0.44 green:0.44 blue:0.44 alpha:1];
        
        
        UILabel *timeLable = [[UILabel alloc]initForAutoLayout];
        [topView addSubview:timeLable];
        timeLable.font = [UIFont systemFontOfSize:12];
        timeLable.textColor = [UIColor colorWithRed:0.44 green:0.44 blue:0.44 alpha:1];
        timeLable.textAlignment = 2;
        [timeLable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:topView withOffset:-12];
        [timeLable autoAlignAxis:ALAxisHorizontal toSameAxisOfView:questionNameLable];
        [timeLable autoSetDimensionsToSize:CGSizeMake(100, 20)];
        timeLable.text = data[@"created_at"];
        
        [questionNameLable autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:timeLable withOffset:-12];
        [questionNameLable autoSetDimension:ALDimensionHeight toSize:24];
        //问题详情描述
        float height = [HZUtil getHeightWithString:data[@"content"] fontSize:16 width:DEF_SCREEN_WIDTH-20];
        UILabel *questionLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 34, DEF_SCREEN_WIDTH-20, height+5)];
        [topView addSubview:questionLable];
        questionLable.font = [UIFont systemFontOfSize:16];
        questionLable.text = data[@"content"];
        questionLable.numberOfLines = 0;
        questionLable.textColor = DEF_RGB_COLOR(51, 51, 51);
        self.questionLable = questionLable;
        
        //显示图片
        NSArray *imageArr = data[@"image"];
        if ([imageArr count] > 0)
        {
            UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(questionLable)+10, DEF_SCREEN_WIDTH, 100)];
            scrollView.showsHorizontalScrollIndicator = NO;
            [topView addSubview:scrollView];
            
            for (int i = 0; i < [imageArr count]; i ++)
            {
                float hSpace = 5.0;
                float imageWidth = 100.0;
                float imageHeight = 100.0;
                
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(hSpace + i*(imageWidth + hSpace), 0, imageWidth, imageHeight)];
                imageView.tag = i;
                imageView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
                imageView.clipsToBounds = YES;
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                
                imageView.userInteractionEnabled = YES;
                [scrollView addSubview:imageView];
                [imageView sd_setImageWithURL:[NSURL URLWithString:imageArr[i]]];
                scrollView.contentSize = CGSizeMake((imageWidth + hSpace)* [imageArr count], 0);
                
                //为imageView添加点击手势
                ImageViewTapGestureRecognizer *tap = [[ImageViewTapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
                tap.numberOfTapsRequired = 1;
                tap.imageView = imageView;
                [imageView addGestureRecognizer:tap];
            }
        }
        float y;
        //        有图片
        if (isContainImage)
        {
            y = DEF_BOTTOM(questionLable)+120; //图片一百 上下间距20
        }
        else
        {
            //            没有图片
            y = DEF_BOTTOM(questionLable)+10;
            
        }
        
        UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, y, DEF_SCREEN_WIDTH - 20, LINE_HEIGHT)];
        [topView addSubview:lineImage];
        lineImage.backgroundColor = DEF_RGB_COLOR(242,241,244);
        
        //问题标签图片
        UIImageView *stag = [[UIImageView alloc]initWithFrame:CGRectMake(DEF_LEFT(_questionLable), DEF_BOTTOM(lineImage) + 9, 20, 16)];
        stag.image = [UIImage imageNamed:@"ic_list_tag"];
        stag.contentMode = UIViewContentModeScaleAspectFit;
        [topView addSubview:stag];
        //
        //问题类型
        UILabel *leftBottomLable = [[UILabel alloc]initWithFrame:CGRectMake(DEF_RIGHT(stag) , DEF_TOP(stag), 55, 16)];
        leftBottomLable.font = DEF_Font(13.5);
        [topView addSubview:leftBottomLable];
        leftBottomLable.textColor = DEF_RGB_COLOR(142, 142, 147);
        leftBottomLable.text = data[@"category_name"];
        [leftBottomLable sizeToFit];
        //
        
        //        //收藏星星
        self.collecBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [topView addSubview:self.collecBtn];
        self.collecBtn.layer.masksToBounds = YES;
        self.collecBtn.layer.cornerRadius = 3;
        self.collecBtn.frame = CGRectMake(DEF_RIGHT(leftBottomLable)+5, DEF_TOP(leftBottomLable), 56, 16);
        [_collecBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [_collecBtn setTitleColor:DEF_RGB_COLOR(142, 142, 147) forState:UIControlStateNormal];
        [_collecBtn setTitleColor:DEF_RGB_COLOR(255,113,53) forState:UIControlStateSelected];
        _collecBtn.titleLabel.font = DEF_Font(13.5);
        _collecBtn.titleLabel.textAlignment = 2;
        _collecBtn.alpha = 0.9;
        UIImage *collectImage = [UIImage imageNamed:@"ic_xx_collect"];
        UIImage *collectImage2 = [UIImage imageNamed:@"ic_xx_collect_o"];
        [self.collecBtn setImage:collectImage forState:UIControlStateNormal];
        [self.collecBtn setImage:collectImage2 forState:UIControlStateSelected];
        NSString *isFavorite = data[@"is_favorite"];//0代表没有收藏，1代表收藏
        if ([isFavorite intValue]==0)
        {
            _collecBtn.selected = NO;
        }
        else
        {
            _collecBtn.selected = YES;
        }
        
        
        //举报按钮
        _reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reportBtn.frame = CGRectMake(DEF_SCREEN_WIDTH-60, DEF_TOP(leftBottomLable), 50, 16);
        
        NSString *is_tipoffStr = data[@"is_tipoff"];
        if ([is_tipoffStr intValue]==1)
        {
            [_reportBtn setTitle:@"已举报" forState:UIControlStateNormal];
            [_reportBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            _reportBtn.enabled = NO;
        }
        else
        {
            [_reportBtn setTitle:@"举报" forState:UIControlStateNormal];
            [_reportBtn setTitleColor:DEF_RGB_COLOR(142, 142, 147) forState:UIControlStateNormal];
        }
        [_reportBtn setShowsTouchWhenHighlighted:YES];
        _reportBtn.titleLabel.font = DEF_Font(13.5);
        //        _reportBtn.backgroundColor = [UIColor redColor];
        [topView addSubview:_reportBtn];
        
        
        
        
        //主意的个数
        _rightBottomLable = [[UILabel alloc]initForAutoLayout];
        [topView addSubview:_rightBottomLable];
        [_rightBottomLable autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_reportBtn];
        [_rightBottomLable autoSetDimension:ALDimensionHeight toSize:16];
        [_rightBottomLable autoSetDimension:ALDimensionWidth toSize:55 relation:NSLayoutRelationGreaterThanOrEqual];
        NSString *ping_num = data[@"ping_num"];
        if (!ping_num)
        {
            ping_num = @"0";
        }
        _rightBottomLable.text = [NSString stringWithFormat:@"%@个主意",ping_num];
        _rightBottomLable.textAlignment = 1;
        _rightBottomLable.textColor = DEF_RGB_COLOR(73, 155, 227);
        _rightBottomLable.font = DEF_Font(13.5);
        [_rightBottomLable sizeToFit];
        //
        
        
        //限定用户只能举报别人的问题
        NSString *uid = data[@"uid"];
        if ([uid isEqualToString:DEF_PERSISTENT_GET_OBJECT(DEF_UserID)])
        {
            _reportBtn.hidden = YES;
            [_rightBottomLable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:topView withOffset:-10];
        }
        else{
            _reportBtn.hidden = NO;
            [_rightBottomLable autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_reportBtn withOffset:-10];
        }
        
        
        //灯泡图标
        _sIdea = [[UIImageView alloc]initForAutoLayout];
        [topView addSubview:_sIdea];
        [_sIdea autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_rightBottomLable withOffset:-0];
        [_sIdea autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_rightBottomLable];
        [_sIdea autoSetDimensionsToSize:CGSizeMake(16, 16)];
        _sIdea.image = [UIImage imageNamed:@"ic_list_idea"];
        _sIdea.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)tap:(ImageViewTapGestureRecognizer *)recognizer
{
    NSInteger index = recognizer.view.tag;
    HZShowImageView *showImageView = [[HZShowImageView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT) withImageArray:self.data[@"image"] clickIndex:index];
    [showImageView show];
}
//
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
