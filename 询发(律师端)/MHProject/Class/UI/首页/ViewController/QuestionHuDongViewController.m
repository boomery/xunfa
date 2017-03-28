//
//  QuestionHuDongViewController.m
//  MHProject
//
//  Created by 张好志 on 15/6/26.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "QuestionHuDongViewController.h"
#import "QuestionHeadView.h"
#import "HZKeyBoardView.h"
#import "QuestionModel.h"
#import "HZUtil.h"
#import "MHKeyboard.h"
#import "QuestionInteractionCell.h"
#import "UserCenterViewController.h"
#import "MyInfoViewController.h"
//#import "UIImageView+AFNetworking.h"
#import "MessageBubbleCell.h"
#import "UIImageView+WebCache.h"

@interface QuestionHuDongViewController ()<UITableViewDelegate, UITableViewDataSource,UITextViewDelegate, HPGrowingTextViewDelegate, IFlyRecognizerViewDelegate>
{
    NSLayoutConstraint *_keyBoardViewBottomConstraint;
    NSLayoutConstraint *_keyBoardViewHeightConstraint;
    NSLayoutConstraint *_tableViewBottomConstraint;
    UIImageView *headImagepic;
    //用于在语音和文字切换时，暂时保存文字状态下的高度
    CGFloat _keyBoardViewHeight;
    NSTimer *_timer;
}

@property (nonatomic,strong)UITableView       *questionInteractTableView;
@property (nonatomic,strong)NSMutableArray    *raiseIdeaArray;
@property (nonatomic,strong)QuestionHeadView  *headerView;
@property (nonatomic,strong)HZKeyBoardView    *keyBoardView;
@property (nonatomic,strong)NSMutableArray    *allDataArr;
@end

@implementation QuestionHuDongViewController
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //取消识别
    [_iflyRecognizerView cancel];
    [_iflyRecognizerView setDelegate: nil];
    [_timer invalidate];
    _timer = nil;
    AppDelegate *delegate = [AppDelegate appDelegate];
    delegate.chattingTarget = nil;

}

