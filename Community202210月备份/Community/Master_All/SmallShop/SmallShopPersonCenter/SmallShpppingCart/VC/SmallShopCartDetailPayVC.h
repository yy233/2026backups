//
//  SmallShopCartDetailPayVC.h
//  Community
//
//  Created by 余莹 on 2022/3/1.
//

#import "SmallShopCartBaseVC.h"
//#import "ZYSmallShopPayWayModel.h"
#import "ZYSmallShopContainerRentPaySuccessVc.h"
#import "SmallShopCartHeader.h"
#import "SmallShopWaitingPayOfTheCountdownTableViewCell.h"
#import "ZYSmallShopPayWayPopView.h"
#import "ZYSmallShopGoodsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SmallShopCartDetailPayVC : SmallShopCartBaseVC  <ZYSmallShopPayWayPopViewDelegate>
@property (nonatomic, assign) ZYSmallShop_Pay_Way_Type nowPayType; 
@property (nonatomic, strong) NSString *nowAddressStr;
@property (nonatomic, strong) NSString *nowPhoneStr;
@property (nonatomic, strong) NSString *nowMoneyStr;
@property (nonatomic, strong) NSString *nowPayDtoStr;
@property (nonatomic, assign) BOOL isWaitingForPayBool;//已经下订单 未支付 倒计时状态
@property (nonatomic, assign) BOOL isOutTimeBool;//已经超时
@property (nonatomic, assign) BOOL isSuccessPayBool;//已经付钱
@property (nonatomic, strong) NSString *saveOrderStrWaitingForPay;//下单的订单IDstr
@property (nonatomic, strong) ZYSmallShopPayWayPopView *popView;
- (void)cellNoticePost;//cell出现后再通知
@property (nonatomic, strong) ZYSmallShopGoodsDetailModel *model;
@property (nonatomic, assign) BOOL isSpellGroup; //是否是拼团
@end

NS_ASSUME_NONNULL_END
