//
//  PopViewMoneyTiXianSendPassword.h
//  Community
//
//  Created by 余莹 on 2021/10/14.
//

#import "BasePopView.h"
#import "TextFieldInfoShowCircleView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^PopViewSendPasswordBlock)(NSString *);
@interface PopViewMoneyTiXianSendPassword : BasePopView
@property (nonatomic,copy) PopViewSendPasswordBlock popViewSendPasswordBlock;
@end

NS_ASSUME_NONNULL_END
