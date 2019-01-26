//
//  MKConfirmOrderViewController.m
//  YangDongXi
//
//  Created by windy on 15/4/20.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKConfirmOrderViewController.h"
#import "MKBaseLib.h"
#import <UIAlertView+Blocks.h>
#import "AppDelegate.h"
#import "WXApi.h"
#import "UIViewController+MKExtension.h"
#import "MKConfirmOrderCell.h"
#import "MKConsigneeCell.h"
#import "MKConsigneeListViewController.h"
#import "UIColor+MKExtension.h"
#import "MKPaymentCell.h"
#import "MKCouponViewController.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKAddConsigneeCell.h"
#import "MKTextField.h"
#import "MKNetworking+BusinessExtension.h"
#import "MKSpecificItemObject.h"
#import "NSDictionary+MKExtension.h"
#import "MKUrlGuide.h"
#import "MKOrderObject.h"
#import "MKConsigneeEditViewController.h"
#import "NSArray+MKExtension.h"
#import "NSString+MKExtension.h"
#import "MKSettlementInfo.h"
#import "newTableViewCell.h"
#import "MKAddAdressTableViewCell.h"
#import "addIdNoCell.h"
#import <PureLayout.h>
#import "MKDetailMoneyTableViewCell.h"
#import <UIAlertView+Blocks.h>
#import "MKPlaceTheOrderController.h"
#import "MKDistributorInfo.h"
#import "MKDistributorsCell.h"
#import <objc/runtime.h>
#import "MKSpecificOrderObject.h"
#import "UIView+MKExtension.h"
#import "MKItemDetailViewController.h"
#import "MKBallTierView.h"
#import "MKRegionItem.h"
#import "MKPaymentSuccessViewController.h"

#define STRING_OR_EMPTY(A)  ({ __typeof__(A) __a = (A); __a ? __a : @""; })

@interface MKConfirmOrderViewController ()<MKConsigneeEditViewControllerDelegate,MKConsigneeListViewControllerDelegate,UITextFieldDelegate,MKCouponViewControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,MKPopUpHierarchyDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (strong, nonatomic) MKTextField *amountField;//金额
@property (strong, nonatomic) MKTextField *messageField;//备注留言
@property (strong, nonatomic) MKConsigneeObject *consigneeItem;

@property (strong, nonatomic) NSMutableArray *consigneeArray;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;

@property (assign, nonatomic) NSInteger deliveryFee;

@property (assign, nonatomic) NSInteger discountAmount;

//@property (assign, nonatomic) NSInteger discountAmount;

@property (assign, nonatomic) NSInteger exchangeAmount;

@property (nonatomic,assign)NSInteger finalTaxFee;
//总价 
@property (assign, nonatomic) NSInteger totalPrice;
/**
 *      @brief 首单立减
 */
@property (nonatomic,assign)NSInteger firstChanLiMinus;

@property (nonatomic, assign) NSInteger selectedPaymentIndex;

@property (nonatomic, strong) NSMutableArray *allCoupons;;

@property (nonatomic ,strong) MKCouponObject *couponItemObject;

@property (nonatomic, strong) MKSettlementInfo *settlementInfo;

@property (nonatomic,strong)NSMutableArray *dataSouce;



@property (strong, nonatomic) UIPickerView *locatePicker;

@property (strong, nonatomic) NSString *selectedProvinceCode;

@property (strong, nonatomic) NSString *selectedCityCode;

@property (strong, nonatomic) NSString *selectedAreaCode;

@property (strong, nonatomic) NSString *selectedStreetCode;


//@property (nonatomic, assign) BOOL ignoreCity;

@property (nonatomic, strong) NSMutableArray *showComponents;

@property (strong, nonatomic) NSMutableArray *indexsOfPicker;



@property (nonatomic,strong)NSString *nameTextF;
@property (nonatomic,strong)NSString *phoneTextF;
@property (nonatomic,strong)NSString *addressTextF;
@property (nonatomic,strong)NSString *idNoTextF;

@property (nonatomic,strong)NSString *orderList;


@property (nonatomic,strong)NSMutableArray *gifItem;

@end


