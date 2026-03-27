//
//  HealthHeartTotalVc.m
//  Community
//
//  Created by 余莹 on 2021/11/24.
//

#import "HealthHeartTotalVc.h"
#import "HealthBaseDataManager.h"
#import "HealthTempHeader.h"
#import "RSA.h"
#define  Height_Row              (30)
#define  Height_SectionHeader    (40)

@interface HealthHeartTotalVc () <UITableViewDelegate,UITableViewDataSource>
 
@end

@implementation HealthHeartTotalVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"心率";
    [self newTextConnectWithHeaderTopV];
    [self.tableView reloadData];
}
 
 
- (void)newTextConnectWithHeaderTopV{
    self.tableViewHeaderView.text = @"心率异常记录";
}
- (void)getOneDayData{
    WEAKSELF
    [[HealthBaseDataManager share]getUserHeartOneDayDataWithUserId:self.nowUserId withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            weakSelf.saveOneDayModel = [HealthGetTempOrHeartOneDayModel mj_objectWithKeyValues:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf reUpMainLinesView];
            });
        }
    }];
    
    [[HealthBaseDataManager share]getUserHeartOneDayAbnormalDataWithUserId:self.nowUserId withBlock:^(NSArray * _Nonnull arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            self.tableViewDataSourceArr = [HealthGetAllAbnormalModel mj_objectArrayWithKeyValuesArray:arr];
            [self changeTouchStausWithSectionCount];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}
- (void)getOneWeakData{
    WEAKSELF
    [[HealthBaseDataManager share]getUserHeartOneWeakDataWithUserId:self.nowUserId withWeakPageTurnIndexNum:self.weakPageTurnIndexNum withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            self.saveOneWeakModel = [HealthGetTempOrHeartOneWeakModel mj_objectWithKeyValues:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf reUpMainLinesView];
            });
        }
    }];
    
    [[HealthBaseDataManager share]getUserHeartOneWeakAbnormalDataWithUserId:self.nowUserId  withWeakPageTurnIndexNum:self.weakPageTurnIndexNum withBlock:^(NSArray * _Nonnull arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            if (self.weakPageTurnIndexNum == -1) {
                self.tableViewDataSourceArr = [HealthGetAllAbnormalModel mj_objectArrayWithKeyValuesArray:arr];
            }else{
                [self.tableViewDataSourceArr  addObjectsFromArray: [HealthGetAllAbnormalModel mj_objectArrayWithKeyValuesArray:arr]];
            }
            [self changeTouchStausWithSectionCount];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
 
    
}
- (void)getOneMonthData{
    WEAKSELF
    [[HealthBaseDataManager share]getUserHeartOneMonthDataWithUserId:self.nowUserId withMonthPageTurnIndexNum:self.monthPageTurnIndexNum withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            self.saveOneMonthModel = [HealthGetTempOrHeartOneMonthModel mj_objectWithKeyValues:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf reUpMainLinesView];
            });
        }
    }];
    [[HealthBaseDataManager share]getUserHeartOneMonthAbnormalDataWithUserId:self.nowUserId  withMonthPageTurnIndexNum:self.monthPageTurnIndexNum withBlock:^(NSArray * _Nonnull arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            if (self.monthPageTurnIndexNum == -1) {
                self.tableViewDataSourceArr = [HealthGetAllAbnormalModel mj_objectArrayWithKeyValuesArray:arr];
            }else{
                [self.tableViewDataSourceArr  addObjectsFromArray: [HealthGetAllAbnormalModel mj_objectArrayWithKeyValuesArray:arr]];
            }
            [self changeTouchStausWithSectionCount];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}
- (void)changeTouchStausWithSectionCount{

    self.saveTableViewDataSourceArrTouchStatus = [NSMutableArray arrayWithCapacity:0];//清空原本数据
    for (int i = 0; i < self.tableViewDataSourceArr.count; i++) {
        [self.saveTableViewDataSourceArrTouchStatus addObject:@(0)];
    }
}
- (void)touchSectionHeaderViewWithSectionNum:(NSInteger)section{
    if ( [[self.saveTableViewDataSourceArrTouchStatus objectAtIndex:section] intValue] == 0) {
        [self.saveTableViewDataSourceArrTouchStatus  replaceObjectAtIndex:section withObject:@(1)];
    }else{
        [self.saveTableViewDataSourceArrTouchStatus  replaceObjectAtIndex:section withObject:@(0)];
    }
}
#pragma mark === 折线图
- (void)reUpMainLinesView{
    switch (self.topViewChooseType) {
        case TempAndHeartTotalTopView_SubBtn_Choose_Type_ThisDay:
        {
            [self.mainLinesView fillHeartDayTypeWithData:self.saveOneDayModel];
        }
            break;
        case TempAndHeartTotalTopView_SubBtn_Choose_Type_ThisWeak:
        {
            [self.mainLinesView fillHeartWeakTypeWithData:self.saveOneWeakModel];
        }
            break;
        case TempAndHeartTotalTopView_SubBtn_Choose_Type_ThisMonth:
        {
            [self.mainLinesView fillHeartMonthTypeWithData:self.saveOneMonthModel];
        }
            break;
            
        default:
            break;
    }
    
    
}
#pragma mark === 异常纪录
#pragma mark == == == == == == == == == ==
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tableViewDataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([self.saveTableViewDataSourceArrTouchStatus[section] boolValue]) {//已经记录为1时做全部显示
        HealthGetAllAbnormalModel *model = self.tableViewDataSourceArr[section];
        return model.list.count;
    }else{
        return 0;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return Height_Row;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Height_SectionHeader;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HealthGetAllAbnormalModel *model = self.tableViewDataSourceArr[section];
    HealthTempAndHeartBaseTotalAbnormalSectionHeaderView *hv = [[HealthTempAndHeartBaseTotalAbnormalSectionHeaderView alloc]initWithFrame:CGRectZero];
    hv.titleL.text = [TextShowWithModelStr textShowWithModelStr:model.timeTitle];//时间数据
    hv.rightBtn.selected = [self.saveTableViewDataSourceArrTouchStatus[section] boolValue];//箭头上下
    WEAKSELF
    hv.touchSubBtnBlcok = ^{
        [weakSelf touchSectionHeaderViewWithSectionNum:section];
        //[tableView reloadSections: [NSIndexSet indexSetWithIndex:section]  withRowAnimation:UITableViewAutomaticDimension];//刷新本组
        [tableView reloadData];//刷新全部 使其暂无展位图隐掉
    };
    return hv;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HealthTempOrHeartAbnormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HealthTempOrHeartAbnormalTableViewCell_Identifier];
    if (!cell) {
        cell = [[HealthTempOrHeartAbnormalTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HealthTempOrHeartAbnormalTableViewCell_Identifier];
    }
    HealthGetAllAbnormalModel *model = self.tableViewDataSourceArr[indexPath.section];
    HealthGetOneAbnormalModel *oneObj = model.list[indexPath.row];
    [cell fillDataWithHeartAbnormalModel:oneObj];
    return cell;
}


/**
 - (void)rsaTest{
     NSString *pubkey = @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI2bvVLVYrb4B0raZgFP60VXY\ncvRmk9q56QiTmEm9HXlSPq1zyhyPQHGti5FokYJMzNcKm0bwL1q6ioJuD4EFI56D\na+70XdRz1CjQPQE3yXrXXVvOsmq9LsdxTFWsVBTehdCmrapKZVVx6PKl7myh0cfX\nQmyveT/eqyZK1gYjvQIDAQAB\n-----END PUBLIC KEY-----";
     NSString *privkey = @"-----BEGIN PRIVATE KEY-----\nMIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMMjZu9UtVitvgHS\ntpmAU/rRVdhy9GaT2rnpCJOYSb0deVI+rXPKHI9Aca2LkWiRgkzM1wqbRvAvWrqK\ngm4PgQUjnoNr7vRd1HPUKNA9ATfJetddW86yar0ux3FMVaxUFN6F0KatqkplVXHo\n8qXubKHRx9dCbK95P96rJkrWBiO9AgMBAAECgYBO1UKEdYg9pxMX0XSLVtiWf3Na\n2jX6Ksk2Sfp5BhDkIcAdhcy09nXLOZGzNqsrv30QYcCOPGTQK5FPwx0mMYVBRAdo\nOLYp7NzxW/File//169O3ZFpkZ7MF0I2oQcNGTpMCUpaY6xMmxqN22INgi8SHp3w\nVU+2bRMLDXEc/MOmAQJBAP+Sv6JdkrY+7WGuQN5O5PjsB15lOGcr4vcfz4vAQ/uy\nEGYZh6IO2Eu0lW6sw2x6uRg0c6hMiFEJcO89qlH/B10CQQDDdtGrzXWVG457vA27\nkpduDpM6BQWTX6wYV9zRlcYYMFHwAQkE0BTvIYde2il6DKGyzokgI6zQyhgtRJ1x\nL6fhAkB9NvvW4/uWeLw7CHHVuVersZBmqjb5LWJU62v3L2rfbT1lmIqAVr+YT9CK\n2fAhPPtkpYYo5d4/vd1sCY1iAQ4tAkEAm2yPrJzjMn2G/ry57rzRzKGqUChOFrGs\nlm7HF6CQtAs4HC+2jC0peDyg97th37rLmPLB9txnPl50ewpkZuwOAQJBAM/eJnFw\nF5QAcL4CYDbfBKocx82VX/pFXng50T7FODiWbbL4UnxICE0UBFInNNiWJxNEb6jL\n5xd0pcy9O2DOeso=\n-----END PRIVATE KEY-----";
 //公钥加密 私钥解密
     NSString *encrypted = [RSA encryptString:@"Rsa_Test___hello world!" publicKey:pubkey];
     NSLog(@"encrypted加密: %@", encrypted);
     NSString *decrypted = [RSA decryptString:encrypted privateKey:privkey];
     NSLog(@"decrypted解密: %@", decrypted);
 }
 */



@end
