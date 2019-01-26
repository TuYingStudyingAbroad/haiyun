//
//  MKServiceTableViewController.m
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/16.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKServiceTableViewController.h"
#import "HasDetailViewController.h"
#import "UIViewController+MKExtension.h"
#import "BaiduMobStat.h"

@interface MKServiceTableViewController ()

@end

@implementation MKServiceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务选择";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section

{
    return [[UIView alloc]init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HasDetailViewController *a = [HasDetailViewController create];
    if (indexPath.row == 0) {
        a.order = self.order;
        a.itemObject = self.itemObject;
        a.orderUid = self.orderUid;
        a.tString = @"退货退款";
         a.isReturn = YES;
    }
    if (indexPath.row == 1) {
        a.order = self.order;
        a.itemObject = self.itemObject;
        a.orderUid = self.orderUid;
        a.tString = @"仅退款";
    }
    [self.navigationController pushViewController:a animated:YES];
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