@implementation MKConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"确认订单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.edgesForExtendedLayout= UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    self.payBtn.layer.cornerRadius = 3.0f;
    self.payBtn.layer.masksToBounds  = YES;
    self.payBtn.backgroundColor = [UIColor colorWithHex:0xcccccc];
    self.discountAmount = 0;
    self.dataSouce = [NSMutableArray array];
    self.tableView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    self.payBtn.enabled = NO;
    self.consigneeArray = [NSMutableArray array];
    
    self.allCoupons = [NSMutableArray array];
    [self loadAddressList];
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBar];
    
}
- (void)setupNavigationBar
{
    UINavigationBar *appearance = self.navigationController.navigationBar;
    //统一设置导航栏颜色，如果单个界面需要设置，可以在viewWillAppear里面设置，在viewWillDisappear设置回统一格式。
    //    [appearance setBarTintColor:[UIColor redColor]];
    
    //导航栏title格式
    NSMutableDictionary *textAttribute = [NSMutableDictionary dictionary];
    textAttribute[NSForegroundColorAttributeName] = [UIColor colorWithHex:0x252525];
    textAttribute[NSFontAttributeName] = [UIFont systemFontOfSize:17.0f];
    [appearance setTitleTextAttributes:textAttribute];
    //设置navigationbar的半透明
    [appearance setTranslucent:NO];
    //去除UINavigationBar下面黑色的线颜色
    [appearance setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [appearance setShadowImage:[UIImage imageWithSolidColor:kHEXCOLOR(0xe9e9e9) size:CGSizeMake(Main_Screen_Width, 1.0f)]];
    
    [appearance setBarTintColor:[UIColor whiteColor]];
    
}
- (void)loadAddressList
{
    self.tableView.hidden = YES;
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    [MKNetworking MKSeniorGetApi:@"/user/consignee/list" paramters:nil completion:^(MKHttpResponse *response)
    {
        
        [ hud hide:YES];
        if (response.errorMsg != nil)
        {
            [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
            return ;
        }
        NSArray *db = [response mkResponseData][@"consignee_list"];
        
        if (db && db.count > 0)
        {
            for (NSDictionary *d in db)
            {
                MKConsigneeObject *item = [MKConsigneeObject objectWithDictionary:d];
                if (item.isDefault)
                {
                    [self.consigneeArray insertObject:item atIndex:0];
                }
                else
                {
                    [self.consigneeArray addObject:item];
                }
            }
            self.consigneeItem  = (MKConsigneeObject*)[self.consigneeArray objectAtIndex:0];
            
        }
        if (self.consigneeItem.consigneeUid) {
            [self loadOrderInfoWith:self.consigneeItem.consigneeUid];
        }else{
             [self loadOrderInfoWith:@""];
        }
    }];
}

#pragma mark -获取订单结算信息
- (void)loadOrderInfoWith:(NSString *)consigneeUid
{
    NSMutableArray *orderArray = [NSMutableArray array];
    for (MKCartItemObject *item in self.confirmOrderList)
    {
        MKSpecificItemObject *orderItem = [[MKSpecificItemObject alloc] init];
        orderItem.skuUid = item.skuUid;
        orderItem.number = item.number;
        orderItem.distributorId = item.distributorId;
        orderItem.itemType = item.itemType;
        if ( item.shareUserId ) {
            orderItem.shareUserId = item.shareUserId;
        }
//        orderItem.shareUserId = @"74262";

        [orderArray addObject:[orderItem dictionarySerializer]];
    }
    NSString *str = [orderArray jsonString];    
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    
    [MKNetworking MKSeniorGetApi:@"/trade/order/confirm/get" paramters:@{@"market_item_list" :str,@"consignee_uid":consigneeUid}
                      completion:^(MKHttpResponse *response)
    {
        [ hud hide:YES];
        if (response.errorMsg != nil)
        {
            [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
            return ;
        }
        if (self.dataSouce.count) {
            [self.dataSouce removeAllObjects];
        }
        self.payBtn.enabled = self.consigneeItem?YES:NO;
        self.tableView.hidden = NO;
        NSDictionary *dict = [response mkResponseData][@"settlement_info"];
        self.settlementInfo = [MKSettlementInfo objectWithDictionary:dict];
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (MKMarketItem *obj in self.settlementInfo.itemList) {
//            NSMutableArray *arr = dic[obj.distributor.distributorId];
            if (obj.itemType == 13) {
                //秒杀
                obj.commodityItemType = MKItemSecondsKill;
            }
//            if (!arr) {
//                arr =[NSMutableArray array];
//                if (obj.distributor) {
//                       [arr addObject:obj.distributor];
//                }
//                if (obj.distributor) {
//                    dic[obj.distributor.distributorId] = arr;
//                }
//            }
//            [arr addObject:obj];
            [self.dataSouce addObject:obj];

        }
//        NSArray *keyArr = dic.allKeys;
//        for (NSString *keyString in keyArr) {
//            NSArray *itemArray = dic[keyString];
//            for (int i = 0; i < itemArray.count; i++) {
//                if ( [itemArray[i] isKindOfClass:[MKMarketItem class]] )
//                {
//                    [self.dataSouce addObject:itemArray[i]];
//                }
//            }
//        }
        self.deliveryFee = [[response mkResponseData][@"settlement_info"][@"delivery_fee"] integerValue];
        self.totalPrice = [[response mkResponseData][@"settlement_info"][@"total_price"] integerValue];
        self.discountAmount =[[response mkResponseData][@"settlement_info"][@"discount_amount"] integerValue];
        self.finalTaxFee = [[response mkResponseData][@"settlement_info"][@"higo_extra_info"][@"final_tax_fee"] integerValue];
        
        self.exchangeAmount = self.settlementInfo.exchangeAmount;
        for (MKMarketItem *obj in self.settlementInfo.itemList) {
            if (obj.higoMark) {
                self.isContains = YES;
                break;
            }
        }
        if ((self.consigneeItem.consigneeUid && (self.isContains == YES && self.consigneeItem.idNo.length)) || (self.consigneeItem.consigneeUid && (self.isContains == NO ))) {
            self.payBtn.backgroundColor = [UIColor colorWithHex:0xff4b55];
            self.payBtn.enabled = YES;
            self.payBtn.tag = 888;
        }else{
            self.payBtn.backgroundColor = [UIColor colorWithHex:0xcccccc];
            self.payBtn.tag = 999;
            self.payBtn.enabled = NO;
        }
        
        if ( self.allCoupons )
        {
            [self.allCoupons removeAllObjects];
        }
        else
        {
            self.allCoupons = [NSMutableArray array];
        }
        for (MKAccountDiscountInfo *adi in self.settlementInfo.accountDiscountInfo)
        {
            NSMutableArray *availableArray = [NSMutableArray arrayWithObject:[adi.availableCoupons objectAtIndex:0]];
            for (MKCouponObject *item in availableArray)
            {
                item.number = [adi.availableCoupons count];
                [self.allCoupons addObject:item];
            }
            
        }
        for (MKAccountDiscountInfo *adi in self.settlementInfo.directDiscountList)
        {//甄别满减送
            if ([adi.marketActivity.toolCode isEqualToString:@"ReachMultipleReduceTool"]) {
                self.gifItem =[NSMutableArray arrayWithArray:adi.giftList] ;
                if (!adi.items.count) {
                    for (MKMarketItem *item in self.settlementInfo.itemList) {
                        item.commodityItemType = MKItemgiftsSign;
                    }
                }else{
                    for (MKMarketItem *itemObj in adi.items) {
                        for (MKMarketItem *item in self.settlementInfo.itemList) {
                            if ([item.itemSkuUid isEqualToString:itemObj.itemSkuUid]) {
                                item.commodityItemType = MKItemgiftsSign;
                            }
                        }
                    }
  
                }
            }
            //甄别限时购
            if ([adi.marketActivity.toolCode isEqualToString:@"TimeRangeDiscount"]) {
                if (!adi.items.count) {
                    for (MKMarketItem *item in self.settlementInfo.itemList) {
                        item.commodityItemType = MKItemTimeToBuy;
                    }
                }else{
                for (MKMarketItem *itemObj in adi.items) {
                    for (MKMarketItem *item in self.settlementInfo.itemList) {
                        if ([item.itemSkuUid isEqualToString:itemObj.itemSkuUid]) {
                            item.commodityItemType = MKItemTimeToBuy;
                            }
                        }
                    }
                }
            }
        }
        [self refreshTotalPrice];
        [self.tableView reloadData];
    }];
}

#pragma mark -计算展示的价格
- (void)refreshTotalPrice
{
    self.firstChanLiMinus = 0;
    NSInteger abc = 0;
    NSInteger totalCouponPrice = 0;
    if ( self.couponItemObject.scope == 4 )
    {
        for (MKAccountDiscountInfo *adi in self.settlementInfo.accountDiscountInfo)
        {
            NSMutableArray *availableArray = [NSMutableArray arrayWithObject:[adi.availableCoupons objectAtIndex:0]];
            BOOL flagCounpons = NO;
            for (MKCouponObject *item in availableArray)
            {
                if ( [item.couponUid isEqual:self.couponItemObject.couponUid] )
                {
                    flagCounpons = YES;
                    break;
                }
            }
            if ( flagCounpons )
            {
                totalCouponPrice = 0;
                for( MKMarketItem *itemObj in adi.items )
                {
                    totalCouponPrice += (itemObj.unitPrice*itemObj.number);
                }
                break;
            }
        }
        totalCouponPrice = self.couponItemObject.discountAmount>totalCouponPrice?totalCouponPrice:self.couponItemObject.discountAmount;
        abc = self.totalPrice - totalCouponPrice + self.deliveryFee + self.finalTaxFee - self.discountAmount;
    }
    else
    {
        totalCouponPrice = self.couponItemObject.discountAmount;
        abc = self.totalPrice - self.couponItemObject.discountAmount + self.deliveryFee + self.finalTaxFee - self.discountAmount;
    }
    
    //不用减去优惠券- self.couponItemObject.discountAmount
    for (MKAccountDiscountInfo *adi in self.settlementInfo.directDiscountList)
    { //甄别首单立减条件
        if ([adi.marketActivity.toolCode isEqualToString:@"FirstOrderDiscount"]) {
            if (abc >= adi.consume) {
                self.firstChanLiMinus = adi.discountAmount;
            }
        }
    }
    NSInteger total = self.totalPrice - totalCouponPrice + self.deliveryFee + self.finalTaxFee - self.discountAmount  - self.firstChanLiMinus;
    //不用减去优惠券- self.couponItemObject.discountAmount
    if (total < 0) {
        total = 0;
    }
    self.totalLabel.text = [MKBaseItemObject priceString:total];
    [self.totalLabel HYPriceChangeFont:10.0f colors:kHEXCOLOR(kRedColor) isTop:NO];
}


- (UIView *)accessoryView{
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){7.0f,0.0f,14.0f,14.0f}];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:(CGRect){0,0,7,14}];
    accessoryView.center = view.center;
    accessoryView.image = [UIImage imageNamed:@"icon_accessory.png"];
    accessoryView.backgroundColor = [UIColor clearColor];
    
    [view addSubview:accessoryView];
    return view;
}
- (void)setupPickerView
{
    self.locatePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216)];
    self.locatePicker.delegate = self;
    self.locatePicker.dataSource = self;
    self.locatePicker.backgroundColor = [UIColor whiteColor];
    self.locatePicker.showsSelectionIndicator = YES;
    [self.locatePicker reloadAllComponents];
    
    //[self reloadPickerView];
}
# pragma mark -----地址的选择处理
- (void)setupSubViews:(UITextField *)text
{
    text.inputView = self.locatePicker;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    v.backgroundColor = [UIColor colorWithHex:0xd1d5da];
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setTitleColor:[UIColor colorWithHex:0x0076ff] forState:UIControlStateNormal];
    bt.titleLabel.font = [UIFont systemFontOfSize:14];
    [bt setTitle:@"完成" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(textFieldComplete) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:bt];
    [bt autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:12];
    [bt autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [bt autoSetDimension:ALDimensionWidth toSize:50];
    text.inputAccessoryView = v;
}

