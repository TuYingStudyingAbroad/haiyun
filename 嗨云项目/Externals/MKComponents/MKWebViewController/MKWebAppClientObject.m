//
//  MKWebAppClientObject.m
//  嗨云项目
//
//  Created by 杨鑫 on 16/7/29.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "MKWebAppClientObject.h"

@interface MKWebAppClientObject ()
@property (nonatomic ,strong)NSDictionary *dic;
@end
@implementation MKWebAppClientObject
- (void)request:(id)JSText{
    NSString *str = [NSString stringWithFormat:@"%@",JSText];
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    if ([JSText isKindOfClass:[NSDictionary class]]) {
        self.dic = [NSDictionary dictionaryWithDictionary:JSText];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers              error:&err];
        self.dic = dic;
    }
    if (self.returnStrUrl) {
        self.returnStrUrl(self.dic);
    }
}
@end
