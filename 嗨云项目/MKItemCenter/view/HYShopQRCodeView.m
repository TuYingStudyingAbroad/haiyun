//
//  HYShopQRCodeView.m
//  嗨云项目
//
//  Created by haiyun on 16/8/23.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYShopQRCodeView.h"
#import "UIImageView+WebCache.h"
#import<AssetsLibrary/AssetsLibrary.h>
#import "UIAlertView+Blocks.h"
#import "HYShareActivityView.h"
#import "MKNetworking+BusinessExtension.h"
#import "HYShareInfo.h"
#import "HYShareKit.h"
#import "UIImage+ResizeMagick.h"


@interface HYShopQRCodeView()
{
    UIView          *_QRBgView;
    UIImageView     *_QRCodeImageView;
    UIButton        *_shareBtn;
    UIButton        *_saveBtn;
}

@property (nonatomic, strong) HYShareActivityView *shareView;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *shopIcon;
@property (nonatomic, copy) NSString *shopContent;
@end

@implementation HYShopQRCodeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        if ([[MKSellerIdSingleton sellerIdSingleton] sellerId]) {
//            [self updateWithSellerId:[[MKSellerIdSingleton sellerIdSingleton] sellerId]];
//        }
    }
    return self;
}




-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.backgroundColor = kHEXCOLOR(0xf5f5f5);
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    CGRect  rect = CGRectMake(0.0f, 35.0f, 590.0f/750.0f*Main_Screen_Width, 780.0f/1334.0f*Main_Screen_Height);
    rect.origin.x = (Main_Screen_Width - rect.size.width)/2.0f;

    if ( _QRCodeImageView == nil )
    {
        _QRCodeImageView = NewObject(UIImageView);
        _QRCodeImageView.frame = rect;
        _QRCodeImageView.image = [UIImage imageNamed:@"placeholder_160x180"];
        _QRCodeImageView.layer.cornerRadius= 6.0f;
        _QRCodeImageView.layer.masksToBounds = YES;
        _QRCodeImageView.layer.borderColor = kHEXCOLOR(0xa8a8a8).CGColor;
        _QRCodeImageView.layer.borderWidth = 0.5f;
        _QRCodeImageView.backgroundColor = [UIColor whiteColor];
        [_QRCodeImageView sd_setImageWithURL:[NSURL URLWithString:self.QRCodeStr] placeholderImage:[UIImage imageNamed:@"placeholder_160x180"]];
        [self addSubview:_QRCodeImageView];
    }else
    {
        [_QRCodeImageView sd_setImageWithURL:[NSURL URLWithString:self.QRCodeStr] placeholderImage:[UIImage imageNamed:@"placeholder_160x180"]];
        _QRCodeImageView.frame = rect;
    }
    
    rect.origin.y += rect.size.height +30.0f;
    rect.size.width = (Main_Screen_Width - 2*rect.origin.x - 15.0f)/2.0f;
    rect.size.height = 40.0f;
    if ( _saveBtn == nil )
    {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.backgroundColor = kHEXCOLOR(0xfea226);
        [_saveBtn setTitle:@"保存到手机" forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_saveBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        _saveBtn.frame = rect;
        _saveBtn.layer.cornerRadius = 3.0;
        _saveBtn.layer.masksToBounds = YES;
        [_saveBtn addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_saveBtn];
    }else
    {
        _saveBtn.frame = rect;
    }
    rect.origin.x += rect.size.width + 15.0f;
    if ( _shareBtn == nil )
    {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.backgroundColor = kHEXCOLOR(kRedColor);
        [_shareBtn setTitle:@"分享给好友" forState:UIControlStateNormal];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _shareBtn.frame = rect;
        _shareBtn.layer.cornerRadius = 3.0;
        _shareBtn.layer.masksToBounds = YES;
        [_shareBtn addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_shareBtn];
    }else
    {
        _shareBtn.frame = rect;
    }
}



-(void)OnButton:(id)sender
{
    if ( sender == _saveBtn )
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
                [MBProgressHUD showMessageIsWait:@"店铺已保存至手机相册" wait:YES];
            }];
        }
        
    }
    else if ( sender == _shareBtn )
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
//        pasteboard.string        = [NSString stringWithFormat:@"%@/index.html?distributor_id=%@",BaseHtmlURL,[[MKSellerIdSingleton sellerIdSingleton] sellerId]];
        pasteboard.string = [NSString stringWithFormat:@"%@/index.html",BaseHtmlURL];
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
//        info.url          = [NSString stringWithFormat:@"%@/index.html?distributor_id=%@",BaseHtmlURL,[[MKSellerIdSingleton sellerIdSingleton] sellerId]];
        info.url = [NSString stringWithFormat:@"%@/index.html",BaseHtmlURL];
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

#pragma mark -发送短信
-(void)sendSMSMessageCompose
{
//    [[HYThreeDealMsg sharedInstance] shareInfoWithMessage:[NSString stringWithFormat:@"%@%@%@",self.shopName, (ISNSStringValid(self.shopContent)?self.shopContent :@"不想你错过美好事物，所以分享我的店铺;"),[NSString stringWithFormat:@"%@/index.html?distributor_id=%@",BaseHtmlURL,[[MKSellerIdSingleton sellerIdSingleton] sellerId]]] type:8];
    
}


@end
