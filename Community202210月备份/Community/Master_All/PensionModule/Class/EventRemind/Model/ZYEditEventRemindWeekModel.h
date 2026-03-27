//
//  ZYEditEventRemindWeekModel.h
//  Community
//
//  Created by ZY on 2021/12/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYEditEventRemindWeekModel : NSObject

@property (nonatomic, copy) NSString *weekStr;

@property (nonatomic, assign) NSInteger week;

@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
