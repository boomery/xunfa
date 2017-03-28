//
//  RaiseIdeaViewController.m
//  MHProject
//
//  Created by 张好志 on 15/6/21.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "RaiseIdeaViewController.h"
#import "QuestionModel.h"
#import "QuestionDetailCell.h"
#import "NewQuestionView.h"
#import "HZUtil.h"
#import "HZKeyBoardView.h"
#import "MHKeyboard.h"
#import "HomeViewController.h"

@interface RaiseIdeaViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate, HPGrowingTextViewDelegate>
{
    NSLayoutConstraint *_keyBoardViewBottomConstraint;
    NSLayoutConstraint *_keyBoardViewHeightConstraint;
    CGFloat _keyBoardViewHeight;
    //定时器
    NSTimer *_timer;//跑分定时器
    //时间
    NSInteger _time;
    //时间提示标签
    UILabel *_timeAttentionLB ;
    UILabel *_timeDanweiLB ;
    NSTimer *_timeSecondTimer;//跑秒定时器
}
@property (nonatomic,strong)UITableView       *raiseIdeaTableView;
@property (nonatomic,strong)NSMutableArray    *raiseIdeaArray;
@property (nonatomic,strong)NewQuestionView  *headerView;
@property (nonatomic,strong)HZKeyBoardView    *keyBoardView;
@end

@implementation RaiseIdeaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    [self initNav];
    [self initUI];    
    [self initVoice];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //取消识别
    [_iflyRecognizerView cancel];
    [_iflyRecognizerView setDelegate: nil];
    [_timer invalidate];
    _timer = nil;
}
- (void)dealloc
{
  
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DEF_DEBUG(@"self.questionDetailDict:%@",self.questionDetailDict);
}

#pragma mark - HTTP请求相关
//发送主意
-(void)giveMyIdeaToServer
{
    __weak RaiseIdeaViewController *weakSelf = self;
   //1、配置请求参数
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    //抢答的答案
    if (self.isRace)
    {
        NSString *url = [NSString stringWithFormat:@"%@/%@",DEF_API_AnswerRaceQuestion,self.answerID];
        NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
        [MHAsiNetworkAPI updateAnswerRaceQuestionByuid:uid timestamp:timeStamp sign:sign answer_id:self.answerID content:self.keyBoardView.inputTF.text state:@"0" SuccessBlock:^(id returnData) {
            NSString *ret = returnData[@"ret"];
            NSString *message = returnData[@"msg"];
            if ([ret isEqualToString:@"0"])
            {
//                SHOW_ALERT(@"抢答成功，请在我的抢答中关注用户追问");                
                NSArray *vcArray = weakSelf.navigationController.childViewControllers;
                for (UIViewController *vc in vcArray) {
                    if ([vc isKindOfClass:[HomeViewController class]])
                    {
                        HomeViewController *homeVC = (HomeViewController *)vc;
                        homeVC.showRaceSuccessTipStr = @"抢答成功";
                        [weakSelf.navigationController popToViewController:homeVC animated:YES];
                    }
                }
            }
            else
            {
                SHOW_ALERT(message);
            }
        } failureBlock:^(NSError *error) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        } showHUD:YES];
    }
    //普通出主意，（评论）
    else
    {
        NSString *questionID = self.questionDetailDict[@"question_id"];
        NSString *url = [NSString stringWithFormat:@"%@",DEF_API_GiveIdeaToquestionPing];
        NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
        [MHAsiNetworkAPI giveAnIdeaToServerWithuid:uid timestamp:timeStamp sign:sign qid:questionID content:self.keyBoardView.inputTF.text SuccessBlock:^(id returnData) {
            NSString *ret = returnData[@"ret"];
            NSString *message = returnData[@"msg"];
            if ([ret isEqualToString:@"0"])
            {
                if (weakSelf.giveIdeaSuccessBlock)
                {
                    weakSelf.giveIdeaSuccessBlock();
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                SHOW_ALERT(message);
            }
            HiddenLoadingView(weakSelf.view);
        } failureBlock:^(NSError *error) {
            HiddenLoadingView(weakSelf.view);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } showHUD:NO];
    }
}

#pragma mark - 初始化相关
//初始化导航条
-(void)initNav
{
    if (self.isRace)
    {
        [self showNavBarWithTwoBtnHUDByNavTitle:@"快给TA出个主意" leftImage:@"menu-left-back" leftTitle:@"" rightImage:@"" rightTitle:@"放弃" inView:self.view isBack:YES];
    }
    else
    {
        [self showNavBarDefaultHUDByNavTitle:@"快给TA出个主意" inView:self.view isBack:YES];
    }
    
}
-(void)rightNavItemClick
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定要放弃吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

