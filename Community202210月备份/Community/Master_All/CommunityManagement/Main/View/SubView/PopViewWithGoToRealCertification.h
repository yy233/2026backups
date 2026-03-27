//
//  PopViewWithGoToRealCertification.h
//  Community
//
//  Created by 余莹 on 2021/3/22.
//  主页弹出 未真人认真时使用

#import <UIKit/UIKit.h>
#import "BasePopView.h"
#import "BaseTableViewFooterView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol PopViewWithGoToRealCertificationDelegate <NSObject>

- (void)popViewBtnActionWithGoToRealCertificationAction;

@end

@interface PopViewWithGoToRealCertification : BasePopView
@property (nonatomic,strong) UIView *centerBackView;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *centerLabel;
@property (nonatomic,strong) UILabel *centerContentLabel;
@property (nonatomic,strong) BaseTableViewFooterView *baseFooterView;
@property (nonatomic,strong) UIButton *bottomCloseBtn;
@property (nonatomic,weak) id <PopViewWithGoToRealCertificationDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
