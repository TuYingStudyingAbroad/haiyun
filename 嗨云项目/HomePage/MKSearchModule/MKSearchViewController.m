//
//  MKSearchViewController.m
//  YangDongXi
//
//  Created by cocoa on 15/4/22.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKSearchViewController.h"
#import "MKSearchModel.h"
#import "UIColor+MKExtension.h"
#import <PureLayout.h>
#import "MKProductListViewController.h"
#import "HYSearchsNewView.h"
#import "UIAlertView+Blocks.h"
#import "MKNetworking+BusinessExtension.h"
#import "MBProgressHUD+MKExtension.h"
#import "HYSearchHotModel.h"

@interface MKSearchViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,HYSearchsNewViewDelegate>


@property (nonatomic, strong) IBOutlet UIButton *cancelButton;

@property (nonatomic, strong) IBOutlet MKSearchBar *searchBar;


@property (nonatomic, weak) MKSearchBar *originSearchBar;

@property (nonatomic, assign) CGRect originSearchBarFrame;

//@property (nonatomic, strong) IBOutlet UITableView *historyTableView;
//
//@property (nonatomic, strong) IBOutlet NSLayoutConstraint *constraint;

@property (nonatomic, strong) IBOutletCollection(NSLayoutConstraint) NSArray *searchBarFrame;

@property (nonatomic, strong) MKSearchModel *model;

@property (nonatomic, strong) NSArray *histories;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *scrollViewHeightLayout;

@property (nonatomic, strong) IBOutlet UIView *scrollContentView;

@property (strong, nonatomic) HYSearchsNewView *historView;

@property (strong, nonatomic) HYSearchsNewView *hotView;


@property (strong, nonatomic) NSMutableArray *hotArr;
@property (strong, nonatomic) NSMutableArray *hotIdArr;

@end


@implementation MKSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.model = [[MKSearchModel alloc] init];
    self.histories = [self.model lastTenKeyword];
    [self.searchBar enableBorder:YES];
    [self searchNewViews];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardWillShowNotification object:nil];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

#pragma mark -搜索
- (void)searchWord:(NSString *)word
{
    if (word.length == 0)
    {
        [self dismiss];
        return;
    }
    [self.model searchKeyword:word];
    self.histories = [self.model lastTenKeyword];

    
    [self.delegate searchViewController:self needSearchWord:word];
}

- (void)showInViewController:(UIViewController *)vc withOriginSearchBar:(MKSearchBar *)searchBar
{
    
    [vc.navigationController presentViewController:self animated:NO completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(searchViewControllerViewWillShow:)])
    {
        [self.delegate searchViewControllerViewWillShow:self];
    }
    
    [self.searchBar becomeFirstResponder];

   
}

- (IBAction)cancel:(id)sender
{
    [self dismiss];
}

- (void)dismiss
{
    [self.searchBar resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(searchViewControllerViewDidDismiss:)])
    {
        [self.delegate searchViewControllerViewDidDismiss:self];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)setSearchBarAutolayoutFrame:(CGRect)frame
{
    NSLayoutConstraint *c = self.searchBarFrame[0];
    c.constant = frame.origin.x;
    c = self.searchBarFrame[1];
    c.constant = frame.origin.y;
    c = self.searchBarFrame[2];
    c.constant = frame.size.width;
    c = self.searchBarFrame[3];
    c.constant = frame.size.height;
}

-(void)keyboardOnScreen:(NSNotification *)notification
{
//    NSDictionary *info  = notification.userInfo;
//    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
//    
//    CGRect rawFrame      = [value CGRectValue];
//    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
//    
//    UIWindow *w = [[UIApplication sharedApplication] keyWindow];
//    CGRect r = [w convertRect:keyboardFrame toView:self.view];
//    self.historyTableView.contentInset = UIEdgeInsetsMake(0, 0, r.size.height, 0);
//    self.historyTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, r.size.height, 0);
}
#pragma mark -删除某个关键字
-(void)deleteSearchWord:(NSString *)word
{
    
    [self.model delOneKeyword:word];
    self.histories = [self.model lastTenKeyword];
    [self searchNewViews];
}
#pragma mark -删除所有
- (void)clear
{
    [self.model clear];
    self.histories = nil;
    [self searchNewViews];
}