- (void)handleNameTextF:(UITextField *)sender{
    
    self.showComponents = [NSMutableArray arrayWithArray:@[[NSArray array], [NSArray array], [NSArray array],  [NSArray array], [NSArray array]]];
    [self getAddressAtIndex:0 withCode:@"CN" isReloadAll:YES completion:^{
        
    }];
    [self setupPickerView];
    [self setupSubViews:sender];
    
    [self reloadPickerView];
}
#pragma mark --
#pragma mark -- get address data

-(void)getAddressAtIndex:(NSInteger)index withCode:(NSString *)code isReloadAll:(BOOL)isReloadAll completion:(void(^)(void))completion;
{
    NSArray *dataArray = [self readArrayWithCustomObjFromUserDefaults:code];
    
    if(dataArray && dataArray.count > 0)
    {
        [self getAddressList:dataArray isReloadAll:isReloadAll withIndex:index code:code forcedReload:YES];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"region_code": code}];
        
        [MKNetworking MKSeniorGetApi:@"/delivery/sub_region/list" paramters:param completion:^(MKHttpResponse *response)
         {
             NSArray *db = [response mkResponseData][@"region_list"];
             
             NSMutableArray *tempArray = [[NSMutableArray alloc]init];
             
             for (NSDictionary *d in db)
             {
                 MKRegionItem *item = [[MKRegionItem alloc]init];
                 
                 item.code = [d objectForKey:@"code"];
                 
                 item.name = [d objectForKey:@"name"];
                 
                 item.pcode = [d objectForKey:@"id"];
                 
                 [tempArray addObject:item];
             }
             
             if(tempArray.count > 0)
             {
                 [self writeArrayWithCustomObjToUserDefaults:code withArray:tempArray];
                 
             }
             
             if(completion)
             {
                 completion();
             }
             
         }];
        
    }
    else
    {
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"region_code": code}];
        
        [MKNetworking MKSeniorGetApi:@"/delivery/sub_region/list" paramters:param completion:^(MKHttpResponse *response)
         {
             NSArray *db = [response mkResponseData][@"region_list"];
             
             NSMutableArray *tempArray = [[NSMutableArray alloc]init];
             
             for (NSDictionary *d in db)
             {
                 MKRegionItem *item = [[MKRegionItem alloc]init];
                 
                 item.code = [d objectForKey:@"code"];
                 
                 item.name = [d objectForKey:@"name"];
                 
                 item.pcode = [d objectForKey:@"id"];
                 
                 [tempArray addObject:item];
             }
             
             if(tempArray.count > 0)
             {
                 [self writeArrayWithCustomObjToUserDefaults:code withArray:tempArray];
             }
             else
             {
                 MKRegionItem *item = [[MKRegionItem alloc]init];
                 
                 item.code = @"NOCODE";
                 
                 item.name = @"我不清楚";
                 
                 [tempArray addObject:item];
             }
             
             BOOL flag = YES;
             
             [self getAddressList:tempArray isReloadAll:isReloadAll withIndex:index code:code forcedReload:flag];
             
             if(isReloadAll && index == 3)
             {
                 [self shouldUpdateInitData];
             }
             else if(!isReloadAll && index == 3)
             {
                 UITextField *te = [self.tableView viewWithTag:110];
                 te.text = [self pickedRegions];
             }
             if(completion)
             {
                 completion();
             }
             
         }];
    }
}
#pragma mark --
#pragma mark -- upate edit data

