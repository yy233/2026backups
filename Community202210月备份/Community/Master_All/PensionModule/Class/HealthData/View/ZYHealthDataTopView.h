//
//  ZYHealthDataTopView.h
//  Community
//
//  Created by ZY on 2021/11/8.
//

#import <UIKit/UIKit.h>
#import "BaseHealthHeader.h"
#import "ZYFamilyArchiveModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYHealthDataTopViewDelegate <NSObject>

- (void)backButtonEvent;

- (void)switchButtonEvent;

@end

@interface ZYHealthDataTopView : UIView

@property (nonatomic, weak) id<ZYHealthDataTopViewDelegate> delegate;
- (void)setTopViewStatusWithRefreshDataTimeStr:(NSString *)statusRefreshDataTime andHealthShowType:(HealthShow_Type)type;
- (void)setNowShowUserModel:(ZYFamilyArchiveModel *)model;

@end

NS_ASSUME_NONNULL_END
