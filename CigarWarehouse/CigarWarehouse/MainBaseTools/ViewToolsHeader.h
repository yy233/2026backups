//
//  ViewToolsHeader.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/15.
//

#ifndef ViewToolsHeader_h
#define ViewToolsHeader_h


#pragma mark ==notice
#define Y_NSNotificationCenter_Creat_NameAction(_noticeName,_noticeActionName)    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_noticeActionName) name:_noticeName object:nil];

#define Y_NSNotificationCenter_PostNotice_NilObject_Name(_noticeName) [[NSNotificationCenter defaultCenter]postNotificationName:_noticeName object:nil];

#define Y_NSNotificationCenter_PostNotice_HaveObject_Name(_noticeName,_Obj) [[NSNotificationCenter defaultCenter]postNotificationName:_noticeName object:_Obj];
#define Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(_noticeName,_userInfo) [[NSNotificationCenter defaultCenter]postNotificationName:_noticeName object:nil userInfo:_userInfo];
#define Y_NSNotificationCenter_PostNotice_HaveObjInfoAndUserInfo_Name(_noticeName,_Obj,_userInfo) [[NSNotificationCenter defaultCenter]postNotificationName:_noticeName object:_Obj userInfo:_userInfo];

#define Y_NSNotificationCenter_RemoveNotice_Name(_noticeName)     [[NSNotificationCenter defaultCenter] removeObserver:self name:_noticeName object:nil];
#pragma mark ===== _SVProgressHUD__相关
#define Y_SVP_SHOW_SUCCESS_MESSAGE           [SVProgressHUD showSuccessWithStatus:Y_ResponsObject_messageStr]; [SVProgressHUD dismissWithDelay:2.0];
#define Y_SVP_SHOW_err_DESCRIPTION           [SVProgressHUD showErrorWithStatus:err.description];  [SVProgressHUD dismissWithDelay:2.0];
#define Y_SVP_SHOW_err_domain                [SVProgressHUD showErrorWithStatus:err.domain];  [SVProgressHUD dismissWithDelay:2.0];


#define Y_SVP_SHOW_error_DESCRIPTION           [SVProgressHUD showErrorWithStatus:error.description];  [SVProgressHUD dismissWithDelay:2.0];
#define Y_SVP_SHOW_ERR_MESSAGE               [SVProgressHUD showErrorWithStatus:Y_ResponsObject_messageStr];[SVProgressHUD dismissWithDelay:2.0];
#define Y_SVP_SHOW_ERR_MES(_msg)             [SVProgressHUD showErrorWithStatus:_msg]; [SVProgressHUD dismissWithDelay:2.0];
#define Y_SVP_SHOW_SUCCESS_MES(_msg)         [SVProgressHUD showSuccessWithStatus:_msg]; [SVProgressHUD dismissWithDelay:2.0];
#define Y_SVP_SHOW_SUCCESS_MES_5Delay(_msg)         [SVProgressHUD showSuccessWithStatus:_msg]; [SVProgressHUD dismissWithDelay:5.0];
#define Y_SVP_SHOW_SUCCESS_MES_10Delay(_msg)         [SVProgressHUD showSuccessWithStatus:_msg]; [SVProgressHUD dismissWithDelay:10.0];
#define Y_SVP_SHOW_SUCCESS_MES_15Delay(_msg)         [SVProgressHUD showSuccessWithStatus:_msg]; [SVProgressHUD dismissWithDelay:15.0];
#define Y_SVP_SHOW_MES(_msg)                 [SVProgressHUD showWithStatus:_msg];[SVProgressHUD dismissWithDelay:2.0];
#define Y_SVP_DISMISS                        [SVProgressHUD dismiss];
#define Y_SVP_DISMISS_DELAY_TWO              [SVProgressHUD dismissWithDelay:2.0];
#define Y_SVP_SHOW_MES_5Delay(_msg)          [SVProgressHUD showWithStatus:_msg];[SVProgressHUD dismissWithDelay:5.0];
#define Y_SVP_SHOW_MES_10Delay(_msg)          [SVProgressHUD showWithStatus:_msg];[SVProgressHUD dismissWithDelay:10.0];

