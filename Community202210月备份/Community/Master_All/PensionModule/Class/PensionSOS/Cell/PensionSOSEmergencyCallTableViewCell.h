//
//  PensionSOSEmergencyCallTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/12/3.
//

#import <UIKit/UIKit.h>
#define Color_Green_BtnShow     Y_ColorWith16FromRGB(0x3CCAC3)
#define Color_Red_BtnShow       Y_ColorWith16FromRGB(0xFF0033)

#define Tag_PensionSOSMainCellSubBtn_AddPhoneBook        (300)
#define Tag_PensionSOSMainCellSubBtn_EmergencyCall       (301)
#define Tag_PensionSOSMainCellSubBtn_EditPhoneBook       (302)

#define Tag_PensionSOSMainCellSubBtn_AddAddressInfo      (400)
#define Tag_PensionSOSMainCellSubBtn_GoAddress           (401)
#define Tag_PensionSOSMainCellSubBtn_EditAddressInfo     (402)

NS_ASSUME_NONNULL_BEGIN

@protocol PensionSOSVcSubTableViewCellDeleagate <NSObject>
- (void)touchCellSubBtnAction:(UIButton *)sender;

@end

@interface PensionSOSEmergencyCallTableViewCell : UITableViewCell
@property (nonatomic,strong) UIButton *cellMainBtn;
@property (nonatomic,strong) UILabel *cellMainLabel;
@property (nonatomic,strong) UIButton *cellEditBtn;

- (void)showEmergencyCallWithHaveInfoBool:(BOOL)haveInfo;
@property (nonatomic,weak) id <PensionSOSVcSubTableViewCellDeleagate> delegate;
@end

NS_ASSUME_NONNULL_END
