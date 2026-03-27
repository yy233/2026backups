//
//  DeviceScanListShowVcHeaderView.h
//  Community
//
//  Created by 余莹 on 2021/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceScanListShowVcHeaderView : UIView

@property (nonatomic,strong) UIButton *mainShowBtn;
@property (nonatomic,strong) UIActivityIndicatorView *rightIndicatorView;

- (void)showWithEndConnectBool:(BOOL)isEndConnectBool;
@end

NS_ASSUME_NONNULL_END
