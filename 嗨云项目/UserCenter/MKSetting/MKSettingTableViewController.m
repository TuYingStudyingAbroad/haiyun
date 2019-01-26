//
//  MKSettingTableViewController.m
//  YangDongXi
//
//  Created by windy on 15/4/23.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKSettingTableViewController.h"
#import "MKSettingCell.h"
#import "UIColor+MKExtension.h"
#import "AppDelegate.h"
#import "MKWebViewController.h"
#import <PureLayout.h>
#import "BaiduMobStat.h"
#import "MKNetworking+BusinessExtension.h"
#import "PersonZLViewController.h"
#import "HYAccounSafeViewController.h"
#import "HYSystemLoginMsg.h"
#import "MKConsigneeListViewController.h"
#import "UIViewController+MKExtension.h"
#import "SDImageCache.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKItemDetailViewController.h"
#import "HYShareKit.h"
#import "HYShareInfo.h"
#import "HYShareActivityView.h"
#import "QYSDK.h"
@interface MKSettingTableViewController ()
{
    HYShareActivityView  *_shareView;
}

@property (nonatomic, strong) NSMutableArray *pNameArr;
@property (nonatomic, strong) NSMutableArray *pImageArr;

@end

@implementation MKSettingTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *array = [NSArray arrayWithObjects:@"1",@"个人资料",@"账户安全",@"1",@"地址管理",@"1",@"清除缓存",@"推荐嗨云",@"关于嗨云", nil];
    NSArray *imageArray = [NSArray arrayWithObjects:@"2",@"gerenziliao",@"zhanghaoanquan",@"2",@"HYdizhiguanli",@"2",@"qingchu",@"tuijianhaiyun",@"guanyuwomen",nil];
    _pNameArr = [[NSMutableArray alloc] initWithArray:array];
    _pImageArr = [[NSMutableArray alloc] initWithArray:imageArray];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"设置";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 9;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ) {
        
        if (indexPath.row == 0||indexPath.row == 3||indexPath.row == 5) {
            
            return 10;
        }
        
        return 44.0f;
        
    }
    
    return 50.0f;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
       
        //实现cell之间格局问题
        if (indexPath.row == 0||indexPath.row == 3||indexPath.row == 5||indexPath.row == 9)
        {
            static NSString *cellIdentifier = @"emptyViewCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
            return cell;
            
        }
            static NSString *cellIdentifier = @"MKSettingCell";
            MKSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
            {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellIdentifier owner:self options:nil]firstObject];
            }

            cell.titleLabel.text = [NSString stringWithFormat:@"%@",[self.pNameArr objectAtIndex:indexPath.row]];
            NSString *imageView = [NSString stringWithFormat:@"%@",[self.pImageArr objectAtIndex:indexPath.row]];
            cell.iconImageView.image = [UIImage imageNamed:imageView];
            cell.lineView.backgroundColor = [UIColor colorWithHex:0xe8e8e8];
            
            if (indexPath.row == 2||indexPath.row == 4||indexPath.row == 8) {
                
                cell.lineView.hidden = YES;
                
                
            }
            if (indexPath.row == 6) {
                cell.llLabel.text = [NSString stringWithFormat:@"%.1fMB",[[SDImageCache sharedImageCache] getSize]/1000.0/1000.0];
            }
            return cell;
        
    }
    
    static NSString *cellIdentifier = @"emptyViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.contentView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    }
    UIButton *logoutBtn = [[UIButton alloc] initWithFrame:(CGRect){0.0f,10.0f,Main_Screen_Width,50.0f}];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor colorWithHex:kRedColor] forState:UIControlStateNormal];
    logoutBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    logoutBtn.backgroundColor = [UIColor whiteColor];
    [logoutBtn addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];

    [cell.contentView addSubview:logoutBtn];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
       
        if (indexPath.row == 1) {   
            PersonZLViewController *p = [[PersonZLViewController alloc] init];
            [self.navigationController pushViewController:p animated:YES];
        
        }
        if (indexPath.row == 2) {//账户安全
             HYAccounSafeViewController *pV = [[HYAccounSafeViewController alloc] init];
            [self.navigationController pushViewController:pV animated:YES];
        }
        if (indexPath.row == 4) {
            MKConsigneeListViewController *m = [MKConsigneeListViewController create];
                m.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:m animated:YES];
        }
        if (indexPath.row == 6)
        {
            //[[SDImageCache sharedImageCache] cleanDisk];
            [self cleanCacheButtonClicked:nil];
            
        }
        
        if (indexPath.row == 7)
        {
           
            if ( _shareView == nil )
            {
                _shareView = [[HYShareActivityView alloc] initWithButtons:@[@(HYSharePlatformTypeWechatSession),@(HYSharePlatformTypeWechatTimeline),@(HYSharePlatformTypeQZone),@(HYSharePlatformTypeSinaWeibo),@(HYSharePlatformTypeQQFriend)] shareTypeBlock:^(HYSharePlatformType type)
                {
                    
                    [self shareActiveType:type];

                }];
                [_shareView show];
            }else
            {
                [_shareView show];
            }
            
        }
        if (indexPath.row == 8)
        {
            MKWebViewController *vc = [[MKWebViewController alloc] init];
            [vc loadUrls:[NSString stringWithFormat:@"%@/about.html",BaseHtmlURL]];
            [vc webViewTitle:@"关于我们"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
    }
    
}
-(void)shareActiveType:(NSUInteger)type
{
    HYShareInfo *shareInfo = [[HYShareInfo alloc] init];
    shareInfo.content = @"社交零售轻创平台";
    shareInfo.title = @"嗨云APP-下载";
    shareInfo.url = @"http://download.haiyn.com/";
    shareInfo.images = [UIImage imageNamed:@"HYShare"];
    shareInfo.type = (HYPlatformType)type;
    shareInfo.shareType = HYShareDKContentTypeWebPage;
    [HYShareKit shareInfoWith:shareInfo completion:^(NSString *errorMsg)
     {
         if ( ISNSStringValid(errorMsg) )
         {
             [MBProgressHUD showMessageIsWait:errorMsg wait:YES];
         }
         [_shareView hide];
     }];
}


