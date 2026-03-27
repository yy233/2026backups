//
//  AccompanyTableViewCell.h
//  Community
//
//  Created by 余莹 on 2020/12/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
 
@protocol AccompanyTableViewCellDegelate <NSObject>
//随行人员 随行车辆
- (void)cellRightBtnTouchGuest:(GuestInfoModel *)model;
- (void)cellRightBtnTouchCar:(CarInfoModel *)model;
//随行人员 随行车辆
- (void)cellSelectedTypeBtnTouchGuest:(GuestInfoModel *)model;
- (void)cellSelectedTypeBtnTouchCar:(CarInfoModel *)model;
@end
@interface AccompanyTableViewCell : UITableViewCell
@property (nonatomic,strong) UIView *backGroundV;
@property (nonatomic,strong) UIButton *isSelectedTypeBtn;
@property (nonatomic,strong) UIButton *editorBtn;
@property (nonatomic,strong) GuestInfoModel *personModel;
@property (nonatomic,strong) CarInfoModel *carModel;
@property (nonatomic,weak) id<AccompanyTableViewCellDegelate>delegate;
- (void)isSelectedType;
- (void)isNomailType;
@end

NS_ASSUME_NONNULL_END
