//
//  MKChildHomePageViewController.m
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/18.
//  Copyright © 2016年 杨鑫. All rights reserved.
//
#import "WXHDownRefreshHeader.h"
#import "MKChildHomePageViewController.h"
#import "AppDelegate.h"
#import "MKProductListViewController.h"
#import <PureLayout.h>
#import "MJRefresh.h"
#import "MKBaseLib.h"
#import <UIImageView+WebCache.h>
#import "MBProgressHUD+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
#import "MKQrCodeViewController.h"
#import "MKSearchViewController.h"
#import "MKItemDetailViewController.h"
#import "MKUrlGuide.h"
#import "MKItemObject.h"
#import "MKFlagShared.h"
#import "MKMarketingComponentObject.h"
#import "MKMarketingListItem.h"
#import "MKMarketingSingleLineView.h"

#import "MKMarketingBannerCell.h"
#import "MKMarketingNormalButtonsCell.h"
#import "MKBlankTableViewCell.h"
#import "MKMarketingComponentTitleCell.h"
#import "MKMarketingStyle2Cell.h"
#import "MKMarketingStyle3Cell.h"
#import "MKMarketingStyle4Cell.h"
#import "MKMarketingTopNewsCell.h"
#import "MKProductListCell.h"
#import "MKMarketingImageCell.h"
#import "MKMarketingDividerLineCell.h"
#import "MKMarketingstyle41.h"
#import "MKMarketingstyle42.h"
#import "MKMarketingstyle43.h"
#import "MKMarketingstyle44.h"
#import "MKMarketingstyle45.h"
#import "MKMarketingstyle46.h"
#import "MKMarketingstyle47.h"
#import "MKMarketingstyle48.h"
#import "MKMarketingstyle31.h"
#import "MKMarketingstyle32.h"
#import "MKMarketingstyle33.h"
#import "MKMarketingstyle34.h"
#import "MKProductCollectionListCell.h"
#import "MKMarketingFlagObject.h"
#import "MKFlagShared.h"
#import "MKSlidingCell.h"
#import "MKMarketingWritingCell.h"
#import "firstSeckillingCell.h"
#import "firstGridCell.h"
#import "FirstImageViewShowCell.h"

#define marketingTypeBanner @"imageBanner"
#define marketingTypeFourItemNav @"fourItemNav"
#define marketingTypeComponentTitle @"componentTitle"
#define marketingTypeSliding @"horizontalScroll"
#define marketingTypeStyle2 @"style2"
#define marketingTypeStyle3 @"style3"
#define marketingTypeStyle4 @"style4"
#define marketingTypeTopNews @"toutiao"
#define marketingTypeBlankCell @"blankCell"
#define homePageCache @"homePageCache"

#define KMarketingTypeDividerBlank @"dividerBlank"
#define KMarketingTypeImage @"image"
#define KMarketingTypeDividerLine @"dividerLine"
#define kMarketingTypeAnnocement @"marquee"
#define kMarketingTypeCard @"card"
#define kMarketingTypeProduct @"product"
#define kMarketingTypeProduct1 @"product1"
#define kMarketingTypeProduct2 @"product2"

#define kMarketingTypeCardStyle41 @"style4-1"
#define kMarketingTypeCardStyle42 @"style4-2"
#define kMarketingTypeCardStyle43 @"style4-3"
#define kMarketingTypeCardStyle44 @"style4-4"
#define kMarketingTypeCardStyle45 @"style4-5"
#define kMarketingTypeCardStyle46 @"style4-6"
#define kMarketingTypeCardStyle47 @"style4-7"
#define kMarketingTypeCardStyle48 @"style4-8"
#define kMarketingTypeCardStyle31 @"style3-1"
#define kMarketingTypeCardStyle32 @"style3-2"
#define kMarketingTypeCardStyle33 @"style3-3"
#define kMarketingTypeCardStyle34 @"style3-4"
#define kMarketingTypeProductListHeader @"productListHeader"
#define kMarketingTypeFirstSeckill @"seckill"
#define kMarketingTypeGrid @"grid"
#define kMarketingTypePicture @"picture"

#define kMarketingTypeFourItemNavEachLineCount  4

@interface MKChildHomePageViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MKMarketingCellDelegate>

@property (nonatomic, strong) NSArray *components;

