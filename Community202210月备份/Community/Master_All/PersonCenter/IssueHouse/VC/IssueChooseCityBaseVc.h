//
//  IssueChooseCityBaseVc.h
//  Community
//
//  Created by 余莹 on 2021/1/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol  IssueChooseCityBaseVcDelegate  <NSObject>
- (void)issueChooseCityVcGetModel:(CityChooseModel *)cityModel withStr:(NSString *)cityNameStr;
@end

@interface IssueChooseCityBaseVc : CityChooseTableViewController
@property (nonatomic,weak) id <IssueChooseCityBaseVcDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
