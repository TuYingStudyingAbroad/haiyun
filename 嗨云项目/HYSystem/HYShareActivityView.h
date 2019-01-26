//
//  HYShareActivityView.h
//  嗨云项目
//
//  Created by haiyun on 16/6/4.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HYSharePlatformType){
    
    /**
     *  微信好友
     */
    HYSharePlatformTypeWechatSession            = 0,
    /**
     *  微信朋友圈
     */
    HYSharePlatformTypeWechatTimeline           = 1,
    
    /**
     *  新浪微博
     */
    HYSharePlatformTypeSinaWeibo                = 2,
    /**
     *  QQ空间
     */
    HYSharePlatformTypeQZone                    = 3,
    /**
     *  拷贝
     */
    HYSharePlatformTypeCopy                     = 4,
    
    /**
     *  QQ好友
     */
    HYSharePlatformTypeQQFriend                 = 5,
    /**
     *  回到首页
     */
    HYSharePlatformTypeToMain                   = 6,
    /**
     *  联系客服
     */
    HYSharePlatformTypeCallService              = 7,
    
    /**
     *  发送短信
     */
    HYSharePlatformTypeSMS                  = 8,
};




typedef void(^HYShayeTypeBlocks)(HYSharePlatformType type);

/**************分享的button****************/
@interface HYShareButtonView : UIView

@property(nonatomic,copy) NSString *shareTitle;
@property(nonatomic,copy) NSString *shareImage;

@property(nonatomic,assign) id delegate;
@end

@protocol HYShareButtonViewDelegate <NSObject>

@optional
-(void)onIconBtnPress:(HYShareButtonView *)button;


@end


/***************分享界面****************/

@interface HYShareActivityView : UIView

/**
 *  普通分享
 *
 *  @param buttons   分享button
 *  @param shareType 回调
 *
 *  @return HYShareActivityView
 */
- (instancetype)initWithButtons:(NSArray *)buttons
                 shareTypeBlock:(HYShayeTypeBlocks )shareType;
/**
 *  商品详情分享
 *
 *  @param buttons   分享到的地方
 *  @param title     title
 *  @param pays      分享可以赚的价格
 *  @param content   内容
 *  @param shareType 回调
 *
 *  @return HYShareActivityView
 */
- (instancetype)initWithButtons:(NSArray *)buttons
                          title:(NSString *)title
                            pay:(NSString *)pays
                 shareTypeBlock:(HYShayeTypeBlocks )shareType;

-(void)show;

-(void)hide;


@end

/*******商品分享中间界面*************/

@interface HYShareContentView : UIView

@property (nonatomic,copy) NSString *sharePay;

@end
