//
//  RaceQuestionViewController.m
//  MHProject
//
//  Created by ZhangChaoxin on 15/7/6.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "RaceQuestionViewController.h"
#import "HZUtil.h"
#import "NewQuestionView.h"
#import "RaiseIdeaViewController.h"
@interface RaceQuestionViewController ()
{
    NewQuestionView *_questionView;
    //旋转圆环
    UIImageView *_circleView;
    //抢答按钮的背景
    UIImageView *_backgroudView;
    //抢答按钮
    UIButton *_answerButton;
    //倒计时标签
    UILabel *_countLabel;
    //定时器
    NSTimer *_timer;
    //时间
    NSInteger _time;
}
@end

@implementation RaceQuestionViewController
-(void)getQuestionDetailRequest
{
    if (!self.questionID)
    {
        [self initUI];
        return;
    }
    //
    NSString *question_idStr = self.questionID;
    __weak RaceQuestionViewController *weakSelf = self;
    
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
- (void)dealloc
{
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavUI];
    [self getQuestionDetailRequest];
    // Do any additional setup after loading the view.
}
- (void)setNavUI
{
    [self showNavBarDefaultHUDByNavTitle:@"抢答问题" inView:self.view isBack:YES];
}
- (void)leftNavItemClick
{
    [super leftNavItemClick];
    [MobClick event:@"LawGetQin_Back"];
}
- (void)initUI
{
    [self creatContScrollView];
    self.contentScrollView.frame = CGRectMake(0, 64, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT - 64 - DEF_SCREEN_WIDTH);
    self.automaticallyAdjustsScrollViewInsets = NO;
    //问题视图
    self.contentScrollView.showsVerticalScrollIndicator = YES;
    NSArray *imageArr = self.questionDetailDict[@"image"];
    UITextView *textView = [[UITextView alloc] init];
    textView.text = self.questionDetailDict[@"content"];
    CGFloat height = [HZUtil getHeightWithString:self.questionDetailDict[@"content"] fontSize:16 width:DEF_SCREEN_WIDTH-24];
    if ([imageArr count] > 0)//有图片的问题
    {
        _questionView = [[NewQuestionView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, height + 47+5 +width(100.0)) with:self.questionDetailDict];
    }
    else//没有图片的问题
    {
        _questionView = [[NewQuestionView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, height + 41 +5) with:self.questionDetailDict];
    }
    
    [self.contentScrollView addSubview:_questionView];
    if (_questionView.height >= DEF_SCREEN_HEIGHT - 64 - DEF_SCREEN_WIDTH)
    {
        [self.contentScrollView frameSet:@"h" value:DEF_SCREEN_HEIGHT - 64 - DEF_SCREEN_WIDTH];
    }
    else
    {
        [self.contentScrollView frameSet:@"h" value:_questionView.height];
    }
    self.contentScrollView.contentSize = CGSizeMake(0, _questionView.height);
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, DEF_BOTTOM(self.contentScrollView), DEF_SCREEN_WIDTH, DEF_SCREEN_WIDTH)];
    DEF_DEBUG(@"%@",NSStringFromCGRect(bottomView.frame));
    [self.view insertSubview:bottomView aboveSubview:self.contentScrollView];
    
    //外部圆环
    _circleView = [[UIImageView alloc] initForAutoLayout];
    _circleView.image = [UIImage imageNamed:@"outer-ring"];
    _circleView.contentMode = UIViewContentModeScaleAspectFit;
    [bottomView addSubview:_circleView];
    [_circleView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:bottomView withOffset:TRANSFORM_HEIGHT(132/3.0)];
    [_circleView autoSetDimension:ALDimensionHeight toSize:TRANSFORM_HEIGHT(520/3.0)];
    [_circleView autoSetDimension:ALDimensionWidth toSize:TRANSFORM_HEIGHT(520/3.0)];
    [_circleView autoAlignAxis:ALAxisVertical toSameAxisOfView:bottomView];
    
    
    //抢答按钮的背景
    _backgroudView = [[UIImageView alloc] initForAutoLayout];
    _backgroudView.image = [UIImage imageNamed:@"rob-bg"];
    _backgroudView.userInteractionEnabled = YES;
    _backgroudView.clipsToBounds = NO;
    [bottomView addSubview:_backgroudView];
    [_backgroudView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_circleView withOffset:TRANSFORM_HEIGHT(16.5)];
    [_backgroudView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [_backgroudView autoSetDimension:ALDimensionHeight toSize:TRANSFORM_HEIGHT(140)];
    [_backgroudView autoSetDimension:ALDimensionWidth toSize:TRANSFORM_HEIGHT(140)];
    
    //抢答按钮
    _answerButton = [[UIButton alloc] initForAutoLayout];
    [_backgroudView addSubview:_answerButton];
    [_answerButton autoCenterInSuperview];
    [_answerButton autoSetDimensionsToSize:CGSizeMake(TRANSFORM_HEIGHT(120), TRANSFORM_HEIGHT(120))];
    [_answerButton setBackgroundImage:[UIImage imageNamed:@"rob"] forState:UIControlStateNormal];
    [_answerButton setBackgroundImage:[UIImage imageNamed:@"rob_on"] forState:UIControlStateHighlighted];
    [_answerButton addTarget:self action:@selector(answerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    //旋转动画
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//"z"还可以是“x”“y”，表示沿z轴旋转
    rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI) * 3];
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.duration = 5.0f;
//    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; //缓入缓出
    [_circleView.layer addAnimation:rotationAnimation forKey:@""];
    
    //倒计时标签
    _countLabel = [[UILabel alloc] initForAutoLayout];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.font = [UIFont systemFontOfSize:21.7];
    [bottomView addSubview:_countLabel];
    _countLabel.textColor = DEF_RGB_COLOR(51, 51, 51);
    [_countLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_circleView withOffset:TRANSFORM_HEIGHT(50/3.0)];
    [_countLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [_countLabel autoSetDimension:ALDimensionHeight toSize:height(50.0)];
    [_countLabel autoSetDimension:ALDimensionWidth toSize:height(250.0)];
    
    _time = 99;
    [self setLabelTime];
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeCount) userInfo:nil repeats:YES];
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:_timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 倒计时
- (void)timeCount
{
    _time -- ;
    [self setLabelTime];
    if (_time == 0)
    {
        [_timer invalidate];
        _timer = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)setLabelTime
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余%2ld秒",(long)_time]];
    [str addAttribute:NSForegroundColorAttributeName value:DEF_RGB_COLOR(111.0, 111.0, 111.0) range:NSMakeRange(0,2)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:21.75] range:NSMakeRange(0, 2)];
    
    [str addAttribute:NSForegroundColorAttributeName value:DEF_RGB_COLOR(51, 51, 51) range:NSMakeRange(2,2)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:48] range:NSMakeRange(2, 2)];
    
    [str addAttribute:NSForegroundColorAttributeName value:DEF_RGB_COLOR(111.0, 111.0, 111.0) range:NSMakeRange(4, 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(4, 1)];
    _countLabel.attributedText = str;
}

