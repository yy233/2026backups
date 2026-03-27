//
//  MyHistoryDevListVc.m
//  Community
//
//  Created by 余莹 on 2021/12/6.
//

#import "MyHistoryDevListVc.h"
#import "HealthBaseDataManager.h"

#import "MyHistoryDevTableViewCell.h"
#define  MyHistoryDevTableViewCell_Identifier           @"MyHistoryDevTableViewCell"


@interface MyHistoryDevListVc ()
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
@end

@implementation MyHistoryDevListVc
- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc]init];
    }
    return _dataSourceArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的设备";
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.backgroundColor = Y_ColorWith16FromRGB(0xF0F1F6);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarStyleWithColor];
}
- (void)initData{
    WEAKSELF
    [[HealthBaseDataManager share] getUserDevHistoryListWithBlock:^(NSArray * _Nonnull arr, BOOL success) {
        if (success) {
            weakSelf.dataSourceArr = [NSMutableArray  arrayWithArray: [DevGetNowUsersDevInfoModel mj_objectArrayWithKeyValuesArray:arr]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return self.dataSourceArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     MyHistoryDevTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyHistoryDevTableViewCell_Identifier ];
     if (!cell) {
         cell = [[MyHistoryDevTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyHistoryDevTableViewCell_Identifier];
     }
     [cell fillDataWithModel:self.dataSourceArr[indexPath.row]];
     WEAKSELF
     cell.historyDevDeletBlock = ^{
         [weakSelf deletRowNum:indexPath.row];
     };
     
    return cell;
}

- (void)deletRowNum:(NSInteger)rowNum{
    DevGetNowUsersDevInfoModel *model = self.dataSourceArr[rowNum];
    WEAKSELF
    [[AlertManager shareManager]creatAlertWithTitle:@"确认删除设备？" message:[@"设备:" stringByAppendingString:[TextShowWithModelStr textShowWithNotNullStr:model.mdeviceName]] preferredStyle:UIAlertControllerStyleAlert cancelTitle:@"取消" otherTitleArr:@[@"删除"].mutableCopy];
    [[AlertManager shareManager]showWithViewController:self IndexBlock:^(NSInteger index) {
        if (index==AlertManagerCancelIndex) {
        }else{
            [weakSelf gotoRemoveBindWithRwoNum:rowNum];
        }
    }];
 
}
- (void)gotoRemoveBindWithRwoNum:(NSInteger)rowNum{
    
    DevGetNowUsersDevInfoModel *model = self.dataSourceArr[rowNum];
    //离线
    
    NSString *modelName= [TextShowWithModelStr textShowWithModelStr:model.mdeviceName];
    NSString *modelMacAddress = [TextShowWithModelStr textShowWithModelStr:model.mdeviceAddress];
    
    //解绑 id处不需要传入
    WEAKSELF
    [[HealthBaseDataManager share]removebindIngDevWCanNotSendUserid:@"" withDevAddress:[TextShowWithModelStr textShowWithModelStr:model.mdeviceAddress] withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            Y_SVP_SHOW_SUCCESS_MES(@"已经删除该设备");
            [weakSelf initData];
            if ([TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected) {
                if (([modelMacAddress isEqualToString:[TrusangBlueToothSdkDataManager share].showModel.saveNowDevMac] || [TrusangBlueToothSdkDataManager share].showModel.saveNowDevMac.length==0) && [modelName isEqualToString:[TrusangBlueToothSdkDataManager share].showModel.saveNowDevName] ) {//同名 && 同mac||空mac
                    //@"当前在线设备!" 做离线处理 再通知数据更新
                    //                         [[TrusangBlueToothSdkDataManager share]disConnectDev];
                    [[ZHJBLEManagerProvider shared] disconnectDeviceWithDisconnect:^(CBPeripheral * _Nonnull info) {
                        NSLog(@"已经断开设备 %@",info);
                        [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.isConnected = NO;
                        [TrusangBlueToothSdkDataManager share].nowDevState = DeviceStateDisconnected;
                        Y_NSNotificationCenter_PostNotice_NilObject_Name(HistoryDeletConnectDevNoticeName);
                        
                    }];
                    
                }
            }else{
                Y_NSNotificationCenter_PostNotice_NilObject_Name(HistoryDeletConnectDevNoticeName);
            }
        }
    }];
}
 
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
