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
#import "SearchListViewController.h"
#import "CategoryDeatilViewController.h"
#import "UIImageView+WebCache.h"
#import "BannerDetailViewController.h"
#import "PageView.h"
@interface IndustryTagViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,PageViewDelegate>
{
    UIView *_reloadView;
}
@property(nonatomic,strong)NSMutableArray *categoryArray;
@property(nonatomic,strong)NSMutableArray *bannerDataArray;

@end

static NSString * CellIdentifier = @"UICollectionViewCell";

@implementation IndustryTagViewController

#pragma mark -- view lifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setNavUI];

    [self initData];
}

#pragma mark -- 初始化
-(void)initData
{
    self.bannerDataArray = [[NSMutableArray alloc]init];
    self.categoryArray = [[NSMutableArray alloc]init];
    [MHAsiNetworkAPI getCategoryIdSuccessBlock:^(id returnData)
     {
         DEF_DEBUG(@"分类模块接口返回数据%@",returnData);
         NSString *ret = returnData[@"ret"];
         NSString *msg = returnData[@"msg"];
         [_reloadView removeFromSuperview];
         //给界面赋值
         if ([ret isEqualToString:@"0"])
         {
             [self initUI];
             NSArray *dataArray = returnData[@"data"];
             if ([dataArray count ]> 0)
             {
                 [self.categoryArray removeAllObjects];
                 for (NSDictionary *categoryDic in dataArray)
                 {
                     [self.categoryArray addObject:categoryDic];
                 }
             }
         }
         else
         {
             SHOW_ALERT(msg);
         }
     } failureBlock:^(NSError *error) {
         [self createReloadView];
     } showHUD:YES];
}
-(void)setNavUI
{
    [self showNavBarWithTwoBtnHUDByNavTitle:@"专业分类" leftImage:@"top_menu_back" leftTitle:@"" rightImage:@"" rightTitle:@"" inView:self.view isBack:NO];
}
// 界面
-(void)initUI
{
    //    创建collecView
    [self creatCollectionView];
}
#pragma mark -- 点击事件处理
#pragma mark -- banner图的点击响应事件
-(void)didSelectPageViewWithNumber:(NSInteger)selectNumber
{
    NSDictionary *dict = self.bannerDataArray[selectNumber];
    BannerDetailViewController *vc =[[BannerDetailViewController alloc]init];
    vc.bannerNameStr = dict[@"title"];
    vc.bannerURL = dict[@"url"];
    [MobClick event:@"Type_AD" attributes:@{@"adURL":dict[@"url"]}];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)creatCollectionView
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, (436.0/3.0));

    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, DEF_SCREEN_WIDTH,DEF_SCREEN_HEIGHT-(64+50)) collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[IndustryTagCell class] forCellWithReuseIdentifier:CellIdentifier
     ];
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[CustomHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"releasesGroup"];
}
- (void)createReloadView
{
    if (_reloadView)
    {
        return;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - 64)];
    [self.view addSubview:view];
    _reloadView = view;
    
    UIImageView *signalView = [[UIImageView alloc] initForAutoLayout];
    [view addSubview:signalView];
    [signalView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:view withOffset:700/2200.0*DEF_SCREEN_HEIGHT];
    [signalView autoAlignAxis:ALAxisVertical toSameAxisOfView:view];
    [signalView autoSetDimensionsToSize:CGSizeMake(100, 100)];
    signalView.image = [UIImage imageNamed:@"signal"];
    
    UILabel *titleLabel = [[UILabel alloc] initForAutoLayout];
    [view addSubview:titleLabel];
    [titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:signalView withOffset:10];
    [titleLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:view];
    [titleLabel autoSetDimensionsToSize:CGSizeMake(DEF_SCREEN_WIDTH - 50, 35)];
    titleLabel.textAlignment = 1;
    titleLabel.textColor = [UIColor colorWithRed:0.21 green:0.24 blue:0.25 alpha:1];
    titleLabel.text = @"亲，您的手机网络不太顺畅喔~";
    
    UIButton *reloadButton = [[UIButton alloc] initForAutoLayout];
    [view addSubview:reloadButton];
    [reloadButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleLabel withOffset:10];
    [reloadButton autoAlignAxis:ALAxisVertical toSameAxisOfView:view];
    [reloadButton autoSetDimensionsToSize:CGSizeMake(111, 35)];
    [reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
    [reloadButton setTitleColor:[UIColor colorWithRed:0.4 green:0.43 blue:0.46 alpha:1] forState:UIControlStateNormal];
    [reloadButton addTarget:self action:@selector(initData) forControlEvents:UIControlEventTouchUpInside];
    reloadButton.layer.cornerRadius = 5;
    reloadButton.layer.borderWidth = 0.5;
    reloadButton.layer.borderColor = [UIColor colorWithRed:0.4 green:0.43 blue:0.46 alpha:1].CGColor;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <=0)
    {
        CGPoint point = CGPointMake(0, 0);
        scrollView.contentOffset = point;
        return;
    }
}
#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.categoryArray.count == 0? 0: self.categoryArray.count + 3;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IndustryTagCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell sizeToFit];
    cell.backgroundColor = [UIColor whiteColor];
    cell.imagePic.image = nil;
    cell.nameLable.text = @"";
    if (indexPath.row < self.categoryArray.count)
    {
        NSDictionary *dict = self.categoryArray[indexPath.row];
        cell.nameLable.text = dict[@"name"];
        [cell.imagePic sd_setImageWithURL:dict[@"icon"]];
    }
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(DEF_SCREEN_WIDTH/4.0, DEF_SCREEN_WIDTH/4.0);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.categoryArray.count)
    {
        NSDictionary *sectionDataDict = self.categoryArray[indexPath.row];
        CategoryDeatilViewController *vc = [[CategoryDeatilViewController alloc]init];
        vc.categoryID = sectionDataDict[@"id"];
        [MobClick event:@"LawType_Choice" attributes:@{@"category_ID":sectionDataDict[@"id"]}];
        vc.title = sectionDataDict[@"name"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
    releaseGroup.pageView.delegate = self;
    releaseGroup.bannerBlock = ^(NSMutableArray *array){
        [self.bannerDataArray addObjectsFromArray:array];
    };
    return releaseGroup;
}
#pragma mark -- 按钮点击事件
-(void)rightNavItemClick
{
    SearchListViewController *searchList = [[SearchListViewController alloc]init];
    [self.navigationController pushViewController:searchList animated:YES];
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
