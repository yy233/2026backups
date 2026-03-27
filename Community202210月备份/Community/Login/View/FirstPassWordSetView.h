//
//  PassWordSetView.h
//  Community
//
//  Created by 余莹 on 2020/11/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
 
@protocol FirstPasswordSetViewDelegate <NSObject>
- (void)firstPasswordSetViewSubBtnAction:(UIButton *)sender;
@end
@interface FirstPassWordSetView : UIView

@property (nonatomic,strong) UIView *topBackGroundView;
@property (nonatomic,strong) UIButton *removeSelfBtn;
@property (nonatomic,strong) UILabel  *topTitleLabel;
@property (nonatomic,strong) UILabel  *topDetailTitleLabel;


//
@property (nonatomic,strong) NSString *passwordOneStr;
@property (nonatomic,strong) NSString *passwordTwoStr;
@property (nonatomic,weak) id<FirstPasswordSetViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
