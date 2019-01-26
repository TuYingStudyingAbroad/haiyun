//
//  HYShopReShareView.m
//  嗨云项目
//
//  Created by haiyun on 16/8/24.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYShopReShareView.h"
#import "UIImageView+WebCache.h"
#import<AssetsLibrary/AssetsLibrary.h>
#import "UIAlertView+Blocks.h"
#import "HYShareActivityView.h"
#import "MKNetworking+BusinessExtension.h"
#import "HYShareInfo.h"
#import "HYShareKit.h"
#import "UIImage+ResizeMagick.h"

@interface HYShopReShareView ()
{
    UIImageView         *_QRCodeImageView;
    
    UIButton            *_leftSaveBtn;
    
    UIButton            *_rightShareBtn;
    
    UIView              *_lineView;
}

@property (nonatomic, strong) HYShareActivityView *shareView;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *shopIcon;
@property (nonatomic, copy) NSString *shopContent;


@end

@implementation HYShopReShareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        if ([[MKSellerIdSingleton sellerIdSingleton] sellerId])
//        {
//            [self updateWithSellerId:[[MKSellerIdSingleton sellerIdSingleton] sellerId]];
//        }
    }
    return self;
}




-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    
    CGRect  rect = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height-64.0f-49.0f);
    if ( _QRCodeImageView == nil )
    {
        _QRCodeImageView = NewObject(UIImageView);
        _QRCodeImageView.image = [UIImage imageNamed:@"placeholder_160x180"];
        _QRCodeImageView.frame = rect;
        [self addSubview:_QRCodeImageView];
    }else
    {
        _QRCodeImageView.frame = rect;
    }
    rect.origin.y += rect.size.height;
    rect.size.width = (Main_Screen_Width - 1.0f)/2.0f;
    rect.size.height = 49.0f;
    if ( _leftSaveBtn == nil )
    {
        _leftSaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftSaveBtn.backgroundColor = [UIColor clearColor];
        [_leftSaveBtn setTitle:@"保存到手机" forState:UIControlStateNormal];
        _leftSaveBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_leftSaveBtn setTitleColor:kHEXCOLOR(0x252525)  forState:UIControlStateNormal];
        _leftSaveBtn.frame = rect;
        [_leftSaveBtn addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftSaveBtn];
    }else
    {
        _leftSaveBtn.frame = rect;
    }
    rect.origin.x += rect.size.width;
    rect.size.width = 1.0f;
    if ( _lineView == nil )
    {
        _lineView = NewObject(UIView);
        _lineView.backgroundColor = kHEXCOLOR(0xcccccc);
        _lineView.frame = rect;
        [self addSubview:_lineView];
    }else
    {
        _lineView.frame = rect;
    }
    
    rect.origin.x += rect.size.width;
    rect.size.width = (Main_Screen_Width - 1.0f)/2.0f;
    if ( _rightShareBtn == nil )
    {
        _rightShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightShareBtn.backgroundColor = [UIColor clearColor];
        [_rightShareBtn setTitle:@"分享给好友" forState:UIControlStateNormal];
        _rightShareBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_rightShareBtn setTitleColor:kHEXCOLOR(0x252525)  forState:UIControlStateNormal];
        _rightShareBtn.frame = rect;
        [_rightShareBtn addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightShareBtn];
    }else
    {
        _leftSaveBtn.frame = rect;
    }

    
}

