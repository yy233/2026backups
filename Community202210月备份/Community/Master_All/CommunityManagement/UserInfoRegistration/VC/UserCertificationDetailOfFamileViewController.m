//
//  UserCertificationDetailOfFamileViewController.m
//  Community
//  业主认证 多个类型的 详情页面 —
//  Created by 余莹 on 2021/3/1.
//

#import "UserCertificationDetailOfFamileViewController.h"
#import "UserFamilAllModel.h"
@interface UserCertificationDetailOfFamileViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UserCertificationCarInfoDeletTableViewCellDelegate>
@property (nonatomic,strong) UserFamilAllModel *familOkModel;
//UserFamilAllModelOfCarsModel
@end

@implementation UserCertificationDetailOfFamileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initDataWithEditOrShow];
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
#pragma mark ==========initData 查看 或 修改 状态时
- (void)initDataWithEditOrShow{
    if (self.type==CertificationVc_Type_OtherUser_ReEdit) {//家属
//        self.detailId = 1;//test
        Y_SVP_SHOW_MES_IsLoading_15Delay
         [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_GuestInfoReistion_Detail_Family withParams:@{@"id":@(self.detailId)}.mutableCopy finished:^(id responsObject, NSError *error) {
             Y_SVP_DISMISS
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    NSDictionary *familyDic = [NSDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                    NSLog(@"%@",familyDic);
                   self.familOkModel = [UserFamilAllModel mj_objectWithKeyValues:familyDic];
                    self.textFieldTextArrSectionOneOfOtherUser[Cell_Name_TextFieldTextArr_SectionOne_OtherUser_RowNum] = [TextShowWithModelStr textShowWithModelStr:self.familOkModel.name];
                    self.textFieldTextArrSectionOneOfOtherUser[Cell_Gender_TextFieldTextArr_SectionOne_OtherUser_RowNum] = [self genderTextWithSex:self.familOkModel.sex];
                    self.textFieldTextArrSectionOneOfOtherUser[Cell_Phone_TextFieldTextArr_SectionOne_OtherUser_RowNum] = [TextShowWithModelStr textShowWithModelStr:self.familOkModel.mobile];//
                    self.textFieldTextArrSectionOneOfOtherUser[Cell_IdCard_TextFieldTextArr_SectionOne_OtherUser_RowNum] = [TextShowWithModelStr textShowWithModelStr:self.familOkModel.idCard];
                    self.textFieldTextArrSectionOneOfOtherUser[Cell_Relationship_TextFieldTextArr_SectionOne_OtherUser_RowNum] = [RelationshipModel getRelationShipRelativeNameWithCode:self.familOkModel.relation];//与业主关系
                
                    self.carInfoModelArr = [NSMutableArray array];//置空 初有个model元素
                    //车辆详情文本和code
                    NSArray *carArr = [NSArray arrayWithArray:self.familOkModel.cars];
                    if (carArr.count==0) {//0.count
                        UserFamilAllModelOfCarsModel* willUseCarModel = [[UserFamilAllModelOfCarsModel alloc]init];
                        [self.carInfoModelArr addObject:willUseCarModel];
                    }else{
                        for (int i = 0; i < carArr.count; i ++) {
                            UserFamilAllModelOfCarsModel *willUseCarModel = [UserFamilAllModelOfCarsModel mj_objectWithKeyValues:carArr[i]];
                            [self.carInfoModelArr addObject:willUseCarModel];
                       }
                    }
                    //车辆图片 0303 暂时不用
                    self.saveCarImgArr = [NSMutableArray array];
//                    for (int i = 0; i < self.carInfoModelArr.count; i ++) {
//                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                            UserFamilAllModelOfCarsModel *carModel  =  self.carInfoModelArr[i];
//                            UIImage *carImg = [ImageGetWithString getImageFromURLStr:carModel.drivingLicenseUrl];//drivingLicenseUrl
//                            [self.saveCarImgArr addObject:isNotNil(carImg)?carImg:[UIImage new]];//空图片
//                            if (i == self.carInfoModelArr.count-1) {
//                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    Y_SVP_DISMISS
//                                    [self.tableView reloadData];
//                                });
//                            }
//                        });
//                    }
                    //刷新
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });

                }else{
                    Y_SVP_SHOW_ERR_MESSAGE
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            }else{
                Y_SVP_SHOW_ERR_DESCRIPTION
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }];
    }
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
    if (self.familOkModel.name.length==0) {
        Y_SVP_SHOW_ERR_MES(@"缺少信息");
        return;
    }
    if(!self.familOkModel.sex || self.familOkModel.sex==0){
        self.okModel.sex = 0;
    }
    if (self.familOkModel.idCard.length == 0) {
        Y_SVP_SHOW_ERR_MES(@"缺少证件信息");
        return;
    }
    //判断有无 有则计入 无则不计入
    NSMutableArray *carWilSnedArr = [NSMutableArray array];
    NSMutableArray *carWilSnedModeArr = [NSMutableArray array];
    //车辆数据 //房产信息 //_________家属 房产数据不计
    NSMutableArray *houseWilSnedArr = [NSMutableArray array];
