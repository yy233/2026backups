//
//  IssueHouseAppointmentManager.h
//  Community
//
//  Created by 余莹 on 2021/4/1.
//

#import <UIKit/UIKit.h>
#import "IssueHouseManagerType.h"
NS_ASSUME_NONNULL_BEGIN

@interface IssueHouseAppointmentManagerVc : BaseTableViewControllerNotNoticeWithUI
@property (nonatomic,assign) IssueHouseManagerVC_MyType  myIdentityType; //身份类型 租客｜房东
@end

NS_ASSUME_NONNULL_END
