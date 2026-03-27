//
//  MyHouseAddSubPersonVCLate.m
//  Community
//
//  Created by 余莹 on 2022/4/25.
//

#import "MyHouseAddSubPersonVCLate.h"
#import "MyHouseAddSubPersonWithChoosePersonTypeHeaderView.h"
#import "MyHouseAddSubPersonVCLateShowTipTextTableViewCell.h"
#import "MyHouseAddSubPersonVCLateShowSwithTableViewCell.h"
#import "MyHouseAddSubPersonVCLateShowSwithWithFaceInfoTableViewCell.h"
#import "MyHouseAddSubPersonVCLateWithTextFiledTableViewCell.h"
#import "MyHouseAddSubPersonTableViewCell.h"
#define MyHouseAddSubPersonTableViewCellTextFeild_Identifier @"MyHouseAddSubPersonTableViewCellTextFeild"
#import "MyHouseAddOrEditPersonUseInfoModel.h"
#import "MyHouseData.h"
#import "MyHouseAddSubPerSonSuccessVc.h"
#import "BaseImgUpDataTool.h"

#define Row_Num_OnlyTipShowLongTextCell   (2)//最长的提示行的位置

typedef enum : NSUInteger {
    selfNowChoose_relationType_No ,   //没选
    selfNowChoose_relationType_JiaShu,//家属
    selfNowChoose_relationType_ZuKe , //租客
}  selfNowChoose_relationType;

static CGFloat Row_Height_NameCell = 50.0;
static CGFloat Row_Height_FaceCell = 120.0;
static CGFloat Row_Height_SwichCell = 50.0;
static CGFloat Row_Height_PhoneCell = 50.0;
static CGFloat Row_Height_CardIDCell = 50.0;
static CGFloat Row_Height_SmallTipCell = 50.0;
static CGFloat Row_Height_LongTipCell = 80.0;

static NSString *Row_ShowConStr_NameCell = @"NameCell";
static NSString *Row_ShowConStr_FaceCell = @"FaceCell";
static NSString *Row_ShowConStr_Swichell = @"Swichell";
static NSString *Row_ShowConStr_PhoneCell = @"PhoneCell";
static NSString *Row_ShowConStr_CardIDCell = @"CardIDCell";
static NSString *Row_ShowConStr_SmallTipCell = @"SmallTipCell";
static NSString *Row_ShowConStr_LongTipCell =  @"LongTipCell";


@interface MyHouseAddSubPersonVCLate () <MyHouseAddSubPersonTableViewCellTextFeildDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic,strong) NSMutableArray *cellShowThingArr;//占位数数用的
@property (nonatomic,strong) NSMutableArray *cellShowThisSectionRowNumArr;//占位数数用的
@property (nonatomic,strong) NSMutableArray *cellShowHeightArr;//高度
@property (nonatomic,strong) NSMutableArray *relationTypeArr;
@property (nonatomic,strong) MyHouseAddSubPersonWithChoosePersonTypeHeaderView *headerView;//类型选择
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,assign) BOOL isOnChooseTypeTime;//正在选择类型的bool
@property (nonatomic,assign) selfNowChoose_relationType saveNowChoose_relationType;
@property (nonatomic,assign) BOOL saveNowSwithChooseType_isHavePhoneNotCareMode;//有手机非关怀模式 yes 无手机关怀模式no
@property (nonatomic,strong) MyHouseAddOrEditPersonUseInfoModel *myHouseAddOrEditPersonUseInfoModel;
@end

@implementation MyHouseAddSubPersonVCLate

 
- (MyHouseAddOrEditPersonUseInfoModel *)myHouseAddOrEditPersonUseInfoModel{
    if (!_myHouseAddOrEditPersonUseInfoModel) {
        _myHouseAddOrEditPersonUseInfoModel = [[MyHouseAddOrEditPersonUseInfoModel alloc]init];
    }
    return _myHouseAddOrEditPersonUseInfoModel;
}

- (NSMutableArray *)cellShowThingArr{
    if (!_cellShowThingArr) {
        _cellShowThingArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _cellShowThingArr;
}
- (NSMutableArray *)cellShowThisSectionRowNumArr{
    if (!_cellShowThisSectionRowNumArr) {
        _cellShowThisSectionRowNumArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _cellShowThisSectionRowNumArr;
}
- (NSMutableArray *)cellShowHeightArr{
    if (!_cellShowHeightArr) {
        _cellShowHeightArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _cellShowHeightArr;
}
- (MyHouseAddSubPersonWithChoosePersonTypeHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[MyHouseAddSubPersonWithChoosePersonTypeHeaderView alloc]initWithFrame:CGRectZero];
        [_headerView.touchUseTopBtn addTarget:self action:@selector(changeTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.oneBtn addTarget:self action:@selector(relationOneBtn:) forControlEvents:UIControlEventTouchUpInside];//家属
        [_headerView.twoBtn addTarget:self action:@selector(relationTwoBtn:) forControlEvents:UIControlEventTouchUpInside];//租客
    }
    return _headerView;
}
#pragma mark ==
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 120)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"提交信息"];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView setBtnFram:CGRectMake(0, 0, Screen_W-32, 50)];
        [_footerView.footerBtn newAnBtnWithLayerCorNerNum:8 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];

    }
    return _footerView;
}