-(void)OnButton:(id)sender
{
    if ( sender == _leftSaveBtn )
    {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if(author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
            [UIAlertView showWithTitle:@"提示" message:@"请移步到系统设置开启相册访问权限" style:UIAlertViewStyleDefault cancelButtonTitle:@"确定" otherButtonTitles:@[@"取消"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                        return ;
                    }
                }else {
                    return;
                }
            }];
        }else
        {
            NSURL *url = [NSURL URLWithString:self.QRCodeStr];
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:url options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                [MBProgressHUD showMessageIsWait:@"已保存至手机相册" wait:YES];
            }];
        }
        
    }
    else if ( sender == _rightShareBtn )
    {
        if ( self.shareView == nil )
        {
            _shareView = [[HYShareActivityView alloc] initWithButtons:@[@(HYSharePlatformTypeWechatSession),@(HYSharePlatformTypeWechatTimeline),@(HYSharePlatformTypeQZone),@(HYSharePlatformTypeSinaWeibo),@(HYSharePlatformTypeQQFriend),@(HYSharePlatformTypeSMS),@(HYSharePlatformTypeCopy)] shareTypeBlock:^(HYSharePlatformType type)
                          {
                              
                              [self shareMoreActionClickType:type];
                              
                          }];
            [self.shareView show];
        }else
        {
            [self.shareView show];
        }
    }
}
- (void)shareMoreActionClickType:(NSInteger)types
{
    if ( types == 4 )
    {
        [self.shareView hide];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string        = [NSString stringWithFormat:@"%@/index.html",BaseHtmlURL];
        [MBProgressHUD showMessageIsWait:@"已复制链接至剪贴板，使用时粘贴即可" wait:YES];
        return;
    }
    if ( types == 8 )
    {
        [self.shareView hide];
        [self sendSMSMessageCompose];
        return;
    }
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:self.shopIcon] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        HYShareInfo *info = [[HYShareInfo alloc] init];
        info.title        = self.shopName;
        info.content      = ISNSStringValid(self.shopContent)?self.shopContent :@"不想你错过美好事物，所以分享我的店铺。";
        image = [image resizedImageWithMaximumSize:CGSizeMake(100, 100)];
        if ( image )
        {
            info.images = image;
            
        }
        else
        {
            info.images = [UIImage imageNamed:@"HYTouxiang"];
        }
        info.url          = [NSString stringWithFormat:@"%@/index.html",BaseHtmlURL];
        info.shareType    = HYShareDKContentTypeWebPage;
        info.type         = (HYPlatformType)types;
        [HYShareKit shareInfoWith:info completion:^(NSString *errorMsg)
         {
             if ( ISNSStringValid(errorMsg) )
             {
                 [MBProgressHUD showMessageIsWait:errorMsg wait:YES];
             }
             [self.shareView hide];
             
         }];
    }];
    
}

#pragma mark -获取店铺信息
- (void)updateWithSellerId:(NSString *)sellerId{
    
    [MKNetworking MKSeniorGetApi:@"/dist/shop/get" paramters:@{@"seller_id":sellerId} completion:^(MKHttpResponse *response) {
        if (response.errorMsg)
        {
            [MBProgressHUD showMessageIsWait:response.errorMsg wait:YES];
            return ;
        }
        self.shopName = [NSString stringWithFormat:@"%@",[response mkResponseData][@"shop_name"]];
        self.shopIcon = [NSString stringWithFormat:@"%@",[response mkResponseData][@"head_img_url"]];
        self.shopContent = [NSString stringWithFormat:@"%@",[response mkResponseData][@"shop_desc"]];
        
    }];
}

-(void)setQRCodeStr:(NSString *)QRCodeStr
{
    if ( ISNSStringValid(QRCodeStr) )
    {
        _QRCodeStr = QRCodeStr;
        [_QRCodeImageView sd_setImageWithURL:[NSURL URLWithString:QRCodeStr] placeholderImage:[UIImage imageNamed:@"placeholder_160x180"]];
    }
}

#pragma mark -发送短信
-(void)sendSMSMessageCompose
{
//    [[HYThreeDealMsg sharedInstance] shareInfoWithMessage:[NSString stringWithFormat:@"%@%@%@",self.shopName, (ISNSStringValid(self.shopContent)?self.shopContent :@"不想你错过美好事物，所以分享我的店铺;"),[NSString stringWithFormat:@"%@/index.html?distributor_id=%@",BaseHtmlURL,[[MKSellerIdSingleton sellerIdSingleton] sellerId]]] type:8];
    
}

@end