#define Y_SVP_SHOW_MES_5Delay_Loading        [SVProgressHUD showWithStatus:@"加载中"];[SVProgressHUD dismissWithDelay:5.0];
#define Y_SVP_SHOW_MES_Loading               [SVProgressHUD showWithStatus:@"处理中"];
#define Y_SVP_SHOW_MES_IsDealing             [SVProgressHUD showWithStatus:@"正在处理"];
#define Y_SVP_SHOW_MES_IsDealing_15Delay     [SVProgressHUD showWithStatus:@"正在处理"];[SVProgressHUD dismissWithDelay:15.0];
#define Y_SVP_SHOW_MES_IsLoading_15Delay     [SVProgressHUD showWithStatus:@"正在加载"];[SVProgressHUD dismissWithDelay:15.0];
#define Y_SVP_SHOW_INFO_MES(_msg)            [SVProgressHUD showInfoWithStatus:_msg]; [SVProgressHUD dismissWithDelay:2.0];
#define Y_SVP_SHOW_INFO_MES_5Delay(_msg)     [SVProgressHUD showInfoWithStatus:_msg]; [SVProgressHUD dismissWithDelay:5.0];

#define Y_SVP_SHOW_MES_IsDling_15Delay(_msg) [SVProgressHUD showWithStatus:_msg];[SVProgressHUD dismissWithDelay:15.0];

#pragma mark =====  Y_ResponsObject_相关__
#import "TextShowWithModelStr.h"
#define  Y_IS_Success_status                            (([[responsObject objectForKey:@"status"] intValue]== 0  ||  [[responsObject objectForKey:@"status"] intValue]== 200  ) && ( [[responsObject objectForKey:@"code"] intValue] != 232))
#define  Y_IS_Success_code                                ( [[responsObject objectForKey:@"code"] intValue]== 0  ||  [[responsObject objectForKey:@"code"] intValue]== 200 )
#define  Y_Success_Or_ErrCode                            [[responsObject objectForKey:@"code"] intValue]
#define  Y_Success_Or_ErrCodeKeyIntV                     [[responsObject objectForKey:@"err_code"] intValue]
#define  Y_status_IS_Success                            ( [[responsObject objectForKey:@"status"] intValue]== 0  ||  [[responsObject objectForKey:@"status"] intValue]== 200 )
#define  Y_EC_IS_Success                                (( [[responsObject objectForKey:@"ec"] intValue]== 0  ||  [[responsObject objectForKey:@"ec"] intValue]== 200 ) && ( [[responsObject objectForKey:@"code"] intValue] != 232))


#define  Y_ResponsObject_codeStr                         [[responsObject allKeys] containsObject:@"code"] ? [NSString stringWithFormat:@"%@",[responsObject objectForKey:@"code"]] : @"1000"
#define  Y_ResponsObject_dataDic                         ( [[responsObject allKeys] containsObject:@"data"] && isNotNil([responsObject objectForKey:@"data"]) ) ? [responsObject objectForKey:@"data"] : [NSDictionary dictionary]

#define  Y_ResponsObject_dataArr                         ( [[responsObject allKeys] containsObject:@"data"] && isNotNil([responsObject objectForKey:@"data"]) ) ? [responsObject objectForKey:@"data"] : [NSMutableArray array]


#define  Y_ResponsObject_dataStr                         [[responsObject allKeys] containsObject:@"data"] ? [TextShowWithModelStr textShowWithNotNullStr:[NSString stringWithFormat:@"%@",[responsObject objectForKey:@"data"]] ] : @""
#define  Y_ResponsObject_messageStr                      [[responsObject allKeys] containsObject:@"message"] ? [TextShowWithModelStr textShowWithNotNullStr:[NSString stringWithFormat:@"%@",[responsObject objectForKey:@"message"]] ] : @"暂无具体信息"
#define  Y_ResponsObject_msgStr                          [[responsObject allKeys] containsObject:@"msg"] ? [TextShowWithModelStr textShowWithNotNullStr:[NSString stringWithFormat:@"%@",[responsObject objectForKey:@"msg"]] ] : @"暂无具体信息"

