//
//  MKDeliveryViewController.m
//  YangDongXi
//
//  Created by windy on 15/5/4.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKDeliveryViewController.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKBaseLib.h"
#import "MKDeliveryInfo.h"
#import "MKOrderObject.h"
#import "MKDeliveryDetailItem.h"
#import "MKDeliveryDetailCell.h"
#import "UIColor+MKExtension.h"
#import <PureLayout.h>
#import "MKNetworking+BusinessExtension.h"
#import "HYDeliveryNoView.h"
#import "MKWebViewController.h"

#define cellTitleId @"titleCell"
#define cellExpressCompanyId @"expressCompany"
#define cellSingleLineTextId @"singleLineTextCell"
#define cellExpressInfoId @"MKDeliveryDetailCell"
#define cellSeperatorId @"seperatorCell"

@interface MKDeliveryViewController ()

@property (strong, nonatomic) UILabel *errorLabel;
/** 物流公司数组（包含该公司的送货信息） */
@property (strong, nonatomic) NSMutableArray *deliveryInfoArray;

//@property (strong, nonatomic) NSMutableArray *deliveryDetailArray;

@property (strong,nonatomic) HYDeliveryNoView *noView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//sectionIndex : BOOL
@property (nonatomic, strong) NSMutableDictionary *unFoldSections;
@end

