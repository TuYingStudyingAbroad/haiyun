//
//  MyHBViewController.m
//  嗨云项目
//
//  Created by kans on 16/5/12.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MyHBViewController.h"
#import "MyHBCell.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
#import "haiBiObject.h"
#import "tradeTypeObject.h"
#import "HBGZViewController.h"
#import "MKWebViewController.h"
#import "WXHDownRefreshHeader.h"
@interface MyHBViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    
}

@property (nonatomic,strong)UIButton *srBtn;
@property (nonatomic,strong)UILabel *srL;
@property (nonatomic,strong)UIButton *zcBtn;
@property (nonatomic,strong)UILabel *zcL;
@property (nonatomic,strong)UILabel *HBL;
@property (nonatomic,strong)UILabel *gqHBL;
@property (nonatomic,strong)UILabel *djzL;
@property (nonatomic,strong)UIView  *footView;
//嗨币收入支出类型
@property (nonatomic,retain)NSString *tradeType;
@property (nonatomic,retain)haiBiObject *hbObj;
@end

@implementation MyHBViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    _tradeType = @"0";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"我的嗨币";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    //[saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"bangzhuzhongxin"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem= rightItem;
    // Do any additional setup after loading the view from its nib.
}


//嗨币规则
-(void)saveBtnClick:(UIButton *)btn {
    
//    HBGZViewController *hbgz = [[HBGZViewController alloc] init];
//    
//    [self.navigationController pushViewController:hbgz animated:YES];
    MKWebViewController *vc = [[MKWebViewController alloc] init];
    [vc loadUrls:[NSString stringWithFormat:@"%@/haibi-desc.html?disable-app-share=1",BaseHtmlURL]];
    [vc webViewTitle:@"嗨币规则"];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    //MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
   
    [MKNetworking MKSeniorGetApi:@"/marketing/wealth_account/coin" paramters:param completion:^(MKHttpResponse *response)
     {
         
         //[ hud hide:YES];
         
         if (response.errorMsg != nil)
         {
             _tableView.footer.hidden = YES;
             
             _djzL.text = [NSString stringWithFormat:@"冻结中:%d",0];
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
         
         NSDictionary *db = [response mkResponseData][@"wealth_account"];
         NSLog(@"%@",db);
         _hbObj = [haiBiObject objectWithDictionary:db];
         _HBL.text = [NSString stringWithFormat:@"%ld",(long)_hbObj.amount];
         if (_hbObj.amount > 99999999) {
             
             _HBL.text = @"99999999+";
         }
         _gqHBL.text = [NSString stringWithFormat:@"%ld嗨币即将过期",(long)_hbObj.willExpireAmount];
         if (_hbObj.willExpireAmount == 0) {
             
             _gqHBL.text = nil;
         }
         _djzL.text = [NSString stringWithFormat:@"冻结中:%ld",(long)_hbObj.transitionAmount];
         
        
         
     }];

    
    
}
-(void)createUI {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 210)];
    //headerView.backgroundColor = [UIColor colorWithHex:0xe6e6e6];
   
    UIImageView *backIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 160)];
    backIV.image = [UIImage imageNamed:@"beijing"];
    [headerView addSubview:backIV];
    
    UILabel *kyhbL = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, [UIScreen mainScreen].bounds.size.width-24, 20)];
    kyhbL.text = @"可用嗨币";
    kyhbL.textColor = [UIColor colorWithHex:0xffffff];
    kyhbL.font = [UIFont systemFontOfSize:12];
    [headerView addSubview:kyhbL];
   //显示可用嗨币数
    _HBL = [[UILabel alloc] initWithFrame:CGRectMake(12, 44, [UIScreen mainScreen].bounds.size.width-24, 30)];
    _HBL.text = [NSString stringWithFormat:@"%ld",(long)_hbObj.amount];
    _HBL.textAlignment = NSTextAlignmentCenter;
    _HBL.textColor = [UIColor colorWithHex:0xffffff];
    _HBL.font = [UIFont systemFontOfSize:30];
    [headerView addSubview:_HBL];
    //显示即将过期嗨币数
    _gqHBL = [[UILabel alloc] initWithFrame:CGRectMake(12, 80, [UIScreen mainScreen].bounds.size.width-24, 10)];
    //_gqHBL.text = @"2000嗨币即将过期";
    _gqHBL.textAlignment = NSTextAlignmentCenter;
    _gqHBL.textColor = [UIColor colorWithHex:0xffffff];
    _gqHBL.font = [UIFont systemFontOfSize:11];
    [headerView addSubview:_gqHBL];
    //下面透明View
    UIView *downBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, [UIScreen mainScreen].bounds.size.width, 40)];
    downBackView.backgroundColor = [UIColor whiteColor];
    downBackView.alpha = 0.08;
    [headerView addSubview:downBackView];
    
    //冻结中
    _djzL = [[UILabel alloc] initWithFrame:CGRectMake(12, 130, [UIScreen mainScreen].bounds.size.width-24, 20)];
    //_djzL.text = @"冻结中: 6666";
    _djzL.textColor = [UIColor colorWithHex:0xffffff];
    _djzL.font = [UIFont systemFontOfSize:12];
    [headerView addSubview:_djzL];

    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 160, [UIScreen mainScreen].bounds.size.width/2, 50)];
    //leftView.backgroundColor = [UIColor greenColor];
    [headerView addSubview:leftView];
    //收入按钮
    _srBtn = [[UIButton alloc] initWithFrame:CGRectMake((leftView.frame.size.width-80)/2, 10, 80, 30)];
    [_srBtn setTitle:@"收入" forState:UIControlStateNormal];
    _srBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_srBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_srBtn addTarget:self action:@selector(srBtn:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:_srBtn];
    
    _srL = [[UILabel alloc] initWithFrame:CGRectMake((leftView.frame.size.width-40)/2, 48, 40, 1)];
    _srL.backgroundColor = [UIColor redColor];
    [leftView addSubview:_srL];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 160, [UIScreen mainScreen].bounds.size.width/2, 50)];
    //_srBtn.titleLabel.font = [UIFont systemFontOfSize:14];rightView.backgroundColor = [UIColor orangeColor];
    [headerView addSubview:rightView];
    //支出按钮
    _zcBtn = [[UIButton alloc] initWithFrame:CGRectMake((rightView.frame.size.width-80)/2, 10, 80, 30)];
    [_zcBtn setTitle:@"支出" forState:UIControlStateNormal];
    _zcBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_zcBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_zcBtn addTarget:self action:@selector(zcBtn:) forControlEvents:UIControlEventTouchUpInside];

    [rightView addSubview:_zcBtn];
    
    _zcL = [[UILabel alloc] initWithFrame:CGRectMake((rightView.frame.size.width-40)/2, 48, 40, 1)];
    _zcL.backgroundColor = [UIColor clearColor];
    [rightView addSubview:_zcL];
   
    UILabel *lineL1 = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height-1, headerView.frame.size.width, 1)];
    lineL1.backgroundColor = [UIColor blackColor];
    lineL1.alpha = 0.05;
    [headerView addSubview:lineL1];
    
    UILabel *lineL2 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, backIV.frame.size.height, 1, 50)];
    lineL2.backgroundColor = [UIColor blackColor];
    lineL2.alpha = 0.05;
    [headerView addSubview:lineL2];
    [self.view addSubview:headerView];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 210, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-230) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor colorWithHex:0xe6e6e6];
    //_tableView.tableHeaderView = headerView;
    
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-210-64)];
    _footView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    
    UIImageView *unHaveIV = [[UIImageView alloc] initWithFrame:CGRectMake((_footView.frame.size.width-80)/2, (_footView.frame.size.height-80)/2, 80, 80)];
    unHaveIV.image = [UIImage imageNamed:@"haibi_wujilu"];
    [_footView addSubview:unHaveIV];
    
    UILabel *unhaveLabel = [[UILabel alloc] initWithFrame:CGRectMake((_footView.frame.size.width-120)/2, (_footView.frame.size.height-80)/2+90, 120, 20)];
    unhaveLabel.text = @"您还没有相关记录~";
    unhaveLabel.textColor = [UIColor colorWithHex:0x999999];
    unhaveLabel.textAlignment = NSTextAlignmentCenter;
    unhaveLabel.adjustsFontSizeToFitWidth = YES;
    [_footView addSubview:unhaveLabel];
  
    [_tableView registerNib:[UINib nibWithNibName:@"MyHBCell" bundle:nil] forCellReuseIdentifier:@"wyh"];

    WXHDownRefreshHeader * header=[WXHDownRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _tableView.header=header;
    header.lastUpdatedTimeLabel.hidden=YES;
    header.stateLabel.hidden=YES;
    
    _tableView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 马上进入刷新状态
    [_tableView.header beginRefreshing];
    
}
-(void)loadNewData {

    [self loadDataIsNew:YES];
    
}
-(void)loadMoreData {
    
    [self loadDataIsNew:NO];
}