#define  Y_ResponsObject_EMstr                          [[responsObject allKeys] containsObject:@"em"] ? [TextShowWithModelStr textShowWithNotNullStr:[NSString stringWithFormat:@"%@",[responsObject objectForKey:@"em"]] ] : @"暂无具体信息"


#define  Y_ResponsObject_rowsArr [[rows allKeys] containsObject:@"rows"]?[rows objectForKey:@"rows"]:[NSMutableArray array]


#define  Y_ResponsObject_ObjectDic                         ( [[responsObject allKeys] containsObject:@"object"] && isNotNil([responsObject objectForKey:@"object"]) ) ? [responsObject objectForKey:@"object"] : [NSDictionary dictionary]

#define  Y_ResponsObject_ObjecStr                         ( [[responsObject allKeys] containsObject:@"object"] && isNotNil([responsObject objectForKey:@"object"]) ) ? [responsObject objectForKey:@"object"] : [NSMutableArray array]

#define  Y_ResponsObject_emStr                         [[responsObject allKeys] containsObject:@"em"] ? [TextShowWithModelStr textShowWithNotNullStr:[NSString stringWithFormat:@"%@",[responsObject objectForKey:@"em"]] ] : @""

#define  Y_ResponsObject_messageStr                      [[responsObject allKeys] containsObject:@"message"] ? [TextShowWithModelStr textShowWithNotNullStr:[NSString stringWithFormat:@"%@",[responsObject objectForKey:@"message"]] ] : @"暂无具体信息"


#pragma mark ===== 颜色
#import "UIColor+ZYHexString.h"

// RGB颜色
// 十六进制颜色
#define Y_ColorWith16FromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define Y_RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define Y_RGB(r,g,b)  Y_RGBA(r,g,b,1.0f)
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#pragma mark === 渐变 color

#define Y_Gradient_Color(width,height,_BeginColor,_EndColor) [UIColor bm_colorGradientChangeWithSize:CGSizeMake(width, height) direction:IHGradientChangeDirectionLevel startColor:_BeginColor endColor:_EndColor]
 
#pragma mark === 随机色
#define Y_randomColor   [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:0.5]



#pragma mark =====  字体
#define  FontSize_Bold(_num)       [UIFont boldSystemFontOfSize:_num]
#define  FontSize_Nomail(_num)     [UIFont systemFontOfSize:_num]
 
 
#pragma mark ==数量 基础宏


#define Y_PAGE_SIZE 20
#define Y_PAGE_SIZE_10 (10)
#define Y_PAGE_SIZE_5  (5)
#define Y_PAGE_SIZE_3  (3)


#define Y_Cell_Height_44 (44.0)
#define Y_Cell_Height_50 (50.0)
#define Y_Cell_Height_60 (60.0)
#define Y_Cell_Height_65 (65.0)
#define Y_Cell_Height_70 (70.0)
#define Y_Cell_Height_80 (80.0)
#define Y_Cell_Height_90 (90.0)
#define Y_Cell_Height_100 (100.0)

#define Y_Height_10 (10.0)
#define Y_Height_20 (20.0)
#define Y_Height_30 (30.0)
#define Y_Height_40 (40.0)
#define Y_Height_44 (44.0)
#define Y_Height_50 (50.0)
#define Y_Height_55 (55.0)
#define Y_Height_60 (60.0)
#define Y_Height_65 (65.0)
#define Y_Height_70 (70.0)
#define Y_Height_75 (75.0)
#define Y_Height_80 (80.0)
#define Y_Height_85 (85.0)
#define Y_Height_90 (90.0)
#define Y_Height_100 (100.0)
#define Y_Height_110 (110.0)
#define Y_Height_120 (120.0)
#define Y_Height_130 (130.0)
#define Y_Height_140 (140.0)
#define Y_Height_150 (150.0)
#define Y_Height_160 (160.0)
#define Y_Height_170 (170.0)
#define Y_Height_180 (180.0)
#define Y_Height_190 (190.0)
#define Y_Height_200 (200.0)

