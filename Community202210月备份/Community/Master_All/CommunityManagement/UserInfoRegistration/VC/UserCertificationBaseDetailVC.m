//
//  UserCertificationBaseVC.m
//  Community
//
//  Created by 余莹 on 2021/2/24.
//

#import "UserCertificationBaseDetailVC.h"
#import "UserFamilAllModel.h"
@interface UserCertificationBaseDetailVC () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ChooseGenderViewDelegate,PopViewRelationshipDelegate,PopViewCarTypeDelegate>

@end

@implementation UserCertificationBaseDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark == Getter
//
- (UIButton *)okBtn{
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _okBtn.frame = CGRectMake(10, 30, Screen_W-52, 44);
        _okBtn.frame = CGRectMake(0, 30, 0, 44);
        [_okBtn setBackgroundColor:Color_Blue];
        [_okBtn setTitle:@"提交信息" forState:UIControlStateNormal];
        [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_okBtn addTarget:self action:@selector(okBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _okBtn.layer.cornerRadius = 22;
        _okBtn.layer.masksToBounds = YES;
    }
    return _okBtn;
}
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UserCertificationHeaderView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 280)];
    }
    return _headerView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = self.okBtn;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

#pragma mark ==
- (ChooseGenderView *)chooseGenderView{
    if (!_chooseGenderView) {
        _chooseGenderView = [[ChooseGenderView alloc]initWithFrame:self.view.frame];
        _chooseGenderView.hidden = YES;
        _chooseGenderView.delegate = self;
    }
    return _chooseGenderView;
}
//- (ChooseCarTypeView *)chooseCarTypeView{
//    if (!_chooseCarTypeView) {
//        _chooseCarTypeView = [[ChooseCarTypeView alloc]initWithFrame:self.view.frame];
//        _chooseCarTypeView.hidden = YES;
//    }
//    return _chooseCarTypeView;
//}
#pragma mark == pop view
- (PopViewRelationship *)popViewRelationship{
    _popViewRelationship = [[PopViewRelationship alloc]init];
    _popViewRelationship.delegate = self;
    return _popViewRelationship;
}
- (PopViewCarType *)popviewCarType{
    _popviewCarType = [[PopViewCarType alloc]init];
    _popviewCarType.delegateOfCarType = self;
    return _popviewCarType;
}
#pragma mark== 赋值 num
- (NSInteger)nowPopViewChooseHouseWithRowNum{
    if (!_nowPopViewChooseHouseWithRowNum) {
        _nowPopViewChooseHouseWithRowNum = 0;
    }
    return _nowPopViewChooseHouseWithRowNum;
}
- (NSInteger)nowPopViewChooseCarTypeWithSectionNum{
    if (!_nowPopViewChooseCarTypeWithSectionNum) {
        _nowPopViewChooseCarTypeWithSectionNum = 0;
    }
    return _nowPopViewChooseCarTypeWithSectionNum;
}
- (NSInteger)nowPopViewChooseCarIdWithSectionNum{
    if (!_nowPopViewChooseCarIdWithSectionNum) {
        _nowPopViewChooseCarIdWithSectionNum = 0;
    }
    return _nowPopViewChooseCarIdWithSectionNum;
}
- (NSInteger)nowPopViewChooseCarImgWithSectionNum{
    if (!_nowPopViewChooseCarImgWithSectionNum) {
        _nowPopViewChooseCarImgWithSectionNum = 0;
    }
    return _nowPopViewChooseCarImgWithSectionNum;
}
- (NSMutableArray<UIImage *> *)saveCarImgArr{
    if (!_saveCarImgArr) {
        _saveCarImgArr = [NSMutableArray array];
        UIImage *carImg = [UIImage new];
        [_saveCarImgArr addObject:carImg];
    }
    return _saveCarImgArr;
}

