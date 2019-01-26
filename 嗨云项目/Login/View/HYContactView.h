//
//  HYContactView.h
//  嗨云项目
//
//  Created by haiyun on 16/7/13.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYBaseView.h"

@class HYContactsObject;
@interface HYContactView : HYBaseView

@property (nonatomic,strong) NSArray *serverDataArr;//数据源

-(void)updateContactView:(NSMutableArray *)nsDataArr;

@end


@interface HYContactTableViewCell : UITableViewCell

-(void)setMenuMsgDict:(HYContactsObject *)contacts;

@end
