//
//  MKSKUViewController.m
//  YangDongXi
//
//  Created by cocoa on 15/4/28.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKSKUViewController.h"
#import "MKItemObject.h"
#import "UIColor+MKExtension.h"
#import "NSString+MKExtension.h"
#import "MBProgressHUD+MKExtension.h"
#import <NYXImagesKit.h>
#import <PureLayout.h>
#import "MKSKUPropertyObject.h"
#import "MKSKUTypeView.h"
#import "MKNumberEditView.h"
#import "MKOperationSKUPropertyObject.h"
#import "MKStrikethroughLabel.h"

#import <UIImageView+WebCache.h>


#define maxScrollViewHeight 190

@interface MKSKUViewController () <MKSKUTypeViewDelegate>

@property (nonatomic, strong) MKItemObject *item;

@property (nonatomic, strong) NSArray *skus;

@property (nonatomic, strong) NSArray *properties;

@property (nonatomic, assign) BOOL isSoldOut;

@property (nonatomic, strong) NSMutableArray *selectedSkus;

@property (nonatomic, strong) NSArray *propertyViews;

@property (nonatomic, strong) IBOutlet UIButton *submitButton;

@property (nonatomic, strong) IBOutlet UIButton *purchaseButton;

@property (nonatomic, strong) IBOutlet UIButton *addToCartButton;

@property (nonatomic, strong) IBOutlet UIButton *closeButton;

@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, strong) IBOutlet UIButton *coverButton;

@property (nonatomic, strong) IBOutlet UIView *mainView;

@property (nonatomic, strong) IBOutlet UIView *scrollContentView;

@property (weak, nonatomic) IBOutlet UIView *topSeperate;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *scrollContentViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *supplyAreaLabel;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) IBOutlet MKNumberEditView *numberEditView;

@property (nonatomic, strong) IBOutlet UILabel *priceLabel;

@property (strong,nonatomic) IBOutlet UILabel *tipLabel;

@property (nonatomic, strong) IBOutlet MKStrikethroughLabel *originPriceLabel;

@property (nonatomic, strong) NSTimer *plusButtonLongPressTimer;

@property (nonatomic, strong) NSTimer *minusButtonLongPressTimer;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *scrollViewHeightLayout;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *mainViewPinBottomLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taxLimitHeight;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *backgroundPinTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taxesDetailViewBottom;
@property (weak, nonatomic) IBOutlet UILabel *taxesDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *taxesDetailView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberViewHeight;

@property (nonatomic, strong) NSString *allPriceString;

@property (nonatomic, strong) NSString *allOriginPriceString;

@property (nonatomic, strong) NSString *allMinDicountString;

@property (nonatomic, assign) BOOL cannotBuy;

@property (nonatomic,strong)NSString *pri;
@property (nonatomic,assign)NSInteger a;
@property (nonatomic,assign)NSInteger b;

@property (nonatomic,strong)NSMutableArray *objArraay;//已选择的属性
@property (nonatomic,strong)NSMutableArray *objectArraay;//可选的sku
@property (nonatomic,strong)NSMutableArray *aviArraay;

@property (nonatomic, assign) NSInteger itemTotalPrice;

@property (nonatomic, assign) NSInteger serviceTotalPrice;

@property (nonatomic,assign)BOOL isSele;


@end


@implementation MKSKUViewController

