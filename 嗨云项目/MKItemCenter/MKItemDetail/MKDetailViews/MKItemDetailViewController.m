//
//  MKItemDetailViewController.m
//  YangDongXi
//
//  Created by cocoa on 15/4/27.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKItemDetailViewController.h"
#import "AppDelegate.h"
#import <PureLayout.h>
#import "UIAlertView+Blocks.h"
#import <UIImageView+WebCache.h>
#import "UIColor+MKExtension.h"
#import "NSString+MKExtension.h"
#import "MKDetailPhotosViewController.h"
#import "MKProductListViewController.h"
#import "MKDetailBaseInfoView.h"
#import "MKDetailAdditionalInfoView.h"
#import "MKDetailChooseSKUButtonView.h"
#import "MKDetailBrandZoneView.h"
#import "MKDetailDetailViewController.h"
#import "MKSKUViewController.h"
#import "MKItemDetailBottomBar.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKItemObject.h"
#import "MKShoppingCartViewController.h"
#import "MKConfirmOrderViewController.h"
#import "NSArray+MKExtension.h"
#import "HYShareActivityView.h"
#import "MKExceptionView.h"
#import "MKItemDetailTipView.h"
#import "MKNetworking+BusinessExtension.h"
#import "MKBizPropertyObject.h"
#import "MKCollectionItem.h"
#import "MKCartItemObject.h"
#import "MKStoreInfoView.h"
#import "MKShareCodeView.h"
#import "MKItemCouponView.h"
#import "MKItemActivityView.h"
#import "NSDictionary+MKExtension.h"
#import "HYShareInfo.h"
#import "HYShareKit.h"
#import "MKMarketingFlagObject.h"
#import "MKFlagShared.h"
#import<AssetsLibrary/AssetsLibrary.h>
#import "UIImage+ResizeMagick.h"
#import "BaiduMobStat.h"
#import "MKItemMarkView.h"
#import "seckilView.h"
#import "MKBallTierView.h"
#import "MKCouponObject.h"
#import "MKItemDiscountObject.h"
#import "MKMarketActivityObject.h"
#import "MKDetailLimitedView.h"
#import "ShopCartFMDB.h"
#import "MKCartItemObject.h"
#import "MKItemShareRatioView.h"

@interface MKItemDetailViewController () <UIScrollViewDelegate, MKDetailDetailViewController, MKSKUViewControllerDelegate>
{
    NSString * seckillStetue;
}

#pragma mark -大图片浏览
@property (nonatomic, strong) MKDetailPhotosViewController *photosViewController;
#pragma mark -名字价格View
@property (nonatomic, strong) MKDetailBaseInfoView *baseInfoView;

#pragma mark -图文详情
@property (nonatomic, strong) MKDetailDetailViewController *detailViewController;

#pragma mark -SKU界面
@property (nonatomic, strong) MKSKUViewController *skuViewController;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

#pragma mark －底部购物车等
@property (nonatomic, strong) MKItemDetailBottomBar *bottomBar;

@property (nonatomic, strong) MKItemObject *item;

//topBar
@property (nonatomic, strong) IBOutlet UIView *topBarView;

@property (nonatomic, strong) IBOutlet UIView *topBarBackground;

@property (nonatomic, strong) IBOutlet UIView *topBarContentView;

@property (nonatomic, strong) IBOutlet UIButton *backButton;

@property (nonatomic, strong) IBOutlet UIButton *favoriteButton;


@property (nonatomic, strong) HYShareActivityView *activityView;

@property (nonatomic, strong) HYShareActivityView *activitySharView;


@property (nonatomic, strong) MKExceptionView *exceptionView;

@property (nonatomic, assign) BOOL isFavorite;

@property (nonatomic, strong) NSLayoutConstraint *insertConstraint;


@property (nonatomic, strong) MKItemSKUObject *selectedSKU;

@property (nonatomic, assign) NSInteger selectedNumber;

@property (nonatomic, strong) MKDetailChooseSKUButtonView *chooseSKUButtonView;

//售罄显示
@property (nonatomic, strong) MKItemDetailTipView *tipView;

@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong) MKShareCodeView *shareView;
@property (nonatomic, strong) seckilView* seckilView;

@property (nonatomic, strong) UIView *replaceView;
#pragma mark -活动，满减送等
@property (nonatomic, strong) MKItemActivityView *activeView;
#pragma mark -保证服务等
@property (nonatomic, strong) MKItemMarkView *markView;
#pragma mark -优惠券
@property (nonatomic, strong) MKItemCouponView *couponView;
#pragma mark -店铺信息
@property (nonatomic, strong) MKStoreInfoView *storeInfoView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *discountInfoArrary;
@property (nonatomic,strong) UIView *itemMarkView;

#pragma mark -分享显示赚的钱
@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (weak, nonatomic) IBOutlet UILabel *shareMoneyLabel;


@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (nonatomic,strong)MKCartItemObject *cartItemObj;
#pragma mark -佣金
@property (nonatomic, strong) MKItemShareRatioView *shareRatioView;
@property (nonatomic, strong) NSLayoutConstraint *shareRatioConstraint;

/**@brief 商品活动标签*/
@property (nonatomic, strong) NSString *bizMark;

/**@brief 是否显示分佣YES显示，NO不显示*/
@property (nonatomic, assign) BOOL isShowTopMark;
//限时购View
@property (nonatomic, strong) MKDetailLimitedView *limitedView;

@end


@implementation MKItemDetailViewController

- (void)dealloc
{
    [self.seckilView removeObserver:self forKeyPath:@"seckillStatue"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    
    self.skuViewController = [[MKSKUViewController alloc] init];
    self.skuViewController.delegate = self;
    //set for corner
    self.bottomBar.collectButton.layer.cornerRadius = 15.0;
    self.bottomBar.collectButton.clipsToBounds = YES;
    
    self.backButton.layer.cornerRadius = 15.0;
    self.backButton.clipsToBounds = YES;
    
    self.scrollView.scrollEnabled = YES;

    
    self.bizMark = nil;
    self.selectedNumber = 1;
     self.storeInfoView = [MKStoreInfoView loadFromXib];
     self.itemMarkView = [[UIView alloc] init];
    [self layoutViews];
    if (self.itemType==13)
    {
        [self loadData];
    }else
    {
        [self onRequest];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isConfiguration) {
        self.backButton.hidden = YES;
    }else {
        self.backButton.hidden = NO;
    }
    
    NSInteger count = getUserCenter.shoppingCartModel.itemCount;
    [self.bottomBar updateShoppingCountValue:count];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


-(void)shareViewChange
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 72.0f, 26.0f)
                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft
                                                         cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, 72.0f, 26.0f);
    maskLayer.path = maskPath.CGPath;
    self.moreView.layer.mask = maskLayer;
}
#pragma mark- 百度统计进入页面，建议在此处添加
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self enableSwipeBackWhenNavigationBarHidden];
    if ( self.item &&  ISNSStringValid(self.item.itemName)  )
    {
        NSString* cName = [NSString stringWithFormat:@"%@", self.item.itemName, nil];
        [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    }
    if ( [getUserCenter isLogined]
        && [getUserCenter.userInfo.roleMark integerValue] == 2
        && self.item
        && [self.item.gains integerValue] != 0 ) {
        [self chageShowTopMark:YES];
    }
    else
    {
        [self chageShowTopMark:NO];
    }
   
}

-(void)chageShowTopMark:(BOOL)ishow
{
    self.isShowTopMark = ishow;
    if ( ishow ) {
        [self shareViewChange];
        self.moreView.hidden = YES;
        self.shareButton.hidden = NO;
        self.shareButton.layer.cornerRadius = 15.0;
        self.shareButton.clipsToBounds = YES;
        self.shareMoneyLabel.text = [NSString stringWithFormat:@"赚¥%.2lf",[self.item.gains integerValue]/100.0f];
        self.shareRatioView.hidden = NO;
        self.shareRatioView.shareRatioLabel.text = [NSString stringWithFormat:@"%@",self.item.gainSharingDesc];
        self.shareRatioConstraint.constant = 39.0f;
        
    }else
    {
        self.moreView.hidden = YES;
        self.shareButton.hidden = NO;
        self.shareButton.layer.cornerRadius = 15.0;
        self.shareButton.clipsToBounds = YES;
        self.shareRatioView.hidden = YES;
        self.shareRatioConstraint.constant = 0.0f;

    }
}

#pragma mark- 百度统计退出页面，建议在此处添加
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ( self.item &&  ISNSStringValid(self.item.itemName) )
    {
        NSString* cName = [NSString stringWithFormat:@"%@", self.item.itemName, nil];
        [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
    }
   
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return (self.scrollView.contentOffset.y > 150 || !self.exceptionView.hidden) ?
            UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( [keyPath isEqualToString:@"itemCount"])
    {
        [self.bottomBar updateShoppingCountValue:getUserCenter.shoppingCartModel.itemCount];
    }
    //秒杀
    if ([keyPath isEqualToString:@"seckillStatue"]) {
        NSLog(@"kkkkkkkk");
        [self updateBottomBar];
    }
}