- (void)cleanCacheButtonClicked:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定清除缓存吗？" message:[NSString stringWithFormat:@"当前图片缓存 %.1fMB",[[SDImageCache sharedImageCache] getSize]/1000.0/1000.0] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];//图片缓存
    alert.tag = 110;
    [alert show];
    
}


- (void)logoutAction:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"您确定退出当前账号吗？"
                                                       delegate:self cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"退出", nil];
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    
    if (buttonIndex == 1 && alertView.tag == 110) {
        
        //[[SDImageCache sharedImageCache] clearDisk];//清除本地磁盘的缓存数据
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            
            
            [self.tableView reloadData];
            [MBProgressHUD showMessageIsWait:@"清除成功" wait:YES];
            // 清除完毕的处理。
            
        }];
//        NSURLCache * cache = [NSURLCache sharedURLCache];
//        [cache removeAllCachedResponses];
//        [cache setDiskCapacity:0];
//        [cache setMemoryCapacity:0];
//        
//        NSLog(@"%.1fM",[[SDImageCache sharedImageCache] getSize]/1000.0/1000.0);
        //*****************************************
        
        //取得文件的沙盒路径 com.hackemist.SDWebImageCache.default        
        

        

        return;
        
    }
    if (buttonIndex == alertView.firstOtherButtonIndex)
    {
        [getUserCenter loginoutGotoMain];
    }
    
}

//退出登录调用接口
- (void)loginoutData
{
    [MKNetworking MKSeniorPostApi:@"/user/logout" paramters:nil completion:^(MKHttpResponse *response)
     {
         
     }];

}

#pragma mark- 百度统计进入页面，建议在此处添加
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ( ISNSStringValid(self.title)  )
    {
        NSString* cName = [NSString stringWithFormat:@"%@",  self.title, nil];
        [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    }
    
}

#pragma mark- 百度统计退出页面，建议在此处添加
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ( ISNSStringValid(self.title) )
    {
        NSString* cName = [NSString stringWithFormat:@"%@", self.title, nil];
        [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
    }
}
@end