#pragma mark == weak
#define WEAKSELF     __weak typeof(self)      weakSelf = self;
#define STRONGSELF   __strong typeof(self)    strongSelf = weakSelf;


#pragma mark - # 循环引用消除
#define WeakSelf(type) autoreleasepool{} __weak __typeof__(type) weakSelf = type

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object)     autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object)     autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object)     try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object)     try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object)   autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object)   autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object)   try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object)   try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#pragma mark == log
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#define DeBugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d  \t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
// 带方法名
#define NSLog(FORMAT, ...) {\
NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];\
[dateFormatter setDateStyle:NSDateFormatterMediumStyle];\
[dateFormatter setTimeStyle:NSDateFormatterShortStyle];\
[dateFormatter setDateFormat:@"HH:mm:ss:SSSSSS"]; \
NSString *str = [dateFormatter stringFromDate:[NSDate date]];\
fprintf(stderr," %s %s %d %s~ 打印 = %s\n",[str UTF8String],[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__,__func__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);\
}
#define debugMethod() NSLog(@"%s", __func__)
#define MyNSLog(FORMAT, ...) fprintf(stderr,"[%s]:[line %d行] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define DLog(...)
#define DeBugLog(...)
#define NSLog(...)
#define debugMethod()
#define MyNSLog(FORMAT, ...) nil
#endif

#define WeakObj(o) __weak typeof(o) o##Weak = o;
#define WeakObject(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#define StrongObject(o) autoreleasepool{} __strong typeof(o) o = o##Weak;


#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type)  __strong typeof(type) type = weak##type;



#pragma mark =====  其他
/** 屏幕宽高*/
#define Screen_W             [UIScreen mainScreen].bounds.size.width
#define Screen_H             [UIScreen mainScreen].bounds.size.height
/////////////////////////////////////////////////////////////////////////////////
#define Screen_Width        [UIScreen mainScreen].bounds.size.width
#define Screen_Height       [UIScreen mainScreen].bounds.size.height
//#define Is_Iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//#define Is_IPhoneX (Screen_Width >=375.0f && Screen_Height >=812.0f && Is_Iphone)
#define Is_IPhoneXX (Screen_Width >=375.0f && Screen_Height >=812.0f)
/////////////////////////////////////////////////////////////////////////////////
//#define KNavBarHeight        (isIPhoneXSeries ? (88.0):(64.0))          /** 导航栏高度 */
//#define kStatusBar_Height    (isIPhoneXSeries ? (44.0):(20.0))          /** 状态栏高度 */
//#define kTabBar_Height       (isIPhoneXSeries ? (49.0 + 34.0):(49.0))   /** 标签栏高度 */
//#define kBottom_SafeHeight   (isIPhoneXSeries ? (34.0):(0))             /** 底部横条高度 */
#define KNavBarHeight        (Is_IPhoneXX ? (88.0):(64.0))          /** 导航栏高度 */
#define kStatusBar_Height    (Is_IPhoneXX ? (44.0):(20.0))          /** 状态栏高度 */
#define kTabBar_Height       (Is_IPhoneXX ? (49.0 + 34.0):(49.0))   /** 标签栏高度 */
#define kBottom_SafeHeight   (Is_IPhoneXX ? (34.0):(0))             /** 底部横条高度 */
#define kRGBA(r, g, b, a)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define kRGB(r, g, b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.f]
#define kkScale390(x) (x * (UIScreen.mainScreen.bounds.size.width / 390.0))

/////////////////////////////////////////////////////////////////////////////////
 

#endif /* ViewToolsHeader_h */
