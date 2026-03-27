//
//  ElectroniNewRealNameAuthenticationFaceVc.m
//  Community
//
//  Created by 余莹 on 2021/2/24.
//

#import "ElectroniNewRealNameAuthenticationFaceVc.h"
#import "ElectroniNewRealNameAuthenticationFaceCenterBtnTableViewCell.h"
#define ElectroniNewRealNameAuthenticationFaceCenterBtnTableViewCell_Identifier @"ElectroniNewRealNameAuthenticationFaceCenterBtnTableViewCell"
#import "ElectroniNewRealNameAuthenticationFaceOtherBtnTableViewCell.h"
#define ElectroniNewRealNameAuthenticationFaceOtherBtnTableViewCell_Identifier @"ElectroniNewRealNameAuthenticationFaceOtherBtnTableViewCell"

#import "ElectroniNewRealNameAuthenticationSuccessVc.h"

//
#import "RealNameAuthenticationViewModel.h"

@interface ElectroniNewRealNameAuthenticationFaceVc () <RealNameAuthenticationFaceCellDelegagte>

@end

@implementation ElectroniNewRealNameAuthenticationFaceVc

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

    Y_SVP_SHOW_MES_IsDealing_15Delay;
    [[RealNameAuthenticationViewModel realNameAuthenticationViewModelShare] willFaceCerWithResultDicJsonData:self.getCerJsonStr andCerDetailAddress:self.cerAddress withUIVc:self withDicBlock:^(NSDictionary * dic, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            NSDictionary *dicData = [[dic allKeys] containsObject:@"data"] ? [dic objectForKey:@"data"] : @{};
            if (dicData.allKeys.count>0) { //___有deta一层时
                [self dealGetDic:dicData];
            }else{//__无data的一层直接用dic
                [self dealGetDic:dic];
            }
        }else{
            Y_SVP_SHOW_ERR_MES(@"认证失败");
        }
    }];
}
- (void)dealGetDic:(NSDictionary *)dicData{
    NSString *endCode = [[dicData allKeys] containsObject:@"code"] ? [NSString stringWithFormat:@"%@",[dicData objectForKey:@"code"]] : @"";
    NSString *endMsg = [[dicData allKeys] containsObject:@"msg"] ? [NSString stringWithFormat:@"%@",[dicData objectForKey:@"msg"]] : @"";
    
    if ([endCode isEqualToString: @"0000"] ) {//认证成功
        if (endMsg.length>0) {
            Y_SVP_SHOW_SUCCESS_MES(endMsg);
        }
        //_____success
        [self goSuccessVc];
    }else{//认证失败
        if (endMsg.length>0) {
            Y_SVP_SHOW_ERR_MES(endMsg);
        }
    }
    DLog(@"%@",dicData);
}
- (void)goSuccessVc{
    dispatch_async(dispatch_get_main_queue(), ^{
        ElectroniNewRealNameAuthenticationSuccessVc *vc = [[ElectroniNewRealNameAuthenticationSuccessVc alloc]init];
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
        ElectroniNewRealNameAuthenticationFaceCenterBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ElectroniNewRealNameAuthenticationFaceCenterBtnTableViewCell_Identifier];
        if (!cell) {
            cell = [[ElectroniNewRealNameAuthenticationFaceCenterBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ElectroniNewRealNameAuthenticationFaceCenterBtnTableViewCell_Identifier];
        }
        cell.delegate = self;
        return cell;
    }else{
        ElectroniNewRealNameAuthenticationFaceOtherBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ElectroniNewRealNameAuthenticationFaceOtherBtnTableViewCell_Identifier];
        if (!cell) {
            cell = [[ElectroniNewRealNameAuthenticationFaceOtherBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ElectroniNewRealNameAuthenticationFaceOtherBtnTableViewCell_Identifier];
       
        }
        return cell;
    }
}

@end