- (void)dealloc
{
    if (self.isViewLoaded)
    {
        [self removeObserver:self forKeyPath:@"mode"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.submitButton.layer.cornerRadius = 3;
    self.submitButton.clipsToBounds = YES;
    self.submitButton.backgroundColor = [UIColor colorWithHex:kRedColor];
    
    //添加边框
    CALayer *layer = [self.iconView layer];
    layer.borderColor = [UIColor colorWithHex:0xf5f5f5].CGColor;
    layer.borderWidth = 0.5f;
    layer.cornerRadius = 5;
    layer.masksToBounds = YES;
    
    
    //    self.scrollView.contentSize = CGSizeMake(320, 500);
//    [self.numberEditView setTextFiedWidth:38];
    self.numberEditView.autoCount = YES;
    self.numberEditView.minusEnableImage = [UIImage imageNamed:@"minus_8x1"];
    self.numberEditView.minusDisableImage = [UIImage imageNamed:@"minus_gray_8x1"];
    self.numberEditView.plusEnableImage = [UIImage imageNamed:@"jia_kedian"];
    self.numberEditView.plusDisableImage = [UIImage imageNamed:@"jia_bukedian"];
    [self.numberEditView updateBorderColor:[UIColor colorWithHex:0xd5d5d5]];
    
    [self.numberEditView addPlusTarget:self action:@selector(plusButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.numberEditView addMinusTarget:self action:@selector(minusButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.objArraay = [NSMutableArray array];
    self.objectArraay = [NSMutableArray array];
    self.aviArraay = [NSMutableArray array];
    
    if (self.skus && self.skus.count > 0)
    {
        [self buildSKUView];
    }
    
    self.purchaseButton.exclusiveTouch = YES;
    self.purchaseButton.layer.cornerRadius = 3;
    self.purchaseButton.clipsToBounds = YES;
    
    self.addToCartButton.layer.cornerRadius = 3;
    self.addToCartButton.layer.borderWidth = 1;
    self.addToCartButton.layer.borderColor = [UIColor colorWithHex:0xFF4B55].CGColor;
    
    [self addObserver:self forKeyPath:@"mode" options:NSKeyValueObservingOptionNew context:NULL];
    [self updateMode];
    [self updatePrice];
    
    [self.delegate skuViewControllerViewDidLoad:self];
    [self disablePurchaseAndAddCart:self.cannotBuy];

    self.taxLimitLabel2.layer.cornerRadius = 3;
    self.taxLimitLabel2.clipsToBounds = YES;
    [self updateTip];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //这里会弹出登录页面，避免登录页返回时调用
    
    if (!self.item.higoMark) {
        self.taxestView.hidden = YES;
        self.taxViewHeight.constant = 0;
        self.numberViewHeight.constant = 100;
    }else {
        if (_item.higoExtraInfo.taxRate == 0) {
            self.taxestLabel.text = [NSString stringWithFormat:@"%@",@"已含税"];
            self.taxesDetailLabel.text = [NSString stringWithFormat:@"此商品含有%f%%消费税，%f%%增值税，订单小于%@元时按%@%%征收。",_item. higoExtraInfo.taxRate,_item.higoExtraInfo.taxRate,@"2000",@"70"];
            
        }else {
            self.taxestLabel.text = [NSString stringWithFormat:@"¥%f",_item.higoExtraInfo.taxRate * [self getNumber]];
        }
    }
    
    if (self.skus.count <= 0) {
        self.mainViewHeight.constant = 360 - self.scrollView.bounds.size.height;
        self.scrollView.hidden = YES;
        self.topSeperate.hidden = YES;
    }
    
    if (self.presentedViewController == nil)
    {
        [self.view layoutIfNeeded];
        self.backgroundImageView.image = [self catchScreen];
        
        self.mainViewPinBottomLayout.constant = -self.mainView.frame.size.height;
        self.coverButton.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                       {
                           [self show];
                       });
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"mode"])
    {
        [self updateMode];
    }
}
#pragma mark -更新数据
- (void)loadItem:(MKItemObject *)item
{
    self.item = item;
    /*******限时购价格，限购数量的处理 Start*******/
    for (NSDictionary *dic in self.item.discountInfoList)
    {
        MKItemDiscountObject *itemDiscountObj = [MKItemDiscountObject objectWithDictionary:dic];
        //&& [itemDiscountObj.marketActivity.limitTagStatus integerValue] != 2
        if ( ISNSStringValid(itemDiscountObj.marketActivity.toolCode) && [itemDiscountObj.marketActivity.toolCode isEqualToString:@"TimeRangeDiscount"] )
        {
            NSMutableDictionary *itemListDict = [NSMutableDictionary dictionary];
            for(NSDictionary *dicList in itemDiscountObj.itemList )
            {
                [itemListDict setValue:dicList forKey:[dicList HYValueForKey:@"item_sku_uid"]];
            }
            if ( itemListDict.count )
            {
                NSMutableArray *itemSkusArr = [NSMutableArray array];
                for( MKItemSKUObject *skuObj in self.item.itemSkus )
                {
                    NSMutableDictionary *dicts = [itemListDict HYNSDictionaryValueForKey:skuObj.skuId];
                    if ( ISNSStringValid( [dicts HYValueForKey:@"unit_price"]) )
                    {
                        skuObj.promotionPrice = [[dicts HYValueForKey:@"unit_price"] integerValue];
                        skuObj.wirelessPrice = [[dicts HYValueForKey:@"unit_price"] integerValue];
                    }
                    if ( ISNSStringValid( [dicts HYValueForKey:@"limit_number"]) )
                    {
                        skuObj.limitNumber = [[dicts HYValueForKey:@"limit_number"] integerValue];
                        skuObj.stockNum = ([[dicts HYValueForKey:@"limit_number"] integerValue] <= 0 ? 0 :skuObj.stockNum);
                    }
                    [itemSkusArr addObject:skuObj];
                }
                self.item.itemSkus = [[NSArray alloc] initWithArray:itemSkusArr];
            }
           
            break;
        }
    }
    /*******限时购价格，限购数量的处理 End*******/

    self.propertyViews = [NSArray array];
    if (item.higoMark == 1) {
        self.supplyAreaLabel.hidden = NO;
        self.supplyAreaLabel.text = [NSString stringWithFormat:@"由%@发货",item.higoExtraInfo.supplyBase];
    }else {
        self.supplyAreaLabel.hidden = YES;
    }
    [self loadSkus:item.itemSkus andProperties:item.skuProperties];
    
    [self updatePrice];

    if (![self isViewLoaded])
    {
        return;
    }
}

-(void)updateTip
{
    if(self.item.limitBuyCount > 0)
    {
        self.tipLabel.text = [NSString stringWithFormat:@"(限%ld件)",self.item.limitBuyCount];
        self.numberEditView.max = self.item.limitBuyCount;
    }
    else if(self.item.minSale == self.item.maxSale && self.item.minSale > 0)
    {
        self.tipLabel.text = [NSString stringWithFormat:@"(每单限购%ld件)",self.item.minSale];
        self.numberEditView.max = self.item.minSale;
    }
    else if (self.item.minSale != self.item.maxSale && self.item.minSale > 1)
    {
        self.tipLabel.text = [NSString stringWithFormat:@"(%ld件起购)",self.item.minSale];
        self.numberEditView.min = self.item.minSale;
    }
    else if ( self.item.itemSkus.count )
    {
        MKItemSKUObject *itemsku = [self getSelectSKU];
        if ( itemsku == nil ) {
            itemsku = self.item.itemSkus[0];
        }
//        MKItemSKUObject *itemsku = self.item.itemSkus[0];

        if( itemsku.limitNumber && itemsku.limitNumber != 99999 )
        {
            self.tipLabel.text = [NSString stringWithFormat:@"(限购%ld件)",itemsku.limitNumber];
        }else
        {
            self.tipLabel.text = @"";
        }
        if ( itemsku.limitNumber )
        {
            self.numberEditView.max = itemsku.stockNum>itemsku.limitNumber?itemsku.limitNumber:itemsku.stockNum;
        }
    }
    else
    {
        self.tipLabel.text = @"";
    }
}

- (void)loadSkus:(NSArray *)skus andProperties:(NSArray *)properties
{
    self.skus = skus;
    self.properties = [NSArray array];
    NSInteger priceTop = -1;
    NSInteger priceBottom = NSIntegerMax;
    NSInteger originPriceTop = -1;
    NSInteger originPriceBottom = NSIntegerMax;
    NSString *minDiscountString = @"10";
    
    NSMutableArray *ssk = [NSMutableArray array];
    for (MKItemSKUObject *iko in skus)
    {
        if (iko.stockNum > 0)
        {
            [ssk addObject:iko];
        }
        if (priceTop < iko.wirelessPrice)
        {
            priceTop = iko.wirelessPrice;
        }
        if (priceBottom > iko.wirelessPrice)
        {
            priceBottom = iko.wirelessPrice;
        }
        if (originPriceTop < iko.marketPrice)
        {
            originPriceTop = iko.marketPrice;
        }
        if (originPriceBottom > iko.marketPrice)
        {
            originPriceBottom = iko.marketPrice;
        }
        NSString *dis = [MKItemObject discountStringWithPrice1:iko.wirelessPrice andPrice2:iko.marketPrice];
        if (dis != nil && [minDiscountString floatValue] > [dis floatValue])
        {
            minDiscountString = dis;
        }
    }
    self.allPriceString = [MKBaseItemObject priceString:priceBottom];
    if (priceBottom < priceTop)
    {
        self.allPriceString = [self.allPriceString stringByAppendingFormat:@"~%@", [MKBaseItemObject priceString:priceTop]];
    }
    if ([minDiscountString floatValue] < 10)
    {
        self.allOriginPriceString = [MKBaseItemObject priceString:originPriceBottom];
        if (originPriceBottom < originPriceTop)
        {
            self.allOriginPriceString = [self.allOriginPriceString stringByAppendingFormat:@"~%@", [MKBaseItemObject priceString:originPriceTop]];
        }
        self.allMinDicountString = minDiscountString;
    }
    self.pri = self.allPriceString;
    self.selectedSkus = ssk;
    NSInteger totalStock = 0;
    for (int i = 0; i < self.selectedSkus.count; i++) {
        MKItemSKUObject *item = self.selectedSkus[i];
        totalStock = totalStock + item.stockNum;
    }
    self.isSoldOut = totalStock <= 0;
    
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    for (MKSKUPropertyObject *p in properties)
    {
        NSMutableArray *par = [props HYNSArrayValueForKey:p.name];
        NSLog(@"props[p.name]%@",props[p.name]);
        if (par == nil)
        {
            par = [NSMutableArray array];
            props[p.name] = par;
        }
        [par addObject:p];
    }
    
    self.properties = [props.allValues sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                       {
                           MKSKUPropertyObject *p1 = obj1[0];
                           MKSKUPropertyObject *p2 = obj2[0];
                           return p1.sort < p2.sort ? NSOrderedAscending : NSOrderedDescending;
                       }];
    
    if ([self isViewLoaded])
    {
        [self buildSKUView];
    }

}

- (void)buildSKUView
{
    int index = 0;
    UIView *upView;
    NSMutableArray *pvs = [NSMutableArray array];
    NSMutableArray *oroper = [NSMutableArray array];
    for (NSArray *props in self.properties) {
        for (MKSKUPropertyObject *abc in props) {
            if (![abc.name isEqualToString:@""]) {
                [oroper addObject:props];
            }
        }
    }
    if (oroper.count == 0) {
        self.mainViewHeight.constant = 360 - self.scrollView.bounds.size.height;
        self.scrollView.hidden = YES;
        self.topSeperate.hidden = YES;
    }
    CGFloat abc = 0;
    NSLog(@"self.properties%@",self.properties);
    for (NSArray *props in self.properties)
    {
        MKSKUTypeView *skutv = [MKSKUTypeView loadFromXib];
        skutv.delegate = self;
        [self.scrollContentView addSubview:skutv];
        
        [skutv buildItemsWithProperties:props];
        abc += skutv.abc;
        if (upView == nil)
        {
            [skutv autoPinEdgeToSuperviewEdge:ALEdgeTop];
        }
        else
        {
            [skutv autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:upView];
        }
        [skutv autoPinEdgeToSuperviewEdge:ALEdgeLeading];
        [skutv autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
        upView = skutv;
       
        skutv.tag = index;
        index ++;
        [pvs addObject:skutv];
       
    }
    self.scrollViewHeightLayout.constant = abc;
    self.propertyViews = [pvs copy];
    
    [self.view layoutIfNeeded];
    
    if (self.item.minSale > 0)
    {
        [self.numberEditView updateNumber:self.item.minSale];
    }
    
    
    if (self.skus.count && self.skus.count != 1)
    {
        MKItemSKUObject *skuObj = [[MKItemSKUObject alloc] init];
        for (MKItemSKUObject *skuItem in self.item.itemSkus) {
            if (skuItem.stockNum > 0) {
                skuObj = skuItem;
                break;
            }
        }
        
        for (MKSKUPropertyObject *item  in skuObj.skuProperties) {
            for (MKSKUTypeView *stv in self.propertyViews)
            {
                for (UIButton *btn in stv.propertyButtons) {
                    if ([btn.titleLabel.text isEqualToString:item.value]) {
                        [stv attributeButtonClick:btn];
                    }
                }
            }
        }
    }else if (self.skus.count == 1) {
        for (MKSKUTypeView *stv in self.propertyViews)
        {
            [stv selectIndex:0];
        }
    }
//    [self refreshSKU:nil with:0];
}
- (void)updateMode
{
    self.submitButton.hidden = self.mode == MKSKUViewControllerModePurchase;
    self.addToCartButton.hidden = self.mode == MKSKUViewControllerModeSubmit;
    self.purchaseButton.hidden = self.mode == MKSKUViewControllerModeSubmit;
}

- (NSInteger)getNumber
{
    return [self.numberEditView getNumber];
}

- (MKItemSKUObject *)getSelectSKU
{
    NSMutableArray *sps = [NSMutableArray array];
    NSInteger i = 0;
    for (MKSKUTypeView *sktv in self.propertyViews)
    {
        NSInteger index = [sktv getSelectedIndex];
        if (index < 0)
        {
            return nil;
        }
        MKSKUPropertyObject *sp = self.properties[i++][index];
        [sps addObject:sp];
    }

    for (MKItemSKUObject *isk in self.skus)
    {
        BOOL isSelect = YES;
        for (MKSKUPropertyObject *sp in isk.skuProperties)
        {
            BOOL contain = NO;
            for (MKSKUPropertyObject *ssp in sps)
            {
                if ([ssp isEqual:sp])
                {
                    contain = YES;
                    break;
                }
            }
            if (!contain)
            {
                isSelect = NO;
                break;
            }
        }
        if (isSelect)
        {
            // NSLog(@"%@",isk.skuProperties);
            return isk;
        }
    }
    return nil;
}

- (NSArray *)getPropertyTitles
{
    NSMutableArray *titles = [NSMutableArray array];
    for (NSArray *a in self.properties)
    {
        MKSKUPropertyObject *skp = a[0];
        [titles addObject:skp.name];
    }
    return [titles copy];
}

- (NSArray *)getMissSelectionTitles
{
    NSMutableArray *sps = [NSMutableArray array];
    NSInteger i = 0;
    for (MKSKUTypeView *sktv in self.propertyViews)
    {
        NSInteger index = [sktv getSelectedIndex];
        if (index < 0)
        {
            MKSKUPropertyObject *sp = self.properties[i][0];
            [sps addObject:sp.name];
        }
        i++;
    }
    return [sps copy];
}

- (UIImage *)catchScreen
{
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, YES, 0);
    //设置截屏大小
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    @try{
        [win.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    @catch(NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

#pragma mark -更新SKU
- (void)skuTypeView:(MKSKUTypeView *)skuTypeView changeFromIndex:(NSInteger)from toIndex:(NSInteger)to
{
    [self updatePrice];
    
   

    
    MKItemSKUObject *item = [self getSelectSKU];
    if (item.stockNum <= 20) {
        self.stockStatusLabel.hidden = NO;
        self.stockStatusLabel.text = @"库存紧张";
    }else {
        self.stockStatusLabel.hidden = NO;
        self.stockStatusLabel.text = @"库存充足";
    }
    if( item.limitNumber && item.limitNumber != 99999 )
    {
        self.tipLabel.text = [NSString stringWithFormat:@"(限购%ld件)",item.limitNumber];
    }else
    {
        self.tipLabel.text = @"";
    }
    if ( item.limitNumber )
    {
        self.numberEditView.max = item.stockNum>item.limitNumber?item.limitNumber:item.stockNum;
    }

    [self refreshSKU:skuTypeView with:to];
//        [self refreshSKU];
}

- (void)refreshSKU
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (MKItemSKUObject *iko in self.skus)
    {
        for (MKSKUPropertyObject *spo in iko.skuProperties)
        {
            dic[spo.description] = spo;
        }
    }
    
    for (int i = 0; i < self.properties.count; ++ i)
    {
        NSArray *ps = self.properties[i];
        MKSKUTypeView *v = self.propertyViews[i];
        
        for (int j = 0; j < ps.count; ++ j)
        {
            MKSKUPropertyObject *ospo = ps[j];
            [v setButton:j enable:dic[ospo.description] != nil];
        }
    }
}


- (void)refreshSKU:(MKSKUTypeView *)view with:(NSInteger )to
{
    NSMutableArray *arr = [NSMutableArray array];
    for (MKItemSKUObject *iko in self.skus)
    {
        iko.skuProperties = [iko.skuProperties sortedArrayUsingComparator:^NSComparisonResult(MKSKUPropertyObject * obj1, MKSKUPropertyObject * obj2) {
            return obj1.sort < obj2.sort ? NSOrderedAscending : NSOrderedDescending;
        }];
        if (iko.stockNum>0) {
            [arr addObject:iko];
        }
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (MKItemSKUObject *iko in arr) {
        NSMutableArray *arra = [NSMutableArray array];
        for (MKSKUPropertyObject *spo in iko.skuProperties) {
            [arra addObject:spo.value];
        }
        [array addObject:arra];
    }
    NSMutableArray *setArray = [NSMutableArray array];
    for (NSArray *arr in array) {
        for (NSString *str in arr) {
            if (![setArray containsObject:str]) {
                [setArray addObject:str];
            }
        }
    }
    for (int i = 0; i < self.properties.count; ++ i)
    {
        NSArray *ps = self.properties[i];
        MKSKUTypeView *v = self.propertyViews[i];
        for (int j = 0; j < ps.count; ++ j)
        {
            MKSKUPropertyObject *ospo = ps[j];
            [v setButton:j enable:[setArray containsObject:ospo.value]];
        }
    }
    if (view && !self.isSele) {
        for (int i = 0; i < self.propertyViews.count; i ++) {
            NSString *str = @"NULL";
            
            self.objArraay[i] = str;
        }
        for (int i = 0; i < self.propertyViews.count; i ++) {
            for (UIButton *but in [self.propertyViews[i] propertyButtons]) {
                if ([but.imageView.image isEqual:[UIImage imageNamed:@"sku_selected"]]) {
                    self.objArraay[i] = [NSString stringWithFormat:@"%@",but.titleLabel.text?but.titleLabel.text:@"NULL"];
                    continue;
                }
            }
        }
        int index = 0 ;
        for (MKSKUTypeView *skuview in self.propertyViews) {
            
            if ([view isEqual:skuview]) {
                if (to == -1) {
                    self.objArraay[index] = @"NULL";
                    break;
                }
                UIButton *but = skuview.propertyButtons[to];
                self.objArraay[index] = [NSString stringWithFormat:@"%@",but.titleLabel.text?but.titleLabel.text:@"NULL"];
            }else{
                for (UIButton *but in skuview.propertyButtons) {
                    if ([but.imageView.image isEqual:[UIImage imageNamed:@"sku_selected"]]) {
                        self.objArraay[index] = [NSString stringWithFormat:@"%@",but.titleLabel.text?but.titleLabel.text:@"NULL"];
                        break;
                    }else{
                        self.objArraay[index] = @"NULL";
                    }
                }
            }
            index ++;
        }
        
        [self.objectArraay removeAllObjects];
        for (NSArray *skuarray in array) {
            if ([self isSkuAvailable:skuarray]) {
                [self.objectArraay addObject:skuarray];
            }
        }
        self.aviArraay = [NSMutableArray array];
        for (int i = 0; i<self.properties.count; i++) {
            NSMutableArray *aviArr = [NSMutableArray array];//可选的属性
            [self.aviArraay addObject:aviArr];
        }
        
        for (NSMutableArray *iarray in self.objectArraay) {
            for (int i = 0; i<self.properties.count; i++) {
                NSMutableArray *aviArr = self.aviArraay[i];
                NSString *ste = self.objArraay[i];
                if ([ste isEqualToString:@"NULL"]) {
                    NSString *str = iarray[i];
                    if (![aviArr containsObject:str]) {
                        [aviArr addObject:str];
                    }
                }
            }
        }
        
        for (int i=0; i < self.objArraay.count; i++) {
            if (![self.objArraay[i] isEqualToString:@"NULL"]) {
                NSMutableArray *arr = [NSMutableArray arrayWithArray:self.objArraay];
                arr[i] = @"NULL";
                NSMutableArray *aviArraytwo = [NSMutableArray array];
                for (NSArray *skuarray in array) {
                    if ([self isSkuAvailable:skuarray with:arr]) {
                        [aviArraytwo addObject:skuarray];
                    }
                }
                for (NSMutableArray *iarray in aviArraytwo) {
                    NSMutableArray *aviArr = self.aviArraay[i];
                    NSString *str = iarray[i];
                    if (![aviArr containsObject:str] &&[self isSkuArrayConString:str withArray:aviArraytwo]) {
                        [aviArr addObject:str];
                    }
                }
            }
        }
        
        for (int i = 0; i < self.properties.count; ++ i)
        {
            NSArray *ps = self.properties[i];
            MKSKUTypeView *v = self.propertyViews[i];
            for (int j = 0; j < ps.count; ++ j)
            {
                [v setButton:j enable:NO];
            }
        }
        for (int i = 0;i<self.aviArraay.count  ; i++) {
            NSMutableArray *arr =self.aviArraay[i];
            MKSKUTypeView *v = self.propertyViews[i];
            NSArray *ps = self.properties[i];
            
            for (int j = 0; j<arr.count; j++) {
                NSString *str = arr[j];
                for (int k = 0; k<ps.count; k++) {
                    MKSKUPropertyObject *ospo = ps[k];
                    if ([ospo.value isEqualToString:str]) {
                        [v setButton:k enable:YES];
                    }
                }
            }
        }
    }
}
- (BOOL)isSkuArrayConString:(NSString *)skuString withArray:(NSMutableArray * )skuArray{
    BOOL isAvailable  = true;
    
    
    
    return isAvailable;
}
- (BOOL)isSkuAvailable:(NSArray *)skuArray{
    BOOL isAvailable  = true;
    for (int i = 0; i<self.objArraay.count; i ++) {
        NSString *str = self.objArraay[i];
        if ([str isEqualToString:@"NULL"]) {
            continue;
        }
        NSString *strSku = skuArray[i];
        if ([str isEqualToString:strSku]) {
            continue;
        }else{
            isAvailable = false;
            break;
        }
    }
    return isAvailable;
}
- (BOOL)isSkuAvailable:(NSArray *)skuArray with:(NSMutableArray *)arr{
    BOOL isAvailable  = true;
    for (int i = 0; i<arr.count; i ++) {
        NSString *str = arr[i];
        if ([str isEqualToString:@"NULL"]) {
            continue;
        }
        NSString *strSku = skuArray[i];
        if ([str isEqualToString:strSku]) {
            continue;
        }else{
            isAvailable = false;
            break;
        }
    }
    return isAvailable;
}

- (void)updatePrice
{
    MKItemSKUObject *itsk = [self getSelectSKU];
    if (itsk != nil)
    {
        if (itsk.imageUrl.length) {
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:itsk.imageUrl]
                             placeholderImage:[UIImage imageNamed:@"placeholder_60x60"]];
        }else {
            NSMutableArray *imageArray = [NSMutableArray array];
            for (MKItemImageObject *d in self.item.itemImages)
            {
                if (d.type == 2) {
                    continue;
                }
                [imageArray addObject:d.imageUrl];
            }
            if ( imageArray.count > 0 )
            {
                [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageArray[0]]
                                 placeholderImage:[UIImage imageNamed:@"placeholder_60x60"]];
            }
            
        }
        self.priceLabel.text = [MKBaseItemObject priceString:itsk.wirelessPrice];
        [self.priceLabel HYPriceChangeFont:12.0f colors:kHEXCOLOR(0xff3333) isTop:NO];

//        if (itsk.wirelessPrice < itsk.marketPrice)
//        {
//            self.originPriceLabel.text = [NSString stringWithFormat:@"￥%@", [MKBaseItemObject priceString:itsk.marketPrice]];
//            self.originPriceLabel.hidden = NO;
//        }
//        else
//        {
//            self.originPriceLabel.hidden = YES;
//        }
        return;
    }
    
    self.priceLabel.text = self.allPriceString;
    [self.priceLabel HYPriceChangeFont:12.0f colors:kHEXCOLOR(0xff3333) isTop:NO];

//    if (self.allOriginPriceString) {
//        self.originPriceLabel.text = [NSString stringWithFormat:@"￥%@", self.allOriginPriceString];
//        self.originPriceLabel.hidden = NO;
//    }
//    else
//    {
//        self.originPriceLabel.hidden = YES;
//    }
}

- (void)disablePurchaseAndAddCart:(BOOL)disable
{
    self.cannotBuy = disable;
    self.addToCartButton.enabled = !disable;
    self.purchaseButton.enabled = !disable;
    self.addToCartButton.layer.borderColor = [UIColor colorWithHex:disable ? 0xCCCCCC : 0xFF4B55].CGColor;
    self.purchaseButton.backgroundColor = [UIColor colorWithHex:disable ? 0xCCCCCC : 0xFF4B55];
    self.submitButton.enabled = !disable;
    self.submitButton.backgroundColor = [UIColor colorWithHex:disable ? 0xCCCCCC : 0xFF4B55];
}

#pragma mark - 操作

- (IBAction)closeButtonClick:(id)sender
{
    [self dismiss:^{
        self.taxLimitLabel1.hidden = YES;
        self.taxLimitLabel2.hidden = YES;
        self.taxLimitHeight.constant = 130;
        [self.numberEditView updateNumber:1];
    }];
}

- (IBAction)submitButtonClick:(id)sender
{
    [self.delegate skuViewControllerDidSubmit:self];
}

- (IBAction)addToCartButtonClick:(id)sender
{
    [self.delegate skuViewControllerDidAddToCart:self];
}

- (IBAction)purchaseButtonClick:(id)sender
{
    [self.delegate skuViewControllerDidPurchase:self];
}

- (void)plusButtonClick
{
    self.itemTotalPrice = 0;
    
    NSInteger n = [self.numberEditView getNumber];
    MKItemSKUObject *itsk = [self getSelectSKU];
    
    self.itemTotalPrice = n * itsk.promotionPrice;
    
    NSString *max = @"200000";
    //判断是否大于1000
    if (self.item.higoMark == 1) {
        if (n * itsk.promotionPrice>max.integerValue)
        {
            if (n>1) {
                self.taxLimitLabel1.hidden = NO;
                self.taxLimitLabel2.hidden = NO;
                self.taxLimitHeight.constant = 150;
//                self.taxLimitLabel2.text = getAppConfig.bizInfo[@"higo_info"][@"item_limit_msg"];
                [self disablePurchaseAndAddCart:YES];
                
            }
        }
    }
    if (self.item.maxSale > 0 && n > self.item.maxSale)
    {
        [MBProgressHUD showMessageIsWait:[NSString stringWithFormat:@"该商品最多购买%ld件哦", self.item.maxSale] wait:YES];
        [self.numberEditView updateNumber:self.item.maxSale];
    }
    else if (n > self.item.limitBuyCount && self.item.limitBuyCount>0) {
        [MBProgressHUD showMessageIsWait:[NSString stringWithFormat:@"该商品最多购买%ld件哦", self.item.limitBuyCount] wait:YES];
        [self.numberEditView updateNumber:self.item.limitBuyCount];
    }
}


- (void)minusButtonClick
{
    NSInteger n = [self.numberEditView getNumber];
    MKItemSKUObject *itsk = [self getSelectSKU];
//    NSString *max = getAppConfig.bizInfo[@"higo_info"][@"order_amount_limit"];
    if (self.item.higoMark == 1) {
        if (itsk.promotionPrice * n  > 200000) {
            if (n == 1) {
                [self.numberEditView updateNumber:200000 / itsk.promotionPrice];
                [self disablePurchaseAndAddCart:NO];
                self.taxLimitLabel1.hidden = YES;
                self.taxLimitLabel2.hidden = YES;
                self.taxLimitHeight.constant = 130;
            }else {
                [self disablePurchaseAndAddCart:YES];
                self.taxLimitLabel1.hidden = NO;
                self.taxLimitLabel2.hidden = NO;
                self.taxLimitHeight.constant = 150;
            }
        }else {
            [self disablePurchaseAndAddCart:NO];
            self.taxLimitLabel1.hidden = YES;
            self.taxLimitLabel2.hidden = YES;
            self.taxLimitHeight.constant = 130;
        }
        
    }
    if (self.item.minSale > 0 && n < self.item.minSale)
    {
        [MBProgressHUD showMessageIsWait:[NSString stringWithFormat:@"该商品%ld件起售", self.item.minSale] wait:YES];
        [self.numberEditView updateNumber:self.item.minSale];
    }
}

#pragma mark - 进入退出动画

#define CATransform3DPerspective(t, x, y) (CATransform3DConcat(t, CATransform3DMake(1, 0, 0, x, 0, 1, 0, y, 0, 0, 1, 0, 0, 0, 0, 1)))
#define CATransform3DMakePerspective(x, y) (CATransform3DPerspective(CATransform3DIdentity, x, y))

CG_INLINE CATransform3D
CATransform3DMake(CGFloat m11, CGFloat m12, CGFloat m13, CGFloat m14,
                  CGFloat m21, CGFloat m22, CGFloat m23, CGFloat m24,
                  CGFloat m31, CGFloat m32, CGFloat m33, CGFloat m34,
                  CGFloat m41, CGFloat m42, CGFloat m43, CGFloat m44)
{
    CATransform3D t;
    t.m11 = m11; t.m12 = m12; t.m13 = m13; t.m14 = m14;
    t.m21 = m21; t.m22 = m22; t.m23 = m23; t.m24 = m24;
    t.m31 = m31; t.m32 = m32; t.m33 = m33; t.m34 = m34;
    t.m41 = m41; t.m42 = m42; t.m43 = m43; t.m44 = m44;
    return t;
}

-(void)show
{
    self.scrollContentViewWidth.constant = self.view.frame.size.width;
    

    
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         CATransform3D t = CATransform3DMakePerspective(0, -0.00013);
         t.m44 = 1.042;
         self.backgroundImageView.layer.transform =t;
     }
                     completion:^(BOOL finished)
     {
         float originWidth = self.view.frame.size.width;
         float originHeight = self.view.frame.size.height;
         float newWidth = originWidth * 0.9;
         float newHeight = originHeight * 0.9;
         [UIView animateWithDuration:0.25 animations:^
          {
              self.backgroundImageView.frame = CGRectMake((self.view.frame.size.width - newWidth) / 2, 22, newWidth, newHeight);
              self.backgroundImageView.layer.transform = CATransform3DMakePerspective(0, 0);
          }
                          completion:^(BOOL finish)
          {
              NSArray *ls = [self.backgroundImageView constraints];
              [self.backgroundImageView removeConstraints:ls];
              ls = [self.backgroundImageView constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal];
              ls = [ls arrayByAddingObjectsFromArray:[self.backgroundImageView constraintsAffectingLayoutForAxis:UILayoutConstraintAxisVertical]];
              for (NSLayoutConstraint *c in ls)
              {
                  switch (c.firstAttribute)
                  {
                      case NSLayoutAttributeLeading:
                          c.constant = self.backgroundImageView.frame.origin.x;
                          break;
                      case NSLayoutAttributeTrailing:
                          c.constant = self.view.frame.size.width - self.backgroundImageView.frame.size.width - self.backgroundImageView.frame.origin.x;
                          break;
                      case NSLayoutAttributeTop:
                          c.constant = self.backgroundImageView.frame.origin.y;
                          break;
                      case NSLayoutAttributeBottom:
                          c.constant = self.view.frame.size.height - self.backgroundImageView.frame.size.height - self.backgroundImageView.frame.origin.y;
                          break;
                      default:
                          break;
                  }
              }
              
              self.mainViewPinBottomLayout.constant = 0;
         }];
     }];
    
    [UIView animateWithDuration:0.5 delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.mainView.frame = CGRectMake(0, self.view.frame.size.height - self.mainView.frame.size.height,
                                          self.mainView.frame.size.width, self.mainView.frame.size.height);
         self.coverButton.alpha = 0.3;
     } completion:nil];
    
}

- (void)dismiss:(void (^)(void))completion
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.mainView.frame = CGRectMake(0, self.view.frame.size.height,
                                          self.mainView.frame.size.width, self.mainView.frame.size.height);
         self.coverButton.alpha = 0;
     } completion:nil];
    
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         CATransform3D t = CATransform3DMakePerspective(0, -0.00013);
         t.m44 = 1.042;
         self.backgroundImageView.layer.transform = t;
         self.backgroundImageView.frame = self.view.bounds;
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.25 animations:^
          {
              self.backgroundImageView.layer.transform = CATransform3DMakePerspective(0, 0);
          }
                          completion:^(BOOL finished)
          {
              NSArray *ls = [self.backgroundImageView constraints];
              [self.backgroundImageView removeConstraints:ls];
              ls = [self.backgroundImageView constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal];
              ls = [ls arrayByAddingObjectsFromArray:[self.backgroundImageView constraintsAffectingLayoutForAxis:UILayoutConstraintAxisVertical]];
              for (NSLayoutConstraint *c in ls)
              {
                  switch (c.firstAttribute)
                  {
                      case NSLayoutAttributeLeading:
                      case NSLayoutAttributeTrailing:
                      case NSLayoutAttributeTop:
                      case NSLayoutAttributeBottom:
                          c.constant = 0;
                          break;
                      default:
                          break;
                  }
              }
              self.mainViewPinBottomLayout.constant = -self.mainView.frame.size.height;
              [self dismissViewControllerAnimated:NO completion:^
               {
                   if (completion != nil)
                   {
                       completion();
                   }
                   [self.delegate skuViewControllerDidClose:self];
               }];
          }];
     }];
}


