//
//  MKMyCollectionController.m
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/13.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKMyCollectionController.h"
#import "MKBaseLib.h"
#import "UIColor+MKExtension.h"
#import "MKCollectionItem.h"
#import "MKCollectionCell.h"
#import "MBProgressHUD+MKExtension.h"
#import "NSData+MKExtension.h"
#import "NSString+MKExtension.h"
#import "NSArray+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
#import "MKExceptionView.h"
#import <UIAlertView+Blocks.h>
#import "MKItemDetailViewController.h"
#import <PureLayout.h>
#import "MJRefresh.h"
#import "MKCommissionCell.h"
#import "NSArray+MKExtension.h"
#import "MKCollectionShop.h"

#import "WXHDownRefreshHeader.h"
@interface MKMyCollectionController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *collections;

@property (nonatomic, strong) MKExceptionView *exceptionView;

@property (nonatomic,strong)NSMutableArray *storeDataSoure;

@end

@implementation MKMyCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collections = [NSMutableArray array];
    self.storeDataSoure = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:(UITableViewStyleGrouped)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MKCollectionCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"MKCollectionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MKCommissionCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"MKCommissionCell"];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    self.exceptionView = [MKExceptionView loadFromXib];
    [self.view addSubview:self.exceptionView];
    [self.exceptionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    self.exceptionView.hidden = YES;
    
    WXHDownRefreshHeader * header=[WXHDownRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.header=header;
    header.lastUpdatedTimeLabel.hidden=YES;
    header.stateLabel.hidden=YES;
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.orderStatus) {
        if (section != 0) {
            return 0.1;
        }
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.orderStatus) {
        return 57;
    }
    return 88;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .1f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.orderStatus) {
        return self.storeDataSoure.count;
    }
    return self.collections.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.orderStatus == 0) {
        MKCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKCollectionCell"];
        NSUInteger row = [indexPath section];
        MKItemObject *item = self.collections[row];
        cell.item = item;
        [cell.deletBut addTarget:self action:@selector(handleDeleAction:withEven:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.checkButton addTarget:self action:@selector(handlePushHomePage:withEven:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell enableEdit:self.editing animation:NO];
        return cell;
    }
    else if(self.orderStatus){
        MKCommissionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKCommissionCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSUInteger row = [indexPath section];
        MKCollectionShop *item = self.storeDataSoure[row];
        [cell.deleBut addTarget:self action:@selector(handleDeleAction:withEven:) forControlEvents:(UIControlEventTouchUpInside)];
        
        cell.shopItem =item;
        [cell cellWithLoda];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    return cell;
}

- (void)handlePushHomePage:(UIButton *)sender withEven:(UIEvent *)even{
    NSSet *touchs = [even allTouches];
    UITouch *touch = [touchs anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if (self.orderStatus == 0) {
        NSUInteger row = [indexPath section];
        MKItemObject *item = self.collections[row];
//        [[MKSellerIdSingleton sellerIdSingleton] setSellerId:item.distributorInfo.distributorId];
        [self pushHomePage];
    }
}
- (void)pushHomePage{
    MKHomePageViewController *home = [[MKHomePageViewController alloc]init];
    home.isGoinHome = YES;
    [self.navigationController pushViewController:home animated:YES];
}
- (void)handleDeleAction:(UIButton *)sender withEven:(UIEvent *)even{
    NSSet *touchs = [even allTouches];
    UITouch *touch = [touchs anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if (self.orderStatus == 0) {
        NSUInteger row = [indexPath section];
        MKItemObject *item = self.collections[row];
        [self deleteWith:item];
    }
    if (self.orderStatus == 1) {
         NSUInteger row = [indexPath section];
        MKCollectionShop *item = self.storeDataSoure[row];
        [self deleteWithStore:item];
    }
}
- (void)deleteWithStore:(MKCollectionShop *)shopItem{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除吗？" delegate:nil
                                       cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    al.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex)
    {
        if (buttonIndex == 0)
        {
            return ;
        }
        
        MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
        [MKNetworking MKSeniorGetApi:@"/collection/shop/delete" paramters:@{@"id" : shopItem.ID}
                           completion:^(MKHttpResponse *response)
         {
             [ hud hide:YES];
             if (response.errorMsg != nil)
             {
                 [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
                 return ;
             }
             [self.storeDataSoure removeObject:shopItem];
             [self.tableView reloadData];
             if (self.collections.count == 0)
             {
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                                {
                                    self.exceptionView.exceptionLabel.text = @"还没有收藏的店铺哦~";
                                    self.exceptionView.hidden = NO;
                                });
             }
         }];
    };
    [al show];
}
- (void)deleteWith:(MKItemObject *)item{
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *ditm = [NSMutableArray array];
    NSInteger i = 0;
    for (MKItemObject *itemb in self.collections)
    {
        if ([item isEqual:itemb])
        {
            NSMutableDictionary *di = [NSMutableDictionary dictionary];
            di[@"item_uid"] = item.itemUid;
            di[@"distributor_id"] = item.distributorInfo.distributorId;
            
            [arr addObject:di];
            
            [ditm addObject:itemb];
        }
        i ++ ;
    }
    

    UIAlertView *al = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除吗？" delegate:nil
                                       cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    al.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex)
    {
        if (buttonIndex == 0)
        {
            return ;
        }
        
        MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
        [MKNetworking MKSeniorPostApi:@"/item/collection/delete" paramters:@{@"item_list" : [arr jsonString]}
                           completion:^(MKHttpResponse *response)
         {
             [ hud hide:YES];
//             NSLog(@"%@",response.errorMsg);
             if (response.errorMsg != nil)
             {
                 [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
                 return ;
             }
             [self.collections removeObjectsInArray:ditm];
             [self.tableView reloadData];
             if (self.collections.count == 0)
             {
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                                {
                                    self.exceptionView.exceptionLabel.text = @"还没有收藏的商品哦~";
                                    self.exceptionView.hidden = NO;
                                });
             }
         }];
    };
    [al show];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.orderStatus) {
        MKItemDetailViewController *Vc = [MKItemDetailViewController create];
        MKItemObject *itemObject = [self.collections objectAtIndex:indexPath.section];
        Vc.itemId = itemObject.itemUid;
        Vc.type = itemObject.itemType;
        Vc.itemType=itemObject.itemType;
        Vc.shareUserId =itemObject.shareUserId;
        [self.navigationController pushViewController:Vc animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//获取收藏列表
- (void)loadDataIsNew:(BOOL)isNew
{
    if (self.orderStatus == 0) {
        NSInteger offset = self.collections.count;
        if (isNew)
        {
            offset = 0;
        }
        
        NSMutableDictionary *param =
        [NSMutableDictionary dictionaryWithDictionary:@{@"offset" : @(offset).stringValue,
                                                        @"count" : @(15).stringValue}];
        MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
        [MKNetworking MKSeniorGetApi:@"item/collection/list" paramters:param completion:^(MKHttpResponse *response)
         {
             [ hud hide:YES];
//             NSLog(@"%@",response.responseDictionary);
             // 拿到当前的下拉刷新控件，结束刷新状态
             [self.tableView.header endRefreshing];
             // 拿到当前的上拉刷新控件，结束刷新状态
             [self.tableView.footer endRefreshing];
             if (response.errorMsg != nil)
             {
                 self.tableView.footer.hidden = YES;
                 self.exceptionView.exceptionLabel.text = response.errorMsg;
                 self.exceptionView.hidden = NO;
                 return ;
             }
             if (isNew)
             {
                 [self.collections removeAllObjects];
             }
             NSArray *db = [response mkResponseData][@"item_list"];
             for (NSDictionary *d in db)
             {
                 MKItemObject *item = [MKItemObject objectWithDictionary:d];
//                 NSLog(@"%@",item.distributorInfo.shopName);
                 [self.collections addObject:item];
             }
             
             if (self.collections && self.collections.count > 0)
             {
                 NSInteger total = [[response mkResponseData][@"total_count"] integerValue];
                 if (self.collections.count >= total)
                 {
                     [self.tableView.footer noticeNoMoreData];
                 }
                 else
                 {
                     [self.tableView.footer resetNoMoreData];
                 }
             }
             else
             {
                 self.tableView.footer.hidden = YES;
                 self.exceptionView.exceptionLabel.text = @"还没有收藏的商品哦~";
                 self.exceptionView.hidden = NO;
             }
             [self.tableView reloadData];
         }];

    }
    if (self.orderStatus == 1) {
        NSInteger offset = self.storeDataSoure.count;
        if (isNew)
        {
            offset = 0;
        }
        
        NSMutableDictionary *param =
        [NSMutableDictionary dictionaryWithDictionary:@{@"offset" : @(offset).stringValue,
                                                        @"count" : @(20).stringValue}];
        MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
        
        [MKNetworking MKSeniorGetApi:@"collection/shop/list" paramters:param completion:^(MKHttpResponse *response)
         {
             [ hud hide:YES];
             // 拿到当前的下拉刷新控件，结束刷新状态
             [self.tableView.header endRefreshing];
             // 拿到当前的上拉刷新控件，结束刷新状态
             [self.tableView.footer endRefreshing];
             if (response.errorMsg != nil)
             {
                 self.tableView.footer.hidden = YES;
                 self.exceptionView.exceptionLabel.text = response.errorMsg;
                 self.exceptionView.hidden = NO;
                 return ;
             }
             if (isNew)
             {
                 [self.storeDataSoure removeAllObjects];
             }
             NSArray *db = [response mkResponseData][@"collection_shop_list"];
             for (NSDictionary *d in db)
             {
                 MKCollectionShop *item = [MKCollectionShop objectWithDictionary:d];
                 [self.storeDataSoure addObject:item];
             }
             
             if (self.storeDataSoure && self.storeDataSoure.count > 0)
             {
                 NSInteger total = [[response mkResponseData][@"total_count"] integerValue];
                 if (self.storeDataSoure.count >= total)
                 {
                     [self.tableView.footer noticeNoMoreData];
                 }
                 else
                 {
                     [self.tableView.footer resetNoMoreData];
                 }
             }
             else
             {
                 self.tableView.footer.hidden = YES;
                 self.exceptionView.exceptionLabel.text = @"还没有收藏的店铺哦~";
                 self.exceptionView.hidden = NO;
             }
             [self.tableView reloadData];
         }];
    }
    
    
}
- (void)loadNewData
{
    [self loadDataIsNew:YES];
}

- (void)loadMoreData
{
    [self loadDataIsNew:NO];
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