#pragma mark ==
- (void)changeTypeBtn:(UIButton *)sender{
    DLog(@"");
    self.isOnChooseTypeTime = YES;
    [self.headerView showChooseViews];
    [self.tableView reloadData];
}
//家属
- (void)relationOneBtn:(UIButton *)sender{
    DLog(@"");
    [self.headerView hiddenChooseViews];
    self.headerView.showPersonTypeL.text = @"选择身份  家属";
    self.isOnChooseTypeTime = NO;
    self.saveNowChoose_relationType = selfNowChoose_relationType_JiaShu;
    [self initListInfo];//更新cell
    [self.tableView reloadData];
}
//租客
- (void)relationTwoBtn:(UIButton *)sender{
    DLog(@"");
    [self.headerView hiddenChooseViews];
    self.headerView.showPersonTypeL.text = @"选择身份  租客";
    self.isOnChooseTypeTime = NO;
    self.saveNowChoose_relationType = selfNowChoose_relationType_ZuKe;
    [self initListInfo];//更新cell
    [self.tableView reloadData];
}

#pragma mark ==
#pragma mark == 重写 无数据占位 协议置空不遵循
- (void)emptyInfoInit{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.saveNowChoose_relationType = selfNowChoose_relationType_No;
    self.myHouseAddOrEditPersonUseInfoModel.communityId = self.nowCommunityId;
    self.myHouseAddOrEditPersonUseInfoModel.houseId = self.nowHouseId;
    [self initView];
    [self initListInfo];
    [self initData];
    [self.tableView reloadData];
}

- (void)initView{
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    self.tableView.separatorColor = [UIColor clearColor];
}

