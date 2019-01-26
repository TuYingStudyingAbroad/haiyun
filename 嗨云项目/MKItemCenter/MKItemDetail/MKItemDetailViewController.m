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
#import "HYShareKit.h"
#import "MKBizPropertyObject.h"
#import "MKCollectionItem.h"
#import "UDChatViewController.h"
#import "MKCartItemObject.h"
#import "MKStoreInfoView.h"
#import "MKShareCodeView.h"
#import "NSDictionary+MKExtension.h"
#import "MKSellerIdSingleton.h"
#import "HYShareInfo.h"

@interface MKItemDetailViewController () <UIScrollViewDelegate, MKDetailDetailViewController, MKSKUViewControllerDelegate>

@property (nonatomic, strong) MKDetailPhotosViewController *photosViewController;

@property (nonatomic, strong) MKDetailBaseInfoView *baseInfoView;

@property (nonatomic, strong) MKDetailDetailViewController *detailViewController;

@property (nonatomic, strong) MKSKUViewController *skuViewController;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) MKItemDetailBottomBar *bottomBar;

@property (nonatomic, strong) MKItemObject *item;

//topBar
@property (nonatomic, strong) IBOutlet UIView *topBarView;

@property (nonatomic, strong) IBOutlet UIView *topBarBackground;

@property (nonatomic, strong) IBOutlet UIView *topBarContentView;

@property (nonatomic, strong) IBOutlet UIButton *backButton;

@property (nonatomic, strong) IBOutlet UIButton *favoriteButton;

@property (nonatomic, strong) IBOutlet UIButton *moreButton;

@property (nonatomic, strong) HYShareActivityView *activityView;

@property (nonatomic, strong) MKExceptionView *exceptionView;

@property (nonatomic, assign) BOOL isFavorite;

@property (nonatomic, strong) NSLayoutConstraint *insertConstraint;

@property (nonatomic, strong) MKItemSKUObject *selectedSKU;

@property (nonatomic, assign) NSInteger selectedNumber;

@property (nonatomic, strong) MKDetailChooseSKUButtonView *chooseSKUButtonView;

@property (nonatomic, strong) MKItemDetailTipView *tipView;

@property (nonatomic,strong)UIView *backView;
@property (nonatomic, strong) MKShareCodeView *shareView;


@end


@implementation MKItemDetailViewController

