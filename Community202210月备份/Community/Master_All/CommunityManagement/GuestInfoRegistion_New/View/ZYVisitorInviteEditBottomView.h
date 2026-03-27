//
//  ZYVisitorInviteEditBottomView.h
//  Community
//
//  Created by ZY on 2022/5/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYVisitorInviteEditBottomViewDelegate <NSObject>

- (void)okButtonEvent;

@end

@interface ZYVisitorInviteEditBottomView : UIView

@property (weak, nonatomic) IBOutlet UIButton *okButton;

@property (nonatomic, weak) id<ZYVisitorInviteEditBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
