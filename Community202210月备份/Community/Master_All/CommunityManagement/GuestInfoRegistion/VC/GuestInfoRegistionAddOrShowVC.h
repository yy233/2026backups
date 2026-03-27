//
//  GuestInfoRegistionEditVC.h
//  Community
//
//  Created by 余莹 on 2020/12/4.
//

#import <UIKit/UIKit.h>
#import "BaseHaveTableViewViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    Type_Add_GuestInfoRegistionEditVC=0,// 新增访客
    Type_Edit_GuestInfoRegistionEditVC=1,//编辑界面
    Type_Show_GuestInfoRegistionEditVC=2,//展示界面
} Type_GuestInfoRegistionEditVC;//访客 详情页 类型

@interface GuestInfoRegistionAddOrShowVC : BaseHaveTableViewViewController
@property (nonatomic,assign) Type_GuestInfoRegistionEditVC type;
@property (nonatomic,assign) NSInteger guestInfonationId;
@end

NS_ASSUME_NONNULL_END
 