@implementation MKDeliveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.unFoldSections = [NSMutableDictionary dictionary];
    
    self.deliveryInfoArray = [NSMutableArray array];
    self.title = @"物流详情";

    UINib *nib = [UINib nibWithNibName:@"MKDeliveryDetailCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellExpressInfoId];
    
    self.errorLabel.hidden = YES;
    self.tableView.hidden = YES;
    
    [self reloadData];
    
    if ( _noView == nil )
    {
        _noView = NewObject(HYDeliveryNoView);
        _noView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [_noView updateDeliverView:@"暂无物流信息" imageName:@"HYwudingdan"];
        _noView.hidden = YES;
        [self.view addSubview:_noView];
    }else
    {
        _noView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    [self.view bringSubviewToFront:_noView];
}

- (void)reloadData
{
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    
    [MKNetworking MKSeniorGetApi:@"/trade/order/delivery_info/list" paramters:@{@"order_uid" : self.orderUid} completion:^(MKHttpResponse *response) {
//        NSLog(@"%@==%@",response.responseDictionary,response.errorMsg);
        [ hud hide:YES];
        if (response.errorMsg != nil)
        {
            self.tableView.hidden = NO;
            self.errorLabel.text = response.errorMsg;
            self.errorLabel.hidden = NO;
            [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
            return ;
        }
        
        self.tableView.hidden = NO;
        self.errorLabel.hidden = YES;
        NSLog(@"%@",response.responseDictionary);
        for (NSDictionary *d in [response mkResponseData][@"delivery_info_list"])
        {
            MKDeliveryInfo *item = [MKDeliveryInfo objectWithDictionary:d];

            [self.deliveryInfoArray addObject:item];
        }
        
        [self.tableView reloadData];
        if ( self.deliveryInfoArray.count <= 0 )
        {
            self.noView.hidden = NO;
        }else
        {
            self.noView.hidden = YES;
        }
        
    }];
}

#pragma mark -
#pragma mark -------------------- Properties ---------------------

- (UILabel*)errorLabel
{
    if (!_errorLabel)
    {
        _errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        _errorLabel.center = self.view.center;
//        _errorLabel.center.y = self.view.center.y * 0.4f;
        _errorLabel.backgroundColor = [UIColor clearColor];
        _errorLabel.font = [UIFont systemFontOfSize:14];
        _errorLabel.textColor = [UIColor redColor];
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        //        [self.tableView addSubview:_errorLabel];
        self.tableView.tableFooterView = _errorLabel;
    }
    return _errorLabel;
}

#pragma mark -
#pragma mark -------------------- UITableViewDataSource,UITableViewDelegate --------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.deliveryInfoArray.count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MKDeliveryInfo *deliveryItem = self.deliveryInfoArray[section];
    if (deliveryItem.deliveryDetailList.count <= 1)
    {
        return 4;
    }
    return 3+deliveryItem.deliveryDetailList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSInteger cellsCount = [self tableView:tableView numberOfRowsInSection:section];
    //分割栏
    if (row == cellsCount - 1)
    {
        return 10;
    }
    //快递公司栏
    if (row == 0)
    {
        return 60;
    }
    //物流详情
    if (row == 1)
    {
        return 30;
    }
    //最后快递信息单元格
    MKDeliveryInfo *deliveryItem = self.deliveryInfoArray[section];
    //没有快递信息显示一个提示
    if (deliveryItem.deliveryDetailList.count == 0)
    {
        return 60;
    }
    MKDeliveryDetailItem *deliveryDetailItem = [deliveryItem.deliveryDetailList objectAtIndex:row-2];
    CGFloat height = [MKDeliveryDetailCell calculateHeightWithContent:deliveryDetailItem.content withWidth:self.view.frame.size.width];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSInteger cellsCount = [self tableView:tableView numberOfRowsInSection:section];
    //分割栏
    if (row == cellsCount - 1)
    {
        return [tableView dequeueReusableCellWithIdentifier:cellSeperatorId];
    }
    //标题栏
    if (row == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellTitleId];
        UILabel *lb = (UILabel *)[cell viewWithTag:99];
        lb.textColor = [UIColor colorWithHex:0x333333];
        lb.text =  @"物流详情";
        lb.font = [UIFont systemFontOfSize:13.0f];
        return cell;
    }

    MKDeliveryInfo *deliveryItem = self.deliveryInfoArray[section];

    //快递公司栏
    if (row == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellExpressCompanyId];
        UILabel *lb = (UILabel *)[cell viewWithTag:88];
        lb.font = [UIFont systemFontOfSize:13.0f];
        lb.textColor = [UIColor colorWithHex:0x333333];
        lb.text =  [NSString stringWithFormat:@"物流公司：%@",deliveryItem.deliveryCompany];

        lb = (UILabel *)[cell viewWithTag:99];
        lb.font = [UIFont systemFontOfSize:13.0f];
        lb.textColor = [UIColor colorWithHex:0x666666];
        lb.text = [NSString stringWithFormat:@"运单编号：%@", deliveryItem.deliveryCode];
        
        UIButton *copyBtn = (UIButton *)[cell viewWithTag:101];
        copyBtn.layer.cornerRadius = 3.0;
        copyBtn.layer.masksToBounds = YES;
        copyBtn.layer.borderColor = kHEXCOLOR(0x999999).CGColor;
        copyBtn.layer.borderWidth = 0.5f;
        [copyBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchDown];
        
        return cell;
    }
    //物流单元格
    //没有快递信息显示一个提示
    if (deliveryItem.deliveryDetailList.count == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellSingleLineTextId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *lb = (UILabel *)[cell viewWithTag:99];
        lb.text = @"暂无物流信息";
        return cell;
    }
    MKDeliveryDetailItem *deliveryDetailItem = deliveryItem.deliveryDetailList[row - 2];
    MKDeliveryDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellExpressInfoId];
    [cell updateExpressInfo:deliveryDetailItem.content andTime:deliveryDetailItem.opTime];
    if (deliveryItem.deliveryDetailList.count == 1)
    {
        [cell updateCellPosition:DeliveryCellPositionSingle];
    }
    else if (row == 2)
    {
        [cell updateCellPosition:DeliveryCellPositionTop];
    }

    else
    {
        [cell updateCellPosition:DeliveryCellPositionMiddle];
    }
    if (deliveryItem.deliveryDetailList.count +1 == row) {
         [cell updateCellPosition:DeliveryCellPositionBottom];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ( indexPath.row == 0 ) {
        if ( self.deliveryInfoArray
            && self.deliveryInfoArray.count>0 )
        {
            MKDeliveryInfo *deliveryItem = self.deliveryInfoArray[0];
            MKWebViewController *class = [[MKWebViewController alloc]init];
            [class loadUrls:[NSString stringWithFormat:@"%@",deliveryItem.expressUrl]];
            [self.navigationController pushViewController:class animated:YES];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark -复制订单编号
-(void)onButton:(id *)sender
{
        if ( self.deliveryInfoArray
            && self.deliveryInfoArray.count>0 )
        {
            MKDeliveryInfo *deliveryItem = self.deliveryInfoArray[0];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string        = [NSString stringWithFormat:@"%@",deliveryItem.deliveryCode];
            [MBProgressHUD showMessageIsWait:@"运单编号复制成功！" wait:YES];
        }
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
