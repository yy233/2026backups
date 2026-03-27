//
//  ZYPageBaseVc.h
//  Community
//
//  Created by ZY on 2021/4/20.
//
// 页面基本VC

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYPageBaseVc : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *naviView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewTopConstraint;

@property (weak, nonatomic) IBOutlet UIView *contentView;

- (IBAction)backButtonClicked:(UIButton *)sender;

- (void)setNavbackBtnTitleNilAndHidden;
- (void)setupNavigationBarWithBackItemHaveTitleWithStr:(NSString *)titleStr;
- (void)setupNavigationBarWithBackItemNoTitle;
@end

NS_ASSUME_NONNULL_END
