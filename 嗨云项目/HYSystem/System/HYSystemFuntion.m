//
//  HYSystemFuntion.m
//  HaiYun
//
//  Created by YanLu on 16/3/30.
//  Copyright © 2016年 YanLu. All rights reserved.
//

#import "HYSystemFuntion.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSObject+Private.h"
#import "HYUpdateTipsView.h"

FOUNDATION_EXPORT NSString * NSArraytoNSString(NSArray * nsArray)
{
    if (nsArray == NULL || [nsArray count] < 1)
    {
        return @"";
    }
    NSMutableString * strArray = [NSMutableString stringWithString:[nsArray objectAtIndex:0]];
    for (int i = 1; i < [nsArray count]; i++)
    {
        [strArray appendString:[nsArray objectAtIndex:i]];
    }
    return strArray;
}


id AfxMessageBox(NSString* strMsg)
{
    return AfxMessageTitle(strMsg,nil);
}

id AfxMessageTitle(NSString* strMsg, NSString* strTitle)
{
    return AfxMessageBlock(strMsg,strTitle,nil,0,nil);
}

id AfxMessageBlock(NSString* strMsg,NSString* strTitle, NSArray* ayBtn, NSInteger nType,void (^block)(NSInteger))
{
    return AfxMessageBlockWithDelegate(strMsg, strTitle, ayBtn, nType, nil, block);
}

FOUNDATION_EXPORT id AfxMessageBlockWithDelegate(NSString* strMsg,NSString* strTitle, NSArray* ayBtn, NSInteger nType, id delegate, void (^block)(NSInteger))
{
    if (strMsg == NULL || [strMsg length] < 1)
        return nil;
    
    if (strTitle == nil || [strTitle length] < 1)
    {
        strTitle = [NSString stringWithFormat:@"%@", @"提示"];
    }
    NSString* nsOk = @"确定";
    NSString* nsCancel = nil;
    if(ayBtn)
    {
        if([ayBtn count] > 0)
        {
            nsOk = [ayBtn objectAtIndex:0];
        }
        if([ayBtn count] > 1)
        {
            nsCancel = [ayBtn objectAtIndex:1];
        }
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                    message:strMsg
                                                   delegate:delegate
                                          cancelButtonTitle:nsOk
                                          otherButtonTitles:nsCancel,nil];
    
    [alert showWithCompletionHandler:block];
    
    alert = nil;
    
    return nil;
}

FOUNDATION_EXPORT  NSData* DealImage(UIImage* photoImage, CGSize ImageSize, int nSize)
{
    CGSize imageSize = photoImage.size;
    CGSize newSize = ImageSize;
    float ratio = MIN(newSize.width/imageSize.width, newSize.height/imageSize.height);
    newSize.width = imageSize.width * ratio;
    newSize.height = imageSize.height * ratio;
    
    UIGraphicsBeginImageContext(newSize);
    [photoImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *small = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imagedata = UIImageJPEGRepresentation(small, 0.5);
    
    if (imagedata.length > nSize * 1024)
    {
        imageSize.height = ImageSize.height/3*2;
        imageSize.width = ImageSize.width/3*2;
        imagedata = DealImage(photoImage, imageSize, nSize);
    }
    return imagedata;
}

FOUNDATION_EXPORT int intervalSinceNow(NSDate *NDTime)
{
    NSTimeInterval late=[NDTime timeIntervalSince1970]*1;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    if (cha/3600>1&&cha/86400<1)//小时判断 cha/3600<1   分钟  //cha/86400>1
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        return [timeString intValue];
    }
    
    return 0;
}


FOUNDATION_EXPORT int GetSinceNow(NSDate *NDTime)
{
    NSTimeInterval late=[NDTime timeIntervalSince1970]*1;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    if (cha/3600 < 1)//小时判断 cha/3600<1   分钟  //cha/86400>1
    {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        return [timeString intValue];
    }
    
    return 0;
}

//获取设备的UUID
FOUNDATION_EXPORT NSString* GetUUID()
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}