-(void)shouldUpdateInitData
{
    NSArray *provinces = [self readArrayWithCustomObjFromUserDefaults:@"CN"];
    MKRegionItem *item = [self checkCode:self.consigneeItem.provinceCode inItems:provinces];
    self.selectedProvinceCode = item.code;
    
    NSArray *cities = [self readArrayWithCustomObjFromUserDefaults:item.code];
    item = [self checkCode:self.consigneeItem.cityCode inItems:cities];
    self.selectedCityCode = item.code;
    
    NSArray *areas = [self readArrayWithCustomObjFromUserDefaults:item.code];
    item = [self checkCode:self.consigneeItem.areaCode inItems:areas];
    self.selectedAreaCode = item.code;
    
//    NSArray *streets = [self readArrayWithCustomObjFromUserDefaults:item.code];
//    item = [self checkCode:self.consigneeItem.streetCode inItems:streets];
//    self.selectedStreetCode = item.code;
    
    [self reloadPickerView];
    
    UITextField *te = [self.tableView viewWithTag:110];
    te.text = [self pickedRegions];
    
}
- (NSString *)pickedRegions
{
    self.selectedProvinceCode = [(MKRegionItem *)self.showComponents[0][[self.locatePicker selectedRowInComponent:0]] code];
    
    int ind = 1;
    NSArray *cities = self.showComponents[1];
    NSInteger s = [self.locatePicker selectedRowInComponent:ind ++];
    self.selectedCityCode = s < cities.count ? [(MKRegionItem *)cities[s] code] : nil;
    
    NSArray *areas = self.showComponents[2];
    s = [self.locatePicker selectedRowInComponent:ind ++ ];
    self.selectedAreaCode = s < areas.count ? [(MKRegionItem *)areas[s] code] : nil;
    
//    NSArray *streets = self.showComponents[3];
//    s = [self.locatePicker selectedRowInComponent:ind];
//    self.selectedStreetCode = s < streets.count ? [(MKRegionItem *)streets[s] code] : nil;
    
    return [NSString stringWithFormat:@"%@-%@-%@", [self selectedProvinceString], [self selectedCityString],
            [self selectedAreaString]];
}
#pragma mark - Private Method

- (MKRegionItem *)checkCode:(NSString *)itemCode inItems:(NSArray *)items
{
    for (MKRegionItem *item in items)
    {
        if ([itemCode isEqualToString:item.code])
        {
            return item;
        }
    }
    return items[0];
}

- (NSString *)selectedProvinceString
{
    NSInteger row = [self.locatePicker selectedRowInComponent:0];
    NSArray *items = self.showComponents[0];
    return [self selectedItemStringWithRow:row inItems:items];
}

- (NSString *)selectedCityString
{
    NSInteger row = [self.locatePicker selectedRowInComponent:1];
    NSArray *items = self.showComponents[1];
    return [self selectedItemStringWithRow:row inItems:items];
}

- (NSString *)selectedAreaString
{
    NSInteger row = [self.locatePicker selectedRowInComponent:2];
    NSArray *items = self.showComponents[2];
    return [self selectedItemStringWithRow:row inItems:items];
}

- (NSString *)selectedStreetString
{
    NSInteger row = [self.locatePicker selectedRowInComponent:3];
    NSArray *items = self.showComponents[3];
    return [self selectedItemStringWithRow:row inItems:items];
}

- (NSString *)selectedItemStringWithRow:(NSInteger)row inItems:(NSArray *)items
{
    if (row >= items.count)
    {
        return @"";
    }
    return [items[row] name];
}



#pragma mark -- save data

-(void)writeArrayWithCustomObjToUserDefaults:(NSString *)keyName withArray:(NSMutableArray *)myArray
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:myArray];
    
    [defaults setObject:data forKey:keyName];
    
    [defaults synchronize];
}
#pragma mark --
#pragma mark --  parser data

-(void)getAddressList:(NSArray *)addressList isReloadAll:(BOOL)isReloadAll withIndex:(NSInteger)index code:(NSString *)code forcedReload:(BOOL)isForced
{
    if(self.showComponents.count > index)
    {
        [self.showComponents replaceObjectAtIndex:index withObject:addressList];
    }
    
    if(index < 3 && isForced)
    {
        [self.locatePicker reloadComponent:index];
    }
    
    if(!isReloadAll && isForced)
    {
        if (addressList.count != 0)
        {
            //放队列防止第一列先停，第二列后停错位的问题
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(index < 3)
                {
                    [self.locatePicker selectRow:0 inComponent:index animated:NO];
                }});
        }
    }
    
    if (index < 2 && addressList.count > 0)
    {
        if(isReloadAll && self.consigneeItem)
        {
            NSString *nextCode = nil;
            
            if(index == 0)
            {
                nextCode = self.consigneeItem.provinceCode;
            }
            else if (index == 1)
            {
                nextCode = self.consigneeItem.cityCode;
            }
            else
            {
                nextCode = self.consigneeItem.areaCode;
            }
            
            [self getAddressAtIndex:index + 1 withCode:nextCode isReloadAll:isReloadAll completion:nil];
        }
        else
        {
            [self getAddressAtIndex:index + 1 withCode:[(MKRegionItem *)addressList[0] code] isReloadAll:isReloadAll completion:nil];
        }
        
    }
    else
    {
        NSInteger cIndex = index;
        
        while (cIndex < 2)
        {
            [self.showComponents replaceObjectAtIndex:cIndex + 1 withObject:[NSArray array]];
            
            [self.locatePicker reloadComponent:cIndex + 1];
            
            cIndex = cIndex + 1;
        }
    }
}

#pragma mark -- get data

-(NSArray *)readArrayWithCustomObjFromUserDefaults:(NSString*)keyName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(!keyName || keyName.length  == 0)
    {
        return nil;
    }
    
    NSData *data = [defaults objectForKey:keyName];
    
    if(data)
    {
        NSArray *myArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        return myArray;
    }
    else
    {
        return nil;
    }
}
- (void)reloadPickerView
{
    NSArray *ids = @[STRING_OR_EMPTY(self.selectedProvinceCode), STRING_OR_EMPTY(self.selectedCityCode),
                     STRING_OR_EMPTY(self.selectedAreaCode)];
    for (int i = 0; i < self.showComponents.count - 2; ++ i)
    {
        NSArray *r = self.showComponents[i];
        
        NSString *code = ids[i];
        int row = 0;
        for (MKRegionItem *item in r)
        {
            if ([item.code isEqualToString:code])
            {
                [self.locatePicker selectRow:row inComponent:i animated:NO];
                break;
            }
            row ++ ;
        }
    }
}


- (void)textFieldComplete{
    [self.view endEditing:YES];
}

