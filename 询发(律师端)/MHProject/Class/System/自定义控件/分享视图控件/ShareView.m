//
//  ShareView.m
//  BlueMobiProject
//
//  Created by Andy on 15/1/29.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "ShareView.h"
#import <ShareSDK/ShareSDK.h>
#import "WeiboSDK.h"
@interface ShareView ()

@end

@implementation ShareView

/**
 *  把截图的图片写到沙盒里 然后获取它的路径 当分享成功后再把改路径下的图片删除
 *
 *  @param shareThumbImage 图片
 */
-(void)setShareThumbImage:(UIImage *)shareThumbImage

{
    _shareThumbImage = shareThumbImage;
    
    // 将图片写入沙盒
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"image.png"]];   // 保存文件的名称
    [UIImagePNGRepresentation(shareThumbImage)writeToFile: filePath  atomically:YES];
    
    self.imagePath = filePath;
}
/**
 *  上传完图片后把截取的图片从沙盒里删除了
 *
 *  @param path 路径
 */
-(void)removeTempImage:(NSString*)path
{
    NSFileManager  * manager =[ NSFileManager defaultManager];
    [manager removeItemAtPath:path error:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 半透明背景
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        //
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-160, DEF_SCREEN_WIDTH, 160)];
        topView.backgroundColor = DEF_RGB_COLOR(239, 239, 239);
        topView.layer.cornerRadius = 5;
        topView.clipsToBounds = YES;
        [self addSubview:topView];
        
        //
        
        NSArray *imageArr = @[@"微信",@"新浪微博",@"微信朋友圈",@"qq空间"];
        NSArray *titleArr = @[@"发送给朋友",@"新浪微博",@"分享到朋友圈",@"QQ空间"];
        float w = DEF_SCREEN_WIDTH/4;
        float h = DEF_HEIGHT(topView)/2;
        CGFloat btnVspace = 20;
        
        for (int i = 0; i < 4; i++)
        {
            UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            shareBtn.frame = CGRectMake(i*w, btnVspace, w, h);
            [shareBtn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
            [shareBtn setTitle:titleArr[i] forState:UIControlStateNormal];
            shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 30, 10);
            
            if (DEF_SCREEN_WIDTH == 320.0)
            {
                shareBtn.titleEdgeInsets = UIEdgeInsetsMake(50, -41, 0, 0);
            }
            else if(DEF_SCREEN_IS_6)
            {
                shareBtn.titleEdgeInsets = UIEdgeInsetsMake(50, -45, 0, 0);
            }
            else
            {
                shareBtn.titleEdgeInsets = UIEdgeInsetsMake(50, -52, 0, 0);
            }
            
            shareBtn.titleLabel.font = DEF_Font(13.5);
            [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [shareBtn addTarget:self action:@selector(sharBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            shareBtn.tag = i;
            [topView addSubview:shareBtn];
        }
        
        UIButton *cancleBtn      = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleBtn.frame          = CGRectMake(0,
                                              topView.frame.size.height-40,
                                              topView.frame.size.width,
                                              40
                                              );
        cancleBtn.backgroundColor = [UIColor whiteColor];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [topView addSubview:cancleBtn];
        
        
//        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        closeButton.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT);
//        [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:closeButton];

        
        
        // 做个渐变显示的动画
        self.alpha = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            //
        }];
    }
    return self;
}

#pragma mark - 点击事件

-(void)sharBtnClick:(UIButton *)btn
{
    switch (btn.tag)
    {
        case 0:
        {
            //            微信好友
            [self wxBtnClick:btn];
        }
            break;
        case 1:
        {
            //            新浪微博
            [self sinaBtnClick:btn];
            
        }
            break;
            
        case 2:
        {
            //            微信朋友圈
            [self wxpyBtnClick:btn];
            
        }
            break;
        case 3:
        {
            //  QQ空间
            [self qqZoneBtnClick:btn];
            
        }
            break;
            
            
        default:
            break;
    }
    
}


