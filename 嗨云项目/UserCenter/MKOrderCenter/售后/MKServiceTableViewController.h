//
//  MKServiceTableViewController.h
//  嗨云项目
//
//  Created by 杨鑫 on 16/5/16.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKOrderItemObject.h"
#import "MKOrderObject.h"

@interface MKServiceTableViewController : UITableViewController

@property (nonatomic, strong) MKOrderObject *order;

@property (nonatomic, strong) NSString *orderUid;

@property (nonatomic, strong)MKOrderItemObject *itemObject;

@end