static NSString *cellIdentifier = @"cell";
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    [self initData];
    [self setNavUI];
    [self initVoice];
    if (self.isFromNews)
    {
        AppDelegate *delegate = [AppDelegate appDelegate];
        delegate.chattingQuestion = self.questionID;
        delegate.chattingTarget = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    }
}
-(void)getQuestionDetailRequest
{
    if (!self.questionID)
    {
        [self initUI];
        return;
    }
    //
    NSString *question_idStr = self.questionID;
    __weak QuestionHuDongViewController *weakSelf = self;
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = [NSString stringWithFormat:@"%@/%@",DEF_API_Question_AllDetail,question_idStr];
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    
    [MHAsiNetworkAPI getQuestionAllDetailWithUid:uid timestamp:timeStamp sign:sign Question_id:question_idStr SuccessBlock:^(id returnData) {
        NSString *ret = returnData[@"ret"];
        NSString *msg = returnData[@"msg"];
        if ([ret isEqualToString:@"0"])
        {
            NSDictionary *dataDict =returnData[@"data"];
            NSDictionary *detailDict =dataDict[@"question"];
            weakSelf.questionDetailDict = detailDict;
            [weakSelf initUI];
        }
        else
        {
            SHOW_ALERT(msg);
        }
    } failureBlock:^(NSError *error) {
    } showHUD:YES];
}
-(void)getChatInfoRequest
{
    if (self.messageID)
    {
        [self updateMessageWithID:self.messageID];
    }
    __weak QuestionHuDongViewController *weakSelf = self;
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    [MHAsiNetworkAPI getQuestionPlusAnswer_id:self.answerID uid:uid SuccessBlock:^(id returnData) {
        DEF_DEBUG(@"%@",returnData);
        NSDictionary *dataDict = returnData[@"data"];
        //        NSString * buttonType = dataDict[@"button_type"];
        NSMutableArray *listArr = dataDict[@"list"];
        [weakSelf.allDataArr removeAllObjects];
        for (NSDictionary *dict in listArr)
        {
            [weakSelf.allDataArr addObject:dict];
        }
        [weakSelf.questionInteractTableView reloadData];
        [weakSelf scrollToBottom];
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}
- (void)updateMessageWithID:(NSString *)messageID
{
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = [NSString stringWithFormat:@"%@/%@",DEF_API_updateMessage,messageID];
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    [MHAsiNetworkAPI updateMyMessageWithuid:uid timestamp:timeStamp sign:sign messageID:messageID SuccessBlock:^(id returnData) {
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}
#pragma mark - 滑动到底部
-(void)scrollToBottom
{
    NSInteger numberOfRows = self.allDataArr.count;
    if (! numberOfRows > 0)
    {
        return;
    }
    [self.questionInteractTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.questionInteractTableView numberOfRowsInSection:0]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

#pragma mark - 初始化科大讯飞
-(void)initVoice
{
    //创建语音听写的对象
    self.iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    //delegate需要设置，确保delegate回调可以正常返回
    _iflyRecognizerView.delegate = self;
}

- (void)initData
{
    self.allDataArr = [[NSMutableArray alloc]init];
    if (!self.answerID)
    {
        self.answerID = self.answerDict[@"id"];
    }
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getChatInfoRequest) userInfo:nil repeats:YES];
    [runLoop addTimer:_timer forMode:NSRunLoopCommonModes];
    [_timer fire];
    [self getQuestionDetailRequest];
}

- (void)setNavUI
{
    [self showNavBarDefaultHUDByNavTitle:@"回复TA的问题" inView:self.view isBack:YES];
}

- (void)leftNavItemClick
{
    [MHKeyboard removeRegisterTheViewNeedMHKeyboard];
    [MobClick event:@"LawQandA_Back"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    //表头
    NSString *content = self.questionDetailDict[@"content"];
    float height =  [HZUtil getHeightWithString:content fontSize:16 width:DEF_SCREEN_WIDTH-20];
    //上面名字LB高度35，下方空白处高度30.
    self.headerView = [[QuestionHeadView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH,height+60) withData:self.questionDetailDict];
    
    
    //设置底部的显示
    if (self.canEdit)
    {
        HZKeyBoardView *keyBoardView = [[HZKeyBoardView alloc]initForAutoLayout];
//        keyBoardView.alpha = 0.5;
        [self.view addSubview:keyBoardView];
        [keyBoardView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
        [keyBoardView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
        _keyBoardViewBottomConstraint = [keyBoardView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
        _keyBoardViewHeightConstraint = [keyBoardView autoSetDimension:ALDimensionHeight toSize:50.0];
        [keyBoardView.changeVoiceBtn addTarget:self action:@selector(changeVoiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [keyBoardView.sendBtn addTarget:self action:@selector(sendMessageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [keyBoardView.pressSpeakBtn addTarget:self action:@selector(pressSpeakBtnClick:) forControlEvents:UIControlEventTouchDown];
        keyBoardView.inputTF.delegate = self;
        [self.view addSubview:self.keyBoardView];
        self.keyBoardView = keyBoardView;
    }
    
    //数据表
    //    self.questionInteractTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20,DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT-64-44-20) style:UITableViewStyleGrouped];
    UITableView *questionInteractTableView = [[UITableView alloc]initForAutoLayout];
    [self.view addSubview:questionInteractTableView];
//    [questionInteractTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
    [questionInteractTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:64];
    [questionInteractTableView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [questionInteractTableView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    if (self.canEdit)
    {
       _tableViewBottomConstraint = [questionInteractTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-50.0];
    }
    else
    {
        _tableViewBottomConstraint = [questionInteractTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    }
    questionInteractTableView.delegate = self;
    questionInteractTableView.dataSource = self;
    questionInteractTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    questionInteractTableView.backgroundColor = [UIColor clearColor];
//    questionInteractTableView.backgroundColor = [UIColor purpleColor];
    questionInteractTableView.showsVerticalScrollIndicator = NO;
    questionInteractTableView.tableHeaderView = self.headerView;
    [questionInteractTableView registerClass:[MessageBubbleCell class] forCellReuseIdentifier:cellIdentifier];
    self.questionInteractTableView = questionInteractTableView;
}

#pragma mark - UITableViewDetegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allDataArr count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageBubbleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    NSDictionary *dictData = self.allDataArr[indexPath.row];
    [cell refreshCellWithDictionary:dictData];
    cell.headImageButton.tag = indexPath.row;
    [cell.headImageButton addTarget:self action:@selector(headImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.allDataArr[indexPath.row];
    return [MessageBubbleCell heightForCellWithDictionary:dict];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark - 点击头像
- (void)headImageButtonClick:(UIButton *)btn
{
    NSDictionary *dictData = self.allDataArr[btn.tag];
    NSString *type = dictData[@"type"];
    if ([type isEqualToString:@"2"])
    {
        [MobClick event:@"LawQandA_ClickLaw"];
        if (self.isFromNews)
        {
            MyInfoViewController *myInfoView = [[MyInfoViewController alloc]init];
            [self.navigationController pushViewController:myInfoView animated:YES];
            return;
        }
        NSString *lawyerID = self.answerDict[@"lawyer_id"];
        NSString *loginUid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
        if ([lawyerID isEqualToString:loginUid])
        {
            MyInfoViewController *myInfoView = [[MyInfoViewController alloc]init];
            [self.navigationController pushViewController:myInfoView animated:YES];
        }
        else
        {
            UserCenterViewController *userCenter = [[UserCenterViewController alloc]init];
            userCenter.diction = self.answerDict;
            [self.navigationController pushViewController:userCenter animated:YES];
        }
    }
}

#pragma mark - 输入方式切换
-(void)changeVoiceBtnClick:(UIButton*)sender
{
    sender.selected = !sender.selected;
    //文字
    if (sender.selected==YES)
    {
        [MobClick event:@"LawQandA_Keyboard"];
        _keyBoardViewHeightConstraint.constant = _keyBoardViewHeight;
//        [self.keyBoardView.inputTF becomeFirstResponder];
        self.keyBoardView.pressSpeakBtn.hidden = YES;
        self.keyBoardView.inputTF.hidden = NO;
        self.keyBoardView.sendBtn.hidden = NO;
    }
    //语音
    else
    {
        [MobClick event:@"LawQandA_Voice"];
        _keyBoardViewHeight = _keyBoardViewHeightConstraint.constant;
        _keyBoardViewHeightConstraint.constant = 50.0;
        [self.keyBoardView.inputTF resignFirstResponder];
        self.keyBoardView.pressSpeakBtn.hidden = NO;
        self.keyBoardView.inputTF.hidden = YES;
        self.keyBoardView.sendBtn.hidden = YES;
    }
}

#pragma mark - 发送消息
-(void)sendMessageBtnClick:(UIButton*)sender
{
    if (self.keyBoardView.inputTF.text.length == 0)
    {
        return;
    }
    [MobClick event:@"LawQandA_Submit"];
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = DEF_API_AnswerPlusSendMessage;
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    NSString *answer_id =self.answerID;
    
    [MHAsiNetworkAPI getAnswerPlusSendMessageByuid:uid timestamp:timeStamp sign:sign answer_id:answer_id content:self.keyBoardView.inputTF.text SuccessBlock:^(id returnData) {
        [self getChatInfoRequest];
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
    self.keyBoardView.inputTF.text = @"";
}

-(void)pressSpeakBtnClick:(UIButton*)sender
{
    [MobClick event:@"LawQandA_ClickTalk"];
    //结束编辑，键盘下降，
    [self.view endEditing:YES];
    [self changeVoiceBtnClick:self.keyBoardView.changeVoiceBtn];
    
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
                    DEF_DEBUG(@"%@",NSStringFromClass([subview class]));
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

#pragma mark - HPGrowingTextViewDelegate
- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    [self sendMessageBtnClick:nil];
    return NO;
}
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    DEF_DEBUG(@"_________%s\nheight:%f",__PRETTY_FUNCTION__,height);
    //输入框变化前高度
    CGFloat originalHeight = _keyBoardViewHeightConstraint.constant;
    
    //输入框变化后高度
    _keyBoardViewHeightConstraint.constant = height + 12;
    
    //偏移量
    CGFloat offSet = originalHeight - _keyBoardViewHeightConstraint.constant;
    
    
    _tableViewBottomConstraint.constant += offSet;
      if (offSet < 0)
    {
        CGPoint OffSet = self.questionInteractTableView.contentOffset;
        OffSet.y = OffSet.y - offSet;
        [self.questionInteractTableView setContentOffset:OffSet animated:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self.keyBoardView.inputTF resignFirstResponder];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
}
- (void)keyBoardShow:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    NSValue *endValue = info[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect keyBoardRect = [endValue CGRectValue];
    CGFloat keyBoardHeight = keyBoardRect.size.height;
    _keyBoardViewBottomConstraint.constant = -keyBoardHeight;
    _tableViewBottomConstraint.constant = -keyBoardHeight-_keyBoardViewHeightConstraint.constant;
    [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.01];
}
- (void)keyBoardHide:(NSNotification *)notification
{
    _keyBoardViewBottomConstraint.constant = 0;
    _tableViewBottomConstraint.constant = -_keyBoardViewHeightConstraint.constant;
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
    //    self.voiceString = [NSString stringWithFormat:@"%@%@",self.suggestionTextView.text,result];
    self.keyBoardView.inputTF.text =[NSString stringWithFormat:@"%@%@",self.keyBoardView.inputTF.text,result];
}

/** 识别结束回调方法
 @param error 识别错误
 */
- (void)onError:(IFlySpeechError *)error
{
    [self.view addSubview:_popView];
    
    //    self.suggestionTextView.text = self.voiceString;
    
    [_popView setText:@"识别结束"];
    DEF_DEBUG(@"errorCode:%d",[error errorCode]);
}

-(void)rightNavItemClick
{
    DEF_DEBUG(@"采纳回复");
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//#pragma mark --textField
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    //让下面的输入框上去的效果
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.25];
//    [UIView setAnimationCurve:7];
//    self.keyBoardView.frame=CGRectMake(0, DEF_SCREEN_HEIGHT - 216 -, 320, 44);
//    self.questionInteractTableView.frame=CGRectMake(0, 64, 320, 480-64-216-44);
//    [UIView commitAnimations];
//    
//    if (self.allDataArr.count>=1)
//    {
//        NSIndexPath * indexPath =[NSIndexPath indexPathForRow:self.allDataArr.count-1 inSection:0];
//        [self.questionInteractTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    }
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