- (void)sinaBtnClick:(UIButton *)btn
{
    if (self.sinaBlock)
    {
        self.sinaBlock();
    }
    if ([WeiboSDK isWeiboAppInstalled] == YES)
    {
        if (self.sinaBlock)
        {
            self.sinaBlock();
        }
        
        NSString * image =self.imagePath;
//        NSLog(@"image:%@",image);
        
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@ %@",self.shareDescription,self.shareURLStr]
                                           defaultContent:self.shareDescription
                                                    image:[ShareSDK jpegImageWithImage:self.shareThumbImage quality:1]
                                         //                                         [ShareSDK imageWithPath:image]
                                                    title:self.shareTitle
                                                      url:self.shareURLStr
                                              description:self.shareDescription
                                                mediaType:SSPublishContentMediaTypeNews];
        
        [ShareSDK clientShareContent:publishContent
                                type:ShareTypeSinaWeibo
                       statusBarTips:YES
                              result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end){
                                  [self removeTempImage:self.imagePath];
                                  
                                  if (state == SSPublishContentStateSuccess)
                                  {
                                      
                                      //    分享完成后在vc里调用
                                      if (self.shareBlock)
                                      {
                                          self.shareBlock();
                                      }
//                                      NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功!"));
                                      [self pushAlertWithTip:@"" Message:@"新浪微博分享成功"];
                                  }
                                  else if (state == SSPublishContentStateFail)
                                  {
//                                      NSLog(@"[error errorDescription]:%@",[error errorDescription]);
//                                      NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败!"), [error errorCode], [error errorDescription]);
                                      
                                      [self pushAlertWithTip:@"" Message:@"新浪微博分享失败"];
                                      
                                  }
                              }];
    }
    
    else
    {
        //创建分享内容
//        NSString * image =self.imagePath;
        id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@ %@",self.shareDescription,self.shareURLStr]
                                           defaultContent:self.shareDescription
                                                    image:[ShareSDK jpegImageWithImage:self.shareThumbImage quality:1]
                                         //                                         [ShareSDK imageWithPath:image]
                                                    title:self.shareTitle
                                                      url:self.shareURLStr
                                              description:self.shareDescription
                                                mediaType:SSPublishContentMediaTypeNews];
        
        //创建弹出菜单容器
        id<ISSContainer> container = [ShareSDK container];
        [container setIPadContainerWithView:btn arrowDirect:UIPopoverArrowDirectionUp];
        
        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                             allowCallback:YES
                                                             authViewStyle:SSAuthViewStyleFullScreenPopup
                                                              viewDelegate:nil
                                                   authManagerViewDelegate:nil];
        
        //在授权页面中添加关注官方微博
        [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                        SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                        SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                        nil]];
        
        //显示分享菜单
        [ShareSDK showShareViewWithType:ShareTypeSinaWeibo
                              container:container
                                content:publishContent
                          statusBarTips:YES
                            authOptions:authOptions
                           shareOptions:[ShareSDK defaultShareOptionsWithTitle:@"分享"
                                                               oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                qqButtonHidden:NO
                                                         wxSessionButtonHidden:NO
                                                        wxTimelineButtonHidden:NO
                                                          showKeyboardOnAppear:NO
                                                             shareViewDelegate:self
                                                           friendsViewDelegate:nil                                                         picViewerViewDelegate:nil]
                                 result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                     
                                     if (state == SSPublishContentStateSuccess)
                                     {
                                         if (self.shareBlock)
                                         {
                                             self.shareBlock();
                                         }
//                                         NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                         [self pushAlertWithTip:@"" Message:@"新浪微博分享成功"];
                                     }
                                     else if (state == SSPublishContentStateFail)
                                     {
//                                         NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                         [self pushAlertWithTip:@"" Message:@"新浪微博分享失败"];
                                     }
                                 }];
    }
    [self closeBtnClick:btn];
}

