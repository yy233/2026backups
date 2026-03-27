//
//  IssueChooseCommunityBaseVc.h
//  Community
//
//  Created by 余莹 on 2021/1/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IssueChooseCommunityBaseVcDelegate <NSObject>
- (void)issueChooseCommunityVcGetModel:(CommunityModel *)communityModel withStr:(NSString *)communityNameStr;
@end


@interface IssueChooseCommunityBaseVc : CommunityChooseTableViewController
@property (nonatomic,weak) id <IssueChooseCommunityBaseVcDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
