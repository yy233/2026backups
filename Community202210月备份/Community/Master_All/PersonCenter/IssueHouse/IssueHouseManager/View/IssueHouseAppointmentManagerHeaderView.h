//
//  IssueHouseAppointmentManagerHeaderView.h
//  Community
//
//  Created by 余莹 on 2021/4/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    IssueHouseAppointment_TopView_Type_All=0,
    IssueHouseAppointment_TopView_Type_WillDeal=1,
    IssueHouseAppointment_TopView_Type_WillLookHouse=2,
    IssueHouseAppointment_TopView_Type_Cancelled=3,
    IssueHouseAppointment_TopView_Type_End=4,
} IssueHouseAppointment_TopView_Type;

@protocol IssueHouseAppointmentManagerHeaderViewDelegate <NSObject>
- (void)headerViewChooseType:(IssueHouseAppointment_TopView_Type)type;
@end

@interface IssueHouseAppointmentManagerHeaderView : UIView
@property (nonatomic,weak) id <IssueHouseAppointmentManagerHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
