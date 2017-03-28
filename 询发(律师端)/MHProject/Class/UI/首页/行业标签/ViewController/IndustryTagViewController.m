//
//  IndustryTagViewController.m
//  MHProject
//
//  Created by 杜宾 on 15/6/27.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "IndustryTagViewController.h"
#import "IndustryTagCell.h"
#import "CustomHeaderReusableView.h"

@interface IndustryTagViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

static NSString * CellIdentifier = @"UICollectionViewCell";

@implementation IndustryTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initData];
    
    [self setNavUI];
    
    [self initUI];

}
// 数据
-(void)initData
{
    
  
}
// 导航
-(void)setNavUI
{
    [self addNavBarTitle:@"行业分类标签"];
    
    [self addLeftNavBarBtnByImg:@"list" andWithText:@""];
    [self addRightNavBarBtnByImg:@"search" andWithText:@""];

    
}
// 界面
-(void)initUI
{
//    创建collecView
    [self creatCollectionView];
    
    
}

-(void)creatCollectionView
{
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, 50);

    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH,DEF_SCREEN_HEIGHT - 64) collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[IndustryTagCell class] forCellWithReuseIdentifier:CellIdentifier
     ];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[CustomHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"releasesGroup"];

}
#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (section == 0)
    {
        return 3;
        
    }
    else if (section == 1)
    {
        return 5;
    }
    return 0;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IndustryTagCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell sizeToFit];
//    cell.backgroundColor = [UIColor orangeColor];
    
    NSArray *fisterSectionArr = @[@"classify-1.png",@"classify-2.png",@"classify-3.png"];
    NSArray *fistSectionLabArr = @[@"婚姻继承",@"交通事故",@"消费维权"];
    
    
    NSArray *secondSectionArr = @[@"classify-4.png",@"classify-5.png",@"classify-6.png",@"classify-7.png",@"classify-8.png"];
     NSArray *secondSectionLabArr = @[@"劳动争议",@"形式诉讼",@"知识产权",@"侵权纠纷",@"其他"];
    
    if (indexPath.section == 0)
    {
        cell.imagePic.image = [UIImage imageNamed:fisterSectionArr[indexPath.row]];
        cell.nameLable.text = fistSectionLabArr[indexPath.row];
    }
    else if(indexPath.section == 1)
    {
        cell.imagePic.image = [UIImage imageNamed:secondSectionArr[indexPath.row]];
        cell.nameLable.text = secondSectionLabArr[indexPath.row];
    }
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
    
    
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"您选择了第%ld分区的第%ld个元素",indexPath.section,indexPath.row);
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// cell点击变色
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (CustomHeaderReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    
    CustomHeaderReusableView* releaseGroup = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"releasesGroup" forIndexPath:indexPath];
    
    if (indexPath.section == 0)
    {
        releaseGroup.tagLable.text = @"热门问题标签";
        releaseGroup.lineImage.hidden = YES;
    }
    else if(indexPath.section == 1)
    {
        releaseGroup.tagLable.text = @"稀缺问题标签";
    }
    
    return releaseGroup;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
