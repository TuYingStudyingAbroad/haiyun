//
//  MKShoppingCartViewController.m
//  YangDongXi
//
//  Created by cocoa on 15/4/17.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKShoppingCartViewController.h"
#import "AppDelegate.h"
#import "MKStoreNameCell.h"
#import "MKShoppingCartCell.h"
#import "MKExceptionView.h"
#import "MKConfirmOrderViewController.h"
#import "MKItemDetailViewController.h"
//-------------------------//--------------------------------//
#import "MKBaseLib.h"
#import <UIAlertView+Blocks.h>
#import <PureLayout.h>
#import "UIView+MKExtension.h"
#import "UIViewController+MKExtension.h"
#import "UIColor+MKExtension.h"
#import "NSArray+MKExtension.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
//-------------------------//--------------------------------//
#import "MKItemObject.h"
#import "MKCartItemObject.h"
#import "MKDistributorCartObject.h"


@interface MKShoppingCartViewController () <UITableViewDataSource, UITableViewDelegate,MKShoppingCartCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIButton *allSelectBtn;

@property (nonatomic, weak) IBOutlet UIButton *confirmOrderBtn;

@property (nonatomic, weak) IBOutlet UIButton *deleteBtn;

@property (nonatomic, weak) IBOutlet UILabel *combinedLabel;

@property (nonatomic, weak) IBOutlet UILabel *symbolLabel;

@property (nonatomic, weak) IBOutlet UILabel *totalLabel;



@property (nonatomic, strong) MKExceptionView *exceptionView;

@property (nonatomic, strong) NSMutableArray *cartData;

@property (nonatomic, strong) NSMutableArray *indexArrary;

@property (nonatomic, weak) UIView *footerView;

@property (nonatomic, assign) NSInteger totalNumber;

@property (nonatomic, assign) float totalPrice;

@property (nonatomic, assign) BOOL editing;

@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, strong) UIButton *rightBtn;

@end


