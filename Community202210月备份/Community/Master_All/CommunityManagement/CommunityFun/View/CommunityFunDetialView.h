//
//  CommunityFunDetialView.h
//  Community
//
//  Created by 余莹 on 2020/12/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ForwardingBtnActionBlock)(void);

@interface CommunityFunDetialView : UIView
@property (nonatomic,strong) CommunityFunModel *model;
@property (nonatomic,weak) ForwardingBtnActionBlock forwardingBtnActionBlock;
@end

NS_ASSUME_NONNULL_END
