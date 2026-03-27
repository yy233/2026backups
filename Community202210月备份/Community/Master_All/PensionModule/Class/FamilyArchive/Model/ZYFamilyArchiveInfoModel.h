//
//  ZYFamilyArchiveInfoModel.h
//  Community
//
//  Created by ZY on 2021/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYFamilyArchiveInfoModel : NSObject

// 类型 TF、select、image
@property (nonatomic, copy) NSString *type;

// 标题
@property (nonatomic, copy) NSString *title;

// 内容
@property (nonatomic, copy) NSString *content;

@end

NS_ASSUME_NONNULL_END