@implementation MKShoppingCartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"购物袋";
    [self changeTitle:@"编辑"];
   
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
   
    self.tableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    
    self.cartData = [NSMutableArray array];
    
    self.exceptionView = [MKExceptionView loadFromXib];
    self.exceptionView.imageView.image = [UIImage imageNamed:@"gouwuche_wushangpin"];
    self.exceptionView.circleView.backgroundColor = [UIColor clearColor];
    self.exceptionView.exceptionLabel.text = @"购物袋还是空空的哦~";
    self.exceptionView.exceptionLabel.textColor = [UIColor colorWithHex:0x999999];
    self.exceptionView.goHomePageBtn.hidden = NO;
    [self.exceptionView.goHomePageBtn addTarget:self action:@selector(pushHomePage) forControlEvents:UIControlEventTouchUpInside];
    self.exceptionView.goHomePageBtn.layer.masksToBounds = YES;
    self.exceptionView.goHomePageBtn.layer.cornerRadius = 5;
    self.exceptionView.goHomePageBtn.layer.borderWidth = 1;
    self.exceptionView.goHomePageBtn.layer.borderColor = [UIColor colorWithHex:0xff2741].CGColor;
    
    self.exceptionView.hidden = YES;

    [self.view addSubview:self.exceptionView];
    [self.exceptionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MKStoreNameCell" bundle:nil] forCellReuseIdentifier:@"storeNameCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MKShoppingCartCell" bundle:nil] forCellReuseIdentifier:@"shoppingCartCell"];
    [self configFootView];
}
- (void)pushHomePage{
    [getMainTabBar guideToHome];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[getUserCenter.shopCart clear];
   NSArray *item = [getUserCenter.shopCart lastItemFromIndex:0 count:100];
    if (![getUserCenter isLogined]) {
        
        if (item.count == 0) {
            
            self.exceptionView.hidden = NO;
            self.tableView.hidden = YES;
            self.footerView.hidden = YES;
            self.navigationItem.rightBarButtonItem = nil;

            
        }else {
            
            [self.cartData removeAllObjects];
            MKDistributorCartObject *distrbutorObj = [[MKDistributorCartObject alloc] init];
            MKCartItemObject *obj = item[0];
            distrbutorObj.itemModelList = [NSMutableArray arrayWithArray:item];
            distrbutorObj.distributorId = obj.distributorId;
            distrbutorObj.distributorShopName = nil;
            distrbutorObj.number = obj.number;
            [self.cartData addObject:distrbutorObj];
            
            [self calculateTotalPrice];
            [self refreshUI];
            [self selectAllButtonClick:self.allSelectBtn];
 
            
        }
        self.totalNumber = item.count;
        if ( _totalNumber > 0 )
        {
            self.navigationItem.title = [NSString stringWithFormat:@"购物袋(%ld)",(long)_totalNumber];
        }else
        {
            self.navigationItem.title = @"购物袋";
        }
        
    } else
    {
      
        if (item.count > 0) {
            
            
            NSMutableArray *cartArray = [[NSMutableArray alloc] init];
           
            for (MKCartItemObject *cartObj in item) {
                NSMutableDictionary *cartDict = [[NSMutableDictionary alloc] init];
                [cartDict setObject:cartObj.skuUid forKey:@"sku_uid"];
                [cartDict setObject:[NSString stringWithFormat:@"%ld",cartObj.number] forKey:@"number"];
                [cartArray addObject:cartDict];
            }
           
            NSString *cartStrring = [cartArray jsonString];
           
        
            [MKNetworking MKSeniorPostApi:@"/trade/cart/batch/add" paramters:@{@"cart_item_list":cartStrring}                               completion:^(MKHttpResponse *response)
             {
                 
                 if (response.errorMsg != nil)
                 {
                     [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
                     [self.cartData removeAllObjects];
                     [self calculateTotalPrice];
                     [self.tableView reloadData];
                     return ;
                 }

                 [getUserCenter.shopCart clear];
                 [self loadData];
             }];
                 //[self loadData];

            
        }else {
            
            [self loadData];
        }
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.allSelectBtn.selected = NO;
    
}

-(void)setupRightLeftButtonItem:(UIBarButtonItem *)barBtn Colors:(UIColor *)btnColor
{
    //设置整个项目的item状态
    
    //设置item普通状态
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    attrs[NSForegroundColorAttributeName] = btnColor;
    [barBtn setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    //设置item不可用状态
    NSMutableDictionary *disabledAttrs = [NSMutableDictionary dictionary];
    disabledAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    disabledAttrs[NSForegroundColorAttributeName] = btnColor;
    [barBtn setTitleTextAttributes:disabledAttrs forState:UIControlStateDisabled];
}


/**
 *  加载底部控件
 */
- (void)configFootView
{
    self.confirmOrderBtn.layer.cornerRadius = 3;
    self.confirmOrderBtn.layer.masksToBounds = YES;
    self.confirmOrderBtn.hidden = NO;
    
    self.deleteBtn.layer.borderColor = [UIColor colorWithHex:0xff4b55].CGColor;
    self.deleteBtn.layer.cornerRadius = 3;
    self.deleteBtn.layer.borderWidth = 1;
    self.deleteBtn.hidden = YES;
}


/**
 *  刷新所有View及tableView
 */
- (void)refreshAllViews
{
    if (self.cartData.count > 0)
    {
        NSInteger num = 0;
        for (MKDistributorCartObject *item in self.cartData) {
            if (item.itemModelList.count) {
                num = num + 1;
            }
        }
        if (num > 0) {
            self.footerView.hidden = NO;
            self.exceptionView.hidden = YES;
            self.tableView.hidden = NO;
//            UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.editing ? @"完成" : @"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editBtn:)];
            [self changeTitle:self.editing ? @"完成" : @"编辑"];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
        }else {
            self.exceptionView.hidden = NO;
            self.tableView.hidden = YES;
            self.footerView.hidden = YES;
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
    else
    {
        self.exceptionView.hidden = NO;
        self.tableView.hidden = YES;
        self.footerView.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
    }
}

/**
 *  刷新界面
 */
- (void)refreshUI
{
    [self refreshAllViews];
    [self.tableView reloadData];
}

/**
 *  去结算-跳转确认订单
 *
 *  @param sender nil
 */
- (IBAction)confirmOrderClick:(id)sender
{
    if ([getUserCenter isLogined]) {
        
        MKConfirmOrderViewController *confirmOrderVc = [MKConfirmOrderViewController create];
        confirmOrderVc.orderItemSource = MKOrderItemSourceShoppingCart;
        NSMutableArray *ar = [NSMutableArray array];
        for (MKDistributorCartObject *item in self.cartData)
        {
            for (MKCartItemObject *cartItem in item.itemModelList ) {
                if (cartItem.isChecked)
                {
                    [ar addObject:cartItem];
                }
            }
        }
        
        if ( ar.count > 0 )
        {
            confirmOrderVc.confirmOrderList = [NSMutableArray arrayWithArray:ar];
            [self.navigationController pushViewController:confirmOrderVc animated:YES];
        }
        else
        {
            [MBProgressHUD showMessageIsWait:@"请选择商品再结算！" wait:YES];
        }

    }else {
        
        [getUserCenter loginoutPullView];
        
        
    }
    
}


/**
 *  请求购物车数据
 */
- (void)loadData
{
    
    if (self.isLoading)
    {
        return;
    }
    self.isLoading = YES;
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
    [MKNetworking MKSeniorGetApi:@"/trade/distributor/cart/item/list" paramters:nil completion:^(MKHttpResponse *response)
     {
         [ hud hide:YES];
         self.isLoading = NO;
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             [self.cartData removeAllObjects];
             [self calculateTotalPrice];
             [self.tableView reloadData];
             
             return ;
         }
         
         NSMutableArray *cartArray = [NSMutableArray array];
         NSArray *db = [response mkResponseData][@"distributor_cart_list"];
         self.totalNumber = [[response mkResponseData][@"total_count"] integerValue];
         if ( _totalNumber > 0 )
         {
             self.navigationItem.title = [NSString stringWithFormat:@"购物袋(%ld)",(long)_totalNumber];
         }else
         {
             self.navigationItem.title = @"购物袋";
         }
         for (NSDictionary *totalDic in db)
         {
             MKDistributorCartObject *distrbutorObj = [MKDistributorCartObject objectWithDictionary:totalDic];
             distrbutorObj.itemModelList = [NSMutableArray array];
             for (NSDictionary *itemDic in distrbutorObj.itemList) {
                 MKCartItemObject *item = [MKCartItemObject objectWithDictionary:itemDic];
                 if (item.status.integerValue == 2 || item.stockNum <= 0) {
                     item.status = @"2";
                 }
                 NSArray *bizArr = [[NSArray alloc] init];
                 bizArr = [itemDic objectForKey:@"biz_mark_list"];
                 if (bizArr != nil) {
                   item.bizMark = [bizArr[0] objectForKey:@"remark"];
                 }
                 item.distributorId = distrbutorObj.distributorId;
                 [distrbutorObj.itemModelList addObject:item];
             }
             [cartArray addObject:distrbutorObj];
         }
         self.cartData = [NSMutableArray arrayWithArray:cartArray];
         [self calculateTotalPrice];
         [self refreshUI];
         [self selectAllButtonClick:self.allSelectBtn];
     }];
}

/**
 *  更新商品数量并同步至服务端
 *
 *  @param index 当前商品数据位置
 *  @param delta 数量是增加还是减少
 */
//购物车商品数量更新
- (void)updateAmountWithIndex:(NSInteger)index andDelta:(NSInteger)delta with:(NSIndexPath *)path
{
    
    //如果点击的是单个商品，取到当前的cell
    if (path) {
        MKShoppingCartCell *cell = [self.tableView cellForRowAtIndexPath:path];
        MKCartItemObject *item = cell.itme;
        NSInteger c = item.number + delta;
        if (c <= 0)
        {
            return;
        }
        //设置加减数量的view
        [cell.numberEditView plusButtonEnable:NO];
        [cell.numberEditView minusButtonEnable:NO];
        
        //判断是否登陆(操作本地数据)
        NSArray *shopCartArr = [getUserCenter.shopCart lastItemFromIndex:0 count:100];
        if (shopCartArr.count > 0&&![getUserCenter isLogined]) {
            
            item.number = delta;
            [getUserCenter.shopCart newShopCartItem:item];
            [cell.numberEditView plusButtonEnable:YES];
            [cell.numberEditView minusButtonEnable:YES];
            item.number = c;
            [cell.numberEditView updateNumber:c];
            [self refreshUI];
            [cell.numberEditView minusButtonEnable:c > 1];
            [self calculateTotalPrice];
            
        }else {
            
            NSDictionary *p = @{@"cart_item_uid" : item.cartItemUid, @"number" : [NSString stringWithFormat:@"%li", (long)c]};
            [MKNetworking MKSeniorPostApi:@"/trade/cart/item/number/update" paramters:p completion:^(MKHttpResponse *response)
             {
                 [cell.numberEditView plusButtonEnable:YES];
                 [cell.numberEditView minusButtonEnable:YES];
                 if (response.errorMsg != nil)
                 {
                     [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
                     return ;
                 }else {
                     item.number = c;
                     [cell.numberEditView updateNumber:c];
                     [self refreshUI];
                     [cell.numberEditView minusButtonEnable:c > 1];
                     [self calculateTotalPrice];
                 }
             }];

        }
    }
}

#pragma mark ------tableViewDelegate and dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cartData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MKDistributorCartObject *distributorObj = self.cartData[section];
    return distributorObj.itemModelList.count  + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 10;
    }
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    view.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKDistributorCartObject *distributorObj = self.cartData[indexPath.section];
    if (indexPath.row == 0) {
        MKStoreNameCell *titleCell = [tableView dequeueReusableCellWithIdentifier:@"storeNameCell" forIndexPath:indexPath];
        [titleCell.selectButton addTarget:self action:@selector(storeSelectClick:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        titleCell.shopNameLabel.text = distributorObj.distributorShopName;
        titleCell.selectButton.selected = distributorObj.isChecked;
        titleCell.hidden = YES;
        return titleCell;
    }else {
        MKShoppingCartCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"shoppingCartCell" forIndexPath:indexPath];
        itemCell.delegate = self;
        
        [itemCell.selectButton addTarget:self action:@selector(itemSelectClick:)
                        forControlEvents:UIControlEventTouchUpInside];
        [itemCell.numberEditView addPlusTarget:self action:@selector(plusButtonClick:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [itemCell.numberEditView addMinusTarget:self action:@selector(minusButtonClick:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [itemCell.deleteBtn addTarget:self action:@selector(deleteSimpleItem:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [itemCell.cellSelectedBtn addTarget:self action:@selector(goToItemDetailView:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        MKCartItemObject *item = distributorObj.itemModelList[indexPath.row - 1];
        itemCell.itme = item;
        [itemCell updateContentWithItem:item];
        if ([itemCell.numberEditView getNumber] == 1) {
            itemCell.numberEditView.min = 0;
            [itemCell.numberEditView addMinusTarget:self action:@selector(deleteSimpleItem:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        }
        itemCell.numberEditView.tag = indexPath.row;
        itemCell.selectButton.selected = item.isChecked;
        [itemCell switchSelectButton:self.editing animation:NO];
        return itemCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [getMainTabBar guideToHome];
        return;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return NO;
    }
    return !self.editing;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    [self deleteWithIndexes:indexPath];
}

#pragma mark ------MKShoppingCartCellDelegate
- (void)willBeginEditNumOfItem:(MKCartItemObject *)item
{
    self.confirmOrderBtn.enabled = NO;
}

#pragma mark 商品操作
- (void) doNothing {
    
}

//根据点击事件取到当前所在cell的indexPath
- (NSIndexPath *)getCellIndexPathWithEvent:(UIEvent *) even {
    //通过event获取这次点击的所有点的集合
    NSSet *touchs = [even allTouches];
    //在触摸点的集合里面，获取任意一个点
    UITouch *touch = [touchs anyObject];
    //从当前view获取点击事件的位置
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    return indexPath;
}

//点击cell跳转商品详情页
- (void)goToItemDetailView:(UIButton *) button withEvent:(UIEvent *)even{
    NSIndexPath *indexPath = [self getCellIndexPathWithEvent:even];
    MKDistributorCartObject *itemObject = [self.cartData objectAtIndex:indexPath.section];
    MKItemDetailViewController *Vc = [MKItemDetailViewController create];
    MKCartItemObject *item = itemObject.itemModelList[indexPath.row - 1];
    if (self.editing)
    {
        return;
    }
    Vc.itemId = item.itemUid;
    Vc.type = 1;
    Vc.shareUserId = item.shareUserId?item.shareUserId:nil;
    [self.navigationController pushViewController:Vc animated:YES];
}

//删除商品
- (void)deleteSimpleItem:(UIButton *) button withEvent:(UIEvent *)even{
    NSIndexPath *indexPath = [self getCellIndexPathWithEvent:even];
    MKDistributorCartObject *item = self.cartData[indexPath.section];
    MKCartItemObject *cartItem = item.itemModelList[indexPath.row - 1];
    if (cartItem.number > 1 && [_rightBtn.titleLabel.text isEqualToString:@"编辑"]) {
        
        
    }else {
        [self deleteWithIndexes:indexPath];
    }
}

//增加商品数量
- (void)plusButtonClick:(UIButton *)button withEvent:(UIEvent *)even
{
    NSIndexPath *indexPath = [self getCellIndexPathWithEvent:even];
    [self updateAmountWithIndex:button.tag andDelta:1 with:indexPath];
    [self refreshUI];
}

//减少商品数量
- (void)minusButtonClick:(UIButton *)button withEvent:(UIEvent *)even
{
    NSIndexPath *indexPath = [self getCellIndexPathWithEvent:even];
    //调用更新数量的方法并将当前model的位置传过去
    [self updateAmountWithIndex:button.tag andDelta:-1 with:indexPath];
    [self refreshUI];
}

//编辑
- (void)editBtn:(id)sender
{
    self.editing = !self.editing;
    [self changeTitle:self.editing ? @"完成" : @"编辑"];
    NSArray *cells = [self.tableView visibleCells];
    float after = 0;
    for (id cell in cells)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^
                       {
                           if ([cell isKindOfClass:[MKShoppingCartCell class]] || [cell isKindOfClass:[MKStoreNameCell class]]) {
                               [cell switchSelectButton:self.editing animation:YES];
                           }
                           
                       });
        after += 0.03;
    }
    if (!self.editing) {
        [self calculateTotalPrice];
    }
}

//删除购物车商品（从服务端删除）
- (void)deleteWithIndexes:(NSIndexPath *)index
{
    
    MKDistributorCartObject *item = self.cartData[index.section];
    
    if ([_rightBtn.titleLabel.text isEqualToString:@"编辑"]) {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除这些商品吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        al.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex)
        {
            if (buttonIndex == 0)
            {
                return ;
            }
            //判断是否登陆(操作本地数据)
             NSArray *shopCartArr = [getUserCenter.shopCart lastItemFromIndex:0 count:100];
            if (shopCartArr.count > 0&&![getUserCenter isLogined]) {
                
                
                if (index.row != 0) {
                    MKCartItemObject *cartItem = item.itemModelList[index.row - 1];
                    [getUserCenter.shopCart deleteItem:cartItem];
                    
                }
                self.totalNumber = self.totalNumber - 1;
                if ( _totalNumber > 0 )
                {
                    self.navigationItem.title = [NSString stringWithFormat:@"购物袋(%ld)",(long)_totalNumber];
                }else
                {
                    self.navigationItem.title = @"购物袋";
                }
                [self calculateTotalPrice];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                               {
                                   MKDistributorCartObject *item = self.cartData[index.section];
                                   MKCartItemObject *cartItem =item.itemModelList[index.row - 1];
                                   getUserCenter.shoppingCartModel.itemCount -= cartItem.number;
                                   [item.itemModelList removeObjectAtIndex:index.row - 1];
                                   if (!item.itemModelList.count) {
                                       [self.cartData removeObject:item];
                                   }
                                   [self refreshUI];
                               });

                
                
            } else {
                NSMutableArray *ar = [NSMutableArray array];
                
                if (index.row != 0) {
                    MKCartItemObject *cartItem = item.itemModelList[index.row - 1];
                    [ar addObject:cartItem.cartItemUid];
                }

                NSString *str = [ar jsonString];
                MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
                [MKNetworking MKSeniorPostApi:@"/trade/cart/item/remove" paramters:@{@"cart_item_uid_list" : str}
                                   completion:^(MKHttpResponse *response)
                 {
                     [ hud hide:YES];
                     if (response.errorMsg != nil)
                     {
                         [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
                         return ;
                     }
                     
                     //            [self.tableView del:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationTop];
                     
                     self.totalNumber = self.totalNumber - 1;
                     if ( _totalNumber > 0 )
                     {
                         self.navigationItem.title = [NSString stringWithFormat:@"购物袋(%ld)",(long)_totalNumber];
                     }else
                     {
                         self.navigationItem.title = @"购物袋";
                     }
                     [self calculateTotalPrice];
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                                    {
                                        MKDistributorCartObject *item = self.cartData[index.section];
                                        MKCartItemObject *cartItem =item.itemModelList[index.row - 1];
                                        getUserCenter.shoppingCartModel.itemCount -= cartItem.number;
                                        [item.itemModelList removeObjectAtIndex:index.row - 1];
                                        if (!item.itemModelList.count) {
                                            [self.cartData removeObject:item];
                                        }
                                        [self refreshUI];
                                    });
                 }];

            }
        };
        [al show];
    }else {
        
        //判断是否登陆(操作本地数据)
        NSArray *shopCartArr = [getUserCenter.shopCart lastItemFromIndex:0 count:100];
        if (shopCartArr.count > 0&&![getUserCenter isLogined]) {
            
            
            if (index.row != 0) {
                MKCartItemObject *cartItem = item.itemModelList[index.row - 1];
                [getUserCenter.shopCart deleteItem:cartItem];
                
            }
            self.totalNumber = self.totalNumber - 1;
            if ( _totalNumber > 0 )
            {
                self.navigationItem.title = [NSString stringWithFormat:@"购物袋(%ld)",(long)_totalNumber];
            }else
            {
                self.navigationItem.title = @"购物袋";
            }
            [self calculateTotalPrice];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                           {
                               MKDistributorCartObject *item = self.cartData[index.section];
                               MKCartItemObject *cartItem =item.itemModelList[index.row - 1];
                               getUserCenter.shoppingCartModel.itemCount -= cartItem.number;
                               [item.itemModelList removeObjectAtIndex:index.row - 1];
                               if (!item.itemModelList.count) {
                                   [self.cartData removeObject:item];
                               }
                               [self refreshUI];
                           });
            
            
            
        } else {
            
            NSMutableArray *ar = [NSMutableArray array];
            
            if (index.row != 0) {
                MKCartItemObject *cartItem = item.itemModelList[index.row - 1];
                [ar addObject:cartItem.cartItemUid];
            }
            NSString *str = [ar jsonString];
            MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.view wait:YES];
            [MKNetworking MKSeniorPostApi:@"/trade/cart/item/remove" paramters:@{@"cart_item_uid_list" : str}
                               completion:^(MKHttpResponse *response)
             {
                 [ hud hide:YES];
                 if (response.errorMsg != nil)
                 {
                     [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
                     return ;
                 }
                 
                 //            [self.tableView del:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationTop];
                 
                 self.totalNumber = self.totalNumber - 1;
                 if ( _totalNumber > 0 )
                 {
                     self.navigationItem.title = [NSString stringWithFormat:@"购物袋(%ld)",(long)_totalNumber];
                 }else
                 {
                     self.navigationItem.title = @"购物袋";
                 }
                 [self calculateTotalPrice];
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                                {
                                    MKDistributorCartObject *item = self.cartData[index.section];
                                    MKCartItemObject *cartItem =item.itemModelList[index.row - 1];
                                    getUserCenter.shoppingCartModel.itemCount -= cartItem.number;
                                    [item.itemModelList removeObjectAtIndex:index.row - 1];
                                    if (!item.itemModelList.count) {
                                        [self.cartData removeObject:item];
                                    }
                                    [self refreshUI];
                                });
             }];


        }
        
        
    }
}

//修改购物车商品数量
- (void)didChangeCountOfItem:(MKCartItemObject *)item addOrMinus:(BOOL)addOrMinus
                   isSuccess:(BOOL)isSuccess responseObject:(MKCartItemObject *)responseObject
{
    self.confirmOrderBtn.enabled = YES;
    if (!isSuccess)
    {
        return;
    }
    [self.tableView reloadData];
    [self calculateTotalPrice];
}

//全选商品
- (IBAction)selectAllButtonClick:(UIButton *)button
{
    button.selected = !button.selected;
    BOOL isSelected = button.selected;
    
    for (MKDistributorCartObject *orderItem in self.cartData)
    {
        for (MKCartItemObject *cartItem in orderItem.itemModelList) {
            cartItem.isChecked = isSelected;
        }
    }
    
    [self calculateTotalPrice];
    [self isStoreItemSelected];
    [self.tableView reloadData];
}

//单选商品
- (void)itemSelectClick:(UIButton *)button
{
    button.selected = !button.selected;
    UITableViewCell *cell = (UITableViewCell *)button.superview;
    while (cell != nil && ![cell isKindOfClass:[UITableViewCell class]])
    {
        cell = (UITableViewCell *)cell.superview;
    }
    if ([cell isKindOfClass:[UITableViewCell class]])
    {
        NSIndexPath *indexp = [self.tableView indexPathForCell:cell];
        MKDistributorCartObject *distributorItem = self.cartData[indexp.section];
        MKCartItemObject *item = distributorItem.itemModelList[indexp.row - 1];
        item.isChecked = button.selected;
    }
    [self isStoreItemSelected];
    [self isAllItemSelected];
    [self.tableView reloadData];
}

//点击店铺标题
- (void)storeSelectClick:(UIButton *) button withEvent:(UIEvent *)even
{
    NSIndexPath *indexPath = [self getCellIndexPathWithEvent:even];
    button.selected = !button.selected;
    //通过店铺的标识来将店铺下的商品选中
    MKDistributorCartObject *item = self.cartData[indexPath.section];
    item.isChecked = button.selected;
    for (MKCartItemObject *cartItem in item.itemModelList) {
        cartItem.isChecked = button.selected;
    }
    
    [self isAllItemSelected];
    [self.tableView reloadData];
}

//判断底部全选按钮是否点亮
- (void)isAllItemSelected {
    self.allSelectBtn.selected = YES;
    for (MKDistributorCartObject *item in self.cartData) {
        if (!item.isChecked) {
            self.allSelectBtn.selected = NO;
            break;
        }
        for (MKCartItemObject *cartItem in item.itemModelList) {
            if (cartItem.status.integerValue != 2) {
                if (!cartItem.isChecked) {
                    self.allSelectBtn.selected = NO;
                }
            }
        }
    }
    [self calculateTotalPrice];
}

//判断店铺选择按钮是否点亮
- (void)isStoreItemSelected {
    for (MKDistributorCartObject *item in self.cartData) {
        item.isChecked = YES;
        for (MKCartItemObject *cartItem in item.itemModelList) {
            if (!cartItem.isChecked) {
                item.isChecked = NO;
            }
        }
    }
}

//计算购物车中选中商品的总价
- (void)calculateTotalPrice
{
    NSInteger total = 0;
    NSInteger checkCount = 0;
    self.totalPrice = 0;
    for (MKDistributorCartObject *item in self.cartData)
    {
        for (MKCartItemObject *cartItem in item.itemModelList) {
            if (cartItem.isChecked)
            {
                if (cartItem.status.integerValue != 2) {
                    self.totalPrice += cartItem.number * cartItem.promotionPrice;
                    checkCount ++ ;
                }
            }
            total = total + cartItem.number;
        }
    }
    self.totalLabel.text = [MKBaseItemObject priceString:self.totalPrice];
    NSString *str = @"去结算";
    if (checkCount > 99) {
        str = [NSString stringWithFormat:@"去结算(%@)",@"99+"];
    }else {
        str = [NSString stringWithFormat:@"去结算(%ld)",checkCount];
    }
    [self.confirmOrderBtn setTitle:str forState:UIControlStateNormal];
    getUserCenter.shoppingCartModel.itemCount = total;
}

-(void)changeTitle:(NSString *)title
{
    UIColor   *colors = [UIColor colorWithHex:0x252525];
    // 创建按钮
    if ( _rightBtn == nil )
    {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        // 设置标题
        [_rightBtn setTitle:title forState:UIControlStateNormal];
        [_rightBtn setTitleColor:colors forState:UIControlStateNormal];
        [_rightBtn setTitleColor:colors forState:UIControlStateHighlighted];
        [_rightBtn addTarget:self action:@selector(editBtn:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f]};
        CGSize btnSize = [title sizeWithAttributes:dict];
        _rightBtn.bounds = (CGRect){CGPointZero, btnSize};
    }else
    {
        [_rightBtn setTitle:title forState:UIControlStateNormal];
    }
}

@end