FOUNDATION_EXPORT UIImage * UIImageScaleToSize(UIImage *image ,CGSize size)
{
    CGSize imageSize = image.size;
    CGSize newSize = size;
    float ratio = MIN(newSize.width/imageSize.width, newSize.height/imageSize.height);
    newSize.width = imageSize.width * ratio;
    newSize.height = imageSize.height * ratio;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(newSize);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0,0, newSize.width, newSize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

FOUNDATION_EXPORT id GetObjectforNSUserDefaultsByKey(NSString *strKey)
{
    if(ISNSStringValid(strKey) )
    {
        return  [[NSUserDefaults standardUserDefaults] objectForKey:strKey];
    }
    return  nil;
}

FOUNDATION_EXPORT void SetObjectforNSUserDefaultsByKey(id value,NSString *strKey)
{
    if (ISNSStringValid(strKey))
    {
        [[NSUserDefaults standardUserDefaults]  setObject:value forKey:strKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

FOUNDATION_EXPORT NSString * StringMD5(NSString * nsstring)
{
    const char *cStr = [nsstring UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

FOUNDATION_EXPORT BOOL HYJudgeMobile(NSString * strMobile)
{
    NSString *phoneRegex = @"^[1][0-9]{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:strMobile];
}

FOUNDATION_EXPORT BOOL HYJudgeCard(NSString * strCard)
{
    NSString *cardRegex = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|[x,X])$)";
    NSPredicate *cardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cardRegex];
    return [cardTest evaluateWithObject:strCard];
}

//身份证日期信息错误
FOUNDATION_EXPORT BOOL HYJudgeYearMonthDay(NSString * strID)
{
    NSString *cardRegex = @"^((\\d{2}(([02468][048])|([13579][26]))[\\-\\/\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])))))|(\\d{2}(([02468][1235679])|([13579][01345789]))[\\-\\/\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/\\s]?((0?[1-9])|(1[0-9])|(2[0-8]))))))(\\s(((0?[0-9])|([1-2][0-3]))\\:([0-5]?[0-9])((\\s)|(\\:([0-5]?[0-9])))))?$";
    NSPredicate *cardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cardRegex];
    return [cardTest evaluateWithObject:strID];
}

//判断纯数字
FOUNDATION_EXPORT BOOL HYJudgeIsNumeric(NSString * strNum)
{
    NSString *cardRegex = @"^[0-9]*$";
    NSPredicate *cardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cardRegex];
    return [cardTest evaluateWithObject:strNum];
}

//判多少位汉子
FOUNDATION_EXPORT BOOL HYJudgeChineseCharacter(NSString * strNum, NSInteger min, NSInteger max)
{
    NSString *cardRegex = [NSString stringWithFormat:@"^[\u4e00-\u9fa5]{%ld,%ld}$",min,max];
    NSPredicate *cardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cardRegex];
    return [cardTest evaluateWithObject:strNum];
}

