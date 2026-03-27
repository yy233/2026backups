//
//  MoneyWalletVCTopTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/2/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MoneyWalletVCTopTableViewCellDelegate <NSObject>

- (void)goToBangKaBtnAction;
- (void)showYuEMingXiBtnAction;

@end


@interface MoneyWalletVCTopTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *titleLabelRight;
@property (nonatomic,strong) UILabel *moneyL;
@property (nonatomic,strong) UIButton *bangKaBtn;
@property (nonatomic,strong) UIView *lineV;
@property (nonatomic,strong) UILabel *yuemingxiLabel;
@property (nonatomic,strong) UIImageView *jiantouimgV;
@property (nonatomic,strong) UIButton *yuemingxiCleanBtn;

@property (nonatomic,weak) id <MoneyWalletVCTopTableViewCellDelegate> delegate;
- (void)fillDataWithYuE:(double)yue andBCardNum:(NSInteger)bCardNum;
@end

NS_ASSUME_NONNULL_END
