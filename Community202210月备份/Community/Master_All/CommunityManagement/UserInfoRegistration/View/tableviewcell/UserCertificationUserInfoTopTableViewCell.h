//
//  UserCertificationUserInfoTopTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/3/1.
// 认证 详情页 业主详情的info cell 

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserCertificationUserInfoTopTableViewCell : UITableViewCell

 @property (nonatomic,strong) UIImageView *headImgV;
@property (nonatomic,strong) UIView *backGroundV;
@property (nonatomic,strong) UIView *titleLabelBackGroundView;
//
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *genderImgV;
@property (nonatomic,strong) UILabel *typeLabel;
//
@property (nonatomic,strong) UILabel *detailtitleLabel;
- (void)genderInfoWithIndex:(NSInteger)genderIndex;
@end

NS_ASSUME_NONNULL_END
