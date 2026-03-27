//
//  ZYLifeCostHouseholdBottomView.h
//  Community
//
//  Created by ZY on 2022/1/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYLifeCostHouseholdBottomViewDelegate <NSObject>

- (void)addButtonEvent;

@end

@interface ZYLifeCostHouseholdBottomView : UIView

@property (nonatomic, weak) id<ZYLifeCostHouseholdBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