- (IBAction)showTaxesView:(id)sender {
    
    if (self.item.higoExtraInfo.taxRate == 0) {
        return;
    }
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.mainView.frame = CGRectMake(0, self.view.frame.size.height,
                                          self.mainView.frame.size.width, self.mainView.frame.size.height);
         self.mainViewPinBottomLayout.constant = -self.mainView.frame.size.height-40;
         self.coverButton.userInteractionEnabled = NO;
     } completion:^(BOOL finished) {
         [UIView animateWithDuration:0.25
                               delay:0
                             options:UIViewAnimationOptionCurveEaseInOut
                          animations:^
          {
              self.taxesDetailView.frame = CGRectMake(0, self.view.frame.size.height - self.taxesDetailView.frame.size.height,
                                                      self.taxesDetailView.frame.size.width, self.taxesDetailView.frame.size.height);
              self.taxesDetailViewBottom.constant = 0;
          } completion:nil];
     }];
}

- (IBAction)dismissTaxesDetailView:(id)sender {
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.taxesDetailView.frame = CGRectMake(0, self.view.frame.size.height,
                                                 self.taxesDetailView.frame.size.width, self.taxesDetailView.frame.size.height);
         self.taxesDetailViewBottom.constant = -150;
         self.coverButton.userInteractionEnabled = YES;
     } completion:^(BOOL finished) {
         [UIView animateWithDuration:0.5
                               delay:0
                             options:UIViewAnimationOptionCurveEaseInOut
                          animations:^
          {
              self.mainView.frame = CGRectMake(0, self.view.frame.size.height - self.mainView.frame.size.height,
                                               self.mainView.frame.size.width, self.mainView.frame.size.height);
              self.mainViewPinBottomLayout.constant = 0;
          } completion:nil];
     }];
    
    
}

@end