//初始化界面
-(void)initUI
{
    float height =  [HZUtil getHeightWithString:self.questionDetailDict[@"content"] fontSize:16 width:DEF_SCREEN_WIDTH-20];
    //表头
    //1、表头问题
    NSArray *imageArr = self.questionDetailDict[@"image"];
    if ([imageArr count] > 0)//有图片的问题
    {
        _headerView = [[NewQuestionView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, height + 47+5 +width(100.0)) with:self.questionDetailDict];
    }
    else//没有图片的问题
    {
        _headerView = [[NewQuestionView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, height + 41 +5) with:self.questionDetailDict];
    }
    //
    float timeAttentionLBHeight = 50.0;
    UIView *topBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH,DEF_HEIGHT(self.headerView)+timeAttentionLBHeight)];
    topBgView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    [topBgView addSubview:self.headerView];
    
    //抢答提示相关
    if (self.isRace)
    {
        UIView *timeTipBgView = [[UIView alloc]initWithFrame:CGRectMake(0, DEF_HEIGHT(topBgView)-timeAttentionLBHeight, DEF_SCREEN_WIDTH, timeAttentionLBHeight)];
        timeTipBgView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
        [topBgView addSubview:timeTipBgView];
        //抢答提示图标
        UIImageView *timeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 17, 15, 15)];
        timeImageView.image = [UIImage imageNamed:@"ic_left_clock"];
        timeImageView.contentMode =  UIViewContentModeScaleAspectFit;
        //    timeImageView.backgroundColor = [UIColor redColor];
        [timeTipBgView addSubview:timeImageView];
        
        //
        UILabel *timeLeftLB = [[UILabel alloc]initWithFrame:CGRectMake(DEF_RIGHT(timeImageView)+3, 15, 60, 20)];
        timeLeftLB.textColor = DEF_RGB_COLOR(51, 51, 51);
        timeLeftLB.font = [UIFont systemFontOfSize:16];
        timeLeftLB.textAlignment =NSTextAlignmentLeft;
        timeLeftLB.backgroundColor = [UIColor clearColor];
        timeLeftLB.text = @"抢答剩余";
        [timeLeftLB sizeToFit];
        [timeTipBgView addSubview:timeLeftLB];

        //
        _timeAttentionLB = [[UILabel alloc]initWithFrame:CGRectMake(DEF_RIGHT(timeLeftLB)+8,13,30,24)];
        _timeAttentionLB.textColor = DEF_RGB_COLOR(255, 255, 255);
        _timeAttentionLB.font = [UIFont boldSystemFontOfSize:18];
        _timeAttentionLB.text = @"10";
        _timeAttentionLB.backgroundColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1];
        _timeAttentionLB.layer.cornerRadius = 2;
        _timeAttentionLB.clipsToBounds = YES;
        _timeAttentionLB.textAlignment = NSTextAlignmentCenter;
        [timeTipBgView addSubview:_timeAttentionLB];
        //打开分钟定时器
        _time =600;
        _timer = [NSTimer timerWithTimeInterval:60 target:self selector:@selector(timeCount) userInfo:nil repeats:YES];
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addTimer:_timer forMode:NSRunLoopCommonModes];
        //
        _timeDanweiLB = [[UILabel alloc]initWithFrame:CGRectMake(DEF_RIGHT(_timeAttentionLB)+8,15,50,20)];
        _timeDanweiLB.textColor = DEF_RGB_COLOR(51, 51, 51);
        _timeDanweiLB.font = [UIFont systemFontOfSize:16];
        _timeDanweiLB.textAlignment =NSTextAlignmentLeft;
        _timeDanweiLB.text = @"分钟";
        [timeTipBgView addSubview:_timeDanweiLB];
    }
    
    //2、表提出的意见
    self.raiseIdeaTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT-64-44) style:UITableViewStylePlain];
    self.raiseIdeaTableView.delegate = self;
    self.raiseIdeaTableView.dataSource = self;
    self.raiseIdeaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.raiseIdeaTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.raiseIdeaTableView];
    self.raiseIdeaTableView.tableHeaderView = topBgView;
    
    //输入框
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
    
    self.popView = [[PopupView alloc] initWithFrame:CGRectMake(100, 300, 0, 0)];
    self.popView.ParentView = self.view;
}

#pragma mark - 倒计时
//分钟倒计时
- (void)timeCount
{
    _time =_time-60;
//    NSLog(@"——timer:%d",_time);
    [self setLabelTime];
    if (_time == 60)
    {
        //关闭分钟定时器
        [_timer invalidate];
        _timer = nil;
        
       //打开秒数定时器
        _timeDanweiLB.text = @"秒";
        _timeSecondTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeSecondCount) userInfo:nil repeats:YES];
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addTimer:_timeSecondTimer forMode:NSRunLoopCommonModes];
    }
}
- (void)setLabelTime
{
    NSString *timeStr = [NSString stringWithFormat:@"%d",_time/60];
    _timeAttentionLB.text = timeStr;
}
//秒数倒计时
-(void)timeSecondCount
{
    _time--;
    [self setSecondLabelTime];
    if (_time==0) {
        [self giveUpMyRaceQuestion];
        [_timeSecondTimer invalidate];
        _timeSecondTimer = nil;
        
    }
}
- (void)setSecondLabelTime
{

    NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)_time];
    _timeAttentionLB.text = timeStr;
}


- (void)keyBoardShow:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    NSValue *endValue = info[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect keyBoardRect = [endValue CGRectValue];
    CGFloat keyBoardHeight = keyBoardRect.size.height;
    _keyBoardViewBottomConstraint.constant = -keyBoardHeight;
}
- (void)keyBoardHide:(NSNotification *)notification
{
    _keyBoardViewBottomConstraint.constant = 0;
}

