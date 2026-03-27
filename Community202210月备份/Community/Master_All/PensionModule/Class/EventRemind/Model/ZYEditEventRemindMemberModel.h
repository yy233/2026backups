//
//  ZYEditEventRemindMemberModel.h
//  Community
//
//  Created by ZY on 2021/11/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYEditEventRemindMemberModel : NSObject

@property (nonatomic, copy) NSString *nameId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) BOOL isOneself;

@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
