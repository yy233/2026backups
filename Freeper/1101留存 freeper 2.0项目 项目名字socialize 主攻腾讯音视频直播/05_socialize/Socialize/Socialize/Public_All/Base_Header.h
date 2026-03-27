//
//  Base_Header.h
//  Socialize
//
//  Created by 余莹 on 2023/5/10.
//

#ifndef Base_Header_h
#define Base_Header_h




//_________________________________________ 基础宏


#define Y_PAGE_SIZE 20
#define Y_PAGE_SIZE_10 (10)
#define Y_PAGE_SIZE_5  (5)
#define Y_PAGE_SIZE_3  (3)

typedef enum : NSUInteger {
    Photo_Choose_Type_Grapht,
    Photo_Choose_Type_Album
} Photo_Choose_Type;





#pragma mark ==notice
#define Y_NSNotificationCenter_Creat_NameAction(_noticeName,_noticeActionName)    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_noticeActionName) name:_noticeName object:nil];

#define Y_NSNotificationCenter_PostNotice_NilObject_Name(_noticeName) [[NSNotificationCenter defaultCenter]postNotificationName:_noticeName object:nil];

#define Y_NSNotificationCenter_PostNotice_HaveObject_Name(_noticeName,_Obj) [[NSNotificationCenter defaultCenter]postNotificationName:_noticeName object:_Obj];
#define Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(_noticeName,_userInfo) [[NSNotificationCenter defaultCenter]postNotificationName:_noticeName object:nil userInfo:_userInfo];

#define Y_NSNotificationCenter_RemoveNotice_Name(_noticeName)     [[NSNotificationCenter defaultCenter] removeObserver:self name:_noticeName object:nil];

#pragma mark ==weak
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


#endif /* Base_Header_h */
