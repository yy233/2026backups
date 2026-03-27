//
//  MyEditWithAddHouseVC.m
//  Community
//
//  Created by 余莹 on 2021/8/19.
//

#import "MyEditWithAddHouseVC.h"
#import "MyEditHouseSubUserConfirmVc.h"

@interface MyEditWithAddHouseVC ()

@end

@implementation MyEditWithAddHouseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)footerBtnAction:(UIButton *)sender{//提交全部信息
    if (isNil(self.saveChooseEndUserInfoModelUseLateVcAddHouse)) {
        Y_SVP_SHOW_ERR_MES(@"数据不完整!")
//        return;
    }
    CommunityModel *cmodel = [self.saveChooseEndUserInfoModelUseLateVcAddHouse objectForKey:@"C"];
    AddressModel *hmodel = [self.saveChooseEndUserInfoModelUseLateVcAddHouse objectForKey:@"H"];
    NSMutableDictionary *houseInfo = [[NSMutableDictionary alloc]init];
    [houseInfo setValue:@(cmodel.ID) forKey:@"communityId"];
    [houseInfo setValue:@(hmodel.ID) forKey:@"houseId"];
  
    MyEditHouseSubUserConfirmVc *vc = [[MyEditHouseSubUserConfirmVc alloc]init];
    vc.nowChooseCommunityId = cmodel.ID;
    vc.nowChooseHouseId = hmodel.ID;
    [self pushVc:vc];
}
@end
