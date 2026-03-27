//
//  ContrectAllListVC.h
//  Community
//
//  Created by 余莹 on 2021/1/28.
//   全部合同 合同列表

#import <UIKit/UIKit.h>
 
NS_ASSUME_NONNULL_BEGIN

//合同状态
typedef enum : NSUInteger {
    ContrectList_Type_All = 0, // 全部合同
    ContrectList_Type_MyWait = 1, // 待我签
    ContrectList_Type_OtherWait = 2, // 待他签
    ContrectList_Type_Complete = 3, // 已完成
    ContrectList_Type_Expire = 4, // 即将截止签署
    ContrectList_Type_Invalid = 5, // 已失效
    ContrectList_Type_Close = 6, // 即将过期
    ContrectList_Type_MySend = 7 // 我发起的
} ContrectList_Type;

@interface ContrectAllListVC : ZYBaseViewController

@property (nonatomic,assign) ContrectList_Type listVcType;

@end

NS_ASSUME_NONNULL_END
