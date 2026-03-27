//
//  ZYEventRemindDetailBottomView.h
//  Community
//
//  Created by ZY on 2021/11/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYEventRemindDetailBottomViewDelegate <NSObject>

- (void)editButtonEvent;

- (void)deleteButtonEvent;

@end

@interface ZYEventRemindDetailBottomView : UIView

@property (nonatomic, weak) id<ZYEventRemindDetailBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