FOUNDATION_EXPORT BOOL HYJudgeIdCardCheckUtil(NSString * IDCardStr)
{
    // =================身份证号不能为空=================
    if ( !ISNSStringValid(IDCardStr) )
    {
        return false;//身份证号不能为空
    }
    // ================ 号码的长度 15位或18位的数字或者末尾为x，X================
    if ( !HYJudgeCard(IDCardStr) )
    {
        return false;
    }
    //将身份证号转成小写
    IDCardStr = [IDCardStr lowercaseString];
    // ================ 数字 除最后以为都为数字 ================
    NSString *Ai = @"";
    if (IDCardStr.length == 18) {
        Ai = [IDCardStr substringWithRange:NSMakeRange(0, 17)];
    } else if (IDCardStr.length == 15) {
        Ai = [NSString stringWithFormat:@"%@19%@",[IDCardStr substringWithRange:NSMakeRange(0, 6)],[IDCardStr substringWithRange:NSMakeRange(6, 9)]];
    }
    if ( !HYJudgeIsNumeric(Ai) )
    {
        return false;
    }
    NSDictionary *zoneNumDic = @{@"11":@"北京",
                                 @"12":@"天津",
                                 @"13":@"河北",
                                 @"14":@"山西",
                                 @"15":@"内蒙古",
                                 @"21":@"辽宁",
                                 @"22":@"吉林",
                                 @"23":@"黑龙江",
                                 @"31":@"上海",
                                 @"32":@"江苏",
                                 @"33":@"浙江",
                                 @"34":@"安徽",
                                 @"35":@"福建",
                                 @"36":@"江西",
                                 @"37":@"山东",
                                 @"41":@"河南",
                                 @"42":@"湖北",
                                 @"43":@"湖南",
                                 @"44":@"广东",
                                 @"45":@"广西",
                                 @"46":@"海南",
                                 @"50":@"重庆",
                                 @"51":@"四川",
                                 @"52":@"贵州",
                                 @"53":@"云南",
                                 @"54":@"西藏",
                                 @"61":@"陕西",
                                 @"62":@"甘肃",
                                 @"63":@"青海",
                                 @"64":@"宁夏",
                                 @"65":@"新疆",
                                 @"71":@"台湾",
                                 @"81":@"香港",
                                 @"82":@"澳门",
                                 @"91":@"外国"
                                 };
    NSArray *ValCodeArr = @[@"1", @"0", @"x", @"9", @"8", @"7", @"6", @"5", @"4",
                            @"3", @"2"];
    NSArray *Wi = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7",@"9", @"10", @"5", @"8", @"4", @"2"];
    
    // ================ 出生年月是否有效 ================
    NSString *strYear = [Ai substringWithRange:NSMakeRange(6, 4)];// 年份
    NSString *strMonth = [Ai  substringWithRange:NSMakeRange(10, 2)];// 月份
    NSString *strDay = [Ai  substringWithRange:NSMakeRange(12, 2)];// 月份
    NSString *str1 = [NSString stringWithFormat:@"%@-%@-%@",strYear,strMonth,strDay];
    if ( !HYJudgeYearMonthDay(str1) )
    {
        return false;//身份证日期信息错误
    }
    NSString *birthStr = [NSString stringWithFormat:@"%@ 00:00:00",str1];
    NSDate *birthDay = HYNSStringChangeToDate(birthStr);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:HYDateChangeToDate([NSDate date])];
    NSInteger year = [dateComponent year];
    if ( [strYear integerValue] - year > 150 || [HYDateChangeToDate([NSDate date]) timeIntervalSinceDate:birthDay] < 0  )
    {
        return false;//身份证日期信息错误
    }
    if ([strMonth integerValue] > 12 || [strMonth integerValue] <= 0) {
        return false;//身份证日期信息错误
    }
    if ( [strDay integerValue] > 31 || [strDay integerValue] <= 0) {
        return false;//身份证日期信息错误
    }
    // =====================(end)=====================
    
    // ================ 地区码时候有效 ================
    NSString *zoneNum = [Ai substringWithRange:NSMakeRange(0, 2)];
    if ( !ISNSStringValid( [zoneNumDic HYValueForKey:zoneNum]) )
    {
        return false;//身份证地区码有误
    }
    // ==============================================
    
    
    // ================ 判断最后一位的值 ================
    int TotalmulAiWi = 0;
    for (int i = 0; i < 17; i++) {
        TotalmulAiWi += [[Ai substringWithRange:NSMakeRange(i, 1)] intValue]
        * [Wi[i] intValue];
    }
    int modValue = TotalmulAiWi % 11;
    NSString *strVerifyCode = ValCodeArr[modValue];
    Ai = [NSString stringWithFormat:@"%@%@",Ai,strVerifyCode];
    
    if ( IDCardStr.length == 18)
    {
        if ( [Ai isEqualToString:IDCardStr] == false) {
            return false;//身份证号码无效
        }else
        {
            return true;
        }
    }else
    {
        return true;
    }
    // =====================(end)=====================
    
    return true;
}

FOUNDATION_EXPORT BOOL HYJudgeEmail(NSString * strEmail)
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:strEmail];
}


