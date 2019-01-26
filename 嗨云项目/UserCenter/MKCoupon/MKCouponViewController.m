//
//  MKCouponViewController.m
//  YangDongXi
//
//  Created by windy on 15/4/22.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKCouponViewController.h"
#import "MKCouponCell.h"
#import "UIColor+MKExtension.h"
#import "MBProgressHUD+MKExtension.h"
#import "NSData+MKExtension.h"
#import "MKBaseLib.h"
#import "MKCouponObject.h"
#import "MKNetworking+BusinessExtension.h"
#import "MKCouponHeadView.h"
#import "UIView+MKExtension.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import <PureLayout.h>
#import "favourableTableViewCell1.h"
#import "UIImage+MKExtension.h"
#import "WXHDownRefreshHeader.h"
@interface MKCouponViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray * titleArray;
@property (nonatomic ,strong) NSMutableArray * dataArray;
@property (nonatomic ,assign) NSInteger segmentIndex;
@property (nonatomic,assign)int a;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *highly;
@property (weak, nonatomic) IBOutlet UITextField *conversionTextF;
@property (weak, nonatomic) IBOutlet UIButton *conversionBut;
@property (nonatomic,strong)UIButton *button;



@end

@implementation MKCouponViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
//    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"选择优惠劵";
    
    self.segmentIndex = 30;
    self.titleArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
    MKCouponHeadView *segmentView = [MKCouponHeadView loadFromXib];
        
    if (!self.isSelected) {
        self.tableView.tableHeaderView = segmentView;
        [segmentView.segmentedControlBar addTarget:self action:@selector(clickSegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
        WXHDownRefreshHeader * header=[WXHDownRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        self.tableView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        self.tableView.header=header;
        header.lastUpdatedTimeLabel.hidden=YES;
        header.stateLabel.hidden=YES;
        // 马上进入刷新状态
        [self.tableView.header beginRefreshing];
        

    }
    else
    {
        self.tableView.tableHeaderView = nil;
        
        self.dataArray = self.currentArray;
        [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:50];
        UIView *view = [[UIView alloc]init];
        view.tag = 110;
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        [view autoPinEdgesToSuperviewEdgesWithInsets:(UIEdgeInsetsZero) excludingEdge:ALEdgeTop];
        [view autoSetDimension:(ALDimensionHeight) toSize:50];
        self.button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _button.backgroundColor = [UIColor whiteColor];
        [_button setTitle:@"不使用优惠劵" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor colorWithHex:0xff4b55] forState:(UIControlStateNormal)];
        [_button.layer setMasksToBounds:YES];
        [_button.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
        [_button.layer setBorderWidth:1.0]; //边框宽度
        [_button.layer setBorderColor:[UIColor colorWithHex:0xff4b55].CGColor];//边框颜色
        [_button addTarget:self action
                         :@selector(handleGoBack:) forControlEvents
                         :(UIControlEventTouchUpInside)];
        [view addSubview:_button];
        [_button autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40];
        [_button autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40];
        [_button autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
        [_button autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
        [self.tableView reloadData];
    }
}
- (void)handleGoBack:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCouponObject:)]) {
        [self.delegate didSelectCouponObject:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIView *v = self.tableView.tableHeaderView;
    v.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 67);
    self.tableView.tableHeaderView = v;
    
    [self.view layoutIfNeeded];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [(UIView *)[self.view viewWithTag:110] removeFromSuperview];
}
- (IBAction)conversionAction:(id)sender {
//    currentArray
    [self.conversionTextF resignFirstResponder];
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    [MKNetworking MKSeniorPostApi:@"/marketing/activity_coupon/exchange" paramters:@{@"coupon_code":self.conversionTextF.text} completion:^(MKHttpResponse *response) {
        [ hud hide:YES];
        if (response.errorMsg != nil) {
            [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
            return ;
        }
        
        if (self.isSelected) {
            //                    [self available:[response responseDictionary][@"coupon_uid"]];
            NSString *str = response.responseDictionary[@"data"][@"coupon_uid"];
            [self availableWith:str];
        }
    }];
    
    
}
- (void)availableWith:(NSString *)couponUid{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [MKNetworking MKSeniorPostApi:@"/marketing/activity_coupon/is_available" paramters:@{@"coupon_uid":couponUid,@"order_item_list":self.orderList} completion:^(MKHttpResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if (response.errorMsg != nil) {
            [MBProgressHUD showMessageIsWait:response.errorMsg wait:NO];
            return ;
        }
        
        if (![response responseDictionary][@"data"][@"discount_info"]) {
            [MBProgressHUD showMessageIsWait:@"兑换成功，请在个人中心查看"  wait:NO];
            return;
        }
        NSArray *ar =response.responseDictionary[@"data"][@"discount_info"][@"available_coupon_list"];
        MKCouponObject *item = [MKCouponObject objectWithDictionary:ar.firstObject];
        [self.dataArray insertObject:item atIndex:0];
        [self.tableView reloadData];
    }];
}
- (void)loadDataIsNew:(BOOL)isNew
{
    NSInteger offset = self.dataArray.count;
    if (isNew)
    {
        offset = 0;
        _a = 0;
    }
    NSLog(@"%ld",(long)offset);
    NSMutableDictionary *param =
    [NSMutableDictionary dictionaryWithDictionary:@{@"offset" : @(offset).stringValue,
                                                    @"count" : @(20).stringValue}];
    
    param[@"status"] = @(self.segmentIndex).stringValue;

    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    [MKNetworking MKSeniorGetApi:@"/marketing/user/gather_coupon/list" paramters:param completion:^(MKHttpResponse *response)
     {
         [ hud hide:YES];
        // 拿到当前的下拉刷新控件，结束刷新状态
         [self.tableView.header endRefreshing];
         // 拿到当前的上拉刷新控件，结束刷新状态
         [self.tableView.footer endRefreshing];
         
         
         if (response.errorMsg != nil)
         {
             self.tableView.footer.hidden = YES;
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
         if (isNew)
         {
             [self.dataArray removeAllObjects];
         }
         
         NSArray *db = [response mkResponseData][@"gather_coupon_list"];
         
         NSString *str = [response mkResponseData][@"total_count"];
         for (NSDictionary *couponDic in db)
         {
             MKCouponObject *item = [MKCouponObject objectWithDictionary:couponDic];
             
             _a += item.number;
             NSLog(@"%d",_a);
             if (_a == str.integerValue) {
                 [self.tableView.footer noticeNoMoreData];
             }
             if (_a > str.integerValue) {
                 [self.tableView.footer endRefreshing];
                 [self.tableView.footer noticeNoMoreData];
                 break;
             }
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
         
        [self.tableView reloadData];
     }];
}

#pragma mark -
#pragma mark ------------ UITableView Datasource ------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataArray.count != 0){
        return 90;
    }
    else
    {
        return self.view.frame.size.height;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.dataArray.count != 0){
        return [self.dataArray  count];
    }
    else
    {
        return 1;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.isSelected) {
        return 0;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count != 0) {
        static NSString *ID = @"favourableTableViewCell1";
        favourableTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"favourableTableViewCell1" owner:nil options:nil] firstObject];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        cell.coupon =[self.dataArray objectAtIndex:indexPath.row];
//        cell.canSelect = NO;
        [cell layoutCellSubviews];
        if ([self.coupon.couponUid isEqualToString:cell.coupon.couponUid]) {
            UIImage *image = [UIImage imageNamed:@"yhq_beijing2"];
            cell.blackImgV.image = [image imageWithColor:[UIColor redColor]];
        }

        return cell;
    }
    
    else
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 95, 100, 100)];
        backgroundView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
        backgroundView.clipsToBounds = YES;
        backgroundView.layer.cornerRadius = 50.0f;
        [cell.contentView addSubview:backgroundView];
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake((100-46)/2,(100-32)/2 , 46, 32)];
        backgroundImageView.backgroundColor = [UIColor clearColor];
        backgroundImageView.image = [UIImage imageNamed:@"coupon icon"];
        [backgroundView addSubview:backgroundImageView];
                                     

        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 215, self.view.frame.size.width, 15)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"没有相关优惠券哦~";
        label.textColor = [UIColor colorWithHex:0x333333];
        label.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:label];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.isSelected) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, tableView.frame.size.width - 24, view.frame.size.height)];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor colorWithHex:0x333333];
        label.text = @"可用优惠券";
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(12, 29.5, tableView.frame.size.width-24, 0.5)];
        lineView.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
        [view addSubview:lineView];
        
        [view addSubview:label];
        
        return view;
    }
    return nil;
}

