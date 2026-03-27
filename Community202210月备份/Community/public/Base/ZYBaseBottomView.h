//
//  ZYBaseBottomView.h
//  Community
//
//  Created by ZY on 2022/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYBaseBottomViewDelegate <NSObject>

- (void)okButtonEvent;

@end

@interface ZYBaseBottomView : UIView

@property (weak, nonatomic) IBOutlet UIButton *okButton;

@property (nonatomic, weak) id<ZYBaseBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
