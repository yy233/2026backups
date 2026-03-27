//
//  ChatVcSubAddressTypeTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/3/24.
//

#import "ChatVcSubBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


static NSString *ChatVcSubAddressTypeTableViewCell_I   = @"ChatVcSubAddressTypeTableViewCell";
static NSString *ChatVcSubAddressTypeTableViewCell_Left_I   = @"ChatVcSubAddressTypeTableViewCell_left";
static NSString *ChatVcSubAddressTypeTableViewCell_Right_I   = @"ChatVcSubAddressTypeTableViewCell_right";

@interface ChatVcSubAddressTypeTableViewCell : ChatVcSubBaseTableViewCell
@property (nonatomic,strong) UILabel *topLocateAddressLabel;//承接地址文本
@property (nonatomic,strong) UIView *bottomLocateAddressShowBackView;//承接地址
@property (nonatomic,strong) UIButton *centerBtn;

@end

NS_ASSUME_NONNULL_END
