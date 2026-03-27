//
//  ZYMyMedicalTopView.h
//  Community
//
//  Created by ZY on 2021/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYMyMedicalTopViewDelegate <NSObject>

- (void)backButtonEvent;

- (void)messageButtonEvent;

@end

@interface ZYMyMedicalTopView : UIView

@property (nonatomic, weak) id<ZYMyMedicalTopViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