@property (nonatomic, strong) NSArray *itemListItems;

@property (nonatomic, strong) NSDictionary *cellsMap;

@property (nonatomic, strong) CAGradientLayer *gradient;

@property (nonatomic, strong) MKSearchViewController *searchViewController;

@property (nonatomic, assign) UIStatusBarStyle myStatusBarStyle;

@property (nonatomic, assign) BOOL isLoaded;

@end

@implementation MKChildHomePageViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, getMainTabBar.tabBar.frame.size.height, 0);
    self.cellsMap = @{
                      marketingTypeBanner : [MKMarketingBannerCell class],
                      marketingTypeFourItemNav : [MKMarketingNormalButtonsCell class],
                      marketingTypeComponentTitle : [MKMarketingComponentTitleCell class],
                      kMarketingTypeProduct2 : [MKProductCollectionListCell class],
                      kMarketingTypeProduct1 : [MKProductListCell class],
                      KMarketingTypeDividerBlank:[MKBlankTableViewCell class],
                      marketingTypeSliding:[MKSlidingCell class],
                      KMarketingTypeImage:[MKMarketingImageCell class],
                      KMarketingTypeDividerLine:[MKMarketingDividerLineCell class],
                      kMarketingTypeAnnocement : [MKMarketingTopNewsCell class],
                      kMarketingTypeCardStyle41 : [MKMarketingstyle41 class],
                      kMarketingTypeCardStyle42 : [MKMarketingstyle42 class],
                      kMarketingTypeCardStyle43 : [MKMarketingstyle43 class],
                      kMarketingTypeCardStyle44 : [MKMarketingstyle44 class],
                      kMarketingTypeCardStyle45: [MKMarketingstyle45 class],
                      kMarketingTypeCardStyle46: [MKMarketingstyle46 class],
                      kMarketingTypeCardStyle47: [MKMarketingstyle47 class],
                      kMarketingTypeCardStyle48: [MKMarketingstyle48 class],
                      kMarketingTypeCardStyle31 : [MKMarketingstyle31 class],
                      kMarketingTypeCardStyle32 : [MKMarketingstyle32 class],
                      kMarketingTypeCardStyle33 : [MKMarketingstyle33 class],
                      kMarketingTypeCardStyle34 : [MKMarketingstyle34 class],
                      kMarketingTypeProductListHeader:[MKMarketingWritingCell class],
                      kMarketingTypeFirstSeckill:[firstSeckillingCell class],
                      kMarketingTypeGrid:[firstGridCell class],
                      kMarketingTypePicture:[FirstImageViewShowCell class]
                      };
    
    [self.cellsMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         [self.tableView registerClass:obj forCellReuseIdentifier:key];
     }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MKProductListCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"MKProductListCell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    __weak typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    
    WXHDownRefreshHeader*header = [WXHDownRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataNewly:YES];
    }];
    self.tableView.header=header;
    header.lastUpdatedTimeLabel.hidden=YES;
    header.stateLabel.hidden=YES;

    
    self.myStatusBarStyle = UIStatusBarStyleLightContent;
    [self setNeedsStatusBarAppearanceUpdate];
    [self.tableView.header beginRefreshing];
    
