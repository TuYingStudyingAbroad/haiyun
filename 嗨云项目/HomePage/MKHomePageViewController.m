//
//  MKHomePageViewController.m
//  YangDongXi
//
//  Created by cocoa on 15/4/7.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import "MKHomePageViewController.h"
#import "AppDelegate.h"
#import "MKProductListViewController.h"
#import <PureLayout.h>

#import "MJRefresh.h"
#import "MKBaseLib.h"
#import <UIImageView+WebCache.h>
#import "MBProgressHUD+MKExtension.h"
#import "MKNetworking+BusinessExtension.h"
#import "MKQrCodeViewController.h"
#import "MKSearchViewController.h"
#import "MKItemDetailViewController.h"

#import "MKUrlGuide.h"
#import "MKItemObject.h"
#import <objc/runtime.h>
#import "MKMarketingComponentObject.h"
#import "MKMarketingListItem.h"
#import "MKMarketingSingleLineView.h"

#import "MKMarketingBannerCell.h"
#import "MKMarketingNormalButtonsCell.h"
#import "MKBlankTableViewCell.h"
#import "MKMarketingComponentTitleCell.h"
#import "MKMarketingStyle2Cell.h"
#import "MKMarketingStyle3Cell.h"
#import "MKMarketingStyle4Cell.h"
#import "MKMarketingTopNewsCell.h"
#import "MKProductListCell.h"
#import "MKMarketingImageCell.h"
#import "MKMarketingDividerLineCell.h"
#import "MKMarketingstyle41.h"
#import "MKMarketingstyle42.h"
#import "MKMarketingstyle43.h"
#import "MKMarketingstyle44.h"
#import "MKMarketingstyle45.h"
#import "MKMarketingstyle46.h"
#import "MKMarketingstyle47.h"
#import "MKMarketingstyle48.h"
#import "MKMarketingstyle31.h"
#import "MKMarketingstyle32.h"
#import "MKMarketingstyle33.h"
#import "MKMarketingstyle34.h"
#import "MKProductCollectionListCell.h"
#import "MKMarketingFlagObject.h"
#import "MKFlagShared.h"
#import "MKSlidingCell.h"
#import "MKChildHomePageViewController.h"
#import "UIView+MKExtension.h"
#import "MKConfirmOrderViewController.h"
#import "MKCartItemObject.h"
#import "ZJScrollPageView.h"
#import "HYClassificationViewController.h"
#import "HYShareActivityView.h"
#import "HYShareKit.h"
#import "UIImage+ResizeMagick.h"
#import "UIView+MKExtension.h"
#import "HYHomeFirstShowView.h"
#import "HYSystemInit.h"

#define marketingTypeBanner @"imageBanner"
#define marketingTypeFourItemNav @"fourItemNav"
#define marketingTypeComponentTitle @"componentTitle"
#define marketingTypeSliding @"sliding"
#define marketingTypeStyle2 @"style2"
#define marketingTypeStyle3 @"style3"
#define marketingTypeStyle4 @"style4"
#define marketingTypeTopNews @"toutiao"
#define marketingTypeBlankCell @"blankCell"
#define homePageCache @"homePageCache"

#define KMarketingTypeDividerBlank @"dividerBlank"
#define KMarketingTypeImage @"image"
#define KMarketingTypeDividerLine @"dividerLine"
#define kMarketingTypeAnnocement @"marquee"
#define kMarketingTypeCard @"card"
#define kMarketingTypeProduct @"product"
#define kMarketingTypeProduct1 @"product1"
#define kMarketingTypeProduct2 @"product2"

#define kMarketingTypeCardStyle41 @"style4-1"
#define kMarketingTypeCardStyle42 @"style4-2"
#define kMarketingTypeCardStyle43 @"style4-3"
#define kMarketingTypeCardStyle44 @"style4-4"
#define kMarketingTypeCardStyle45 @"style4-5"
#define kMarketingTypeCardStyle46 @"style4-6"
#define kMarketingTypeCardStyle47 @"style4-7"
#define kMarketingTypeCardStyle48 @"style4-8"
#define kMarketingTypeCardStyle31 @"style3-1"
#define kMarketingTypeCardStyle32 @"style3-2"
#define kMarketingTypeCardStyle33 @"style3-3"
#define kMarketingTypeCardStyle34 @"style3-4"

#define kMarketingTypeFourItemNavEachLineCount  4

@interface MKHomePageViewController () < UITextFieldDelegate, MKSearchViewControllerDelegate>

@property (nonatomic, strong) IBOutlet MKSearchBar *searchBar;

@property (strong, nonatomic) UIButton *changeButton;

@property (nonatomic, strong) IBOutlet UIView *topBar;

