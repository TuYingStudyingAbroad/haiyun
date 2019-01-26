//
//  HYSafeBandCardView.m
//  嗨云项目
//
//  Created by haiyun on 16/8/31.
//  Copyright © 2016年 杨鑫. All rights reserved.
//

#import "HYSafeBandCardView.h"
#import "HYTextFieldBaseView.h"
#import "HYLoginTextFieldView.h"
#import "HYPhoto.h"
#import "MKNetworking+BusinessExtension.h"
#import "UIImageView+WebCache.h"
#import "YLSafeTool.h"
#import "HYSafeBandInfo.h"
#import <AliyunOSSiOS/OSSService.h>

@interface HYSafeBandCardView ()<HYSafeCardViewDelegate>
{
    UILabel         *_bankLabel;
    HYTextFieldBaseView        *_nameView;//名字
    HYTextFieldBaseView        *_cardView;//身份证号
    
    NSString                    *_cardLeftImageUrl;//leftImage
    NSString                    *_cardRightImageUrl;//rghtImage

    HYSafeCardView             *_safeCardView;
    
    UILabel                    *_titleLabel;
    UIImageView                *_cardImageView;
    
    UILabel                     *_tapLabel;
    UILabel                     *_title1Label;

}

@end

@implementation HYSafeBandCardView

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsNull(frame)||CGRectIsEmpty(frame))
        return;
    
    CGRect rect = CGRectMake(12.0f, 0.0f, frame.size.width-24.0f, 35.0f);
    
    if ( _bankLabel == nil )
    {
        _bankLabel = NewObject(UILabel);
        _bankLabel.backgroundColor = [UIColor clearColor];
        _bankLabel.text = @"完成实名认证后提取账户余额";
        _bankLabel.font = [UIFont systemFontOfSize:11.0f];
        _bankLabel.textColor = kHEXCOLOR(0x999999);
        _bankLabel.textAlignment = NSTextAlignmentLeft;
        _bankLabel.frame = rect;
        [self.pBaseView addSubview:_bankLabel];
    }else
    {
        _bankLabel.frame = rect;
    }
    rect.origin.x = 0;
    rect.size.width = frame.size.width;
    rect.origin.y += rect.size.height;
    rect.size.height = 44.0f;
    if ( _nameView == nil )
    {
        _nameView = NewObject(HYTextFieldBaseView);
        _nameView.textMinLength = 2;
        _nameView.textMaxLength = 12;
        _nameView.iconImageName = @"HYSafeyonghuming";
        _nameView.textPlaceName = @"姓名";
        _nameView.keyboardType = UIKeyboardTypeDefault;
        _nameView.textIsEnabled = YES;
        _nameView.secureTextEntry = NO;
        _nameView.frame = rect;
        [self.pBaseView addSubview:_nameView];
    }else
    {
        _nameView.frame = rect;
    }
    
    rect.origin.y += rect.size.height;
    if ( _cardView == nil )
    {
        _cardView = NewObject(HYTextFieldBaseView);
        _cardView.textMinLength = 15;
        _cardView.textMaxLength = 18;
        _cardView.iconImageName = @"HYSafeshenfenzheng";
        _cardView.textPlaceName = @"身份证号";
        _cardView.keyboardType = UIKeyboardTypeDefault;
        _cardView.textIsEnabled = YES;
        _cardView.secureTextEntry = NO;
        _cardView.bottomHide = YES;
        _cardView.frame = rect;
        [self.pBaseView addSubview:_cardView];
    }else
    {
        _cardView.frame = rect;
    }
    
    rect.origin.y += rect.size.height;
    rect.origin.x = 0;
    rect.size.width = frame.size.width;
    rect.size.height = 151.0f;
    if ( _safeCardView == nil )
    {
        _safeCardView = NewObject(HYSafeCardView);
        _safeCardView.isOnlyShow = NO;
        _safeCardView.frame = rect;
        _safeCardView.delegate = self;
        [self.pBaseView addSubview:_safeCardView];
    }
    else
    {
        _safeCardView.frame = rect;
    }
    
    rect.origin.x = 12.0f;
    rect.origin.y += rect.size.height + 15.0f;
    rect.size.width = frame.size.width - 2*rect.origin.x;
    rect.size.height = 20.0f;
    if ( _titleLabel == nil )
    {
        _titleLabel = NewObject(UILabel);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"参考图例";
        _titleLabel.frame = rect;
        _titleLabel.textColor = kHEXCOLOR(0x252525);
        _titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.pBaseView addSubview:_titleLabel];
    }else
    {
        _titleLabel.frame = rect;
    }
    
    
    rect.origin.y += rect.size.height + 12.0f;
    rect.size.width = 295.0f;
    rect.origin.x = (frame.size.width -rect.size.width)/2.0f;
    rect.size.height = 190.0f;
    if ( _cardImageView == nil )
    {
        _cardImageView = NewObject(UIImageView);
        _cardImageView.image = [UIImage imageNamed:@"HYtuli"];
        _cardImageView.frame = rect;
        [self.pBaseView addSubview:_cardImageView];
    }else
    {
        _cardImageView.frame = rect;
    }
    
    rect.origin.x = 12.0f;
    rect.origin.y += rect.size.height + 12.0f;
    rect.size.width = frame.size.width - 2*rect.origin.x;
    rect.size.height = 20.0f;
    if ( _title1Label == nil )
    {
        _title1Label = NewObject(UILabel);
        _title1Label.textAlignment = NSTextAlignmentLeft;
        _title1Label.text = @"温馨提示：";
        _title1Label.frame = rect;
        _title1Label.textColor = kHEXCOLOR(0x999999);
        _title1Label.font = [UIFont systemFontOfSize:12.0f];
        [self.pBaseView addSubview:_title1Label];
    }else
    {
        _title1Label.frame = rect;
    }
    
    rect.origin.y += rect.size.height;
    rect.origin.x = 25.0f;
    rect.size.width = frame.size.width - 2*rect.origin.x;
    rect.size.height = 83.0f;
    if ( _tapLabel == nil )
    {
        _tapLabel = NewObject(UILabel);
        _tapLabel.textAlignment = NSTextAlignmentLeft;
        _tapLabel.text = @"1.身份证上所有信息清晰可见，必须能看清证件号;\r\n2.手持证件人需身份证本人;\r\n3.需免冠，建议未化妆，五官清晰可见;\r\n4.照片内容真实有效，不得做任何修改;\r\n5.支持jpg .png格式照片，大小不超过2M。";
        _tapLabel.frame = rect;
        _tapLabel.numberOfLines = 0;
        _tapLabel.textColor = kHEXCOLOR(0x999999);
        _tapLabel.backgroundColor = [UIColor clearColor];
        _tapLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.pBaseView addSubview:_tapLabel];
    }else
    {
        _tapLabel.frame = rect;
    }

    CGRect rectBaseView = _pBaseView.frame;
    rectBaseView.size.height = rect.origin.y + rect.size.height+100.0f;
    _pBaseView.frame = rectBaseView;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.contentSize = CGSizeMake(0,_pBaseView.frame.size.height);
}