- (void)dealloc
{
    [getUserCenter.shoppingCartModel removeObserver:self forKeyPath:@"itemCount"];
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
    
    self.moreButton.layer.cornerRadius = 15.0;
    self.moreButton.clipsToBounds = YES;
    
    self.selectedNumber = 1;
    
    [self layoutViews];
    [self loadData];
    
    [getUserCenter.shoppingCartModel addObserver:self forKeyPath:@"itemCount" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isConfiguration) {
        self.backButton.hidden = YES;
    }else {
        self.backButton.hidden = NO;
    }
     NSDictionary *pareameters;
    if (!getUserCenter.userInfo) {
        NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
        pareameters = @{@"user":@{
                                @"nick_name":@"游客",
                                @"sdk_token":identifierForVendor
                                }
                        };
    }else{
        pareameters = @{@"user":@{
                                @"nick_name":getUserCenter.userInfo.userName,
                                @"sdk_token":getUserCenter.accountInfo.accessToken
                                }
                        };
    }
    
    [UDManager createCustomer:pareameters completion:^(NSString *customerId, NSError *error) {
        //提交用户设备信息
        [UDManager submitCustomerDevicesInfo:^(id responseObject, NSError *error) {
        }];
        //获取用户登录信息
        [UDManager getCustomerLoginInfo:^(NSDictionary *loginInfoDic, NSError *error) {
        }];
    }];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self enableSwipeBackWhenNavigationBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return (self.scrollView.contentOffset.y > 150 || !self.exceptionView.hidden) ?
            UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"itemCount"])
    {
        [self.bottomBar updateShoppingCountValue:getUserCenter.shoppingCartModel.itemCount];
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
    
    self.baseInfoView = [MKDetailBaseInfoView loadFromXib];
    [self.scrollView addSubview:self.baseInfoView];
    [self.baseInfoView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:photoView];
    [self.baseInfoView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.baseInfoView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [self.baseInfoView autoSetDimension:ALDimensionHeight toSize:110];
    
    self.detailViewController = [[MKDetailDetailViewController alloc] init];
    self.detailViewController.delegate = self;
    [self addChildViewController:self.detailViewController];
    UIView *v = self.detailViewController.view;
    [self.scrollView addSubview:v];
    self.insertConstraint = [v autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.baseInfoView withOffset:5];
    [v autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [v autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [v autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.scrollView
               withOffset:-self.topBarBackground.frame.size.height];
    [self.scrollView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:v];
    [self.baseInfoView.shareCodeButton addTarget:self action:@selector(showCodeImageView) forControlEvents:UIControlEventTouchUpInside];
}

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
    [self.shareView autoSetDimension:ALDimensionWidth toSize:self.view.bounds.size.width - 40];
    [self.shareView autoSetDimension:ALDimensionHeight toSize:540];
    [self.shareView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:20];
    [self.shareView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view];
    self.shareView.closeButton.layer.cornerRadius = 15;
    self.shareView.closeButton.layer.masksToBounds = YES;
    
    MKItemImageObject *item = self.item.itemImages[0];
    self.shareView.itemNameLabel.text = self.item.itemName;
    self.shareView.itemPriceLabel.text = [MKBaseItemObject priceString:self.item.wirelessPrice];
    [self.shareView.codeImageVIew sd_setImageWithURL:[NSURL URLWithString:self.item.qrCode]];
    [self.shareView.itemMainImageView sd_setImageWithURL:[NSURL URLWithString:item.imageUrl]];
}

- (void)shareToWeChat:(UIButton *) button
{
    HYShareInfo *info = [[HYShareInfo alloc] init];
    info.content = self.item.itemName;
    info.image = [self catchScreen];
    info.type = HYPlatformTypeWeixiSession;
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil wait:YES];
    [HYShareKit shareInfoWith:info completion:^(NSString *errorMsg)
     {
         [hud hide:YES];
         if (errorMsg == nil)
         {
             errorMsg = @"分享成功";
         }
         [MBProgressHUD showMessageIsWait:errorMsg wait:YES];
     }];
}

- (void)saveCodeInphone:(UIButton *) button {
    UIImageWriteToSavedPhotosAlbum([self catchScreen], nil, nil, nil);
}

- (void)closeShareCodeView :(UIButton *) btn {
    [self.backView removeFromSuperview];
}

- (UIImage *)catchScreen
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.shareView.bounds.size.width, self.shareView.mainView.bounds.size.height - 80), YES, 0);
    //设置截屏大小
    @try{
        [self.shareView.mainView.layer renderInContext:UIGraphicsGetCurrentContext()];
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
    self.moreButton.hidden = NO;
    
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

- (void)fillData
{
    NSMutableArray *imageArray = [NSMutableArray array];
    for (MKItemImageObject *d in self.item.itemImages)
    {
        if (d.type == 2) {
            continue;
        }
        
        [imageArray addObject:d.imageUrl];
    }
    self.photosViewController.imageUrls = imageArray;
    
    if (self.item.higoMark) {
        if (self.item.higoExtraInfo.supplyBaseIcon) {
            [self.baseInfoView.supplyImageView sd_setImageWithURL:[NSURL URLWithString:self.item.higoExtraInfo.supplyBaseIcon] placeholderImage:nil];
        }
        self.baseInfoView.titleLabel.text = [NSString stringWithFormat:@"        %@",self.item.itemName];
    }else {
        self.baseInfoView.titleLabel.text = [NSString stringWithFormat:@"%@",self.item.itemName];
        self.baseInfoView.supplyImageView.hidden = YES;
    }
    
    
    [self.detailViewController loadItem:self.item];
    
    [self.skuViewController loadItem:self.item];
    
    [self fillPrice];
    
    BOOL cannotBuy = [self.skuViewController isSoldOut] || self.item.status != MKItemStatusSaling;
    if (cannotBuy)
    {
        self.tipView = [MKItemDetailTipView loadFromXib];
        [self.view addSubview:self.tipView];
        [self.tipView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
        [self.tipView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
        [self.tipView autoSetDimension:ALDimensionHeight toSize:40];
        [self.tipView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.bottomBar];
        
        if (self.item.status != MKItemStatusSaling)
        {
            self.tipView.textLabel.text = [MKItemObject stringWithStatus:self.item.status];
        }
    }
    
    [self disablePurchaseAndAddCart:cannotBuy];
    [self.skuViewController disablePurchaseAndAddCart:cannotBuy];
    
    NSMutableDictionary *pd = [NSMutableDictionary dictionary];
    NSSet *set = [NSSet setWithObjects:MKItemPropertyKeyBrand, MKItemPropertyKeyDeliveryMethod, MKItemPropertyKeySource, nil];
    for (MKItemPropertyObject *po in self.item.itemProperties)
    {
        if ([set containsObject:po.code] && po.value.length > 0)
        {
            pd[po.code] = po;
        }
    }
    
    if (pd.count > 0)
    {
        MKDetailAdditionalInfoView *daiv = [MKDetailAdditionalInfoView loadFromXib];
        
        [daiv updateContents:pd];
        [self insertRow:daiv];
    }
    
    
    //商品标签
    UIView *LayoutLeftView = [[UIView alloc] init];
    UIView *itemMarkView = [[UIView alloc] init];
    if (self.item.itemLabelList.count) {
        for (int i ; i < self.item.itemLabelList.count; i++) {
            UILabel * label = [[UILabel alloc] init];
            [itemMarkView addSubview:label];
            [label autoCenterInSuperview];
            if (LayoutLeftView == nil) {
                
            }else {
                [label autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:LayoutLeftView];
            }
        }
        [self insertRow:itemMarkView];
    }
    
    //店铺信息
    MKStoreInfoView *storeInfoView = [MKStoreInfoView loadFromXib];
    [self insertRow:storeInfoView];
    [storeInfoView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.baseInfoView withOffset:10];
    [storeInfoView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [storeInfoView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [storeInfoView autoSetDimension:ALDimensionHeight toSize:60];
    storeInfoView.storeNameLabel.text = self.item.distributorInfo.shopName;
    storeInfoView.storeSignLabel.text = self.item.distributorInfo.distributorSign;
    //选择或展示sku信息
//    MKDetailChooseSKUButtonView *choose = [MKDetailChooseSKUButtonView loadFromXib];
//    [choose autoSetDimension:ALDimensionHeight toSize:35];
//    [choose.button addTarget:self action:@selector(chooseSKUButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self insertRow:choose];
//    self.chooseSKUButtonView = choose;
//    if (self.item.itemSkus.count == 1)
//    {
//        self.selectedSKU = self.item.itemSkus[0];
//        NSMutableString *s = [NSMutableString stringWithString:@"已选择"];
//        for (MKSKUPropertyObject *skp in self.selectedSKU.skuProperties)
//        {
//            [s appendFormat:@" \"%@\"", skp.value];
//        }
//        choose.title.text = s;
//    }
//    else
//    {
//        NSArray *a = [self.skuViewController getPropertyTitles];
//        NSMutableString *ss = [NSMutableString stringWithString:@"请选择"];
//        for (NSString *s in a)
//        {
//            [ss appendFormat:@" %@", s];
//        }
//        choose.title.text = ss;
//    }
    
    if (self.item.itemBrand != nil)
    {
        MKDetailBrandZoneView *zone = [MKDetailBrandZoneView loadFromXib];
        zone.title.text = self.item.itemBrand.name;
        [zone.imageView sd_setImageWithURL:[NSURL URLWithString:self.item.itemBrand.logoUrl]
                          placeholderImage:[UIImage imageNamed:@"placeholder_80x40"]];
        [zone.button addTarget:self action:@selector(brandButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self insertRow:zone];
    }

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

- (void)fillPrice
{
    if (self.selectedSKU != nil)
    {
        self.baseInfoView.priceLabel.text = [MKBaseItemObject priceString:self.selectedSKU.wirelessPrice];
        if (self.selectedSKU.marketPrice == self.selectedSKU.wirelessPrice)
        {
            [self.baseInfoView hideOriginPrice:YES];
            return;
        }
        [self.baseInfoView hideOriginPrice:NO];
        self.baseInfoView.originPriceLabel.text = [MKBaseItemObject priceString:self.selectedSKU.marketPrice];
        
//        NSString *diss = [MKBaseItemObject discountStringWithPrice1:self.selectedSKU.wirelessPrice andPrice2:self.selectedSKU.marketPrice];
//        self.baseInfoView.discountLabel.text = [NSString stringWithFormat:@"%@折", diss];
        return;
    }
    self.baseInfoView.priceLabel.text = self.skuViewController.allPriceString;
    [self.baseInfoView hideOriginPrice:self.skuViewController.allMinDicountString == nil];
    if (self.skuViewController.allMinDicountString == nil)
    {
        return;
    }
    self.baseInfoView.originPriceLabel.text = self.skuViewController.allOriginPriceString;
//    self.baseInfoView.discountLabel.text = [NSString stringWithFormat:@"%@折", self.skuViewController.allMinDicountString];
}

- (void)loadData
{
    NSString *itemId = self.itemId == nil ? self.item.itemUid : self.itemId;
    if (itemId == nil)
    {
        [self showExceptionViewWithText:@"商品不存在"];
        return;
    }
    if (self.type == 1) {
        self.distributorId = [MKSellerIdSingleton sellerIdSingleton].sellerId;
    }else if(self.type == 0){
        
    }
    [MKNetworking enableLog];
    [MKNetworking MKSeniorGetApi:@"item/get" paramters:@{@"item_uid" : itemId,@"distributor_id":self.distributorId}
                completion:^(MKHttpResponse *response)
    {
        
        if (response.errorMsg != nil)
        {
            [self showExceptionViewWithText:response.errorMsg];
            return ;
        }
        
        self.item = [MKItemObject objectWithDictionary:[response mkResponseData][@"item"]];
        
        [self showNormalView];
        
        [self fillData];
        
        [getUserCenter.historyModel newHistoryItem:self.item];
    }];
}

- (void)insertRow:(UIView *)view
{
    UIView *v1 = self.insertConstraint.secondItem;
    UIView *v2 = self.insertConstraint.firstItem;
    [self.scrollView removeConstraint:self.insertConstraint];
    [self.scrollView addSubview:view];
    //view.translatesAutoresizingMaskIntoConstraints = NO;
    [view autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [view autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:v1 withOffset:([view isKindOfClass:[MKDetailBrandZoneView class]]) ? 5 : 0];
    if([view isKindOfClass:[MKDetailBrandZoneView class]])
    {
        [view autoSetDimension:ALDimensionHeight toSize:65];
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

- (void)addToCart
{
    if (![self checkSelectedSKU])
    {
        return;
    }
    
    if (getUserCenter.accountInfo.accessToken == nil)
    {
        [getUserCenter loginout];
        return;
    }
    if (self.type == 1) {
        self.distributorId = [MKSellerIdSingleton sellerIdSingleton].sellerId;
    }else if(self.type == 0){
        
    }
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil wait:YES];
    [MKNetworking MKSeniorPostApi:@"/trade/cart/item/add" paramters:@{@"sku_uid" : self.selectedSKU.skuId,@"number" : @(self.selectedNumber),@"distributor_id":self.distributorId}
                       completion:^(MKHttpResponse *response)
    {
        [hud hide:YES];
        if (response.errorMsg != nil)
        {
            [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
            return ;
        }
        getUserCenter.shoppingCartModel.itemCount += self.selectedNumber;
        [MBProgressHUD showMessageIsWait:@"加入购物车成功" wait:YES];
        
        [self.skuViewController dismiss:nil];
    }];
}

- (void)purchase
{
    if (![self checkSelectedSKU])
    {
        return;
    }
    
    if (getUserCenter.accountInfo.accessToken == nil)
    {
        [getUserCenter loginout];
        return;
    }
    
    NSString *distributorId = [MKSellerIdSingleton sellerIdSingleton].sellerId;
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
    confirmItem.distributorId = distributorId;
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

//- (void)showLoginViewController:(void (^)())successBlock
//{
//    MKLoginViewController *lgc = [MKLoginViewController create];
//    lgc.successBlock = successBlock;
//    UIViewController *v = self;
//    if (self.presentedViewController != nil)
//    {
//        v = self.presentedViewController;
//    }
//    [v presentViewController:[[UINavigationController alloc] initWithRootViewController:lgc] animated:YES completion:nil];
//}

#pragma mark - 操作

- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)favoriteButtonClick:(UIButton *)send
{
    if (![getUserCenter isLogined])
    {
//        [self showLoginViewController:^
//        {
//            [self favoriteButtonClick:nil];
//        }];
        [getUserCenter loginout];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil wait:YES];
    NSDictionary *dic = @{@"item_uid":self.item.itemUid,@"distributor_id":self.item.distributorInfo.distributorId};
    NSArray *ary = @[dic];
    NSString *string = [ary jsonString];
    [MKNetworking MKSeniorPostApi:self.isFavorite ? @"item/collection/delete" : @"item/collection/add"
                       paramters:@{@"item_list" : string}
                completion:^(MKHttpResponse *response)
    {
        [hud hide:YES];
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

- (IBAction)moreButtonClick:(id)sender
{
    if ( self.activityView == nil )
    {
        _activityView = [[HYShareActivityView alloc] initWithButtons:@[@(HYSharePlatformTypeWechatSession),@(HYSharePlatformTypeWechatTimeline),@(HYSharePlatformTypeQZone),@(HYSharePlatformTypeSinaWeibo),@(HYSharePlatformTypeQQFriend),@(HYSharePlatformTypeCallService),@(HYSharePlatformTypeToMain)] shareTypeBlock:^(HYSharePlatformType type)
                         {
                             
                             [self shareMoreActionClickType:type];
                             
                         }];
        [self.activityView show];
    }else
    {
        [self.activityView show];
    }
}

- (void)addToCartButtonClick
{
    self.skuViewController.tag = 0;
    self.skuViewController.mode = MKSKUViewControllerModeSubmit;
    [self presentViewController:self.skuViewController animated:NO completion:nil];
}

- (void)purchaseButtonClick
{
    self.skuViewController.tag = 1;
    self.skuViewController.mode = MKSKUViewControllerModeSubmit;
    [self presentViewController:self.skuViewController animated:NO completion:nil];
}

- (void)cartButtonClick
{
    if (![getUserCenter isLogined])
    {
//        [self showLoginViewController:^
//        {
//            [self cartButtonClick];
//        }];
        [getUserCenter loginout];
        return;
    }
    MKShoppingCartViewController *shoppingCart = [MKShoppingCartViewController create];
    [self.navigationController pushViewController:shoppingCart animated:YES];
}

- (void)shareMoreActionClickType:(NSInteger)types
{
    if ( types == 6 )
    {
        [self.activityView hide];
        [self backToHome:nil];
        return;
    }
    if ( types == 7 )
    {
        [self.activityView hide];
        @try {
            UDChatViewController *chat = [[UDChatViewController alloc] init];
            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:chat];
            [self presentViewController:na animated:YES completion:^{
                
            }];
        }
        @catch (NSException *exception) {

        }
        @finally {
            
        }
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
        return;
    }
    HYShareInfo *info = [[HYShareInfo alloc] init];
    info.content = self.item.itemName;
    if (self.item.itemImages.count > 0)
    {
        info.image = [(MKItemImageObject *)self.item.itemImages[0] imageUrl];
    }
    info.url = [NSString stringWithFormat:@"http://api.haiyn.com/detail.html?item_uid=%@", self.item.itemUid];
    info.type = (HYPlatformType)types;
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil wait:YES];
    [HYShareKit shareInfoWith:info completion:^(NSString *errorMsg)
    {
        [hud hide:YES];

        if (errorMsg == nil)
        {
            errorMsg = @"分享成功";
        }
        [MBProgressHUD showMessageIsWait:errorMsg wait:YES];
        [self.activityView hide];

    }];
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

- (void)brandButtonClick:(UIButton *)button
{
    MKProductListViewController *plv = [MKProductListViewController create];
    plv.brandId = self.item.itemBrand.brandId;
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
    
    if (!self.isFavorite)
    {
        if (alpa < 0.5)
        {
            [self.backButton setImage:[UIImage imageNamed:@"backButtonNormal"] forState:UIControlStateNormal];
            
            [self.moreButton setImage:[UIImage imageNamed:@"fenxiang_bai"] forState:UIControlStateNormal];
            
            self.backButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
            
            self.moreButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
        }
        else
        {
            [self.backButton setImage:[UIImage imageNamed:@"backButtonHighlight"] forState:UIControlStateNormal];
            
            [self.moreButton setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
            
            self.backButton.backgroundColor = [UIColor clearColor];
            
            self.moreButton.backgroundColor = [UIColor clearColor];
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

@end
