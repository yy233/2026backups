//
//  HouseRentOfAppointmentVCSubView.h
//  Community
//
//  Created by 余莹 on 2021/3/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HouseRentOfAppointmentVCSubViewDelegate <NSObject>
- (void)footerViewOkAction;        //提交
- (void)touchTimesChooseBtnAction; //看房时间
- (void)chooseStayInTimeIndex:(NSInteger)index;//入住时间

@end


@interface HouseRentOfAppointmentVCSubView : UIView
@property (nonatomic,weak) id <HouseRentOfAppointmentVCSubViewDelegate> delegate;
- (void)fillDataWithIsHouseModel:(HouseRentListVcHouseCellModel *)model; //model 房屋
- (void)changYuyueTimeWithStr:(NSString *)showYuyueTimeStr;
@end

NS_ASSUME_NONNULL_END
