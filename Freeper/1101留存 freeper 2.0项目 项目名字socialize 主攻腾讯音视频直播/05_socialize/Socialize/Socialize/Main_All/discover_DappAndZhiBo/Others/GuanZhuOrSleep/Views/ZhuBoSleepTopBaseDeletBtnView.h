//
//  TopBaseDeletBtnView.h
//  Socialize
//
//  Created by 余莹 on 2023/5/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZhuBoSleepTopBaseDeletBtnViewDelegate <NSObject>

- (void)touchGoMainVc;
- (void)touchKaiBoTiXing;
- (void)touchDeletBtn;


@end


@interface ZhuBoSleepTopBaseDeletBtnView : UIView

@property (nonatomic,strong) UIButton *rightTopBtn;
@property (nonatomic,strong) UIImageView *bakImg;
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *topL;
@property (nonatomic,strong) UILabel *botL;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;

@property (nonatomic,weak) id <ZhuBoSleepTopBaseDeletBtnViewDelegate>delegate;

@end




NS_ASSUME_NONNULL_END
