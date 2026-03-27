//
//  ResetPasswordView.h
//  Community
//
//  Created by 余莹 on 2020/11/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RestPasswordViewDelegate <NSObject>
- (void)restPasswordViewSubBtnAction:(UIButton *)sender;
@end
@interface ResetPasswordView : UIView
@property (nonatomic,weak)id <RestPasswordViewDelegate> delegate;
@property (nonatomic,strong) NSString *phoneStr;
@property (nonatomic,strong) NSString *codeStr;
- (void)countdown;
@end

NS_ASSUME_NONNULL_END
