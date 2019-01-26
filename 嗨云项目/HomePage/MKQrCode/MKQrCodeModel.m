//
//  MKQrCodeModel.m
//  YangDongXi
//
//  Created by windy on 15/4/22.
//  Copyright (c) 2015年 yangdongxi. All rights reserved.
//

#import "MKQrCodeModel.h"
#import <ZXingObjC.h>


@interface MKQrCodeModel () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) dispatch_queue_t sessionQueue;

@property (nonatomic, assign) BOOL capturePause;

@property (nonatomic, assign) BOOL decoding;

@property (nonatomic, strong) ZXQRCodeReader *reader;

@end


@implementation MKQrCodeModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.reader = [[ZXQRCodeReader alloc] init];
        
        self.session = [[AVCaptureSession alloc] init];
        self.session.sessionPreset = AVCaptureSessionPreset640x480;
        
        self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        self.sessionQueue = dispatch_queue_create("ve qrcode session", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)initializeDevice
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error;
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (error)
    {
        [self.delegate qrCodeModel:self deviceError:error];
    }
    
    if ([self.session canAddInput:videoDeviceInput])
    {
        [self.session addInput:videoDeviceInput];
    }
    
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    
    [output setVideoSettings:@{(NSString *)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]}];
    [output setAlwaysDiscardsLateVideoFrames:YES];
    [output setSampleBufferDelegate:self queue:self.sessionQueue];
    
    [self.session addOutput:output];
}

- (void)start
{
    [self.session startRunning];
}

- (void)stop
{
    [self.session stopRunning];
}

- (void)pauseCapture
{
    self.capturePause = YES;
}

- (void)continueCapture
{
    self.capturePause = NO;
}

#pragma mark -  AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    if (self.capturePause)
    {
        return;
    }
    CVImageBufferRef buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CGImageRef imageRef = [ZXCGImageLuminanceSource createImageFromBuffer:buffer];
    NSString *text = [self decodeCGImage:imageRef];
    if (text.length > 0)
    {
        dispatch_sync(dispatch_get_main_queue(), ^
        {
            [self.delegate qrCodeModel:self capturedText:text];
        });
    }
    CGImageRelease(imageRef);
}

- (NSString *)decodeCGImage:(CGImageRef)imageRef
{
    ZXCGImageLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageRef];
    if (source == nil)
    {
        return nil;
    }
    ZXHybridBinarizer *binarizer = [[ZXHybridBinarizer alloc] initWithSource:source];
    ZXBinaryBitmap *bitmap = [[ZXBinaryBitmap alloc] initWithBinarizer:binarizer];
    ZXResult *localResult = [self.reader decode:bitmap error:nil];
    
    return localResult.text;
}

//解析二维码图片
- (void)decodeImageAsynchronously:(UIImage *)image
{
    dispatch_async(self.sessionQueue, ^
                   {
                       NSString *text = [self decodeCGImage:image.CGImage];
                       dispatch_sync(dispatch_get_main_queue(), ^
                                     {
                                         [self.delegate qrCodeModel:self capturedText:text];
                                     });
                   });
}

#pragma mark - utils
- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format
{
    switch (format)
    {
        case kBarcodeFormatAztec:
            return @"Aztec";
            
        case kBarcodeFormatCodabar:
            return @"CODABAR";
            
        case kBarcodeFormatCode39:
            return @"Code 39";
            
        case kBarcodeFormatCode93:
            return @"Code 93";
            
        case kBarcodeFormatCode128:
            return @"Code 128";
            
        case kBarcodeFormatDataMatrix:
            return @"Data Matrix";
            
        case kBarcodeFormatEan8:
            return @"EAN-8";
            
        case kBarcodeFormatEan13:
            return @"EAN-13";
            
        case kBarcodeFormatITF:
            return @"ITF";
            
        case kBarcodeFormatPDF417:
            return @"PDF417";
            
        case kBarcodeFormatQRCode:
            return @"QR Code";
            
        case kBarcodeFormatRSS14:
            return @"RSS 14";
            
        case kBarcodeFormatRSSExpanded:
            return @"RSS Expanded";
            
        case kBarcodeFormatUPCA:
            return @"UPCA";
            
        case kBarcodeFormatUPCE:
            return @"UPCE";
            
        case kBarcodeFormatUPCEANExtension:
            return @"UPC/EAN extension";
            
        default:
            return @"Unknown";
    }
}

@end