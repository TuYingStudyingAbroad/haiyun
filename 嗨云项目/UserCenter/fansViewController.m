//
//  fansViewController.m
//  嗨云项目
//
//  Created by 小辉 on 16/8/30.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "fansViewController.h"
#import <PureLayout.h>
#import "MJRefresh.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
#import "fansSortView.h"
#import "fansTableViewCell.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
#import "fansObject.h"
#import "noDataView.h"
#import "FSdefsViewController.h"
@interface fansViewController ()<fansSortViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)fansSortView* fansView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,assign)NSInteger  sortBy;
@property(nonatomic,assign)NSInteger upDown;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)noDataView* nodataView;
@end

@implementation fansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的粉丝";
    self.dataArray = [NSMutableArray array];
    self.sortBy=1;
    self.upDown=1;
    [self layoutViews];
    [self initsubView];
    [self loadNewData:YES];
    
}
-(fansSortView *)fansView{
    if (!_fansView) {
        _fansView=[fansSortView loadFromXib];
    }
    return _fansView;
}


-(void)loadNewData:(BOOL)isNew{
    
    NSInteger offset = self.dataArray.count;
    if (isNew)
    {
        offset = 0;
    }
    NSMutableDictionary *param =
    [NSMutableDictionary dictionaryWithDictionary:@{@"offset" : @(offset).stringValue,
                                                    @"count" : @(15).stringValue}];
    
    param[@"sort"]=@(self.sortBy).stringValue;
    param[@"updown"]=@(self.upDown).stringValue;
    param[@"user_id"] = @(appDelegate.userCenter.userInfo.userId).stringValue;
//    NSMutableDictionary *param =
//    [NSMutableDictionary dictionaryWithDictionary:@{@"sort" :@(self.sortBy).stringValue, @"updown" :@(self.upDown).stringValue}];
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    [MKNetworking MKSeniorGetApi:@"/fans/list" paramters:param completion:^(MKHttpResponse *response)
     {
         [ hud hide:YES];
         // 拿到当前的下拉刷新控件，结束刷新状态
         [self.tableView.header endRefreshing];
         // 拿到当前的上拉刷新控件，结束刷新状态
         [self.tableView.footer endRefreshing];
         
         if (response.errorMsg != nil)
         {
             _nodataView.hidden=NO;
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
          NSArray *db = [response mkResponseData][@"myFans"];
         if (isNew) {
          [self.dataArray removeAllObjects]; 
         }

         for (NSDictionary *couponDic in db)
         {
             fansObject *item = [fansObject objectWithDictionary:couponDic];
             
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
             _nodataView.hidden=NO;

             self.tableView.footer.hidden = YES;
             
         }
         
         
        [self.tableView reloadData];
     }];
    
}
     
-(void)layoutViews{
    [self.view addSubview:self.fansView];
    [self.fansView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.fansView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
    [self.fansView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    self.fansView.delegate=self;
     [self.fansView autoSetDimension:ALDimensionHeight toSize:40];

}
-(void)initsubView{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    if ( self.tableView == nil )
    {
        self.tableView = NewObject(UITableView);
        self.tableView.frame = CGRectMake(0, 41, self.view.frame.size.width, self.view.frame.size.height-104);
        self.tableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
       self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.tableView registerNib:[UINib nibWithNibName:@"fansTableViewCell" bundle:[NSBundle mainBundle]]
             forCellReuseIdentifier:@"fansTableViewCell"];
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        self.tableView.footer=footer;
        // 设置文字
          [footer setTitle:@"" forState:MJRefreshStateIdle];
        // [footer setTitle:@"Loading more ..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
          [self.view addSubview: self.tableView];
    }else{
        self.tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 41, self.view.frame.size.width, self.view.frame.size.height-104)style:UITableViewStyleGrouped];
                          
    }
    if ( _nodataView == nil )
    {
        _nodataView = [noDataView loadFromXib];
        _nodataView.frame = rect;
        _nodataView.hidden = YES;
       
        [self.view addSubview:_nodataView];
    }else
    {
        _nodataView.frame = rect;
    }
    [self.view bringSubviewToFront:_nodataView];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    fansTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"fansTableViewCell" forIndexPath:indexPath];

    cell.fansObject=[self.dataArray objectAtIndex:indexPath.row];
    [cell layoutCellSubviews];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    fansObject* fansObject = self.dataArray[indexPath.row];
    FSdefsViewController *vc = [[FSdefsViewController alloc] init];
    vc.userID = fansObject.userID;
    NSString *str1 = fansObject.nickName;
    str1.length>8?str1=[NSString stringWithFormat:@"%@...",[fansObject.nickName substringToIndex:8]]:(str1=fansObject.nickName);
    vc.title = [NSString stringWithFormat:@"%@的粉丝",str1];
    [self.navigationController pushViewController:vc animated:YES];

    
}
-(void)didPressBtnTag:(NSInteger)btnTag withUPDown:(NSInteger)ud{
    if (ud==1) {
        self.upDown=1;
    }else{
        self.upDown=2;
    }
    self.sortBy=btnTag;
    //暂时不支持金额排序，临时的；
    if (self.sortBy==2) {
        self.upDown=2;

    }
    

    [self loadNewData:YES];
         
}
-(void)loadMoreData{
    [self loadNewData:NO];
}


@end