@property (nonatomic, strong) IBOutlet UIView *topBarBackground;
@property (weak, nonatomic) IBOutlet UIImageView *shopIcon;
@property (weak, nonatomic) IBOutlet UILabel *shopName;

@property (nonatomic, strong) NSArray *components;

@property (nonatomic, strong) NSArray *itemListItems;

@property (nonatomic, strong) NSDictionary *cellsMap;

@property (nonatomic, strong) HYShareActivityView *activityView;

@property (nonatomic, strong) MKSearchViewController *searchViewController;

@property (nonatomic, assign) UIStatusBarStyle myStatusBarStyle;

@property (nonatomic, assign) BOOL isLoaded;

@property (nonatomic,strong) ZJScrollPageView *scrollPageView ;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goinhome;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *shareSd;
@property (nonatomic,strong)NSString *shopIconUrl;

//当前主页所有的内容view数组
@property (nonatomic,strong)NSMutableArray *childVcs;
@end


@implementation MKHomePageViewController

- (IBAction)shareSdCon:(id)sender {
    
    
    self.searchViewController = [[MKSearchViewController alloc] init];
    self.searchViewController.delegate = self;
    [self.searchViewController showInViewController:self withOriginSearchBar :nil];
   /* if ( self.activityView == nil )
    {
        _activityView = [[HYShareActivityView alloc] initWithButtons:@[@(HYSharePlatformTypeWechatSession),@(HYSharePlatformTypeWechatTimeline),@(HYSharePlatformTypeQZone),@(HYSharePlatformTypeSinaWeibo),@(HYSharePlatformTypeQQFriend),@(HYSharePlatformTypeSMS),@(HYSharePlatformTypeCopy)] shareTypeBlock:^(HYSharePlatformType type)
                         {

                             [self shareMoreActionClickType:type];

                         }];
        [self.activityView show];
    }else
    {
        [self.activityView show];
    }*/
}

//- (void)shareMoreActionClickType:(NSInteger)types
//{
//    
//    if ( types == 4 )
//    {
//        [self.activityView hide];
//        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//        pasteboard.string        = [NSString stringWithFormat:@"%@/index.html",BaseHtmlURL];
//        [MBProgressHUD showMessageIsWait:@"复制成功" wait:YES];
//        return;
//    }
//    if ( types == 8 )
//    {
//        [self.activityView hide];
//        [[HYThreeDealMsg sharedInstance] shareInfoWithMessage:[NSString stringWithFormat:@"嗨云，全球美妆第一社交电商平台——发现全球正品美妆，优选中国时尚大牌。%@/index.html",BaseHtmlURL] type:8];
//        return;
//    }
//    
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    [manager downloadImageWithURL:[NSURL URLWithString:getUserCenter.userInfo.headerUrl]  options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//        HYShareInfo *info = [[HYShareInfo alloc] init];
//        info.title        = @"我是嗨客，我为嗨云代言";
//        info.content      = @"嗨云，全球美妆第一社交电商平台——发现全球正品美妆，优选中国时尚大牌。";
//        image = [image resizedImageWithMaximumSize:CGSizeMake(100, 100)];
//        if ( image )
//        {
//            info.images = image;
//        }
//        else
//        {
//            info.images = [UIImage imageNamed:@"logo"];
//        }
//        info.url          = [NSString stringWithFormat:@"%@/index.html",BaseHtmlURL];
//        info.shareType    = HYShareDKContentTypeWebPage;
//        info.type         = (HYPlatformType)types;
//        [HYShareKit shareInfoWith:info completion:^(NSString *errorMsg)
//         {
//             if ( ISNSStringValid(errorMsg) )
//             {
//                 [MBProgressHUD showMessageIsWait:errorMsg wait:YES];
//             }
//             [self.activityView hide];
//             
//         }];
//    }];
//    
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;

//    [self loadCache];
//    [self lodaData];
//    self.myStatusBarStyle = UIStatusBarStyleLightContent;
//    [self setNeedsStatusBarAppearanceUpdate];
    
//    if ([GetObjectforNSUserDefaultsByKey(@"HYShowHomePageFirst1.2") intValue] != 2)
//    {
//        HYHomeFirstShowView *showView = [[HYHomeFirstShowView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:showView];
////        [[HYSystemInit sharedInstance].window addSubview:showView];
//    }

    
}
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return self.myStatusBarStyle;
//}

