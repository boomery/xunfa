//
//  TabBarView.m
//  PerfectProject
//
//  Created by ZhangHaoZhi on 14/12/12.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#import "TabBarView.h"
#import "MessageManager.h"
// App下导航栏页数
#define DEF_TAB_ITEM_COUNT 4

@implementation TabBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        

        // 设置图片颜色
//        self.backgroundColor    = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tab_bg"]];
        self.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
        
        // tabBar上每个item的宽度
        float itemWidth = DEF_SCREEN_WIDTH/DEF_TAB_ITEM_COUNT;
        
        //
        NSArray *btnNameArray = [NSArray arrayWithObjects:@"抢答",@"广场",@"消息",@"我的", nil];
//        NSArray *btnDefaultImageNameArray = [NSArray arrayWithObjects:@"btn-home", @"btn-classify",@"btn-question",@"btn-admin", nil];
        NSArray *btnDefaultImageNameArray = [NSArray arrayWithObjects:@"botm_rob_home", @"btn-question",@"botm_btn_mesg",@"btn-admin", nil];

        NSArray *btnSelectedImageNameArray = [NSArray arrayWithObjects:@"botm_btn_rob_on", @"btn-question-on",@"botm_btn_mesg_on",@"btn-admin-on", nil];

        
        // 创建每个item
        for (int i=0; i<DEF_TAB_ITEM_COUNT; i++)
        {
            UIButton *itemButton       = [UIButton buttonWithType:UIButtonTypeCustom];
            itemButton.frame           = CGRectMake(i*itemWidth ,0, itemWidth, DEF_HEIGHT(self));
            itemButton.adjustsImageWhenHighlighted  = NO;
            itemButton.tag                          = i;
            itemButton.backgroundColor = [UIColor clearColor];
            //
            [itemButton setImage:[UIImage imageNamed:btnDefaultImageNameArray[i]] forState:UIControlStateNormal];
            [itemButton setImage:[UIImage imageNamed:btnSelectedImageNameArray[i]] forState:UIControlStateSelected];
            //
            [itemButton setTitle:btnNameArray[i] forState:UIControlStateNormal];
            [itemButton setTitle:btnNameArray[i] forState:UIControlStateSelected];

            //
            [itemButton.titleLabel setTextAlignment:DEF_TextAlignmentCenter];
            [itemButton.titleLabel setFont:[UIFont systemFontOfSize:11.5]];
            
            //
            [itemButton setTitleColor:DEF_RGB_COLOR(111, 111, 111) forState:UIControlStateNormal];
            [itemButton setTitleColor:DEF_RGB_COLOR(60, 153, 230) forState:UIControlStateSelected];
            [itemButton setImageEdgeInsets:UIEdgeInsetsMake(5,
                                                         (itemWidth-30)/2,
                                                         (DEF_HEIGHT(self)-20)/2+5,
                                                         (itemWidth-30)/2
                                                         )];
            if (DEF_SCREEN_WIDTH==320)
            {
                [itemButton setTitleEdgeInsets:UIEdgeInsetsMake((itemWidth-20)/2 ,
                                                             (itemWidth+16)/2 - itemWidth+2,
                                                             5,
                                                             0
                                                             )];
            }
            else if (DEF_SCREEN_IS_6)
            {
                [itemButton setTitleEdgeInsets:UIEdgeInsetsMake((itemWidth-20)/2-7 ,
                                                                (itemWidth+30)/2 - itemWidth+2,
                                                                5,
                                                                0
                                                                )];
 
            }
            else
            {
                [itemButton setTitleEdgeInsets:UIEdgeInsetsMake((itemWidth-20)/2-10 ,
                                                             (itemWidth+40)/2 - itemWidth+2,
                                                             5,
                                                             0
                                                             )];
            }
            //抢答
            if (i == 0)
            {
                UIView *redDot = [[UIView alloc] init];
                redDot.frame = CGRectMake(itemButton.imageView.right, itemButton.imageView.top, 8, 8);
                redDot.backgroundColor = [UIColor redColor];
                redDot.layer.cornerRadius = 4;
                redDot.clipsToBounds = YES;
                [itemButton addSubview:redDot];
                redDot.hidden = YES;
                self.raceRedDot = redDot;
            }
            //我的
            else if (i == 2)
            {
                UIView *redDot = [[UIView alloc] init];
                redDot.frame = CGRectMake(itemButton.imageView.right, itemButton.imageView.top, 8, 8);
                redDot.backgroundColor = [UIColor redColor];
                redDot.layer.cornerRadius = 4;
                redDot.clipsToBounds = YES;
                [itemButton addSubview:redDot];
                redDot.hidden = [MessageManager shouldHideRedDot];
                self.messageRedDot = redDot;
            }
            [itemButton addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            itemButton.selected = NO;
            [self addSubview:itemButton];
//            
            if (i == 0)
            {
                // 默认选中第一个
                itemButton.selected = YES;
            }
            
        }
    }
    return self;
}

- (void)itemClick:(UIButton *)item
{
    for (UIButton *button in self.subviews)
    {
        // 取消所有按钮的选中状态
        button.selected = NO;
    }
    
    // 设置当前点击的按钮为选中状态
    item.selected = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarView:didSelectAtIndex:)]) {
        [self.delegate tabBarView:self didSelectAtIndex:item.tag];
    }
}
- (void)selectTabWithIndex:(NSInteger)index
{
    [self itemClick:self.buttonArray[index]];
}

- (void)resetSelectButtonWithIndex:(NSInteger)index
{
    UIButton *item = self.buttonArray[index];
    if (item != self.lastBtn)
    {
        self.lastBtn.selected = NO;
        self.lastBtn = item;
        self.lastBtn.selected = YES;
    }
}

@end
