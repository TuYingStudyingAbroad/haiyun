//
//  MKWebAppClientObject.h
//  嗨云项目
//
//  Created by 杨鑫 on 16/7/29.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol MKWebAppClientObjectProtocol <JSExport>

- (void)request:(id)JSText;

@end
@interface MKWebAppClientObject : NSObject<MKWebAppClientObjectProtocol>

@property (nonatomic,assign)void (^returnStrUrl)(NSDictionary *dict);
@end
