//
//  ZYSmallShopNavigationView.h
//  Community
//
//  Created by ZY on 2022/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYSmallShopNavigationViewDelegate <NSObject>

- (void)backButtonEvent;

@end

@interface ZYSmallShopNavigationView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) id<ZYSmallShopNavigationViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
