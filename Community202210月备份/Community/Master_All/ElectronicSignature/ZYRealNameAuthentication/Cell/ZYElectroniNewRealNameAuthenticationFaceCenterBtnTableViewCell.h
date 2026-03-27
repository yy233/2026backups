//
//  ElectroniNewRealNameAuthenticationFaceCenterBtnTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/2/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ZYRealNameAuthenticationFaceCellDelegagte <NSObject>
- (void)cellSubCenterBtnTouch;
@end

@interface ZYElectroniNewRealNameAuthenticationFaceCenterBtnTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UIButton *centerBtn;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,weak) id <ZYRealNameAuthenticationFaceCellDelegagte> delegate;
@end

NS_ASSUME_NONNULL_END
