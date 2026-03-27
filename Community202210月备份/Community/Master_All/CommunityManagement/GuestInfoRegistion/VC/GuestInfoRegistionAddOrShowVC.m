//
//  GuestInfoRegistionEditVC.m
//  Community
//
//  Created by 余莹 on 2020/12/4.
//

#import "GuestInfoRegistionAddOrShowVC.h"
#import "GuestInfoRegistionAccompanyVC.h"       //随行
#import "GuestInfoRegistionOkShowQrCardVC.h"    //成功后提交/详情查看时的二维码界面
#import "GuestInfoRegistionOkShowQrCardLateVC.h"    //成功后提交/详情查看时的二维码界面

#import "CarPaltWebViewVC.h"//车牌输入的h5vc
//view
#import "GuestInfoRegistionEditTextFieldTableViewCell.h"
#import "GuestInfoRegistionEditShowRightBtnTableViewCell.h"
#import "GuestInfoRegistionCarTypeHaveTextFieldAndBtnTableViewCell.h"
#import "GuestInfoRegistionCarTypeHaveChooseBtnTableViewCell.h"

#import "PopViewChooseUserHouse.h"      //房产list
#import "PopViewChooseVisitReason.h"    //邀请事情缘由
#import "PopViewChooseVisitTime.h"      //访问时间
#import "PopViewChooseAuthorisation.h"  //门禁2种
#import "PopViewChooseCarType.h"        //车辆类型
#import "GuestEditVcSubHistoryCarListPopView.h" //车辆历史记录列表popv

 
#define GuestInfoRegistionEditTextFieldTableViewCell_Identifier @"GuestInfoRegistionEditTextFieldTableViewCell"
#define GuestInfoRegistionEditShowRightBtnTableViewCell_Identifier @"GuestInfoRegistionEditShowRightBtnTableViewCell"
#define GuestInfoRegistionCarTypeHaveTextFieldAndBtnTableViewCell_Identifier @"GuestInfoRegistionCarTypeHaveTextFieldAndBtnTableViewCell"
#define GuestInfoRegistionCarTypeHaveChooseBtnTableViewCell_Identifier @"GuestInfoRegistionCarTypeHaveChooseBtnTableViewCell"


#define GiestDeletVcFooterBtn_Tag_OnTime     (500)
#define GiestDeletVcFooterBtn_Tag_ExpieTime  (501)
#define GiestDeletVcFooterBtn_Tag_Add        (502)


//model
#import "GuestInfoWillRegisterModel.h"
#import "GuestInfoWillRegisterAccomPanyCarModel.h"
#import "GuestInfoWillRegisterAccomPanyPersonModel.h"

//cell row num 赋值时使用
#define name_cell_SectionOne_rowNum 0
#define phone_cell_SectionOne_rowNum 1
#define address_cell_SectionOne_rowNum 2
//#define reson_cell_SectionOne_rowNum 3
#define time_cell_SectionOne_rowNum 3 //1029 来访事由 被去掉

#define carId_cell_SectionTwo_rowNum 0
#define carType_cell_SectionTwo_rowNum 1

#define accessPersonAndCar_cell_SectionThr_rowNum 0
#define communitAuthor_cell_SectionFour_rowNum 0
#define buildingAuthor_cell_SectionFour_rowNum 1
 
//UI 时使用
#define TableView_Section_Num 4
//#define TableView_Section_One_Row_Num 5
#define TableView_Section_One_Row_Num 4 //1029去掉来访事由
#define TableView_Section_Two_Row_Num 2
#define TableView_Section_Thr_Row_Num 1
#define TableView_Section_Four_Row_Num 2

#define TableViewCell_Heitht_Nomal 50
#define TableView_Section_HeaderView_Height 40

//Action 相关使用
#define Tag_TextField_SectionOne 260
#define Tag_TextField_SectionTwo 270
#define Tag_TextField_SectionThr 280
#define Tag_TextField_SectionFour 290

#define Popview_Tag_VisitReason 300
#define Popview_Tag_Authorisation_one 301
#define Popview_Tag_Authorisation_two 302
#define Popview_Tag_CarType 303
#define Popview_Tag_UserHouse 304
#define Popview_Tag_CarHistoryList 305


@interface GuestInfoRegistionAddOrShowVC () <UITextFieldDelegate,BasePopTableViewChooseDelegate,PopViewChooseVisitTimeDelegate,PopViewCarTypeDelegate>
@property (nonatomic,strong) LabelYu *headerView;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
//popview
@property (nonatomic,strong) PopViewChooseUserHouse *housePopView;
@property (nonatomic,strong) PopViewChooseVisitReason *resonPopView;
@property (nonatomic,strong) PopViewChooseVisitTime *timePpoView;
@property (nonatomic,strong) PopViewChooseAuthorisation *authorPopViewOne;//门禁
@property (nonatomic,strong) PopViewChooseAuthorisation *authorPopViewTwo;
@property (nonatomic,strong) PopViewChooseCarType *carTypePooView;
@property (nonatomic,strong) GuestEditVcSubHistoryCarListPopView *carHistoryListPopView;
//UI textStr
@property (nonatomic,strong) NSMutableArray *titleLabelArrSectionOne;
@property (nonatomic,strong) NSMutableArray *textFieldPlaceholderArrSectionOne;//人员信息
@property (nonatomic,strong) NSMutableArray *titleLabelArrSectionTwo;
@property (nonatomic,strong) NSMutableArray *textFieldPlaceholderArrSectionTwo;//车辆信息
@property (nonatomic,strong) NSMutableArray *titleLabelArrSectionThr;
@property (nonatomic,strong) NSMutableArray *textFieldPlaceholderArrSectionThr;//随行
@property (nonatomic,strong) NSMutableArray *titleLabelArrSectionFour;
@property (nonatomic,strong) NSMutableArray *textFieldPlaceholderArrSectionFour;//授权
//数据显示时
@property (nonatomic,strong) NSMutableArray *textFieldArrSectionOne;//人员信息
@property (nonatomic,strong) NSMutableArray *textFieldArrSectionTwo;//车辆信息
@property (nonatomic,strong) NSMutableArray *textFieldArrSectionThr;//随行
@property (nonatomic,strong) NSMutableArray *textFieldArrSectionFour;//授权
//数据list
@property (nonatomic,strong) NSMutableArray *userHousePopViewDataSource;//用户房屋信息列表
@property (nonatomic,strong) NSMutableArray *resonPopViewDataSource;//访问事由
@property (nonatomic,strong) NSMutableArray *authorOneDataSource;//门禁 //isCommunityAccess 照旧不动
@property (nonatomic,strong) NSMutableArray *authorTwoDataSource;//楼宇门禁 //0917 楼宇门禁改成车辆门禁isCarBanAccess 是否授予来访人楼栋门禁权限，0无，1二维码通行证，2可视对讲
@property (nonatomic,strong) NSMutableArray *carPopViewDataSource;//车辆类型
@property (nonatomic,strong) NSMutableArray *carHistoryListPopViewDataSource;//车辆历史列表
@property (nonatomic,assign) NSInteger saveAndShowIntValueWithCarAlternativePayStaus;//车费代缴状态;   0:不代缴;   1:代缴;   默认为0
@property (nonatomic,assign) NSInteger saveAndShowIntValueWithExpireStatus;//是否过期 0否1已过期
//点击后 提交前使用
@property (nonatomic,strong) UserHouseModel *houserModel;//当前房屋model____此model 只用在家属部分
@property (nonatomic,strong) VisitReasonModel *resonModel;//访问事由
@property (nonatomic,strong) AccessModel *communitAccessModel;//门禁
@property (nonatomic,strong) AccessModel *carAccessModel;//楼宇门禁 0917改为车辆门禁
@property (nonatomic,strong) CarTypeModel *carTypeModel;//车辆类型

@property (nonatomic,assign) BOOL time_thisPostDataNotNeedToGeShiBool;//提交前——时间不需要处理格式。
@property (nonatomic,strong) NSString *beginTimeStr;//来访时间-begin
@property (nonatomic,strong) NSString *endTimeStr;//来访时间-end
@property (nonatomic,strong) NSMutableArray *accompayCarArr;//随行车辆数组
@property (nonatomic,strong) NSMutableArray *accompayPersonArr;//随行人员数组
@property (nonatomic,strong) NSString *visitorIdStr;//查看状态时的二维码数据

@property (nonatomic,assign) BOOL isPushGoToCarPvcDontRemoveSelfBool; //去输入车牌号界面类型 不removeselfvc


@end

@implementation GuestInfoRegistionAddOrShowVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"来访人员登记";
    if (self.type == Type_Show_GuestInfoRegistionEditVC) {
        self.tableView.tableFooterView = [UIView new];
        self.tableView.tableFooterView = self.footerView;
    }
    if (self.type == Type_Add_GuestInfoRegistionEditVC) {
        self.tableView.tableFooterView = self.footerView;
    }
