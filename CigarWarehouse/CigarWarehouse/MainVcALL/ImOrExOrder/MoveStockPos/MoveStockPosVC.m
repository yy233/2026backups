//
//  MoveStockPosVC.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/8/1.
//

#import "MoveStockPosVC.h"
#import "PosAndBrandInfoAddTools.h"

#import <SGQRCode/SGQRCode.h>
#import "ScanQR_BaseViewController.h"
#import "WBQRCodeVC.h"
@interface MoveStockPosVC ()
@property (nonatomic,strong) NSString *codeSave;
@property (nonatomic,strong) NSString *posSave;

@end

@implementation MoveStockPosVC



#pragma mark ===
- (void)footerBtnAction:(UIButton *)sender{
    [self.view endEditing:YES];
    if (self.codeSave.length<=0) {
        Y_SVP_SHOW_INFO_MES(@"请填写产品码！");
        return;
    }
    if (self.posSave.length<=0) {
        Y_SVP_SHOW_INFO_MES(@"请填写新位置码！");
        return;
    }
    
    [[PosAndBrandInfoAddTools share]moveStockPosWithThisProductCode:self.codeSave withPosStr:self.posSave withBlock:^(BOOL succ, NSDictionary * _Nonnull okDic) {
        if (succ) {
            Y_SVP_SHOW_SUCCESS_MES(@"移动库存 成功！");
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            Y_SVP_SHOW_SUCCESS_MES(@"移动库存 失败！");
        }
    }];
    
}
#pragma mark =========
- (void)getTextSave:(UITextField *)textField{
    //@"码",@"位置"
    switch (textField.tag - cell_tf_BaseTag ) {
        case 0:
            self.codeSave = textField.text;
            break;
        case 1:
            self.posSave = textField.text;
            break;
        default:
            break;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTitleData];
}
- (void)initTitleData{//入库
    self.codeSave = @"";
    self.posSave = @"";
    self.dataSourceTitleArr = @[@"产品码",@"位置"].mutableCopy;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListBaseTableViewCell_ShowBtn_I];
    if (!cell) {
        cell = [[ListBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ListBaseTableViewCell_ShowBtn_I];
    }
    cell.titL.text = self.dataSourceTitleArr[indexPath.row];
    cell.textF.tag = cell_tf_BaseTag + indexPath.row;
    cell.textF.delegate = self;
    [cell showRightBtnWithTextStr:@"扫码"];
    cell.rightBtn.tag = 1000+indexPath.row;
    if (indexPath.row == 0) {
        cell.textF.text =  [TextShowWithModelStr textShowWithModelStr:self.codeSave];
        [cell.rightBtn addTarget:self action:@selector(goQR:) forControlEvents:UIControlEventTouchUpInside];
        [cell setTextPStr:@"请填写产品码"];
    } else {
        cell.textF.text =  [TextShowWithModelStr textShowWithModelStr:self.posSave];
        [cell.rightBtn addTarget:self action:@selector(goQR:) forControlEvents:UIControlEventTouchUpInside];
        [cell setTextPStr:@"请填写新位置码"];
    }
 
    return cell;
}
- (void)goQR:(UIButton *)sender{
    if ( sender.tag - 1000 == 0) {
        [self goQRActionWithIsPosBool:NO];

    }else{
        [self goQRActionWithIsPosBool:YES];
    }
}
- (void)goQRActionWithIsPosBool:(BOOL)isPos{
    WEAKSELF
        [SGPermission permissionWithType:SGPermissionTypeCamera completion:^(SGPermission * _Nonnull permission, SGPermissionStatus status) {
            if (status == SGPermissionStatusNotDetermined) {
                [permission request:^(BOOL granted) {
                    if (granted) {
                        NSLog(@"第一次授权成功");
                        WBQRCodeVC *qrVC = [[WBQRCodeVC alloc] init];
                        weakSelf.hidesBottomBarWhenPushed = YES;
                        qrVC.qrResultStrBlock = ^(NSString * _Nonnull resultStr) {
                            NSLog(@"QR resultStr - %@",resultStr);
                            [weakSelf getQrStr:resultStr WithIsPosBool:isPos];
                        };
                        [weakSelf.navigationController pushViewController:qrVC animated:YES];
                     } else {
                        NSLog(@"第一次授权失败");
                    }
                }];
            } else if (status == SGPermissionStatusAuthorized) {
                NSLog(@"SGPermissionStatusAuthorized");
                WBQRCodeVC *qrVC = [[WBQRCodeVC alloc] init];
                weakSelf.hidesBottomBarWhenPushed = YES;
                qrVC.qrResultStrBlock = ^(NSString * _Nonnull resultStr) {
                    NSLog(@"QR resultStr - %@",resultStr);
                    [weakSelf getQrStr:resultStr WithIsPosBool:isPos];
                };
                [weakSelf.navigationController pushViewController:qrVC animated:YES];
 
            } else if (status == SGPermissionStatusDenied) {
                NSLog(@"SGPermissionStatusDenied");
                [weakSelf failed];
            } else if (status == SGPermissionStatusRestricted) {
                NSLog(@"SGPermissionStatusRestricted");
                [weakSelf unknown];
            }
        }];
}



#pragma mark ==
 

- (void)failed {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"[前往：设置 - 隐私 - 相机 - SGQRCode] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertA];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertC animated:YES completion:nil];
    });
}
- (void)unknown {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertC addAction:alertA];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertC animated:YES completion:nil];
    });
}
#pragma mark ===
- (void)getQrStr:(NSString *)res WithIsPosBool:(BOOL)isPos{
    self.tabBarController.tabBar.hidden = YES;//扫码pos后显示了tabbar 主动隐藏tabbar
    if (res.length == 0) {
        Y_SVP_SHOW_INFO_MES(@"不符合规则的二维码！");
        return;
    }else{
    }
    if (isPos == YES) {
        self.posSave = [CigarQRTool rRStr_GetPosWithStr:res];//1
        if (self.posSave.length<=0) {
            Y_SVP_SHOW_INFO_MES(@"没有识别到位置信息！");
            return;
        }
    
    } else {
        self.codeSave = [CigarQRTool rRStr_GetProductWithStr:res];//0
        if (self.codeSave.length<=0) {
            Y_SVP_SHOW_INFO_MES(@"没有识别到产品码信息！");
            return;
        }
    }
    [self.tableView reloadData];
    NSLog(@" res  -%@",  res);
    
}


@end
