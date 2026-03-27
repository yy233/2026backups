//
//  MyHouseAddSubPersonWithChoosePersonTypeHeaderView.h
//  Community
//
//  Created by 余莹 on 2022/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyHouseAddSubPersonWithChoosePersonTypeHeaderView : UIView

@property (nonatomic,strong) UIView *centerBackV;
@property (nonatomic,strong) UILabel *showPersonTypeL;
@property (nonatomic,strong) UIImageView *allowImgV;
@property (nonatomic,strong) UIButton *touchUseTopBtn;;

@property (nonatomic,strong) UIView *relationBackV;
@property (nonatomic,strong) UIButton *oneBtn;
@property (nonatomic,strong) UIButton *twoBtn;

- (void)hiddenChooseViews;
- (void)showChooseViews;

@end

NS_ASSUME_NONNULL_END
