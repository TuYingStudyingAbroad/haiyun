//
//  MKHistoryViewController.m
//  YangDongXi
//
//  Created by windy on 15/5/6.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKHistoryViewController.h"
#import "MKBaseLib.h"
#import <UIImageView+WebCache.h>
#import "UIColor+MKExtension.h"
#import "MKTinyItemTableViewCell.h"
#import "MBProgressHUD+MKExtension.h"
#import "NSData+MKExtension.h"
#import "NSString+MKExtension.h"
#import "NSArray+MKExtension.h"
#import "MKHistoryItemObject.h"
#import "MJRefresh.h"
#import "MKExceptionView.h"
#import <PureLayout.h>
#import "AppDelegate.h"
#import <UIAlertView+Blocks.h>
#import "MKItemDetailViewController.h"

@interface MKHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;



@property (nonatomic, strong) NSMutableArray *histories;

@property (nonatomic, strong) NSMutableDictionary *selectedItems;

@property (nonatomic, strong) MKHistoryModel *historyModel;

@end


@implementation MKHistoryViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"浏览历史";
    self.histories = [NSMutableArray array];
    self.selectedItems = [NSMutableDictionary dictionary];
    self.historyModel = getUserCenter.historyModel;
     self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MKTinyItemTableViewCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"MKTinyItemTableViewCell"];
    
    self.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithMJTitle:@"清空" target:self action:@selector(editButtonClick:)];;
    self.tableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    if (self.histories.count > 0)
    {
        NSInteger count = self.histories.count;
        [self.histories removeAllObjects];
        [self loadDataWithCount:count];
    }
    else
    {
        [self loadMoreData];
        if (self.histories.count == 0)
        {
            [self showExceptionView];
        }
    }
   
}

- (void)editButtonClick:(UIBarButtonItem *)sender{
    NSMutableArray *ar = [NSMutableArray array];
    NSMutableArray *ditm = [NSMutableArray array];
    NSMutableArray *drows = [NSMutableArray array];
    NSInteger i = 0;
    for (NSDictionary *dic in self.histories)
    {
        NSArray *arr = dic.allKeys;
        NSMutableArray *array = dic[arr[0]];
        for (MKHistoryItemObject *item in array) {
            [ar addObject:item.itemUid];
            
            [ditm addObject:item];
            [drows addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            i ++ ;
        }
        
    }
    
    
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除这些商品吗？" delegate:nil
                                       cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    al.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex)
    {
        if (buttonIndex == 0)
        {
            return ;
        }
        [self.historyModel clear];
        [self.histories removeAllObjects];
        
        [self.tableView reloadData];
        if (self.histories.count == 0)
        {
            [self.tableView.header endRefreshing];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                           {
                               [self showExceptionView];
                           });
        }
    };
    
    [al show];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)loadDataWithCount:(NSInteger)count
{
    NSArray *arry = self.histories;
    int i = 0;
    for (NSDictionary *dic in arry) {
        NSArray *arr = dic.allKeys;
        for (NSString *str in arr) {
            NSArray *ab = dic[str];
            i+=ab.count;
        }
    }
    
    
    NSArray *items = [self.historyModel lastItemFromIndex:i count:count];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:items];
    for (NSDictionary *dic in self.histories) {
        for (NSString *str in dic) {
            NSArray *arry = dic[str];
            for (MKHistoryItemObject*item in arry) {
                [arr addObject:item];
            }
        }
    }
    items = [NSMutableArray arrayWithArray:arr];
    [self.histories removeAllObjects];
     NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (MKHistoryItemObject*item in items) {
        NSMutableArray *array = [NSMutableArray array];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:item.historyUpdateTime];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        if (dict[confromTimespStr] == nil) {
            dict[confromTimespStr] = array;
        }
        NSMutableArray *dicArray = dict[confromTimespStr];
        if (![dicArray containsObject:item]) {
             [dicArray addObject:item];
        }
    }
    for (NSString *timeArray in dict) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSMutableArray *array = dict[timeArray];
        NSArray *array2 = [array sortedArrayUsingComparator:
                           ^NSComparisonResult(MKHistoryItemObject *obj1, MKHistoryItemObject *obj2) {
                               // 先按照姓排序
                               NSComparisonResult result = [@(obj2.historyUpdateTime) compare:@(obj1.historyUpdateTime)];
                               return result;
                           }];
        dic[timeArray] = array2;
        [self.histories addObject:dic];
    }
    NSArray *array2 = [self.histories sortedArrayUsingComparator:
                       ^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                           // 先按照姓排序
                           NSComparisonResult result = [obj2.allKeys[0] compare:obj1.allKeys[0]];
                           return result;
                       }];
    self.histories = [NSMutableArray arrayWithArray:array2];
    
    
    [self.tableView reloadData];
    [self.tableView.footer endRefreshing];
    if (items.count < count)
    {
        [self.tableView.header endRefreshing];
    }
    else
    {
        self.tableView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
}
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (void)loadMoreData
{
    [self loadDataWithCount:20];
}

- (void)showExceptionView
{
    self.navigationItem.rightBarButtonItem = nil;
    
    MKExceptionView *ev = [MKExceptionView loadFromXib];
    ev.exceptionLabel.text = @"还没有浏览历史哦~";
    ev.imageView.image = [UIImage imageNamed:@"no_history"];
    [self.view addSubview:ev];
    [ev autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

#pragma mark -
#pragma mark ------------ UITableView Datasource ------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.histories.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = self.histories[section];
    NSArray *arr = dic.allKeys;
    return [dic[arr[0]] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MKTinyItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKTinyItemTableViewCell"];
    NSUInteger row = [indexPath row];
    NSDictionary *dic = self.histories[indexPath.section];
    NSArray *arr = dic.allKeys;
    NSMutableArray *array = dic[arr[0]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MKHistoryItemObject *item = array[indexPath.row];
    cell.titleLabel.text = item.itemName;
    cell.objModel = item;
    cell.shopName.text = item.shopName;
    cell.checkButton.tag = row;
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:item.iconUrl] placeholderImage:[UIImage imageNamed:@"placeholder_70x70"]];
    cell.priceLabel.text = [MKHistoryItemObject priceString:item.wirelessPrice];
    [cell setBottomSeperatorLineMarginLeft:0 rigth:0];
    [cell enableEdit:self.editing animation:NO];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;{
    return 1;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary *dic = self.histories[section];
    NSArray *arr = dic.allKeys;
    return [NSString stringWithFormat:@"    %@",arr[0]];
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKTinyItemTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    MKItemDetailViewController *Vc = [MKItemDetailViewController create];
    Vc.itemId = cell.objModel.itemUid;
    Vc.shareUserId = nil;
    Vc.type = 1;
    Vc.itemType=cell.objModel.itemType;
    [self.navigationController pushViewController:Vc animated:YES];
}

@end
