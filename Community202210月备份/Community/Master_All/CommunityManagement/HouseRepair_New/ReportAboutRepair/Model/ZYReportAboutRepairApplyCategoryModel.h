//
//  ZYReportAboutRepairApplyCategoryModel.h
//  Community
//
//  Created by ZY on 2022/3/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYReportAboutRepairApplyCategoryModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *idStr;

@property (nonatomic, copy) NSString *communityId;

@property (nonatomic, copy) NSString *pid;

@property (nonatomic, copy) NSString *name;

// 是否选中
@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