FOUNDATION_EXPORT BOOL HYJudgeBandCard(NSString * strBandCard)
{
    NSString *cardRegex = @"^[0-9]{16,23}$";
    NSPredicate *cardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cardRegex];
    return [cardTest evaluateWithObject:strBandCard];
}

FOUNDATION_EXPORT BOOL HYJudgePassword(NSString * strPassword)
{
    NSString *phoneRegex = @"^[a-zA-Z0-9]{6,15}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:strPassword];
}


FOUNDATION_EXPORT CGFloat GetHeightOfString(NSString * string,float width,UIFont* font)
{
    return [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size.height;
}

FOUNDATION_EXPORT CGFloat GetWidthOfString(NSString * string,float height,UIFont* font)
{
    return [string boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size.width;
}

FOUNDATION_EXPORT NSInteger StringToBinary2Dec (NSString * string )
{
    NSInteger sum = 0;
    for ( int i=0; i<string.length; ++i )
    {
        sum = sum*2 +[[string substringWithRange:NSMakeRange(i, 1)] intValue];
    }
    return sum;
}

//字符串时间转换 (时区)
FOUNDATION_EXPORT NSDate *HYNSStringChangeToDate(NSString * strDate)
{
    if (!ISNSStringValid(strDate))
        return nil;
    
    NSDateFormatter *outputFormat = NewObject(NSDateFormatter);;
    [outputFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [outputFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate  *date = [outputFormat dateFromString:strDate];
    return HYDateChangeToDate(date);
}
//时间+时区
FOUNDATION_EXPORT NSDate *HYDateChangeToDate(NSDate * date)
{
    if (!date)
        return nil;
  
    return [date dateByAddingTimeInterval: [[NSTimeZone systemTimeZone] secondsFromGMTForDate:date]];
}

FOUNDATION_EXPORT NSString *HYNowTimeChangeToDate(NSTimeInterval  timeInterval)
{
    NSDateFormatter *outputFormat = NewObject(NSDateFormatter);;
    [outputFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [outputFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
   
    return [outputFormat stringFromDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval]];
}

FOUNDATION_EXPORT NSAttributedString *attributedText(NSArray *stringArray, NSArray *attributeAttay)
{
    NSString * string = [stringArray componentsJoinedByString:@""];
    
    // 通过要显示的文字内容来创建一个带属性样式的字符串对象
    NSMutableAttributedString * result = [[NSMutableAttributedString alloc] initWithString:string];
    for(NSInteger i = 0; i < stringArray.count; i++)
    {
        // 将某一范围内的字符串设置样式
        [result setAttributes:attributeAttay[i] range:[string rangeOfString:stringArray[i]]];
    }
    // 返回已经设置好了的带有样式的文字
    return [[NSAttributedString alloc] initWithAttributedString:result];
}

FOUNDATION_EXPORT void HYUpdateShowTips(NSString * strTips,NSString * strTitle,NSString * strLeft,NSString * strRight,void (^selectBlock)(NSInteger tipsIndex))
{
    if (ISNSStringValid(strTips))
    {
        HYUpdateTipsView * tipsView = NewObject(HYUpdateTipsView);
        tipsView.nsTips = strTips;
        
        if (!ISNSStringValid(strTitle))
        {
            tipsView.nsTitle = @"提示";
        }else
        {
            tipsView.nsTitle = strTitle;
        }
        
        if (!ISNSStringValid(strLeft))
        {
            tipsView.nsleft = @"取消";
        }else
        {
            tipsView.nsleft = strLeft;
        }
        
        if (!ISNSStringValid(strRight))
        {
            tipsView.nsright = @"确定";
        }else
        {
            tipsView.nsright = strRight;
        }
        tipsView.tipsselect = ^(NSInteger tipsIndex)
        {
            selectBlock(tipsIndex);
        };
        tipsView.frame = [[UIScreen mainScreen] bounds];
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:tipsView];

//        [UIAppWindow addSubview:tipsView];
    }
}