//    NSMutableArray *houseWilSnedModelArr = [NSMutableArray array];
  if(self.type == CertificationVc_Type_OtherUser_ReEdit || self.type == CertificationVc_Type_OtherUser_Add){
        //车
        for (int i = 0 ; i < self.carInfoModelArr.count ; i ++) {
            UserFamilAllModelOfCarsModel *carModel = self.carInfoModelArr[i];
            if (carModel.drivingLicenseUrl.length>0) {//已经处理好图片有地址的cell才上传该数据
                UserFamilAllModelOfCarsModel *carWillSendModel = [[UserFamilAllModelOfCarsModel alloc]init];
                 carWillSendModel.carPlate = carModel.carPlate;
                carWillSendModel.carType = carModel.carType;
                carWillSendModel.drivingLicenseUrl = carModel.drivingLicenseUrl;
                if (self.type == CertificationVc_Type_OtherUser_ReEdit) {
                    carWillSendModel.id = carModel.id;
                }else{
                    carWillSendModel.id = 0;
                }
                [carWilSnedModeArr addObject:carWillSendModel];
            }else{//无图不计入 可能是初始化数据
            }
        }
        NSArray *familyCarWillSnedKeyArr = @[@"drivingLicenseUrl",@"carPlate",@"carType",@"id"];
        carWilSnedArr = [NSMutableArray arrayWithArray:[UserFamilCarGetModel mj_keyValuesArrayWithObjectArray:carWilSnedModeArr keys:familyCarWillSnedKeyArr]]; 

    }
    if (self.type == CertificationVc_Type_OtherUser_ReEdit || self.type == CertificationVc_Type_OtherUser_Add) {//家属
 
        [self isOtherUserWillSendWithCarArr:carWilSnedArr houseArr:houseWilSnedArr];
     
    }
}
//家属
- (void)isOtherUserWillSendWithCarArr:(NSMutableArray *)carWilSnedArr houseArr:(NSMutableArray *)houseWilSnedArr{
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setValue:self.familOkModel.name forKey:@"name"];
    [parms setValue:@(self.familOkModel.sex) forKey:@"sex"];
    [parms setValue:self.familOkModel.mobile forKey:@"mobile"];//电话
    [parms setValue:@(1) forKey:@"identificationType"];//证件类型 当前默认证件为身份证————功能待改
    [parms setValue:self.familOkModel.idCard forKey:@"idCard"];//身份证
    [parms setValue:@(self.familOkModel.relation) forKey:@"relation"];//亲属关系
    [parms setValue:carWilSnedArr forKey:@"cars"];
    //添加 or  编辑  家属 对应当前门牌的房子
    [parms setValue:@(self.communityId) forKey:@"communityId"];
    [parms setValue:@(self.houseId) forKey:@"houseId"];
    
    if (self.type==CertificationVc_Type_OtherUser_ReEdit) {
        [parms setValue:@(self.detailId) forKey:@"id"];//修改状态
    }
    [self sendAllInfoWithOther:parms];
    
}

