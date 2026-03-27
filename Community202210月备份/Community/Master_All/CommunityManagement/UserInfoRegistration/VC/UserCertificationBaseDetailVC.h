//
//  UserCertificationBaseVC.h
//  Community
//
//  Created by 余莹 on 2021/2/24.
//

#import <UIKit/UIKit.h>
#import "UserCertificationTextTableViewCell.h"
#import "UserCertificationBtnTableViewCell.h"
#import "UserCertificationCarImgTableViewCell.h"
#import "UserCertificationCarInfoDeletTableViewCell.h"
#import "UserCertificationHeaderView.h"
#import "UserCertificationCellSectionFooterView.h"

#import "UserInfoRegistAllInfoWillSubmitModel.h"
#import "UserCertificationHouserModel.h"
#import "UserFamilyWillSendModel.h"
#import "UserFamilCarGetModel.h"

#import "UserCertificationChooseHouseDetailAddressVC.h"
#import "ChooseGenderView.h"
#import "ChooseCarTypeView.h"
#import "PopViewCarType.h"  //更换
#import "PopViewRelationship.h"
#import "RelationshipListModel.h"
#import "UserCertificationDetailViewModel.h" //车
//notice
#define Notice_name_AddressAllInfoPost @"noticeActionWithDetailedAddressInfo"

//cell
#import "UserCertificationUserInfoTopTableViewCell.h"
#define  UserCertificationUserInfoTopTableViewCell_Identifier @"UserCertificationUserInfoTopTableViewCell"

//cell
#define UserCertificationTextTableViewCell_Identifier @"UserCertificationTextTableViewCell"
#define UserCertificationTextOtherRightImgTableViewCell_Identifier @"UserCertificationTextWithOtherRightImgTableViewCell"
#define UserCertificationBtnTableViewCell_Identifier @"UserCertificationBtnTableViewCell"
#define UserCertificationCarImgTableViewCell_Identifier @"UserCertificationCarImgTableViewCell"
#define UserCertificationCarInfoDeletTableViewCell_Identifier @"UserCertificationCarInfoDeletTableViewCell"
 

//view
//#define TableView_Cell_Section_One_RowAllNum_MainUser 3    //业主个人信息区
#define TableView_Cell_Section_One_RowAllNum_MainUser 1    //业主个人信息区

#define TableView_Cell_Section_One_RowAllNum_OtherUser 6   //家属个人信息区

#define CerTableViewCell_Height_cell_HeaderView 50
#define CerTableViewCell_Height_cell_FooterView 50
#define CerTableViewCell_Height_cell_HeaderViewAndFooterView_No 5


//btn_tag
//textfield_tag
#define BTN_TAG_SectionOne_TextFieldSubVChooseBtn 200
#define TextField_SectionOne_TAG 250

#define BTN_TAG_SectionHouse_TextFieldSubVChooseBtn 300
#define TextField_SectionHouse_TAG 400

//车
//textField
#define TextField_SectionCar_CarId_TAG 500
#define TextField_SectionCar_CarType_TAG 600
#define TextField_SectionCar_CarImg_TAG 700
//Btn
#define BTN_TAG_SectionCar_TextFieldSubVChooseBtn_CarId 800
#define BTN_TAG_SectionCar_TextFieldSubVChooseBtn_CarType 900
#define BTN_TAG_SectionCar_TextFieldSubVChooseBtn_CarImg 1000

//row_num 业主 个人信息
#define Cell_Name_TextFieldTextArr_SectionOne_RowNum 0
#define Cell_Gender_TextFieldTextArr_SectionOne_RowNum 1
#define Cell_IdCard_TextFieldTextArr_SectionOne_RowNum 2
//家属 个人信息
#define Cell_Name_TextFieldTextArr_SectionOne_OtherUser_RowNum   0
#define Cell_Gender_TextFieldTextArr_SectionOne_OtherUser_RowNum 1
#define Cell_Phone_TextFieldTextArr_SectionOne_OtherUser_RowNum  2
#define Cell_IdCard_TextFieldTextArr_SectionOne_OtherUser_RowNum 3
#define Cell_Relationship_TextFieldTextArr_SectionOne_OtherUser_RowNum    4
#define Cell_HouseAddressStr_TextFieldTextArr_SectionOne_OtherUser_RowNum 5

