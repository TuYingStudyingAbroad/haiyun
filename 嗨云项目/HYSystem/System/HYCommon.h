

// App Frame Height&Width
#define App_Frame_Height        [[UIScreen mainScreen] applicationFrame].size.height
#define App_Frame_Width         [[UIScreen mainScreen] applicationFrame].size.width

// MainScreen Height&Width
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width



#define IosAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define NewObject(x) [[x alloc]init];//NEW 对象

#define ISNSStringValid(x) (x != NULL && [x length] > 0) //字符串空判断

// 系统IOS 几的判断
#define IS_IOS(x) ([[UIDevice currentDevice].systemVersion intValue] >= x)
//iOS5 的判断
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_Iphone4 (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_Iphone5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_Iphone6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_Iphone6Plus (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IS_Ipad (IS_IPAD)

//#define IS_Iphone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//
//#define IS_Iphone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//
//#define IS_Iphone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080, 1920), [[UIScreen mainScreen] currentMode].size) : NO)

//关闭所有键盘
#define CloseKeyBord(bClose)  [[[UIApplication sharedApplication] keyWindow] endEditing:bClose]
#define UIAppWindow [[UIApplication sharedApplication] keyWindow] 
#define UIAppWindowTopView [UIApplication sharedApplication].delegate.window.rootViewController.view
// 获得RGB颜色
/**
 *  十六进制颜色
 */
#define kHEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define kColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

// 全局背景色
#define kGlobalBg kColor(248, 248, 248)
// 全局前景色
#define kGlobalFg kColor(255, 0, 0)

#define kSectionHeadTitleColor 0x6b6e73

#define kRedColor 0xff3333