#pragma mark === 提交all信息
//家属
- (void)sendAllInfoWithOther:(NSMutableDictionary *)param{
   //新增
    if (self.type==CertificationVc_Type_OtherUser_Add) {
        NSString *url = URL_User_Family_Add;
        [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueue:url withParams:param finished:^(id responsObject, NSError *error) {
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        Y_NSNotificationCenter_PostNotice_NilObject_Name(Notice_Certifiction_Famile_Add_Or_Edit_OK)
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }else{
                    Y_SVP_SHOW_ERR_MES(Y_ResponsObject_messageStr)
                }
            }else{
                Y_SVP_SHOW_ERR_DESCRIPTION
                
            }
        }];
    }
    //修改
    if (self.type==CertificationVc_Type_OtherUser_ReEdit) {
        NSString *url =  URL_User_Family_Update;
        [[ToolOfNetWork sharedTools] YrequestPutURL:url withParams:param finished:^(id responsObject, NSError *error) {
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    Y_NSNotificationCenter_PostNotice_NilObject_Name(Notice_Certifiction_Famile_Add_Or_Edit_OK)
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    Y_SVP_SHOW_ERR_MES(Y_ResponsObject_messageStr)
                }
            }else{
                Y_SVP_SHOW_ERR_DESCRIPTION
                
            }
        }];
    }else{
        return;
    }
   
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
//                 self.saveCarImgArr[self.nowPopViewChooseCarImgWithSectionNum] = photo;//更换
                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                     UserFamilAllModelOfCarsModel *model = self.carInfoModelArr[self.nowPopViewChooseCarImgWithSectionNum];
                     model.drivingLicenseUrl =  [NSString stringWithFormat:@"%@",[responsObject objectForKey:@"data"]];
                     dispatch_async(dispatch_get_main_queue(), ^{
//                         [self.tableView reloadData];//0303增
                         [self reloadCarImgWithSectionNum:self.nowPopViewChooseCarImgWithSectionNum];
                     });
                 });
               
             }else{
//                 self.saveCarImgArr[self.nowPopViewChooseCarImgWithSectionNum] = [UIImage new];//保持原状
                 Y_SVP_SHOW_ERR_MESSAGE
             }
         }else{
//             self.saveCarImgArr[self.nowPopViewChooseCarImgWithSectionNum] = [UIImage new];
             Y_SVP_SHOW_ERR_DESCRIPTION
         }
    }];
}

