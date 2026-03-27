//
//  UserCertificationViewController.m
//  Community
//  业主认证 多个类型的 详情页面 —
//  Created by 余莹 on 2020/11/20.
//

#import "UserCertificationViewController.h"




@interface UserCertificationViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ChooseGenderViewDelegate,PopViewRelationshipDelegate,PopViewCarTypeDelegate,UserCertificationCarInfoDeletTableViewCellDelegate>

@end

@implementation UserCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initDataWithEditOrShow];
    [self initNoticeWithDetailedAddressInfo];
}
- (void)initView{
    self.carIsAllShow = YES;
    [self.view addSubview:self.tableView];
    if (self.type == CertificationVc_Type_OtherUser_Add) {//添加家属
        self.tableView.tableHeaderView = [UIView new];
        self.title = @"添加家属";
    }else if (self.type == CertificationVc_Type_OtherUser_ReEdit) {
        self.tableView.tableHeaderView = [UIView new];
        self.title = @"修改家属";
    }else{
        self.tableView.tableHeaderView = self.headerView;
        self.title = @"房屋认证";
    }

    [self.view addSubview:self.chooseGenderView];
    [self setUI];
}
- (void)setUI{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableView.superview).insets(UIEdgeInsetsMake(10, 16, 10, 16));
    }];
}
#pragma mark == notice_ AddressInfo_  总信息 AllInfoPost 更改了 userInfo
- (void)initNoticeWithDetailedAddressInfo{
    Y_NSNotificationCenter_Creat_NameAction(Notice_name_AddressAllInfoPost, noticeActionWithDetailedAddressInfo:)
}
- (void)noticeActionWithDetailedAddressInfo:(NSNotification *)notice{
    NSLog(@"-------notice DetailedAddressInfo ==%@=%@",notice.object,notice.userInfo);
    NSDictionary *userinfoDic = notice.userInfo;
    NSArray *modelArr = [NSMutableArray arrayWithArray:[userinfoDic objectForKey:@"userInfo"]];
    CommunityModel *communityModel =  [[CommunityModel alloc]init];
    AddressModel *addressModel = [[AddressModel alloc]init];
    for (int i = 0; i < modelArr.count; i ++) {
        if ([modelArr[i] isKindOfClass:[CommunityModel class]]) {
            communityModel = modelArr[i];
        }
        if ([modelArr[i] isKindOfClass:[AddressModel class]]) {
            addressModel = modelArr[i];
        }
    }
    self.okModel.detailAddress =  [NSString stringWithFormat:@"%@ %@",[TextShowWithModelStr textShowWithModelStr:communityModel.name],[TextShowWithModelStr textShowWithModelStr:addressModel.door]];
   
    //房屋信息  -----------------------------------------
    UserCertificationHouserModel *model = self.houseAddressModelArr[self.nowPopViewChooseHouseWithRowNum];//存入or更换
    if (isNil(model)) {//存入or更换 无数据则新增 初始化 （新用户）
        model = [[UserCertificationHouserModel alloc]init];
        [self.houseAddressModelArr addObject: model];
    }
    if (model.id!=0) {
    }else{
        model.id = 0;//设置空id  用于后端进行 区分旧数据修改or新数据新增。----------------暂待讨论
    }
    model.communityName = [TextShowWithModelStr textShowWithModelStr:communityModel.name];
    model.door = [TextShowWithModelStr textShowWithModelStr:addressModel.door];
    model.houseId = addressModel.ID;//门牌id
    model.communityId = communityModel.ID;

    [self reloadHouseRowsWithRowIndex:self.nowPopViewChooseHouseWithRowNum];
 
}
- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(@"noticeActionWithDetailedAddressInfo");
}
#pragma mark ==========initData 查看 或 修改 状态时
- (void)initDataWithEditOrShow{
    if (self.type==CertificationVc_Type_MainUser_ReEdit) {//业主 编辑状态时
        Y_SVP_SHOW_MES_IsLoading_15Delay
        [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_User_Certifition_SelfDetail  withParams:@{}.mutableCopy  finished:^(id responsObject, NSError *error) {
//        [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_User_Certifition_SelfDetail  withParams:@{}.mutableCopy  finished:^(id responsObject, NSError *error) {
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
                    //房屋
                    self.houseAddressModelArr = [NSMutableArray arrayWithArray:[UserCertificationHouserModel mj_objectArrayWithKeyValuesArray:self.mainUserModel.proprietorHouses]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        Y_SVP_DISMISS
                        [self.tableView reloadData];
                    });
                    //车辆
                    if (self.mainUserModel.proprietorCars.count==0) {//保持 1行空图的车辆初始化数据
                        return;
                    }
                    self.saveCarImgArr = [NSMutableArray array];
                    self.carInfoModelArr = [NSMutableArray arrayWithArray: [CarEntityModel mj_objectArrayWithKeyValuesArray:self.mainUserModel.proprietorCars]];
                    if (self.carInfoModelArr.count==0) {//待梳理流程
                    }
               
                    //图片数据
                    for (int  i = 0; i < self.carInfoModelArr.count; i ++) {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            CarEntityModel *model  =  self.carInfoModelArr[i];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UIImage *carImg = [ImageGetWithString getImageFromURLStr:model.drivingLicenseUrl];//行驶证
                                [self.saveCarImgArr addObject:isNotNil(carImg)?carImg:[UIImage new]];//空图片
                            });
                        
//                            //test
//                            NSString *testStr = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1608296478508&di=52ab073bc87d1b8374e237b76063ff14&imgtype=0&src=http%3A%2F%2Fimage.biaobaiju.com%2Fuploads%2F20191102%2F14%2F1572677897-aAxqIpoFOV.jpg";
//                            UIImage *carImg = [ImageGetWithString getImageFromURLStr:testStr];
//                            if (isNotNil(carImg)) {
//                                [self.saveCarImgArr addObject:carImg];
//                            }else{
//                                [self.saveCarImgArr addObject:[UIImage new]];
//                            }
                            if (i == self.carInfoModelArr.count-1) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    Y_SVP_DISMISS
                                    [self.tableView reloadData];
                                });
                            }
                        });
                    }
                }else{
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else{
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
          
        }];
    }
    
