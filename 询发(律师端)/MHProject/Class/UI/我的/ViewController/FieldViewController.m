//
//  FieldViewController.m
//  MHProject
//
//  Created by ZhangChaoxin on 15/7/14.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "FieldViewController.h"
#import "FieldCell.h"
@interface FieldViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *allFiledsDictArray;
@end

@implementation FieldViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initData];
    self.allFieldsArray = [[NSMutableArray alloc] init];
    self.allFiledsDictArray = [[NSMutableArray alloc] init];
    [self creatCollectionView];
    
    [self showNavBarWithTwoBtnHUDByNavTitle:@"擅长领域" leftImage:@"menu-left-back" leftTitle:@"" rightImage:@"" rightTitle:@"保存" inView:self.view isBack:YES];
}
- (void)initData
{
    [MHAsiNetworkAPI getCategoryIdSuccessBlock:^(id returnData)
     {
         DEF_DEBUG(@"分类模块接口返回数据%@",returnData);
         
         NSString *ret = returnData[@"ret"];
         NSString *msg = returnData[@"msg"];
         //给界面赋值
         if ([ret isEqualToString:@"0"])
         {
             NSArray *dataArray = returnData[@"data"];
             for (NSDictionary *dict in dataArray)
             {
                [self.allFieldsArray addObject:dict[@"name"]];
                [self.allFiledsDictArray addObject:dict];
             }
             [self.collectionView reloadData];
         }
         else
         {
             SHOW_ALERT(msg);
         }
         [self.collectionView reloadData];
         
     } failureBlock:^(NSError *error) {
     } showHUD:NO];
}
static NSString *CellIdentifier = @"cell";
-(void)creatCollectionView
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, DEF_SCREEN_WIDTH,DEF_SCREEN_HEIGHT - 64) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    [self.collectionView registerClass:[FieldCell class] forCellWithReuseIdentifier:CellIdentifier
     ];
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}

#pragma mark - 保存选择的领域
- (void)rightNavItemClick
{
    NSMutableArray *selectDictArray = [[NSMutableArray alloc] init];;
    for (NSDictionary *subDict in self.allFiledsDictArray)
    {
        NSString *filed = subDict[@"name"];
        if ([self containFiled:filed])
        {
            [selectDictArray addObject:subDict];
        }
    }
    self.saveBlock(selectDictArray);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- UICollectionViewDataSource
//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.allFieldsArray count];
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FieldCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.titleButton.titleLabel.font = FONT;
    NSString *field = self.allFieldsArray[indexPath.row];
    [cell.titleButton setTitle:field forState:UIControlStateNormal];
    cell.isSelected = [self containFiled:field];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(TRANSFORM_WIDTH(60.0), TRANSFORM_HEIGHT(30.0));
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat interval = (DEF_SCREEN_WIDTH - 4*TRANSFORM_WIDTH(60.0))/5;
    return UIEdgeInsetsMake(TRANSFORM_HEIGHT(87/3.0), interval, TRANSFORM_HEIGHT(87/3.0), interval);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return TRANSFORM_HEIGHT(67/3.0);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FieldCell *cell = (FieldCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *filed = self.allFieldsArray[indexPath.row];
    if (![self containFiled:filed])
    {
        if (!cell.isSelected)
        {
            if (self.selectedFieldsArray.count >= 3)
            {
                [DataHander showInfoWithTitle:@"最多可以选择三个领域"];
            }
            else
            {
                [self.selectedFieldsArray addObject:filed];
            }
        }
    }
   else
   {
       [self.selectedFieldsArray removeObject:filed];
   }
    cell.isSelected = [self containFiled:filed];
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


- (BOOL)containFiled:(NSString *)filed
{
    return [self.selectedFieldsArray containsObject:filed];
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
