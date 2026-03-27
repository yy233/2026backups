//
//  PayPasswordThirdStepVC.h
//  Community
//
//  Created by 刘久炼 on 2021/2/26.
//

#import "BaseViewControllerNotNoticeWithUI.h"

NS_ASSUME_NONNULL_BEGIN

@interface PayPasswordThirdStepVC : BaseViewController //NotNoticeWithUI
@property (nonatomic,strong) NSString *payPasswordStr;
@property (nonatomic, copy) NSString *verifyCode;
@end

NS_ASSUME_NONNULL_END
