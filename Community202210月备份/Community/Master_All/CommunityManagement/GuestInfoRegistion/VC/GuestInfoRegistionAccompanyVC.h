//
//  GuestInfoRegistionAccompanyVC.h
//  Community
//  随行人员 随行车辆
//  Created by 余莹 on 2020/12/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GuestInfoRegistionAccompanyVC : BaseTableViewController//BaseViewController
@property (nonatomic,assign) Type_GuestInfoRegistionEditVC type;//当前总type 编辑类型 or 查看类型
@property (nonatomic,assign) NSInteger guestInfonationId;
@property (nonatomic,strong) NSMutableArray *personDataSourceArr;
@property (nonatomic,strong) NSMutableArray *carDataSourceArr;
@end

NS_ASSUME_NONNULL_END
