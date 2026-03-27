//
//  IssueHouseAppointmentManagerVcTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/4/1.
//

#import <UIKit/UIKit.h>
#import "HouseRentHouseTableViewCell.h"
#import "IssueHouseAppointmentManagerVcModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol IssueHouseAppointmentManagerVcBaseTableViewCellDelegate <NSObject>
- (void)cellTouchCancelBtnWithModle:(IssueHouseAppointmentManagerVcModel *)model;
- (void)cellTouchFinishLookHouseBtnWithModle:(IssueHouseAppointmentManagerVcModel *)model;
- (void)cellTouchAcceptBtnWithModel:(IssueHouseAppointmentManagerVcModel *)model;
@end
@interface IssueHouseAppointmentManagerVcBaseTableViewCell : BaseTableViewCell
//top
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *typeL;
@property (nonatomic,strong) UIView *lineV;
//centerinfo
@property (nonatomic,strong) UIView *centerInfoBackView;
@property (nonatomic,strong) HouseRentHouseTableViewCell *centerInfoV;
//bottom
@property (nonatomic,strong) UIView *bottomBackView;
@property (nonatomic,strong) UIButton *acceptBtn;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *finishBtn;

//
- (void)fillDataWithModle:(IssueHouseAppointmentManagerVcModel *)model;
//
@property (nonatomic,weak) id <IssueHouseAppointmentManagerVcBaseTableViewCellDelegate> delegate;

@end
#pragma mark == 待处理
@interface IssueHouseAppointmentManagerVcWillDealTableViewCell : IssueHouseAppointmentManagerVcBaseTableViewCell
- (void)zuKeIsShowCancelBtn;
- (void)fangDngIsShowAcceptBtn;
@end

#pragma mark == 待看房

@interface IssueHouseAppointmentManagerVcWillLookHouseTableViewCell : IssueHouseAppointmentManagerVcBaseTableViewCell
- (void)zuKeIsShowFinishLookHouseOkBtn;
- (void)fangDngIsShowCancelBtn;
@end

#pragma mark == 已取消
@interface IssueHouseAppointmentManagerVcIsCancelledTableViewCell : IssueHouseAppointmentManagerVcBaseTableViewCell
@end

#pragma mark == 已完成
@interface IssueHouseAppointmentManagerVcEndTableViewCell : IssueHouseAppointmentManagerVcBaseTableViewCell
@end
NS_ASSUME_NONNULL_END