//    if (self.type==CertificationVc_Type_OtherUser_ReEdit) {//家属
//    }
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
#pragma mark === 提交信息
- (void)okBtnAction:(UIButton *)sender{
    //个人信息
    if (self.okModel.realName.length==0) {
        Y_SVP_SHOW_ERR_MES(@"缺少信息");
        return;
    }
    if(!self.okModel.sex || self.okModel.sex==0){
        self.okModel.sex = 0;
    }
    if (self.okModel.idCard.length == 0) {
        Y_SVP_SHOW_ERR_MES(@"缺少信息");
        return;
    }
    //判断有无 有则计入 无则不计入
    NSMutableArray *carWilSnedArr = [NSMutableArray array];
    NSMutableArray *carWilSnedModeArr = [NSMutableArray array];
    //车辆数据 //房产信息
    NSMutableArray *houseWilSnedArr = [NSMutableArray array];
    NSMutableArray *houseWilSnedModelArr = [NSMutableArray array];
    if (self.type == CertificationVc_Type_MainUser_ReEdit || self.type == CertificationVc_Type_MainUser_Add) {//___________业主
        //车
        for (int i = 0 ;i < self.carInfoModelArr.count ; i ++) {
            CarEntityModel *carModel = self.carInfoModelArr[i];
            if (carModel.drivingLicenseUrl.length>0) {//图 车辆 url str 键更改
                [carWilSnedModeArr addObject:carModel];
            }else{//无图不计入
                DLog(@"carInfoModelArr无图不计入");
            }
        }
        NSArray *userCarWillSnedKeyArr = @[];
        if (self.type == CertificationVc_Type_MainUser_Add) {
            userCarWillSnedKeyArr = @[@"drivingLicenseUrl",@"carPlate",@"carType"];//图 车辆 url str 键更改 drivingLicenseUrl carType
        }else if(self.type == CertificationVc_Type_MainUser_ReEdit){
            userCarWillSnedKeyArr = @[@"drivingLicenseUrl",@"carPlate",@"carType",@"id"];//图 车辆 url str 键更改
        }
        carWilSnedArr = [NSMutableArray arrayWithArray:[CarEntityModel mj_keyValuesArrayWithObjectArray:carWilSnedModeArr keys:userCarWillSnedKeyArr]];//业主的车辆信息 carTypeCode 待改
         //房
        for (int i = 0 ; i < self.houseAddressModelArr.count ; i ++) {
//            (UserCertificationHouserModel 用于业主和家属本vc) （UserHouseModel 只用于访客相关list） __________________________________________________ 提交的房屋信息model 待确认
            UserCertificationHouserModel *houseModel = self.houseAddressModelArr[i];//
            if (houseModel.communityName.length>0) {
                [houseWilSnedModelArr addObject:houseModel];
            }else{//无地址不计入 可能是初始化数据
            }
        }
        NSArray *userHouseWillSnedKeyArr = @[];
        if (self.type == CertificationVc_Type_MainUser_Add) {
            userHouseWillSnedKeyArr = @[@"houseId",@"communityId"];
        }else if(self.type == CertificationVc_Type_MainUser_ReEdit){
            userHouseWillSnedKeyArr = @[@"id",@"houseId",@"communityId"];
        }
        houseWilSnedArr = [NSMutableArray arrayWithArray:[UserCertificationHouserModel mj_keyValuesArrayWithObjectArray:houseWilSnedModelArr keys:userHouseWillSnedKeyArr]];
        
    }else if(self.type == CertificationVc_Type_OtherUser_ReEdit || self.type == CertificationVc_Type_OtherUser_Add){//_________家属 房产数据不计
    }
  
   //参数处理
    if (self.type == CertificationVc_Type_MainUser_ReEdit || self.type == CertificationVc_Type_MainUser_Add) {//业主
        [self isMainUserWillSendWithCarArr:carWilSnedArr houseArr:houseWilSnedArr];
    }
//    if (self.type == CertificationVc_Type_OtherUser_ReEdit || self.type == CertificationVc_Type_OtherUser_Add) {//家属
//    }
}
//业主
- (void)isMainUserWillSendWithCarArr:(NSMutableArray *)carWilSnedArr houseArr:(NSMutableArray *)houseWilSnedArr{
    BOOL hasCar = NO;
    if (carWilSnedArr.count>0) {
        hasCar = YES;
    }
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    //个人信息部分不上传 20210225更改
    [parms setValue:@(hasCar) forKey:@"hasCar"];
    [parms setValue:carWilSnedArr forKey:@"cars"];
    [parms setValue:houseWilSnedArr forKey:@"houses"];
    [self sendAllInfo:parms];
}
#pragma mark === 提交all信息
 
//业主
- (void)sendAllInfo:(NSMutableDictionary *)params{ 
   
    if (self.type == CertificationVc_Type_MainUser_Add) {
     
        [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueue:URL_User_ProprietorRegister withParams:params finished:^(id responsObject, NSError *error) {
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //存个人信息
                        UserModel *userM = [[UserModel alloc]init];
                        userM.idCard = self.okModel.idCard;
                        userM.realName =  self.okModel.realName;
                        userM.sex =  self.okModel.sex;
                        [[ShareUserInfo sharedUserInfo] saveDefaultsUserInfoRegist:userM];
                        Y_SVP_SHOW_SUCCESS_MES(@"业主信息已成功添加");
                        Y_NSNotificationCenter_PostNotice_NilObject_Name(Notice_Certifiction_MainUser_Add_Ok);
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }else{
                    Y_SVP_SHOW_ERR_MES(Y_ResponsObject_messageStr)
                }
            }else{
                
                Y_SVP_SHOW_ERR_DESCRIPTION
                
            }
        }];
    }else if(self.type == CertificationVc_Type_MainUser_ReEdit){
        [[ToolOfNetWork sharedTools] YrequestPutURLNoMainQueue:URL_User_ProprietorRegister_Change withParams:params finished:^(id responsObject, NSError *error) {
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        Y_SVP_SHOW_SUCCESS_MES(@"业主信息已修改");
                        Y_NSNotificationCenter_PostNotice_NilObject_Name(Notice_Certifiction_MainUser_Edit_OK);
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }else{
                    Y_SVP_SHOW_ERR_MES(Y_ResponsObject_messageStr)
                }
            }else{
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
        }];
    }else{
    }
    NSLog(@"okBtnAction");
}
#pragma mark == addImgBtnAction
- (void)addImgBtnAction:(UIButton *)sender{
    NSInteger cellSectionNum =  sender.tag - BTN_TAG_SectionCar_TextFieldSubVChooseBtn_CarImg;
    self.nowPopViewChooseCarImgWithSectionNum = cellSectionNum;
    [self chooseImage];
    NSLog(@"addImgBtnAction===   %ld",(long)cellSectionNum);
    
}
#pragma mark == img pick

