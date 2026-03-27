//
//  MyHouseAddSubPersonVCLateShowSwithTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *MyHouseAddSubPersonVCLateShowSwithTableViewCell_I = @"MyHouseAddSubPersonVCLateShowSwithTableViewCell";//关怀模式cell开关
static NSString *MyHouseAddSubPersonVCLateShowSwithWithOpenPhoneOrNotOpenPhoneTableViewCell_I = @"MyHouseAddSubPersonVCLateShowSwithWithOpenPhoneOrNotOpenPhoneTableViewCell";//是否开启手机号

typedef void(^CellSubSwitchSelectedBlock)(BOOL isOn);

@interface MyHouseAddSubPersonVCLateShowSwithTableViewCell : UITableViewCell
@property (nonatomic,strong) UISwitch *switchV;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,copy) CellSubSwitchSelectedBlock cellSubSwitchSelectedBlock;
@end

@interface MyHouseAddSubPersonVCLateShowSwithWithOpenPhoneOrNotOpenPhoneTableViewCell : MyHouseAddSubPersonVCLateShowSwithTableViewCell 
 
@end

NS_ASSUME_NONNULL_END
