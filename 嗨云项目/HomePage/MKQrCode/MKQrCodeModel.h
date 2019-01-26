//
//  MKQrCodeModel.h
//  YangDongXi
//
//  Created by windy on 15/4/22.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@class MKQrCodeModel;

@protocol MKQrCodeModelDelegate <NSObject>

- (void)qrCodeModel:(MKQrCodeModel *)model capturedText:(NSString *)text;

- (void)qrCodeModel:(MKQrCodeModel *)model deviceError:(NSError *)error;

@end


@interface MKQrCodeModel : NSObject

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, weak) id<MKQrCodeModelDelegate> delegate;

- (void)initializeDevice;

- (void)start;
- (void)stop;

- (void)pauseCapture;
- (void)continueCapture;

- (void)decodeImageAsynchronously:(UIImage *)image;

@end
