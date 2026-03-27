//
//  ZYSmallShopContainerRentPayFooterView.h
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYSmallShopContainerRentPayFooterViewDelegate <NSObject>

- (void)agreementButtonEvent;

@end


@interface ZYSmallShopContainerRentPayFooterView : UIView

@property (weak, nonatomic) IBOutlet UIButton *agreementButton;

@property (nonatomic, weak) id<ZYSmallShopContainerRentPayFooterViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
