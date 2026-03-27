//
//  UserCertificationTextTableViewCell.h
//  Community
//
//  Created by 余莹 on 2020/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserCertificationTextTableViewCell : UITableViewCell
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIButton *textFieldRightBtn;//展示用
@property (nonatomic,strong) UIButton *subShowChooseBtn;//选择用
@property (nonatomic,strong) UIView *lineView;
@end

//车辆信息车牌号cell
@interface UserCertificationTextWithOtherRightImgTableViewCell : UserCertificationTextTableViewCell
@end

NS_ASSUME_NONNULL_END
