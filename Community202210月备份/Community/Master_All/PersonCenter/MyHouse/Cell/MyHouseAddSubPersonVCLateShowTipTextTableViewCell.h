//
//  MyHouseAddSubPersonVCLateShowTipTextTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *MyHouseAddSubPersonVCLateShowTipTextTableViewCell_I = @"MyHouseAddSubPersonVCLateShowTipTextTableViewCell";//文本tipcell
static NSString *MyHouseAddSubPersonVCLateShowTipTextAndBeginImgVTableViewCell_I = @"MyHouseAddSubPersonVCLateShowTipTextAndBeginImgVTableViewCell";//长tip

@interface MyHouseAddSubPersonVCLateShowTipTextTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *showTextL;

@end

@interface MyHouseAddSubPersonVCLateShowTipTextAndBeginImgVTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *showTextL;
@property (nonatomic,strong) UIImageView *beginImgV;
@end




NS_ASSUME_NONNULL_END
