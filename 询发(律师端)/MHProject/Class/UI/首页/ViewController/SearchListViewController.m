//
//  SearchListViewController.m
//  MHProject
//
//  Created by 杜宾 on 15/6/27.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "SearchListViewController.h"
#import "SearchQuestionCell.h"
#import "QuestionListDetailViewController.h"
#import "QuestionListCell.h"
#import "IndustryTagCell.h"
#import "CategoryDeatilViewController.h"
@interface SearchListViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,PullingRefreshTableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSLayoutConstraint *_toolBarTopConstraint;
}
@property(nonatomic,strong) UITextField *searchTF;
@property(nonatomic,strong) NSMutableArray *searchArray;

@property (nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *categoryArray;
@property(nonatomic,strong)NSMutableArray *bannerDataArray;
@end
static NSString * CellIdentifier = @"UICollectionViewCell";
@implementation SearchListViewController

#pragma mark -- http网络请求相关
-(void)requestTableDataWithRefresh:(BOOL)refreshFlag
{
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    if (!uid)
    {
        uid = @"0";//未登录情况下
    }
    NSString *searchStr = self.searchTF.text;
    NSString *str = [searchStr urlCodingToUTF8];
    NSString *pageNum = [NSString stringWithFormat:@"%ld",self.pageNumber];
    
    DEF_DEBUG(@"%@",pageNum);
    
    BOOL isExist = [[CMManager sharedCMManager]isBlankString:self.searchTF.text];
    if (isExist)
    {
        [DataHander showInfoWithTitle:@"亲，请输入要搜索的内容！"];
    }
    else
    {
        [MHAsiNetworkAPI searchQuestionWithContent:str uid:uid page_num:pageNum limit:@"20" SuccessBlock:^(id returnData)
         {
             [self tableViewEndLoading];
             NSString *ret = returnData[@"ret"];
             NSString *msg = returnData[@"msg"];
             if ([ret isEqualToString:@"0"])
             {
                 NSArray *dataArr = returnData[@"data"];
                 if (dataArr.count==0) {
                     SHOW_ALERT(@"亲，找不到您要搜索的相关内容");
                 }
                 if (refreshFlag)
                 {
                     [self.searchArray removeAllObjects];
                     
                     for (NSDictionary *dict in dataArr)
                     {
                         [self.searchArray addObject:dict];
                     }
                 }
                 else
                 {
                     if ([dataArr count]>0)
                     {
                         for (NSDictionary *dict in dataArr)
                         {
                             [self.searchArray addObject:dict];
                         }
                     }
                     else
                     {
                         self.pageNumber --;
                     }
                 }
             }
             else
             {
                 SHOW_ALERT(msg);
             }
             [self.questionListTableView reloadData];
         } failureBlock:^(NSError *error) {
             [self tableViewEndLoading];
         } showHUD:YES];
    }
}

#pragma mark -- view lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    [self initData];
    
    [self initUI];
    
    [self setNavUI];
    
    [self initVoice];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //取消识别
    [_iflyRecognizerView cancel];
    [_iflyRecognizerView setDelegate: nil];
    [self.searchTF endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_iflyRecognizerView setDelegate:self];
}
#pragma mark -- 初始化
-(void)initData
{
    self.searchArray = [[NSMutableArray alloc]init];
    self.bannerDataArray = [[NSMutableArray alloc]init];
    self.categoryArray = [[NSMutableArray alloc]init];
    [MHAsiNetworkAPI getCategoryIdSuccessBlock:^(id returnData)
     {
         DEF_DEBUG(@"分类模块接口返回数据%@",returnData);
         
         NSString *ret = returnData[@"ret"];
         NSString *msg = returnData[@"msg"];
         //给界面赋值
         if ([ret isEqualToString:@"0"])
         {
             [self initUI];
             [self.collectionView reloadData];
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
         //         [self createReloadView];
     } showHUD:YES];
}
-(void)setNavUI
{
    [self showSearchNavBarInView:self.view];
}
- (void)showSearchNavBarInView:(UIView *)view
{
    // 背景
    UIView *navBarView          = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_WIDTH(view), 64)];
    navBarView.backgroundColor  = DEF_RGB_COLOR(250,250, 250);
    [view addSubview:navBarView];
    //
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 60, 44);
    [backBtn setImage:[UIImage imageNamed:@"menu-left-back"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0,15,0,35)];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(leftNavItemClick) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:backBtn];
    
    //
    UIView *titleView = [[UIView alloc]initForAutoLayout];
    [navBarView addSubview:titleView];
    [titleView  autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(28, TRANSFORM_WIDTH(150/3.0), 8, TRANSFORM_WIDTH(40/3.0))];
    titleView.backgroundColor = [UIColor whiteColor];
    titleView.layer.masksToBounds = YES;
    titleView.layer.cornerRadius = 3;
    titleView.layer.borderWidth = LINE_HEIGHT;
    titleView.layer.borderColor = DEF_RGB_COLOR(202, 202, 202).CGColor;
    //
    UIImageView *searchImagePic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [titleView addSubview:searchImagePic];
    searchImagePic.image = [UIImage imageNamed:@"ic_search_top"];
    searchImagePic.contentMode = UIViewContentModeScaleAspectFit;
   
    //
    UIButton *voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleView addSubview:voiceBtn];
    [voiceBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:titleView];
    [voiceBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:titleView];
    [voiceBtn autoSetDimensionsToSize:CGSizeMake(44, 44)];
    [voiceBtn setImage:[UIImage imageNamed:@"ic_phone_top"] forState:UIControlStateNormal];
    voiceBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [voiceBtn addTarget:self action:@selector(voiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //
    self.searchTF = [[UITextField alloc]initForAutoLayout];
    [titleView addSubview:self.searchTF];
    [self.searchTF autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:voiceBtn];
    [self.searchTF autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:searchImagePic];
    [self.searchTF autoAlignAxis:ALAxisHorizontal toSameAxisOfView:titleView];
    [self.searchTF addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.searchTF.placeholder = @"搜索你想要的答案";
    self.searchTF.font = [UIFont systemFontOfSize:14];
    self.searchTF.delegate = self;
    self.searchTF.returnKeyType = UIReturnKeySearch;
    
    UIView *lineView = [[UIView alloc] initForAutoLayout];
    [navBarView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithRed:0.79 green:0.79 blue:0.79 alpha:1];
    [lineView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:navBarView withOffset:0];
    [lineView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:navBarView withOffset:0 ];
    [lineView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:navBarView withOffset:0];
    [lineView autoSetDimension:ALDimensionHeight toSize:LINE_HEIGHT];
}

-(void)initUI
{
    if (!_questionListTableView)
    {
        _questionListTableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 64,DEF_SCREEN_WIDTH , DEF_SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _questionListTableView.delegate = self;
        _questionListTableView.dataSource = self;
        _questionListTableView.pullingDelegate = self;
        _questionListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _questionListTableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_questionListTableView];
    }
    
    UIToolbar *toolBar = [[UIToolbar alloc] initForAutoLayout];
    [self.view addSubview:toolBar];
    _toolBarTopConstraint  = [toolBar autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.view];
    [toolBar autoSetDimensionsToSize:CGSizeMake(DEF_SCREEN_WIDTH, 44)];
    
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:      UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButtonItem.width = DEF_SCREEN_WIDTH - 80;
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(endEdit)];
    [toolBar setItems:@[spaceButtonItem,done]];
    if (!self.collectionView)
    {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //        flowLayout.headerReferenceSize = CGSizeMake(DEF_SCREEN_WIDTH, (436.0/3.0));
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, DEF_SCREEN_WIDTH,DEF_SCREEN_HEIGHT-(64+50)) collectionViewLayout:flowLayout];
        [self.collectionView registerClass:[IndustryTagCell class] forCellWithReuseIdentifier:CellIdentifier
         ];
        self.collectionView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
        //设置代理
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.view addSubview:self.collectionView];
    }
}
- (void)endEdit
{
    [self.searchTF resignFirstResponder];
}
#pragma mark - 监听键盘状态
- (void)keyBoardShow:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    NSValue *endValue = info[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect keyBoardRect = [endValue CGRectValue];
    CGFloat keyBoardHeight = keyBoardRect.size.height;
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        _toolBarTopConstraint.constant = -keyBoardHeight-44;
    } completion:nil];
}
- (void)keyBoardHide:(NSNotification *)notification
{
    _toolBarTopConstraint.constant = 0;
}
#pragma mark - UITableViewDetegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.searchArray count] > 0)
    {
        return self.searchArray.count;
    }
    else
    {
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    SearchQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[SearchQuestionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.searchArray.count != 0)
    {
        self.questionListTableView.scrollEnabled = YES;
    }
    else{
        self.questionListTableView.scrollEnabled = NO;
    }
    NSDictionary *questionDict = [self.searchArray objectAtIndex:indexPath.row];
    [cell loadCellWithDict:questionDict];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *lawerDict = [self.searchArray objectAtIndex:indexPath.row];
    return  [SearchQuestionCell heightForCellWithDict:lawerDict];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *lawerDict = [self.searchArray objectAtIndex:indexPath.row];
    QuestionListDetailViewController *detail = [[QuestionListDetailViewController alloc]init];
    detail.questionID = lawerDict[@"question_id"];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - UICollectionViewDataSource

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

#pragma mark - UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((DEF_SCREEN_WIDTH-0.5)/4.0, (DEF_SCREEN_WIDTH-0.5)/4.0);
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
    return 0.1;
}
#pragma mark - UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.categoryArray.count)
    {
        NSDictionary *sectionDataDict = self.categoryArray[indexPath.row];
        CategoryDeatilViewController *vc = [[CategoryDeatilViewController alloc]init];
        vc.categoryID = sectionDataDict[@"id"];
        [MobClick event:@"Type_Choice" attributes:@{@"category_ID":sectionDataDict[@"id"]}];
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
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.collectionView.hidden = YES;
    _questionListTableView.hidden = NO;
    [self requestTableDataWithRefresh:YES];
    return YES;
}
- (void)textDidChange:(UITextField *)textField
{
    if (textField.text.length == 0)
    {
        _questionListTableView.hidden = YES;
        self.collectionView.hidden = NO;
    }
}
#pragma mark - 科大讯飞相关
-(void)initVoice
{
    //创建语音听写的对象
    self.iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    //delegate需要设置，确保delegate回调可以正常返回
    _iflyRecognizerView.delegate = self;
}

