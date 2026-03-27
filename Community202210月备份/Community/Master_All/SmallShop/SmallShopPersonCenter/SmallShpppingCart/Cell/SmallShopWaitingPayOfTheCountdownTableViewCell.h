//
//  SmallShopWaitingPayOfTheCountdownTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/3/22.
// 等待付款倒计时cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *kNotice_HaveOrderAndWaitForPay   = @"Notice_HaveOrderAndWaitForPay";
static NSString *SmallShopWaitingPayOfTheCountdownTableViewCell_I = @"SmallShopWaitingPayOfTheCountdownTableViewCell";
typedef void(^SmallShopWaitingPayOfTheCountdownEndBlock)(void);

@interface SmallShopWaitingPayOfTheCountdownTableViewCell : UITableViewCell
@property (nonatomic,copy) SmallShopWaitingPayOfTheCountdownEndBlock waitingPayOfTheCountdownEndBlock;
- (void)orderCountownTimeChangeBegin;
 @end

NS_ASSUME_NONNULL_END
