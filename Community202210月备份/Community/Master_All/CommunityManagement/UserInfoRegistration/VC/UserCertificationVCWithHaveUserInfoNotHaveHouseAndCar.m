//
//  UserInfoRegistVCWithNotUserInfoOnlyHaveHouseAndCar.m
//  Community
//
//  Created by 余莹 on 2021/2/23.
// 主页详情页 add情况时（只有实名过 未有房屋）时1使用

#import "UserCertificationVCWithHaveUserInfoNotHaveHouseAndCar.h"

@interface UserCertificationVCWithHaveUserInfoNotHaveHouseAndCar ()

@end

@implementation UserCertificationVCWithHaveUserInfoNotHaveHouseAndCar

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = [UIView new];//弃用人脸识别headerview 只有个人信息数据
    [self initUserInfoData];
}
- (void)initUserInfoData{
    Y_SVP_SHOW_MES_IsLoading_15Delay
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_User_Certifition_SelfDetail  withParams:@{}.mutableCopy  finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            [self.tableView.mj_header endRefreshing];
        });
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                //
                self.mainUserModel = [UserInfoRegistModel mj_objectWithKeyValues:[NSDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic]];
                self.okModel.realName = [TextShowWithModelStr textShowWithModelStr: self.mainUserModel.realName];
                self.okModel.sex = self.mainUserModel.sex;
                self.okModel.idCard = self.mainUserModel.idCard;
                self.okModel.houseEntityList =  [NSMutableArray arrayWithArray:self.mainUserModel.proprietorHouses];;
                self.okModel.carEntityList =  [NSMutableArray arrayWithArray:self.mainUserModel.proprietorCars];
                //显示用的oneSection数据
                self.textFieldTextArrSectionOne[Cell_Name_TextFieldTextArr_SectionOne_RowNum] = [TextShowWithModelStr textShowWithModelStr: self.mainUserModel.realName];
                self.textFieldTextArrSectionOne[Cell_Gender_TextFieldTextArr_SectionOne_RowNum] = [self genderTextWithSex:self.mainUserModel.sex];
                self.textFieldTextArrSectionOne[Cell_IdCard_TextFieldTextArr_SectionOne_RowNum] = [TextShowWithModelStr textShowWithModelStr:self.mainUserModel.idCard];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
      
    }];
}
//性别文本
- (NSString *)genderTextWithSex:(NSInteger)sex{
    switch (sex) {
        case Choose_Gender_unknown:
            return Str_Gender_Nomal;
            break;
        case Choose_Gender_man:
            return Str_Boy;
            break;
        case Choose_Gender_woman:
            return Str_Girl;
            break;
        default:
            return Str_Gender_Nomal;
            break;
    }
}
@end