#pragma mark - HPGrowingTextViewDelegate
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
//    NSLog(@"_________%s\nheight:%f",__PRETTY_FUNCTION__,height);
    
    //输入框变化后高度
    _keyBoardViewHeightConstraint.constant = height + 12;
    
}
- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    [growingTextView resignFirstResponder];
    [self sendMessageBtnClick:nil];
    return YES;
}

#pragma mark - UITableViewDetegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.raiseIdeaArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    QuestionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[QuestionDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    QuestionModel *user = [self.raiseIdeaArray objectAtIndex:indexPath.row];
    cell.name.text = user.username;
//    [cell setQUestionText:user.introduction];
    cell.questionLable.backgroundColor = DEF_RGB_COLOR(50, 172, 234);
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionModel *user = [self.raiseIdeaArray  objectAtIndex:indexPath.row];
    
    CGSize size = CGSizeMake(300, 1000);
    CGSize lableSize = [user.introduction sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    float height = lableSize.height+110;
    return height;
}

#pragma mark - 科大讯飞相关
-(void)initVoice
{
    //创建语音听写的对象
    self.iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    //delegate需要设置，确保delegate回调可以正常返回
    _iflyRecognizerView.delegate = self;
}

-(void)pressSpeakBtnClick:(UIButton*)sender
{
    
    if (self.isRace)
    {
        [MobClick event:@"LawAnswer_Clicktalk"];

    }
    else
    {
        [MobClick event:@"LawIdea_Voice"];
 
    }
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
    
//    NSLog(@"errorCode:%d",[error errorCode]);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.keyBoardView.inputTF resignFirstResponder];
    return YES;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        //放弃抢答的机会
        case 1:
        {
            [MobClick event:@"LawAnswer_Cacel"];
            [self giveUpMyRaceQuestion];
        }
            break;
        default:
            break;
    }
}

//放弃我抢答的问题
-(void)giveUpMyRaceQuestion
{
    NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
    NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
    NSString *url = [NSString stringWithFormat:@"%@/%@",DEF_API_AnswerRaceQuestion,self.answerID];
    NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
    __weak RaiseIdeaViewController *weakSelf = self;
    [MHAsiNetworkAPI updateAnswerRaceQuestionByuid:uid timestamp:timeStamp sign:sign answer_id:self.answerID content:@"" state:@"4" SuccessBlock:^(id returnData) {
        DEF_DEBUG(@"放弃抢答返回的数据：%@",returnData);
        
        NSString *msg = returnData[@"msg"];
        NSString *ret = returnData[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            SHOW_ALERT(msg);
        }
    } failureBlock:^(NSError *error) {
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    } showHUD:YES];
}

#pragma mark - 导航条按钮点击事件
- (void)leftNavItemClick
{
    [MobClick event:@"LawIdea_Back"];

    [MHKeyboard removeRegisterTheViewNeedMHKeyboard];
    if (self.isRace)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"不进行回答直接退出将放弃本问题，您确定要继续吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else
    {
        [MobClick event:@"LawAnswer_Back"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 切换语音模式
-(void)changeVoiceBtnClick:(UIButton*)sender
{
    sender.selected = !sender.selected;
    //文字
    if (sender.selected==YES)
    {
        if (self.isRace)
        {
            [MobClick event:@"LawAnswer_Keyboard"];
        }
        else
        {
            [MobClick event:@"LawIdea_Keyboard"];
         }

        _keyBoardViewHeightConstraint.constant = _keyBoardViewHeight;
        self.keyBoardView.pressSpeakBtn.hidden = YES;
        self.keyBoardView.inputTF.hidden = NO;
        self.keyBoardView.sendBtn.hidden = NO;
//        [self.keyBoardView.inputTF becomeFirstResponder];
    }
    //语音
    else
    {
        if (self.isRace)
        {
            [MobClick event:@"LawAnswer_Voice"];
        }
        else{
            [MobClick event:@"LawIdea_ClickTalk"];
        }
        _keyBoardViewHeight = _keyBoardViewHeightConstraint.constant;
        _keyBoardViewHeightConstraint.constant = 50.0;
        self.keyBoardView.pressSpeakBtn.hidden = NO;
        self.keyBoardView.inputTF.hidden = YES;
        self.keyBoardView.sendBtn.hidden = YES;
        [self.keyBoardView.inputTF resignFirstResponder];
    }
}
//发送消息
-(void)sendMessageBtnClick:(UIButton*)sender
{
    [MobClick event:@"LawIdea_Submit"];
    if (self.keyBoardView.inputTF.text.length == 0)
    {
        SHOW_ALERT(@"输入内容不能为空");
        return;
    }
    //1、结束编辑
    [self.keyBoardView.inputTF resignFirstResponder];
    //2、发送请求
    if (![NSString isBlankString:self.keyBoardView.inputTF.text])
    {
        [MobClick event:@"LawAnswer_Submit"];

        [self giveMyIdeaToServer];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