//    [self initNavRightBtn];//1028右上提示按钮隐藏
    [self noticeInit];
    self.view.backgroundColor = [ThemeManager shareManager].guestInfoRegisterVcBackgroundColor;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)initNavRightBtn{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[ThemeImg themeImageWithBaseName:@"warn"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItems:@[rightItem]];
}
#pragma mark == init //随行相关的notice
- (void)noticeInit{
    if (self.type == Type_Add_GuestInfoRegistionEditVC) {
        Y_NSNotificationCenter_Creat_NameAction(GuestInfo_Add_Accompany_Person_Notice_Name, accompyPersonNoticeAction:);
        Y_NSNotificationCenter_Creat_NameAction(GuestInfo_Add_Accompany_Car_Notice_Name, accompyCarNoticeAction:);
    }
}
#pragma mark == initdata
- (void)initData{
    if (self.type == Type_Add_GuestInfoRegistionEditVC) {
        //门禁上传数据
        self.communitAccessModel = [[AccessModel alloc]init];
        self.communitAccessModel.code = 1;
        self.communitAccessModel.name = @"二维码通行";
        //门禁展示文本
       // self.textFieldArrSectionFour[communitAuthor_cell_SectionFour_rowNum] = [TextShowWithModelStr textShowWithModelStr:model.isCommunityAccessStr];
        self.textFieldArrSectionFour = [[NSMutableArray alloc]initWithObjects:@"二维码通行", nil];
    }
    if (self.type == Type_Show_GuestInfoRegistionEditVC) {
        Y_SVP_SHOW_MES_IsLoading_15Delay
        [GuestInfoWillRegisterModel showDetailGuestInfoRegistWithParm:@{@"id":@(self.guestInfonationId)}.mutableCopy withReturnResult:^(BOOL resultBool, GuestInfoWillRegisterModel *model) {
            dispatch_async(dispatch_get_main_queue(), ^{
               Y_SVP_DISMISS
            });
            if (resultBool) {
                //处理成可展示数据 展示model 和addmodel 在随行部分 不一样
                self.textFieldArrSectionOne[name_cell_SectionOne_rowNum] = [TextShowWithModelStr textShowWithModelStr:model.name];
                self.textFieldArrSectionOne[phone_cell_SectionOne_rowNum] = [TextShowWithModelStr textShowWithModelStr:model.contact];
                //
               // self.textFieldArrSectionOne[reson_cell_SectionOne_rowNum] = [TextShowWithModelStr textShowWithModelStr:model.reasonStr];
                self.resonModel = [[VisitReasonModel alloc]init];//
                self.resonModel.name = [TextShowWithModelStr textShowWithModelStr: model.reasonStr];
                self.resonModel.code = model.reason;
                //0917 适配物业后台时间精确到小时分秒
                //1027 编辑状态下 时间初始化要有最完整长串
                self.beginTimeStr =  [TextShowWithModelStr textShowWithModelStr: model.startTime];
                self.endTimeStr  = [TextShowWithModelStr textShowWithModelStr: model.endTime];
                NSString *showBegT = self.beginTimeStr.length > 10 ?  [self.beginTimeStr substringWithRange:NSMakeRange(5, 11)] : self.beginTimeStr;
                NSString *showEndT =  self.endTimeStr .length > 10 ?  [self.endTimeStr  substringWithRange:NSMakeRange(5, 11)] : self.endTimeStr ;
                if (self.endTimeStr.length>0) {
                    self.textFieldArrSectionOne[time_cell_SectionOne_rowNum] = [NSString stringWithFormat:@"%@至%@",showBegT,showEndT];
                }else{
                    self.textFieldArrSectionOne[time_cell_SectionOne_rowNum] = [NSString stringWithFormat:@"%@",showBegT];
                }
             
                //
                self.textFieldArrSectionOne[address_cell_SectionOne_rowNum] = [TextShowWithModelStr textShowWithModelStr:model.address];//地址
                self.houserModel = [[UserHouseModel alloc]init];
                self.houserModel.address = [TextShowWithModelStr textShowWithModelStr:model.address];
                self.houserModel.communityId = model.communityId;
                self.houserModel.buildingId = model.buildingId;
                //0411 过期状态重新生成时需要
                self.houserModel.houseId = model.houseId;
                self.houserModel.pidStr = model.unitId;

                //
                NSString *carP = [TextShowWithModelStr textShowWithModelStr:model.carPlate] ;
                NSString *carT = [TextShowWithModelStr textShowWithModelStr:model.carTypeStr];
                self.textFieldArrSectionTwo[carId_cell_SectionTwo_rowNum] = (carP.length>0) ? carP : @"暂无随行车辆";
                self.textFieldArrSectionTwo[carType_cell_SectionTwo_rowNum] = (carT.length>0) ? carT : @"暂无随行车辆";
                self.carTypeModel = [[CarTypeModel alloc]init];
                self.carTypeModel.code = model.carType;
                self.carTypeModel.name = model.carTypeStr;
                
               //随行
                self.accompayCarArr = [NSMutableArray arrayWithArray:[CarInfoModel mj_objectArrayWithKeyValuesArray:model.visitingCarRecordList]];
                self.accompayPersonArr = [NSMutableArray arrayWithArray:[GuestInfoModel mj_objectArrayWithKeyValuesArray:model.visitorPersonRecordList]];
                
                //门禁
                self.communitAccessModel = [[AccessModel alloc]init];
                self.carAccessModel = [[AccessModel alloc]init];
                self.communitAccessModel.code = model.isCommunityAccess;
                self.communitAccessModel.name = model.isCommunityAccessStr;
//                self.buildAccessModel.code = model.isBuildingAccess;
//                self.buildAccessModel.name = model.isBuildingAccessStr;
                //0917楼宇门禁改为车辆门禁
                self.carAccessModel.code = model.isCarBanAccess;
                self.carAccessModel.name = model.isCarBanAccessStr;
                //门禁文本
                self.textFieldArrSectionFour[communitAuthor_cell_SectionFour_rowNum] = [TextShowWithModelStr textShowWithModelStr:model.isCommunityAccessStr];
//                self.textFieldArrSectionFour[buildingAuthor_cell_SectionFour_rowNum] = [TextShowWithModelStr textShowWithModelStr:model.isBuildingAccessStr];
                self.textFieldArrSectionFour[buildingAuthor_cell_SectionFour_rowNum] = [TextShowWithModelStr textShowWithModelStr:model.isCarBanAccessStr];//0917楼宇门禁改为车辆门禁
                //
                self.visitorIdStr = model.idStr;
                //
                self.saveAndShowIntValueWithCarAlternativePayStaus = model.carAlternativePaymentStatus;
                //更新footerv headerv的展示等相关属性//tipLabel  过期的label
                self.saveAndShowIntValueWithExpireStatus = model.expireStatus;
                
                [self whenChangeTypeWithUpFooterView];
                [self whenChangeTypeWithUpHeaderView];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }];
    }
}
#pragma mark === right
- (void)rightBtnAction:(UIButton *)sender{
    DLog(@"rightBtnAction");
    Y_SVP_SHOW_INFO_MES_5Delay(@"请正确输入访客信息，以保证访客正常出入。");
}

#pragma mark === footerBtnAction
- (void)guestEditVcfooterBtnAction:(UIButton *)sender{
    
    switch (sender.tag) {
        case  GiestDeletVcFooterBtn_Tag_Add:
            [self footerWithAddAction];
            break;
        case  GiestDeletVcFooterBtn_Tag_OnTime:
            [self footerWithShowCodeVcAction];
            break;
        case  GiestDeletVcFooterBtn_Tag_ExpieTime:
            [self footerWithCreatNewInfoAction];
            break;
        default:
            break;
    }
 
}
#pragma mark == 重新创建一个访客邀请 ｜（本来为查看状态 + 二维码已过期）｜改变当前页的状态 或做 跳转｜（ 时间可改动 其他不可改动 变成 编辑状态+提交按钮）
- (void)footerWithCreatNewInfoAction{
    //类型为修改类型
    self.type = Type_Edit_GuestInfoRegistionEditVC;
    //footerV更新
    [self whenChangeTypeWithUpFooterView];
    [self whenChangeTypeWithUpHeaderView];
    //showType cell不可点击 在cell内增加Edit类型相关处理允许yes （做刷新处理cell是否允许交互）
    [self.tableView reloadData];
}
#pragma mark == 查看二维码 做跳转动作｜ （本来为查看状态 + 二维码没过期）
- (void)footerWithShowCodeVcAction{
    [self goToQrVcWithIsNowSuccessType:NO andVisitorIdStr:self.visitorIdStr];
}
#pragma mark == 提交按钮 (add类型 edit类型)
- (void)footerWithAddAction{
    NSLog(@"提交信息 btn");
    //访客登记--提交信息
    if (self.type == Type_Add_GuestInfoRegistionEditVC) {
        GuestInfoWillRegisterModel *willRegisterModel = [[GuestInfoWillRegisterModel alloc]init];
        //个人信息
        willRegisterModel.name = [NSString stringWithFormat:@"%@",self.textFieldArrSectionOne[name_cell_SectionOne_rowNum]];
        willRegisterModel.contact =  [NSString stringWithFormat:@"%@",self.textFieldArrSectionOne[phone_cell_SectionOne_rowNum]];//contact mobile
        if (willRegisterModel.name.length==0) {
            Y_SVP_SHOW_ERR_MES(@"请输入访客姓名");
            return;
        }
        if (willRegisterModel.contact.length==0) {
            Y_SVP_SHOW_ERR_MES(@"请输入访客电话");
            return;
        }
        if ((self.houserModel.address.length == 0)) {
            Y_SVP_SHOW_ERR_MES(@"请输入地址");
            return;
        }
        if (self.beginTimeStr.length == 0) {
            Y_SVP_SHOW_ERR_MES(@"请输入来访时间");
            return;
        }
        
        //门禁信息
        //#define communitAuthor_cell_SectionFour_rowNum 0 #define buildingAuthor_cell_SectionFour_rowNum 1
        NSString *communitAuthorS = [NSString stringWithFormat:@"%@",self.textFieldArrSectionFour[communitAuthor_cell_SectionFour_rowNum]];
        NSString *buildingAuthorS = [NSString stringWithFormat:@"%@",self.textFieldArrSectionFour[buildingAuthor_cell_SectionFour_rowNum]];
        if (communitAuthorS.length == 0 || buildingAuthorS.length == 0) {
            Y_SVP_SHOW_ERR_MES(@"请选择门禁");
            return;
        }
     
        willRegisterModel.communityId = self.houserModel.communityId;
        willRegisterModel.buildingId = self.houserModel.buildingId;
        willRegisterModel.address = self.houserModel.address;
        willRegisterModel.reason = self.resonModel.code;
        //处理上传时间
    
        if ( self.time_thisPostDataNotNeedToGeShiBool == YES) {//不需要处理时间格式bool
        }else{
            //只一天endTime做时分秒的后半截
            if (self.beginTimeStr.length>18 || self.beginTimeStr.length<=0) { //有尾数的情况 开始时间不做23点59分59秒的处理 （尾数只碰到一次 可能是重复调用导致 做排除）()
                DLog(@"提交访客邀请的时间__x ： %@ 。%@",self.beginTimeStr,self.endTimeStr);
                Y_SVP_SHOW_ERR_MES(@"需要选择来访时间");//(提交过一次后 原本的时间格式已经更换过了)
                return;
            }
           
            DLog(@"提交访客邀请的时间__a ： %@ 。%@",self.beginTimeStr,self.endTimeStr);
           /** 2021 1020 隐藏开始结束时间数据的尾数处理 popview 已经处理过了 */
            if (self.endTimeStr.length==0) {
                self.endTimeStr = self.beginTimeStr;//做成同一天的0点到23点
            }
            self.endTimeStr = [NSString stringWithFormat:@"%@ 23:59:59",self.endTimeStr];
            //｜ 不是今天 用00点 ｜｜｜ 当前今天 不用0点 用当前后一分钟开始有效
            if (![self.beginTimeStr isEqualToString: [ToolOfTimeChangeFormat shortStrOfnowTimeWithYearAndMonthAndDay] ]) {
                self.beginTimeStr = [NSString stringWithFormat:@"%@ 00:00:00",self.beginTimeStr];
            }else{
                NSString *curTimeIv = [ToolOfTimeChangeFormat currentTimeStr];
                NSString *lastOneMinTimeIv = [NSString stringWithFormat:@"%ld",([curTimeIv integerValue] + 60*1000)];//60秒后
                self.beginTimeStr = [ToolOfTimeChangeFormat getDataStrWithStr:lastOneMinTimeIv];
            }
        }

        DLog(@"提交访客邀请的时间__bbb ： %@ 。%@",self.beginTimeStr,self.endTimeStr);

        //
        willRegisterModel.startTime = self.beginTimeStr;
        willRegisterModel.endTime = self.endTimeStr;
        //主客人车辆信息
        willRegisterModel.carType = self.carTypeModel.code;//1027车辆类型数据去除UI，默认cartype=0
        NSString *willSendCarPlateStr =  [NSString stringWithFormat:@"%@",self.textFieldArrSectionTwo[carId_cell_SectionTwo_rowNum]];
        if ([willSendCarPlateStr containsString:@"暂无"]) {//滞空
            willSendCarPlateStr = @"";
            willRegisterModel.carType = 0;
        }
        willRegisterModel.carPlate = willSendCarPlateStr;
        //门禁
        willRegisterModel.isCommunityAccess = self.communitAccessModel.code;
//        willRegisterModel.isBuildingAccess = self.buildAccessModel.code;
        //0917 改楼宇门禁为车辆门禁
        willRegisterModel.isCarBanAccess =  self.carAccessModel.code;
        //随行 人员
        NSArray* accompanyCarArr = [NSArray arrayWithArray:[CarInfoModel mj_keyValuesArrayWithObjectArray:self.accompayCarArr]];
        NSArray *accmpanyCarModelArr = [NSArray arrayWithArray: [GuestInfoWillRegisterAccomPanyCarModel mj_objectArrayWithKeyValuesArray:accompanyCarArr]];
        willRegisterModel.visitingCarRecordList = [NSMutableArray arrayWithArray:[GuestInfoWillRegisterAccomPanyCarModel mj_keyValuesArrayWithObjectArray:accmpanyCarModelArr]];
        //随行 车辆
        NSArray* accompayPersonArr = [NSArray arrayWithArray:[GuestInfoModel mj_keyValuesArrayWithObjectArray:self.accompayPersonArr]];
        NSArray *accompayPersonModelArr = [NSArray arrayWithArray: [GuestInfoWillRegisterAccomPanyPersonModel mj_objectArrayWithKeyValuesArray:accompayPersonArr]];
        willRegisterModel.visitorPersonRecordList = [NSMutableArray arrayWithArray:[GuestInfoWillRegisterAccomPanyPersonModel mj_keyValuesArrayWithObjectArray:accompayPersonModelArr]];
      
        //
        willRegisterModel.carAlternativePaymentStatus =  self.saveAndShowIntValueWithCarAlternativePayStaus;//车费是否代缴 1027
        //20220316
        willRegisterModel.unitId = self.houserModel.pidStr;
        willRegisterModel.houseId = self.houserModel.houseId;
        NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithDictionary:[willRegisterModel mj_keyValues]];
        [self guestOkWithParm:parm];
    }
    //访客登记--修改信息 //暂无修改
    if (self.type == Type_Edit_GuestInfoRegistionEditVC) {
        GuestInfoWillRegisterModel *willRegisterModel = [[GuestInfoWillRegisterModel alloc]init];
        //个人信息
        willRegisterModel.name = [NSString stringWithFormat:@"%@",self.textFieldArrSectionOne[name_cell_SectionOne_rowNum]];
        willRegisterModel.contact =  [NSString stringWithFormat:@"%@",self.textFieldArrSectionOne[phone_cell_SectionOne_rowNum]];//contact mobile
        
        //门禁信息
        Y_SVP_SHOW_MES_Loading
        willRegisterModel.communityId = self.houserModel.communityId;
        willRegisterModel.buildingId = self.houserModel.buildingId;
        willRegisterModel.address = self.houserModel.address;
        willRegisterModel.reason = self.resonModel.code;
        //处理上传时间
        if ( self.time_thisPostDataNotNeedToGeShiBool == YES) {//不需要处理时间格式bool
        }else{
            //只一天endTime做时分秒的后半截
            if (self.beginTimeStr.length==19 && self.endTimeStr.length==19) {
                //未改动时间 没有做选择 直接使用的initShow的时间数据 == 已经过期时间
                Y_SVP_SHOW_INFO_MES(@"时间已过期，请重新选择来访时间");
                return;
            }else{
                if (self.beginTimeStr.length>18 || self.beginTimeStr.length<=0) { //有尾数的情况 开始时间不做23点59分59秒的处理 （尾数只碰到一次 可能是重复调用导致 做排除）()
                    DLog(@"提交访客邀请的时间__x ： %@ 。%@",self.beginTimeStr,self.endTimeStr);
                    Y_SVP_SHOW_ERR_MES(@"缺失来访时间数据");//0为主
                    return;
                }
               
                DLog(@"提交访客邀请的时间__a ： %@ 。%@",self.beginTimeStr,self.endTimeStr);
               /** 2021 1020 隐藏开始结束时间数据的尾数处理 popview 已经处理过了 */
                if (self.endTimeStr.length==0) {
                    self.endTimeStr = self.beginTimeStr;//做成同一天的0点到23点
                }
                self.endTimeStr = [NSString stringWithFormat:@"%@ 23:59:59",self.endTimeStr];
                //｜ 不是今天 用00点 ｜｜｜ 当前今天 不用0点 用当前后一分钟开始有效
                if (![self.beginTimeStr isEqualToString: [ToolOfTimeChangeFormat shortStrOfnowTimeWithYearAndMonthAndDay] ]) {
                    self.beginTimeStr = [NSString stringWithFormat:@"%@ 00:00:00",self.beginTimeStr];
                }else{
                    NSString *curTimeIv = [ToolOfTimeChangeFormat currentTimeStr];
                    NSString *lastOneMinTimeIv = [NSString stringWithFormat:@"%ld",([curTimeIv integerValue] + 60*1000)];//60秒后
                    self.beginTimeStr = [ToolOfTimeChangeFormat getDataStrWithStr:lastOneMinTimeIv];
                }
              
            }
        }
        
        DLog(@"提交访客邀请的时间__bbb ： %@ 。%@",self.beginTimeStr,self.endTimeStr);

        //
        willRegisterModel.startTime = self.beginTimeStr;
        willRegisterModel.endTime = self.endTimeStr;
        //主客人车辆信息
        willRegisterModel.carType = self.carTypeModel.code;//1027车辆类型数据去除UI，默认cartype=0
        NSString *willSendCarPlateStr =  [NSString stringWithFormat:@"%@",self.textFieldArrSectionTwo[carId_cell_SectionTwo_rowNum]];
        if ([willSendCarPlateStr containsString:@"暂无"]) {//滞空
            willSendCarPlateStr = @"";
            willRegisterModel.carType = 0;
        }
        willRegisterModel.carPlate = willSendCarPlateStr;
        //门禁
        willRegisterModel.isCommunityAccess = self.communitAccessModel.code;
//        willRegisterModel.isBuildingAccess = self.buildAccessModel.code;
        //0917 改楼宇门禁为车辆门禁
        willRegisterModel.isCarBanAccess =  self.carAccessModel.code;
        //随行 人员
        NSArray* accompanyCarArr = [NSArray arrayWithArray:[CarInfoModel mj_keyValuesArrayWithObjectArray:self.accompayCarArr]];
        NSArray *accmpanyCarModelArr = [NSArray arrayWithArray: [GuestInfoWillRegisterAccomPanyCarModel mj_objectArrayWithKeyValuesArray:accompanyCarArr]];
        willRegisterModel.visitingCarRecordList = [NSMutableArray arrayWithArray:[GuestInfoWillRegisterAccomPanyCarModel mj_keyValuesArrayWithObjectArray:accmpanyCarModelArr]];
        //随行 车辆
        NSArray* accompayPersonArr = [NSArray arrayWithArray:[GuestInfoModel mj_keyValuesArrayWithObjectArray:self.accompayPersonArr]];
        NSArray *accompayPersonModelArr = [NSArray arrayWithArray: [GuestInfoWillRegisterAccomPanyPersonModel mj_objectArrayWithKeyValuesArray:accompayPersonArr]];
        willRegisterModel.visitorPersonRecordList = [NSMutableArray arrayWithArray:[GuestInfoWillRegisterAccomPanyPersonModel mj_keyValuesArrayWithObjectArray:accompayPersonModelArr]];
      
        //
        willRegisterModel.carAlternativePaymentStatus =  self.saveAndShowIntValueWithCarAlternativePayStaus;//车费是否代缴 1027
        //20220316
        willRegisterModel.unitId = self.houserModel.pidStr;
        willRegisterModel.houseId = self.houserModel.houseId;
        NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithDictionary:[willRegisterModel mj_keyValues]];
        NSLog(@"edit_type 访客 重提交 == %@",parm);
        [self guestOkWithParm:parm];
    }
}
 //ok_btn 
