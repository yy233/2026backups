//
//  MyCarWithParkingSpotListPopChooseView.h
//  Community
//
//  Created by 余莹 on 2022/5/7.
//

#import "BasePopTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCarWithParkingSpotListPopChooseViewSubHeaderView : UIView

@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *okBtn;
@property (nonatomic,strong) UILabel *centerL;

@end


static NSInteger kChooseSpotIndexBaseI = 999999;

@interface MyCarWithParkingSpotListPopChooseView : BasePopTableView

@property (nonatomic,assign) NSInteger chooseSpotIndex;
@property (nonatomic,strong) MyCarWithParkingSpotListPopChooseViewSubHeaderView *headerVv;
- (void)thisPopViewHeaderOkBtnChangeColor;

@end



NS_ASSUME_NONNULL_END
