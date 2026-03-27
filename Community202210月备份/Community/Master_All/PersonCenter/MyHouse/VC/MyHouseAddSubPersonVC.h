//
//  MyHouseAddSubPerson.h
//  Community
//
//  Created by 余莹 on 2021/8/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyHouseAddSubPersonVC : BaseTableViewController
@property (nonatomic,assign) NSInteger nowCommunityId;
@property (nonatomic,assign) NSInteger nowHouseId;
@property (nonatomic,assign) BOOL isYeZhuRight;//是否为业主权限
@property (nonatomic,strong) NSString *addressStr;//二维码的时候使用
@end

NS_ASSUME_NONNULL_END
