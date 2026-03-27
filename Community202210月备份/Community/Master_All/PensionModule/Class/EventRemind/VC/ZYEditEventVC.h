//
//  ZYEditEventVC.h
//  Community
//
//  Created by ZY on 2021/11/11.
//

#import <UIKit/UIKit.h>
#import "ZYEventRemindModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYEditEventVC : ZYPensionBaseVC

// 类型（add:新增 edit:编辑）
@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) ZYEventRemindModel *editEvenModel;

@end

NS_ASSUME_NONNULL_END