- (void)initData{
    if (self.myHouseAddOrEditSubPersonVC_Type == MyHouseAddOrEditSubPersonVC_Type_Add) {//租客家属新增页面
        self.saveNowSwithChooseType_isHavePhoneNotCareMode = YES;//初始为需要手机号的非关怀UI
        if ((self.isYeZhuRight)) {
            
        }else{//家属权限 做添加 只能加租客不能切换 （无listmodel数据）
            self.saveNowChoose_relationType = selfNowChoose_relationType_ZuKe;
            self.headerView.allowImgV.hidden = YES;
            self.headerView.touchUseTopBtn.hidden = YES;
            self.headerView.showPersonTypeL.text = @"选择身份  租客";
            [self.headerView hiddenChooseViews];
        }
    }else{ //家属信息编辑页
        self.headerView.allowImgV.hidden = YES;
        self.headerView.touchUseTopBtn.hidden = YES;
        self.headerView.showPersonTypeL.text = @"选择身份  家属";
        [self.headerView hiddenChooseViews];
        [self initPersonDetailInfo];
    }
    [self.tableView reloadData];
}
//编辑状态下 加载成员信息数据 更新UI
- (void)initPersonDetailInfo{
    self.myHouseAddOrEditPersonUseInfoModel.name = [TextShowWithModelStr textShowWithModelStr:self.listEditPersonWithModel.name];
    self.myHouseAddOrEditPersonUseInfoModel.faceUrl = [TextShowWithModelStr textShowWithModelStr:self.listEditPersonWithModel.faceUrl];
    self.myHouseAddOrEditPersonUseInfoModel.mobile = [TextShowWithModelStr textShowWithModelStr:self.listEditPersonWithModel.mobile];
    self.myHouseAddOrEditPersonUseInfoModel.idCard = [TextShowWithModelStr textShowWithModelStr:self.listEditPersonWithModel.idCard];
    self.saveNowSwithChooseType_isHavePhoneNotCareMode = ![@(self.listEditPersonWithModel.carePattern) boolValue];//是否开启手机号的bool键值 | 是否关怀模式 （负相关）
    self.myHouseAddOrEditPersonUseInfoModel.carePattern = self.listEditPersonWithModel.carePattern;//是否关怀x2 正相关
}
- (void)initListInfo{
    if (self.myHouseAddOrEditSubPersonVC_Type == MyHouseAddOrEditSubPersonVC_Type_Add) {//租客家属新增页面
        self.title = @"添加成员";
        
        if (self.isYeZhuRight) {//两类可选填 家属租客
            if (self.saveNowChoose_relationType == selfNowChoose_relationType_No) { //未选
                self.cellShowThingArr = [NSMutableArray arrayWithCapacity:0];
                self.cellShowHeightArr = [NSMutableArray arrayWithCapacity:0];
                self.cellShowThisSectionRowNumArr = [NSMutableArray arrayWithCapacity:0];
                
            }else if (self.saveNowChoose_relationType == selfNowChoose_relationType_ZuKe) {
                 // 租客
                // self.cellShowThingArr = [NSMutableArray arrayWithObjects:@"名+手机基础信息", nil];//新增租客模式
                self.cellShowThingArr = [NSMutableArray arrayWithObjects:@[Row_ShowConStr_NameCell ,Row_ShowConStr_PhoneCell], nil];
                 self.cellShowHeightArr = [NSMutableArray arrayWithObjects:@[@(Row_Height_NameCell),@(Row_Height_PhoneCell)], nil];
                self.cellShowThisSectionRowNumArr = [NSMutableArray arrayWithObjects:@(2), nil];
            }else{
                //  家属
                
                if(self.saveNowSwithChooseType_isHavePhoneNotCareMode){//有手机非关怀
                    //self.cellShowThingArr = [NSMutableArray arrayWithObjects:@"是否开启关怀模式",@"非关怀类型_名+手机的基础信息",@"提示文本", nil];//新增家属模式
                    self.cellShowThingArr = [NSMutableArray arrayWithObjects:
                                              @[Row_ShowConStr_Swichell, Row_ShowConStr_SmallTipCell],
                                              @[Row_ShowConStr_NameCell, Row_ShowConStr_PhoneCell],
                                              @[Row_ShowConStr_LongTipCell],nil];
                    self.cellShowHeightArr = [NSMutableArray arrayWithObjects:
                                              @[@(Row_Height_SwichCell),@(Row_Height_SmallTipCell)],
                                              @[@(Row_Height_NameCell),@(Row_Height_PhoneCell)],
                                              @[@(Row_Height_LongTipCell)],nil];
                    self.cellShowThisSectionRowNumArr = [NSMutableArray arrayWithObjects:
                                                         @(2),
                                                         @(2),
                                                         @(1),
                                                         nil];
                }else{//无手机 关怀模式
                    //self.cellShowThingArr = [NSMutableArray arrayWithObjects:@"是否开启关怀模式",@"关怀模式_名+人脸照片的基础信息",@"提示文本", nil];//新增家属模式
                    self.cellShowThingArr = [NSMutableArray arrayWithObjects:
                                              @[Row_ShowConStr_Swichell,Row_ShowConStr_SmallTipCell],
                                              @[Row_ShowConStr_NameCell,Row_ShowConStr_CardIDCell,Row_ShowConStr_FaceCell],
                                              @[Row_ShowConStr_LongTipCell ],nil];
                    self.cellShowHeightArr = [NSMutableArray arrayWithObjects:
                                              @[@(Row_Height_SwichCell),@(Row_Height_SmallTipCell)],
                                              @[@(Row_Height_NameCell),@(Row_Height_CardIDCell),@(Row_Height_FaceCell)],
                                              @[@(Row_Height_LongTipCell)],nil];
                    self.cellShowThisSectionRowNumArr = [NSMutableArray arrayWithObjects:
                                                         @(2),
                                                         @(3),
                                                         @(1),
                                                         nil];
                }
                
                
            }

        }else{//当前为非业主状态 （即是 家属权限做添加 ）只能添加租客
            //一类租客可填
            //self.cellShowThingArr = [NSMutableArray arrayWithObjects:@"名+手机基础信息", nil];
            self.cellShowThingArr = [NSMutableArray arrayWithObjects:@[Row_ShowConStr_NameCell ,Row_ShowConStr_PhoneCell], nil];
            self.cellShowHeightArr = [NSMutableArray arrayWithObjects:@[@(Row_Height_NameCell),@(Row_Height_PhoneCell)], nil];
            self.cellShowThisSectionRowNumArr = [NSMutableArray arrayWithObjects:@(2), nil];
        }
        
        [self.tableView reloadData];

    }else{//家属被编辑状态
        self.title = @"编辑成员";
        //self.cellShowThingArr = [NSMutableArray arrayWithObjects:@"名+手机基础信息",@"是否开启关怀模式",@"提示文本", nil];
    
        
        if (self.saveNowSwithChooseType_isHavePhoneNotCareMode) {//有手机
            self.cellShowThingArr = [NSMutableArray arrayWithObjects:
                                      @[Row_ShowConStr_NameCell,Row_ShowConStr_CardIDCell,Row_ShowConStr_FaceCell],
                                      @[Row_ShowConStr_Swichell,Row_ShowConStr_PhoneCell],
                                      @[Row_ShowConStr_LongTipCell ],nil];
            self.cellShowThisSectionRowNumArr = [NSMutableArray arrayWithObjects:
                                                 @(3),@(2),@(1), nil];
            
            self.cellShowHeightArr = [NSMutableArray arrayWithObjects:
                                      @[@(Row_Height_NameCell),@(Row_Height_CardIDCell),@(Row_Height_FaceCell)],
                                      @[@(Row_Height_SwichCell),@(Row_Height_PhoneCell)],
                                      @[@(Row_Height_LongTipCell)],nil];
        }else{//关怀模式 无手机行
            self.cellShowThingArr = [NSMutableArray arrayWithObjects:
                                      @[Row_ShowConStr_NameCell,Row_ShowConStr_CardIDCell,Row_ShowConStr_FaceCell],
                                      @[Row_ShowConStr_Swichell],
                                      @[Row_ShowConStr_LongTipCell ],nil];
            self.cellShowThisSectionRowNumArr = [NSMutableArray arrayWithObjects:
                                                 @(3),@(1),@(1), nil];
            self.cellShowHeightArr = [NSMutableArray arrayWithObjects:
                                      @[@(Row_Height_NameCell),@(Row_Height_CardIDCell),@(Row_Height_FaceCell)],
                                      @[@(Row_Height_SwichCell)],
                                      @[@(Row_Height_LongTipCell)],nil];
        }
   
        [self.tableView reloadData];
    }

}



