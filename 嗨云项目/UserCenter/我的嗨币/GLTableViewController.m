//
//  GLTableViewController.m
//  嗨云项目
//
//  Created by 唯我独尊 on 16/8/19.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "GLTableViewController.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
#import "UIImageView+WebCache.h"
#import "finderViewController.h"
#import "AppDelegate.h"
#import "HYShopQRCodeViewController.h"
#import "HYShopInvitationViewController.h"
#import "MKWebViewController.h"
#import "getMoneyTableViewController.h"
#import "BaiduMobStat.h"

@interface GLTableViewController ()

@property(nonatomic,assign)UIStatusBarStyle myStatusBarStyle;
@property(nonatomic,copy) NSString  *shopId;

@end

@implementation GLTableViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self updateIsSeller];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.View7.hidden = YES;
    self.View8.hidden = YES;
    self.tableView.separatorStyle = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.txBackV.layer.masksToBounds = YES;
    self.txBackV.layer.cornerRadius = 35.5;
    self.txIV.layer.masksToBounds = YES;
    self.txIV.layer.cornerRadius = 32.5;
    self.txIV.layer.borderWidth = 0;
    self.txIV.layer.borderColor = [UIColor whiteColor].CGColor;
    self.myStatusBarStyle = UIStatusBarStyleLightContent;
    [self updateIsSeller];
    
}

#pragma mark -店铺信息
-(void)updateIsSeller
{
    [MKNetworking MKSeniorGetApi:@"/seller/center/get" paramters:nil
                      completion:^(MKHttpResponse *response)
     
     {
         if (response.errorMsg != nil)
         {
             [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
             return ;
         }
         
         NSDictionary *db = [response mkResponseData][@"seller_info"];
         NSString *iSseller = [response mkResponseData][@"is_seller"];
         self.glo = [GLObject objectWithDictionary:db];
         //NSLog(@"%@",glo.shopUrl);
         if (iSseller.intValue == 1)
         {
             self.jrsrL.text = [NSString stringWithFormat:@"%ld",self.glo.todayCome];
             if (self.glo.todayCome <= 0) {
                 
                 self.jrsrL.text = @"努力赚钱吧~";
             }
             self.ljsyL.text = [NSString stringWithFormat:@"%ld",self.glo.totalCome];
             [self customerManagement];
             [self myShop];
         } else
         {
//             dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//             dispatch_sync(queue, ^{
//                 [getMainTabBar changeTabarClass];
//                 
//             });
//             dispatch_async(dispatch_get_main_queue(), ^{
//                 [getMainTabBar changeTabarClass];
//             });
         }
     }];
}

//客户管理接口数据
-(void)customerManagement {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSString stringWithFormat:@"%ld",self.glo.userId] forKey:@"user_id"];
    [MKNetworking MKSeniorGetApi:@"/dist/seller/get" paramters:param
                      completion:^(MKHttpResponse *response)
     
     {
         if (response.errorMsg != nil)
         {
             return ;
         }
         NSString *djStr =[response.mkResponseData objectForKey:@"level_name"];
         if ([djStr isEqualToString:@"店主"]) {
             
             self.djL.text = djStr;
             [self.djB setBackgroundImage:[UIImage imageNamed:@"huizhangsan"] forState:UIControlStateNormal];
         }
         if ([djStr isEqualToString:@"客户经理"]) {
           
             self.djL.text = djStr;
             [self.djB setBackgroundImage:[UIImage imageNamed:@"huizhanger"] forState:UIControlStateNormal];
         }

         if ([djStr isEqualToString:@"客户总监"]) {
           
             self.djL.text = djStr;
             [self.djB setBackgroundImage:[UIImage imageNamed:@"huizhangyi"] forState:UIControlStateNormal];
             
         }
         
     }];

    
}
//我的店铺接口数据
-(void)myShop {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSString stringWithFormat:@"%ld",self.glo.myID] forKey:@"seller_id"];
    [MKNetworking MKSeniorGetApi:@"/dist/shop/get" paramters:param
                      completion:^(MKHttpResponse *response)
     
     {
         if (response.errorMsg != nil)
         {
             return ;
         }
         self.shopId = [NSString stringWithFormat:@"%@",[response.mkResponseData objectForKey:@"id"]];
         self.dpNamen.text = [response.mkResponseData objectForKey:@"shop_name"];
         self.yqmL.text = [NSString stringWithFormat:@"邀请码:%@",[response.mkResponseData objectForKey:@"inviter_code"]];
         [self.txIV sd_setImageWithURL:[NSURL URLWithString:[response.mkResponseData objectForKey:@"head_img_url"]] placeholderImage:nil];
         
     }];
    

    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.myStatusBarStyle;
}

