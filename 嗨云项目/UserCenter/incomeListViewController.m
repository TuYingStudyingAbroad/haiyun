//
//  incomeListViewController.m
//  嗨云项目
//
//  Created by kans on 16/5/9.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "incomeListViewController.h"
#import <PureLayout.h>
#import "MJRefresh.h"
#import "incomeDetailTableViewCell.h"
#import "bankDetailViewController.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
//余额明细模型
#import "WXHBalanceObject.h"
#import "WXHDownRefreshHeader.h"
#import "HYMainNotDataView.h"
@interface incomeListViewController ()<UITableViewDataSource, UITableViewDelegate,HYMainNotDataViewDelegate>

//@property (nonatomic, strong) NSMutableArray *orderSections;
{
    
    HYMainNotDataView       *_mainNotDataView;
    
    
}


@property (nonatomic ,strong) NSMutableArray * dataArray;
@property (nonatomic,assign)int a;

@end

@implementation incomeListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initsubView];
    self.view.backgroundColor=[UIColor colorWithHexString:@"Oxf5f5f5"];
    self.dataArray = [NSMutableArray array];
    
    
    
    
}

-(void) initsubView
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    if ( self.tableView == nil )
    {
        self.tableView = NewObject(UITableView);
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-250);
        self.tableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerNib:[UINib nibWithNibName:@"incomeDetailTableViewCell" bundle:[NSBundle mainBundle]]
             forCellReuseIdentifier:@"incomeDetailTableViewCell"];
                WXHDownRefreshHeader * header=[WXHDownRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
                _tableView.header=header;
                header.lastUpdatedTimeLabel.hidden=YES;
                header.stateLabel.hidden=YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        self.tableView.footer=footer;
        
        // 设置文字
          [footer setTitle:@"" forState:MJRefreshStateIdle];
        //  [footer setTitle:@"Loading more ..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
        
        // [self.tableView.header beginRefreshing];
        [self loadDataIsNew:YES];
      //  self.tableView.scrollEnabled=NO;
        
        [self.view addSubview: self.tableView];
    }else
    {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-250)
                                                      style:UITableViewStyleGrouped];
    }
    
    if ( _mainNotDataView == nil )
    {
        _mainNotDataView = NewObject(HYMainNotDataView);
        _mainNotDataView.frame = rect;
        _mainNotDataView.hidden = YES;
        _mainNotDataView.delegate = self;
        [self.view addSubview:_mainNotDataView];
    }else
    {

        _mainNotDataView.frame = rect;
    }
    
    [self.view bringSubviewToFront:_mainNotDataView];
    
}


- (void)loadDataIsNew:(BOOL)isNew
{
    NSInteger offset = self.dataArray.count;
    if (isNew)
    {
        
        offset = 0;
    }
    //    NSLog(@"%ld",(long)offset);
    NSMutableDictionary *param =
    [NSMutableDictionary dictionaryWithDictionary:@{@"offset" : @(offset),
                                                    @"count" : @(15),@"wealth_type":@(1)}];
    
    param[@"trade_type"] = @(self.orderStatus - 1).stringValue;
    
    //MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    
    [MKNetworking MKSeniorGetApi:@"/marketing/wealth_account/record/list" paramters:param completion:^(MKHttpResponse *response)
     {
         //[ hud hide:YES];
         
         [self.tableView.header endRefreshing];
         [self.tableView.footer endRefreshing];
         
         if (response.errorMsg != nil)
         {
             //             NSLog(@"%@",response.errorMsg);
            // _mainNotDataView.hidden=NO;
             self.tableView.backgroundColor=[UIColor clearColor];
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             // self.tableView.hidden = YES;
             return ;
         }
         _mainNotDataView.hidden=YES;
         
         //         NSLog(@"%@",response.responseDictionary);
         if (isNew)
         {
             [self.dataArray removeAllObjects];
         }
         
         for (NSDictionary *d in [response mkResponseData][@"wealth_log_list"])
         {
             WXHBalanceObject *order = [WXHBalanceObject objectWithDictionary:d];
             [self.dataArray addObject:order];
         }
            if (self.dataArray && self.dataArray.count >0 ){
//             self.tableView.scrollEnabled=YES;
             NSInteger total = [[response mkResponseData][@"total_count"] integerValue];
             if (self.dataArray.count >= total)
             {
                 [self.tableView.footer noticeNoMoreData];
             }
             else
             {
                 [self.tableView.footer resetNoMoreData];
             }
         }else
         {
             
            // self.tableView.scrollEnabled=NO;
             self.tableView.footer.hidden = YES;
             
         }
         //self.tableView.hidden = !self.dataArray.count;
         if (self.dataArray.count==0) {
             self.tableView.backgroundColor=[UIColor clearColor];
         }
         
         [self.tableView reloadData];
     }];
}



-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
};
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}

- (BOOL)cellWithHiden:(NSInteger)stute{
    
    return YES;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    incomeDetailTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"incomeDetailTableViewCell" forIndexPath:indexPath];
    //拿数据
    cell.status = self.orderStatus;
 
         cell.WXHBalanceOBJ =[ self.dataArray objectAtIndex:indexPath.row];
   
    [cell layoutCellSubviews];
    //    cell.statuesLab.text =[self cellWithStute:cell.WXHBalanceOBJ.status withLabel:cell.statuesLab];
    //    cell.statuesLab.hidden = [self cellWithHiden:cell.WXHBalanceOBJ.status];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.orderStatus==3) {
        
        WXHBalanceObject *order=[self.dataArray objectAtIndex:indexPath.row];
        bankDetailViewController * bankDetailVC=[[bankDetailViewController alloc]init];
        bankDetailVC.withdrawalsNumber=order.withdrawalsNumber;
        bankDetailVC.showComplete=NO;
        bankDetailVC.refusalReason=order.refusalReason;
        bankDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bankDetailVC animated:YES];
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
//HYMainNotDataView 代理
-(void)reloadDataView:(HYMainNotDataView *)noView
{
    if ( noView == _mainNotDataView )
    {
        [self loadDataIsNew:YES];
        
    }
}


//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    
//    if (scrollView.contentOffset.y < -5)
//    {
//        if (self.delegate&&[self.delegate respondsToSelector:@selector(getMoneyViewControllerNeedScrollToTop)]) {
//            self.tableView.scrollEnabled=NO;
//            [self.delegate getMoneyViewControllerNeedScrollToTop];
//        }
//    }
//}


@end
