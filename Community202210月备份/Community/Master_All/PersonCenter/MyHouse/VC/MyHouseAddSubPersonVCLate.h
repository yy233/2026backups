//
//  MyHouseAddSubPersonVCLate.h
//  Community
//
//  Created by 余莹 on 2022/4/25.
//

#import "MyHouseAddSubPersonVC.h"
#import "MyHousePersonRelationSubMemberModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    MyHouseAddOrEditSubPersonVC_Type_Add,
    MyHouseAddOrEditSubPersonVC_Type_Edit,
} MyHouseAddOrEditSubPersonVC_Type;//本界面 新增家属租客 或 编辑家属的 类型

typedef void(^AddOrEditPersonWithRefreshListVcBlock)(void);

@interface MyHouseAddSubPersonVCLate : BaseTableViewController
@property (nonatomic,assign) NSInteger nowCommunityId;
@property (nonatomic,assign) NSInteger nowHouseId;
@property (nonatomic,assign) BOOL isYeZhuRight;//是否为业主权限
@property (nonatomic,strong) NSString *addressStr;//二维码的时候使用
@property (nonatomic,assign) MyHouseAddOrEditSubPersonVC_Type myHouseAddOrEditSubPersonVC_Type; //本界面类型
@property (nonatomic,strong) MyHousePersonRelationSubMemberModel *listEditPersonWithModel; //编辑类型 用到的model
@property (nonatomic,copy) AddOrEditPersonWithRefreshListVcBlock addOrEditPersonWithRefreshListVcBlock;

@end

NS_ASSUME_NONNULL_END
