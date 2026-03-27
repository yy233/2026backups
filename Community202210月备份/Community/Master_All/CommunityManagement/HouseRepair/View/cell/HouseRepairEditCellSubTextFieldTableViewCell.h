//
//  HouseRepairEditCellSubTextFieldTableViewCell.h
//  Community
//
//  Created by 余莹 on 2020/12/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseRepairEditCellSubTextFieldTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIView *lineView;
@end

@interface HouseRepairEditCellSubTextFieldAndChooseBtnTableViewCell : HouseRepairEditCellSubTextFieldTableViewCell
@property (nonatomic,strong) UIButton *textFieldTopChooseBtn;
@property (nonatomic,strong) UIImageView *textFieldRightImg;
@end

@interface HouseRepairEditCellSubTextFieldOnlyShowTitleTableViewCell : HouseRepairEditCellSubTextFieldTableViewCell
@end

@protocol HouseRepairEditCellSubTwoChooseBtnTableViewCellDelegate <NSObject>
- (void)chooseBtnWithRepairType:(Repair_Type_PersonalOrPublic)type;
@end
@interface HouseRepairEditCellSubTwoChooseBtnTableViewCell : HouseRepairEditCellSubTextFieldOnlyShowTitleTableViewCell
@property (nonatomic,strong) UIButton *personTypeBtn;
@property (nonatomic,strong) UIButton *publishTypeBtn;
@property (nonatomic,weak) id <HouseRepairEditCellSubTwoChooseBtnTableViewCellDelegate> delegate;
@end
 
NS_ASSUME_NONNULL_END