#pragma mark -页面显示
- (void)searchNewViews
{
    if ( self.historView)
    {
        [self.historView removeFromSuperview];
        self.historView = nil;
    }
    if ( self.hotView ) {
        [self.hotView removeFromSuperview];
        self.hotView = nil;
    }
    CGFloat abc = 0;
    if ( self.histories.count > 0 )
    {
        HYSearchsNewView *histView = [HYSearchsNewView loadFromXib];
        histView.delegate = self;
        [self.scrollContentView addSubview:histView];
        [histView buildSearchsNewView:self.histories title:@"最近搜索" isRight:NO];
        abc += histView.abc;
        [histView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [histView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
        [histView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
        self.historView = histView;
    }
   
    if ( self.hotArr.count >0  ) {
        
        HYSearchsNewView *hView = [HYSearchsNewView loadFromXib];
        hView.delegate = self;
        [self.scrollContentView addSubview:hView];
        [hView buildSearchsNewView:self.hotArr title:@"大家都在搜" isRight:YES];
        abc += hView.abc;
        if (self.historView == nil)
        {
            [hView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        }
        else
        {
            [hView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.historView];
        }
        [hView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
        [hView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
        self.hotView = hView;
    }
   
    
    self.scrollViewHeightLayout.constant = abc > Main_Screen_Height?abc:Main_Screen_Height;
    
    [self.view layoutIfNeeded];
    
    
    
   
}


#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.histories && self.histories.count >0 ) {
        return self.histories.count + 1;

    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.histories.count)
    {
        UITableViewCell *c = [tableView dequeueReusableCellWithIdentifier:@"clear"];
        if (c == nil)
        {
            c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"clear"];
            c.selectionStyle = UITableViewCellSelectionStyleNone;
            UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
            [bt setTitle:@"清除搜索历史" forState:UIControlStateNormal];
            bt.titleLabel.font = [UIFont systemFontOfSize:12];
            [bt setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
            [bt addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
            bt.layer.borderColor = [UIColor colorWithHex:0xe5e5e5].CGColor;
            bt.layer.borderWidth = 0.5;
            [c.contentView addSubview:bt];
            [bt autoCenterInSuperview];
            [bt autoSetDimensionsToSize:CGSizeMake(100, 30)];
        }
        return c;
    }
    
    UITableViewCell *c = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (c == nil)
    {
        c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        c.textLabel.font = [UIFont systemFontOfSize:12];
        c.textLabel.textColor = [UIColor colorWithHex:0x666666];
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
        [c.contentView addSubview:v];
        [v autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 12, 0, 12) excludingEdge:ALEdgeTop];
        [v autoSetDimension:ALDimensionHeight toSize:0.5];
    }
    c.textLabel.text = self.histories[indexPath.row];
    return c;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == self.histories.count ? 70 : 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == self.histories.count)
    {
        [self dismiss];
        return;
    }
    [self.searchBar resignFirstResponder];
    [self searchWord:self.histories[indexPath.row]];
}

#pragma mark - UISearchBarDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchWord:textField.text];
    return YES;
}

#pragma mark -HYSearchsNewViewDelegate
//index:1全部删除，2删除，3点击,4点击热词，tags删除的那个，点击的那个
-(void)searchsNewView:(HYSearchsNewView *)searchView changeIndex:(NSInteger)index tags:(NSInteger)tags
{
    if ( searchView == self.historView )
    {
        if ( index == 1 )
        {
            [UIAlertView showWithTitle:nil message:@"是否清空最近搜索记录" style:UIAlertViewStyleDefault cancelButtonTitle:@"确定" otherButtonTitles:@[@"取消"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                if (buttonIndex == 0)
                {
                    [self clear];
                }
            }];
        }else if ( index == 3 )
        {
            if ( tags>=0 && tags < self.histories.count )
            {
                [self.searchBar resignFirstResponder];
                [self searchWord:self.histories[tags]];

            }
        }else if ( index == 2 )
        {
            if ( tags>=0 && tags < self.histories.count )
            {
                [self deleteSearchWord:self.histories[tags]];
                
            }
        }
    }
    else if ( searchView == self.hotView )
    {
        if ( index == 4 )
        {
            if ( tags>=0 && tags < self.hotArr.count )
            {
                [self.searchBar resignFirstResponder];
                [self searchWord:self.hotArr[tags]];
                [self clickHotSearchWords:tags];
                
            }
        }
    }
}

#pragma mark -热词获取
- (void)loadData
{
    
    [MKNetworking MKSeniorGetApi:@"/item/hotsearch/list"
                       paramters:nil
                      completion:^(MKHttpResponse *response)
    {
        if (response.errorMsg != nil)
        {
            [MBProgressHUD showMessageIsWait:@"加载失败了..." wait:YES];
            return ;
        }
        if ( _hotArr == nil )
        {
            _hotArr = [[NSMutableArray alloc] init];
        }
        else
        {
            [_hotArr removeAllObjects];
        }
        if ( _hotIdArr == nil )
        {
            _hotIdArr = [[NSMutableArray alloc] init];
        }else
        {
            [_hotIdArr removeAllObjects];
        }
        for( NSDictionary *dicts in response.mkResponseData[@"hotName"] )
        {
            HYSearchHotModel *model = [HYSearchHotModel objectWithDictionary:dicts];
            [_hotIdArr addObject:model];
            [_hotArr addObject:model.hotName];
        }
        if ( _hotArr.count > 0 )
        {
            [self searchNewViews];
        }
    }];
}
#pragma mark -点击热词
-(void)clickHotSearchWords:(NSInteger)index
{
    if ( index >=0 && index < self.hotIdArr.count )
    {
        HYSearchHotModel *model = self.hotIdArr[index];
        
        [MKNetworking MKSeniorGetApi:@"/item/hotsearch/clickrate"
                           paramters:@{@"hot_id":model.Id,@"hot_name":model.hotName}
                          completion:^(MKHttpResponse *response)
         {
             
         }];
    }
}
@end