-(void)onButtonClickRight
{
    NSString *msg = nil;
    CloseKeyBord(YES);
    if ( _nameView.textName.length <=0 )
    {
        msg = @"请填写姓名";
    }
    else if ( _nameView.textName.length <2 || _nameView.textName.length>12 )
    {
        msg = @"请填写正确的姓名";
    }
    else if (_cardView.textName.length <= 0  )
    {
        msg = @"请填写身份证号";
    }
    else if ( !HYJudgeIdCardCheckUtil(_cardView.textName) )
    {
        msg = @"请填写正确的身份证号";
    }
    else if ( !ISNSStringValid(_cardLeftImageUrl) )
    {
        msg = @"请选择手持身份证照片";
    }
    else if ( !ISNSStringValid(_cardRightImageUrl) )
    {
        msg = @"请选择手持身份证照片";
    }
    if ( msg != nil)
    {
        [MBProgressHUD showMessageIsWait:msg wait:YES];
        return;
    }
//    @"user_id":@(getUserCenter.userInfo.userId),
    [YLSafeTool sendUserAuthonSave:@{
                                     @"bank_realname":_nameView.textName,
                                     @"bank_personal_id":_cardView.textName,
                                     @"picture_front":_cardLeftImageUrl,
                                     @"picture_back":_cardRightImageUrl} success:^{
                                         [self bandCardSuccess];
                                     }];
}