#pragma mark - 点击抢答按钮
- (void)answerButtonClick
{
    [MobClick event:@"LawGetQin_Click"];
    //点击按钮后定时器不再倒计时
    [_timer invalidate];
    _timer = nil;
    __weak RaceQuestionViewController *weakSelf = self;

    [UIView animateWithDuration:0.6 animations:^{
        _answerButton.transform = CGAffineTransformScale([self transformForOrientation], 1.4, 1.4);
    } completion:^(BOOL finished) {
        NSString *uid = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
        NSString *timeStamp = [[CMManager sharedCMManager]getCurrentTimestap];
        NSString *token = DEF_PERSISTENT_GET_OBJECT(DEF_loginToken);
        NSString *url = DEF_API_AnswerRaceQuestion;
        NSString *sign = [[CMManager sharedCMManager]getSignByURL:url timestamp:timeStamp token:token];
        NSString *questionID = weakSelf.questionDetailDict[@"id"];
        [UIView animateWithDuration:0.6 animations:^{
            _answerButton.transform = CGAffineTransformScale([self transformForOrientation], 1, 1);
        } completion:^(BOOL finished) {
            //暂停动画的方法
//            [self pauseLayer:_circleView.layer];
            [MHAsiNetworkAPI answerRaceQuestionByuid:uid timestamp:timeStamp sign:sign question_id:questionID SuccessBlock:^(id returnData) {
                NSString *ret = returnData[@"ret"];
                NSString *message = returnData[@"msg"];
                if ([ret isEqualToString:@"0"])
                {
                    [_answerButton setBackgroundImage:[UIImage imageNamed:@"rob_success"] forState:UIControlStateNormal];
                    RaiseIdeaViewController *raiseVC = [[RaiseIdeaViewController alloc] init];
                    raiseVC.isRace = YES;
                    raiseVC.answerID = returnData[@"data"][@"id"];
                    raiseVC.questionDetailDict = weakSelf.questionDetailDict;
                    [weakSelf.navigationController pushViewController:raiseVC animated:YES];
                }
                else
                {
                    [_answerButton setBackgroundImage:[UIImage imageNamed:@"rob_fail"] forState:UIControlStateNormal];
                    SHOW_ALERT(message);
                }
                _answerButton.enabled = NO;
            } failureBlock:^(NSError *error) {
            } showHUD:YES];
        }];
    }];
}

#pragma mark - 放大缩小动画
- (CGAffineTransform)transformForOrientation
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationLandscapeLeft == orientation) {
        return CGAffineTransformMakeRotation(M_PI*1.5);
    } else if (UIInterfaceOrientationLandscapeRight == orientation) {
        return CGAffineTransformMakeRotation(M_PI/2);
    } else if (UIInterfaceOrientationPortraitUpsideDown == orientation) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}

#pragma mark - 操作动画
//用来暂停layer上的动画
-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime()fromLayer:nil];
    layer.speed=0.0;
    layer.timeOffset = pausedTime;
}
//恢复layer上的动画
-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime=[layer timeOffset];
    layer.speed=1.0;
    layer.timeOffset=0.0;
    layer.timeOffset = pausedTime;
}
- (void)didReceiveMemoryWarning
{
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