-(void)updateBottomBar{
    
    seckillStetue=[NSString stringWithFormat:@"%@",[self.seckilView valueForKey:@"seckillStatue"]];
//    NSLog(@"%@%ld",seckillStetue,(long)self.itemType);
    
    if ([seckillStetue isEqualToString:@"1"]) {
        self.bottomBar.purchaseButton.userInteractionEnabled=NO;
        self.bottomBar.purchaseButton.backgroundColor=[UIColor colorWithHexString:@"cccccc"];
      
        
    }
    if ([seckillStetue isEqualToString:@"2"]) {
        self.bottomBar.purchaseButton.userInteractionEnabled=YES;
        self.bottomBar.purchaseButton.backgroundColor=[UIColor colorWithHexString:@"FF2741"];
        [self.bottomBar.purchaseButton setTitle:@"立即秒杀" forState:UIControlStateNormal];

        
        
    }
    if ([seckillStetue isEqualToString:@"3"]) {
        self.bottomBar.purchaseButton.userInteractionEnabled=YES;
        self.bottomBar.purchaseButton.backgroundColor=[UIColor colorWithHexString:@"FF2741"];
         [self.bottomBar.purchaseButton setTitle:@"还有机会" forState:UIControlStateNormal];
        
    }
    
    if ([seckillStetue isEqualToString:@"4"]) {
        self.bottomBar.purchaseButton.userInteractionEnabled=NO;
        self.bottomBar.purchaseButton.backgroundColor=[UIColor colorWithHexString:@"cccccc"];
        [self.bottomBar.purchaseButton setTitle:@"活动已结束" forState:UIControlStateNormal];
        
    }
    if ([seckillStetue isEqualToString:@"11"]) {
        self.bottomBar.purchaseButton.userInteractionEnabled=YES;
        self.bottomBar.purchaseButton.backgroundColor=[UIColor colorWithHexString:@"FF2741"];
        [self.bottomBar.purchaseButton setTitle:@"去结算" forState:UIControlStateNormal];
    }

    
}
#pragma mark - 内部方法