- (void)clickSegmentedControlAction:(UISegmentedControl *)sender
{
    
    NSLog(@"%ld",(long)sender.selectedSegmentIndex);
    if (sender.selectedSegmentIndex == 0 ) {
        self.segmentIndex = 30;
    }
    if (sender.selectedSegmentIndex == 1 ) {
        self.segmentIndex = 50;
    }
    if (sender.selectedSegmentIndex == 2 ) {
        self.segmentIndex = 60;
    }
//    self.segmentIndex = (sender.selectedSegmentIndex+3)*10;
    [self loadDataIsNew:YES];


}

- (void)loadNewData
{
    [self loadDataIsNew:YES];
}

- (void)loadMoreData
{
    [self loadDataIsNew:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSelected && self.dataArray.count)
    {
    
        MKCouponObject *couponItem =  [self.dataArray objectAtIndex:indexPath.row];
        if ([self.coupon.couponUid isEqualToString:couponItem.couponUid]) {
            [self.delegate didSelectCouponObject:nil];
            favourableTableViewCell1 *cell = [tableView cellForRowAtIndexPath:indexPath];
            UIImage *image = [UIImage imageNamed:@"yhq_beijing2"];
            cell.blackImgV.image = image;
            return;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCouponObject:)])
        {
            [self.delegate didSelectCouponObject:couponItem];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