- (void)loadDataIsNew:(BOOL)isNew
{
    NSLog(@"%ld",(unsigned long)_dataArray.count);
    NSInteger offset = _dataArray.count;
    if (isNew)
    {
        
        offset = 0;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:_tradeType forKey:@"trade_type"];
    [param setObject:@"3" forKey:@"wealth_type"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)offset] forKey:@"offset"];
    [param setObject:@"15" forKey:@"count"];
    NSLog(@"%@",param);
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    
    [MKNetworking MKSeniorGetApi:@"/marketing/wealth_account/record/list" paramters:param completion:^(MKHttpResponse *response)
     {
         [ hud hide:YES];
         [_tableView.header endRefreshing];
         [_tableView.footer endRefreshing];
         
         if (response.errorMsg != nil)
         {
             NSLog(@"%@",response.errorMsg);
             if ([response.errorMsg isEqualToString:@"wealthType is invalid"]) {
                 
                 response.errorMsg = @"网络异常";
             }
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             // self.tableView.hidden = YES;
             return ;
         }
         if (isNew)
         {
             [_dataArray removeAllObjects];
         }
         NSArray *db = [response mkResponseData][@"wealth_log_list"];
         NSLog(@"%@",db);
         for (NSDictionary *dict in db) {
             
             tradeTypeObject *ty = [tradeTypeObject objectWithDictionary:dict];
             
             [_dataArray addObject:ty];
         }
        
         if (_dataArray.count <= 0)
         {
             [_tableView reloadData];
             _tableView.footer.hidden = YES;
             _tableView.tableFooterView = self.footView;
             return;
         }
          _tableView.footer.hidden = NO;
          _tableView.tableFooterView = nil;
         
         NSInteger total = [[response mkResponseData][@"total_count"] integerValue];
         //NSLog(@"%ld",total);
         
         if (_dataArray.count >= total)
         {
             [_tableView.footer noticeNoMoreData];
         }
         
         else
             
         {
             [_tableView.footer resetNoMoreData];
         }

         [_tableView reloadData];
         
     }];
}

