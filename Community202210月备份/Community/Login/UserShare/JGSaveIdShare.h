//
//  JGSaveIdShare.h
//  Community
//
//  Created by 余莹 on 2021/9/15.
//保存极光的id做后续接口数据时使用

#import <Foundation/Foundation.h>
#import "MethodsHeader.h"
NS_ASSUME_NONNULL_BEGIN

@interface JGSaveIdShare : NSObject

singleton_interface(sharedUserInfo)

@property (nonatomic,strong) NSString *registrationID;//registrationID获取
@end

NS_ASSUME_NONNULL_END
