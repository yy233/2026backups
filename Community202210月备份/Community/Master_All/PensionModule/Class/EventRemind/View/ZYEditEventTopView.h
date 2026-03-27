//
//  ZYEditEventTopView.h
//  Community
//
//  Created by ZY on 2021/12/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYEditEventTopViewDelegate <NSObject>

- (void)backButtonEvent;

@end

@interface ZYEditEventTopView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) id<ZYEditEventTopViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
