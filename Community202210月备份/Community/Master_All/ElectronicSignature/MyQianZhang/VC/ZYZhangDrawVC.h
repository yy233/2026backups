//
//  ZYZhangDrawVC.h
//  Community
//
//  Created by ZY on 2021/5/11.
//

#import <UIKit/UIKit.h>
#import "ZYZhangManagerModel.h"

@protocol ZYZhangDrawVCDelegate <NSObject>

- (void)zhangDrawWithModel:(ZYZhangManagerDataModel *_Nullable)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZYZhangDrawVC : BaseViewControllerNotNoticeWithUI

@property (nonatomic, weak) id<ZYZhangDrawVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