#pragma mark -店铺二维码
- (IBAction)dpewmBtn:(id)sender {
    if ( self.glo && ISNSStringValid(self.glo.shopUrl) )
    {
        HYShopQRCodeViewController *shopQR = [[HYShopQRCodeViewController alloc] init];
        shopQR.QRCodeStr = self.glo.shopUrl;
        [self.navigationController pushViewController:shopQR animated:YES];
    }
   
}
//点击头像
- (IBAction)szBtn:(id)sender {
    
    NSLog(@"点击头像");
}
#pragma mark -今日收益
- (IBAction)jrsyBtn:(id)sender {
}
#pragma mark -累计收益
- (IBAction)ljsyBtn:(id)sender {
    getMoneyTableViewController * getMoneyTableVC=[getMoneyTableViewController create];
    
    [self.navigationController pushViewController:getMoneyTableVC animated:YES];

}
#pragma mark-发现按钮
- (IBAction)fxBTN:(id)sender {
    finderViewController * finderVC=[[finderViewController alloc]init];
    [self.navigationController pushViewController:finderVC animated:YES];
}
//高佣金按钮
- (IBAction)gyjBtn:(id)sender {
}
#pragma mark -邀请赚钱
- (IBAction)yqzqBtn:(id)sender {

    if ( self.glo  )
    {
        HYShopInvitationViewController *shopInvit = [[HYShopInvitationViewController alloc] init];
        shopInvit.shopUserId = [NSString stringWithFormat:@"%ld",self.glo.userId];
        [self.navigationController pushViewController:shopInvit animated:YES];
    }
    
}
#pragma mark -分享赚钱
- (IBAction)fxzqBtn:(id)sender {
}
#pragma mark -我的收益
- (IBAction)wdsyBtn:(id)sender {
    getMoneyTableViewController * getMoneyTableVC=[getMoneyTableViewController create];
    
    [self.navigationController pushViewController:getMoneyTableVC animated:YES];
}
#pragma mark -我的团队
- (IBAction)wdtdBTn:(id)sender {
    if ( self.glo  )
    {
        MKWebViewController *class = [[MKWebViewController alloc]init];
        [class loadUrls:[NSString stringWithFormat:@"http://m.haiyn.com/merchant-customer.html?disable-app-share=1&user_id=%ld", self.glo.userId]];
        [self.navigationController pushViewController:class animated:YES];
    }
}
#pragma mark -我的客户
- (IBAction)wdkhBtn:(id)sender {
    
}
#pragma mark -订单管理
- (IBAction)ddglBtn:(id)sender {
    if ( ISNSStringValid(self.shopId) )
    {
        MKWebViewController *class = [[MKWebViewController alloc]init];
        [class loadUrls:[NSString stringWithFormat:@"http://m.haiyn.com/seller-my-order.html?shop_id=%@&disable-app-share=1",self.shopId]];
        [self.navigationController pushViewController:class animated:YES];
    }
}
#pragma mark -访问数据
- (IBAction)fwsjBtn:(id)sender {

    MKWebViewController *class = [[MKWebViewController alloc]init];
    [class loadUrls:@"http://m.haiyn.com/merchant-data.html?disable-app-share=1"];
    [self.navigationController pushViewController:class animated:YES];
}

#pragma mark -嗨云课堂
- (IBAction)hyktBtn:(id)sender {
    [MBProgressHUD showMessageIsWait:@"即将上线，敬请期待" wait:YES];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 百度统计进入页面，建议在此处添加
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"店铺管理"];
    
}

#pragma mark- 百度统计退出页面，建议在此处添加
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"店铺管理"];
}

#pragma mark - Table view data source


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