#pragma mark ===

- (void)cellTextFieldWithTag:(NSInteger)tag andTextFieldStr:(NSString *)textStr{
    NSInteger index = tag-300;
     
    switch (index) {
        case 0:
        {//name
            self.myHouseAddOrEditPersonUseInfoModel.name = textStr;
        }
            break;
        case 1:
        {//phone
            self.myHouseAddOrEditPersonUseInfoModel.mobile = textStr;
        }
            break;
        case 2:
        {//cardId
            self.myHouseAddOrEditPersonUseInfoModel.idCard = textStr;
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return self.cellShowThingArr.count;//类型用headerv不用cell
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section ==  Row_Num_OnlyTipShowLongTextCell) {//租客 一个数据section单元
        return 1;
    }else{
         return  [[self.cellShowThisSectionRowNumArr objectAtIndex:section] integerValue];
        /**
         if (self.myHouseAddOrEditSubPersonVC_Type == MyHouseAddOrEditSubPersonVC_Type_Edit) {//编辑页
             if (section == 0 ) {
                 return  (self.saveNowSwithChooseType_isHavePhoneNotCareMode == YES ? 2 : 3);//关怀多一个身份证行
             }else if (section == 1){
                 return  (self.saveNowSwithChooseType_isHavePhoneNotCareMode == YES ? 1 : 2);//关怀多一个手机号行
             }else{
                 return 1;
             }
              
         }else{//(新增页 )
             if (self.saveNowChoose_relationType == selfNowChoose_relationType_ZuKe) {//租客
                 return 2;
             }else{//家属
                 if (section == 0) {
                     return 2;
                 }else if (section == 1){
                     return  (self.saveNowSwithChooseType_isHavePhoneNotCareMode == YES ?  : 3);//关怀 手机行一个身份证行
                 }else{
                     return 1;
                 }
             }
             
         }
         */
       
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ self.cellShowHeightArr[indexPath.section][indexPath.row] floatValue];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *thisCellConstr = self.cellShowThingArr[indexPath.section][indexPath.row];


    if ([thisCellConstr containsString: Row_ShowConStr_NameCell] || [thisCellConstr containsString: Row_ShowConStr_PhoneCell] || [thisCellConstr containsString: Row_ShowConStr_CardIDCell]) {
        MyHouseAddSubPersonVCLateWithTextFiledTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:MyHouseAddSubPersonVCLateWithTextFiledTableViewCell_I];
                if (!cell) {
                    cell = [[MyHouseAddSubPersonVCLateWithTextFiledTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyHouseAddSubPersonVCLateWithTextFiledTableViewCell_I];
                    cell.delegate = self;
                }
        if ([thisCellConstr containsString: Row_ShowConStr_NameCell]) {
            cell.textField.tag = 300;
            cell.titleL.text =  @"姓  名";
            cell.textField.text =  [TextShowWithModelStr textShowWithModelStr:self.myHouseAddOrEditPersonUseInfoModel.name];
            cell.textField.keyboardType = UIKeyboardTypeDefault;
            [cell setTextFiePstr:@"请输入"];//非空的提示输入
            if (self.myHouseAddOrEditSubPersonVC_Type == MyHouseAddOrEditSubPersonVC_Type_Edit) {//家属编辑状态下 名字行不可以更改
                cell.textField.userInteractionEnabled = NO ;
            }else{
                cell.textField.userInteractionEnabled = YES;

            }
        }else  if ([thisCellConstr containsString: Row_ShowConStr_PhoneCell]) {
            cell.textField.tag = 301;
            cell.textField.keyboardType = UIKeyboardTypePhonePad;
            cell.titleL.text =  @"手机号";
            [cell setTextFiePstr:@"请输入"];//非空空的提示输入
            cell.textField.text =  [TextShowWithModelStr textShowWithModelStr:self.myHouseAddOrEditPersonUseInfoModel.mobile];
            cell.textField.userInteractionEnabled = YES;
        }else  {//Row_ShowConStr_CardIDCell
            cell.textField.tag = 302;
            cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.titleL.text = @"身份证号";
            [cell setTextFiePstr:@"请输入"];//空的提示输入
            cell.textField.text =  [TextShowWithModelStr textShowWithModelStr:self.myHouseAddOrEditPersonUseInfoModel.idCard];
            if (self.myHouseAddOrEditSubPersonVC_Type == MyHouseAddOrEditSubPersonVC_Type_Edit) {//家属编辑状态下 身份证行不可以更改
                cell.textField.userInteractionEnabled = NO ;
            }else{
                cell.textField.userInteractionEnabled = YES;
                
            }
        }
        return cell;
    
    }else if ([thisCellConstr containsString: Row_ShowConStr_FaceCell]){
        MyHouseAddSubPersonVCLateShowSwithWithFaceInfoTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:MyHouseAddSubPersonVCLateShowSwithWithFaceInfoTableViewCell_I];
        if (!cell) {
            cell = [[MyHouseAddSubPersonVCLateShowSwithWithFaceInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyHouseAddSubPersonVCLateShowSwithWithFaceInfoTableViewCell_I];
        }
        if (self.myHouseAddOrEditSubPersonVC_Type == MyHouseAddOrEditSubPersonVC_Type_Add) {
            cell.onceAgainBtn.hidden = YES;
            cell.imgTopBtn.hidden = NO;
        }else{
            cell.onceAgainBtn.hidden = NO;//编辑修改需要重传按钮
            cell.imgTopBtn.hidden = YES;//此时有图 隐藏图top直接上传的按钮
//            cell.faceAndIdcardInfoAuditStatu = YES;//关怀模式的人脸和身份证信息 审核状态
        }
        WEAKSELF
        cell.touchChooseOnceAgainBtnBlock = ^{
            NSLog(@"重选图片");
            [weakSelf iconImgTap];
        };
        cell.touchChooseImgBlcok = ^{
            NSLog(@"添加图片");
            [weakSelf iconImgTap];
        };
        if ( self.myHouseAddOrEditPersonUseInfoModel.faceUrl.length >0 ) {//图片
//            cell.faceImgV.image = self.myHouseAddOrEditPersonUseInfoModel.faceImg;
            [cell.faceImgV sd_setImageWithURL: [UrlWithString getURLWithStr:self.myHouseAddOrEditPersonUseInfoModel.faceUrl] placeholderImage: [UIImage imageNamed:@"sczp_icon"]];
        }
        return cell;
        
    }else if ([thisCellConstr containsString: Row_ShowConStr_Swichell]){//开关cell 两个cell在开启状态-意思是相反的
        
        if (self.myHouseAddOrEditSubPersonVC_Type == MyHouseAddOrEditSubPersonVC_Type_Edit) {//编辑状态 title不一样 "是否开启手机号"-------编辑状态下的关怀模式切换在本swithch
            MyHouseAddSubPersonVCLateShowSwithWithOpenPhoneOrNotOpenPhoneTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:MyHouseAddSubPersonVCLateShowSwithWithOpenPhoneOrNotOpenPhoneTableViewCell_I];
            if (!cell) {
                cell = [[MyHouseAddSubPersonVCLateShowSwithWithOpenPhoneOrNotOpenPhoneTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyHouseAddSubPersonVCLateShowSwithWithOpenPhoneOrNotOpenPhoneTableViewCell_I];
            }
        
             WEAKSELF
             cell.cellSubSwitchSelectedBlock = ^(BOOL isOn) { //"是否开启手机号" 无界面变化 但提交时需要判断本键 (开手机号y 非关怀状态n)
                 weakSelf.saveNowSwithChooseType_isHavePhoneNotCareMode = isOn;
                 if (isOn) {//从关怀 -- 切到 非关怀填手机 === 展示数据用空数据。
                     weakSelf.myHouseAddOrEditPersonUseInfoModel.mobile = @"";
                 }else{//从非关怀 -- 切到关怀== 展示数据用list的model内手机编号
                     weakSelf.myHouseAddOrEditPersonUseInfoModel.mobile = [TextShowWithModelStr textShowWithModelStr:self.listEditPersonWithModel.idCard];
                 }
                 [weakSelf initListInfo];//更新cell
                 [tableView reloadData];
             };
             cell.switchV.on = self.saveNowSwithChooseType_isHavePhoneNotCareMode;//关系到展示的开启手机号状态 ｜ 是否保护模式 (负相关)  ====》eg:NO 保护模式 无手机号 显示的是关闭按钮 （界面按钮状态正相关）
         
            return cell;
        }else{//新增状态 关怀模式
            MyHouseAddSubPersonVCLateShowSwithTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyHouseAddSubPersonVCLateShowSwithTableViewCell_I];
            if (!cell) {
                cell = [[MyHouseAddSubPersonVCLateShowSwithTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyHouseAddSubPersonVCLateShowSwithTableViewCell_I];
            }
            WEAKSELF
            cell.cellSubSwitchSelectedBlock = ^(BOOL isOn) { //"是否关怀模式"
                weakSelf.saveNowSwithChooseType_isHavePhoneNotCareMode = !isOn;
                [weakSelf initListInfo];//更新cell
                [tableView reloadData];
            };
            cell.switchV.on = !self.saveNowSwithChooseType_isHavePhoneNotCareMode;
            return cell;
            
        }
        
    }else if ([thisCellConstr containsString: Row_ShowConStr_SmallTipCell]){
        MyHouseAddSubPersonVCLateShowTipTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyHouseAddSubPersonVCLateShowTipTextTableViewCell_I ];
        if (!cell) {
            cell = [[MyHouseAddSubPersonVCLateShowTipTextTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyHouseAddSubPersonVCLateShowTipTextTableViewCell_I];
        }
        return cell;
        
    }else  {//  ([thisCellConstr containsString: Row_ShowConStr_LongTipCell]){
        MyHouseAddSubPersonVCLateShowTipTextAndBeginImgVTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyHouseAddSubPersonVCLateShowTipTextAndBeginImgVTableViewCell_I];
        if (!cell) {
            cell = [[MyHouseAddSubPersonVCLateShowTipTextAndBeginImgVTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyHouseAddSubPersonVCLateShowTipTextAndBeginImgVTableViewCell_I];
        }
        return cell;
        
    }

}
 

#pragma mark === 组圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==  Row_Num_OnlyTipShowLongTextCell) {
        return;
    }
    CGFloat cornerRadius = 7.5f;
    UIColor *sectionFillColor =  [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    UIColor *separatoColor = [ThemeManager shareManager].themeLineColor;
    if ([cell respondsToSelector:@selector(tintColor)]) {
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 16.0, 0);
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);// 实体剧形状
        } else if (indexPath.row == 0) {//上部分有圆角
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
            
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {//下部分有圆角
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            separatoColor = [UIColor clearColor];
        } else {//填充？
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        //颜色修改
        layer.fillColor = sectionFillColor.CGColor;
        layer.strokeColor= sectionFillColor.CGColor;
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-0.5, bounds.size.width-10*2, 0.5);//h_0.5
            NSString *thisCellConstr = self.cellShowThingArr[indexPath.section][indexPath.row];
            if ((self.myHouseAddOrEditSubPersonVC_Type == MyHouseAddOrEditSubPersonVC_Type_Add) && ([thisCellConstr containsString: Row_ShowConStr_Swichell] )){//开关cell 关怀模式cell  新增家属时
                lineLayer.backgroundColor =  [UIColor clearColor].CGColor;
                [layer addSublayer:lineLayer];
            }else{
                lineLayer.backgroundColor = separatoColor.CGColor;
                [layer addSublayer:lineLayer];
            }
                
 
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}

 
#pragma mark == == == == == == == == == == == == ==
#pragma mark == img pick
 