- (void)guestOkWithParm:(NSMutableDictionary *)parm{//缺少预期来访时间,缺少社区ID,缺少楼栋ID,缺少详细地址,缺少来访人姓名";
    Y_SVP_SHOW_MES_Loading
    WEAKSELF
    [GuestInfoWillRegisterModel addGuestInfoRegistWithParm:parm withReturnResult:^(NSDictionary * dic, BOOL success) {
        Y_SVP_DISMISS
        STRONGSELF
        if (success) {
            Y_SVP_SHOW_SUCCESS_MES(@"添加成功");
            //0630 成功后去二维码页面 返回时不到编辑页
            //刷新列表页
            Y_NSNotificationCenter_PostNotice_NilObject_Name(GuestOneInfoAddSuccessWillRefreshListVc_Notice_Name)
           
            //先跳转二维码页
            /**
             data =     {
                 id = 75345105560670208;
             };
             */
            if (isNil(dic)) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self popVC];
                });
                return;
            }
            NSString *visitorIdStr = [[dic allKeys]containsObject:@"id"] ? [dic objectForKey:@"id"] : @"";
          
            [strongSelf goToQrVcWithIsNowSuccessType:YES andVisitorIdStr:visitorIdStr];
            
            //再删除nav中的编辑页 跳转了再删 不然就nil了 //0719 延时处理删除
            /**1020换成dis内做处理
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                     if ([self respondsToSelector:@selector(removeEditVc)]) {
                         [self performSelector:@selector(removeEditVc) withObject:nil];
                     }
             });
             
             */
          
        }else{
            self.time_thisPostDataNotNeedToGeShiBool = YES;//下次不需要处理时间格式bool
        }
    }];
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //去输入车牌号界面类型 不removeselfvc
    if (self.isPushGoToCarPvcDontRemoveSelfBool){
    //其他
    }else{
        //新增状态下的离开本页面。删掉自己（ 去二维码界面 返回时 需要一次返回到列表 ）
        //查看状态下 已经过期 再次提交类型 (修改成功状态下的删掉自己 1026)
        //查看状态下的离开本页面。 （ 去二维码界面 返回时 回到本页面）不能删掉自己。
        if (self.type == Type_Add_GuestInfoRegistionEditVC || self.type == Type_Edit_GuestInfoRegistionEditVC) {
            [self removeEditVc];
        }
    }
}
- (void)removeEditVc{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *vcArr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
         for (UIViewController *vc in vcArr) {
             if ([vc isKindOfClass:[GuestInfoRegistionAddOrShowVC class]]) {
                 [vcArr removeObject:vc];
                 break;
             }
         }
         self.navigationController.viewControllers = vcArr;
    });
}
- (void)goToQrVcWithIsNowSuccessType:(BOOL)nowSuccessType andVisitorIdStr:(NSString *)idStr{//Type_Show_GuestInfoRegistionEditVC 暂时3种添加编辑查看里面只有两种有使用
    dispatch_async(dispatch_get_main_queue(), ^{
//        GuestInfoRegistionOkShowQrCardVC *qrCardVc = [[GuestInfoRegistionOkShowQrCardVC alloc]init];
        GuestInfoRegistionOkShowQrCardLateVC *qrCardVc = [[GuestInfoRegistionOkShowQrCardLateVC alloc]init];
        qrCardVc.isNowSuccessToShow = nowSuccessType;
        qrCardVc.visitorId = idStr;
        qrCardVc.houseNameShowStr = self.houserModel.address;
        qrCardVc.personNameShowStr = [TextShowWithModelStr textShowWithModelStr:self.textFieldArrSectionOne[name_cell_SectionOne_rowNum]];//名字
        if ( self.endTimeStr.length<=0) {//以天计算
            qrCardVc.timeDelineShowStr = self.beginTimeStr;
        }else{
            qrCardVc.timeDelineShowStr = self.endTimeStr;
        }
        [self pushVc:qrCardVc]; 
    });
  
}
#pragma mark == notice
- (void)accompyPersonNoticeAction:(NSNotification *)notice{
    NSMutableArray *arr =   [notice.userInfo objectForKey:GuestInfo_Add_Accompanu_UserInfo_Key_Person];
    self.accompayPersonArr = arr;
    self.textFieldArrSectionThr[0] = [NSString stringWithFormat:@"人员%lu人 车辆%lu辆",(unsigned long)self.accompayPersonArr.count,(unsigned long)self.accompayCarArr.count];
    [self.tableView reloadData];
}
- (void)accompyCarNoticeAction:(NSNotification *)notice{
    NSMutableArray *arr =   [notice.userInfo objectForKey:GuestInfo_Add_Accompanu_UserInfo_Key_Car];
    self.accompayCarArr = arr;
    self.textFieldArrSectionThr[0] = [NSString stringWithFormat:@"人员%lu人 车辆%lu辆",(unsigned long)self.accompayPersonArr.count,(unsigned long)self.accompayCarArr.count];
    [self.tableView reloadData];
    
}
#pragma mark == pop View  touch VisitReason+门禁+house
- (void)basePopViewTag:(NSInteger)tag OfSubTableViewTouchWithIndexPath:(NSIndexPath *)indexPath{
    if (tag==Popview_Tag_UserHouse) {//社区房屋信息
        self.houserModel = self.userHousePopViewDataSource[indexPath.row];
        self.textFieldArrSectionOne[address_cell_SectionOne_rowNum] = [NSString stringWithFormat:@"%@",self.houserModel.address];;

//        if (self.houserModel.communityName != nil && self.houserModel.communityName.length>0) {
//            self.textFieldArrSectionOne[address_cell_SectionOne_rowNum] = [NSString stringWithFormat:@"%@ %@",self.houserModel.communityName,self.houserModel.address];;
//        }else{
//            self.textFieldArrSectionOne[address_cell_SectionOne_rowNum] = [NSString stringWithFormat:@"%@",self.houserModel.address];;
//        }
    }
    if (tag==Popview_Tag_VisitReason) {
        VisitReasonModel  *model = self.resonPopViewDataSource[indexPath.row];
        DLog(@"PopViewChooseVisitReason   viewtag=%ld indexPath=%ld str= %@", (long)tag, (long)indexPath.row, model.name);
        self.resonModel = self.resonPopViewDataSource[indexPath.row];
        //self.textFieldArrSectionOne[reson_cell_SectionOne_rowNum] = self.resonModel.name;
    }
    if (tag==Popview_Tag_Authorisation_one) {
        DLog(@"PopViewChoose 门禁 1  viewtag=%ld indexPath=%ld str= %@", (long)tag, (long)indexPath.row,self.authorOneDataSource[indexPath.row]);
        self.communitAccessModel = self.authorOneDataSource[indexPath.row];
        self.textFieldArrSectionFour[communitAuthor_cell_SectionFour_rowNum] = self.communitAccessModel.name;
    }
    if (tag==Popview_Tag_Authorisation_two) {
        DLog(@"PopViewChoose 门禁 2  viewtag=%ld indexPath=%ld str= %@", (long)tag, (long)indexPath.row,self.authorTwoDataSource[indexPath.row]);
        self.carAccessModel = self.authorTwoDataSource[indexPath.row];
        self.textFieldArrSectionFour[buildingAuthor_cell_SectionFour_rowNum] = self.carAccessModel.name;
    }
    if (tag==Popview_Tag_CarHistoryList) {
        DLog(@"PopViewChoose  历史车辆数据 填入车辆数据cell action");
       // NSString *chooseCarInfoName = self.carHistoryListPopViewDataSource[indexPath.row];
        CarInfoModel *carModel = [CarInfoModel mj_objectWithKeyValues:self.carHistoryListPopViewDataSource[indexPath.row]];
        NSString *chooseCarInfoName = [TextShowWithModelStr textShowWithModelStr:carModel.carPlate];
        self.textFieldArrSectionTwo[carId_cell_SectionTwo_rowNum] = chooseCarInfoName;
        
    }
    [self.tableView reloadData];
}
#pragma mark == pop view car history