- (void)modifyConsignee:(MKConsigneeObject *)consigneeItem
{
    NSString *str = [[consigneeItem dictionarySerializer] jsonString];
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    
    [MKNetworking MKSeniorPostApi:@"/user/consignee/update" paramters:@{@"consignee" : str}
                       completion:^(MKHttpResponse *response)
     {
         [ hud hide:YES];
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
         
         self.consigneeItem.idNo = consigneeItem.idNo;
         [self loadOrderInfoWith:self.consigneeItem.consigneeUid];
         [MBProgressHUD showMessageIsWait:@"编辑成功" wait:YES];
     }];
}
- (void)addAddressWith:(MKConsigneeObject *)consigneeItem{
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    
    NSString *str = [[consigneeItem dictionarySerializer] jsonString];
    [MKNetworking MKSeniorPostApi:@"/user/consignee/add" paramters:@{@"consignee" : str}
                       completion:^(MKHttpResponse *response)
     {
         [ hud hide:YES];
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessage:response.errorMsg wait:NO];
             return ;
         }
         NSString *consigneeUid = [response mkResponseData][@"consignee_uid"];
         consigneeItem.consigneeUid = consigneeUid;
         self.consigneeItem = consigneeItem;
         [self loadOrderInfoWith:consigneeUid];
         [MBProgressHUD showMessageIsWait:@"添加成功" wait:YES];
     }];

}

- (void)handleSaveAddress:(UIButton *)sender{
    [self.view endEditing:YES];
    MKConsigneeObject *consigneeIte = [[MKConsigneeObject alloc] init];
    consigneeIte.countryCode = @"CN";
    consigneeIte.provinceCode = self.selectedProvinceCode;
    consigneeIte.cityCode = self.selectedCityCode;
    consigneeIte.areaCode = self.selectedAreaCode;
//    consigneeIte.streetCode = self.selectedStreetCode;
    consigneeIte.address = self.addressTextF;
    consigneeIte.mobile = self.phoneTextF;
    consigneeIte.consignee = self.nameTextF;
    consigneeIte.idNo = self.idNoTextF;
    if (self.consigneeItem.consigneeUid) {
        if (self.isContains) {
            if (!self.idNoTextF.length) {
                [MBProgressHUD showMessageIsWait:@"请填写身份证号码" wait:YES];
                return;
            }
            if (!HYJudgeCard(self.idNoTextF)) {
                [MBProgressHUD showMessageIsWait:@"请填写正确的身份证号码" wait:YES];
                return;
            }
            consigneeIte.provinceCode = self.consigneeItem.provinceCode;
            consigneeIte.cityCode = self.consigneeItem.cityCode;
            consigneeIte.areaCode = self.consigneeItem.areaCode;
            consigneeIte.streetCode = self.consigneeItem.streetCode;
            consigneeIte.address = self.consigneeItem.address;
            consigneeIte.mobile = self.consigneeItem.mobile;
            consigneeIte.consignee = self.consigneeItem.consignee;
            consigneeIte.consigneeUid = self.consigneeItem.consigneeUid;
            [self modifyConsignee:consigneeIte];
        }
    }else{
        if (!consigneeIte.cityCode.length) {
            [MBProgressHUD showMessageIsWait:@"请选择省市区" wait:YES];
            return;
        }
        if (!HYJudgeMobile(consigneeIte.mobile)) {
            [MBProgressHUD showMessageIsWait:@"请输入正确的手机号码" wait:YES];
            return;
        }
        if (consigneeIte.address.length<5) {
            [MBProgressHUD showMessageIsWait:@"详细地址不能小于5个字符" wait:YES];
            return;
        }
        if (self.isContains) {
            if (!self.idNoTextF.length) {
                [MBProgressHUD showMessageIsWait:@"请填写身份证号码" wait:YES];
                return;
            }
            if (!HYJudgeCard(self.idNoTextF)) {
                [MBProgressHUD showMessageIsWait:@"请填写正确的身份证号码" wait:YES];
                return;
            }
        }
       [self addAddressWith:consigneeIte];
    }
    
}

#pragma mark -
#pragma mark -------------------- UITableViewDataSource,UITableViewDelegate --------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {//分组总数
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.consigneeItem.consigneeUid? (self.isContains ? (self.consigneeItem.idNo.length?1:3):1):(self.isContains)?7:6;
    }
    else if (section == 1){
        return self.dataSouce.count;
    }
    else if (section == 2){
        return 5 ;
    }
    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //第一组与商品列表后的分组
    if (section == 0) {
        return 4;
    }
    
    else if (section == 1 ) {
        return 0;
    }
    else if (section == 2){
        if (self.gifItem.count) {
            return self.gifItem.count * 30;
        }else{
            return 0;
        }
    }
    
    return 31;
}
- (UIView *)getView{
    UIView *viewb = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, self.gifItem.count*30)];
    viewb.backgroundColor = [UIColor whiteColor];
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(13, self.gifItem.count*30 -1, Main_Screen_Width - 13, .5f)];
    lineView.backgroundColor = [UIColor colorWithHex:0xe5e5e6];
    [viewb addSubview:lineView];
    for (int i = 0; i < self.gifItem.count; i++) {
            MKMarketItem *gifItem =self.gifItem[i];
            UILabel *gifLabel = [[UILabel alloc]init];
            gifLabel.text = @"赠品:";
            gifLabel.textColor = [UIColor colorWithHex:0xff2741];
            gifLabel.font = [UIFont systemFontOfSize:12];
            [viewb addSubview:gifLabel];
            [gifLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:12];
            [gifLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            UILabel *gifLabelName = [[UILabel alloc]init];
            gifLabelName.text = gifItem.itemName;
            gifLabelName.font = [UIFont systemFontOfSize:12];
            gifLabelName.textColor = [UIColor colorWithHex:0x999999];
            gifLabelName.numberOfLines = 1;
            gifLabelName.lineBreakMode = NSLineBreakByClipping;
            [viewb addSubview:gifLabelName];
            [gifLabelName autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            [gifLabelName autoPinEdge:(ALEdgeLeft) toEdge:(ALEdgeRight) ofView:gifLabel withOffset:8];
            [gifLabelName autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:viewb withOffset:12 relation:NSLayoutRelationLessThanOrEqual];
    }
   
    return viewb;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0){
        UIImageView *sectionHeaderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 4)];
