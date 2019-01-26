//
//  MJPhotoToolbar.m
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoToolbar.h"
#import "MJPhoto.h"
#import "MBProgressHUD+MKExtension.h"

@interface MJPhotoToolbar()
{
    // 显示页码
    UILabel *_indexLabel;
    UIButton *_saveImageBtn;
}

@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation MJPhotoToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (_photos.count > 1) {
//        _indexLabel = [[UILabel alloc] init];
//        _indexLabel.font = [UIFont boldSystemFontOfSize:20];
//        _indexLabel.frame = self.bounds;
//        _indexLabel.backgroundColor = [UIColor clearColor];
//        _indexLabel.textColor = [UIColor whiteColor];
//        _indexLabel.textAlignment = NSTextAlignmentCenter;
//        _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        [self addSubview:_indexLabel];
        self.pageControl = [[UIPageControl alloc]init];
        self.pageControl.numberOfPages = photos.count;
        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
//        [self.pageControl updateCurrentPageDisplay];
//        [self.pageControl layoutIfNeeded];
        [self addSubview:self.pageControl];
        self.pageControl.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0);
    }
    
//    // 保存图片按钮
//    CGFloat btnWidth = self.bounds.size.height;
//    _saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _saveImageBtn.frame = CGRectMake(20, 0, btnWidth, btnWidth);
//    _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon.png"] forState:UIControlStateNormal];
//    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon_highlighted.png"] forState:UIControlStateHighlighted];
//    [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_saveImageBtn];
}

- (void)saveImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MJPhoto *photo = _photos[_currentPhotoIndex];
        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showMessageIsWait:@"保存失败" wait:YES];
    } else {
        MJPhoto *photo = _photos[_currentPhotoIndex];
        photo.save = YES;
        _saveImageBtn.enabled = NO;
        [MBProgressHUD showMessageIsWait:@"成功保存到相册" wait:YES];
    }
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    self.pageControl.currentPage = currentPhotoIndex;
    // 更新页码
    _indexLabel.text = [NSString stringWithFormat:@"%lu / %lu", _currentPhotoIndex + 1, (unsigned long)_photos.count];
    
    MJPhoto *photo = _photos[_currentPhotoIndex];
    // 按钮
    _saveImageBtn.enabled = photo.image != nil && !photo.save;
}

@end