- (void)layoutViews
{
    self.bottomBar = [MKItemDetailBottomBar loadFromXib];
    [self.bottomBar.purchaseButton addTarget:self action:@selector(purchaseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomBar.addToCartButton addTarget:self action:@selector(addToCartButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBar.collectButton addTarget:self action:@selector(favoriteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBar.cartButton addTarget:self action:@selector(cartButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bottomBar];
    
    [self.bottomBar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [self.bottomBar autoSetDimension:ALDimensionHeight toSize:60];
     self.bottomBar.hidden = YES;
     NSInteger count = getUserCenter.shoppingCartModel.itemCount;
    [self.bottomBar updateShoppingCountValue:count];
    
    //商品图
    self.photosViewController = [[MKDetailPhotosViewController alloc] init];
    [self addChildViewController:self.photosViewController];
    UIView *photoView = self.photosViewController.view;
    [self.scrollView addSubview:photoView];
    
    [photoView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [photoView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.scrollView];
    [photoView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [photoView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:photoView];
    
    self.replaceView = [[UIView alloc] init];
    _replaceView = photoView;
    //秒杀
    if (self.itemType==13) {
        self.seckilView=[seckilView loadFromXib];
        [self.scrollView addSubview:self.seckilView];
        [self.seckilView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
        [self.seckilView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
        [self.seckilView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:photoView];
        [self.seckilView autoSetDimension:ALDimensionHeight toSize:50];
        [self.seckilView addObserver:self forKeyPath:@"seckillStatue" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self.bottomBar.purchaseButton setTitle:@"立即秒杀" forState:UIControlStateNormal];
        _replaceView = self.seckilView;
    }
    
    //商品名字view
    self.baseInfoView = [MKDetailBaseInfoView loadFromXib];
    [self.scrollView addSubview:self.baseInfoView];
     [self.baseInfoView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.baseInfoView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_replaceView];
    [self.baseInfoView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [self.baseInfoView hideLimitedView:self.itemType skuNum:0];
    
       //图文详情
    self.detailViewController = [[MKDetailDetailViewController alloc] init];
    self.detailViewController.delegate = self;
    [self addChildViewController:self.detailViewController];
    UIView *v = self.detailViewController.view;
    [self.scrollView addSubview:v];
    self.insertConstraint = [v autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.baseInfoView withOffset:0];
    [v autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [v autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [v autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.scrollView
               withOffset:-64];
    [self.scrollView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:v];
    [self.baseInfoView.shareCodeButton addTarget:self action:@selector(loadCode) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -展示二维码
- (void)showCodeImageView {
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UIButton *butt = [UIButton buttonWithType:(UIButtonTypeCustom)];
    butt.frame = self.backView.bounds;
    [self.backView addSubview:butt];
    [butt addTarget:self action:@selector(closeShareCodeView:) forControlEvents:(UIControlEventTouchUpInside)];
    self.backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self.view.window addSubview:self.backView];
    self.shareView = [MKShareCodeView loadFromXib];
//    self.shareView.changeWidth.constant =[UIScreen mainScreen].bounds.size.width-60;
    [self.shareView.closeButton addTarget:self action:@selector(closeShareCodeView:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.shareView.shareToWeChatBtn addTarget:self action:@selector(shareToWeChat:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView.saveInPhoneBtn addTarget:self action:@selector(saveCodeInphone:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backView addSubview:self.shareView];
    [self.shareView autoSetDimension:ALDimensionWidth toSize:self.view.bounds.size.width * 3 / 4];
    [self.shareView autoSetDimension:ALDimensionHeight toSize:[UIScreen mainScreen].bounds.size.height * 5 / 7];
    [self.shareView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:self.view.bounds.size.width  / 8];
    [self.shareView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view];
    self.shareView.closeButton.layer.cornerRadius = 15;
    self.shareView.closeButton.layer.masksToBounds = YES;
    if (self.item.qrCode) {
            [self.shareView.codeImageView sd_setImageWithURL:[NSURL URLWithString:self.item.qrCode]];
    }
}

- (void):(UIButton *)button
{
    if ( self.item && ISNSStringValid(self.item.qrCode) )
    {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:self.item.qrCode] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize)
        {
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if ( image )
            {
                HYShareInfo *info = [[HYShareInfo alloc] init];
                info.content = self.item.itemName;
                info.images = image;
                info.type = HYPlatformTypeWeixiSession;
                info.shareType    = HYShareDKContentTypeImage;
                [HYShareKit shareImageWeChat:info  completion:^(NSString *errorMsg)
                 {
                     if ( ISNSStringValid(errorMsg) )
                     {
                         [MBProgressHUD showMessageIsWait:errorMsg wait:YES];
                     }
                 }];
            }else
            {
                [MBProgressHUD showMessageIsWait:@"分享失败！" wait:YES];
            }
        }];
    }
    else
    {
        [MBProgressHUD showMessageIsWait:@"分享失败！" wait:YES];
    }
 
}


- (void)saveCodeInphone:(UIButton *) button {
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if(author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
        [UIAlertView showWithTitle:@"提示" message:@"请移步到系统设置开启相册访问权限" style:UIAlertViewStyleDefault cancelButtonTitle:@"确定" otherButtonTitles:@[@"取消"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                    return ;
                }
            }else {
                return;
            }
        }];
    }else{
        UIImageWriteToSavedPhotosAlbum([self catchScreen], nil, nil, nil);
        [MBProgressHUD showMessageIsWait:@"保存成功" wait:YES];
    }
    
}

- (void)closeShareCodeView :(UIButton *) btn {
    [self.backView removeFromSuperview];
}

- (UIImage *)catchScreen
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.shareView.codeImageView.bounds.size.width, self.shareView.codeImageView.bounds.size.height), YES, 0);
    //设置截屏大小
    @try{
        [self.shareView.codeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    @catch(NSException *exception) {

    }
    @finally {
        
    }
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

- (void)showNormalView
{
    self.bottomBar.hidden = NO;
    self.scrollView.hidden = NO;
    
    self.bottomBar.collectButton.hidden = NO;
    
    //[self.backButton setImage:[UIImage imageNamed:@"arrow_back_white20x23"] forState:UIControlStateNormal];
    
    self.exceptionView.hidden = YES;
    
    /*
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.topBarView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor,
                       (id)[[UIColor clearColor] CGColor], nil];
    [self.topBarView.layer insertSublayer:gradient atIndex:0];
    
    [self setNeedsStatusBarAppearanceUpdate];
     */
    
}

#pragma mark -界面的搭建，增加板块
/**
 *  满减、活动信息,领取优惠券,商品标签
 */
- (void)fillData
{
    
    //处理满减、活动信息
    
    [self makeDiscountInfoWithArrary:self.item.discountInfoList];
    //秒杀相关；
    if (self.itemType==13) {
        MKCartItemObject *confirmItem = [[MKCartItemObject alloc] init];
        confirmItem.skuUid = [self.item.itemSkus.firstObject skuId];
        self.seckilView.skuUid= confirmItem.skuUid;
        self.seckilView.distributorId=@"";
        self.seckilView.seckillUid=self.item.miaoTuanXianOBJ.seckillUid;
        //self.seckilView.seckillStatue=self.item.miaoTuanXianOBJ.lifecycle;
        [self.seckilView updateView];
    }
    
    NSMutableArray *imageArray = [NSMutableArray array];
    for (MKItemImageObject *d in self.item.itemImages)
    {
        if (d.type == 2) {
            continue;
        }
        [imageArray addObject:d.imageUrl];
    }
    self.photosViewController.imageUrls = imageArray;
    MKMarketingFlagObject *object =  [[MKFlagShared sharedInstance].flagDictionary objectForKey:self.item.higoExtraInfo.supplyBase];
    
    NSString *imageLink = object.icon_url;
    if (imageLink.length > 0) {
        [self.baseInfoView.supplyImageView sd_setImageWithURL:[NSURL URLWithString:imageLink] placeholderImage:nil];
        self.baseInfoView.titleLabel.text = [NSString stringWithFormat:@"       %@",self.item.itemName];
    }else {
        self.baseInfoView.titleLabel.text = [NSString stringWithFormat:@"%@",self.item.itemName];
        self.baseInfoView.supplyImageView.hidden = YES;
    }
    if([self isMoreThanOneLineWithHeightForWidth:([UIScreen mainScreen].bounds.size.width - 82) usingFont:[UIFont systemFontOfSize:16.0] string:self.baseInfoView.titleLabel.text]) {
        [self.baseInfoView autoSetDimension:ALDimensionHeight toSize:100];
    }else {
        [self.baseInfoView autoSetDimension:ALDimensionHeight toSize:80];
    }

    [self.detailViewController loadItem:self.item];
    
    [self.skuViewController loadItem:self.item];
    
    [self fillPrice];
    
    BOOL cannotBuy = [self.skuViewController isSoldOut] || self.item.status != MKItemStatusSaling;
    if (cannotBuy)
    {
        self.tipView = [MKItemDetailTipView loadFromXib];
        [self.view addSubview:self.tipView];
        self.tipView.layer.masksToBounds = YES;
        self.tipView.layer.cornerRadius = 45;
        [self.tipView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.tipView autoSetDimension:ALDimensionHeight toSize:90];
        [self.tipView autoSetDimension:ALDimensionWidth toSize:90];
        [self.tipView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.photosViewController.view withOffset:- self.photosViewController.view.bounds.size.height / 2];
        if (self.item.status != MKItemStatusSaling)
        {
            self.tipView.textLabel.text = [MKItemObject stringWithStatus:self.item.status];
        }
    }
    
    if (self.itemType==13) {
        self.tipView.hidden=YES;
    }
    //秒杀判断
    if (!self.itemType) {
        [self disablePurchaseAndAddCart:cannotBuy];
        [self.skuViewController disablePurchaseAndAddCart:cannotBuy];
    }
    //限时购
    for (NSDictionary *dic in self.item.discountInfoList)
    {
        MKItemDiscountObject *itemDiscountObj = [MKItemDiscountObject objectWithDictionary:dic];
        //&& [itemDiscountObj.marketActivity.limitTagStatus integerValue] != 2
        if ( ISNSStringValid(itemDiscountObj.marketActivity.toolCode) && [itemDiscountObj.marketActivity.toolCode isEqualToString:@"TimeRangeDiscount"] )
        {
            self.bizMark = @"TimeRangeDiscount";
            _limitedView = [MKDetailLimitedView loadFromXib];
            [self insertRow:_limitedView withOffSet:0];
            [_limitedView autoSetDimension:ALDimensionHeight toSize:36];
            [_limitedView setMenuMsg:HYNowTimeChangeToDate([itemDiscountObj.marketActivity.limitTagDate floatValue]/1000) skuNum:cannotBuy limitTagStatus:[itemDiscountObj.marketActivity.limitTagStatus integerValue]];
            if ( !cannotBuy && [itemDiscountObj.marketActivity.limitTagStatus integerValue]==1 )
            {
                [self.baseInfoView hideLimitedView:21 skuNum:YES];
            }else
            {
                [self.baseInfoView hideLimitedView:21 skuNum:NO];
            }
            break;
        }
    }
    //分佣显示
    _shareRatioView = [MKItemShareRatioView loadFromXib];
    [self insertRow:_shareRatioView withOffSet:0];
    self.shareRatioConstraint = [_shareRatioView autoSetDimension:ALDimensionHeight toSize:39];
    //分佣显示
    if ( [getUserCenter isLogined]
        && [getUserCenter.userInfo.roleMark integerValue] == 2
        && self.item
        && [self.item.gains integerValue] != 0 )
    {
        
        [self chageShowTopMark:YES];
    }else
    {
        [self chageShowTopMark:NO];
    }
    
    //活动
    if (self.discountInfoArrary && self.discountInfoArrary.count) {
        _activeView = [MKItemActivityView loadFromXib];
        self.activeView.activityLabel.text = [self.discountInfoArrary componentsJoinedByString:@";"];
        [self insertRow:_activeView withOffSet:10];
        [_activeView autoSetDimension:ALDimensionHeight toSize:44];
        [_activeView.activityButton addTarget:self action:@selector(showActivityDetail) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //领取优惠券
    if (self.item.couponList.count) {
        _couponView = [MKItemCouponView loadFromXib];
        [self insertRow:_couponView withOffSet:10];
        [_couponView autoSetDimension:ALDimensionHeight toSize:44];
        [_couponView.couponButton addTarget:self action:@selector(showCouponDetail) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //商品标签 picc啦 包邮啦 7天退还啦 wxh备注

    _markView = [MKItemMarkView loadFromXib];
    if (self.item.itemLabelList.count) {
        if (self.item.couponList.count) {
            [self insertRow:_markView withOffSet:10];
        }else {
            [self insertRow:_markView withOffSet:10];
        }
        
        [_markView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
        [_markView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
        [_markView autoSetDimension:ALDimensionHeight toSize:50];
        
        [_markView buildItemMarkViewWithArray:self.item.itemLabelList];
    }
    //选择品牌馆
    if (self.item.itemBrand != nil)
    {
        MKDetailBrandZoneView *zone = [MKDetailBrandZoneView loadFromXib];
        [self insertRow:zone withOffSet:10];
        CGFloat heightZone = 75;
        heightZone +=GetHeightOfString(self.item.itemBrand.brandDesc, Main_Screen_Width-25.0f, [UIFont systemFontOfSize:14.0f]);
        [zone autoSetDimension:ALDimensionHeight toSize:heightZone];
        [zone autoPinEdgeToSuperviewEdge:ALEdgeLeading];
        [zone autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
        zone.title.text = self.item.itemBrand.name;
        [zone.imageView sd_setImageWithURL:[NSURL URLWithString:self.item.itemBrand.logoUrl]
                          placeholderImage:[UIImage imageNamed:@"placeholder_80x80"]];
        zone.contentLabel.text = self.item.itemBrand.brandDesc;
        [zone.button addTarget:self action:@selector(brandButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [zone.inButton addTarget:self action:@selector(brandButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
   
    //货源地
    if ( self.item.itemProperties.count )
    {
        MKDetailAdditionalInfoView *propertiesView = [MKDetailAdditionalInfoView loadFromXib];
        [self insertRow:propertiesView withOffSet:10];
        [propertiesView autoSetDimension:ALDimensionHeight toSize:(32*self.item.itemProperties.count +46)];
        [propertiesView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
        [propertiesView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
        [propertiesView updateItemPropertiesViewWithArray:self.item.itemProperties];
    }
    
    //店铺信息
//    _storeInfoView = [MKStoreInfoView loadFromXib];
//    [self insertRow:_storeInfoView withOffSet:10];
//    
//    [_storeInfoView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
//    [_storeInfoView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
//    [_storeInfoView autoSetDimension:ALDimensionHeight toSize:60];
//    _storeInfoView.storeNameLabel.text = self.item.distributorInfo.shopName;
//    _storeInfoView.storeSignLabel.text = self.item.distributorInfo.distributorSign;
//    [_storeInfoView.storeImageView sd_setImageWithURL:[NSURL URLWithString:self.item.distributorInfo.headImgUrl] placeholderImage:[UIImage imageNamed:@"xiangqingye_dianpu"]];
    
   


    //收藏信息 魔筷应用可能还有其他的信息存放，故遍历，嗨云项目只用到收藏信息，其中“IC_SYS_P_BIZ_000001”表示收场的信息，王新辉备注；
    for (MKBizPropertyObject * bizPropertyItem in self.item.bizProperties) {
        if ([bizPropertyItem.code isEqualToString:@"IC_SYS_P_BIZ_000001"]) {
            if ([bizPropertyItem.value isEqualToString:@"1"]) {
                [self.bottomBar.collectButton setImage:[UIImage imageNamed:@"shoucang_T"] forState:UIControlStateNormal];
                self.isFavorite = YES;
            }
            else{
                self.isFavorite = NO;
            }
        }
    }
    self.bottomBar.collectButton.selected = self.isFavorite;
}

- (void)disablePurchaseAndAddCart:(BOOL)disable
{
    self.bottomBar.addToCartButton.enabled = !disable;
    self.bottomBar.purchaseButton.enabled = !disable;
    
    self.bottomBar.addToCartButton.layer.borderColor = [UIColor colorWithHex:disable ? 0xCCCCCC : 0xFF4B55].CGColor;
    self.bottomBar.purchaseButton.backgroundColor = [UIColor colorWithHex:disable ? 0xCCCCCC : 0xFF4B55];
}

//嗨云项目没有用到王新辉你备注
- (void)fillPrice
{
//        self.baseInfoView.priceLabel.text = [MKBaseItemObject priceString:self.selectedSKU.wirelessPrice];
    if (self.item.skuProperties.count > 1) {
        [self.baseInfoView hideOriginPrice:YES];
    }else {
        [self.baseInfoView hideOriginPrice:NO];
    }
    if (self.skuViewController.allOriginPriceString != nil) {
            self.baseInfoView.originPriceLabel.text = [NSString stringWithFormat:@"¥%@",self.skuViewController.allOriginPriceString];
    }
    
//        self.baseInfoView.originPriceLabel.text = [NSString stringWithFormat:@"¥%@",[MKBaseItemObject priceString:self.selectedSKU.marketPrice]];
        
//        NSString *diss = [MKBaseItemObject discountStringWithPrice1:self.selectedSKU.wirelessPrice andPrice2:self.selectedSKU.marketPrice];
//        self.baseInfoView.discountLabel.text = [NSString stringWithFormat:@"%@折", diss];
//        return;
    
    self.baseInfoView.priceLabel.text = self.skuViewController.allPriceString;
//    if ([self.skuViewController.allOriginPriceString containsString:@"~"]) {
//        
//        NSRange itemRange = [self.skuViewController.allOriginPriceString rangeOfString:@"~"];
//
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.skuViewController.allOriginPriceString];
//        [attributedString addAttribute:NSFontAttributeName value:self.baseInfoView.priceLabel.font range:NSMakeRange(0,self.skuViewController.allOriginPriceString.length)];
//        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(itemRange.location-2,2)];
//        [attributedString addAttribute:NSForegroundColorAttributeName value:kHEXCOLOR(0xff3333) range:itemRange];
//        
//        NSRange baseRange = NSMakeRange(self.skuViewController.allOriginPriceString.length-2,2);
//        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:baseRange];
//        [attributedString addAttribute:NSForegroundColorAttributeName value:kHEXCOLOR(0xff3333) range:baseRange];
//        self.baseInfoView.priceLabel.attributedText = attributedString;
//        
//    }else{
//    [self.baseInfoView.priceLabel HYPriceChangeFont:12.0f colors:kHEXCOLOR(0xff3333) isTop:NO];
    [self.baseInfoView hideOriginPrice:self.skuViewController.allMinDicountString == nil];
    if (self.skuViewController.allMinDicountString == nil)
    {
        return;
    }


}

#pragma mark -更新数据
-(void)onRequest
{
    NSString *itemId = self.itemId == nil ? self.item.itemUid : self.itemId;
    if (itemId == nil)
    {
        [self showExceptionViewWithText:@"商品不存在"];
        return;
    }
    NSDictionary *paramters = @{@"item_uid" :itemId};
    
    [MKNetworking MKSeniorGetApi:@"/item/base/get"
                       paramters:paramters
                      completion:^(MKHttpResponse *response)
     
     {
         if (response.errorMsg != nil)
         {
             if (response.errorType == MKHttpErrorTypeLocal) {
                 [self showExceptionViewWithText:@"网络错误"];
                 return;
             }
             if (response.errorType == MKHttpErrorTypeRemote) {
                 [self showExceptionViewWithText:@"商品已下架/商品不存在"];
                 return;
             }
             [self showExceptionViewWithText:response.errorMsg];
             return ;
         }
         NSMutableDictionary *itemDict = [NSMutableDictionary dictionary];
         
        [itemDict addEntriesFromDictionary:[[response mkResponseData] HYNSDictionaryValueForKey:@"item"]];
         
         NSDictionary *paramter1;
         if ( self.shareUserId )
         {
             paramter1 = @{@"item_uid" :itemId,@"item_type":@([[itemDict HYValueForKey:@"item_type"] integerValue]),@"share_user_id":self.shareUserId};
         }else
         {
             paramter1 = @{@"item_uid" :itemId,@"item_type":@([[itemDict HYValueForKey:@"item_type"] integerValue])};

         }
         [MKNetworking MKSeniorGetApi:@"/item/dynamic/get"
                            paramters:paramter1
                           completion:^(MKHttpResponse *response)
          
          {
              if (response.errorMsg != nil)
              {
                  if (response.errorType == MKHttpErrorTypeLocal) {
                      [self showExceptionViewWithText:@"网络错误"];
                      return;
                  }
                  if (response.errorType == MKHttpErrorTypeRemote) {
                      [self showExceptionViewWithText:@"商品已下架/商品不存在"];
                      return;
                  }
                  [self showExceptionViewWithText:response.errorMsg];
                  return ;
              }
              
              NSMutableDictionary *itemDyna = [NSMutableDictionary dictionaryWithDictionary:[[response mkResponseData] HYNSDictionaryValueForKey:@"item"]];
              /******提取item_sku_list中的价格*******/
              NSMutableDictionary *itemSkuPrice = [NSMutableDictionary dictionary];
              for ( NSDictionary *dict in [itemDyna HYNSArrayValueForKey:@"item_sku_list"] )
              {
                  NSMutableDictionary *priceDic = [NSMutableDictionary dictionary];
                  NSString *keyDict = [dict HYValueForKey:@"sku_uid"];
                 
                  [priceDic HYSetObject:[dict HYValueForKey:@"market_price"] forKey:@"market_price"];
                  [priceDic HYSetObject:[dict HYValueForKey:@"promotion_price"] forKey:@"promotion_price"];
                  [priceDic HYSetObject:[dict HYValueForKey:@"wireless_price"] forKey:@"wireless_price"];
                  
                  [itemSkuPrice setValue:priceDic forKey:keyDict];
              }
              
              [itemDyna removeObjectForKey:@"item_sku_list"];
              [itemDyna removeObjectForKey:@"sku_property_list"];
              
              [itemDict addEntriesFromDictionary:itemDyna];
              
              [MKNetworking MKSeniorGetApi:@"/item/stock/get"
                                 paramters:@{@"item_uid" :itemId}
                                completion:^(MKHttpResponse *response)
               
               {
                   if (response.errorMsg != nil)
                   {
                       if (response.errorType == MKHttpErrorTypeLocal) {
                           [self showExceptionViewWithText:@"网络错误"];
                           return;
                       }
                       if (response.errorType == MKHttpErrorTypeRemote) {
                           [self showExceptionViewWithText:@"商品已下架/商品不存在"];
                           return;
                       }
                       [self showExceptionViewWithText:response.errorMsg];
                       return ;
                   }
                   
                   NSMutableDictionary *itemStock =  [[response mkResponseData] HYNSDictionaryValueForKey:@"item"];
                   
                   NSMutableDictionary *itemStockPrice = [NSMutableDictionary dictionary];//库存价格
                   /******提取item_sku_list中的库存*******/
                   for ( NSDictionary *dict in [itemStock HYNSArrayValueForKey:@"item_sku_list"] )
                   {
                       NSString *keyDict = [dict HYValueForKey:@"sku_uid"];
                       NSMutableDictionary *dic1 = [itemSkuPrice HYNSDictionaryValueForKey:keyDict];
                       if ( dic1 )
                       {
                           [dic1 HYSetObject:[dict HYValueForKey:@"stock_num"] forKey:@"stock_num"];
                       }
                       [itemStockPrice setValue:dic1 forKey:keyDict];
                   }
                   [self refreshNewView:itemDict skuDict:itemStockPrice];
                   
               }];
              
          }];
     }];
}
- (void)loadData
{
    NSString *itemId = self.itemId == nil ? self.item.itemUid : self.itemId;
    if (itemId == nil)
    {
        [self showExceptionViewWithText:@"商品不存在"];
        return;
    }
    NSDictionary *paramters = @{@"item_uid" :itemId};
    if ( self.itemType == 13 )
    {
        paramters = @{@"item_uid" :itemId,@"distributor_id":@"1"};
    }

//    @"distributor_id":self.distributorId?self.distributorId:@""
    //self.itemType == 13秒杀
//    self.itemType == 13?@"/seckill/detail/get" : @"item/get"
      [MKNetworking MKSeniorGetApi:@"/seckill/detail/get"
                         paramters:paramters
                     completion:^(MKHttpResponse *response)

         {
             if (response.errorMsg != nil)
             {
                 if (response.errorType == MKHttpErrorTypeLocal) {
                     [self showExceptionViewWithText:@"网络错误"];
                     return;
                 }
                 if (response.errorType == MKHttpErrorTypeRemote) {
                     [self showExceptionViewWithText:@"商品已下架/商品不存在"];
                     return;
                 }
                 [self showExceptionViewWithText:response.errorMsg];
                 return ;
             }

             
             self.item = [MKItemObject objectWithDictionary:[[response mkResponseData] HYNSDictionaryValueForKey:@"item"]];
             self.item.time = [[response mkResponseData] HYValueForKey:@"time"];
             
             
             if (self.item.higoMark) {
                 self.bottomBar.addToCartButton.hidden = YES;
                 self.bottomBar.addButtonWidth.constant = [UIScreen mainScreen].bounds.size.width - 130;
                 self.baseInfoView.taxMarkImageView.hidden = NO;
             }else {
                 self.bottomBar.addToCartButton.hidden = NO;
                 self.baseInfoView.taxMarkImageView.hidden = YES;
             }
             if (self.itemType == 13) {
                 self.bottomBar.addToCartButton.hidden = YES;
                 self.bottomBar.addButtonWidth.constant = [UIScreen mainScreen].bounds.size.width - 130;
             }
            
             
             [self showNormalView];
     
             [self fillData];
             //分享二维码wxh
//             [self loadCode];
             
//             [self upDataSeckill:self.item.miaoTuanXianOBJ.seckillUid];
             
             [getUserCenter.historyModel newHistoryItem:self.item];
         }];
}
#pragma mark -新的刷新界面
-(void)refreshNewView:(NSMutableDictionary *)itemDict skuDict:(NSMutableDictionary *)skuDict
{
    NSMutableArray *itemSkuNewList = [NSMutableArray array];
    /*****新的库存价格的加入*****/
    for ( NSDictionary *dic1 in [itemDict HYNSArrayValueForKey:@"item_sku_list"] )
    {
        NSMutableDictionary *newSkuId = [NSMutableDictionary dictionaryWithDictionary:dic1];
        if ( [skuDict HYNSDictionaryValueForKey:[dic1 HYValueForKey:@"sku_uid"]] )
        {
            [newSkuId addEntriesFromDictionary:[skuDict HYNSDictionaryValueForKey:[dic1 HYValueForKey:@"sku_uid"]]];
        }
        [itemSkuNewList addObject:newSkuId];
    }
    [itemDict removeObjectForKey:@"item_sku_list"];
    [itemDict setValue:itemSkuNewList forKey:@"item_sku_list"];
    
    self.item = [MKItemObject objectWithDictionary:itemDict];
    
    if (self.item.higoMark) {
        self.bottomBar.addToCartButton.hidden = YES;
        self.bottomBar.addButtonWidth.constant = [UIScreen mainScreen].bounds.size.width - 130;
        self.baseInfoView.taxMarkImageView.hidden = NO;
    }else {
        self.bottomBar.addToCartButton.hidden = NO;
        self.baseInfoView.taxMarkImageView.hidden = YES;
    }
    if (self.itemType == 13) {
        self.bottomBar.addToCartButton.hidden = YES;
        self.bottomBar.addButtonWidth.constant = [UIScreen mainScreen].bounds.size.width - 130;
    }
    
    
    [self showNormalView];
    
    [self fillData];
    
    [getUserCenter.historyModel newHistoryItem:self.item];
}

#pragma mark -二维码获取
-(void)loadCode{

    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    __weak typeof(self) weakSelf = self;
    NSDictionary *paramters=nil;
    if ( [getUserCenter isLogined] )
    {
        paramters = @{@"item_id" : self.itemId,@"share_user_id":@(getUserCenter.userInfo.userId)};
            }else
    {
        paramters = @{@"item_id" : self.itemId,@"share_user_id":@(0)};
    }
    [MKNetworking MKSeniorGetApi:@"item/qrcode/get" paramters:paramters
                      completion:^(MKHttpResponse *response)
     {
         [hud hide:YES];
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
         self.item.qrCode = response.responseDictionary[@"data"];
         [weakSelf showCodeImageView];
     }];

}
- (void)insertRow:(UIView *)view withOffSet:(CGFloat)offset
{
    UIView *v1 = self.insertConstraint.secondItem;
    UIView *v2 = self.insertConstraint.firstItem;
    [self.scrollView removeConstraint:self.insertConstraint];
    [self.scrollView addSubview:view];
    //view.translatesAutoresizingMaskIntoConstraints = NO;
    [view autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [view autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:v1 withOffset:offset];
//    [view autoSetDimension:ALDimensionHeight toSize:65];
    if ([view isKindOfClass:[MKItemDetailBottomBar class]]) {
        [view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:v1 withOffset:0];
    }
    self.insertConstraint = [v2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:view withOffset:10];
    
}

- (void)showExceptionViewWithText:(NSString *)text
{
    self.exceptionView = [MKExceptionView loadFromXib];
    self.exceptionView.exceptionLabel.text = text;
    [self.view insertSubview:self.exceptionView atIndex:0];
    [self.exceptionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)showXianShiGou {
    self.seckilView = [seckilView loadFromXib];
    //将控件修改为限时购格式
    [self.scrollView addSubview:self.seckilView];
    [self.seckilView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.photosViewController.view];
    [self.seckilView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.seckilView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [self.seckilView autoSetDimension:ALDimensionHeight toSize:50];
    _replaceView = self.seckilView;
    
    self.seckilView.miaoshaLab.text = @"限时购";
    self.seckilView.qiangguangLab.hidden = YES;
    if (self.item.miaoTuanXianOBJ.lifecycle == 0) {
        self.seckilView.activePriceView.hidden = NO;
        self.seckilView.priceNameLabel.text = @"活动价";
        self.seckilView.priceLabel.text = [MKBaseItemObject priceString:self.item.promotionPrice];
//        self.seckilView.miaoshaBlockImgV
        self.seckilView.backgroundColor = [UIColor colorWithHex:0xfedada];
        self.seckilView.miaoshaLab.textColor = [UIColor whiteColor];
        self.seckilView.jieshuLab.textColor = [UIColor colorWithHex:0xff2741];
        self.seckilView.priceNameLabel.textColor = [UIColor colorWithHex:0xff2741];
        self.seckilView.priceLabel.textColor = [UIColor colorWithHex:0xff2741];
        self.seckilView.moneyMarkLabel.textColor = [UIColor colorWithHex:0xff2741];
    }else if (self.item.miaoTuanXianOBJ.lifecycle == 1) {
        self.seckilView.activePriceView.hidden = NO;
        self.seckilView.priceNameLabel.text = @"原价";
        self.seckilView.priceLabel.text = [MKBaseItemObject priceString:self.item.promotionPrice];
        self.baseInfoView.priceLabel.text = [MKBaseItemObject priceString:self.item.promotionPrice];
        //        self.seckilView.miaoshaBlockImgV
        self.seckilView.backgroundColor = [UIColor colorWithHex:0xfb6165];
    }
    
    BOOL canBuy = [self.skuViewController isSoldOut] || self.item.status != MKItemStatusSaling;
    if (canBuy) {
        self.seckilView.backgroundColor = [UIColor colorWithHex:0xcccccc];
    }
    
    //限时购倒计时开始
    [_seckilView getPolling:self.item.time.integerValue startTime:self.item.miaoTuanXianOBJ.startTime.integerValue endTime:self.item.miaoTuanXianOBJ.endTime.integerValue lifeCycle:self.item.miaoTuanXianOBJ.lifecycle];
}

#pragma mark -点击领取优惠券界面
- (void)showCouponDetail {
    
    MKBallTierView * ballTierView = [[MKBallTierView alloc]init];
    NSMutableArray *ary = [NSMutableArray array];
    
    for (NSDictionary *dic in self.item.couponList) {
        MKItemDiscountObject *discountObj = [MKItemDiscountObject objectWithDictionary:dic];
        if ([discountObj.marketActivity.toolCode isEqualToString:@"SYS_MARKET_TOOL_000001"]) {
            MKCouponObject *item = [[MKCouponObject alloc] init];
            item.content = discountObj.desc;
            item.couponUid = discountObj.marketActivity.activityUid;
            item.scope = discountObj.marketActivity.scope;
            item.name = discountObj.marketActivity.activityName;
            item.toolCode = discountObj.marketActivity.toolCode;
            item.discountAmount = discountObj.marketActivity.discountAmount;
            item.startTime = discountObj.marketActivity.startTime;
            item.endTime = discountObj.marketActivity.endTime;
            item.propertyList = discountObj.marketActivity.properties;
            [ary addObject:item];
        }
    }
    [ballTierView MKPopUpHierarchywithType:MKPopUpHierarchyCoupon withDataArray:ary];
    [ballTierView show];
}

- (void)showActivityDetail {
    MKBallTierView * ballTierView = [[MKBallTierView alloc]init];
    [ballTierView MKPopUpHierarchywithType:MKPopUpHierarchyReduction withDataArray:self.discountInfoArrary];
    [ballTierView show];
}

- (void)makeDiscountInfoWithArrary:(NSArray *) ary {
    self.discountInfoArrary = [NSMutableArray array];
    NSString *activityName = @"";
    for (NSDictionary *dic in ary) {
        MKItemDiscountObject *itemDiscountObj = [MKItemDiscountObject objectWithDictionary:dic];
        NSString *giftName = @"";
        NSString *couponName = @"";
        if ([itemDiscountObj.marketActivity.toolCode isEqualToString:@"ReachMultipleReduceTool"]) {
            self.bizMark = @"ReachMultipleReduceTool";
            if (itemDiscountObj.giftList.count) {
                NSMutableArray *giftNameAry = [NSMutableArray array];
                for (NSDictionary *dic in itemDiscountObj.giftList) {
                    [giftNameAry addObject:dic[@"item_name"]];
                }
                giftName = [giftNameAry componentsJoinedByString:@"、"];
            }
            
            if (itemDiscountObj.couponList.count) {
                NSMutableArray *couponListAry = [NSMutableArray array];
                for (NSDictionary *dic in itemDiscountObj.couponList) {
                    NSString *couponStr = [NSString stringWithFormat:@"%ld",[dic[@"discount_amount"] integerValue]/100];
                    [couponListAry addObject:couponStr];
                }
                couponName = [couponListAry componentsJoinedByString:@"、"];
            }
            
            NSString *s1 =itemDiscountObj.consume;
            NSString * sv1 = [NSString stringWithFloat:s1.floatValue/100];
            NSString *s2 = itemDiscountObj.discountAmount;
            NSString * sv2 = [NSString stringWithFloat:s2.floatValue/100];
            NSString *s3 = itemDiscountObj.freePostage;
            NSString * sv3 = [NSString stringWithFloat:s3.floatValue/100];
            
            if (![sv3 isEqualToString:@"0"]) {
                activityName = [NSString stringWithFormat:@"满%@减%@元，包邮",sv1,sv2];
                if (itemDiscountObj.giftList.count) {
                    activityName = [NSString stringWithFormat:@"满%@元减%@元,包邮,赠%@",sv1,sv2,giftName];
                    if (itemDiscountObj.couponList.count) {
                        activityName = [NSString stringWithFormat:@"满%@元减%@元,包邮,赠%@,送%@元优惠券",sv1,sv2,giftName,couponName];
                    }
                }else {
                    if (itemDiscountObj.couponList.count) {
                        activityName = [NSString stringWithFormat:@"满%@元减%@元,包邮,送%@元优惠券",sv1,sv2,couponName];
                    }
                }
                
                if ([sv2 isEqualToString:@"0"]) {
                    activityName = [NSString stringWithFormat:@"满%@元包邮",sv1];
                    if (itemDiscountObj.giftList.count != 0) {
                        activityName = [NSString stringWithFormat:@"满%@元包邮,赠%@",sv1,giftName];
                        if (itemDiscountObj.couponList.count) {
                            activityName = [NSString stringWithFormat:@"满%@元包邮,赠%@,送%@元优惠券",sv1,giftName,couponName];
                        }
                    }else {
                        if (itemDiscountObj.couponList.count) {
                            activityName = [NSString stringWithFormat:@"满%@元包邮,送%@元优惠券",sv1,couponName];
                        }
                    }
                }
            }else if ([sv3 isEqualToString:@"0"]) {
                activityName = [NSString stringWithFormat:@"满%@减%@元",sv1,sv2];
                if (itemDiscountObj.giftList.count != 0) {
                    activityName = [NSString stringWithFormat:@"满%@元,赠%@",sv1,giftName];
                    if (itemDiscountObj.couponList.count) {
                        activityName = [NSString stringWithFormat:@"满%@元,赠%@,送%@元优惠券",sv1,giftName,couponName];
                    }
                }else {
                    if (itemDiscountObj.couponList.count) {
                        activityName = [NSString stringWithFormat:@"满%@元,送%@元优惠券",sv1,couponName];
                    }
                }
            }
        
            [self.discountInfoArrary addObject:activityName];
        }
    }
}

#pragma mark -加入购物车
- (void)addToCart
{
    if (![self checkSelectedSKU])
    {
        return;
    }
    
    if (![getUserCenter isLogined])
    {
        self.cartItemObj = [[MKCartItemObject alloc] init];
        self.cartItemObj.number = self.selectedNumber;
        self.cartItemObj.deliveryType = self.item.deliveryType;
        self.cartItemObj.iconUrl = self.item.iconUrl;
        self.cartItemObj.itemName = self.item.itemName;
        self.cartItemObj.itemType = self.item.itemType;
        self.cartItemObj.itemUid = self.item.itemUid;
        self.cartItemObj.marketPrice = self.selectedSKU.marketPrice;
        self.cartItemObj.promotionPrice = self.selectedSKU.promotionPrice;
        self.cartItemObj.wirelessPrice = self.selectedSKU.wirelessPrice;
        self.cartItemObj.saleMinNum = [NSString stringWithFormat:@"%ld",self.item.minSale];
        self.cartItemObj.saleMaxNum = [NSString stringWithFormat:@"%ld",self.item.maxSale];
        self.cartItemObj.status = [NSString stringWithFormat:@"%ld",self.item.status];
        if ( self.selectedSKU.skuProperties.count )
        {
            MKSKUPropertyObject *skuob1 = self.selectedSKU.skuProperties[0];
            if (skuob1.name == nil&&skuob1.value == nil) {
                
                self.cartItemObj.skuSnapshot = nil;
            }else {
                
                if (self.selectedSKU.skuProperties.count == 1) {
                    
                    skuob1 = self.selectedSKU.skuProperties[0];
                    self.cartItemObj.skuSnapshot = [NSString stringWithFormat:@"%@",skuob1.value];
                }
                if (self.selectedSKU.skuProperties.count == 2) {
                    
                    skuob1 = self.selectedSKU.skuProperties[0];
                    MKSKUPropertyObject *skuob2 = self.selectedSKU.skuProperties[1];
                    self.cartItemObj.skuSnapshot = [NSString stringWithFormat:@"%@-%@",skuob1.value,skuob2.value];
                }
            }
        }

        self.cartItemObj.skuUid = self.selectedSKU.skuId;
        //库存字段
        if ( ISNSStringValid(self.bizMark) &&  [self.bizMark isEqualToString:@"TimeRangeDiscount"] )
        {
            if ( self.selectedSKU.limitNumber && self.selectedSKU.limitNumber != 99999 )
            {
                self.cartItemObj.stockNum = self.selectedSKU.stockNum>self.selectedSKU.limitNumber?self.selectedSKU.limitNumber:self.selectedSKU.stockNum;
 
            }else
            {
                self.cartItemObj.stockNum = self.selectedSKU.stockNum;
            }
        }else
        {
            self.cartItemObj.stockNum = self.selectedSKU.stockNum;
        }
        //判断是否是满减送或限时购
        self.cartItemObj.bizMark = self.bizMark;
        [getUserCenter.shopCart newShopCartItem:self.cartItemObj];
        NSArray *arr = [getUserCenter.shopCart lastItemFromIndex:0 count:100];
        NSInteger i = 0;
        for (MKCartItemObject *item in arr) {
            
            i+=item.number;
        }
        getUserCenter.shoppingCartModel.itemCount = i;
        [MBProgressHUD showMessageIsWait:@"加入购物袋成功" wait:YES];
        [self.skuViewController dismiss:nil];
        return;
    }
    
    NSDictionary *paramter;
    if ( self.shareUserId ) {
        paramter = @{@"sku_uid" : self.selectedSKU.skuId,@"number" : @(self.selectedNumber),@"share_user_id":self.shareUserId};
    }else
    {
        paramter = @{@"sku_uid" : self.selectedSKU.skuId,@"number" : @(self.selectedNumber)};
    }
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil wait:YES];
    [MKNetworking MKSeniorPostApi:@"/trade/cart/item/add" paramters:paramter
                       completion:^(MKHttpResponse *response)
    {
        [ hud hide:YES];
        if (response.errorMsg != nil)
        {
            [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
            return ;
        }
        getUserCenter.shoppingCartModel.itemCount += self.selectedNumber;
        [self.bottomBar updateShoppingCountValue:getUserCenter.shoppingCartModel.itemCount];
        [MBProgressHUD showMessageIsWait:@"加入购物袋成功" wait:YES];
        
        [self.skuViewController dismiss:nil];
    }];
}

#pragma mark -立即购买
- (void)purchase
{
    if (![self checkSelectedSKU])
    {
        return;
    }
    
    if (![getUserCenter isLogined])
    {
        [getUserCenter loginoutPullView];
        return;
    }
    
    
    MKConfirmOrderViewController *confirm = [MKConfirmOrderViewController create];
    confirm.orderItemSource = MKOrderItemSourceImmediatelyBuy;
    MKCartItemObject *confirmItem = [[MKCartItemObject alloc] init];
    confirmItem.number = [self.skuViewController getNumber];
    confirmItem.skuUid = self.selectedSKU.skuId;
    confirmItem.promotionPrice = self.item.promotionPrice;
    confirmItem.itemName = self.item.itemName;
   
    confirmItem.wirelessPrice = self.selectedSKU.wirelessPrice;
    confirmItem.iconUrl = self.item.iconUrl;
    confirmItem.deliveryType = self.item.deliveryType;
    confirmItem.itemType = self.item.itemType;
    if ( self.shareUserId ) {
        confirmItem.shareUserId = self.shareUserId;
    }
    confirm.confirmOrderList = [NSMutableArray arrayWithObject:confirmItem];
    [self.navigationController pushViewController:confirm animated:YES];
}

- (BOOL)checkSelectedSKU
{
    NSString *skuUid = self.selectedSKU.skuId;
    NSString *msg = nil;
    do
    {
        if (skuUid == nil)
        {
            NSArray *missTitles = [self.skuViewController getMissSelectionTitles];
            NSMutableString *mm = [NSMutableString stringWithString:@"请选择"];
            for (NSString *t in missTitles)
            {
                [mm appendFormat:@" %@", t];
            }
            msg = [mm copy];
            break;
        }
        if (self.selectedSKU.stockNum == 0)
        {
            msg = @"您选的商品没货了";
            break;
        }
        if (self.selectedNumber > self.selectedSKU.stockNum)
        {
            msg = @"您选的数量超过库存了";
        }
    }
    while (NO);
    if (msg != nil)
    {
        [MBProgressHUD showMessageIsWait:msg wait:YES];
        return NO;
    }
    return YES;
}

#pragma mark - 操作

- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -点击收藏
- (void)favoriteButtonClick:(UIButton *)send
{
    if (![getUserCenter isLogined])
    {
        [getUserCenter loginoutPullView];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil wait:YES];
    NSDictionary *dic;
    if (self.shareUserId) {
        dic = @{@"item_uid":self.item.itemUid,@"share_user_id":self.shareUserId};
    }else
    {
        dic = @{@"item_uid":self.item.itemUid};
  
    }
    
    NSArray *ary = @[dic];
    NSString *string = [ary jsonString];
    [MKNetworking MKSeniorPostApi:self.isFavorite ? @"item/collection/delete" : @"item/collection/add"
                       paramters:@{@"item_list" : string}
                completion:^(MKHttpResponse *response)
    {
        [ hud hide:YES];
        if (response.errorMsg != nil)
        {
            [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
            return ;
        }
        self.isFavorite = !self.isFavorite;
        [MBProgressHUD showMessageIsWait:self.isFavorite ? @"收藏成功" : @"取消收藏成功" wait:YES];
        [self.bottomBar.collectButton setImage:self.isFavorite ? [UIImage imageNamed:@"shoucang_T"] : [UIImage imageNamed:@"shoucang_F"] forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCollectionItemStatusChangedNotification object:nil];
    }];
}

#pragma mark -点击分享
- (IBAction)moreButtonClick:(id)sender
{
    if ( self.isShowTopMark )
    {
        [self shareViewShow];
        
    }else
    {
        [self shareNoViewShow];
    }
    
}
#pragma mark -分享赚钱
-(void)shareViewShow
{
    if ( self.activityView == nil )
    {
        NSString *gainMoney = @"0.00元";
        if ( self.item.gains )
        {
            gainMoney = [NSString stringWithFormat:@"%@",self.item.sharingGains];
        }
        _activityView = [[HYShareActivityView alloc] initWithButtons:@[@(HYSharePlatformTypeWechatSession),@(HYSharePlatformTypeWechatTimeline),@(HYSharePlatformTypeQZone),@(HYSharePlatformTypeSinaWeibo),@(HYSharePlatformTypeQQFriend),@(HYSharePlatformTypeSMS),@(HYSharePlatformTypeCopy)]
                                                               title:@"分享可赚"
                                                                 pay:gainMoney
                                                      shareTypeBlock:^(HYSharePlatformType type)
                         {
                             [self shareMoreActionClickType:type index:0];
                             
                         }];
        [self.activityView show];
    }else
    {
        [self.activityView show];
    }
}

#pragma mark -分享赚钱
-(void)shareNoViewShow
{
    if ( self.activitySharView == nil )
    {
            _activitySharView = [[HYShareActivityView alloc] initWithButtons:@[@(HYSharePlatformTypeWechatSession),@(HYSharePlatformTypeWechatTimeline),@(HYSharePlatformTypeQZone),@(HYSharePlatformTypeSinaWeibo),@(HYSharePlatformTypeQQFriend),@(HYSharePlatformTypeSMS),@(HYSharePlatformTypeCopy)]
                                                      shareTypeBlock:^(HYSharePlatformType type)
                         {
                             [self shareMoreActionClickType:type index:1];
                             
                         }];
        [self.activitySharView show];
    }else
    {
        [self.activitySharView show];
    }
}

#pragma mark -点击加入购物车
- (void)addToCartButtonClick
{
    self.skuViewController.tag = 0;
    self.skuViewController.mode = MKSKUViewControllerModeSubmit;
    [self presentViewController:self.skuViewController animated:NO completion:nil];
}

#pragma mark -秒杀或者选择SKU-立即购买
- (void)purchaseButtonClick
{
    if (![getUserCenter isLogined])
    {
        [getUserCenter loginoutPullView];
        return;
    }
    if (self.itemType==13)
    {
        
        if ([seckillStetue isEqualToString:@"3"]) {
            [UIAlertView showWithTitle:@"提示" message:@"请耐心等待!其他用户正在付款中,如15分钟内未成功付款,活动继续." cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                if (buttonIndex==0) {
                    
                }else{
                  
                }
                
            }];
            
            return;
        }
       
        if ([seckillStetue isEqualToString:@"11"]) {
            
            MKConfirmOrderViewController *confirm = [MKConfirmOrderViewController create];
            confirm.orderItemSource = MKOrderItemSourceImmediatelyBuy;
            MKCartItemObject *confirmItem = [[MKCartItemObject alloc] init];
            confirmItem.number = 1;
            confirmItem.skuUid = [self.item.itemSkus.firstObject skuId];
            confirmItem.promotionPrice = self.item.promotionPrice;
            confirmItem.itemName = self.item.itemName;
            confirmItem.wirelessPrice = [self.item.itemSkus.firstObject wirelessPrice];
            confirmItem.iconUrl = self.item.iconUrl;
            confirmItem.deliveryType = self.item.deliveryType;
            confirmItem.itemType = self.item.itemType;
            if ( self.shareUserId ) {
                confirmItem.shareUserId = self.shareUserId;
            }
            confirm.confirmOrderList = [NSMutableArray arrayWithObject:confirmItem];
            [self.navigationController pushViewController:confirm animated:YES];
            return;
        }
        
//        distributorId = @"1842012";
        //self.itemType == 13秒杀

        MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];

        [MKNetworking MKSeniorPostApi:@"/seckill/apply"
                            paramters:@{@"seckill_uid" : self.item.miaoTuanXianOBJ.seckillUid,
                                        @"distributor_id":@"1",
                                        @"sku_uid":[self.item.itemSkus.firstObject skuId]}
                           completion:^(MKHttpResponse *response)
         {

              [ hud hide:YES];
             if (response.errorMsg != nil)

             {
                 [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
                 return ;
             }
                 MKConfirmOrderViewController *confirm = [MKConfirmOrderViewController create];
                 confirm.orderItemSource = MKOrderItemSourceImmediatelyBuy;
                 MKCartItemObject *confirmItem = [[MKCartItemObject alloc] init];
                 confirmItem.number = 1;
                 confirmItem.skuUid = [self.item.itemSkus.firstObject skuId];
                 confirmItem.promotionPrice = self.item.promotionPrice;
                 confirmItem.itemName = self.item.itemName;
                 confirmItem.wirelessPrice = [self.item.itemSkus.firstObject wirelessPrice];
                 confirmItem.iconUrl = self.item.iconUrl;
                 confirmItem.deliveryType = self.item.deliveryType;
                 confirmItem.itemType = self.item.itemType;
                 if ( self.shareUserId ) {
                     confirmItem.shareUserId = self.shareUserId;
                 }
            
                 confirm.confirmOrderList = [NSMutableArray arrayWithObject:confirmItem];
                 [self.navigationController pushViewController:confirm animated:YES];
            
              self.bottomBar.purchaseButton.userInteractionEnabled=YES;
              self.bottomBar.purchaseButton.backgroundColor=[UIColor colorWithHexString:@"FF2741"];
             [self.bottomBar.purchaseButton setTitle:@"去结算" forState:UIControlStateNormal];

         }];
        
        
    }
    else
    {
        self.skuViewController.tag = 1;
        self.skuViewController.mode = MKSKUViewControllerModeSubmit;
        [self presentViewController:self.skuViewController animated:NO completion:nil];
    }
}

#pragma makr -点击购物车
- (void)cartButtonClick
{
    
    MKShoppingCartViewController *shoppingCart = [MKShoppingCartViewController create];
    [self.navigationController pushViewController:shoppingCart animated:YES];
}

- (void)shareMoreActionClickType:(NSInteger)types index:(NSInteger)index
{
    if ( types == 4 )
    {
        if ( index == 0 )
        {
            [self.activityView hide];
        }else
        {
            [self.activitySharView hide];
        }
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        if ( [getUserCenter isLogined] )
        {
            pasteboard.string = [NSString stringWithFormat:@"%@/detail.html?item_uid=%@&share_user_id=%ld&item_type=%ld",BaseHtmlURL, self.item.itemUid,(long)getUserCenter.userInfo.userId,(long)self.itemType];
        }else
        {
            pasteboard.string = [NSString stringWithFormat:@"%@/detail.html?item_uid=%@&item_type=%ld",BaseHtmlURL, self.item.itemUid,(long)self.itemType];
        }
        
        [MBProgressHUD showMessageIsWait:@"复制成功" wait:YES];
        return;
    }
    if ( types == 8 )
    {
        if ( index == 0 )
        {
            [self.activityView hide];
        }else
        {
            [self.activitySharView hide];
        }
        NSString *sharStr =@"";
        if ( [getUserCenter isLogined] )
        {
            sharStr = [NSString stringWithFormat:@"%@/detail.html?item_uid=%@&share_user_id=%ld&item_type=%ld",BaseHtmlURL, self.item.itemUid,(long)getUserCenter.userInfo.userId,(long)self.itemType];
        }else
        {
            sharStr = [NSString stringWithFormat:@"%@/detail.html?item_uid=%@&item_type=%ld",BaseHtmlURL, self.item.itemUid,(long)self.itemType];
        }
        [[HYThreeDealMsg sharedInstance] shareInfoWithMessage:sharStr type:8];
        return;
    }
    if (self.item.itemImages.count > 0)
    {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:self.photosViewController.imageUrls[0]] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            HYShareInfo *info = [[HYShareInfo alloc] init];
            info.title = self.item.itemName;
            info.content = self.item.distributorInfo.shopName;
            
            if ( [getUserCenter isLogined] ) {
                  info.url = [NSString stringWithFormat:@"%@/detail.html?item_uid=%@&share_user_id=%ld&item_type=%ld",BaseHtmlURL, self.item.itemUid,(long)getUserCenter.userInfo.userId,(long)self.itemType];
            }else{
                info.url = [NSString stringWithFormat:@"%@/detail.html?item_uid=%@&item_type=%ld",BaseHtmlURL, self.item.itemUid,(long)self.itemType];
            }
            info.type = (HYPlatformType)types;
            info.shareType = HYShareDKContentTypeWebPage;
            image = [image resizedImageWithMaximumSize:CGSizeMake(100, 100)];
            info.images = image;
            info.image = self.photosViewController.imageUrls[0];
            [HYShareKit shareInfoWith:info completion:^(NSString *errorMsg)
             {
                 if ( ISNSStringValid(errorMsg) )
                 {
                     [MBProgressHUD showMessageIsWait:errorMsg wait:YES];
                 }
                 if ( index == 0 )
                 {
                     [self.activityView hide];
                 }else
                 {
                     [self.activitySharView hide];
                 }
                 
             }];
        }];
    }
    else
    {
        HYShareInfo *info = [[HYShareInfo alloc] init];
        info.title = self.item.itemName;
        info.content = self.item.distributorInfo.shopName;
        
        if ( [getUserCenter isLogined] ) {
            info.url = [NSString stringWithFormat:@"%@/detail.html?item_uid=%@&share_user_id=%ld&item_type=%ld",BaseHtmlURL, self.item.itemUid,(long)getUserCenter.userInfo.userId,(long)self.itemType];
        }else{
            info.url = [NSString stringWithFormat:@"%@/detail.html?item_uid=%@&item_type=%ld",BaseHtmlURL, self.item.itemUid,(long)self.itemType];
        }
        info.type = (HYPlatformType)types;
        info.shareType = HYShareDKContentTypeWebPage;
        [HYShareKit shareInfoWith:info completion:^(NSString *errorMsg)
         {
             if ( ISNSStringValid(errorMsg) )
             {
                 [MBProgressHUD showMessageIsWait:errorMsg wait:YES];
             }
             if ( index == 0 )
             {
                 [self.activityView hide];
             }else
             {
                 [self.activitySharView hide];
             }
         }];
    }
}

- (void)chooseSKUButtonClick
{
    self.skuViewController.mode = MKSKUViewControllerModePurchase;
    [self presentViewController:self.skuViewController animated:NO completion:nil];
}

- (IBAction)backToHome:(id)sender
{
    [getMainTabBar guideToHome];
}

#pragma mark -进入品牌馆
- (void)brandButtonClick:(UIButton *)button
{
    MKProductListViewController *plv = [MKProductListViewController create];
    plv.brandId = self.item.itemBrand.brandId;
    plv.isSearch=NO;
    [self.navigationController pushViewController:plv animated:YES];
}
#pragma mark - sku操作

- (void)skuViewControllerDidSubmit:(MKSKUViewController *)viewController
{
    self.selectedSKU = [viewController getSelectSKU];
    self.selectedNumber = [viewController getNumber];
    if (viewController.tag == 1)
    {
        [viewController dismiss:^
         {
             [self purchase];
         }];
    }
    else
    {
        [self addToCart];
    }
}

- (void)skuViewControllerDidPurchase:(MKSKUViewController *)viewController
{
    self.selectedSKU = [viewController getSelectSKU];
    self.selectedNumber = [viewController getNumber];
    [viewController dismiss:^
     {
         [self purchase];
     }];
}

- (void)skuViewControllerDidAddToCart:(MKSKUViewController *)viewController
{
    self.selectedSKU = [viewController getSelectSKU];
    self.selectedNumber = [viewController getNumber];
    [self addToCart];
}

- (void)skuViewControllerDidClose:(MKSKUViewController *)viewController
{
    self.selectedSKU = [viewController getSelectSKU];
    self.selectedNumber = [viewController getNumber];
    
    if (self.selectedSKU == nil)
    {
        NSArray *a = [self.skuViewController getPropertyTitles];
        NSMutableString *ss = [NSMutableString stringWithString:@"请选择"];
        for (NSString *s in a)
        {
            [ss appendFormat:@" %@", s];
        }
        //        self.chooseSKUButtonView.title.text = ss;
    }
    else
    {
        NSMutableString *s = [NSMutableString stringWithString:@"已选择"];
        for (MKSKUPropertyObject *skp in self.selectedSKU.skuProperties)
        {
            [s appendFormat:@" \"%@\"", skp.value];
        }
        //        self.chooseSKUButtonView.title.text = s;
    }
    [self fillPrice];
}

- (void)skuViewControllerViewDidLoad:(MKSKUViewController *)viewController
{
    viewController.titleLabel.text = self.item.itemName;
    if (self.item.itemImages.count <= 0)
    {
        return;
    }
    MKItemImageObject *imo = self.item.itemImages[0];
    [viewController.iconView sd_setImageWithURL:[NSURL URLWithString:imo.imageUrl]
                               placeholderImage:[UIImage imageNamed:@"placeholder_60x60"]];
}


#pragma mark - 回调
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    
    CGFloat alpa = y / 300;
    
    if (alpa < 0)
    {
        alpa = 0;
    }
    if (alpa > 1)
    {
        alpa = 1;
    }
    self.topBarBackground.alpha = alpa;
    
    self.topBarContentView.alpha = MAX(1 - alpa, alpa);
    
    if (alpa < 0.5)
    {
        [self.backButton setImage:[UIImage imageNamed:@"backButtonNormal"] forState:UIControlStateNormal];
        
        
        self.backButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
        
        if ( !self.isShowTopMark )
        {
            [self.shareButton setImage:[UIImage imageNamed:@"fenxiang_bai"] forState:UIControlStateNormal];
        
        
            self.shareButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
        }
        
    }
    else
    {
        [self.backButton setImage:[UIImage imageNamed:@"backButtonHighlight"] forState:UIControlStateNormal];
        
        
        self.backButton.backgroundColor = [UIColor clearColor];
        
        if ( !self.isShowTopMark )
        {
            [self.shareButton setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
        
            self.shareButton.backgroundColor = [UIColor clearColor];
        }
        
    }
    
    if ([self preferredStatusBarStyle] != [UIApplication sharedApplication].statusBarStyle)
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    if (y > scrollView.contentSize.height - scrollView.frame.size.height -
        scrollView.frame.size.height * 0.25 && scrollView.scrollEnabled)
    {
        scrollView.scrollEnabled = NO;
        [scrollView setContentOffset:CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height) animated:YES];
        [self.detailViewController enableScroll:YES];
    }
    else if (y < scrollView.contentSize.height - scrollView.frame.size.height - scrollView.frame.size.height * 0.5 && !scrollView.scrollEnabled)
    {
        scrollView.scrollEnabled = YES;
        [self.detailViewController enableScroll:NO];
    }
}

- (void)detailDetailViewControllerNeedScrollToTop
{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)isMoreThanOneLineWithHeightForWidth:(CGFloat)width usingFont:(UIFont *)font string:(NSString *)string
{
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize labelSize = (CGSize){width, FLT_MAX};
    CGRect r = [string boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:context];
    if(r.size.height > 20)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
