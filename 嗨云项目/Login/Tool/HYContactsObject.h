//
//  HYContactsObject.h
//  嗨云项目
//
//  Created by haiyun on 16/7/13.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKBaseObject.h"

@interface HYContactsObject : MKBaseObject

@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *initial;//首字母
@property (nonatomic,copy) NSString  *mobile;

@end

/**************格式化联系人列表*******************/
@interface HYContactDataHelper : NSObject

/**
 *  对联系人排序
 *
 *  @param array 需要排序的数组
 *
 *  @return 拍完序列数组
 */
+ (NSMutableArray *) getFriendListDataBy:(NSMutableArray *)array;
/**
 *  获取数据源所有首字母
 *
 *  @param array 数据源
 *
 *  @return 首字母字典
 */
+ (NSMutableArray *) getFriendListSectionBy:(NSMutableArray *)array;

@end
