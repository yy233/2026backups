//
//  ZYMyPensionTopView.h
//  Community
//
//  Created by ZY on 2021/11/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYMyPensionTopViewDelegate <NSObject>

- (void)backButtonEvent;

- (void)messageButtonEvent;

@end

@interface ZYMyPensionTopView : UIView

@property (nonatomic, weak) id<ZYMyPensionTopViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
