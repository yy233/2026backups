//
//  GuestTempCodeShowVcLateViewController.h
//  Community
//
//  Created by 余莹 on 2021/10/28.
// 临时二维码

//#import "GuestInfoRegistionOkShowQrCardVC.h"
#import "GuestInfoRegistionOkShowQrCardLateVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface GuestTempCodeShowVcLate : GuestInfoRegistionOkShowQrCardLateVC
//
@property (nonatomic,assign) BOOL isTempCodeShow;
@property (nonatomic,assign) NSInteger tempTimeNum;
@property (nonatomic,strong) NSString *tempTimeBeginInfoStr;
@end

NS_ASSUME_NONNULL_END