- (void)chooseImage {
    UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
    pickVC.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    pickVC.delegate = self;
    pickVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:pickVC animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate 图片 回调
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *photo = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self imgDetalWithPhoto:photo];
}
#pragma mark === 提交img信息的 //图片上传
- (void)imgDetalWithPhoto:(UIImage *)photo{
   
    if (isNil(photo)) {
        Y_SVP_SHOW_ERR_MES(@"缺少照片信息");
        return;
    }
    Y_SVP_SHOW_MES_IsDealing_15Delay;
     [[ToolOfNetWork sharedTools]YrequestPostCarImageDataWithURL:URL_User_SendCarImg withParams:nil fileData:@[photo].mutableCopy finished:^(id responsObject, NSError *error) {
         Y_SVP_DISMISS
         if (isNotNil(responsObject)) {
             if (Y_IS_Success) {
                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                     self.saveCarImgArr[self.nowPopViewChooseCarImgWithSectionNum] = photo;//更换
                     CarEntityModel *model = self.carInfoModelArr[self.nowPopViewChooseCarImgWithSectionNum];
                     model.drivingLicenseUrl =  [NSString stringWithFormat:@"%@",[responsObject objectForKey:@"data"]];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self reloadCarImgWithSectionNum:self.nowPopViewChooseCarImgWithSectionNum];
                     });
                 });
               
             }else{
                 self.saveCarImgArr[self.nowPopViewChooseCarImgWithSectionNum] = [UIImage new];//保持原状
                 Y_SVP_SHOW_ERR_MESSAGE
             }
         }else{
             self.saveCarImgArr[self.nowPopViewChooseCarImgWithSectionNum] = [UIImage new];
             Y_SVP_SHOW_ERR_DESCRIPTION
         }
    }];
}
#pragma mark  ==== Section Footer Action 添加房屋
- (void)sectionFooterActionWithAddHouse:(UIButton *)sender{
    NSLog(@"add house");
    if (self.houseAddressModelArr.count>=50) {
        Y_SVP_SHOW_ERR_MES(@"限制房产数量最多50")
        return;
    }
    UserCertificationHouserModel *model = [[UserCertificationHouserModel alloc]init];
    [self.houseAddressModelArr addObject:model];
    [self.tableView reloadData];
}
#pragma mark  ==== sectionFooterAction  添加车辆
- (void)sectionFooterActionWithAddCar:(UIButton *)sender{
    NSLog(@"add car")
    if (self.carInfoModelArr.count>=50) {
        Y_SVP_SHOW_ERR_MES(@"限制车辆数量最多50")
        return;
    }
    CarEntityModel *model = [[CarEntityModel alloc]init];
    [self.carInfoModelArr addObject:model];
    [self.saveCarImgArr addObject:[UIImage new]];//车辆图片
    [self.tableView reloadData];
}
#pragma mark === 删除某条车辆信息
- (void)touchCarInfoDeletBtnWithCarSectionNum:(NSInteger)carSectionNum{
            CarEntityModel *model = self.carInfoModelArr[carSectionNum];
    if (isNotNil(model) && model.id != 0){
        //网络接口数据
        BOOL isMianUser = NO;
        if(self.type == CertificationVc_Type_OtherUser_ReEdit || self.type == CertificationVc_Type_OtherUser_Add){
            isMianUser = NO;
        }else{
            isMianUser = YES;
        }
        [UserCertificationDetailViewModel deletCarWithVcShowTypeBoolIsMainOrFamile:isMianUser withCarId:model.id withBlock:^(NSDictionary * dic, BOOL success) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_SUCCESS_MES(@"该车辆信息成功删除");
                });
                [self deletCarInfoWithCarSectionNum:carSectionNum];
            }
        }];
    }else if(model.carPlate.length<=0 && carSectionNum==0){
        Y_SVP_SHOW_ERR_MES(@"车辆待新增占位,不可删除");
        return;
    }else{
        [self deletCarInfoWithCarSectionNum:carSectionNum];
    }
}
- (void)deletCarInfoWithCarSectionNum:(NSInteger)carSectionNum{
    [self.carInfoModelArr removeObjectAtIndex:carSectionNum];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (carSectionNum == 0) {
            NSInteger willRfSectionNum = 0;
            if (self.type == CertificationVc_Type_MainUser_Add || self.type == CertificationVc_Type_MainUser_ReEdit) {
                 willRfSectionNum = carSectionNum+2;//个人信息s+房屋信息s
            }else{
                 willRfSectionNum = carSectionNum+1;//个人信息s
            }
            NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:willRfSectionNum];//个人信息在top
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            [self.tableView reloadData];
        }
   
    });
}

#pragma mark == subShowChooseBtnAction 点击btn

