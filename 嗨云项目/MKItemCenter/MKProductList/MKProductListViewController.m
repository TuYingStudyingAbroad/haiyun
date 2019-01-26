//
//  MKProductListViewController.m
//  YangDongXi
//
//  Created by windy on 15/4/27.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKProductListViewController.h"
#import "MKListOptionView.h"
#import <PureLayout.h>
#import "MKProductListCell.h"
#import "MKBaseLib.h"
#import "MKItemObject.h"
#import "MBProgressHUD+MKExtension.h"
#import "MKItemDetailViewController.h"
#import "MKSearchViewController.h"
#import "MKNetworking+BusinessExtension.h"
#import "AppDelegate.h"
#import "MKNetworking+BusinessExtension.h"
#import <UIImageView+WebCache.h>
#import "MJRefresh.h"
#import "MKProductCollectionListCell.h"
#import "WXHDownRefreshHeader.h"
#import "ProductionListHeadView.h"
@interface MKProductListViewController ()<MKSearchViewControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate,MKListOptionViewDelegate,MKProductCollectionListCellDelegate,UIScrollViewDelegate>
{

    BOOL isDoubleTemplate;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MKListOptionView *optionView;
@property (strong, nonatomic) NSMutableArray *productListArray;
@property (weak,nonatomic) IBOutlet MKSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *backGo;
@property (weak,nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) UILabel *label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showHead;
@property(nonatomic,strong)ProductionListHeadView* productionListHeadView;
@property(nonatomic, assign)BOOL isScrollUp;//是否是向上滚动
@property(nonatomic, assign)CGFloat lastOffsetY;//滚动即将结束时scrollView的偏移量
@property(nonatomic, assign)BOOL isDownIsShowHead;//没有数据下滑是否隐藏headview

@property (nonatomic,assign)NSString * pinPaiUrlStr;

@end


@implementation MKProductListViewController

- (void)dealloc
{
//    [self.optionView removeObserver:self forKeyPath:@"sortBy"];
//    [self.optionView removeObserver:self forKeyPath:@"btnTag"];
}

//-(ProductionListHeadView *)productionListHeadView{
//    if (!_productionListHeadView) {
//        self.productionListHeadView=[ProductionListHeadView loadFromXib];
//    }
//    return _productionListHeadView;
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isConfiguration) {
        self.backGo.hidden = YES;
        [self.searchBar autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.backGo.superview withOffset:12 relation:NSLayoutRelationEqual];
    }
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (self.isSearch)
    {
        self.searchBar.hidden = NO;
        self.titleLabel.hidden = YES;
    }
    else
    {
        self.searchBar.hidden = YES;
        self.titleLabel.hidden = NO;
    }
    
    
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self enableSwipeBackWhenNavigationBarHidden];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isScrollUp = false;
    _isDownIsShowHead=false;
    _lastOffsetY = 0;
    isDoubleTemplate = YES;
    
    // Do any additional setup after loading the view.
    if (self.title.length > 0)
    {
        self.titleLabel.text = self.title;
    }
    self.label = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100, 15, 200, 30)];
    self.label.hidden = YES;
    [self.tableView addSubview:_label];
        self.productListArray = [NSMutableArray array];
    [self.searchBar enableBorder:YES];
   
    
    
    [self layoutView];
    
 
    [self loadNewData];
    

    
     MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter  footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.footer=footer;
    // 设置文字
      [footer setTitle:@"" forState:MJRefreshStateIdle];
    //  [footer setTitle:@"Loading more ..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    
}



-(MKListOptionView *)optionView{
    if (!_optionView) {
        self.optionView=[MKListOptionView loadFromNib];
    }
    return _optionView;
}