//收入
-(void)srBtn:(UIButton *)btn {
    _srBtn.titleLabel.textColor = [UIColor colorWithHex:0xff2741];
    _srL.backgroundColor = [UIColor redColor];
    _zcBtn.titleLabel.textColor = [UIColor blackColor];
    _zcL.backgroundColor = [UIColor clearColor];
    _tradeType = @"0";
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
//                       [_dataArray removeAllObjects];
                       [_tableView.header beginRefreshing];
                       
                   });
}
//支出
-(void)zcBtn:(UIButton *)btn {
 
    _srBtn.titleLabel.textColor = [UIColor blackColor];
    _srL.backgroundColor = [UIColor clearColor];
    [_zcBtn setTitleColor:[UIColor colorWithHex:0xff2741] forState:UIControlStateNormal];
    _zcL.backgroundColor = [UIColor redColor];
    _tradeType = @"1";
    dispatch_async(dispatch_get_main_queue(), ^
                   {
//                        [_dataArray removeAllObjects];
                       [_tableView.header beginRefreshing];

                   });
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( indexPath.row < _dataArray.count )
    {
        tradeTypeObject *ty = _dataArray[indexPath.row];
        
        MyHBCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wyh" forIndexPath:indexPath];
        cell.fgxL.backgroundColor = [UIColor colorWithHex:0xe8e8e8];
        cell.dianpuL.text = ty.textName;
        cell.dianpuL.textColor = [UIColor colorWithHex:0x252525];
        cell.timeL.text = ty.timeName;
        cell.timeL.textColor = [UIColor colorWithHex:0x999999];
        cell.moneyL.text = [NSString stringWithFormat:@"%ld",(long)ty.amount];
        cell.moneyL.textColor = [UIColor colorWithHex:0x252525];
        if (ty.status == 0) {
            
            cell.tepyL.text = @"冻结中";
            cell.tepyL.textColor = [UIColor colorWithHex:0xff2741];
            //cell.dianpuL.textColor = [UIColor colorWithHex:0x999999];
        }
        if (ty.status == 1) {
            
            cell.tepyL.text = nil;
            
        }
        if (ty.status == 2) {
            
            cell.tepyL.text = @"已取消";
            cell.tepyL.textColor = [UIColor colorWithHex:0x999999];
            
        }
        //    if (ty.status == 3) {
        //        cell.tepyL.text = @"过期";
        //        cell.dianpuL.textColor = [UIColor colorWithHex:0x999999];
        //        cell.timeL.textColor = [UIColor colorWithHex:0x999999];
        //        cell.moneyL.textColor = [UIColor colorWithHex:0x999999];
        //        cell.tepyL.textColor = [UIColor colorWithHex:0x999999];
        //    }
        if (ty.orderUid == nil&&_tradeType.intValue == 1) {
            
            cell.tepyL.text = @"过期";
            cell.dianpuL.textColor = [UIColor colorWithHex:0x999999];
            cell.timeL.textColor = [UIColor colorWithHex:0x999999];
            cell.moneyL.textColor = [UIColor colorWithHex:0x999999];
            cell.tepyL.textColor = [UIColor colorWithHex:0x999999];
            
        }else if (ty.orderUid != nil && _tradeType.intValue == 1) {
            
            cell.tepyL.text = nil;
            cell.dianpuL.textColor = [UIColor colorWithHex:0x252525];
            cell.timeL.textColor =  [UIColor colorWithHex:0x999999];
            cell.moneyL.textColor = [UIColor colorWithHex:0x252525];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [[UIView alloc]init];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