//    [self loadCache];
    [self loadDataNewly:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ( self.isHide ){
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}


- (void)loadDataNewly:(BOOL)isNew
{
//    NSString *st = [[NSBundle mainBundle]pathForResource:@"ceshi" ofType:nil];
//    NSData *data=[NSData dataWithContentsOfFile:st];
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    if (dic) {
//        [self.tableView.header endRefreshing];
//    }
//    [self loadFromDictionary:dic[@"data"]];
    
    //homepage/app/data/get  之前入参 page_title_id
    NSString * shouyeApi=nil;
    NSDictionary * paramterDic=nil;
    if (!_isHide) {
        shouyeApi=@"homepage/app/data/get";
        paramterDic=@{@"page_title_id":@"tashuo"};
    }else{
        shouyeApi=@"/mainweb/page/get";
        paramterDic=@{@"page_id":self.state};
    }
    
    [MKNetworking MKSeniorGetApi: shouyeApi paramters:paramterDic completion:^(MKHttpResponse *response) {
        [self.tableView.header endRefreshing];
        
        
        if (response.errorMsg != nil)
        {
            [self loadCache];
            [MBProgressHUD showMessageIsWait:@"加载失败了..." wait:YES];
            return ;
        }
      
        if (![[response.responseDictionary allKeys]containsObject:@"data"] ||!response.mkResponseData.count ||![response.mkResponseData isKindOfClass:[NSDictionary class]]) {
            [self loadCache];
            [MBProgressHUD showMessageIsWait:@"加载失败了..." wait:YES];
            return ;
        }
        
        [self loadFromDictionary:response.mkResponseData];

        
        NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        path = [path stringByAppendingPathComponent:self.state];
        [response.mkResponseData writeToFile:path atomically:YES];
    }];

}

- (void)loadCache
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    path = [path stringByAppendingPathComponent:self.state];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    if (dic.count) {
       [self loadFromDictionary:dic];
    }
}

#pragma mark --
#pragma markk -- fake data

#pragma mark --
#pragma mark -- parsering data from response

-(void)loadFlagFromDictionary:(NSDictionary *)data
{
    NSString *totalCount = data[@"total_count"];
    
    [[MKFlagShared sharedInstance].flagDictionary removeAllObjects];
    
    if([totalCount integerValue] >= 0)
    {
        for(NSDictionary *item in data[@"item_list"])
        {
            MKMarketingFlagObject *flagObject = [MKMarketingFlagObject objectWithDictionary:item];
            
            [[MKFlagShared sharedInstance].flagDictionary setObject:flagObject forKey:flagObject.cName];
        }
    }
}

- (void)loadFromDictionary:(NSDictionary *)data
{
    NSMutableArray *ar = [NSMutableArray array];
    //
    for (NSDictionary *d in [data HYNSArrayValueForKey:@"component"])
    {
        if ( [d isKindOfClass:[NSDictionary class]] )
        {
            id valueComponent = [d valueForKey:@"value"];
            
            NSMutableDictionary *parserDictionary = [[NSMutableDictionary alloc]initWithDictionary:d];
            
            if([valueComponent isKindOfClass:[NSDictionary class]])
            {
                [parserDictionary setValue:@[valueComponent] forKey:@"value"];
                
            }
            MKMarketingComponentObject *entry = [MKMarketingComponentObject objectWithDictionary:parserDictionary];
            
            if([entry.valueType isEqualToString:kMarketingTypeProduct])
            {
                MKMarketingObject *object = [entry.values objectAtIndex:0];
                
                //parser the products list
                if(object.productType.integerValue == 2)
                {
                    for(int index = 0; index < ceilf(object.productList.count/2.0) ; index ++)
                    {
                        MKMarketingComponentObject *productComponentObject = [[MKMarketingComponentObject alloc]init];
                        
                        productComponentObject.valueType = entry.valueType;
                        
                        MKMarketingObject *productObject = [[MKMarketingObject alloc]init];
                        
                        MKMarketingListItem *productItem1 = [object.productList objectAtIndex: 2 * index];
                        
                        productObject.productType = object.productType;
                        
                        if(object.productList.count > 2 * index + 1)
                        {
                            MKMarketingListItem *productItem2 = [object.productList objectAtIndex: ( 2 * index + 1)];
                            
                            productObject.productList = @[productItem1,productItem2];
                        }
                        else
                        {
                            productObject.productList = @[productItem1];
                        }
                        
                        productComponentObject.values = @[productObject];
                        
                        [ar addObject:productComponentObject];
                    }
                    
                }
                
                else if (object.productType.integerValue == 1)
                {
                    for(MKMarketingListItem *productItem in object.productList)
                    {
                        MKMarketingComponentObject *productComponentObject = [[MKMarketingComponentObject alloc]init];
                        
                        productComponentObject.valueType = entry.valueType;
                        
                        MKMarketingObject *productObject = [[MKMarketingObject alloc]init];
                        
                        productObject.productType = object.productType;
                        
                        productObject.productList = @[productItem];
                        
                        productComponentObject.values = @[productObject];
                        
                        [ar addObject:productComponentObject];
                        
                    }
                }
            }
            else
            {
                [ar addObject:entry];
            }
        }
        
    }
    self.components = [ar copy];
    
    [ar removeAllObjects];
    
    /*
     for (NSDictionary *d in data[@"itemList"])
     {
     MKMarketingListItem *entry = [MKMarketingListItem objectWithDictionary:d];
     
     [ar addObject:entry];
     }
     
     self.itemListItems = [ar copy];
     
     */
    
    [self.tableView reloadData];
    
}

- (IBAction)onClickHanderScan:(id)sender
{
    MKQrCodeViewController *Vc = [MKQrCodeViewController create];
    Vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:Vc animated:YES];
}