#pragma mark == pop view cartype
- (void)popViewChooseCarTypeModle:(CarTypeModel *)typeMode{
//    if (tag==Popview_Tag_CarType) {}
        DLog(@"PopViewChoose CarType  %@  %@", typeMode,typeMode.name);
    self.carTypeModel = typeMode;
    self.textFieldArrSectionTwo[carType_cell_SectionTwo_rowNum] = self.carTypeModel.name;
    [self.tableView reloadData];
}

#pragma mark ==  PopViewChoose VisitTime Delegate 时间
- (void)popViewChooseVisitTimeChooseDayArr:(NSMutableArray *)timeStrArr{
    self.time_thisPostDataNotNeedToGeShiBool = NO;//提交前时间需要做格式处理
    DLog(@" PopViewChooseVisitTimeDelegate ====== %@",timeStrArr);
    if ([timeStrArr.lastObject isEqualToString: @""]) {
        self.beginTimeStr = timeStrArr.firstObject;
        self.textFieldArrSectionOne[time_cell_SectionOne_rowNum] = self.beginTimeStr;
        self.endTimeStr = @"";//清空
    }else{
        self.beginTimeStr = timeStrArr.firstObject;
        self.endTimeStr = timeStrArr.lastObject;
        self.textFieldArrSectionOne[time_cell_SectionOne_rowNum] = [NSString stringWithFormat:@"%@至%@",self.beginTimeStr,self.endTimeStr];
    }
    [self.tableView reloadData];
}

