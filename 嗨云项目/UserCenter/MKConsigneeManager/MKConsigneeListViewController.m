//
//  MKConsigneeListViewController.m
//  YangDongXi
//
//  Created by cocoa on 15/4/7.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKConsigneeListViewController.h"
#import "MKConsigneeEditViewController.h"
#import "UIViewController+MKExtension.h"
#import "UIColor+MKExtension.h"
#import <UIAlertView+Blocks.h>
#import "NSArray+MKExtension.h"
#import "MKBaseLib.h"
#import "MKBaseObject.h"
#import "MKConsigneeObject.h"
#import "MKConsigneeCell.h"
#import "MKAddConsigneeCell.h"
#import "MKCouponViewController.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKConsigneeObject.h"
#import "MKConsigneeEditViewController.h"
#import "MKNetworking+BusinessExtension.h"
#import "MKConsigneeDetailCell.h"
#import "MKConsigneeSimpleOperationCell.h"

@interface MKConsigneeListViewController ()<MKConsigneeEditViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *addressArray;
@property (nonatomic, weak) IBOutlet UIView *addressBackView;
@property (nonatomic, weak) IBOutlet UIView *addressView;
@property (nonatomic, weak) IBOutlet UIButton *addAddressBtn;
@property (nonatomic, strong) UIImageView *sectionHeaderImageView;
@property (weak, nonatomic) IBOutlet UIView *butomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@end

@implementation MKConsigneeListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的地址";
    if (self.canSelected) {
        self.title = @"选择地址";
    }
    self.addressArray = [NSMutableArray array];

    self.sectionHeaderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 10)];
    self.sectionHeaderImageView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    
    self.addAddressBtn.clipsToBounds = YES;
    self.addAddressBtn.layer.cornerRadius = 3;
    self.addAddressBtn.layer.borderWidth = 0.5;
    self.addAddressBtn.layer.borderColor = [UIColor colorWithHex:0xff4b55].CGColor;
    
    self.addressView.clipsToBounds = YES;
    self.addressView.layer.cornerRadius = 50;
    self.addressBackView.hidden = YES;
    
    
    //注册所需要的cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MKConsigneeDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"detailCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MKConsigneeSimpleOperationCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"operationCell"];
    self.tableView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self loadData];
}

//获取地址列表
- (void)loadData
{
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    [MKNetworking MKSeniorGetApi:@"/user/consignee/list" paramters:nil completion:^(MKHttpResponse *response)
     {
         [ hud hide:YES];
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             self.tableView.hidden = YES;
             self.addressBackView.hidden = NO;
             return ;
         }
         [self.addressArray removeAllObjects];
         NSArray *db = [response mkResponseData][@"consignee_list"];
         for (NSDictionary *d in db)
         {
             MKConsigneeObject *item = [MKConsigneeObject objectWithDictionary:d];
             [self.addressArray addObject:item];
         }
         [self refreshView];
         [self.tableView reloadData];
     }];
}

- (void)refreshView
{
    if (self.addressArray && self.addressArray.count >0)
    {
        self.tableView.tableHeaderView = self.sectionHeaderImageView;
        self.addressBackView.hidden = YES;
        self.tableViewHeight.constant = 50;
        self.tableView.hidden = NO;
    }
    else
    {
        self.addressBackView.hidden = NO;
        self.tableView.tableHeaderView = nil;
        self.tableViewHeight.constant = 0;
        self.tableView.hidden = YES;
    }
}


#pragma mark ---- UITableViewDataSource,UITableViewDelegate --------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {//分组总数
    if (self.addressArray.count >0 ) {
        return self.addressArray.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        if (self.addressArray.count) {
            MKConsigneeObject *consigneItem = [[MKConsigneeObject alloc] init];
            consigneItem = [self.addressArray objectAtIndex:indexPath.section];
            if (!consigneItem.idNo || [consigneItem.idNo isEqualToString:@""]) {
                return 100;
            }
        }
        return 120;
    }else {
        return 35;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKConsigneeObject *consigneItem = [[MKConsigneeObject alloc] init];
    if (self.addressArray.count) {
        consigneItem = [self.addressArray objectAtIndex:indexPath.section];
    }
    
    if (indexPath.row == 0) {
        MKConsigneeDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
        [detailCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [detailCell loadCellWithItem:consigneItem];
        return detailCell;
    }else {
        MKConsigneeSimpleOperationCell *operationCell = [tableView dequeueReusableCellWithIdentifier:@"operationCell" forIndexPath:indexPath];
        [operationCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (consigneItem.isDefault) {
            [operationCell.isDefault setImage:[UIImage imageNamed:@"dizhitianjia_gouxuan"] forState:UIControlStateNormal];
        }else {
            [operationCell.isDefault setImage:[UIImage imageNamed:@"dizhitianjia_weigouxuan"] forState:UIControlStateNormal];
        }
        
        operationCell.editButton.tag = indexPath.section + 100;
        operationCell.deleteButton.tag = indexPath.section + 200;
        operationCell.setDefaultButton.tag = indexPath.section + 300;
        [operationCell.deleteButton addTarget:self action:@selector(deleteConsignee:) forControlEvents:UIControlEventTouchUpInside];
        [operationCell.editButton addTarget:self action:@selector(pushToConsigneeEditVC:) forControlEvents:UIControlEventTouchUpInside];
        [operationCell.setDefaultButton addTarget:self action:@selector(setDefaultConsignee:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.canSelected) {
            operationCell.rightConstant.constant = -70;
            operationCell.btnConstant.constant = -75;
            operationCell.setDefaultButton.backgroundColor = [UIColor whiteColor];
            operationCell.deleteButton.hidden = YES;
            operationCell.setDefaultButton.userInteractionEnabled = NO;
        }
        
        return operationCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 10)];
    
    view.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKConsigneeObject *consigneeItem1 = (MKConsigneeObject*)
    [self.addressArray objectAtIndex:indexPath.section];
    
    if (self.canSelected) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectConsignee:)])
        {
            [self.delegate didSelectConsignee:consigneeItem1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }
    
//    else
//    {
//        MKConsigneeEditViewController *Vc = [MKConsigneeEditViewController create];
//        Vc.delegate = self;
//        Vc.consigneeItem = consigneeItem1;
//        Vc.isEdit = YES;
//        Vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:Vc animated:YES];
//    }
}