- (void)marketingCell:(MKMarketingCell *)cell didClickWithUrl:(NSString *)url
{
    // NSString *str = @"http://m.haiyn.com/detail.html?item_uid=1841254_2204&item_type=13";
    [[MKUrlGuide commonGuide] guideForUrl:url];
}

-(void)didCompleteDownloadImage
{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.components.count + self.itemListItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKMarketingComponentObject *entry = self.components[indexPath.row];
    
    if([entry.valueType isEqualToString:kMarketingTypeProduct])
    {
        MKMarketingObject *object = entry.values[0];
        
        if(object.productType.integerValue == 2)
        {
            MKProductCollectionListCell *cell = [tableView dequeueReusableCellWithIdentifier:kMarketingTypeProduct2];
            
            [cell updateWithEntryObject:entry];
    
            return cell;
        }
//        if(object.productType.integerValue == 3)
//        {
//            MKSlidingCell *cell = [tableView dequeueReusableCellWithIdentifier:marketingTypeSliding];
//             cell.delegate = self;
//            [cell updateWithEntryObject:entry];
//            
//            return cell;
//        }
        else
        {
            MKProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKProductListCell"];
            
            MKMarketingListItem *item = [object.productList objectAtIndex:0];
            
            /*
             cell.nameLabel.text = item.text;
             
             [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:item.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_80x80"]];
             
             [cell updatePrice:item.wirelessPrice andMarketPrice:item.marketPrice];
             */
            
            [cell updateCellWithData:item];
            
            return cell;
        }
        
    }
    
    else
    {
        MKMarketingCell *cell;
        if([entry.valueType isEqualToString:kMarketingTypeCard])
        {
            MKMarketingObject *object = entry.values[0];
            
            cell = [tableView dequeueReusableCellWithIdentifier:object.type];
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:entry.valueType];
        }
        
        if (cell == nil)
        {
            return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        if ([cell isKindOfClass:[MKMarketingCell class]])
        {
            [cell updateWithEntryObject:entry];
            cell.delegate = self;
        }
        
        return cell;
    }
    
    /*
     MKMarketingListItem *item = self.itemListItems[indexPath.row - self.components.count];
     
     MKProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKProductListCell"];
     
     cell.nameLabel.text = item.text;
     
     [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:item.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_80x80"]];
     
     [cell updatePrice:item.wirelessPrice andMarketPrice:item.marketPrice];
     
     return cell;
     */
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.components.count)
    {
        MKMarketingComponentObject *entry = self.components[indexPath.row];
        
        if ([entry.valueType isEqualToString:KMarketingTypeDividerBlank])
        {
            MKMarketingObject *cellInformation = [entry.values objectAtIndex:0];
            
            if([cellInformation.height floatValue] > 0)
            {
                return [cellInformation.height floatValue]/2.0;
            }
            else
            {
                return [self.cellsMap[entry.valueType] cellHeight];
            }
        }
        else if ([entry.valueType isEqualToString:marketingTypeFourItemNav])
        {
            NSInteger lineCount = ceilf(1.0 * entry.values.count/KNumberOfIconsInLine);
            
            return [self.cellsMap[entry.valueType] cellHeight] * lineCount;
        }
        
        else if ([entry.valueType isEqualToString:KMarketingTypeDividerLine])
        {
            MKMarketingObject *cellInformation = [entry.values objectAtIndex:0];
            
            CGFloat topPadding = [cellInformation.topPadding floatValue] > 0 ? [cellInformation.topPadding floatValue] : kDefaultDividerMargin;
            
            CGFloat bottomePadding = [cellInformation.bottomPadding floatValue] > 0 ? [cellInformation.bottomPadding floatValue] : kDefaultDividerMargin;
            
            return topPadding + bottomePadding + kDefaultDividerLineHeight;
        }
        else if ([entry.valueType isEqualToString:kMarketingTypeCard])
        {
            MKMarketingObject *object = entry.values[0];
            
            return [self.cellsMap[object.type] cellHeight];
        }
        else if ([entry.valueType isEqualToString:kMarketingTypeProduct])
        {
            MKMarketingObject *object = entry.values[0];
            
            if(object.productType.integerValue == 2)
            {
//                return [self.cellsMap[kMarketingTypeProduct2] cellHeight];
                return ([UIScreen mainScreen].bounds.size.width - 20 ) / 2 + 106;

            }
//            if(object.productType.integerValue == 3)
//            {
//                return [self.cellsMap[marketingTypeSliding] cellHeight];
//            }
            
            return [self.cellsMap[kMarketingTypeProduct1] cellHeight];
        }
        else if ([entry.valueType isEqualToString:KMarketingTypeImage])
        {
            MKMarketingObject *object = entry.values[0];
            
            if([[MKFlagShared sharedInstance].imageHeightDictionary objectForKey:object.imageUrl])
            {
                return [[[MKFlagShared sharedInstance].imageHeightDictionary objectForKey:object.imageUrl] intValue];
            }
            else
            {
                return 35.0;
           }
        
        }else if ([entry.valueType isEqualToString:kMarketingTypeGrid]){
            MKMarketingObject *itemInformation = [entry.values objectAtIndex:0];
            
           NSString * keyStr=[NSString stringWithFormat:@"%@%@",itemInformation.gridRow,itemInformation.gridColumn];
            if ([[MKFlagShared sharedInstance].GirdHeightDictionary objectForKey:keyStr]) {
                 return [[[MKFlagShared sharedInstance].GirdHeightDictionary objectForKey:keyStr] intValue];
            }
        }
        else if ([entry.valueType isEqualToString:marketingTypeSliding]){
          NSArray *arr = [entry.values[0] productList];
            if (!arr.count) {
                return 0;
            }
          return  [self.cellsMap[marketingTypeSliding] cellHeight];
        }
        else if ( [entry.valueType isEqualToString:kMarketingTypePicture]){
            if ( entry.values.count>0 ) {
                MKMarketingObject *object = entry.values[0];
                return  ([object.height floatValue]/[object.width floatValue])*Main_Screen_Width;
            }
            return 0;
        }
        
        return [self.cellsMap[entry.valueType] cellHeight];
    }
    
    return [MKProductListCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < self.components.count)
    {
        MKMarketingComponentObject *entry = self.components[indexPath.row];
        
        if ([entry.valueType isEqualToString:marketingTypeComponentTitle] &&
            [entry.values[0] targetUrl].length > 0)
        {
            [[MKUrlGuide commonGuide] guideForUrl:[entry.values[0] targetUrl]];
        }
        else if ([entry.valueType isEqualToString:kMarketingTypeProduct])
        {
            MKMarketingObject *object = entry.values[0];
            
            MKMarketingListItem *item = [object.productList objectAtIndex:0];
            
            [[MKUrlGuide commonGuide] guideForUrl:item.targetUrl];
        }
        
        return;
    }
    
    MKMarketingListItem *item = self.itemListItems[indexPath.row - self.components.count];
    
    [[MKUrlGuide commonGuide] guideForUrl:item.targetUrl];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    
    if (y < 0)
    {
        y = 0;
    }
    if (y > 100)
    {
        y = 100;
    }
   
}




//#pragma mark - MKSearchViewControllerDelegate
//
//- (void)searchViewController:(MKSearchViewController *)searchViewController needSearchWord:(NSString *)word
//{
//    [self.searchViewController dismiss];
//    MKProductListViewController *vc = [MKProductListViewController create];
//    vc.keyWord = word;
//    vc.isSearch = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//- (void)searchViewControllerViewWillShow:(MKSearchViewController *)searchViewController
//{
//    self.myStatusBarStyle = UIStatusBarStyleDefault;
//    [self setNeedsStatusBarAppearanceUpdate];
//}
//
//- (void)searchViewControllerViewDidDismiss:(MKSearchViewController *)searchViewController
//{
//    self.myStatusBarStyle = UIStatusBarStyleLightContent;
//    [self setNeedsStatusBarAppearanceUpdate];
//}

@end
