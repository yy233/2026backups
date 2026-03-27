//
//  ZYSOSAddSalvorBottomView.h
//  Community
//
//  Created by ZY on 2021/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYSOSAddSalvorBottomViewDelegate <NSObject>

- (void)okButtonEvent;

- (void)inputButtonEvent;

@end

@interface ZYSOSAddSalvorBottomView : UIView
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@property (nonatomic, weak) id<ZYSOSAddSalvorBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
