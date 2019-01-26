//
//  MKTestJSObject.h
//  YangDongXi
//
//  Created by 李景 on 16/3/16.
//  Copyright © 2016年 yangdongxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>


typedef void(^returnBlock)(NSDictionary * dic);
@protocol MKTestJSObjectProtocol <JSExport>

- (void)call:(id)JSText;

@end

@interface MKTestJSObject : NSObject<MKTestJSObjectProtocol>


@property (nonatomic, strong)NSDictionary *dic;

@property (nonatomic,assign)id<MKTestJSObjectProtocol> delegate;
@property (nonatomic,strong)returnBlock returnTextBlock;

@property (nonatomic,assign)BOOL isRef;

@property (nonatomic,strong)void (^returnStrUrl)(NSString *strUrl,NSDictionary *dic);


- (void) returnText: (returnBlock)block;
@end