#pragma mark  ==== sectionFooterAction  添加车辆
- (void)sectionFooterActionWithAddCar:(UIButton *)sender{
    NSLog(@"add car")
    if (self.carInfoModelArr.count>=50) {
        Y_SVP_SHOW_ERR_MES(@"限制车辆数量最多50")
        return;
    }
    UserFamilAllModelOfCarsModel *model = [[UserFamilAllModelOfCarsModel alloc]init];
    [self.carInfoModelArr addObject:model];
//    [self.saveCarImgArr addObject:[UIImage new]];//车辆图片
    [self.tableView reloadData];
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
            UserFamilAllModelOfCarsModel *model = self.carInfoModelArr[self.nowPopViewChooseCarIdWithSectionNum];
            model.carPlate = [NSString stringWithFormat:@"车牌号test %ld",(long)cellSectionIndex];
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
                self.familOkModel.sex = 1;
                self.textFieldTextArrSectionOneOfOtherUser[Cell_Gender_TextFieldTextArr_SectionOne_OtherUser_RowNum] = Str_Boy;
                [self.tableView reloadData];
            }
                break;
            case Choose_Gender_woman:
            {
                self.familOkModel.sex = 2;
                self.textFieldTextArrSectionOneOfOtherUser[Cell_Gender_TextFieldTextArr_SectionOne_OtherUser_RowNum] = Str_Girl;
                [self.tableView reloadData];
            }
                break;
            case Choose_Gender_unknown:
            {
                self.familOkModel.sex = 0;
                self.textFieldTextArrSectionOneOfOtherUser[Cell_Gender_TextFieldTextArr_SectionOne_OtherUser_RowNum] = Str_Gender_Nomal;
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
    UserFamilAllModelOfCarsModel *model = self.carInfoModelArr[self.nowPopViewChooseCarTypeWithSectionNum];
    model.carTypeText = typeMode.name;
    model.carType = typeMode.code;
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
    self.familOkModel.relation = model.code;
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
                    self.familOkModel.name = textField.text;
                    self.textFieldTextArrSectionOneOfOtherUser[Cell_Name_TextFieldTextArr_SectionOne_OtherUser_RowNum] = self.familOkModel.name;
                }
                    break;
                case 2://电话
                {
                    self.familOkModel.mobile = textField.text;
                    self.textFieldTextArrSectionOneOfOtherUser[Cell_Phone_TextFieldTextArr_SectionOne_OtherUser_RowNum] = self.familOkModel.mobile;
                }
                    break;
                case 3://身份证
                {
                    self.familOkModel.idCard = textField.text;
                    self.textFieldTextArrSectionOneOfOtherUser[Cell_IdCard_TextFieldTextArr_SectionOne_OtherUser_RowNum] = self.familOkModel.idCard;
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
        UserFamilAllModelOfCarsModel *model = self.carInfoModelArr[self.nowPopViewChooseCarIdWithSectionNum];
        model.carPlate = textField.text;
        [self reloadCarIdWithSectionNum:self.nowPopViewChooseCarIdWithSectionNum];
     }
}
#pragma mark ==  table view 刷新
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
    //UIView performWithoutAnimation可以强制一些动作不使用动画,它是一个简单的封装，先检查动画当前是否启用，然后禁止动画，执行块语句，最后重新启用动画。一个需要说明的地方是，它并不会阻塞基于CoreAnimation的动画
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
        
    }else{
        return 1;
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
        }else{
            return 0;
        }
    }else{//车  家属业主
//        return 3;
        return 4;

      
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
    }else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.type==CertificationVc_Type_OtherUser_Add||self.type==CertificationVc_Type_OtherUser_ReEdit) {
    if (indexPath.section==0) {//个人信息
        return  [self tableView:tableView sectionOneOfOtherUserInfocellForRowAtIndexPath:indexPath];//家属信息
    }else{
        return  [self tableView:tableView sectionCarcellForRowAtIndexPath:indexPath];//车辆信息 多组
    }
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
        UserFamilAllModelOfCarsModel *model = self.carInfoModelArr[sectionNum];
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
        //图片arr
//        if (self.saveCarImgArr.count<=sectionNum) {//数据图片没载好 则空 则返回
//            return cell;
//        }else{
////            [cell.addImgBtn setImage:(isNotNil(self.saveCarImgArr[sectionNum]) ? self.saveCarImgArr[sectionNum] :[UIImage new])forState:UIControlStateNormal];//空型 初始化的cell 有[UIImage new]
//        }
        if (self.carInfoModelArr.count<=sectionNum) {
            [cell.addImgBtn setImage:[UIImage new] forState:UIControlStateNormal];
            return cell;
        }else{
            UserFamilAllModelOfCarsModel *model = self.carInfoModelArr[sectionNum];
            if (model.drivingLicenseUrl.length>0) {
//                UIImageView *imgV = [[UIImageView alloc]init];
//                [imgV sd_setImageWithURL:[UrlWithString getURLWithStr:model.drivingLicenseUrl]];
//                [cell.addImgBtn setImage:imgV.image forState:UIControlStateNormal];
                [cell.addImgBtn sd_setBackgroundImageWithURL:[UrlWithString getURLWithStr:model.drivingLicenseUrl] forState:UIControlStateNormal];
             }else{
//                [cell.addImgBtn setImage:[UIImage new] forState:UIControlStateNormal];
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
        
        UserFamilAllModelOfCarsModel *model = self.carInfoModelArr[sectionNum];
        if (self.type==CertificationVc_Type_OtherUser_Add||self.type==CertificationVc_Type_OtherUser_ReEdit) {//家属
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

#pragma mark ==
- (UserFamilAllModel *)familOkModel{
    if (!_familOkModel) {
        _familOkModel = [[UserFamilAllModel alloc]init];
    }
    return _familOkModel;
}

@end
