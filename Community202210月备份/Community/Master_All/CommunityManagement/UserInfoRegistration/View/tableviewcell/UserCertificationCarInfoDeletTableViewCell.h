//
//  UserCertificationCarInfoDeletTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/7/12.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol UserCertificationCarInfoDeletTableViewCellDelegate <NSObject>
- (void)touchCarInfoDeletBtnWithCarSectionNum:(NSInteger)carSectionNum;
@end
 
@interface UserCertificationCarInfoDeletTableViewCell : UITableViewCell
@property (nonatomic,strong) UIButton *deletCarInfoBtn;
@property (nonatomic,assign) NSInteger carSectionNum;
@property (nonatomic,weak) id <UserCertificationCarInfoDeletTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