#pragma mark === textFiled
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textField textField.tag %ld  \n   %@", (long)textField.tag,textField.text);
    NSInteger tag = textField.tag;
    switch (tag) {
        case Tag_TextField_SectionOne:
        {
//            name
            self.textFieldArrSectionOne[name_cell_SectionOne_rowNum] = textField.text;
        }
            break;
        case Tag_TextField_SectionOne+1:
        {
            //phone
            self.textFieldArrSectionOne[phone_cell_SectionOne_rowNum] = textField.text;
        }
            break;
        case Tag_TextField_SectionTwo:
        {
            //car
            self.textFieldArrSectionTwo[carId_cell_SectionTwo_rowNum] = textField.text;
        }
            break;
            
        default:
            break;
    }
   
}

#pragma mark== tableview ---
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    //0917暂时隐藏随行
    switch (indexPath.section) {
        case 0:
        {
            [self oneSectionTableViewTouchRow:indexPath.row];
        }
            break;
        case 1:
        {
            [self twoSectionTableViewTouchRow:indexPath.row];
        }
            break;
            
        default:
        {
            [self fourSectionTableViewTouchRow:indexPath.row];
        }
            break;
    }
    
}
- (void)oneSectionTableViewTouchRow:(NSInteger)rowNum{
    switch (rowNum) {
        case address_cell_SectionOne_rowNum:
        {
            DLog(@"详细地址");
            [SVProgressHUD showWithStatus:@"正在加载房产"];
            [SVProgressHUD dismissWithDelay:15];
            [UserHouseOrCommunityListModel getUserAllHouseListWithBlock:^(NSArray * arr) {
                self.userHousePopViewDataSource =  [NSMutableArray arrayWithArray:[UserHouseModel mj_objectArrayWithKeyValuesArray:arr]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_DISMISS
                    [self.housePopView showInView:self.view thePopViewTableViewHeight:(Screen_H*0.3) WithArray:self.userHousePopViewDataSource];
                });
            }];
            
        }
            break;
            /**
             case 3:  //1029 来访事由 去掉
             {
                 DLog(@"是由");
                 [SVProgressHUD showWithStatus:@"正在加载事由"];
                 [SVProgressHUD dismissWithDelay:15];
                 [VisitReasonListModel getVisitReasoneListWithBlock:^(NSArray * arr) {
                     self.resonPopViewDataSource =  [NSMutableArray arrayWithArray:[VisitReasonModel mj_objectArrayWithKeyValuesArray:arr]];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         Y_SVP_DISMISS
                         [self.resonPopView showInView:self.view thePopViewTableViewHeight:(Screen_H*0.3) WithArray:self.resonPopViewDataSource];
                     });
                 }];
             }
                 break;
             */
      
        case time_cell_SectionOne_rowNum:
        {
            DLog(@"时间");
             [self.timePpoView showInView:self.view thePopViewSubViewHeight:(Screen_H*0.85) WithArray:@[].mutableCopy];
        }
            break;
            
        default:
            break;
    }
}
- (void)twoSectionTableViewTouchRow:(NSInteger)rowNum{
    switch (rowNum) {
            //return; //cell更换成代缴车费 不需要本调用
            /**
             case 1:
             {
               
                 DLog(@"车类型");
                 [self carTypePopViewShow];
             }
                 break;
             */
        default:
            break;
    }
}

