//
//  WMPhotoPickerController.m
//  MHProject
//
//  Created by Andy on 15/6/6.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "WMPhotoPickerController.h"
#import "WMPhotoCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define CELL_NAME @"Cell"

@interface WMPhotoPickerController ()

@end

@implementation WMPhotoPickerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavBarTitle:@"选择图片"];
    [self addLeftNavBarBtnByImg:@"back" andWithText:@""];
    
    [self uiHUD];
    
}
- (void)uiHUD
{
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - 64 - 40) collectionViewLayout:flow];
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    self.myCollectionView.showsVerticalScrollIndicator = NO;
   // self.myCollectionView.delegate = self;
   // self.myCollectionView.dataSource = self;
    
    //注册
    [self.myCollectionView registerClass:[WMPhotoCollectionViewCell class] forCellWithReuseIdentifier:CELL_NAME];
    [self.view addSubview:self.myCollectionView];
    
    UIView *LineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.myCollectionView.bottom, DEF_SCREEN_WIDTH, 40)];
    LineView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self.view addSubview:LineView];
    
    self.OKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.OKBtn.frame = CGRectMake(LineView.width - 70, 5, 50, 30);
    self.OKBtn.enabled = NO;
    [self.OKBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.OKBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.OKBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.OKBtn setBackgroundColor:DEF_RGB_COLOR(61, 189, 244)];
    self.OKBtn.layer.cornerRadius = 5;
    [self.OKBtn addTarget:self action:@selector(okBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [LineView addSubview:self.OKBtn];
    
    self.countLab = [UIButton buttonWithType:UIButtonTypeCustom];
    self.countLab.frame = CGRectMake(self.OKBtn.left - 40, self.OKBtn.top, 30, 30);
    self.countLab.backgroundColor = DEF_RGB_COLOR(61, 189, 244);
    //self.countLab.hidden = YES;
    [self.countLab setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //self.countLab.textAlignment = DEF_TextAlignmentCenter;
    self.countLab.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.countLab.layer.cornerRadius = 15;
    [LineView addSubview:self.countLab];
    
    ALAssetsLibrary *_assetsLibrary = [[ALAssetsLibrary alloc] init];
    self.photoImages = [[NSMutableArray alloc] init];
    
    ///ALAssetsGroupLibrary
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos|ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result)
            {
                UIImage *img = [UIImage imageWithCGImage:result.thumbnail];
                if(img)
                {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:img forKey:@"img"];
                    [dic setObject:@"0" forKey:@"flag"];
                    [self.photoImages addObject:dic];
                }
                if(index + 1 == group.numberOfAssets)
                {
                    ///最后一个刷新界面
                    [self finish];
                }
            }
        }];
    } failureBlock:^(NSError *error) {
        // error
        NSLog(@"error ==> %@",error.localizedDescription);
    }];

}
- (void)finish
{
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
}
#pragma mark UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photoImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    WMPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_NAME forIndexPath:indexPath];
    cell.selectImageView.tag = indexPath.row;
    if (indexPath.row < [self.photoImages count])
    {
        id dic = [self.photoImages objectAtIndex:indexPath.row];
        [cell sendValue:dic];
    }
    return cell;
}
#pragma mark - UICollectionViewDelegateFlowLayout
// 设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWH = DEF_SCREEN_WIDTH / 4 - 16;
    return CGSizeMake(itemWH, itemWH);
}
// 设置每个图片的Margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMPhotoCollectionViewCell *cell = (WMPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    id dic = [self.photoImages objectAtIndex:indexPath.row];
    BOOL flag = [[dic objectForKey:@"flag"] boolValue];
    if (!flag)
    {
        [dic setObject:@"1" forKey:@"flag"];
    }
    else
    {
        [dic setObject:@"0" forKey:@"flag"];
    }
    [cell setSelectFlag:!flag];
    
    NSInteger selectCount = [self getSelectImageCount];
//    if (selectCount > 0)
//    {
        self.OKBtn.enabled = YES;
        self.OKBtn.backgroundColor =DEF_RGB_COLOR(61, 189, 244);
        self.countLab.hidden = NO;
        [self.countLab setTitle:[NSString stringWithFormat:@"%ld", (long)selectCount] forState:UIControlStateNormal] ;

//    }
//    else
//    {
//        self.OKBtn.backgroundColor = [UIColor clearColor];
//        self.countLab.hidden = YES;
//    }
}
/**
 *  获取列表中有多少Image被选中
 *
 *  @return 选中个数
 */
- (NSInteger)getSelectImageCount
{
    NSInteger count = 0;
    for (NSInteger i = 0; i < [self.photoImages count]; i++)
    {
        id dic = [self.photoImages objectAtIndex:i];
        BOOL flag = [[dic objectForKey:@"flag"] boolValue];
        if (flag)
        {
            count++;
        }
    }

    return count;
}
- (void)okBtnAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(getPhoto:)])
    {
        NSMutableArray *imageArr = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dic in self.photoImages)
        {
            if ([[dic objectForKey:@"flag"] boolValue])
            {
                [imageArr addObject:[dic objectForKey:@"img"]];
            }
        }
        [self.delegate getPhoto:imageArr];
        if (imageArr.count > 5)
        {
            [DataHander showInfoWithTitle:@"您最多只能选择五张图片"];
//            SHOW_ALERT");
//            XYShowAlert(@"您最多只能选择四张图片", @"我知道了");
            return;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
