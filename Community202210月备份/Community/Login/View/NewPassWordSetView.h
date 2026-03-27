//
//  NewPassWordSetView.h
//  Community
//
//  Created by 余莹 on 2020/11/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NewPasswordSetViewDelegate <NSObject>
- (void)newPasswordSetViewSubBtnAction:(UIButton *)sender;
@end

@interface NewPassWordSetView : UIView
@property (nonatomic,strong) NSString *passwordOneStr;
@property (nonatomic,weak) id<NewPasswordSetViewDelegate>delegate;
@end
NS_ASSUME_NONNULL_END