- (void)showHistoryCarListAction:(UIButton *)sender{
    DLog(@"展示隐藏的历史车辆列表v 的控制键 %d",sender.selected);
    [self carHistoryPopViewShow];
}
- (void)payTypeChooseBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    DLog(@"代缴费用 %d",sender.selected);
    self.saveAndShowIntValueWithCarAlternativePayStaus = sender.selected; //车费代缴状态;0:不代缴; 1:代缴;默认为0
    
}
- (void)thrSectionTableViewTouchRow:(NSInteger)rowNum{
    switch (rowNum) {
        case 0:
        {
            DLog(@"随行人员/随行车辆");
            GuestInfoRegistionAccompanyVC *accompanyVc = [[GuestInfoRegistionAccompanyVC alloc]init];
            if (self.type==Type_Show_GuestInfoRegistionEditVC) {
                if (self.accompayCarArr.count==0 && self.accompayPersonArr.count==0) {
                    Y_SVP_SHOW_INFO_MES(@"此次来访记录暂无随行人员/车辆")
                    return;
                }
                accompanyVc.type = Type_Show_GuestInfoRegistionEditVC;
                accompanyVc.guestInfonationId = self.guestInfonationId;
                accompanyVc.carDataSourceArr = self.accompayCarArr;
                accompanyVc.personDataSourceArr = self.accompayPersonArr;
            }else{
                accompanyVc.type = Type_Add_GuestInfoRegistionEditVC;
            }
            [self pushVc:accompanyVc];
        }
            break;
            
        default:
            break;
    }
}
- (void)fourSectionTableViewTouchRow:(NSInteger)rowNum{
    switch (rowNum) {
        case 0:
        {
            DLog(@"门禁");
            if (self.type==Type_Show_GuestInfoRegistionEditVC) {//查看状态
                [self goToQrVcWithIsNowSuccessType:NO andVisitorIdStr:self.visitorIdStr];
                return;
            }
            [self communityAccessPopViewShow];
 
        }
            break;
        case 1:
        {
//            DLog(@"楼宇门禁");
            //0917
            DLog(@"车辆门禁");
            if (self.type==Type_Show_GuestInfoRegistionEditVC) {//查看状态
                [self goToQrVcWithIsNowSuccessType:NO andVisitorIdStr:self.visitorIdStr];
                return;
            }
            [self buildingAccessPopViewShow];
        }
            break;
            
        default:
            break;
    }
}
- (void)carTypePopViewShow{
    [CarTypeListModel getCarTypeListWithBlock:^(NSArray * arr) {
        if (arr.count==0) {
            Y_SVP_SHOW_ERR_MES(@"暂无车辆类型");
            return;
        }
        self.carPopViewDataSource = [NSMutableArray arrayWithArray:[CarTypeModel mj_objectArrayWithKeyValuesArray:arr]];
        [self.carTypePooView showInView:self.view thePopViewSubViewHeight:180 WithArray:arr.mutableCopy WithOldCarInfoModel:nil];// 只用arr不用modelarr
    }];
}
- (void)communityAccessPopViewShow{
    [AccessListModel getCommunityAccessListWithBlock:^(NSArray * arr) {
        if (arr.count==0) {
            Y_SVP_SHOW_ERR_MES(@"暂无社区门禁类型");
            return;
        }
        self.authorOneDataSource = [NSMutableArray arrayWithArray:[AccessModel mj_objectArrayWithKeyValuesArray:arr]];
        [self.authorPopViewOne showInView:self.view thePopViewTableViewHeight:200 WithArray:self.authorOneDataSource];
    }];
   
}
- (void)buildingAccessPopViewShow{
    [AccessListModel getBuildingAccessListWithBlock:^(NSArray * arr) {
        if (arr.count==0) {
//            Y_SVP_SHOW_ERR_MES(@"暂无楼栋门禁类型");
            Y_SVP_SHOW_ERR_MES(@"暂无车辆门禁类型");
            return;
        }
        self.authorTwoDataSource = [NSMutableArray arrayWithArray:[AccessModel mj_objectArrayWithKeyValuesArray:arr]];
        [self.authorPopViewTwo showInView:self.view thePopViewTableViewHeight:200 WithArray:self.authorTwoDataSource];
    }];

}
- (void)carHistoryPopViewShow{// self.houserModel.communityId
    if (self.houserModel.communityId<=0) {
        Y_SVP_SHOW_ERR_MES(@"请先选择社区相关信息!");
        return;
    }
 
    [CarTypeListModel getCarHistoryListWithHouseInfoCommunityId:self.houserModel.communityId  withBlocl:^(NSArray * arr, BOOL success) {
        if (success) {
            if (arr.count==0) {
                Y_SVP_SHOW_INFO_MES(@"当前社区暂无历史车辆信息，您可以手动输入车牌号。");
                return;//没历史车辆记录 不做弹出
            }else{
                self.carHistoryListPopViewDataSource = [NSMutableArray arrayWithArray:arr];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.carHistoryListPopView showInView:self.view thePopViewTableViewHeight:0 WithArray:self.carHistoryListPopViewDataSource];
                });
            }
        }
    }];
}
#pragma mark ======================================= tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   // return 2;//0917隐藏随行//1027隐藏门禁类型 TableView_Section_Num
    
    
    if (kMYAPP_Now_IS_HIDDEN_CAR == 1) {//隐藏车辆
        return 1;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    //0917隐藏随行
    switch (section) {
        case 0:
            return TableView_Section_One_Row_Num;
            break;
        case 1:
            return TableView_Section_Two_Row_Num;
            break;
        default:
           // return TableView_Section_Four_Row_Num;
            return self.titleLabelArrSectionFour.count;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return [self tableView:tableView OneSectionCellForRowAtIndexPath:indexPath];
    }else if(indexPath.section == 1){
        return [self tableView:tableView TwoSectionCellForRowAtIndexPath:indexPath];
//    }else if(indexPath.section == 2){
//        return [self tableView:tableView ThrSectionCellForRowAtIndexPath:indexPath];//0917 随行人员车辆 暂不显示
    } else {
        return [self tableView:tableView FourSectionCellForRowAtIndexPath:indexPath];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView OneSectionCellForRowAtIndexPath:(NSIndexPath *)indexPath {//个人信息
    if (indexPath.row<2) {//前3文本数据cell
        GuestInfoRegistionEditTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GuestInfoRegistionEditTextFieldTableViewCell_Identifier];
        if (!cell) {
            cell = [[GuestInfoRegistionEditTextFieldTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:GuestInfoRegistionEditTextFieldTableViewCell_Identifier];
        }
        cell.titleL.text = self.titleLabelArrSectionOne[indexPath.row];
        [cell.textField mainModuleAttributedPlaceholderNewColorWithStr:self.textFieldPlaceholderArrSectionOne[indexPath.row]];
        cell.textField.delegate = self;
        cell.textField.tag = Tag_TextField_SectionOne+indexPath.row;
        cell.textField.text = self.textFieldArrSectionOne[indexPath.row];
        if ((self.type == Type_Show_GuestInfoRegistionEditVC) || (self.type == Type_Edit_GuestInfoRegistionEditVC)) {
            cell.userInteractionEnabled  = NO;
            cell.textFieldRightBtn.hidden = YES;
        }
        return cell;
    }else{//后几行
        GuestInfoRegistionEditShowRightBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GuestInfoRegistionEditShowRightBtnTableViewCell_Identifier];
        if (!cell) {
            cell = [[GuestInfoRegistionEditShowRightBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:GuestInfoRegistionEditShowRightBtnTableViewCell_Identifier];
        }
        cell.titleL.text = self.titleLabelArrSectionOne[indexPath.row];
        [cell.textField mainModuleAttributedPlaceholderNewColorWithStr:self.textFieldPlaceholderArrSectionOne[indexPath.row]];
        cell.textField.delegate = self;
        cell.textField.tag = Tag_TextField_SectionOne+indexPath.row;
        if (indexPath.row== [tableView numberOfRowsInSection:indexPath.section]-1) {//******* 【来访时间】 row=4 (sectionOne最后一行)
            if((self.type == Type_Show_GuestInfoRegistionEditVC) ){//展示类 不交互
                cell.userInteractionEnabled  = NO;
                cell.textFieldRightBtn.hidden = YES;
            }else if ((self.type == Type_Add_GuestInfoRegistionEditVC) || (self.type == Type_Edit_GuestInfoRegistionEditVC)){//add类 编辑类 交互
                cell.userInteractionEnabled  = YES;
                cell.textFieldRightBtn.hidden = NO;
            }
            cell.lineView.hidden = YES;
            //
        }else{//来访事由 1029 本cell去掉
            cell.lineView.hidden = NO;
            if ((self.type == Type_Show_GuestInfoRegistionEditVC) || (self.type == Type_Edit_GuestInfoRegistionEditVC)) {//展示类 编辑类 不交互
                cell.userInteractionEnabled  = NO;
                cell.textFieldRightBtn.hidden = YES;
            }else{ //add类 交互
                cell.userInteractionEnabled  = YES;
                cell.textFieldRightBtn.hidden = NO;
            }
        }
        cell.textField.text = self.textFieldArrSectionOne[indexPath.row];

         return cell;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView TwoSectionCellForRowAtIndexPath:(NSIndexPath *)indexPath {//车辆信息
    if (indexPath.row==0) {
        GuestInfoRegistionCarTypeHaveTextFieldAndBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GuestInfoRegistionCarTypeHaveTextFieldAndBtnTableViewCell_Identifier];
        if (!cell) {
            cell = [[GuestInfoRegistionCarTypeHaveTextFieldAndBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:GuestInfoRegistionCarTypeHaveTextFieldAndBtnTableViewCell_Identifier];
            [cell.chooseWithCarListShowOrHidenBtn addTarget:self action:@selector(showHistoryCarListAction:) forControlEvents:UIControlEventTouchUpInside];  
        }
        cell.titleL.text = self.titleLabelArrSectionTwo[indexPath.row];
        [cell.textField mainModuleAttributedPlaceholderNewColorWithStr:self.textFieldPlaceholderArrSectionTwo[indexPath.row]];
        cell.textField.delegate = self;
        cell.textField.tag = Tag_TextField_SectionTwo+indexPath.row;
        cell.lineView.hidden = NO;
        cell.textField.text = self.textFieldArrSectionTwo[indexPath.row];
        if ((self.type == Type_Show_GuestInfoRegistionEditVC) || (self.type == Type_Edit_GuestInfoRegistionEditVC)) {
            cell.userInteractionEnabled  = NO;
            cell.chooseWithCarListShowOrHidenBtn.hidden = YES;
        }else{
            cell.userInteractionEnabled  = YES;
            cell.chooseWithCarListShowOrHidenBtn.hidden = NO;
        }
        WEAKSELF
        cell.touchTextFiledTopBtnActionBlock = ^{
            [weakSelf textFTopTuchBtnAction];//跳h5车牌输入
        };
        return cell;
    }else{
        GuestInfoRegistionCarTypeHaveChooseBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GuestInfoRegistionCarTypeHaveChooseBtnTableViewCell_Identifier];
        if (!cell) {
            cell = [[GuestInfoRegistionCarTypeHaveChooseBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:GuestInfoRegistionCarTypeHaveChooseBtnTableViewCell_Identifier];
            [cell.payTypeChooseBtn addTarget:self action:@selector(payTypeChooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.payTypeChooseBtn.selected = self.saveAndShowIntValueWithCarAlternativePayStaus;
        if ((self.type == Type_Show_GuestInfoRegistionEditVC) || (self.type == Type_Edit_GuestInfoRegistionEditVC)) {//展示类型 不可做点击
            cell.userInteractionEnabled  = NO;
            cell.payTypeChooseBtn.userInteractionEnabled = NO;
        }else{
            cell.userInteractionEnabled  = YES;
            cell.payTypeChooseBtn.userInteractionEnabled = YES;
        }
        return cell;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView ThrSectionCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GuestInfoRegistionEditShowRightBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GuestInfoRegistionEditShowRightBtnTableViewCell_Identifier];
    if (!cell) {
        cell = [[GuestInfoRegistionEditShowRightBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:GuestInfoRegistionEditShowRightBtnTableViewCell_Identifier];
    }
    cell.titleL.text = self.titleLabelArrSectionThr[indexPath.row];
    [cell.textField mainModuleAttributedPlaceholderNewColorWithStr:self.textFieldPlaceholderArrSectionThr[indexPath.row]];
    cell.textField.delegate = self;
    cell.textField.tag = Tag_TextField_SectionThr+indexPath.row;
    cell.lineView.hidden = YES;
    cell.textField.text = self.textFieldArrSectionThr[indexPath.row];
    if (self.type == Type_Show_GuestInfoRegistionEditVC) {
        cell.textField.text = @"查看";
    }
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView FourSectionCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GuestInfoRegistionEditShowRightBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GuestInfoRegistionEditShowRightBtnTableViewCell_Identifier];
    if (!cell) {
        cell = [[GuestInfoRegistionEditShowRightBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:GuestInfoRegistionEditShowRightBtnTableViewCell_Identifier];
    }
    cell.titleL.text = self.titleLabelArrSectionFour[indexPath.row];
    [cell.textField mainModuleAttributedPlaceholderNewColorWithStr:self.textFieldPlaceholderArrSectionFour[indexPath.row]];
    cell.textField.delegate = self;
    cell.textField.tag = Tag_TextField_SectionFour+indexPath.row;
    cell.textField.text = self.textFieldArrSectionFour[indexPath.row];
    if (self.type == Type_Show_GuestInfoRegistionEditVC) {//不可交互状态 0630改为可以交互 可查看门禁二维码
        cell.userInteractionEnabled  = YES;
        cell.textFieldRightBtn.hidden = YES;
    }
    if (indexPath.row==1) {
        cell.lineView.hidden = YES;
    }else{
//        cell.lineView.hidden = NO;
        cell.lineView.hidden = YES;//
    }
    if (self.type == Type_Show_GuestInfoRegistionEditVC) {//不可交互状态 0630改为可以交互 可查看门禁二维码
        cell.userInteractionEnabled  = YES;
        cell.textFieldRightBtn.hidden = YES;
    }else{
        cell.userInteractionEnabled  = NO;//展示默认二维码数据 不做点击选择
        cell.textFieldRightBtn.hidden = YES;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return TableViewCell_Heitht_Nomal;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return TableView_Section_HeaderView_Height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SectionHeaderView *headerView= [[SectionHeaderView alloc]initWithFrame:CGRectZero];
//    NSArray *headerTextArr = @[@"人员信息",@"车辆信息",@"随行人员",@"授权信息"];
    NSArray *headerTextArr = @[@"人员信息",@"车辆信息",@"授权信息"];//@"随行人员"@"随行车辆"
    headerView.titleLabel.text = headerTextArr[section];
    return headerView;
}

#pragma mark ==
- (LabelYu *)headerView{
    if (!_headerView) {
        _headerView = [[LabelYu alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 35)];
        _headerView.backgroundColor = [COlor_Red255 colorWithAlphaComponent:0.2];
        _headerView.textColor = COlor_Red255;
        _headerView.textAlignment = NSTextAlignmentCenter;
        _headerView.font = [UIFont systemFontOfSize:11.0];
        _headerView.textInsets = UIEdgeInsetsMake(0, 15, 0, 15);
        _headerView.text = @"温馨提示：当前访客码已失效，可点击下方按钮后选择新日期重新生成访客码";
        _headerView.numberOfLines = 0;
    }
    return _headerView;
}

- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 90)];
        [_footerView.footerBtn addTarget:self action:@selector(guestEditVcfooterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView.footerBtn setTitle:@"提交信息" forState:UIControlStateNormal];//add 时 不做whenChangeTypeWithUpFooterView，show initData后会更新footerv
        _footerView.footerBtn.tag = GiestDeletVcFooterBtn_Tag_Add;
    }
    return _footerView;
}
- (void)whenChangeTypeWithUpFooterView{
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (weakSelf.type) {
            case Type_Add_GuestInfoRegistionEditVC:
                [weakSelf.footerView.footerBtn setTitle:@"提交信息" forState:UIControlStateNormal];
                weakSelf.footerView.footerBtn.tag = GiestDeletVcFooterBtn_Tag_Add;
                break;
            case Type_Show_GuestInfoRegistionEditVC:
                //是否失效
                if (self.saveAndShowIntValueWithExpireStatus == 0) {
                    [weakSelf.footerView.footerBtn setTitle:@"查看通行码" forState:UIControlStateNormal];
                    weakSelf.footerView.footerBtn.tag = GiestDeletVcFooterBtn_Tag_OnTime;
                }else{
                    [weakSelf.footerView.footerBtn setTitle:@"重新生成访客码" forState:UIControlStateNormal];
                    weakSelf.footerView.footerBtn.tag = GiestDeletVcFooterBtn_Tag_ExpieTime;
                }
                break;
            case Type_Edit_GuestInfoRegistionEditVC:
                [weakSelf.footerView.footerBtn setTitle:@"提交信息" forState:UIControlStateNormal];
                weakSelf.footerView.footerBtn.tag = GiestDeletVcFooterBtn_Tag_Add;
                break;
            default:
                break;
        }
    });
   
}
- (void)whenChangeTypeWithUpHeaderView{
    WEAKSELF
    /**
     dispatch_async(dispatch_get_main_queue(), ^{
        switch (weakSelf.type) {
            case Type_Show_GuestInfoRegistionEditVC:
                if (self.saveAndShowIntValueWithExpireStatus) {//已过期才会有文本label
                    weakSelf.tableView.tableHeaderView = self.headerView;
                }else{
                    weakSelf.tableView.tableHeaderView = [UIView new];
                }
                break;
                
            default:
                weakSelf.tableView.tableHeaderView = [UIView new];
                break;
        }
    });
 */
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (weakSelf.type) {
            case Type_Show_GuestInfoRegistionEditVC:
            {
                [weakSelf.view addSubview:weakSelf.headerView];
                [weakSelf.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.right.equalTo(weakSelf.headerView.superview);
                    make.height.offset(35);
                }];
                if (self.saveAndShowIntValueWithExpireStatus) {//已过期状态才会有top红色文本labelTip
                    weakSelf.tableView.frame = CGRectMake(16, 35, Screen_W-32, Screen_H-KNavBarHeight-35);
                    weakSelf.headerView.hidden = NO;
                }else{
                    //不显示topL
                    weakSelf.tableView.frame = CGRectMake(16, 0, Screen_W-32, Screen_H-KNavBarHeight);
                    weakSelf.headerView.hidden = YES;
                }
            }
              break;
                
            default:
            { //不显示topL
                weakSelf.tableView.frame = CGRectMake(16, 0, Screen_W-32, Screen_H-KNavBarHeight);
                if (isNotNil(weakSelf.headerView)) {
                    weakSelf.headerView.hidden = YES;
                }
            }
              break;
        }
    });
}
#pragma mark== pop 非getter
- (PopViewChooseUserHouse *)housePopView{
    _housePopView = [[PopViewChooseUserHouse alloc]initWithFrame:CGRectZero];
    _housePopView.tag = Popview_Tag_UserHouse;
    _housePopView.delegate = self;
    return _housePopView;
}
- (PopViewChooseVisitReason *)resonPopView{
    _resonPopView = [[PopViewChooseVisitReason alloc]initWithFrame:CGRectZero];
    _resonPopView.tag = Popview_Tag_VisitReason;
    _resonPopView.delegate = self;
    return _resonPopView;
}
- (PopViewChooseVisitTime *)timePpoView{
    _timePpoView = [[PopViewChooseVisitTime alloc]initWithFrame:CGRectZero];
    _timePpoView.delegate = self;
    return _timePpoView;
}
- (PopViewChooseAuthorisation *)authorPopViewOne{
    _authorPopViewOne = [[PopViewChooseAuthorisation alloc]initWithFrame:CGRectZero];
    _authorPopViewOne.delegate = self;
    _authorPopViewOne.tag = Popview_Tag_Authorisation_one;
    return _authorPopViewOne;
}
- (PopViewChooseAuthorisation *)authorPopViewTwo{
    _authorPopViewTwo = [[PopViewChooseAuthorisation alloc]initWithFrame:CGRectZero];
    _authorPopViewTwo.delegate = self;
    _authorPopViewTwo.tag = Popview_Tag_Authorisation_two;
    return _authorPopViewTwo;
}
- (PopViewChooseCarType *)carTypePooView{
    _carTypePooView = [[PopViewChooseCarType alloc]initWithFrame:CGRectZero];
    _carTypePooView.delegateOfCarType = self;
    _carTypePooView.tag = Popview_Tag_CarType;
    return _carTypePooView;
}
- (GuestEditVcSubHistoryCarListPopView *)carHistoryListPopView{
    _carHistoryListPopView = [[GuestEditVcSubHistoryCarListPopView alloc]initWithFrame:CGRectZero];
    _carHistoryListPopView.delegate = self;
    _carHistoryListPopView.tag = Popview_Tag_CarHistoryList;
    return _carHistoryListPopView;
}
#pragma mark ==
//初始显示部分
- (NSMutableArray *)titleLabelArrSectionOne{
    if (!_titleLabelArrSectionOne) {
        _titleLabelArrSectionOne = [NSMutableArray arrayWithObjects:@"来访人姓名",@"来访人电话",@"来访社区详细地址",@"来访时间", nil];//@"来访事由" 1029被去掉
    }
    return _titleLabelArrSectionOne;
}
- (NSMutableArray *)textFieldPlaceholderArrSectionOne{
    if (!_textFieldPlaceholderArrSectionOne) {
        _textFieldPlaceholderArrSectionOne = [NSMutableArray arrayWithObjects:@"请输入姓名",@"请输入电话",@"请选择",@"请选择", nil];
    }
    return _textFieldPlaceholderArrSectionOne;
}
- (NSMutableArray *)titleLabelArrSectionTwo{
    if (!_titleLabelArrSectionTwo) {
        _titleLabelArrSectionTwo = [NSMutableArray arrayWithObjects:@"车牌号",@"车辆类型",nil];
    }
    return _titleLabelArrSectionTwo;
}
- (NSMutableArray *)textFieldPlaceholderArrSectionTwo{
    if (!_textFieldPlaceholderArrSectionTwo) {
        _textFieldPlaceholderArrSectionTwo = [NSMutableArray arrayWithObjects:@"请输入车牌号",@"请选择", nil];
    }
    return _textFieldPlaceholderArrSectionTwo;
}
- (NSMutableArray *)titleLabelArrSectionThr{
    if (!_titleLabelArrSectionThr) {
        _titleLabelArrSectionThr = [NSMutableArray arrayWithObjects:@"随行人员/车辆",nil];
    }
    return _titleLabelArrSectionThr;
}
- (NSMutableArray *)textFieldPlaceholderArrSectionThr{
    if (!_textFieldPlaceholderArrSectionThr) {
        _textFieldPlaceholderArrSectionThr = [NSMutableArray arrayWithObjects:@"添加", nil];
    }
    return _textFieldPlaceholderArrSectionThr;
}
- (NSMutableArray *)titleLabelArrSectionFour{
    if (!_titleLabelArrSectionFour) {
//        _titleLabelArrSectionFour = [NSMutableArray arrayWithObjects:@"是否授权门禁",@"是否授权楼宇门禁",nil];//Authorisation
        _titleLabelArrSectionFour = [NSMutableArray arrayWithObjects:@"是否授权门禁",nil];// 门禁默认不可选择 展示默认的二维码       @"是否授权车辆门禁" 1019去掉

    }
    return _titleLabelArrSectionFour;
}
- (NSMutableArray *)textFieldPlaceholderArrSectionFour{
    if (!_textFieldPlaceholderArrSectionFour) {
        _textFieldPlaceholderArrSectionFour = [NSMutableArray arrayWithObjects:@"请选择",@"请选择", nil];
    }
    return _textFieldPlaceholderArrSectionFour;
}

//
- (NSMutableArray *)userHousePopViewDataSource{
    if (!_userHousePopViewDataSource) {
        _userHousePopViewDataSource = [NSMutableArray array];
    }
    return _userHousePopViewDataSource;
}
//以下都用对应model做元素 不用str
- (NSMutableArray *)resonPopViewDataSource{
    if (!_resonPopViewDataSource) {
        _resonPopViewDataSource = [NSMutableArray arrayWithObjects:@"一般来访",@"应聘来访",@"走亲访友",@"其他", nil];// 改model
    }
    return _resonPopViewDataSource;
}
- (NSMutableArray *)authorOneDataSource{
    if (!_authorOneDataSource) {
        _authorOneDataSource = [NSMutableArray arrayWithObjects:@"二维码通行证",@"可视对讲",@"暂不授权", nil];
    }
    return _authorOneDataSource;
}
- (NSMutableArray *)authorTwoDataSource{
    if (!_authorTwoDataSource) {
        _authorTwoDataSource = [NSMutableArray arrayWithObjects:@"二维码通行证",@"人脸识别",@"暂不授权", nil];
    }
    return _authorTwoDataSource;
}
- (NSMutableArray *)carPopViewDataSource{
    if (!_carPopViewDataSource) {
        _carPopViewDataSource = [NSMutableArray array];
    }
    return _carPopViewDataSource;
}
- (NSMutableArray *)carHistoryListPopViewDataSource{
    if (!_carHistoryListPopViewDataSource) {
        _carHistoryListPopViewDataSource = [NSMutableArray array];
    }
    return _carHistoryListPopViewDataSource;
}
#pragma mark ==
//数据部分
- (NSMutableArray *)textFieldArrSectionOne{
    if (!_textFieldArrSectionOne) {
        _textFieldArrSectionOne = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
    }
    return _textFieldArrSectionOne;
}
- (NSMutableArray *)textFieldArrSectionTwo{
    if (!_textFieldArrSectionTwo) {
        _textFieldArrSectionTwo = [NSMutableArray arrayWithObjects:@"",@"",nil];
    }
    return _textFieldArrSectionTwo;
}
- (NSMutableArray *)textFieldArrSectionThr{
    if (!_textFieldArrSectionThr) {
        _textFieldArrSectionThr = [NSMutableArray arrayWithObjects:@"",nil];
    }
    return _textFieldArrSectionThr;
}
- (NSMutableArray *)textFieldArrSectionFour{
    if (!_textFieldArrSectionFour) {
        _textFieldArrSectionFour = [NSMutableArray arrayWithObjects:@"",@"",nil];//Authorisation
    }
    return _textFieldArrSectionFour;
}
- (NSMutableArray *)accompayCarArr{
    if (!_accompayCarArr) {
        _accompayCarArr = [NSMutableArray array];
    }
    return _accompayCarArr;
}
- (NSMutableArray *)accompayPersonArr{
    if (!_accompayPersonArr) {
        _accompayPersonArr = [NSMutableArray array];
    }
    return _accompayPersonArr;
}
- (NSString *)visitorIdStr{
    if (!_visitorIdStr) {
        _visitorIdStr = @"";
    }
    return _visitorIdStr;
}

#pragma mark == 车牌号码
- (void)textFTopTuchBtnAction{
    DLog(@"view  点击tf 跳转去h5 输车牌");
    self.isPushGoToCarPvcDontRemoveSelfBool = YES; //去输入车牌号界面类型 不removeselfvc 做yes

    CarPaltWebViewVC *vc = [[CarPaltWebViewVC alloc]init];
    WEAKSELF
    vc.carPlatBlock = ^(NSString * _Nonnull carPlatStr) {
        STRONGSELF
        strongSelf.isPushGoToCarPvcDontRemoveSelfBool=NO;   //回来后初始no_Bool
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.navigationController.navigationBarHidden = NO;
            strongSelf.textFieldArrSectionTwo[carId_cell_SectionTwo_rowNum] = (carPlatStr.length>0) ? carPlatStr : @"暂无随行车辆";
            [strongSelf.tableView reloadData];
        });
    };
    [self pushVc:vc];
}
@end
