//
//  DeviceListTableViewController.h
//  blueDemo
//
//  Created by 余莹 on 2021/11/4.
//

#import <UIKit/UIKit.h>
#import "TrusangBluetooth.framework/Headers/TrusangBluetooth.h"
#import "TrusangBluetooth.framework/Headers/TrusangBluetooth-Swift.h"
 #import "HealthDataSubBaseTableViewController.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^OneDevicConnectedOkBlock)(ZHJBTDevice *);


@interface DeviceScanListShowTableViewController : HealthDataSubBaseTableViewController
@property (nonatomic,strong) NSString *nowUserId;
@property (nonatomic,assign) BOOL isOwnBool;//userid是否自己,如果是家人id则为no
@property (nonatomic,strong) NSMutableArray <ZHJBTDevice *> *dataSourceArr;
@property (nonatomic,copy) OneDevicConnectedOkBlock oneDevicConnectedOkBlock;
@property (nonatomic,assign) DeviceState saveOldDevState;//当前初始时的设备状态（因为本list会有搜索功能 会导致devManager中键值变化成搜索状态导致无法确定处理cell so 在搜索状态+初始未点击链接时用本状态处理cell）
@end

NS_ASSUME_NONNULL_END