- (void)subShowChooseBtnAction:(UIButton *)sender{
     NSLog(@"textFieldRightBtnAction===%ld",(long)sender.tag);
    if ((sender.tag/100)==(BTN_TAG_SectionOne_TextFieldSubVChooseBtn/100)) {//个人信息
        NSInteger cellIndex = sender.tag - BTN_TAG_SectionOne_TextFieldSubVChooseBtn;
        if(self.type == CertificationVc_Type_OtherUser_ReEdit || self.type == CertificationVc_Type_OtherUser_Add){
            switch (cellIndex) {//家属
                case 1://性别
                {
                    NSLog(@"性别选择");
                    [self.view endEditing:YES];
                    self.chooseGenderView.hidden = NO;
                }
                    break;
                case 4://亲属关系
                {
                    [self getRelationDataSourceAndShowPopViewRelationship];
                }
                    break;
                    
                    
                default:
                    break;
            }
        }else{//业主
            switch (cellIndex) {
                case 1://性别
                {
                    NSLog(@"性别选择");
                    [self.view endEditing:YES];
                    self.chooseGenderView.hidden = NO;
                }
                    break;
                default:
                    break;
            }
        }
    }else if((sender.tag/100)==(BTN_TAG_SectionHouse_TextFieldSubVChooseBtn/100)) {//房产信息
        NSInteger houseCellIndex = sender.tag - BTN_TAG_SectionHouse_TextFieldSubVChooseBtn;
        if(self.type == CertificationVc_Type_OtherUser_ReEdit || self.type == CertificationVc_Type_OtherUser_Add){
            //详细地址 不跳转
        }else{
            NSInteger houseRowNum = houseCellIndex;
            self.nowPopViewChooseHouseWithRowNum = houseRowNum;
            //跳转
            UserCertificationChooseHouseDetailAddressVC *chooseHouseDetailAddressVC = [[UserCertificationChooseHouseDetailAddressVC alloc]init];
            chooseHouseDetailAddressVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chooseHouseDetailAddressVC animated:YES];
           
        }
    }else if((sender.tag/100)==(BTN_TAG_SectionCar_TextFieldSubVChooseBtn_CarId/100)) {//车牌信息
        NSInteger cellSectionIndex = sender.tag - BTN_TAG_SectionCar_TextFieldSubVChooseBtn_CarId;
        {
            NSLog(@"车牌号拍照识别 %ld",(long)cellSectionIndex);
            //test
            self.nowPopViewChooseCarIdWithSectionNum = cellSectionIndex;
            CarEntityModel *model = self.carInfoModelArr[self.nowPopViewChooseCarIdWithSectionNum];
            model.carPlate = [NSString stringWithFormat:@"%ld",(long)cellSectionIndex];
            [self reloadCarIdWithSectionNum:self.nowPopViewChooseCarIdWithSectionNum];
        }
    }else if((sender.tag/100)==(BTN_TAG_SectionCar_TextFieldSubVChooseBtn_CarImg/100)) {////        NSLog(@"车图片按钮 选择 %ld",(long)cellSectionIndex);  SubVChooseBtn 隐藏 此处无 图片按钮数据
        
    }else if((sender.tag/100)==(BTN_TAG_SectionCar_TextFieldSubVChooseBtn_CarType/100)) {//车 类型按钮
        NSInteger cellSectionIndex = sender.tag - BTN_TAG_SectionCar_TextFieldSubVChooseBtn_CarType;
          
        NSLog(@"车辆类型选择 %ld",(long)cellSectionIndex);
        self.nowPopViewChooseCarTypeWithSectionNum = cellSectionIndex;
        [self popCarDataAndShowPopView:nil];
        
    }else{
        NSLog(@"textFieldRightBtnAction 未知");
 
    }
}
#pragma mark ==  chooseGenderView _delegate 选择性别
- (void)chooseGender:(Choose_Gender_Num)indexGenderNum{
    //        0未知，1男，2女
    if(self.type == CertificationVc_Type_OtherUser_ReEdit || self.type == CertificationVc_Type_OtherUser_Add){//家属
        switch (indexGenderNum) {
            case Choose_Gender_man:
            {
                self.okModel.sex = 1;
                self.textFieldTextArrSectionOneOfOtherUser[Cell_Gender_TextFieldTextArr_SectionOne_OtherUser_RowNum] = Str_Boy;
                [self.tableView reloadData];
            }
                break;
            case Choose_Gender_woman:
            {
                self.okModel.sex = 2;
                self.textFieldTextArrSectionOneOfOtherUser[Cell_Gender_TextFieldTextArr_SectionOne_OtherUser_RowNum] = Str_Girl;
                [self.tableView reloadData];
            }
                break;
            case Choose_Gender_unknown:
            {
                self.okModel.sex = 0;
                self.textFieldTextArrSectionOneOfOtherUser[Cell_Gender_TextFieldTextArr_SectionOne_OtherUser_RowNum] = Str_Gender_Nomal;
                [self.tableView reloadData];
            }
                break;
                
            default:
                break;
        }
    }else{//业主部分
        switch (indexGenderNum) {
            case Choose_Gender_man:
            {
                self.okModel.sex = 1;
                self.textFieldTextArrSectionOne[Cell_Gender_TextFieldTextArr_SectionOne_RowNum] = Str_Boy;
                [self.tableView reloadData];
            }
                break;
            case Choose_Gender_woman:
            {
                self.okModel.sex = 2;
                self.textFieldTextArrSectionOne[Cell_Gender_TextFieldTextArr_SectionOne_RowNum] = Str_Girl;
                [self.tableView reloadData];
            }
                break;
            case Choose_Gender_unknown:
            {
                self.okModel.sex = 0;
                self.textFieldTextArrSectionOne[Cell_Gender_TextFieldTextArr_SectionOne_RowNum] = Str_Gender_Nomal;
                [self.tableView reloadData];
            }
                break;
                
            default:
                break;
        }
    }
   
}
#pragma mark == popview show car 选择车辆
//车
-  (void)popCarDataAndShowPopView:(CarInfoModel *)oldModel{//oldModel==nil
    [CarTypeListModel getCarTypeListWithBlock:^(NSArray * arr) {
        if (arr.count==0) {
            Y_SVP_SHOW_ERR_MES(@"车辆类型信息获取失败");
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view endEditing:YES];
            [self.popviewCarType showInView:self.view thePopViewSubViewHeight:180 WithArray:arr.mutableCopy WithOldCarInfoModel:oldModel];
        });
    }];
}
#pragma mark == pop carType 车辆多个cell
- (void)popViewChooseCarTypeModle:(CarTypeModel *)typeMode{
    CarEntityModel *model = self.carInfoModelArr[self.nowPopViewChooseCarTypeWithSectionNum];
    //20210225改
    model.carTypeText = typeMode.name;
    model.carType = [NSString stringWithFormat:@"%ld",(long)typeMode.code];
    self.carInfoModelArr[self.nowPopViewChooseCarTypeWithSectionNum] = model;
    [self reloadCarTypeWithSectionNum:self.nowPopViewChooseCarTypeWithSectionNum];
}
#pragma mark == relationshipPopView 亲属关系 选择
- (void)getRelationDataSourceAndShowPopViewRelationship{
    [RelationshipListModel getRelationshipListWithBlock:^(NSArray * arr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view endEditing:YES];
            [self.popViewRelationship showInView:self.view thePopViewSubViewHeight:200 WithArray:arr.mutableCopy];
        });
    }];
}
//家属的type才会有
- (void)relationshipPopViewChooseModel:(RelationshipModel *)model{
    NSLog(@"业主关系 relationship PopView %@",model.name);
    //model.code
    self.okModel.concern = model.code; //relation
    self.textFieldTextArrSectionOneOfOtherUser[Cell_Relationship_TextFieldTextArr_SectionOne_OtherUser_RowNum]  = model.name;
    [self reloadPersonInfoWithRowIndex:Cell_Relationship_TextFieldTextArr_SectionOne_OtherUser_RowNum];
}
#pragma mark == Textfield delagete
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (textField.tag-TEXTFIELD_TAG == 2) {
//        return [ValidateUtil fisMatchIdCardNumberFormat:textField range:range string:string];//不可用于身份证
//    }
//    if (textField.tag-TEXTFIELD_TAG == 4) {
//      return [ValidateUtil isMatchCarCodeNumberFormat:textField range:range string:string];
//    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag<(TextField_SectionOne_TAG+10)) {//个人信息 250+5<255
        NSInteger tag = textField.tag-TextField_SectionOne_TAG;
        
        if (self.type == CertificationVc_Type_OtherUser_Add || self.type == CertificationVc_Type_OtherUser_ReEdit) {
            switch (tag) {//家属 暂停 缺少亲属类型/ 姓名 性别 电话 身份证号 业主关系 /所属单元
                case 0:
                {
                    self.okModel.realName = textField.text;
                    self.textFieldTextArrSectionOneOfOtherUser[Cell_Name_TextFieldTextArr_SectionOne_OtherUser_RowNum] = self.okModel.realName;
                }
                    break;
                case 2://电话
                {
                    self.okModel.mobile = textField.text;
                    self.textFieldTextArrSectionOneOfOtherUser[Cell_Phone_TextFieldTextArr_SectionOne_OtherUser_RowNum] = self.okModel.mobile;
                }
                    break;
                case 3://身份证
                {
                    self.okModel.idCard = textField.text;
                    self.textFieldTextArrSectionOneOfOtherUser[Cell_IdCard_TextFieldTextArr_SectionOne_OtherUser_RowNum] = self.okModel.idCard;
                }
                    break;
                default:
                    break;
            }
        }else{//业主
            switch (tag) {
                case 0:
                {
                    self.okModel.realName = textField.text;
                    self.textFieldTextArrSectionOne[Cell_Name_TextFieldTextArr_SectionOne_RowNum] = self.okModel.realName;
                }
                    break;
                case 2:
                {
                    self.okModel.idCard = textField.text;
                    self.textFieldTextArrSectionOne[Cell_IdCard_TextFieldTextArr_SectionOne_RowNum] = self.okModel.idCard;
                }
                    break;
                default:
                    break;
            }
        }
       
    }
    if ((textField.tag/100)==(TextField_SectionHouse_TAG/100)) {//房产信息  textfield 暂textfield文本部分不做响应
    }
    if((textField.tag/100)==(TextField_SectionCar_CarId_TAG/100)){//车辆信息Id车牌部分
        NSInteger carIDRowNow = textField.tag-TextField_SectionCar_CarId_TAG;
        self.nowPopViewChooseCarIdWithSectionNum = carIDRowNow;
        CarEntityModel *model = self.carInfoModelArr[self.nowPopViewChooseCarIdWithSectionNum];
        model.carPlate = textField.text;
        [self reloadCarIdWithSectionNum:self.nowPopViewChooseCarIdWithSectionNum];
     }
}
#pragma mark ==  table view 刷新
/**
 NSInteger sectionNum = 0;
 NSInteger sectionNumOfMainUserCar = indexPath.section-2;
 NSInteger sectionNumOfOtherUserCar = indexPath.section-1;//刷新数据时 arr对应的popsectionnum 0开始的
 */
