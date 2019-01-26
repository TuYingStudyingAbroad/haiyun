//
//  HYSearchNewView.h
//  嗨云项目
//
//  Created by haiyun on 16/9/19.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYBaseScrollView.h"

@interface HYSearchNewView : HYBaseScrollView

@end


@interface HYSearchShowView : UIView

@property (nonatomic,strong) NSMutableArray *keyArr;
@property (nonatomic,copy) NSString *titleName;
@property (nonatomic,copy) NSString *rightImageStr;
@property (nonatomic,copy) NSString *leftImageStr;


@end

@interface HYKeywordsView : UIView

@property (nonatomic,copy) NSString *keyTitle;
@property (nonatomic,assign) BOOL isHide;


@end
