//
//  ZYCommunityFairIssueVc.h
//  Community
//
//  Created by ZY on 2022/6/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ZYCommunityFairIssue_Type_Add,   //发布
    ZYCommunityFairIssue_Type_Edit,  //编辑
} ZYCommunityFairIssue_Type;

@interface ZYCommunityFairIssueVc : ZYBaseViewController

@property (nonatomic, assign) ZYCommunityFairIssue_Type type;

@property (nonatomic, strong) NSString *idStr;

@end

NS_ASSUME_NONNULL_END
