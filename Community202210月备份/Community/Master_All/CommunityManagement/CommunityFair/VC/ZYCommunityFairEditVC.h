//
//  ZYCommunityFairEditVC.h
//  Community
//
//  Created by ZY on 2021/8/7.
//

#import <UIKit/UIKit.h>
#import "ZYCommunityFairListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYCommunityFairEditVC : ZYBaseViewController

@property (nonatomic, copy) NSString *typeStr;

@property (nonatomic, strong) ZYCommunityFairListDataListModel *listModel;

@end

NS_ASSUME_NONNULL_END