#pragma mark == 个人信息
- (NSMutableArray *)titleArrSectionOne{
    if (!_titleArrSectionOne) {
        _titleArrSectionOne = [NSMutableArray arrayWithObjects:@"姓名",@"性别",@"身份证号",@"所属单元",nil];
    }
    return _titleArrSectionOne;
}
- (NSMutableArray *)textFieldPlaceholderArrOne{
    if (!_textFieldPlaceholderArrOne) {
        _textFieldPlaceholderArrOne = [NSMutableArray arrayWithObjects:@"请输入姓名",@"请选择",@"请输入身份证号",@"请选择",nil];
    }
    return _textFieldPlaceholderArrOne;
}
- (NSMutableArray *)textFieldTextArrSectionOne{
    if (!_textFieldTextArrSectionOne) {
        _textFieldTextArrSectionOne = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",nil];
    }
    return _textFieldTextArrSectionOne;
}
#pragma mark ==//家属
- (NSMutableArray *)titleArrSectionOneOfOtherUser{
    if (!_titleArrSectionOneOfOtherUser) {
        _titleArrSectionOneOfOtherUser = [NSMutableArray arrayWithObjects:@"姓名",@"性别",@"电话",@"身份证号",@"业主关系",@"所属单元",nil];

    }
    return _titleArrSectionOneOfOtherUser;
}
- (NSMutableArray *)textFieldPlaceholderArrOneOfOtherUser{
    if (!_textFieldPlaceholderArrOneOfOtherUser) {
        _textFieldPlaceholderArrOneOfOtherUser = [NSMutableArray arrayWithObjects:@"请输入姓名",@"请选择",@"请输入电话",@"请输入身份证号",@"请选择",@"已默认业主房屋",nil];
    }
    return _textFieldPlaceholderArrOneOfOtherUser;
}
- (NSMutableArray *)textFieldTextArrSectionOneOfOtherUser{
    if (!_textFieldTextArrSectionOneOfOtherUser) {
        _textFieldTextArrSectionOneOfOtherUser = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",nil];
    }
    return _textFieldTextArrSectionOneOfOtherUser;
}
#pragma mark == 房屋信息

- (NSMutableArray *)titleArrSectionHouse{
    if (!_titleArrSectionHouse) {
        _titleArrSectionHouse = [NSMutableArray arrayWithObjects:@"所属房屋",nil];
    }
    return _titleArrSectionHouse;
}
- (NSMutableArray *)textFieldPlaceholderArrHouse{
    if (!_textFieldPlaceholderArrHouse) {
        _textFieldPlaceholderArrHouse = [NSMutableArray arrayWithObjects:@"请选择",nil];
    }
    return _textFieldPlaceholderArrHouse;
}
#pragma mark == 车辆信息
- (NSMutableArray *)titleArrSectionCar{
    if (!_titleArrSectionCar) {
        _titleArrSectionCar = [NSMutableArray arrayWithObjects:@"车牌号",@"车辆类型",@"行驶证图片",@"删除车辆",nil];
    }
    return _titleArrSectionCar;
}
- (NSMutableArray *)textFieldPlaceholderArrCar{
    if (!_textFieldPlaceholderArrCar) {
        _textFieldPlaceholderArrCar = [NSMutableArray arrayWithObjects:@"请输入车牌号或拍照识别",@"请选择",@"添加图片",nil];
    }
    return _textFieldPlaceholderArrCar;
}
 
#pragma mark ==houseAddressModelArr;//业主用的OK的model存放区域 ---家属的另有
- (UserInfoRegistAllInfoWillSubmitModel *)okModel{
    if (!_okModel) {
        _okModel = [[UserInfoRegistAllInfoWillSubmitModel alloc]init];
    }
    return _okModel;
}
#pragma mark ==houseAddressModelArr;//房屋信息的model存放区域
- (NSMutableArray *)houseAddressModelArr{
    if (!_houseAddressModelArr) {
        _houseAddressModelArr = [NSMutableArray array];
        UserCertificationHouserModel *model = [[UserCertificationHouserModel alloc]init];
        [_houseAddressModelArr addObject:model];
    }
    return _houseAddressModelArr;
}
#pragma mark ==carInfoModelArr;//车辆信息的数字存放区域
- (NSMutableArray *)carInfoModelArr{
    if (!_carInfoModelArr) {
        _carInfoModelArr = [[NSMutableArray alloc]init];
        if(self.type == CertificationVc_Type_OtherUser_ReEdit || self.type == CertificationVc_Type_OtherUser_Add){//
            UserFamilAllModelOfCarsModel *model = [[UserFamilAllModelOfCarsModel alloc]init];
            [_carInfoModelArr addObject:model];
        }else{
            CarEntityModel *model = [[CarEntityModel alloc]init];
            [_carInfoModelArr addObject:model];
        }
    }
    return _carInfoModelArr;
}
@end