-(void)layoutView{
    self.productionListHeadView=[ProductionListHeadView loadFromXib];
    [self.view addSubview:self.productionListHeadView];
    [self.productionListHeadView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.productionListHeadView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:64];
     [self.productionListHeadView.headImgeV sd_setImageWithURL:[NSURL URLWithString: self.pinPaiUrlStr]];
     self.productionListHeadView.headImgeV.contentMode = UIViewContentModeScaleAspectFit;
    [self.productionListHeadView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [self.productionListHeadView autoSetDimension:ALDimensionHeight toSize:180];
    
    
//    self.optionView = [MKListOptionView loadFromNib];
    self.optionView.delegate = self;
    self.optionView.hidden = NO;
    //    [self.optionView sortByButtonClick:self.optionView.salesButton];
    [self.view addSubview:self.optionView];
    [self.optionView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:180+64];
    [self.optionView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.optionView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.optionView autoSetDimension:ALDimensionHeight toSize:35 relation:NSLayoutRelationEqual];

}

- (void)didPressListOrdering:(VESortBy)sortBy withTag:(NSInteger)tag {

    [self loadDataIsNew:YES];
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

//获取产品列表
- (void)loadDataIsNew:(BOOL)isNew
{
//  
//    [self.productionListHeadView removeFromSuperview];
//    self.showHead.constant=20;
//    [self.optionView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:64];
//    _isDownIsShowHead=YES;
    
    
    NSInteger offset = self.productListArray.count;
    if (isNew)
    {
        offset = 0;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:self.tableView wait:YES];
    hud.yOffset = -40;
    
    if (self.keyWord == nil)
    {
        self.keyWord = @"";
    }
    if (!self.itemGroupUid.length) {
        self.itemGroupUid = @"";
    }
    NSDictionary *temp = @{@"order_by" : @(self.optionView.sortBy),
                           @"asc" : @(self.optionView.btnTag),
                           @"offset" : @(offset),
                           @"count" : @(20),
                           @"keyword" : self.keyWord,
                           @"item_group_uid":self.itemGroupUid};
    NSMutableDictionary *p = [NSMutableDictionary dictionaryWithDictionary:temp];
    
    
    
    if (self.categoryId != 0)
    {
        p[@"category_id"] = @(self.categoryId);
    }
    if (self.brandId != 0)
    {
        p[@"item_brand_uid"] = @(self.brandId);
        
    }else{
        [self.productionListHeadView removeFromSuperview];
            self.showHead.constant=20;
            [self.optionView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:64];
            _isDownIsShowHead=YES;

    }

    [MKNetworking MKSeniorGetApi:@"item/list" paramters:p completion:^(MKHttpResponse *response)
    {
        [ hud hide:YES];
    
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.header endRefreshing];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.footer endRefreshing];
        if (response.errorMsg != nil)
        {
            [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
            return ;
        }
        NSArray *db = [response mkResponseData][@"item_list"];
        NSDictionary * pinPaiDic=[response mkResponseData][@"brand"];
        self.pinPaiUrlStr=pinPaiDic[@"banner_img"];
        if ( self.pinPaiUrlStr) {
              [self.productionListHeadView.headImgeV sd_setImageWithURL:[NSURL URLWithString: self.pinPaiUrlStr]];
            self.productionListHeadView.headImgeV.contentMode = UIViewContentModeScaleAspectFit;

        }else{
            [self.productionListHeadView removeFromSuperview];
            self.showHead.constant=20;
            [self.optionView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:64];
            _isDownIsShowHead=YES;

        }
        
        if (db.count == 0) {
            _label.hidden = NO;
            _label.text = @"当前条件，列表为空";
            _label.textAlignment = NSTextAlignmentCenter;
            _label.textColor = [UIColor lightGrayColor];
            _label.font = [UIFont systemFontOfSize:14];
            self.tableView.footer.hidden = YES;
        }else {
            _label.hidden = YES;
        }
        if (isNew)
        {
            [self.productListArray removeAllObjects];
        }
        for (NSDictionary *d in db)
        {
            MKItemObject *item = [MKItemObject objectWithDictionary:d];
            [self.productListArray addObject:item];
        }
        if (self.productListArray.count<=2) {
            self.tableView.scrollEnabled=NO;
        }else{
            self.tableView.scrollEnabled=YES;
        }
        if (self.productListArray.count >= [[response mkResponseData][@"total_count"] integerValue])
        {
            [self.tableView.footer noticeNoMoreData];
        }
            [self.tableView reloadData];
    }];
}

#pragma mark ------------ UITableView Datasource ------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isDoubleTemplate)
    {
        return ([UIScreen mainScreen].bounds.size.width - 20 ) / 2 + 106;
    }
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isDoubleTemplate)
    {
        return ceilf(1.0 * self.productListArray.count/2.0);
    }
    return self.productListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isDoubleTemplate)
    {
        static NSString *collectionID = @"MKProductCollectionListCell";
        
        MKProductCollectionListCell *cell = [tableView dequeueReusableCellWithIdentifier:collectionID];
        
        cell.delegate = self;
        
        if (cell == nil)
        {
            cell = [MKProductCollectionListCell loadFromXib];
            
            cell.delegate = self;
        }
        
        NSMutableArray *dataArray = [[NSMutableArray alloc]init];
        
        MKItemObject *item1 = [self.productListArray objectAtIndex:indexPath.row * 2];
        
        [dataArray addObject:item1];
        
        if(self.productListArray.count > indexPath.row * 2 + 1)
        {
            MKItemObject *item2 = [self.productListArray objectAtIndex:indexPath.row * 2 + 1];
            
            [dataArray addObject:item2];
        }
        
        [cell updateWithArray:dataArray];

        return cell;
    }
    else
    {
        static NSString *ID = @"MKProductListCell";
        
        MKProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil)
        {
            cell = [MKProductListCell loadFromXib];
        }
        MKItemObject *item = [self.productListArray objectAtIndex:indexPath.row];
        
        /*
        cell.nameLabel.text = item.itemName;
        
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:item.iconUrl] placeholderImage:[UIImage imageNamed:@"placeholder_80x80"]];
        
        [cell updatePrice:item.wirelessPrice andMarketPrice:item.marketPrice];
        */
        
        [cell updateCellWithProductData:item];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isDoubleTemplate)
    {
        
        return;
    }
    MKItemDetailViewController *Vc = [MKItemDetailViewController create];
    
    MKItemObject *itemObject = [self.productListArray objectAtIndex:indexPath.row];
    
    Vc.itemId = itemObject.itemUid;
    
    [self.navigationController pushViewController:Vc animated:YES];
    
}

