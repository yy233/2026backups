//
//  ElectroniRealNameAuthenticationHeaderView.h
//  Community
//
//  Created by 余莹 on 2021/2/24.
// 实名认证 共用 headerview

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    ZYElectroniRealNameAuthenticationHeaderView_Type_Card,
    ZYElectroniRealNameAuthenticationHeaderView_Type_Face,
} ZYElectroniRealNameAuthenticationHeaderView_Type;
@interface ZYElectroniRealNameAuthenticationBaseHeaderView : UIView
@property (nonatomic,strong) UIButton *cardBtn;
@property (nonatomic,strong) UIButton *faceBtn;
@property (nonatomic,strong) UIImageView *cardBottomImgV;
@property (nonatomic,strong) UIImageView *faceBottomImgV;
@property (nonatomic,strong) UIImageView *centerImgView;
@property (nonatomic,strong) UIView *bottomLineV;

//
- (void)setHeaderViewType:(ElectroniRealNameAuthenticationHeaderView_Type)selectedBtnType;
@end

NS_ASSUME_NONNULL_END
