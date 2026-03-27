//
//  ZYLeadFamilyArchiveModel.h
//  Community
//
//  Created by ZY on 2021/12/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYLeadFamilyArchiveModel : NSObject

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
