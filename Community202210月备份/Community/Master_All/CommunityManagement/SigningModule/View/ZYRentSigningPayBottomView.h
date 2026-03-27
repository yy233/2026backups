//
//  ZYRentSigningPayBottomView.h
//  Community
//
//  Created by ZY on 2021/9/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYRentSigningPayBottomViewDelegate <NSObject>

- (void)okButtonEvent;

@end

@interface ZYRentSigningPayBottomView : UIView

@property (weak, nonatomic) IBOutlet UIButton *okButton;

@property (nonatomic, weak) id<ZYRentSigningPayBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
