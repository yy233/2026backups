//
//  UserInfoRegistVCTableViewCell.h
//  Community
//
//  Created by 余莹 on 2020/11/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//
@protocol eidtorBtnRegistVcMainUserInfoTabeViewCellDelegate <NSObject>
- (void)editorBtnActionWillPushVcToEditorMianUser;
@end
@interface UserInfoRegistVCTableViewCell : UITableViewCell
@property (nonatomic,strong) UserInfoRegistModel *model;
@property (nonatomic,weak)id <eidtorBtnRegistVcMainUserInfoTabeViewCellDelegate> delegate;
@end
//
@protocol UserInfoRegistVCOtherUserInfoTableViewCellDelegate  <NSObject>
- (void)editorBtnActionWillPushVcToEditorFamilyMemberInfoWithModel:(UserFamilyModel*)model;
@end
@interface UserInfoRegistVCOtherUserInfoTableViewCell : UITableViewCell
@property (nonatomic,strong) UserFamilyModel *model;
@property (nonatomic,weak)id <UserInfoRegistVCOtherUserInfoTableViewCellDelegate> delegate;
@end
//
@interface UserInfoRegistVCNotUserInfoTableViewCell : UITableViewCell
@end

NS_ASSUME_NONNULL_END
