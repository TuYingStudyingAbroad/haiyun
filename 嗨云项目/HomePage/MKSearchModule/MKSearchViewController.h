//
//  MKSearchViewController.h
//  YangDongXi
//
//  Created by cocoa on 15/4/22.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKSearchBar.h"
@class MKSearchViewController;

@protocol MKSearchViewControllerDelegate <NSObject>

- (void)searchViewController:(MKSearchViewController *)searchViewController needSearchWord:(NSString *)word;

@optional

- (void)searchViewControllerViewWillShow:(MKSearchViewController *)searchViewController;

- (void)searchViewControllerViewDidDismiss:(MKSearchViewController *)searchViewController;

@end


@interface MKSearchViewController : UIViewController

@property (nonatomic, weak) id<MKSearchViewControllerDelegate> delegate;

- (void)showInViewController:(UIViewController *)vc withOriginSearchBar:(MKSearchBar *)searchBar;

- (void)dismiss;

@end