#pragma mark --
#pragma mark -- MKProductCollectionListCellDelegate

-(void)didSelect:(MKItemObject *)item
{
    if(item)
    {
        MKItemDetailViewController *Vc = [MKItemDetailViewController create];
        
        Vc.itemId = item.itemUid;
//        Vc.type = 1;
        
        [self.navigationController pushViewController:Vc animated:YES];
    }
}

#pragma mark - UISearchBarDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    MKSearchViewController *s = [[MKSearchViewController alloc] init];
    s.delegate = self;
    [s showInViewController:self withOriginSearchBar:self.searchBar];
    return NO;
}

#pragma mark - MKSearchViewControllerDelegate

- (void)searchViewController:(MKSearchViewController *)searchViewController needSearchWord:(NSString *)word
{
    self.keyWord = word;
    [self loadDataIsNew:YES];
    [searchViewController dismiss];
}

- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadNewData
{
    [self loadDataIsNew:YES];
}

- (void)loadMoreData
{
    [self loadDataIsNew:NO];
}

#pragma mark --
#pragma mark -- MKListOptionViewDelegate

-(void)didPressTemplateToDouble:(BOOL)doubleTemplate
{
    isDoubleTemplate = doubleTemplate;
    
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%f",scrollView.contentOffset.y);
    _isScrollUp = _lastOffsetY < scrollView.contentOffset.y;
    _lastOffsetY = scrollView.contentOffset.y;
    //减少重复性改变值
    CGFloat showHeadConts = self.showHead.constant;
    if (_isScrollUp&&self.productionListHeadView && showHeadConts !=20) {
        self.showHead.constant=20;
        [self.productionListHeadView removeFromSuperview];
        [self.optionView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:64];
       
    }
    if (!_isScrollUp&&scrollView.contentOffset.y<40&&scrollView.contentOffset.y!=-20&&!_isDownIsShowHead && showHeadConts !=200) {
        [self.productionListHeadView removeFromSuperview];
        [self.optionView removeFromSuperview];
        [self layoutView];
         self.showHead.constant=200;
     
    }
}


@end
