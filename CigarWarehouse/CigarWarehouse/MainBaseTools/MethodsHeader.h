//
//  MethodsHeader.h
//  Community
//
//  Created by 余莹 on 2020/11/12.
//

#ifndef MethodsHeader_h
#define MethodsHeader_h

///单例宏-->方便.h文件使用
#define singleton_interface(name) +(instancetype)name;//.h文件替换

#if __has_feature(objc_arc)

///单例宏-->方便.m文件使用
#define singleton_implementation(name) \
static id _instance = nil; \
\
+ (instancetype)name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
if (_instance == nil) \
{ \
_instance = [[self alloc] init]; \
} \
}); \
return _instance; \
} \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
if (_instance == nil) \
{ \
_instance = [super allocWithZone:zone]; \
} \
}); \
return _instance; \
} \
\
- (id)copyWithZone:(struct _NSZone *)zone \
{ \
return _instance; \
} \
\
- (id)mutableCopyWithZone:(struct _NSZone *)zone \
{ \
return _instance; \
}

#else
#define singleton_implementation(name) \
static id _instance = nil; \
\
+ (instancetype)name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [[self alloc] init]; \
}); \
return _instace; \
} \
\
+(instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
\
-(id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
} \
\
-(id)mutableCopyWithZone:(NSZone *)zone \
{ \
return _instance; \
} \
\
- (oneway void)release { } \
- (id)retain { return self; } \
- (NSUInteger)retainCount { return 1;} \
- (id)autorelease { return self;}

#endif
#endif /* MethodsHeader_h */