- (void)iconImgTap{
        //非处理状态
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        __weak typeof(self) weakSelf = self;
        UIAlertAction *photographAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //图片拍照
            [weakSelf chooseImageWithType:Photo_Choose_Type_Grapht];
        }];
        UIAlertAction *photoalbumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //图片相册选择
            [weakSelf chooseImageWithType:Photo_Choose_Type_Album];
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:photographAction];
        [alertVC addAction:photoalbumAction];
        [alertVC addAction:cancleAction];
        alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:alertVC animated:YES completion:nil];
   
}

- (void)chooseImageWithType:(Photo_Choose_Type)type {
   
   UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
   pickVC.delegate = self;
   if (type == Photo_Choose_Type_Grapht) {
       
       pickVC.allowsEditing = YES;//设置为允许编辑  didFinish UIImagePickerControllerOriginalImage 改成 UIImagePickerControllerEditedImage
       pickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
   }else {
       pickVC.allowsEditing = YES;
       pickVC.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
   }
   pickVC.modalPresentationStyle = UIModalPresentationFullScreen;
   [self presentViewController:pickVC animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate 图片 回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
//    UIImage *photo = info[UIImagePickerControllerOriginalImage];
    UIImage *photo = info[UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self imgDetalWithPhoto:photo];
}
#pragma mark === 提交img信息的 //图片上传 用聊天的图片公共上传接口
- (void)imgDetalWithPhoto:(UIImage *)photo{
    WEAKSELF
    NSLog(@"图片上传 %@",photo);
    Y_SVP_SHOW_MES_IsDealing_15Delay
    [BaseImgUpDataTool baseUpImgWithOneImg:photo  withParms:@{}.mutableCopy withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            //NSMutableDictionary *getDataDic =  ( [[dic allKeys] containsObject:@"data"] && isNotNil([dic objectForKey:@"data"]) ) ? [dic objectForKey:@"data"] : [NSDictionary dictionary];
            NSMutableDictionary *getDataDic = dic.mutableCopy;
            NSString *imgUrl =  [[getDataDic allKeys] containsObject:@"url"]?[NSString stringWithFormat:@"%@",[getDataDic objectForKey:@"url"]] : @"";
            weakSelf.myHouseAddOrEditPersonUseInfoModel.faceUrl = imgUrl;
             Y_SVP_SHOW_SUCCESS_MES(@"图像上传成功！");
             dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
 
}

#pragma  mark == footer action
- (void)footerBtnAction{
    [self.view endEditing:YES];
    NSLog(@"新增/修改 提交信息");
    
    
    if (self.myHouseAddOrEditPersonUseInfoModel.name.length<=0) {
        Y_SVP_SHOW_INFO_MES(@"请输入姓名！");
        return;
    }
    if (self.saveNowSwithChooseType_isHavePhoneNotCareMode) {//有手机非关怀的状态｜或则｜关怀状态的非新增而是编辑页时的有手机状态 不处理身份证 只处理手机号
        if (self.myHouseAddOrEditPersonUseInfoModel.mobile.length <= 0) {
            Y_SVP_SHOW_INFO_MES(@"请输入手机号！");
            return;
        }
        if ((self.myHouseAddOrEditPersonUseInfoModel.mobile.length < 8) || (self.myHouseAddOrEditPersonUseInfoModel.mobile.length > 11)) {
            Y_SVP_SHOW_INFO_MES(@"手机号格式错误！");
            return;
        }
    }else{//关怀模式 新版有身份证数据 ｜新增页 编辑页 都会走这个
 
        if (self.myHouseAddOrEditPersonUseInfoModel.idCard.length <= 0) {
            Y_SVP_SHOW_INFO_MES(@"请输入身份证号！");
            return;
        }
        if ( self.myHouseAddOrEditPersonUseInfoModel.idCard.length != 18 &&  self.myHouseAddOrEditPersonUseInfoModel.idCard.length != 15 ) {//一代身份证是15位,二代身份证是18位; 两个格式都不匹配 则为错误格式
            Y_SVP_SHOW_INFO_MES(@"身份证格式错误！");
            return;
        }
        if (self.myHouseAddOrEditPersonUseInfoModel.faceUrl.length <= 0) {
            Y_SVP_SHOW_INFO_MES(@"请选择人脸图像！");
            return;
        }
    }
    
    
    if (self.myHouseAddOrEditSubPersonVC_Type == MyHouseAddOrEditSubPersonVC_Type_Add) {//新增类型
        WEAKSELF
        NSMutableDictionary *personInfo = [NSMutableDictionary  dictionaryWithCapacity:0];
        [personInfo setValue:@(self.myHouseAddOrEditPersonUseInfoModel.houseId) forKey:@"houseId"];
        [personInfo setValue:@(self.myHouseAddOrEditPersonUseInfoModel.communityId) forKey:@"communityId"];
        [personInfo setValue:[TextShowWithModelStr textShowWithModelStr:self.myHouseAddOrEditPersonUseInfoModel.name] forKey:@"name"];
        if (self.saveNowChoose_relationType == selfNowChoose_relationType_ZuKe) {
            [personInfo setValue:@(7) forKey:@"relation"];//PersonRelatio_Num_Zuke=6
        }else if(self.saveNowChoose_relationType == selfNowChoose_relationType_JiaShu){
            [personInfo setValue:@(6) forKey:@"relation"]; 
        }
        if (self.saveNowSwithChooseType_isHavePhoneNotCareMode) {//手机非关怀
            [personInfo setValue:@(0) forKey:@"carePattern"];//是否开启关怀模式(0.关闭 1.开启)
            [personInfo setValue:[TextShowWithModelStr textShowWithModelStr:self.myHouseAddOrEditPersonUseInfoModel.mobile] forKey:@"mobile"];
        }else{//关怀
            [personInfo setValue:@(1) forKey:@"carePattern"];
            [personInfo setValue:[TextShowWithModelStr textShowWithModelStr:self.myHouseAddOrEditPersonUseInfoModel.faceUrl] forKey:@"faceUrl"];
            [personInfo setValue:[TextShowWithModelStr textShowWithModelStr:self.myHouseAddOrEditPersonUseInfoModel.idCard] forKey:@"idCard"];
        }
    
        DLog(@"add personInfo  %@",personInfo);
        [MyHouseData addMyHousePersonsRelationsWithPersonInfoDic:personInfo withBlock:^(NSDictionary * dic, BOOL success) {
            if (success) {
                if (isNil(dic)) {
                    Y_SVP_SHOW_ERR_MES(@"数据有误");
                    return;
                }
                [weakSelf successAddOrEditWithDeffeirentActionWithDic:dic];
            }
        }];
    }else{//编辑修改类型
        WEAKSELF
        NSMutableDictionary *personInfo = [NSMutableDictionary  dictionaryWithCapacity:0];
        [personInfo setValue:@(self.listEditPersonWithModel.ID) forKey:@"id"];
        [personInfo setValue:@(self.myHouseAddOrEditPersonUseInfoModel.houseId) forKey:@"houseId"];
        [personInfo setValue:@(self.myHouseAddOrEditPersonUseInfoModel.communityId) forKey:@"communityId"];
        [personInfo setValue:[TextShowWithModelStr textShowWithModelStr:self.myHouseAddOrEditPersonUseInfoModel.name] forKey:@"name"];
        [personInfo setValue:@(6) forKey:@"relation"];//PersonRelatio_Num_家属
        
        if (self.saveNowSwithChooseType_isHavePhoneNotCareMode) {//手机即将更新旧关怀为非关怀----- 为了变成非关怀 当前关怀家属编辑页的手机信息----要旧的人脸图像数据+新的手机数据
            [personInfo setValue:@(0) forKey:@"carePattern"];//是否开启关怀模式(0.关闭 1.开启)
            [personInfo setValue:[TextShowWithModelStr textShowWithModelStr:self.myHouseAddOrEditPersonUseInfoModel.mobile] forKey:@"mobile"];
            [personInfo setValue:[TextShowWithModelStr textShowWithModelStr:self.myHouseAddOrEditPersonUseInfoModel.faceUrl] forKey:@"faceUrl"];
            [personInfo setValue:[TextShowWithModelStr textShowWithModelStr:self.myHouseAddOrEditPersonUseInfoModel.idCard] forKey:@"idCard"];


        }else{//关怀----- 需要之前列表页的手机编号信息 还是关怀模式 基础信息更改
            [personInfo setValue:@(1) forKey:@"carePattern"];
            [personInfo setValue:[TextShowWithModelStr textShowWithModelStr:self.listEditPersonWithModel.mobile] forKey:@"mobile"];
            [personInfo setValue:[TextShowWithModelStr textShowWithModelStr:self.myHouseAddOrEditPersonUseInfoModel.faceUrl] forKey:@"faceUrl"];
            [personInfo setValue:[TextShowWithModelStr textShowWithModelStr:self.myHouseAddOrEditPersonUseInfoModel.idCard] forKey:@"idCard"];
        }
        DLog(@"edit personInfo  %@",personInfo);
        [MyHouseData updateMyHousePersonWithFlamilyInfoDic:personInfo withBlock:^(NSDictionary * dic, BOOL success) {
            if (success) {
                if (isNil(dic)) {
                    Y_SVP_SHOW_ERR_MES(@"数据有误");
                    return;
                }else{
                    [weakSelf successAddOrEditWithDeffeirentActionWithDic:dic];
                }
            }
        }];
        
    }
   
}
- (void)successAddOrEditWithDeffeirentActionWithDic:(NSDictionary *)dic{
    WEAKSELF
    
    BOOL successDicHaveUrlStrBool = [[dic allKeys]containsObject:@"URL"];
    if (successDicHaveUrlStrBool){//数据 有手机 非关怀 去h5界面展示引导  self.saveNowSwithChooseType_isHavePhoneNotCareMode
        //成功后的前页列表刷新
        if (isNil(weakSelf.addOrEditPersonWithRefreshListVcBlock)) {
            return;
        }
        weakSelf.addOrEditPersonWithRefreshListVcBlock();
        //新增成功后的跳转
        NSString *thisRelationText = @"";
        if (self.saveNowChoose_relationType == selfNowChoose_relationType_ZuKe) {
            thisRelationText = @"租客";
            
        }else if(self.saveNowChoose_relationType == selfNowChoose_relationType_JiaShu){
            thisRelationText = @"家属";
        }
        NSString *addInfoStr = [NSString stringWithFormat:@"邀请您（%@）加入我的%@成员关系", self.myHouseAddOrEditPersonUseInfoModel.name,thisRelationText];
        NSString *urlStr = [dic objectForKey:@"URL"];
        dispatch_async(dispatch_get_main_queue(), ^{
            MyHouseAddSubPerSonSuccessVc *vc = [[MyHouseAddSubPerSonSuccessVc alloc]init];
            vc.showScanCodeWebUrlStr = urlStr;
            vc.addInfoStr = addInfoStr;
            vc.addressStr = self.addressStr;
            [weakSelf pushVc:vc];
            //再删除nav中的编辑页 跳转了再删 不然就nil了
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                if ([weakSelf respondsToSelector:@selector(removeSelfVc)]) {
                    [weakSelf performSelector:@selector(removeSelfVc) withObject:nil];
                }
            });
        });
    }else{//无手机 关怀模式 直接回列表页popvc
        //成功后的前页列表刷新
    
        if (isNil(weakSelf.addOrEditPersonWithRefreshListVcBlock)) {
            return;
        }
        weakSelf.addOrEditPersonWithRefreshListVcBlock();
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_SHOW_SUCCESS_MES(@"操作成功!");
            [weakSelf popVC];
        });
    }
    
}

- (void)removeSelfVc{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *vcArr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
         for (UIViewController *vc in vcArr) {
             if ([vc isKindOfClass:[MyHouseAddSubPersonVCLate class]]) {
                 [vcArr removeObject:vc];
                 break;
             }
         }
         self.navigationController.viewControllers = vcArr;
    });
}
@end