//        sectionHeaderImageView.image = [UIImage imageNamed:@"stripeView.png"];
        sectionHeaderImageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"stripeView.png"]];
        return sectionHeaderImageView;
    }
    else if(section == 1){
        return [[UIView alloc] init];
    }
    else if(section == 2){
        
        if (self.gifItem.count) {
           
            return [self getView];
        }else{
            return [[UIView alloc] init];
        }
        
    }
    UIView *sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 31)];
    
    return sectionHeaderView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    
    if (section == 0) {
//        self.consigneeItem.consigneeUid? (self.isContains ? (self.consigneeItem.idNo?1:2):1):7
    
        if (!self.consigneeItem.consigneeUid ) {
            if (indexPath.row == 5 && !self.isContains) {
                return 68.f;
            }
            if (indexPath.row == 6) {
                 return 68.f;
            }
            return 35.f;
        }
        if (self.consigneeItem.consigneeUid) {
            if (self.consigneeItem.idNo.length) {
                return 90.f;
            }else{
                if (self.isContains) {
                    if (indexPath.row == 0) {
                        return 68.f;
                    }
                    if (indexPath.row == 1) {
                        return 35.f;
                    }
                    if (indexPath.row == 2) {
                        return 68.f;
                    }
                }else{
                    return 70.f;
                }
            }
        }
        return 39.0f;
    }
    else if (section  == 1){
        NSObject *item = [self.dataSouce objectAtIndex:indexPath.row];
        if ([item isKindOfClass:[MKDistributorInfo class]]) {
            return 35;
        }
        if ([item isKindOfClass:[MKMarketItem class]])
        {
           MKMarketItem *itemobj = (MKMarketItem *)item;
            if (itemobj.commodityItemType) {
                return 99.f;
            }
        }
        return 99.f;
    }
    else if (section == 2){
        //运费优惠券
        if (indexPath.row == 1) {
            if (self.isContains ) {
                return 39.f;
            }else{
                return 0;
            }
        }
        if (indexPath.row == 2) {
            if (self.discountAmount  <= 0) //不用减去优惠券- self.couponItemObject.discountAmount
            {
                return 0;
            }else{
                return 39.f;
            }
        }
        if (indexPath.row == 3) {
            if (self.allCoupons.count) {
                return 39.f;
            }else{
                return 0;
            }
        }
        if (indexPath.row == 4) {
            if (self.firstChanLiMinus) {
                return 39.f;
            }else{
                return 0;
            }
        }
        return 39.0f;
    }
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0) {
        if (self.consigneeItem.consigneeUid) {
            if (self.isContains) {
                if (self.consigneeItem.idNo.length) {
                    static NSString *cellIdentifier = @"MKConsigneeCell";
                    MKConsigneeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if (!cell) {
                        cell = [MKConsigneeCell loadFromNib];
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    }
                    cell.consigneeItem = self.consigneeItem;
                     cell.selectedImageView.hidden = NO;
                    cell.selectedImageView.image = [UIImage imageNamed:@"arrow_more"];
                    [cell layoutCellSubviews];
                    return cell;
                }else{
                    if (indexPath.row == 0) {
                        static NSString *cellIdentifier = @"MKConsigneeCell";
                        MKConsigneeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                        if (!cell) {
                            cell = [MKConsigneeCell loadFromNib];
                            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        }
                        cell.consigneeItem = self.consigneeItem;
                        cell.selectedImageView.hidden = NO;
                        cell.selectedImageView.image = [UIImage imageNamed:@"arrow_more"];
                        [cell layoutCellSubviews];
                        return cell;
                    }
                    if (indexPath.row == 1) {
                        static NSString *cellIdentifier = @"addIdNoCell";
                        addIdNoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                        if (!cell) {
                            cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil] firstObject];
                            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        }
                        cell.idNoTextF.delegate = self;
                        cell.idNoTextF.tag = 119;
                        return cell;
                    }
                    if (indexPath.row == 2) {
                        static NSString *cellIdentifier = @"MKAddAdressTableViewCell";
                        MKAddAdressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                        if (!cell) {
                            cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil] firstObject];
                            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        }
                        [cell.saveAddress addTarget:self action:@selector(handleSaveAddress:) forControlEvents:(UIControlEventTouchUpInside)];
                        return cell;
                    }
                }
            }else{
                static NSString *cellIdentifier = @"MKConsigneeCell";
                MKConsigneeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    cell = [MKConsigneeCell loadFromNib];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                }
                cell.consigneeItem = self.consigneeItem;
                [cell layoutCellSubviews];
                return cell;
            }
        }
        else
        {
            if (indexPath.row == 0) {
                
                static NSString *cellIdentifier = @"MKAddConsigneeCell";
                MKAddConsigneeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil] firstObject];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                }
                cell.ShoulderImage.image = [UIImage imageNamed:@"dizhi"];
                cell.addAddress.text = @"请填写收货地址";
                cell.ShoulderImage.hidden = YES;
                return cell;
            }else{
                static NSString *cellIdentifier = @"newTableViewCell";
                newTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil] firstObject];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                }
                cell.neNameTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
                cell.jianZhang.hidden = YES;
                cell.xing.hidden = NO;
                if (indexPath.row == 1) {
                    cell.addNameLabel.text = @"收货人  ";
                    cell.neNameTextF.placeholder = @"请输入收货人姓名";
                    cell.neNameTextF.delegate = self;
                    cell.neNameTextF.tag = 108;
                }
                if (indexPath.row == 2) {
                    cell.addNameLabel.text = @"手机号码";
                    cell.neNameTextF.placeholder = @"请输入收件人手机号码";
                    cell.neNameTextF.delegate = self;
                    cell.neNameTextF.tag = 109;
                }
                if (indexPath.row == 3) {
                    cell.addNameLabel.text = @"所在地区";
                    cell.neNameTextF.placeholder = @"请选择省市区";
                    cell.neNameTextF.delegate = self;
                    cell.neNameTextF.tag = 110;
                    cell.neNameTextF.clearButtonMode = UITextFieldViewModeNever;
                    cell.jianZhang.hidden = NO;
                    return cell;
                }
                if (indexPath.row == 4) {
                    cell.addNameLabel.text = @"详细地址";
                    cell.neNameTextF.placeholder = @"请输入详细地址";
                    cell.neNameTextF.delegate = self;
                    cell.neNameTextF.tag = 111;
                }
                if (indexPath.row == 5 && self.isContains) {
                    cell.addNameLabel.text = @"身份证号";
                    cell.neNameTextF.placeholder = @"用于海关报关使用，填写后我们将加密处理";
                    cell.neNameTextF.delegate = self;
                    cell.neNameTextF.tag = 112;
                    cell.xing.hidden = YES;
                    return cell;
                }
                if (indexPath.row == 5 && !self.isContains) {
                    static NSString *cellIdentifier = @"MKAddAdressTableViewCell";
                    MKAddAdressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if (!cell) {
                        cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil] firstObject];
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    }
                    [cell.saveAddress addTarget:self action:@selector(handleSaveAddress:) forControlEvents:(UIControlEventTouchUpInside)];
                    return cell;
                }
                
                if (indexPath.row == 6) {
                    static NSString *cellIdentifier = @"MKAddAdressTableViewCell";
                    MKAddAdressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if (!cell) {
                        cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil] firstObject];
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    }
                    [cell.saveAddress addTarget:self action:@selector(handleSaveAddress:) forControlEvents:(UIControlEventTouchUpInside)];
                    return cell;
                }
                return cell;
            }
        }
    }
    else if (section == 1 ){
        
        
        NSObject *item = [self.dataSouce objectAtIndex:indexPath.row];
        if ([item isKindOfClass:[MKMarketItem class]]) {
            static NSString *ID = @"MKConfirmOrderCell";
            MKConfirmOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [MKConfirmOrderCell loadFromNib];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            cell.item = (MKMarketItem *)item;
            [cell layoutCellModel];
            cell.priceLabel.textColor = [UIColor colorWithHex:kRedColor];
            [cell.priceLabel HYPriceChangeFont:9.0f colors:kHEXCOLOR(kRedColor) isTop:NO];
            return cell;
        }
        if ([item isKindOfClass:[MKDistributorInfo class]]) {
            static NSString *MKDistributors = @"MKDistributorsCell";
           MKDistributorsCell *cell = [tableView dequeueReusableCellWithIdentifier:MKDistributors];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:MKDistributors owner:self options:nil] firstObject];;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            [cell cellWithModel:(MKDistributorInfo *)item];
            return cell;
        }
    }
    else if (section == 2){
        static NSString *ID = @"MKDetailMoneyTableViewCell";
        MKDetailMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.hidden = NO;
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] firstObject];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        cell.minus.hidden = YES;
        cell.symbol.hidden = NO;
        if (indexPath.row == 0) {
            cell.showName.text = @"运费";
            cell.imgeWidthCount.constant = 0;
            cell.valueText.text = [MKItemObject priceString:self.deliveryFee];
            
            cell.minus.hidden = NO;
            cell.minus.text = @"+";
            return cell;
        }
        if (indexPath.row == 1) {
            cell.showName.text = @"跨境综合税";
            cell.valueText.text = [MKItemObject priceString:self.finalTaxFee];
            cell.symbol.hidden = NO;
            if (self.finalTaxFee == 0) {
               cell.valueText.text = @"已含税";
               cell.symbol.hidden = YES;
                cell.imgeWidthCount.constant = 0;
            }
            if (self.isContains )
            {
                cell.hidden = NO;
            }else{
                cell.hidden = YES;
            }
        }
        if (indexPath.row == 2) {
            cell.showName.text = @"活动优惠";
            cell.minus.hidden = NO;
            cell.imgeWidthCount.constant = 0;
            cell.valueText.text = [MKBaseItemObject priceString:self.discountAmount ];////不用减去优惠券- self.couponItemObject.discountAmount
            if (self.discountAmount  <= 0) //不用减去优惠券- self.couponItemObject.discountAmount
            {
                cell.hidden = YES;
            }else{
                cell.hidden = NO;
            }
        }
        if (indexPath.row == 3) {
            
            cell.showName.text = @"优惠劵";
            if (self.couponItemObject.couponUid) {
                cell.valueText.text = [MKBaseItemObject priceString:self.couponItemObject.discountAmount];
                cell.minus.hidden = NO;
            }else{
                cell.symbol.hidden = YES;
                 cell.valueText.text = @"未使用";
            }
            if (self.allCoupons.count) {
                cell.hidden = NO;
            }else{
                cell.hidden = YES;
            }
        }
        if (indexPath.row == 4) {
            cell.showName.text = @"首单立减";
            cell.minus.hidden = NO;
            cell.valueText.text = [MKBaseItemObject priceString:self.firstChanLiMinus];
            cell.imgeWidthCount.constant = 0;
            if (self.firstChanLiMinus) {
                cell.hidden = NO;
            }else{
                cell.hidden = YES;
            }
        }
        return cell;
    }
    
    static NSString *cellIdentifier = @"emptyViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:cellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if (!self.consigneeItem.consigneeUid || ( self.isContains && !self.consigneeItem.idNo.length)) {
            return 0.1f;
        }
        return 10;
    }