- (void)pushToConsigneeEditVC:(UIButton *) button{
    MKConsigneeEditViewController *Vc = [MKConsigneeEditViewController create];
    MKConsigneeObject *consigneeItem = (MKConsigneeObject*)[self.addressArray objectAtIndex:button.tag - 100];
    Vc.canSelected = self.canSelected;
    Vc.isTax = self.isTax;
    Vc.delegate = self;
    Vc.isEdit = YES;
    Vc.consigneeItem = consigneeItem;
    Vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:Vc animated:YES];
}

- (void)deleteConsignee:(UIButton *) button {
    NSMutableArray *ar = [NSMutableArray array];
    MKConsigneeObject *consigneeItem = (MKConsigneeObject*)[self.addressArray objectAtIndex:button.tag - 200];
    [ar addObject:consigneeItem.consigneeUid];
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除收货地址吗？" delegate:nil
                                       cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    al.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex)
    {
        if (buttonIndex == 0)
        {
            return ;
        }
        NSString *str = [ar jsonString];
        
        MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
        [MKNetworking MKSeniorPostApi:@"/user/consignee/delete" paramters:@{@"consignee_uid_list" : str} completion:^(MKHttpResponse *response)
         {
             [ hud hide:YES];
             if (response.errorMsg != nil)
             {
                 [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
                 return ;
             }
             [MBProgressHUD showMessageIsWait:@"删除成功" wait:YES];
             
             [self.addressArray removeObject:consigneeItem];
             [self.tableView reloadData];
             [self refreshView];
         }];
    };
    [al show];
}

- (void)setDefaultConsignee:(UIButton *) button {
    MKConsigneeObject *consigneeItem = (MKConsigneeObject*)[self.addressArray objectAtIndex:button.tag - 300];
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    if (consigneeItem.isDefault) {
        [ hud hide:YES];
    }else {
        [MKNetworking MKSeniorPostApi:@"/user/consignee/default/set"paramters:@{@"consignee_uid" : consigneeItem.consigneeUid} completion:^(MKHttpResponse *response)
         {
             [ hud hide:YES];
             if (response.errorMsg != nil)
             {
                 [MBProgressHUD showMessageIsWait:[NSString stringWithFormat:@"设置默认地址时发生错误了!\n%@", response.errorMsg] wait:YES];
                 return ;
             }
             consigneeItem.isDefault = 1;
             for (MKConsigneeObject *item in self.addressArray) {
                 if (item.consigneeUid != consigneeItem.consigneeUid) {
                     item.isDefault = 0;
                 }
             }
             [MBProgressHUD showMessageIsWait:@"设置成功" wait:YES];
             [self.tableView reloadData];
         }];
    }
    
}


- (IBAction)clickAddAddressBtn:(id)sender
{
    MKConsigneeEditViewController *Vc = [MKConsigneeEditViewController create];
    Vc.delegate = self;
    Vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:Vc animated:YES];
}

- (void)didSuccessModifyAddress:(MKConsigneeObject *)address;
{
    if (address) {
        [self loadData];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectConsignee:)])
    {
        [self.delegate didSelectConsignee:address];
    }
}

- (void)didSuccessFullAddAddress:(MKConsigneeObject*)address;
{
    if (address) {
        [self.addressArray addObject:address];
        [self loadData];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectConsignee:)])
    {
        [self.delegate didSelectConsignee:address];
    }
}

- (void)didSuccessDeleteAddress
{
    [self loadData];
}

@end
