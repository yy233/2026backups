//
//  ElectroniNewRealNameAuthenticationFaceVc.m
//  Community
//
//  Created by 余莹 on 2021/2/24.
//

#import "ZYElectroniNewRealNameAuthenticationFaceVc.h"
#import "ZYElectroniNewRealNameAuthenticationFaceCenterBtnTableViewCell.h"
#define ElectroniNewRealNameAuthenticationFaceCenterBtnTableViewCell_Identifier @"ZYElectroniNewRealNameAuthenticationFaceCenterBtnTableViewCell"
#import "ZYElectroniNewRealNameAuthenticationFaceOtherBtnTableViewCell.h"
#define ElectroniNewRealNameAuthenticationFaceOtherBtnTableViewCell_Identifier @"ZYElectroniNewRealNameAuthenticationFaceOtherBtnTableViewCell"

#import "ZYElectroniNewRealNameAuthenticationSuccessVc.h"
#import "ZYElectroniNewRealNameAuthenticationFailVc.h"

//
#import "ZYRealNameAuthenticationViewModel.h"

@interface ZYElectroniNewRealNameAuthenticationFaceVc () <ZYRealNameAuthenticationFaceCellDelegagte>

@end

@implementation ZYElectroniNewRealNameAuthenticationFaceVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self upUI];
}
- (void)upUI{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.footerView.footerBtn newAnBtnWithTextStr:@"采集面部数据"];
    [self.headerView setHeaderViewType:ElectroniRealNameAuthenticationHeaderView_Type_Face];
}
#pragma mark ==
- (void)cellSubCenterBtnTouch{
    [self nextAction];
}
#pragma mark ==  采集面部数据
- (void)nextAction{
    WEAKSELF
    Y_SVP_SHOW_MES_IsDealing_15Delay;
    [[ZYRealNameAuthenticationViewModel realNameAuthenticationViewModelShare] willFaceCerWithResultDicJsonData:self.getCerJsonStr andCerDetailAddress:self.cerAddress withUIVc:self withDicBlock:^(NSDictionary * dic, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            NSDictionary *dicData = [[dic allKeys] containsObject:@"data"] ? [dic objectForKey:@"data"] : @{};
            if (dicData.allKeys.count>0) { //___有deta一层时
                [weakSelf dealGetDic:dicData];
            }else{//__无data的一层直接用dic
                [weakSelf dealGetDic:dic];
            }
        }else{
           
            dispatch_async(dispatch_get_main_queue(), ^{
                //Y_SVP_SHOW_ERR_MES(@"认证失败");
                ZYElectroniNewRealNameAuthenticationFailVc *vc = [[ZYElectroniNewRealNameAuthenticationFailVc alloc] init];
                [weakSelf pushVc:vc];
            });
     
        }
    }];
}
- (void)dealGetDic:(NSDictionary *)dicData{
    NSString *endCode = [[dicData allKeys] containsObject:@"code"] ? [NSString stringWithFormat:@"%@",[dicData objectForKey:@"code"]] : @"";
    NSString *endMsg = [[dicData allKeys] containsObject:@"msg"] ? [NSString stringWithFormat:@"%@",[dicData objectForKey:@"msg"]] : @"";
    
    if ([endCode isEqualToString: @"0000"] ) {//认证成功
        //_____success
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:@"1" forKey:@"isRealNameElectronicSignature"];
        [userDefaults synchronize];
        [ShareUserInfo sharedUserInfo].userInfo.realName = self.realName;
        [ShareUserInfo sharedUserInfo].userInfo.isRealAuth = 2;
        [self goSuccessVc];
    }else{//认证失败
        dispatch_async(dispatch_get_main_queue(), ^{
            //Y_SVP_SHOW_ERR_MES(@"认证失败");
            ZYElectroniNewRealNameAuthenticationFailVc *vc = [[ZYElectroniNewRealNameAuthenticationFailVc alloc] init];
            [self pushVc:vc];
        });
    }
    DLog(@"%@",dicData);
}
- (void)goSuccessVc{
    dispatch_async(dispatch_get_main_queue(), ^{
        ZYElectroniNewRealNameAuthenticationSuccessVc *vc = [[ZYElectroniNewRealNameAuthenticationSuccessVc alloc]init];
        // 发送通知
        Y_NSNotificationCenter_PostNotice_HaveObject_Name(@"SIGNING_DETAIL_REALNAME_BACK", nil)
        [self pushVc:vc];
    });
}
#pragma mark ==
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"%ld",(long)indexPath.row);
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 280;
    }else{
        return 160;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ZYElectroniNewRealNameAuthenticationFaceCenterBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ElectroniNewRealNameAuthenticationFaceCenterBtnTableViewCell_Identifier];
        if (!cell) {
            cell = [[ZYElectroniNewRealNameAuthenticationFaceCenterBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ElectroniNewRealNameAuthenticationFaceCenterBtnTableViewCell_Identifier];
        }
        cell.delegate = self;
        return cell;
    }else{
        ZYElectroniNewRealNameAuthenticationFaceOtherBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ElectroniNewRealNameAuthenticationFaceOtherBtnTableViewCell_Identifier];
        if (!cell) {
            cell = [[ZYElectroniNewRealNameAuthenticationFaceOtherBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ElectroniNewRealNameAuthenticationFaceOtherBtnTableViewCell_Identifier];
       
        }
        return cell;
    }
}

@end