//个人信息
- (void)reloadPersonInfoWithRowIndex:(NSInteger)rowNum{
    [self reloadTableViewWithIndexPaths:[NSIndexPath indexPathForRow:rowNum inSection:0]];//section=0
}
//房屋
- (void)reloadHouseRowsWithRowIndex:(NSInteger)rowNum{
    [self reloadTableViewWithIndexPaths:[NSIndexPath indexPathForRow:self.nowPopViewChooseHouseWithRowNum inSection:1]];//section=1
}
//车辆--- //section==1or2
- (void)reloadCarIdWithSectionNum:(NSInteger)sectionNum{//车牌
    if (self.type==CertificationVc_Type_OtherUser_Add||self.type==CertificationVc_Type_OtherUser_ReEdit) {//家属2+car组
        [self reloadCarSectonWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionNum+1]];
    }else{
        [self reloadCarSectonWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionNum+2]];
    }
}
- (void)reloadCarTypeWithSectionNum:(NSInteger)sectionNum{//车类型
    if (self.type==CertificationVc_Type_OtherUser_Add||self.type==CertificationVc_Type_OtherUser_ReEdit) {
        [self reloadCarSectonWithIndexPath:[NSIndexPath indexPathForRow:1 inSection:sectionNum+1]];
    }else{
        [self reloadCarSectonWithIndexPath:[NSIndexPath indexPathForRow:1 inSection:sectionNum+2]];
    }
}
- (void)reloadCarImgWithSectionNum:(NSInteger)sectionNum{//车图片
    if (self.type==CertificationVc_Type_OtherUser_Add||self.type==CertificationVc_Type_OtherUser_ReEdit) {
        [self reloadCarSectonWithIndexPath:[NSIndexPath indexPathForRow:2 inSection:sectionNum+1]];
    }else{
        [self reloadCarSectonWithIndexPath:[NSIndexPath indexPathForRow:2 inSection:sectionNum+2]];
    }
//    [self reloadCarSectonWithIndexPath:[NSIndexPath indexPathForRow:2 inSection:sectionNum]];
}
- (void)reloadCarSectonWithIndexPath:(NSIndexPath *)indexPath{
    [UIView performWithoutAnimation:^{
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
//总刷新
- (void)reloadTableViewWithIndexPaths:(NSIndexPath *)indexPath{
    [UIView performWithoutAnimation:^{

        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
}

#pragma mark == tableView ———————————————————————————— delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.type==CertificationVc_Type_OtherUser_Add||self.type==CertificationVc_Type_OtherUser_ReEdit) {//家属2+car组
        if (self.carInfoModelArr.count==0) {
            return 2;
        }else{
            return 1+self.carInfoModelArr.count;
        }
    }else{//业主3+car组
        if (self.carInfoModelArr.count==0) {
            return 3;
        }else{
            return 2+self.carInfoModelArr.count;
        }
    }
}

//SectionHeader
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.type==CertificationVc_Type_OtherUser_Add||self.type==CertificationVc_Type_OtherUser_ReEdit) {
        if (section<=1) {
            return CerTableViewCell_Height_cell_HeaderView;
        }else{
            return CerTableViewCell_Height_cell_HeaderViewAndFooterView_No;
        }
    }else{
        if (section<=2) {
            return CerTableViewCell_Height_cell_HeaderView;
        }else{
            return CerTableViewCell_Height_cell_HeaderViewAndFooterView_No;
        }
    }
    
   
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MainSectionHeaderViewTextLabel *headerViewTextLabel = [[MainSectionHeaderViewTextLabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];//
    if (self.type==CertificationVc_Type_OtherUser_Add||self.type==CertificationVc_Type_OtherUser_ReEdit) {
        NSArray *headerTextArr = @[@"个人信息",@"车辆信息"];
        if (section<=1) {
            headerViewTextLabel.text = headerTextArr[section];
            return headerViewTextLabel;
        }else{
            return [UIView new];
        }
    }else{
        NSArray *headerTextArr = @[@"个人信息",@"房屋信息",@"车辆信息"];
        if (section<=2) {
            headerViewTextLabel.text = headerTextArr[section];
            return headerViewTextLabel;
        }else{
            return [UIView new];
        }
    }
    
  
}
//SectionFooter
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(self.type == CertificationVc_Type_OtherUser_Add){
       if (section == (self.carInfoModelArr.count==0 ? 1 : self.carInfoModelArr.count)){//section==1 or section=lastcar
           return CerTableViewCell_Height_cell_FooterView;
       }else{
           return CerTableViewCell_Height_cell_HeaderViewAndFooterView_No;
       }
      
    }else if(self.type == CertificationVc_Type_OtherUser_ReEdit){
        if (section== (self.carInfoModelArr.count==0 ? 1 : self.carInfoModelArr.count)){//section==1 or section=lastcar
            return CerTableViewCell_Height_cell_FooterView;
        }else{
            return CerTableViewCell_Height_cell_HeaderViewAndFooterView_No;
        }
        
    }else if(self.type == CertificationVc_Type_MainUser_ReEdit){
        if (section==1) {
            return CerTableViewCell_Height_cell_FooterView;
        } else if (section== (self.carInfoModelArr.count==0 ? 2 : self.carInfoModelArr.count+1)){
            return CerTableViewCell_Height_cell_FooterView;
        }else{
            return CerTableViewCell_Height_cell_HeaderViewAndFooterView_No;
        }
    }else{
        if (section==1) {
            return CerTableViewCell_Height_cell_FooterView;
        } else if (section== (self.carInfoModelArr.count==0 ? 2 : self.carInfoModelArr.count+1)){
            return CerTableViewCell_Height_cell_FooterView;
        }else{
            return CerTableViewCell_Height_cell_HeaderViewAndFooterView_No;
        }
    }
   
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UserCertificationCellSectionFooterView *sectionFooterView  = [[UserCertificationCellSectionFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, CerTableViewCell_Height_cell_FooterView)];
    if(self.type == CertificationVc_Type_OtherUser_ReEdit || self.type == CertificationVc_Type_OtherUser_Add){//section==1 or section=lastcar
        if (section== (self.carInfoModelArr.count==0 ? 1 : self.carInfoModelArr.count)){
            [sectionFooterView.sectionFooterViewBtn setTitle:@"+ 继续添加车辆" forState:UIControlStateNormal];
            [sectionFooterView.sectionFooterViewBtn addTarget:self action:@selector(sectionFooterActionWithAddCar:) forControlEvents:UIControlEventTouchUpInside];
            return sectionFooterView;
        }else{
            return [UIView new];
        }
    }else if(self.type == CertificationVc_Type_MainUser_Add || self.type == CertificationVc_Type_MainUser_ReEdit){
        if (section==1) {
            [sectionFooterView.sectionFooterViewBtn setTitle:@"+ 继续添加房屋" forState:UIControlStateNormal];
            [sectionFooterView.sectionFooterViewBtn addTarget:self action:@selector(sectionFooterActionWithAddHouse:) forControlEvents:UIControlEventTouchUpInside];
            return sectionFooterView;
        } else if (section== (self.carInfoModelArr.count==0 ? 2 : self.carInfoModelArr.count+1)){
            [sectionFooterView.sectionFooterViewBtn setTitle:@"+ 继续添加车辆" forState:UIControlStateNormal];
            [sectionFooterView.sectionFooterViewBtn addTarget:self action:@selector(sectionFooterActionWithAddCar:) forControlEvents:UIControlEventTouchUpInside];
            return sectionFooterView;
        }else{
            return [UIView new];
        }
    }else{
        return [UIView new];
    }
    
}
//row - num
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        if (self.type==CertificationVc_Type_OtherUser_Add||self.type==CertificationVc_Type_OtherUser_ReEdit) {
            return TableView_Cell_Section_One_RowAllNum_OtherUser;//家属新增电话 业主关系
        }else{
            return TableView_Cell_Section_One_RowAllNum_MainUser;//业主信息 个人信息部分
        }
    }else if(section==1){
        if (self.type==CertificationVc_Type_OtherUser_Add||self.type==CertificationVc_Type_OtherUser_ReEdit) {
            //家属 车辆
//            return 3;;
            return 4;
        }else{//业主 house
            if ( self.houseAddressModelArr.count==0) {
                return 1;
            }else{
                return self.houseAddressModelArr.count;//1section多row
            }
        }
    }else{//车  家属业主
//        return 3;
        return  4;
      
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type==CertificationVc_Type_OtherUser_Add||self.type==CertificationVc_Type_OtherUser_ReEdit) {
        if (indexPath.section==0) {
            return 50;
        }else{//车辆信息
            if (indexPath.row==2) {
                return 90;//车辆图片
            }else{
                return 50;
            }
        }
    }else{//业主
        if (indexPath.section==0) {
            return 80;
        }else if (indexPath.section==1){
            return 50;
        }else{//车辆信息
            if (indexPath.row==2) {
                return 90;//车辆图片
            }else{
                return 50;
            }
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type==CertificationVc_Type_OtherUser_Add||self.type==CertificationVc_Type_OtherUser_ReEdit) {
        if (indexPath.section==0) {//个人信息
            return  [self tableView:tableView sectionOneOfOtherUserInfocellForRowAtIndexPath:indexPath];//家属信息
        }else{
            return  [self tableView:tableView sectionCarcellForRowAtIndexPath:indexPath];//车辆信息 多组
        }
    }else{
        if (indexPath.section==0) {//个人信息
            return  [self tableView:tableView sectionOneOfMainUserInfocellForRowAtIndexPath:indexPath];//业主信息
         
        }else if(indexPath.section==1){
            return [self tableView:tableView sectionHousecellForRowAtIndexPath:indexPath];//房产信息 1组多行
        }else{
            return  [self tableView:tableView sectionCarcellForRowAtIndexPath:indexPath];//车辆信息 多组
//            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
//            return cell;
        }
    }
    
}
 