#pragma mark - btnClick
-(void)voiceBtnClick:(UIButton *)btn
{
    [self.searchTF endEditing:YES];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if([session respondsToSelector:@selector(requestRecordPermission:)])
    {
        [session requestRecordPermission:^(BOOL granted) {
            if (granted)
            {
                [_iflyRecognizerView setParameter: @"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
                //设置结果数据格式，可设置为json，xml，plain，默认为json。
                [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
                [_iflyRecognizerView start];
                _iflyRecognizerView.tag = 1000;
                UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
                for (UIView *subview in window.subviews)
                {
//                    NSLog(@"%@",NSStringFromClass([subview class]));
                    if ([subview isKindOfClass:[IFlyRecognizerView class]])
                    {
                        NSArray *subviews = subview.subviews;
                        [subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            if ([obj isKindOfClass:NSClassFromString(@"IFlyRecognizerViewImp")])
                            {
                                UIView *impView = obj;
                                for (UIView *subview3 in impView.subviews)
                                {
                                    if ([subview3 isKindOfClass:[UILabel class]])
                                    {
                                        UILabel *advLabel = (UILabel *)subview3;
                                        if ([advLabel.text containsString:@"核心技术"])
                                        {
                                            advLabel.text = @"";
                                        }
                                    }
                                }
                            }
                        }];
                    }
                }
            }
            else
            {
                SHOW_ALERT(@"需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风");
            }
        }];
    }
}

#pragma mark - IFlySpeechRecognizerDelegate
/** 识别结果回调方法
 @param resultArray 结果列表
 @param isLast YES 表示最后一个，NO表示后面还有结果
 */
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    for (NSString *key in dic)
    {
        [result appendFormat:@"%@",key];
    }
    self.searchTF.text =[NSString stringWithFormat:@"%@%@",self.searchTF.text,result];
    [self requestTableDataWithRefresh:YES];
    [_iflyRecognizerView cancel];
}

/** 识别结束回调方法
 @param error 识别错误
 */
- (void)onError:(IFlySpeechError *)error
{
    [self.view addSubview:_popView];
//    self.suggestionTextView.text = self.voiceString;
    
    [_popView setText:@"识别结束"];
    
//    NSLog(@"errorCode:%d",[error errorCode]);
}

#pragma mark-- 下拉刷新上啦加载
#pragma mark- pullReflreshDelegate
-(void)tableViewEndLoading{
    [self.questionListTableView tableViewDidFinishedLoading];
}
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    self.pageNumber = 0;
    [self requestTableDataWithRefresh:YES];
}
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    self.pageNumber ++;
    [self requestTableDataWithRefresh:NO];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.searchArray.count != 0)
    {
        [self.questionListTableView tableViewDidScroll:scrollView];
    }
    else{
        self.questionListTableView.scrollEnabled = NO;
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.questionListTableView tableViewDidEndDragging:scrollView];
}
- (NSDate *)pullingTableViewRefreshingFinishedDate
{
    return [NSDate date];
}
- (NSDate *)pullingTableViewLoadingFinishedDate
{
    return [NSDate date];
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
