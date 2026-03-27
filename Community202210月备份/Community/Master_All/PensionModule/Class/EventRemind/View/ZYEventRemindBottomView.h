//
//  ZYEventRemindBottomView.h
//  Community
//
//  Created by ZY on 2021/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYEventRemindBottomViewDelegate <NSObject>

- (void)addEventButtonEvent;

@end

@interface ZYEventRemindBottomView : UIView

@property (nonatomic, weak) id<ZYEventRemindBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
