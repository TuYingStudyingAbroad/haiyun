//
//  preferenceListViewController.m
//  嗨云项目
//
//  Created by kans on 16/5/10.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "preferenceListViewController.h"
#import <PureLayout.h>
#import "MJRefresh.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
#import "favourableTableViewCell.h"
#import "MKCouponObject.h"
#import "favourableTableViewCell1.h"
#import "AppDelegate.h"
#import <objc/runtime.h>
#import "WXHDownRefreshHeader.h"

#import "HYMainNotDataView.h"
@interface preferenceListViewController ()<UITableViewDataSource, UITableViewDelegate,HYMainNotDataViewDelegate>
{
    HYMainNotDataView       *_mainNotDataView;
    
}
@property (nonatomic, strong) UITableView *tableView;

//用于请求优惠券状态的参数
@property (nonatomic,assign)NSInteger statusIndex;

@property (nonatomic, strong) NSMutableArray *orderSections;
@property (nonatomic ,strong) NSMutableArray * dataArray;

@end

@implementation preferenceListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];    

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initsubView];
    
    if (self.orderStatus== 0 ) {
        self.statusIndex = 30;
    }
    if (self.orderStatus == 1 ) {
        self.statusIndex = 50;
    }
    if (self.orderStatus == 2 ) {
        self.statusIndex = 60;
    }

    self.dataArray = [NSMutableArray array];
    self.orderSections = [NSMutableArray array];
        
}

-(void) initsubView
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

    if ( self.tableView == nil )
    {
       self.tableView = NewObject(UITableView);
       self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64);
    self.tableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];

        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerNib:[UINib nibWithNibName:@"favourableTableViewCell1" bundle:[NSBundle mainBundle]]
             forCellReuseIdentifier:@"favourableTableViewCell1"];
        WXHDownRefreshHeader * header=[WXHDownRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableView.header=header;
        header.lastUpdatedTimeLabel.hidden=YES;
        header.stateLabel.hidden=YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        self.tableView.footer=footer;
        // 设置文字
        //  [footer setTitle:@"Click or drag up to refresh" forState:MJRefreshStateIdle];
        //  [footer setTitle:@"Loading more ..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
        [self.tableView.header beginRefreshing];
        [self.view addSubview: self.tableView];
    }else
    {
        self.tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)
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

- (void)ceshi{
      [appDelegate.mainTabBarViewController guideToHome];
}

- (void)loadDataIsNew:(BOOL)isNew
{
   
    NSInteger offset = self.dataArray.count;
    if (isNew)
    {
      //  _a = 0;
        offset = 0;
    }
    NSLog(@"%ld",(long)offset);
    NSMutableDictionary *param =
    [NSMutableDictionary dictionaryWithDictionary:@{@"offset" : @(offset).stringValue,
                                                    @"count" : @(20).stringValue}];
    
    param[@"status"] = @(self.statusIndex).stringValue;
   
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    [MKNetworking MKSeniorGetApi:@"/marketing/user/coupon/list" paramters:param completion:^(MKHttpResponse *response)
     {
         [ hud hide:YES];
         NSLog(@"hhh%@",response.responseDictionary);
         // 拿到当前的下拉刷新控件，结束刷新状态
         [self.tableView.header endRefreshing];
         // 拿到当前的上拉刷新控件，结束刷新状态
         [self.tableView.footer endRefreshing];
         
         if (response.errorMsg != nil)
         {
              _mainNotDataView.hidden = NO;
              self.tableView.footer.hidden = YES;
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
         if (isNew)
         {
             [self.dataArray removeAllObjects];
         }
         _mainNotDataView.hidden = YES;
         NSArray *db = [response mkResponseData][@"coupon_list"];
         
         //NSString *str = [response mkResponseData][@"total_count"];
         for (NSDictionary *couponDic in db)
         {
             MKCouponObject *item = [MKCouponObject objectWithDictionary:couponDic];
             
             [self.dataArray addObject:item];
         }
         
         if (self.dataArray && self.dataArray.count >0 )
         {
             
             NSInteger total = [[response mkResponseData][@"total_count"] integerValue];
            
             if (self.dataArray.count >= total)
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
             
         }
        self.tableView.hidden = !self.dataArray.count;
         [self.tableView reloadData];
     }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
    return 9;
}
}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 1;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
//    MKCouponObject *mk = self.dataArray[indexPath.section];
//    
//    NSString *str=[NSString stringWithFormat:@"%ld",(long)mk.discountAmount];
//    
//    a = [self heightForString:(self.view.bounds.size.width - 135) withConten:str withFont:17];
//    return mk.ischos? 120 + a : 120;
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //点击进入首页
   // [appDelegate.mainTabBarViewController guideToHome];
   
    
}
- (void)rulseButtonAction:(UIButton *)sender withEven:(UIEvent *)even{
    NSSet *touchs = [even allTouches];
    UITouch *touch = [touchs anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    
    
    MKCouponObject *mk = self.dataArray[indexPath.section];
    mk.ischos = !mk.ischos;
    
    [self.tableView reloadData];
}

- (float) heightForString:(float)width withConten:(NSString *)conten withFont:(float)font{
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(12, 0, width, 0)];
    textView.text = conten;
    textView.font = [UIFont systemFontOfSize:font];
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    favourableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favourableTableViewCell"];
    
    favourableTableViewCell1 * cell=[tableView dequeueReusableCellWithIdentifier:@"favourableTableViewCell1" forIndexPath:indexPath];
    //拿数据
    cell.coupon =[ self.dataArray objectAtIndex:indexPath.section];
    cell.status=self.orderStatus;
    if (self.orderStatus == 2) {
        
        UIImage *imag = [UIImage imageNamed:@"yhq_beijing_yishiyong"];
        [cell.blackImgV setImage: imag];
        cell.timeLimitLab.hidden=YES;
    }if (self.orderStatus == 1) {
         UIImage *imag = [UIImage imageNamed:@"yhq_beijing_yishiyong"];
        [cell.blackImgV setImage: imag];
        cell.timeLimitLab.hidden=YES;
        
    }
    [cell layoutCellSubviews];
    
    
    //    MKCouponObject *mk = self.dataArray[indexPath.section];
    //    NSString *str=[NSString stringWithFormat:@"%ld",(long)mk.discountAmount];
    //
    //通过模型判断箭头指向
    // [cell.isChoose setImage:[UIImage imageNamed:mk.ischos?@"xiala":@"shangla"] forState:UIControlStateNormal];
    
    // [cell.isChoose addTarget:self action:@selector(rulseButtonAction:withEven:) forControlEvents:(UIControlEventTouchUpInside)];
    // [cell.isChoose addTarget:self action:@selector(A:B:) forControlEvents:UIControlEventTouchUpInside];
    //  cell.detailLab.text=str;
    return cell;
    
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
@end
