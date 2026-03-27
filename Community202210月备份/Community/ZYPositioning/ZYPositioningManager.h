//
//  ZYPositioningManager.h
//  Community
//
//  Created by ZY on 2021/6/10.
//

#import <Foundation/Foundation.h>

typedef void(^LocationCompletion)(ZYPositioningModel * _Nullable model, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface ZYPositioningManager : NSObject

@property (nonatomic, copy) LocationCompletion locationCompletionBlock;

+ (void)startPositioningWithLocationCompletion:(LocationCompletion)locationCompletion;

@end

NS_ASSUME_NONNULL_END
