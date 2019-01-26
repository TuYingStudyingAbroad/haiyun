//
//  MKCollectionViewController.m
//  YangDongXi
//
//  Created by cocoa on 15/4/17.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKCollectionViewController.h"
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
#import "WXHDownRefreshHeader.h"

@interface MKCollectionViewController ()

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIView *bottomView;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *bottomViewBottom;

@property (nonatomic, strong) IBOutlet UIButton *allSelectBtn;

@property (nonatomic, strong) IBOutlet UIButton *deleteButton;

@property (nonatomic, strong) NSMutableArray *collections;

@property (nonatomic, assign) NSInteger selectCount;

@property (nonatomic, assign) BOOL editing;

@property (nonatomic, strong) MKExceptionView *exceptionView;

@end


@implementation MKCollectionViewController

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"selectCount"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的收藏";

    // Do any additional setup after loading the view.
    self.collections = [NSMutableArray array];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MKCollectionCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"MKCollectionCell"];
    
    self.deleteButton.layer.borderColor = [UIColor colorWithHex:0xff4b55].CGColor;
    self.deleteButton.layer.cornerRadius = 3;
    self.deleteButton.layer.borderWidth = 0.5;
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonClick:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    [self addObserver:self forKeyPath:@"selectCount" options:NSKeyValueObservingOptionNew context:NULL];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectionStatusChange)
                                                 name:MKCollectionItemStatusChangedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"selectCount"])
    {
        self.allSelectBtn.selected = self.selectCount == self.collections.count && self.collections.count != 0;
    }
}

//获取收藏列表
- (void)loadDataIsNew:(BOOL)isNew
{
    NSInteger offset = self.collections.count;
    if (isNew)
    {
        offset = 0;
    }
    
    NSMutableDictionary *param =
    [NSMutableDictionary dictionaryWithDictionary:@{@"offset" : @(offset).stringValue,
                                                    @"count" : @(20).stringValue}];
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    
    [MKNetworking MKSeniorGetApi:@"item/collection/list" paramters:param completion:^(MKHttpResponse *response)
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
            [self.collections removeAllObjects];
        }
        NSArray *db = [response mkResponseData][@"item_list"];
        for (NSDictionary *d in db)
        {
            MKCollectionItem *item = [MKCollectionItem objectWithDictionary:d];
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

- (void)collectionStatusChange
{
    [self loadDataIsNew:YES];
}

#pragma mark -
#pragma mark ------------ UITableView Datasource ------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.collections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKCollectionCell"];
    if (![cell.checkButton canPerformAction:@selector(checkButtonClick:) withSender:self])
    {
        [cell.checkButton addTarget:self action:@selector(checkButtonClick:)
                   forControlEvents:UIControlEventTouchUpInside];
    }
    
    NSUInteger row = [indexPath row];
    MKCollectionItem *item = self.collections[row];
    cell.item = item;
    [cell enableEdit:self.editing animation:NO];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKItemDetailViewController *Vc = [MKItemDetailViewController create];
    MKItemObject *itemObject = [self.collections objectAtIndex:indexPath.row];
    Vc.itemId = itemObject.itemUid;
    Vc.shareUserId = itemObject.shareUserId;
    Vc.type = itemObject.itemType;
    [self.navigationController pushViewController:Vc animated:YES];
}

- (void)checkButtonClick:(UIButton *)checkButton
{
    self.selectCount += (checkButton.selected ? 1 : -1);
}

- (void)editButtonClick:(id)sender
{
    self.editing = !self.editing;
    self.navigationItem.rightBarButtonItem.title = self.editing ? @"完成" : @"编辑";
    
    [UIView animateWithDuration:0.25f animations:^
    {
        self.bottomViewBottom.constant = self.editing ? 0 : -60;
        [self.view layoutIfNeeded];
    }];
    
    NSArray *cells = [self.tableView visibleCells];
    float after = 0;
    for (MKCollectionCell *cell in cells)
    {
        if (self.editing)
        {
            cell.checkButton.selected = NO;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^
        {
            [cell enableEdit:self.editing animation:YES];
        });
        after += 0.03;
    }
    if (self.editing)
    {
        for (MKCollectionItem *it in self.collections)
        {
            it.isChecked = NO;
        }
        self.allSelectBtn.selected = NO;
        self.selectCount = 0;
    }
}

- (IBAction)selectAllClick:(UIButton *)sender
{
    BOOL s = !sender.selected;
    NSArray *cells = [self.tableView visibleCells];
    for (MKCollectionCell *cell in cells)
    {
        cell.checkButton.selected = s;
    }
    for (MKCollectionItem *item in self.collections)
    {
        item.isChecked = s;
    }
    self.selectCount = s ? self.collections.count : 0;
}

- (IBAction)deleteButtonClick:(id)sender
{
    NSMutableArray *ar = [NSMutableArray array];
    NSMutableArray *ditm = [NSMutableArray array];
    NSMutableArray *drows = [NSMutableArray array];
    NSInteger i = 0;
    for (MKCollectionItem *item in self.collections)
    {
        if (item.isChecked)
        {
            [ar addObject:item.itemUid];
            [ditm addObject:item];
            [drows addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        i ++ ;
    }
    
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除这些商品吗？" delegate:nil
                                       cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    al.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex)
    {
        if (buttonIndex == 0)
        {
            return ;
        }
        NSString *str = [ar jsonString];
        
        MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
        [MKNetworking MKSeniorPostApi:@"/item/collection/delete" paramters:@{@"item_uid_list" : str}
                     completion:^(MKHttpResponse *response)
        {
            [ hud hide:YES];
            if (response.errorMsg != nil)
            {
                [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
                return ;
            }
            [self.collections removeObjectsInArray:ditm];
            [self.tableView deleteRowsAtIndexPaths:drows withRowAnimation:UITableViewRowAnimationTop];
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

- (void)loadNewData
{
    [self loadDataIsNew:YES];
}

- (void)loadMoreData
{
    [self loadDataIsNew:NO];
}

@end