#pragma mark -绑定成功
-(void)bandCardSuccess
{
    if ( self.baseDelegate && [self.baseDelegate respondsToSelector:@selector(OnPushController:wParam:)])
    {
        [self.baseDelegate OnPushController:0 wParam:nil];
    }
}

#pragma mark -HYSafeCardViewDelegate
-(void)safeCardView:(HYSafeCardView *)safeView
           imageUrl:(NSString *)imageUrl
              index:(NSInteger)index
{
    if ( index == 1 )
    {
        _cardLeftImageUrl = imageUrl;
    }else
    {
        _cardRightImageUrl = imageUrl;
    }
}
@end


/*************照片******************/

@interface HYSafeCardView ()
{
    UILabel                     *_titleLabel;
    UIView                      *_lineView;
   
    UIImageView                 *_leftImageView;
    UIButton                    *_leftBtn;
    UIImageView                 *_rightImageView;
    UIButton                    *_rightBtn;
}

@end

@implementation HYSafeCardView

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsNull(frame)||CGRectIsEmpty(frame))
        return;
    self.backgroundColor = [UIColor whiteColor];
    CGRect  rect = CGRectMake(0, 0, frame.size.width, 0.5f);
    if ( _lineView == nil )
    {
        _lineView = NewObject(UIView);
        _lineView.frame = rect;
        _lineView.backgroundColor = kHEXCOLOR(0xe5e5e5);
        [self addSubview:_lineView];
    }else
    {
        _lineView.frame = rect;
    }
    
    rect.origin.x = 12.0f;
    rect.origin.y += rect.size.height + 12.0f;
    rect.size.width = frame.size.width - 2*rect.origin.x;
    rect.size.height = 20.0f;
    if ( _titleLabel == nil )
    {
        _titleLabel = NewObject(UILabel);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"身份证照片";
        _titleLabel.frame = rect;
        _titleLabel.textColor = kHEXCOLOR(0x252525);
        _titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:_titleLabel];
    }else
    {
        _titleLabel.frame = rect;
    }
    
    rect.origin.y += rect.size.height + 6.0f;
    rect.size.width = 142.0f;
    rect.origin.x = (frame.size.width -2*rect.size.width -15.0f)/2.0f;
    rect.size.height = 92.0f;
    if ( _leftImageView == nil )
    {
        _leftImageView = NewObject(UIImageView);
        if (ISNSStringValid(self.leftImageStr))
        {
            [_leftImageView sd_setImageWithURL:[NSURL URLWithString:self.leftImageStr] placeholderImage:[UIImage imageNamed:@"HYfanmian"]];
        }else
        {
            _leftImageView.image = [UIImage imageNamed:@"HYfanmian"];
        }
        _leftImageView.userInteractionEnabled = YES;
        _leftImageView.frame = rect;
        [self addSubview:_leftImageView];
    }else
    {
        if (ISNSStringValid(self.leftImageStr))
        {
            [_leftImageView sd_setImageWithURL:[NSURL URLWithString:self.leftImageStr] placeholderImage:[UIImage imageNamed:@"HYfanmian"]];
        }
        _leftImageView.frame = rect;
    }
    
    rect.origin.y += 30.0f;
    rect.origin.x += 25.0f;
    rect.size.width = 92.0f;
    rect.size.height = 32.0f;
    if ( _leftBtn == nil )
    {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setTitle:@"上传正面" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:kHEXCOLOR(kRedColor) forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _leftBtn.frame = rect;
        _leftBtn.userInteractionEnabled = YES;
        _leftBtn.layer.cornerRadius = 5.0;
        _leftBtn.layer.masksToBounds = YES;
        _leftBtn.layer.borderColor = kHEXCOLOR(kRedColor).CGColor;
        _leftBtn.layer.borderWidth = 0.5f;
        _leftBtn.backgroundColor = [UIColor clearColor];
        [_leftBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.hidden = self.isOnlyShow;
        [self addSubview:_leftBtn];
    }else
    {
        _leftBtn.hidden = self.isOnlyShow;
        _leftBtn.frame = rect;
    }
    
    rect.origin.y = _leftImageView.frame.origin.y;
    rect.origin.x = _leftImageView.frame.origin.x + _leftImageView.frame.size.width;
    rect.origin.x += 15.0f;
    rect.size.width = _leftImageView.frame.size.width;
    rect.size.height = _leftImageView.frame.size.height;
    
    if ( _rightImageView == nil )
    {
        _rightImageView = NewObject(UIImageView);
        if (ISNSStringValid(self.rightImageStr))
        {
            [_rightImageView sd_setImageWithURL:[NSURL URLWithString:self.rightImageStr] placeholderImage:[UIImage imageNamed:@"HYfanmian"]];

        }else
        {
            _rightImageView.image = [UIImage imageNamed:@"HYfanmian"];
        }
        _rightImageView.userInteractionEnabled = YES;
        _rightImageView.frame = rect;
        [self addSubview:_rightImageView];
    }else
    {
        if (ISNSStringValid(self.rightImageStr))
        {
            [_rightImageView sd_setImageWithURL:[NSURL URLWithString:self.rightImageStr] placeholderImage:[UIImage imageNamed:@"HYfanmian"]];
        }
        _rightImageView.frame = rect;
    }
    
    rect.origin.y += 30.0f;
    rect.origin.x += 25.0f;
    rect.size.width = 92.0f;
    rect.size.height = 32.0f;
    if ( _rightBtn == nil )
    {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"上传反面" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:kHEXCOLOR(kRedColor) forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _rightBtn.frame = rect;
        _rightBtn.userInteractionEnabled = YES;
        _rightBtn.layer.cornerRadius = 5.0;
        _rightBtn.layer.masksToBounds = YES;
        _rightBtn.layer.borderColor = kHEXCOLOR(kRedColor).CGColor;
        _rightBtn.layer.borderWidth = 0.5f;
        _rightBtn.backgroundColor = [UIColor clearColor];
        [_rightBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.hidden = self.isOnlyShow;
        [self addSubview:_rightBtn];
    }else
    {
        _rightBtn.hidden = self.isOnlyShow;
        _rightBtn.frame = rect;
    }

}

-(void)onButton:(id)sender1
{
    if ( sender1 == _leftBtn || sender1 == _rightBtn )
    {
        __weak typeof(self) weakSelf = self;
        
        [[HYPhoto getSharePhoto] getPhoto:sender1
                                     Back:YES
                                    Image:^(UIImage *image, id sender)
         {
             if ((sender == _leftBtn || sender == _rightBtn) && image)
             {
                 UIImage *imageLogo = [weakSelf addImageLogo:image logo:[UIImage imageNamed:@"HYShuiyin"]];
                 
                 NSData *data;
                 if (UIImagePNGRepresentation(imageLogo) == nil)
                 {
                     data = UIImageJPEGRepresentation(imageLogo, 0.5);
                 }
                 else
                 {
                     data = UIImagePNGRepresentation(imageLogo);
                 }
                 NSInteger index = 2;
                 if ( sender == _leftBtn ){
                     index = 1;
                 }
//                 [weakSelf uploadImageData:data types:index];
                 [weakSelf updateToALi:data types:index];
             }
             
         }];
    }
}

#pragma mark -图片上传
- (void)updateToALi:(NSData *)data types:(NSInteger)index
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
    NSString *fileName = [NSString stringWithFormat:@"member/ios_card%@.png", str];
    
    put.bucketName =@"haiynoss";
    put.objectKey = fileName;
    
    put.uploadingData = data; // 直接上传NSData
    
    put.uploadProgress = ^(int64_t bytesSent,int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
    };
    
    OSSTask * putTask = [client putObject:put];
    
//    MBProgressHUD *hud1 = [MBProgressHUD showMessage:nil inView:UIAppWindow wait:YES];
    __weak typeof(self) weakSelf = self;
    // 上传阿里云
    [putTask continueWithBlock:^id(OSSTask *task)
    {
        
        if (!task.error)
        {
//            [hud1 hide:YES];
            [weakSelf updateImageUrl:[NSString stringWithFormat:@"http://haiynoss.oss-cn-hangzhou.aliyuncs.com/%@",fileName] index:index];
            if ( _delegate && [_delegate respondsToSelector:@selector(safeCardView:imageUrl:index:)]) {
                [_delegate safeCardView:weakSelf imageUrl:[NSString stringWithFormat:@"http://haiynoss.oss-cn-hangzhou.aliyuncs.com/%@",fileName] index:index];
            }
        } else
        {
//            [hud1 hide:YES];
            [MBProgressHUD showMessageIsWait:@"上传失败！" wait:YES];
        }
        return nil;
    }];
    
}

