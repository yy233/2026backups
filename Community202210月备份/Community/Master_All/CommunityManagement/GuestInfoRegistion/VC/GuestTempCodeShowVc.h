//
//  GuestTempCodeShowVc.h
//  Community
//
//  Created by 余莹 on 2021/10/26.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GuestTempCodeShowVc : BaseViewController
@property (nonatomic,strong) NSString *visitorId;//二维码所需ID
@property (nonatomic,assign) NSInteger tempTimeNum;
@property (nonatomic,strong) NSString *tempTimeBeginInfoStr;

@end

NS_ASSUME_NONNULL_END
