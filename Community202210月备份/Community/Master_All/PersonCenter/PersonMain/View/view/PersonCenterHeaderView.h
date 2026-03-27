//
//  PersonCenterHeaderView.h
//  Community
//
//  Created by 余莹 on 2021/1/18.
//

#import <UIKit/UIKit.h>
#import "PersonInfoUseModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol PersonCenterHeaderViewDelegate <NSObject>
- (void)personVcHeaderViewSubSetBtnTouchUp;
- (void)personVcHeaderViewSubInfoBtnTouchUp;
- (void)blockchainIDCardButtonEvent;
@end

@interface PersonCenterHeaderView : UIView
@property (nonatomic,weak) id <PersonCenterHeaderViewDelegate> delegate;
- (void)fillPersonInfoWithPersonInfoUseModel:(PersonInfoUseModel *)model;
- (void)headerViewRefreshPersonInfo;
- (void)changeThemeWithColorUpData;//主题色更新
@end


NS_ASSUME_NONNULL_END
