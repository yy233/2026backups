//
//  ZYParkingTemporaryDetaiBottomView.h
//  Community
//
//  Created by ZY on 2021/10/26.
//

#import <UIKit/UIKit.h>

@protocol ZYParkingTemporaryDetaiBottomViewDelegate <NSObject>

- (void)payButtonEvent;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZYParkingTemporaryDetaiBottomView : UIView

@property (nonatomic, weak) id<ZYParkingTemporaryDetaiBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
