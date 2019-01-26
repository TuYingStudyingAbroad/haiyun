//
//  RefundObject.m
//  YangDongXi
//
//  Created by 杨鑫 on 15/10/16.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "RefundObject.h"
#import "MKNetworking+BusinessExtension.h"
#import "NSDictionary+MKExtension.h"
#import "MBProgressHUD+MKExtension.h"
#import "BlackView.h"
#import "BlackWaitView.h"
#import "NSArray+MKExtension.h"
#import "AppDelegate.h"
#import <AliyunOSSiOS/OSSService.h>

@interface RefundObject ()

@property (nonatomic,assign)NSInteger stap;
@property (nonatomic,strong)NSMutableArray *imageUrl;

@property (nonatomic,strong)BlackView *promptView;
@property (nonatomic,strong)BlackWaitView *balckWaitView;
@property (nonatomic,strong)UITapGestureRecognizer *recognizer;



@end
@implementation RefundObject
- (UIView *)pickView{
    if (!_pickView) {
        self.pickView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _pickView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
        self.recognizer.numberOfTapsRequired = 1;
        [self.pickView addGestureRecognizer:self.recognizer];
       
    }
    return _pickView;
}
- (void)handleTapAction:(UITapGestureRecognizer *)sender{
    [self.pickView removeFromSuperview];
    [MKNetworking cancelAllOperation];
    self.stap = 0;
}
- (void)uploadData{
    self.stap = 0;
    self.imageUrl = [NSMutableArray array];
    UIWindow *win = [[UIApplication sharedApplication].delegate window];
    if (self.imageData.count>0) {
        self.balckWaitView = [[BlackWaitView alloc]initWithFrame:CGRectMake(0, 0, 200, 300)];
        self.balckWaitView.center = win.center;
        [self.balckWaitView.plck startAnimating];
        self.balckWaitView.blackLabelView.text = [NSString stringWithFormat:@"正在上传图片%ld/%ld",self.stap,self.imageData.count];
        [self.pickView addSubview:self.balckWaitView];
        [win addSubview:self.pickView];
        for (NSData *da in self.imageData) {
            [self uploadImageData:da];
        }
    }else{
        [self notImageUploadData];
    }
}
- (void)uploadImageData:(NSData *)data
{
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:@"scl16iPO2OUD1goj" secretKey:@"1J9wWa1ZSVzZ6pSFZ6nTGVhT8BvjG9"];
    
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    
    // 网络请求遇到异常失败后的重试次数
    conf.maxRetryCount = 3;
    
    // 网络请求的超时时间
    conf.timeoutIntervalForRequest =30;
    
    // 允许资源传输的最长时间
    conf.timeoutIntervalForResource =24 * 60 * 60;
    
    // 你的阿里地址前面通常是这种格式 ：http://oss……
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:@"oss-cn-hangzhou.aliyuncs.com" credentialProvider:credential];
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"member/ios_%@.png", str];
    
    put.bucketName =@"haiynoss";
    put.objectKey = fileName;
    
    put.uploadingData = data; // 直接上传NSData
    
    put.uploadProgress = ^(int64_t bytesSent,int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
    };
    
    OSSTask * putTask = [client putObject:put];
    
    // 上传阿里云
    [putTask continueWithBlock:^id(OSSTask *task)
     {
         
         if (!task.error)
         {
             [self.imageUrl addObject:[NSString stringWithFormat:@"http://haiynoss.oss-cn-hangzhou.aliyuncs.com/%@",fileName]];
             self.stap ++;
             self.balckWaitView.blackLabelView.text = [NSString stringWithFormat:@"正在上传图片%ld/%ld",self.stap,self.imageData.count];
             if (self.stap == self.imageData.count) {
                 [self.pickView removeFromSuperview];
                 [self notImageUploadData];
             }
         }
         return nil;
     }];

}
- (void)notImageUploadData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.refund_reason_id forKey:@"refund_reason_id"];
    [dict setObject:@(self.refund_amount.floatValue *100) forKey:@"refund_amount"];
    [dict setObject:self.refund_desc forKey:@"refund_desc"];
    [dict setObject:self.item.orderItemUid forKey:@"order_item_uid"];
    if (self.imageUrl.count>0) {
        NSMutableArray *muta = [NSMutableArray array];
        for (NSString *str in self.imageUrl) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:str forKey:@"image_url"];
            [muta addObject:dic];
        }
        [dict setObject:muta forKey:@"refund_image_list"];
    }
    NSArray *ar = [NSArray arrayWithObject:dict];
    [MKNetworking MKSeniorPostApi:@"trade/refund/apply" paramters:@{@"refund_list":[ar jsonString],@"order_uid":self.orderUid,@"user_id":@(getUserCenter.userInfo.userId)} completion:^(MKHttpResponse *response) {
        NSLog(@"%@",response.errorMsg);
        if ([response.responseDictionary[@"code"] isEqualToNumber: @(10000)]) {
            self.promptView = [[BlackView alloc]initWithFrame:CGRectMake(0, 0, 200, 300)];
        UIWindow *win = [[UIApplication sharedApplication].delegate window];
            self.promptView.center = win.center;
            [self.pickView addSubview:self.promptView];
            [win addSubview:self.pickView];
                self.tmpe();
            }else{
            [MBProgressHUD showMessageIsWait:@"请求失败" wait:YES];
        }
    }];
}
@end
