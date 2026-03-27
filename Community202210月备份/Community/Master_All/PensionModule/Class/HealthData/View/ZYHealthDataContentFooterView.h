//
//  ZYHealthDataContentFooterView.h
//  Community
//
//  Created by ZY on 2021/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYHealthDataContentFooterViewDelegate <NSObject>

- (void)bindButtonEvent;

@end

@interface ZYHealthDataContentFooterView : UIView

@property (nonatomic, weak) id<ZYHealthDataContentFooterViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