- (void)uploadImageData:(NSData *)data types:(NSInteger)index{

    MKMulipartFormObject * object = [[MKMulipartFormObject alloc]init];
    MBProgressHUD *hud = [MBProgressHUD showMessage:nil inView:UIAppWindow wait:YES];
    //[MBProgressHUD showMessageIsWait:@"图片上传中" wait:YES];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
    [object addFileData:data withName:@"images" type:@"image/jpg" filename:fileName];
    [object addParameters:@{@"media_auth_key":@"6r4XkF6EcE"}];
    [MKNetworking POST:@"http://b.taojae.com/service.php" form:object completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [hud hide:YES];
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString: @"10000"])
        {
            [self updateImageUrl:[[responseObject objectForKey:@"data"] objectForKey:@"thumb"] index:index];
            if ( _delegate && [_delegate respondsToSelector:@selector(safeCardView:imageUrl:index:)]) {
                [_delegate safeCardView:self imageUrl:[[responseObject objectForKey:@"data"] objectForKey:@"thumb"] index:index];
            }
            
        }else
        {
            [MBProgressHUD showMessageIsWait:@"上传失败！" wait:YES];
        }
        
        
    }];
}

#pragma mark -增加水印
-(UIImage *)addImageLogo:(UIImage *)img logo:(UIImage *)logo
{
    CGImageRef imgRef = img.CGImage;
    CGFloat w = CGImageGetWidth(imgRef);
    CGFloat h = CGImageGetHeight(imgRef);
    
    //以img的图大小为底图
    CGImageRef imgRef1 = logo.CGImage;
    CGFloat w1 = CGImageGetWidth(imgRef1);
    CGFloat h1 = CGImageGetHeight(imgRef1);
    
    //以img的图大小为画布创建上下文
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    [img drawInRect:CGRectMake(0, 0, w, h)];//先把img 画到上下文中
    [logo drawInRect:CGRectMake(w-w1-15.0f, h-h1-15.0f, w1, h1)];//再把小图放在上下文中
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();//从当前上下文中获得最终图片
    UIGraphicsEndImageContext();//关闭上下文
    
//    CGImageRelease(imgRef);
//    CGImageRelease(imgRef1);
    return resultImg;
}