- (void)loadCache{
    NSString *path    = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
              path    = [path stringByAppendingPathComponent:homePageCache];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            return;
        }
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
        if (dic.count) {
            [self loadFromDictionary:dic];
        }
}
- (void)lodaData{
    ///homepage/app/config/get
    [MKNetworking MKSeniorGetApi:@"/mainweb/page/page_names" paramters:nil completion:^(MKHttpResponse *response) {
        NSArray *pageTitleList = response.mkResponseData[@"page_title_list"];
        if (!pageTitleList.count) {
            [self loadCache];
           [MBProgressHUD showMessageIsWait:@"加载失败了..." wait:YES];
            return ;
        }
        if (response.errorMsg) {
            [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
            return ;
        }
       
    [self loadFromDictionary:[response mkResponseData]];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    path           = [path stringByAppendingPathComponent:homePageCache];
        [response.mkResponseData writeToFile:path atomically:YES];
    }];
}

- (void)loadFromDictionary:(NSDictionary *)data{
    ZJSegmentStyle *style         = [[ZJSegmentStyle alloc] init];
    //显示滚动条
    
    style.showLine                = YES;
    style.scrollLineHeight        = 3;
    style.scrollLineY             = style.segmentHeight-4 ;
    style.titleMargin             = 20;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    style.selectedTitleColor      = [UIColor colorWithRed:255/255.0 green:39/255.0 blue:65/255.0 alpha:1];
    style.normalTitleColor        = [UIColor colorWithRed:37/255.0 green:37/255.0 blue:37/255.0 alpha:1];
    style.scrollLineColor         = [UIColor colorWithRed:255/255.0 green:39/255.0 blue:65/255.0 alpha:1];
    NSArray *pageTitleList        = data[@"page_title_list"];
    NSMutableArray *pageNamme     = [NSMutableArray array];
    NSMutableArray *pageId        = [NSMutableArray array];
    for (NSMutableDictionary *dic in pageTitleList) {
        [pageNamme addObject:dic[@"name"]];
        [pageId addObject:dic[@"id"]];
    }
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *array      = pageNamme;
    NSArray *statuses   = pageId;
    if (pageNamme.count==5) {
        style.scrollTitle=NO;
    }
    for (int i = 0; i < array.count; i++)
    {
    MKChildHomePageViewController *orderListViewController = [[MKChildHomePageViewController alloc]init];
    orderListViewController.title                          = array[i];
    NSString *stateStr = @"";
        if ( i>=0 && i<statuses.count )
        {
            stateStr = [NSString stringWithFormat:@"%@",statuses[i]];
        }
        orderListViewController.state                          = ISNSStringValid(stateStr)?stateStr:@"";
        orderListViewController.isHide = YES;
        [arr addObject:orderListViewController];
    }
    self.childVcs = [NSMutableArray arrayWithArray:arr];
    // 初始化
    if (!self.scrollPageView) {
    self.scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 64.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64.0) segmentStyle:style childVcs:_childVcs parentViewController:nil];
    }
    [self.view addSubview:_scrollPageView];
}

- (void)goBackHome
{
    [self.navigationController popViewControllerAnimated:YES];
    return;
}
- (void)viewWillAppear:(BOOL)animated
{    [super viewWillAppear:animated];
    
//     [self loadCache];
     [self lodaData];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.changeButton      = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.changeButton setImage:[UIImage imageNamed:@"fanhui_bai"] forState:(UIControlStateNormal)];

    if (self.isGoinHome || [self.isgoinhome isEqualToString:@"110"]) {
        [self.backView addSubview:self.changeButton];
        [self.changeButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:12];
        [self.changeButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.shopName withOffset:0];
        [self.changeButton addTarget:self action:@selector(goBackHome) forControlEvents:(UIControlEventTouchUpInside)];
    self.goinhome.constant = 50;
    }else{
        [self.changeButton setImage:[UIImage imageNamed:@"shouye_sousuo"] forState:(UIControlStateNormal)];
    self.goinhome.constant = 12;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

//    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.shopName.text=@"嗨云";
    self.tabBarController.tabBar.hidden = NO;
    

}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

}


- (void)closeSearchView
{
    [self.searchViewController dismiss];
    self.searchViewController          = nil;
}


//- (IBAction)onClickHanderScan:(id)sender
//{
//    HYClassificationViewController *Vc = [[HYClassificationViewController alloc]init];
//    Vc.isBacks = NO;
//    Vc.hidesBottomBarWhenPushed        = YES;
//    [self.navigationController pushViewController:Vc animated:YES];
//}


#pragma mark - MKSearchViewControllerDelegate

- (void)searchViewController:(MKSearchViewController *)searchViewController needSearchWord:(NSString *)word
{
    [self.searchViewController dismiss];
    MKProductListViewController *vc    = [MKProductListViewController create];
    vc.keyWord                         = word;
    vc.isSearch                        = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)searchViewControllerViewWillShow:(MKSearchViewController *)searchViewController
{
    self.myStatusBarStyle              = UIStatusBarStyleLightContent;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)searchViewControllerViewDidDismiss:(MKSearchViewController *)searchViewController
{
    self.myStatusBarStyle              = UIStatusBarStyleLightContent;
    [self setNeedsStatusBarAppearanceUpdate];
}

@end