- (void)wxBtnClick:(UIButton *)btn
{
    //发送内容给微信
    id<ISSContent> content = [ShareSDK content:self.shareDescription
                                defaultContent:self.shareDescription
                                         image:[ShareSDK jpegImageWithImage:self.shareThumbImage quality:1]
                                         title:self.shareTitle
                                           url:self.shareURLStr
                                   description:self.shareDescription
                                     mediaType:SSPublishContentMediaTypeNews];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    [ShareSDK shareContent:content
                      type:ShareTypeWeixiSession
               authOptions:authOptions
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
     {
         
         
         [self removeTempImage:self.imagePath];
         
         if (state == SSPublishContentStateSuccess)
         {
//             NSLog(@"success");
             
             if (self.shareBlock)
             {
                 self.shareBlock();
                 
             }
             [self pushAlertWithTip:@"" Message:@"分享到微信好友列表成功"];
         }
         else if (state == SSPublishContentStateFail)
         {
             [self pushAlertWithTip:@"" Message:@"分享到微信好友列表失败"];
             
         }
     }];
    [self closeBtnClick:btn];
}

- (void)wxpyBtnClick:(UIButton *)btn
{
    id<ISSContent> content = [ShareSDK content:self.shareDescription
                                defaultContent:self.shareDescription
                                         image:[ShareSDK jpegImageWithImage:self.shareThumbImage quality:1]
                                         title:self.shareTitle
                                           url:self.shareURLStr
                                   description:self.shareDescription
                                     mediaType:SSPublishContentMediaTypeNews];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    [ShareSDK shareContent:content
                      type:ShareTypeWeixiTimeline
               authOptions:authOptions
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        
                        [self removeTempImage:self.imagePath];
                        
                        
                        if (state == SSPublishContentStateSuccess)
                        {
                            [self pushAlertWithTip:@"" Message:@"分享到朋友圈成功"];
//                            NSLog(@"success");
                            
                            
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            [self pushAlertWithTip:@"" Message:@"分享到朋友圈失败"];
                        }
                    }];    // 关闭View
    [self closeBtnClick:btn];
    
}

- (void)qqZoneBtnClick:(UIButton *)btn
{
    id<ISSContent> content = [ShareSDK content:self.shareDescription
                                defaultContent:self.shareDescription
                                         image:[ShareSDK jpegImageWithImage:self.shareThumbImage quality:1]
                                         title:self.shareTitle
                                           url:self.shareURLStr
                                   description:self.shareDescription
                                     mediaType:SSPublishContentMediaTypeImage];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    [ShareSDK shareContent:content
                      type:ShareTypeQQSpace
               authOptions:authOptions
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        
                        
                        
                        [self removeTempImage:self.imagePath];
                        
                        
                        if (state == SSPublishContentStateSuccess)
                        {
                            [self pushAlertWithTip:@"" Message:@"QQ空间分享成功"];
                            
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            
//                            NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);                            [self pushAlertWithTip:@"" Message:@"QQ空间分享失败"];
                        }
                    }];
    // 关闭View
    [self closeBtnClick:btn];
}

- (void)closeBtnClick:(UIButton *)btn
{
    [UIView animateWithDuration:0.25 animations:^{
        //
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        //
        [self removeFromSuperview];
    }];
}
-(void)closeButtonClick:(UIButton *)btn
{
    [UIView animateWithDuration:0.25 animations:^{
        //
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        //
        [self removeFromSuperview];
    }];
}



// 提示框
- (void)pushAlertWithTip:(NSString *)tip Message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:tip message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    [alert show];
}

//
- (void)doSomethingAfterShareCompletion:(ShareSuccessBlock)block
{
    self.shareBlock = block;
}
- (void)sinaShare:(SinaBlock)completion
{
    self.sinaBlock = completion;
}
- (void)cancleShare:(CancleBlock)completion
{
    self.cancleBlock = completion;
}
- (void)closeShar:(CloseBlock)completion
{
    self.closeBlock = completion;
}

@end