-(void)updateImageUrl:(NSString *)imageUrl index:(NSInteger)index
{
    if ( index == 1 )
    {
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"HYfanmian"]];
    }
    else if( index == 2 )
    {
         [_rightImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"HYfanmian"]];
    }
}

@end


@interface HYSafeNoCardView ()
{
    
    /**
     *  顶部View
     */
    UIView  *_topView;
    /**
     *  图片
     */
    UIImageView *_topImageView;
    /**
     *  name
     */
    UILabel *_topLabel;
    UILabel *_top1Label;
    
    UIView *_bottomView;
    /**
     *  姓名
     */
    HYLoginTextFieldView *_nameView;
    /**
     *  身份证
     */
    HYLoginTextFieldView *_cardView;
    /**
     *  身份正照片
     */
    HYSafeCardView      *_safeCardView;
}

@end

@implementation HYSafeNoCardView

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsNull(frame)||CGRectIsEmpty(frame))
        return;
    
    CGRect rect = CGRectMake(0, 0, frame.size.width, 154.0f);
    if ( _topView == nil )
    {
        _topView = NewObject(UIView);
        _topView.frame = rect;
        _topView.backgroundColor = [UIColor whiteColor];
        [self.pBaseView addSubview:_topView];
    }
    else
    {
        _topView.frame = rect;
    }
    
    
    rect.origin.y = 33.0f;
    rect.size.width = 42.0f;
    rect.size.height = rect.size.width;
    rect.origin.x = (Main_Screen_Width - rect.size.width)/2.0f;
    if ( _topImageView == nil )
    {
        _topImageView = NewObject(UIImageView);
        _topImageView.image = [UIImage imageNamed:(self.isReject?@"HYshenhezhong":@"HYshenheshibai")];
        _topImageView.contentMode = UIViewContentModeCenter;
        _topImageView.frame = rect;
        [self.pBaseView addSubview:_topImageView];
    }
    else
    {
        _topImageView.image = [UIImage imageNamed:(self.isReject?@"HYshenhezhong":@"HYshenheshibai")];
        _topImageView.frame = rect;
    }
    
    rect.origin.y += rect.size.height+10.0f;
    rect.size.height = 20.0f;
    rect.size.width = Main_Screen_Width;
    rect.origin.x = 0.0f;
    if ( _topLabel == nil )
    {
        _topLabel = NewObject(UILabel);
        _topLabel.frame = rect;
        _topLabel.backgroundColor = [UIColor clearColor];
        _topLabel.text = (self.isReject?@"实名资料审核中，如有疑问，请联系客服热线":@"您上次提交的资料未审核通过，");
        _topLabel.font = [UIFont systemFontOfSize:15.0f];
        _topLabel.textColor = (self.isReject?kHEXCOLOR(0x05be03):kHEXCOLOR(kRedColor));
        _topLabel.textAlignment = NSTextAlignmentCenter;
        [self.pBaseView addSubview:_topLabel];
        
    }else
    {
         _topLabel.text = (self.isReject?@"实名资料审核中，如有疑问，请联系客服热线":@"您上次提交的资料未审核通过，");
        _topLabel.textColor = (self.isReject?kHEXCOLOR(0x05be03):kHEXCOLOR(kRedColor));
        _topLabel.frame = rect;
    }
    
    rect.origin.y += rect.size.height;
    if ( _top1Label == nil )
    {
        _top1Label = NewObject(UILabel);
        _top1Label.frame = rect;
        _top1Label.backgroundColor = [UIColor clearColor];
        _top1Label.text = (self.isReject?@"400-757-1998":@"请重新提交！");
        _top1Label.font = [UIFont systemFontOfSize:15.0f];
        _top1Label.textColor = (self.isReject?kHEXCOLOR(0x05be03):kHEXCOLOR(kRedColor));
        _top1Label.textAlignment = NSTextAlignmentCenter;
        [self.pBaseView addSubview:_top1Label];
        
    }else
    {
        _top1Label.text = (self.isReject?@"400-757-1998":@"请重新提交！");
        _top1Label.textColor = (self.isReject?kHEXCOLOR(0x05be03):kHEXCOLOR(kRedColor));
        _top1Label.frame = rect;
    }

    
    rect.origin.y = _topView.frame.origin.y + _topView.frame.size.height + 10.0f;
    rect.size.height = 88.0f;
    if ( _bottomView == nil ) {
        _bottomView = NewObject(UIView);
        _bottomView.frame = rect;
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self.pBaseView addSubview:_bottomView];
    }else
    {
        _bottomView.frame = rect;
    }
    
    rect.origin.x = 10.0f;
    rect.size.height = 44.0f;
    rect.size.width = frame.size.width - 2*rect.origin.x;
    if ( _nameView == nil ) {
        _nameView = NewObject(HYLoginTextFieldView);
        _nameView.iconImageName = @"HYSafeyonghuming";
        _nameView.textIsEnabled = NO;
        _nameView.secureTextEntry = NO;
        _nameView.textName = self.name;
        _nameView.textFont = [UIFont systemFontOfSize:14.0f];
        _nameView.textColor = kHEXCOLOR(0x999999);
        _nameView.frame = rect;
        [self.pBaseView addSubview:_nameView];
    }else
    {
        _nameView.textName = self.name;
        _nameView.frame = rect;
    }
    
    rect.origin.y += rect.size.height;
    if ( _cardView == nil )
    {
        _cardView = NewObject(HYLoginTextFieldView);
        _cardView.iconImageName = @"HYSafeshenfenzheng";
        _cardView.textIsEnabled = NO;
        _cardView.secureTextEntry = NO;
        NSString *strPad = @"**************************************";
        _cardView.textName = [self.cardId stringByReplacingCharactersInRange:NSMakeRange(1, self.cardId.length-2) withString:[strPad substringWithRange:NSMakeRange(0,self.cardId.length-2)]];
        _cardView.textFont = [UIFont systemFontOfSize:14.0f];
        _cardView.textColor = kHEXCOLOR(0x999999);
        _cardView.bottomHide = YES;
        _cardView.frame = rect;
        [self.pBaseView addSubview:_cardView];
    }else
    {
        NSString *strPad = @"**************************************";
        _cardView.textName = [self.cardId stringByReplacingCharactersInRange:NSMakeRange(1, self.cardId.length-2) withString:[strPad substringWithRange:NSMakeRange(0,self.cardId.length-2)]];
        _cardView.frame = rect;
    }
    
    rect.origin.y = _bottomView.frame.origin.y + _bottomView.frame.size.height;
    rect.origin.x = 0;
    rect.size.width = frame.size.width;
    rect.size.height = 151.0f;
    if ( _safeCardView == nil )
    {
        _safeCardView = NewObject(HYSafeCardView);
        _safeCardView.isOnlyShow = YES;
        _safeCardView.frame = rect;
        [self.pBaseView addSubview:_safeCardView];
    }
    else
    {
        _safeCardView.frame = rect;
    }
    
    CGRect rectBaseView = _pBaseView.frame;
    rectBaseView.size.height = rect.origin.y + rect.size.height+100.0f;
    _pBaseView.frame = rectBaseView;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.contentSize = CGSizeMake(0,_pBaseView.frame.size.height);
}

-(void)onButtonClickRight
{
    
}
#pragma mark -更新数据
-(void)updateMessage:(HYSafeBandInfo *)safeInfo{
    if ( [safeInfo.authonStatus integerValue] == 0 ) {
        self.isReject = YES;
        self.name = safeInfo.bankRealname;
        self.cardId = safeInfo.bankPersonalId;
        _safeCardView.leftImageStr = safeInfo.pictureFront;
        _safeCardView.rightImageStr = safeInfo.pictureBack;
    }else if ( [safeInfo.authonStatus integerValue] == 2 ) {
        self.isReject = NO;
        self.name = safeInfo.bankRealname;
        self.cardId = safeInfo.bankPersonalId;
        _safeCardView.leftImageStr = safeInfo.pictureFront;
        _safeCardView.rightImageStr = safeInfo.pictureBack;
    }
    [self setFrame:self.frame];
}
@end
