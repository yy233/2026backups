//
//  ElectroniNewRealNameAuthenticationFaceCenterBtnTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/2/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol RealNameAuthenticationFaceCellDelegagte <NSObject>
- (void)cellSubCenterBtnTouch;
@end

@interface ElectroniNewRealNameAuthenticationFaceCenterBtnTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UIButton *centerBtn;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,weak) id <RealNameAuthenticationFaceCellDelegagte> delegate;
@end

NS_ASSUME_NONNULL_END