//    if (section == 1) {
//        return .1f;
//    }
    if (section == 2) {
        return .1f;
    }
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    view.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSInteger section = indexPath.section;
    if (section == 0 && indexPath.row == 0)
    {
        if (self.consigneeItem)
        {
            MKConsigneeListViewController *vc = [MKConsigneeListViewController create];
            vc.delegate = self;
            vc.canSelected = YES;
            vc.isTax = self.isContains;
            vc.seletedConsignee = self.consigneeItem;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    
    }
    if (indexPath.section == 1) {
        NSObject *item = [self.dataSouce objectAtIndex:indexPath.row];
        if ([item isKindOfClass:[MKMarketItem class]]) {
            MKItemDetailViewController *detail = [MKItemDetailViewController create];
            detail.itemId = [(MKMarketItem *)item itemUid];
            if ( [(MKMarketItem *)item shareUserId]) {
                detail.shareUserId = [(MKMarketItem *)item shareUserId];
            }
            detail.type = 1;
            if ([(MKMarketItem *)item itemType] == 13) {
                //秒杀
                detail.itemType = [(MKMarketItem *)item itemType];
            }
            [self.navigationController pushViewController:detail animated:YES];
        }
        if ([item isKindOfClass:[MKDistributorInfo class]]) {
            
            MKHomePageViewController *home = [[MKHomePageViewController alloc]init];
            home.isGoinHome = YES;
            [self.navigationController pushViewController:home animated:YES];
        }
    }
    
    
//        else
//        {
//            MKConsigneeEditViewController *Vc = [MKConsigneeEditViewController create];
//            Vc.delegate = self;
//            Vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:Vc animated:YES];
//        }
//    }
    if (section == 2)
    {
        if (indexPath.row == 3)
        {
            MKExceptionView *exceptionView = [MKExceptionView loadFromXib];
            exceptionView.circleView.backgroundColor = exceptionView.backgroundColor;
            exceptionView.exceptionLabel.textColor = [UIColor colorWithHex:0x474747];
            exceptionView.exceptionLabel.text = @"暂无可用优惠劵";
            exceptionView.imageView.image = [UIImage imageNamed:@"coupon icon"];
            MKBallTierView *mk = [[MKBallTierView alloc]init];
            mk.type = 1;
            mk.exceptionView = exceptionView;
            mk.objectItem = self.couponItemObject;
            [mk MKPopUpHierarchywithType:(MKPopUpHierarchyCoupon) withDataArray:self.allCoupons];
            mk.delegate = self;
            [mk show];
            
//            MKCouponViewController *vc = [MKCouponViewController create];
//            vc.isSelected = YES;
//            vc.currentArray = self.allCoupons;
//            vc.delegate = self;
//            NSMutableArray *orderArray = [NSMutableArray array];
//            for (MKMarketItem *item in self.settlementInfo.itemList)
//            {
//                MKSpecificItemObject *orderItem = [[MKSpecificItemObject alloc] init];
//                orderItem.skuUid = item.itemSkuUid;
//                orderItem.number = item.number;
//                [orderArray addObject:orderItem];
//            }
//            NSMutableArray *orderListArray = [NSMutableArray array];
//            for (MKSpecificItemObject *orderItem in orderArray) {
//                [orderListArray addObject:orderItem.dictionarySerializer];
//            }
//            self.orderList = [orderListArray jsonString];
//            vc.orderList = self.orderList;
//            vc.coupon = self.couponItemObject;
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


#pragma mark -立即支付
//立即支付
- (IBAction)clickPayBtn:(id)sender
{
    NSInteger count = 0;
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    NSMutableArray *orderArray = [NSMutableArray array];
    for (MKMarketItem *item in self.settlementInfo.itemList)
    {
        MKSpecificOrderObject *orderItem = [[MKSpecificOrderObject alloc] init];
        orderItem.skuUid = item.itemSkuUid;
        orderItem.number = item.number;
        if (self.orderItemSource == MKOrderItemSourceShoppingCart) {
            count += item.number;
        }
        orderItem.itemType = item.itemType;
        if ( item.shareUserId ) {
            orderItem.shareUserId = item.shareUserId;
        }
//        orderItem.shareUserId = @"74262";
        orderItem.distributorId = item.distributor.distributorId;
        [orderArray addObject:orderItem];
    }
    MKOrderObject *orderInfo = [[MKOrderObject alloc] init];
    orderInfo.orderItemSource = self.orderItemSource;
    orderInfo.orderItems = orderArray;
    orderInfo.consignee = self.consigneeItem;
    orderInfo.paymentId =  1;
    orderInfo.deliveryId = 1;
    if (self.couponItemObject != nil)
    {
        orderInfo.couponItems = @[self.couponItemObject];
    }
    NSDictionary *d = [orderInfo dictionarySerializer];
    NSString *orderString = [d jsonString];
    [MKNetworking MKSeniorPostApi:@"/trade/order/add" paramters:@{@"order" :orderString}
                       completion:^(MKHttpResponse *response)
    {
        [ hud hide:YES];
        if (response.errorMsg != nil)
        {
            [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
            return ;
        }
        getUserCenter.shoppingCartModel.itemCount =  getUserCenter.shoppingCartModel.itemCount - count >0 ? getUserCenter.shoppingCartModel.itemCount - count : 0;
        
        NSString *orderUid = response.mkResponseData[@"order_uid"];
        NSInteger timeout = [response.mkResponseData[@"pay_timeout"] integerValue];
        NSString *orderSn = response.mkResponseData[@"order_sn"];
        if ([[response mkResponseData][@"order_status"] integerValue] == 30) {
            MKPaymentSuccessViewController *succe = [MKPaymentSuccessViewController create];
            succe.couponObject                    = self.couponItemObject;
            succe.consigneeItem                   = self.consigneeItem;
            succe.orderItemSource                 = self.orderItemSource;
            succe.orderUid                        = orderUid;
            succe.orderSn                         = orderSn;
            succe.payAmount                       = self.totalLabel.text.integerValue*100;
            [self.navigationController pushViewController:succe animated:YES];
            return;
        }
        MKPlaceTheOrderController *pa= [MKPlaceTheOrderController create];
        self.navigationController.navigationBarHidden = YES;
        pa.orderItemSource = self.orderItemSource;
        pa.consigneeItem = self.consigneeItem;
        pa.wealthArray = self.settlementInfo.wealthItems;
        pa.couponObject = self.couponItemObject;
        pa.orderUid = orderUid;
        pa.totalPrice = self.totalLabel.text;
        pa.confirm = self;
        pa.isHidenTime = YES;
        pa.time = timeout;
        pa.orderObject = orderInfo;
        pa.orderSn = response.mkResponseData[@"order_sn"];
        [self.navigationController pushViewController:pa animated:YES];
    }];
}

- (void)didSuccessFullAddAddress:(MKConsigneeObject*)address
{
    self.consigneeItem = address;
    [self loadOrderInfoWith:self.consigneeItem.consigneeUid];
//    [self.tableView reloadData];
}

- (void)didSuccessModifyAddress:(MKConsigneeObject *)address
{
    self.consigneeItem = address;
    [self loadOrderInfoWith:self.consigneeItem.consigneeUid];
//    [self.tableView reloadData];
}

- (void)didSelectConsignee:(MKConsigneeObject *)address
{
    self.consigneeItem = address;
    [self loadOrderInfoWith:self.consigneeItem.consigneeUid];
//    [self.tableView reloadData];
}

- (void)didSelectCouponObject:(MKCouponObject *)couponItem
{
    self.couponItemObject = couponItem;
//    self.discountAmount = couponItem.discountAmount;
    [self refreshTotalPrice];
    [self.tableView reloadData];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
   
    if (textField.tag == 110) {
        [self handleNameTextF:textField];
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.tag == 108) {
        if (textField.text.length>20) {
            return NO;
        }
        self.nameTextF = textField.text;
    }
    if (textField.tag == 109) {
        self.phoneTextF = textField.text;
    }
    if (textField.tag == 111) {
        if (textField.text.length>70) {
            return NO;
        }
        self.addressTextF = textField.text;
    }
    if (textField.tag == 112) {
        self.idNoTextF = textField.text;
    }
    if (textField.tag == 119) {
        self.idNoTextF = textField.text;
    }
    return YES;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat width = 0;
    CGFloat screenWidth = self.view.frame.size.width;
    CGFloat averageWidth = screenWidth / 4.0f;
    if (component == 0) {
        width = 60;
    } else if (component == 1) {
        width = averageWidth - 5;
    } else if (component == 2) {
        width = averageWidth - 5;
    } else if (component == 3) {
        width = screenWidth - 60 - averageWidth * 2 + 10;
    }
    return width;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(self.showComponents.count > component)
    {
        NSArray *items = self.showComponents[component];
        return items.count;
    }
    else
    {
        return 0;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSArray *items = self.showComponents[component];
    NSString *title = [[items objectAtIndex:row] name];
    
    CGFloat fontSize = 17.0f;
    NSInteger maxLength = 3;
    if (title.length > maxLength)
    {
        fontSize = fontSize - 1 - (title.length - maxLength);
    }
    
    UILabel *titleLabel = (UILabel *)view;
    if (!titleLabel)
    {
        titleLabel = [[UILabel alloc] init];
    }
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:fontSize];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = title;
    
    return titleLabel;
}

- (void)reloadRegionFromIndex:(NSInteger)index withComponentIndex:(NSInteger)cIndex withPcode:(NSString *)pcode
{
    [self getAddressAtIndex:index withCode:pcode isReloadAll:NO completion:^{
        
        //放队列防止第一列先停，第二列后停错位的问题
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                       {
                           UITextField *te =(UITextField *)[self.tableView viewWithTag:110];
                          te.text = [self pickedRegions];
                       });
    }];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray *items = self.showComponents[component];
    
    if (row >= items.count)
    {
        return;
    }
    
    MKRegionItem *item = items[row];
    [self reloadRegionFromIndex:component + 1 withComponentIndex:component + 1 withPcode:item.code];
}

@end
