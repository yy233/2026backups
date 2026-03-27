//
//  ZYVisitorInviteEditVc.h
//  Community
//
//  Created by ZY on 2022/5/20.
//

#import <UIKit/UIKit.h>
#import "ZYVisitorInviteUploadModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ZYVisitorInvite_Type_Add,  //新增
    ZYVisitorInvite_Type_Edit, //编辑
} ZYVisitorInvite_Type;

@interface ZYVisitorInviteEditVc : ZYBaseViewController

@property (nonatomic, assign) ZYVisitorInvite_Type type;

// 提交数据model
@property (nonatomic, strong) ZYVisitorInviteUploadModel *uploadModel;

@end

NS_ASSUME_NONNULL_END
