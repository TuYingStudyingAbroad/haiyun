//
//  HYSystemFuntion.h
//  HaiYun
//
//  Created by YanLu on 16/3/30.
//  Copyright © 2016年 YanLu. All rights reserved.
//

// 字符数组转字符串

FOUNDATION_EXPORT NSString * NSArraytoNSString(NSArray * nsArray);
// 提示框
FOUNDATION_EXPORT id AfxMessageBox(NSString* strMsg);
FOUNDATION_EXPORT id AfxMessageTitle(NSString* strMsg,NSString* strTitle);
FOUNDATION_EXPORT id AfxMessageBlock(NSString* strMsg,NSString* strTitle, NSArray* ayBtn, NSInteger nType,void (^block)(NSInteger));
FOUNDATION_EXPORT id AfxMessageBlockWithDelegate(NSString* strMsg,NSString* strTitle, NSArray* ayBtn, NSInteger nType, id delegate, void (^block)(NSInteger));




//图片压缩处理
FOUNDATION_EXPORT  NSData* DealImage(UIImage* photoImage, CGSize ImageSize, int nSize);

//long类型时间转换成字符串
FOUNDATION_EXPORT NSString *LongTimeToString(NSString* nsValue,NSString* strFormat);
//打印json数据
FOUNDATION_EXPORT void printInfo(NSMutableDictionary* pDict);

//时间计算
FOUNDATION_EXPORT int intervalSinceNow(NSDate *NDTime);
FOUNDATION_EXPORT int GetSinceNow(NSDate *NDTime);



//获取设备的UUID
FOUNDATION_EXPORT NSString* GetUUID();

FOUNDATION_EXPORT UIImage * UIImageScaleToSize(UIImage *image ,CGSize size);


//轻量级本地存储 获取的Value 只能读取不能写入当作更改，若要更改存储 必须用 SetObjectforNSUserDefaultsByKey 函数来存住
FOUNDATION_EXPORT id GetObjectforNSUserDefaultsByKey(NSString *strKey);

FOUNDATION_EXPORT void SetObjectforNSUserDefaultsByKey(id value,NSString *strKey);

FOUNDATION_EXPORT NSString * StringMD5(NSString * nsstring);

//手机号码正则验证
FOUNDATION_EXPORT BOOL HYJudgeMobile(NSString * strMobile);
//密码判断
FOUNDATION_EXPORT BOOL HYJudgePassword(NSString * strPassword);
//身份证正则验证
FOUNDATION_EXPORT BOOL HYJudgeCard(NSString * strCard);
//判多少位汉子
FOUNDATION_EXPORT BOOL HYJudgeChineseCharacter(NSString * strNum, NSInteger min, NSInteger max);
//身份证
FOUNDATION_EXPORT BOOL HYJudgeIdCardCheckUtil(NSString * IDCardStr);
//判断银行卡
FOUNDATION_EXPORT BOOL HYJudgeBandCard(NSString * strBandCard);
//邮箱正则验证
FOUNDATION_EXPORT BOOL HYJudgeEmail(NSString * strEmail);

//计算文字高度，宽度
FOUNDATION_EXPORT CGFloat GetHeightOfString(NSString * string,float width,UIFont* font);
FOUNDATION_EXPORT CGFloat GetWidthOfString(NSString * string,float width,UIFont* font);

//二进制转换成十进制
FOUNDATION_EXPORT NSInteger StringToBinary2Dec (NSString * string );

//字符串时间转换 (时区)
FOUNDATION_EXPORT NSDate *HYNSStringChangeToDate(NSString * strDate);
//时间+时区
FOUNDATION_EXPORT NSDate *HYDateChangeToDate(NSDate * date);
//现在时间＋多少s
FOUNDATION_EXPORT NSString *HYNowTimeChangeToDate(NSTimeInterval  timeInterval);

FOUNDATION_EXPORT NSAttributedString *attributedText(NSArray *stringArray, NSArray *attributeAttay);

FOUNDATION_EXPORT void HYUpdateShowTips(NSString * strTips,NSString * strTitle,NSString * strLeft,NSString * strRight,void (^selectBlock)(NSInteger tipsIndex));