#pragma mark === cell_main_userInfo 业主
//- (UITableViewCell *)tableView:(UITableView *)tableView sectionOneOfMainUserInfocellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UserCertificationTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCertificationTextTableViewCell_Identifier];
//    if (!cell) {
//        cell = [[UserCertificationTextTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UserCertificationTextTableViewCell_Identifier];
//    }
//     cell.titleL.text = self.titleArrSectionOne[indexPath.row];
//     cell.textField.text = self.textFieldTextArrSectionOne[indexPath.row];
//     cell.textField.delegate = self;
//     cell.textField.tag = TextField_SectionOne_TAG+indexPath.row;
//     cell.subShowChooseBtn.tag = BTN_TAG_SectionOne_TextFieldSubVChooseBtn+indexPath.row;
//    [cell.textField mainModuleAttributedPlaceholderNewColorWithStr:self.textFieldPlaceholderArrOne[indexPath.row]];
//    //20210224更改
//    cell.textFieldRightBtn.hidden = YES;
//    cell.subShowChooseBtn.hidden = YES;
//    cell.textField.userInteractionEnabled = NO;
////    if(indexPath.row==0||indexPath.row==2){
////        cell.textFieldRightBtn.hidden = YES;
////        cell.subShowChooseBtn.hidden = YES;
////    }else{
////        cell.textFieldRightBtn.hidden = NO;
////        cell.subShowChooseBtn.hidden = NO;
////    }
//    if(indexPath.row==TableView_Cell_Section_One_RowAllNum_MainUser-1){
//        cell.lineView.hidden = YES;
//    }else{
//        cell.lineView.hidden = NO;
//    }
//    return cell;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView sectionOneOfMainUserInfocellForRowAtIndexPath:(NSIndexPath *)indexPath{//业主信息修改 0301修改业主infocell
#import "UserCertificationUserInfoTopTableViewCell.h"
    
        UserCertificationUserInfoTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCertificationUserInfoTopTableViewCell_Identifier];
        if (!cell) {
            cell = [[UserCertificationUserInfoTopTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UserCertificationUserInfoTopTableViewCell_Identifier];
        }
    cell.titleLabel.text = self.okModel.realName;
    [cell genderInfoWithIndex:self.okModel.sex];
    cell.detailtitleLabel.text = self.okModel.idCard;
//       cell.detailTextLabel.text = self.textFieldTextArrSectionOne[3];
    return cell;
 }