typedef enum : NSUInteger {
    CertificationVc_Type_MainUser_Add=0, //业主
    CertificationVc_Type_MainUser_ReEdit=1,
    CertificationVc_Type_OtherUser_Add=2,
    CertificationVc_Type_OtherUser_ReEdit=3,//家属
} CertificationVc_Type; //业主 家属 详情页类型

NS_ASSUME_NONNULL_BEGIN

@interface UserCertificationBaseDetailVC : BaseViewController
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *okBtn;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) ChooseGenderView *chooseGenderView;
//@property (nonatomic,strong) ChooseCarTypeView *chooseCarTypeView;//换
@property (nonatomic,strong) PopViewCarType *popviewCarType;
@property (nonatomic,strong) PopViewRelationship *popViewRelationship;
@property (nonatomic,assign) BOOL carIsAllShow;
@property (nonatomic,assign) NSInteger nowPopViewChooseHouseWithRowNum;//房产
@property (nonatomic,assign) NSInteger nowPopViewChooseCarIdWithSectionNum;//车辆车牌号点击时
@property (nonatomic,assign) NSInteger nowPopViewChooseCarTypeWithSectionNum;//车辆类型点击时选择的（section-2）tag处赋值
@property (nonatomic,assign) NSInteger nowPopViewChooseCarImgWithSectionNum;//车辆图片点击时选择的（section-2）
@property (nonatomic,strong) NSMutableArray<UIImage *>*saveCarImgArr;//仅用于显示的图片存储arr （section-2）

//家属
@property (nonatomic,strong) NSMutableArray *titleArrSectionOneOfOtherUser;
@property (nonatomic,strong) NSMutableArray *textFieldTextArrSectionOneOfOtherUser;//框内信息
@property (nonatomic,strong) NSMutableArray *textFieldPlaceholderArrOneOfOtherUser;
//业主
@property (nonatomic,strong) NSMutableArray *titleArrSectionOne;
@property (nonatomic,strong) NSMutableArray *textFieldTextArrSectionOne;//框内信息
@property (nonatomic,strong) NSMutableArray *textFieldPlaceholderArrOne;
//车辆
@property (nonatomic,strong) NSMutableArray *titleArrSectionCar;
@property (nonatomic,strong) NSMutableArray *textFieldPlaceholderArrCar;
//房产
@property (nonatomic,strong) NSMutableArray *titleArrSectionHouse;
@property (nonatomic,strong) NSMutableArray *textFieldPlaceholderArrHouse;

@property (nonatomic,strong) UserInfoRegistAllInfoWillSubmitModel *okModel;
//@property (nonatomic,strong) UIImage *carImg;
//@property (nonatomic,strong) NSString *carImgUrl;

@property (nonatomic,strong) NSMutableArray *houseAddressModelArr;//房屋信息的数字存放区域
@property (nonatomic,strong) NSMutableArray *carInfoModelArr;//车辆信息的存放区  (业主 家属 不一样的初始化)
@property (nonatomic,strong) UserInfoRegistModel *mainUserModel;//业主 编辑状态查看状态时 得到数据时使用
//_______________________
@property (nonatomic,assign) CertificationVc_Type type;//新增业主，修改业主，添加家属，修改家属
@property (nonatomic,assign) NSInteger detailId; //编辑或查看状态时
@property (nonatomic,assign) NSInteger houseId; //门牌号ID 家属时使用 //业主时不使用ID查全部
@property (nonatomic,assign) NSInteger communityId;//小区ID
@end

NS_ASSUME_NONNULL_END
