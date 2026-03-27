//
//  MoeyWalletAddBankHaVeCardTypeVcTwoTypeBtnTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/2/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MoeyWalletAddBankHaVeCardTypeVcTwoTypeBtnTableViewCellDelegate <NSObject>
- (void)cellChooseChuXuKa;
- (void)cellChooseXinYongKa;
@end
@interface MoeyWalletAddBankHaVeCardTypeVcTwoTypeBtnTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIButton *chuXuKaBtn;
@property (nonatomic,strong) UIButton *xinYongKaBtn;
@property (nonatomic,weak) id <MoeyWalletAddBankHaVeCardTypeVcTwoTypeBtnTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