#pragma mark === cell_other_userInfo 家属
- (UITableViewCell *)tableView:(UITableView *)tableView sectionOneOfOtherUserInfocellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserCertificationTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCertificationTextTableViewCell_Identifier];
    if (!cell) {
        cell = [[UserCertificationTextTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UserCertificationTextTableViewCell_Identifier];
    }
     cell.titleL.text = self.titleArrSectionOneOfOtherUser[indexPath.row];
     cell.textField.text = self.textFieldTextArrSectionOneOfOtherUser[indexPath.row];
     cell.textField.delegate = self;
     cell.textField.tag = TextField_SectionOne_TAG+indexPath.row;
     cell.subShowChooseBtn.tag = BTN_TAG_SectionOne_TextFieldSubVChooseBtn+indexPath.row;
    [cell.textField mainModuleAttributedPlaceholderNewColorWithStr:self.textFieldPlaceholderArrOneOfOtherUser[indexPath.row]];
    if(indexPath.row==0||indexPath.row==2||indexPath.row==3){//姓名 电话 身份证
        cell.textFieldRightBtn.hidden = YES;
        cell.subShowChooseBtn.hidden = YES;
    }else if(indexPath.row==1){//性别
        cell.textFieldRightBtn.hidden = NO;
        cell.subShowChooseBtn.hidden = NO;
    }else if(indexPath.row== 4){//房屋
        cell.textFieldRightBtn.hidden = YES;
        cell.subShowChooseBtn.hidden = NO;
        [cell.subShowChooseBtn setTitleColor:Y_RGBA(197, 201, 212, 1) forState:UIControlStateNormal];
        cell.subShowChooseBtn.userInteractionEnabled = YES;//点击不跳转
    }
    if(indexPath.row==TableView_Cell_Section_One_RowAllNum_OtherUser-1){
        cell.lineView.hidden = YES;
    }else{
        cell.lineView.hidden = NO;
    }
    return cell;
}

