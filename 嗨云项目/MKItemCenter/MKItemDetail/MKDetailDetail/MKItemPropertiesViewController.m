//
//  MKItemPropertiesViewController.m
//  YangDongXi
//
//  Created by cocoa on 15/6/1.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKItemPropertiesViewController.h"
#import <PureLayout.h>
#import "MKItemPropertyObject.h"


@interface MKItemPropertiesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *itemProperties;

@end


@implementation MKItemPropertiesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    [self.delegate subViewControllerViewDidLoad:self];
}

- (void)loadProperties:(NSArray *)properties
{
    self.itemProperties = properties;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemProperties.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MKItemPropertyObject *ipo = self.itemProperties[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@", ipo.name, ipo.value];
    return cell;
}

- (UIScrollView *)getScrollView
{
    return self.tableView;
}

@end