//房产信息
- (UITableViewCell *)tableView:(UITableView *)tableView sectionHousecellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserCertificationTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCertificationTextTableViewCell_Identifier];
    if (!cell) {
        cell = [[UserCertificationTextTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UserCertificationTextTableViewCell_Identifier];
    }
    if (self.houseAddressModelArr.count==0) {//空房屋
        return  cell;
    }
    UserCertificationHouserModel *model =  self.houseAddressModelArr[indexPath.row];
    cell.textField.text =  [[TextShowWithModelStr textShowWithModelStr:model.communityName] stringByAppendingString:[TextShowWithModelStr textShowWithModelStr:model.door]];//房产名显示部分 暂定 =社区+门牌
    //
    cell.titleL.text = self.titleArrSectionHouse.firstObject;
    cell.textField.delegate = self;
    cell.textField.tag = TextField_SectionHouse_TAG+indexPath.row;
    cell.subShowChooseBtn.tag = BTN_TAG_SectionHouse_TextFieldSubVChooseBtn+indexPath.row;
    [cell.textField mainModuleAttributedPlaceholderNewColorWithStr:self.textFieldPlaceholderArrHouse.firstObject];
    cell.subShowChooseBtn.hidden = NO;
    cell.textFieldRightBtn.hidden = NO;
    if(indexPath.row==self.houseAddressModelArr.count-1){
        cell.lineView.hidden = YES;
    }else{
        cell.lineView.hidden = NO;
    }
    return cell;
}
//车辆信息
- (UITableViewCell *)tableView:(UITableView *)tableView sectionCarcellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger sectionNum = 0;
    NSInteger sectionNumOfMainUserCar = indexPath.section-2;
    NSInteger sectionNumOfOtherUserCar = indexPath.section-1;//刷新数据时 arr对应的popsectionnum
    if (self.type==CertificationVc_Type_OtherUser_Add||self.type==CertificationVc_Type_OtherUser_ReEdit) {//家属
        sectionNum = sectionNumOfOtherUserCar;
    }else{//业主
        sectionNum = sectionNumOfMainUserCar;
    }
    if (indexPath.row==0) {//车牌号
        UserCertificationTextWithOtherRightImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCertificationTextOtherRightImgTableViewCell_Identifier];
        if (!cell) {
            cell = [[UserCertificationTextWithOtherRightImgTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UserCertificationTextOtherRightImgTableViewCell_Identifier];
        }
        CarEntityModel *model = self.carInfoModelArr[sectionNum];
        cell.textField.text = [TextShowWithModelStr textShowWithModelStr: model.carPlate];
        cell.textField.tag = TextField_SectionCar_CarId_TAG+(sectionNum);
        cell.subShowChooseBtn.tag = BTN_TAG_SectionCar_TextFieldSubVChooseBtn_CarId+(sectionNum);
        cell.titleL.text = self.titleArrSectionCar[indexPath.row];
        cell.textField.delegate = self;
        [cell.textField mainModuleAttributedPlaceholderNewColorWithStr:self.textFieldPlaceholderArrCar[indexPath.row]];
        cell.lineView.hidden = NO;
        return cell;
    }else if(indexPath.row==2){//车辆图片
        UserCertificationCarImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCertificationCarImgTableViewCell_Identifier];
        if (!cell) {
            cell = [[UserCertificationCarImgTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UserCertificationCarImgTableViewCell_Identifier];
        }
        cell.addImgBtn.tag = BTN_TAG_SectionCar_TextFieldSubVChooseBtn_CarImg+(sectionNum);
//        //图片arr
//        if (self.saveCarImgArr.count<=sectionNum) {//数据图片没载好 则空 则返回
//            return cell;
//        }
//        [cell.addImgBtn setImage:(isNotNil(self.saveCarImgArr[sectionNum]) ? self.saveCarImgArr[sectionNum] :[UIImage new])forState:UIControlStateNormal];//空型
        //0304此处弃用imgarr的数据
        if (self.carInfoModelArr.count<=sectionNum) {
            [cell.addImgBtn setImage:[UIImage new] forState:UIControlStateNormal];
            return cell;
        }else{
            CarEntityModel *model = self.carInfoModelArr[sectionNum];
            if (model.drivingLicenseUrl.length>0) {
                [cell.addImgBtn sd_setBackgroundImageWithURL:[UrlWithString getURLWithStr:model.drivingLicenseUrl] forState:UIControlStateNormal];
             }else{
//                 cell.addImgBtn.backgroundColor = [UIColor clearColor];
                 [cell.addImgBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
            }
        }
        return cell;
    }else if(indexPath.row==3){//删除本车辆信息
        UserCertificationCarInfoDeletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCertificationCarInfoDeletTableViewCell_Identifier];
        if (!cell) {
            cell = [[UserCertificationCarInfoDeletTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UserCertificationCarInfoDeletTableViewCell_Identifier];
        }
        cell.carSectionNum = sectionNum;
        cell.delegate = self;
        return cell;
    }else{//车辆类型
        UserCertificationTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCertificationTextTableViewCell_Identifier];
        if (!cell) {
            cell = [[UserCertificationTextTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UserCertificationTextTableViewCell_Identifier];
        }
        
        CarEntityModel *model = self.carInfoModelArr[sectionNum];
        //carType CarEntityModel 文本部分model
//        cell.textField.text = [TextShowWithModelStr textShowWithModelStr:model.carType];//类型code
      
        if (self.type==CertificationVc_Type_OtherUser_Add||self.type==CertificationVc_Type_OtherUser_ReEdit) {//家属
            cell.textField.text = [TextShowWithModelStr textShowWithModelStr:model.carType];//类型文本 //家属getmodel carType
        }else{//业主
            cell.textField.text = [TextShowWithModelStr textShowWithModelStr:model.carTypeText];//类型文本 //家属getmodel carType
        }
        cell.titleL.text = self.titleArrSectionCar[indexPath.row];
        cell.textField.tag = TextField_SectionCar_CarType_TAG+(sectionNum);
        cell.subShowChooseBtn.tag = BTN_TAG_SectionCar_TextFieldSubVChooseBtn_CarType+(sectionNum);
        //
        cell.textField.delegate = self;
        [cell.textField mainModuleAttributedPlaceholderNewColorWithStr:self.textFieldPlaceholderArrCar[indexPath.row]];
        cell.subShowChooseBtn.hidden = NO;
        cell.lineView.hidden = NO;
        cell.textFieldRightBtn.hidden = NO;
       return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}


@end
