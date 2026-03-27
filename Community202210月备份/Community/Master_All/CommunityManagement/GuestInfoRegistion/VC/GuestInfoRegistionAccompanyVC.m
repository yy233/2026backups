//
//  GuestInfoRegistionAccompanyVC.m
//  Community
//
//  Created by 余莹 on 2020/12/8.
//

#import "GuestInfoRegistionAccompanyVC.h"
#import "AccompanyNavView.h"
#import "AccompanyFooterView.h"
#import "AccompanyTableViewCell.h"
#import "AccompanyMoreChooseTypeTableViewCell.h"

#import "AccompanySectionHeaderView.h"
#import "PopViewAccompanyPerson.h"
#import "PopViewAccomPanyCar.h"

#import "CarInfoModel.h"
//列表数据
#import "AccompanyPersonListModel.h"
#import "AccompanyCarListModel.h"
//增删改
#import "AccompanyOnePersonManage.h"
#import "AccompanyOneCarManage.h"


#define AccompanyTableViewCell_Identifier                    @"AccompanyTableViewCell"
#define AccompanyMoreChooseTypeTableViewCell_Identifier     @"AccompanyMoreChooseTypeTableViewCell"
@interface GuestInfoRegistionAccompanyVC () <AccompanyNavViewChooseDelegate,AccompanyTableViewCellDegelate,AccompanyMoreChooseTypeTableViewCellDelegate,PopViewAccompanyPersonDelegate,PopViewAccomPanyCarDelegate>
@property (nonatomic,strong) AccompanyNavView *navTopChooseBtnView;
@property (nonatomic,strong) AccompanyFooterView *footerView;
@property (nonatomic,strong) AccompanySectionHeaderView *sectionHeaderView;
@property (nonatomic,strong) PopViewAccompanyPerson *popViewAddPerson;
@property (nonatomic,strong) PopViewAccomPanyCar *popViewAddCar;
@property (nonatomic,assign) Accompany_Type showAccompanyPersonOrCarType;//显示类型
@property (nonatomic,assign) BOOL isMoreChooseType;//多选状态

@property (nonatomic,assign) NSInteger pageNumOfPerson;
@property (nonatomic,assign) NSInteger pageNumOfCar;

//被选择的
@property (nonatomic,strong) NSMutableArray *personIsChooseDataSourceArr;
@property (nonatomic,strong) NSMutableArray *carIsChooseDataSourceArr;
@end

@implementation GuestInfoRegistionAccompanyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavOfPersonAndCar];
    [self initPageNum];
    if (self.type == Type_Add_GuestInfoRegistionEditVC) {//添加时 全数据
        [self addRefresh];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self noticePopModeToEditVc];
}
- (void)initPageNum{
    self.pageNumOfPerson = 1;
    self.pageNumOfCar = 1;
}
#pragma mark === addRefresh
- (void)addRefresh{
//    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
//    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upData)];
//    self.tableView.mj_header = headeerRefresh;
//    self.tableView.mj_footer = footerRefresh;
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headeerRefreshInitData)];//查全部
    self.tableView.mj_header = headeerRefresh;
 
}
#pragma mark === nav choose
- (void)accompanyNavViewSubBtnTouchChooseType:(Accompany_Type)type{
    if (type==Accompany_Type_Person) {
        self.showAccompanyPersonOrCarType = Accompany_Type_Person;
        [self chanfooterBtnTitle:Accompany_Type_Person];
        [self changeSectionHeaderTitle:Accompany_Type_Person];
    }
    if (type==Accompany_Type_Car) {
        self.showAccompanyPersonOrCarType = Accompany_Type_Car;
        [self chanfooterBtnTitle:Accompany_Type_Car];
        [self changeSectionHeaderTitle:Accompany_Type_Car];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
   
}
#pragma mark == notice post
- (void)noticePopModeToEditVc{
    if (self.type==Type_Edit_GuestInfoRegistionEditVC||self.type==Type_Show_GuestInfoRegistionEditVC) {//查看状态
        return;
    }
    //
    [self noticePoostPersonModelArr];
    [self noticePostCarModelArr];
}
- (void)noticePoostPersonModelArr{
    NSLog(@"noticePoostPersonModelArr count %lu",(unsigned long)self.personIsChooseDataSourceArr.count);
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithObject:self.personIsChooseDataSourceArr forKey:GuestInfo_Add_Accompanu_UserInfo_Key_Person];
    Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(GuestInfo_Add_Accompany_Person_Notice_Name, userInfoDic);
}
- (void)noticePostCarModelArr{
    NSLog(@"carIsChooseDataSourceArr count %lu",(unsigned long)self.carIsChooseDataSourceArr.count);
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithObject:self.carIsChooseDataSourceArr forKey:GuestInfo_Add_Accompanu_UserInfo_Key_Car];
    Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(GuestInfo_Add_Accompany_Car_Notice_Name, userInfoDic);
}
#pragma mark == data
- (void)initData{
    if (self.type == Type_Add_GuestInfoRegistionEditVC) {//添加时 全数据
        self.tableView.tableFooterView = self.footerView;
        [self initPersonData];
        [self initCarData];
        
    }
    if (self.type == Type_Show_GuestInfoRegistionEditVC) {//查看时 本访客信息ID所对应数据
        self.tableView.tableFooterView = [UIView new];
        [self.tableView reloadData];
    }
   
}
- (void)headeerRefreshInitData{
    if (self.showAccompanyPersonOrCarType==Accompany_Type_Person) {
        [self initPersonData];
    }
    if (self.showAccompanyPersonOrCarType==Accompany_Type_Car) {
        [self initCarData];
    }
    
}
- (void)initPersonData{
    [AccompanyPersonListModel getAccompayPersonInitListWithBlock:^(NSArray * arr) {
        Y_SVP_DISMISS
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
        
        if (arr.count==0) {
        }else{
            self.personDataSourceArr = [NSMutableArray arrayWithArray:[GuestInfoModel mj_objectArrayWithKeyValuesArray:arr]];
            self.personIsChooseDataSourceArr = [NSMutableArray array];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}
- (void)initCarData{
    [AccompanyCarListModel getAccompayCarInitListWithBlock:^(NSArray * arr) {
        Y_SVP_DISMISS
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
        if (arr.count==0) {
        }else{
            self.carDataSourceArr = [NSMutableArray arrayWithArray:[CarInfoModel mj_objectArrayWithKeyValuesArray:arr]];
            self.carIsChooseDataSourceArr = [NSMutableArray array];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}
//（增删改的时候 错位or得重新刷新 不好处理） 此upData 弃用
- (void)upData{
    if (self.showAccompanyPersonOrCarType == Accompany_Type_Person) {
        [self morePersonData];
    }
    if (self.showAccompanyPersonOrCarType == Accompany_Type_Car) {
        [self moreCarData];
    }
}
- (void)morePersonData{
    self.pageNumOfPerson += 1;
    [AccompanyPersonListModel getAccompayPersonUpdatMoreListWithBlock:^(NSArray * arr) {
        [self.tableView.mj_footer endRefreshing];
        if (arr.count==0) {
            self.pageNumOfPerson -=1;
            return;
        }else{
            [self.personDataSourceArr addObjectsFromArray: [GuestInfoModel mj_objectArrayWithKeyValuesArray:arr]];
        }
    } nowPageNum:self.pageNumOfPerson];
}
- (void)moreCarData{
    self.pageNumOfCar += 1;
    [AccompanyCarListModel getAccompayCarUpdatMoreListWithBlock:^(NSArray * arr) {
        [self.tableView.mj_footer endRefreshing];
        if (arr.count==0) {
            self.pageNumOfCar -= 1;
            return;
        }else{
            [self.carDataSourceArr addObjectsFromArray:[CarInfoModel mj_objectArrayWithKeyValuesArray:arr]];
        }
    } nowPageNum:self.pageNumOfCar];
}
#pragma mark == cell btn edit_btn 修改按钮 弹出 person/ car
//随行人员 随行车辆
- (void)cellRightBtnTouchGuest:(GuestInfoModel *)model{
    if (self.type==Type_Add_GuestInfoRegistionEditVC) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.popViewAddPerson showInView:self.view thePopViewSubViewHeight:250 WithArray:@[model].mutableCopy];
        });
    }
}
- (void)cellRightBtnTouchCar:(CarInfoModel *)model{
    if (self.type==Type_Add_GuestInfoRegistionEditVC) {
        [self popCarDataAndShowPopView:model];
    }
}
#pragma mark == cell delegate
#pragma mark == 单选——————cell btn  已选变成取消
//随行人员 随行车辆
- (void)cellSelectedTypeBtnTouchGuest:(GuestInfoModel *)model{
    if ([self.personIsChooseDataSourceArr containsObject:model]) {//存在 则删除
        [self.personIsChooseDataSourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model isEqual:self.personIsChooseDataSourceArr[idx]]) {
                [self.personIsChooseDataSourceArr removeObjectAtIndex:idx];
            }
        }];
    }
    [self.tableView reloadData];
}
- (void)cellSelectedTypeBtnTouchCar:(CarInfoModel *)model{
    if ([self.carIsChooseDataSourceArr containsObject:model]) {//存在 则删除
        [self.carIsChooseDataSourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model isEqual:self.carIsChooseDataSourceArr[idx]]) {
                [self.carIsChooseDataSourceArr removeObjectAtIndex:idx];
            }
        }];
    }
    [self.tableView reloadData];
}
#pragma mark == 多选————more_choose ——cell btn 选择状态切换
- (void)cellIsMoreChooseTypeChooseBtnActionIsSelected:(BOOL)selected WithPersonModel:(GuestInfoModel *)model{
    if (selected==YES) {//选择
        if (![self.personIsChooseDataSourceArr containsObject:model]) {//不存在 则添加
            [self.personIsChooseDataSourceArr addObject:model];
        }
    }else{//取消
        if ([self.personIsChooseDataSourceArr containsObject:model]) {//存在 则删除
            [self.personIsChooseDataSourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([model isEqual:self.personIsChooseDataSourceArr[idx]]) {
                    [self.personIsChooseDataSourceArr removeObjectAtIndex:idx];
                }
            }];
        }
    }
    [self.tableView reloadData];
}
- (void)cellIsMoreChooseTypeChooseBtnActionIsSelected:(BOOL)selected WithCarModel:(CarInfoModel *)model{
    if (selected==YES) {//选择
        if (![self.carIsChooseDataSourceArr containsObject:model]) {//不存在 则添加
            [self.carIsChooseDataSourceArr addObject:model];
        }
    }else{//取消
        if ([self.carIsChooseDataSourceArr containsObject:model]) {//存在 则删除
            [self.carIsChooseDataSourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([model isEqual:self.carIsChooseDataSourceArr[idx]]) {
                    [self.carIsChooseDataSourceArr removeObjectAtIndex:idx];
                }
            }];
        }
    }
    [self.tableView reloadData];
}
#pragma mark === Header_View ________moreChooseBtnAction 多选按钮
- (void)moreChooseBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected==YES) {
        //多选。
        self.isMoreChooseType = YES;
        [self.footerView isMoreChooseTypeFooterView];
        //全数据
        [self moreChooseAddAllArr];
    }else{
        //回原状
        self.isMoreChooseType = NO;
        [self.footerView isNomalNoMoreChooseTypeFooterView];
    }
 
    [self.tableView reloadData];
}
- (void)moreChooseAddAllArr{
    if (_showAccompanyPersonOrCarType == Accompany_Type_Person) {
        self.personIsChooseDataSourceArr = [NSMutableArray arrayWithArray:self.personDataSourceArr];
    }else{
        self.carIsChooseDataSourceArr = [NSMutableArray arrayWithArray:self.carDataSourceArr];
    }
}
 
#pragma mark ===================== Footer_View
#pragma mark == footer add
- (void)footerBtnAddAction:(UIButton *)sender{//添加单个cell 新增
    if (self.type == Type_Add_GuestInfoRegistionEditVC) {
        //add
        if (_showAccompanyPersonOrCarType==Accompany_Type_Person) {
            //add
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.popViewAddPerson showInView:self.view thePopViewSubViewHeight:250 WithArray:@[].mutableCopy];
            });
        }else{
            [self popCarDataAndShowPopView:nil];//add car model==nil
        }
    }
   
}
#pragma mark == footer delet
//多选 删除 按钮 --- 总数据 删除按钮
- (void)deletBtnAction:(UIButton *)sender{
    if (_showAccompanyPersonOrCarType==Accompany_Type_Person) {
        DLog(@"Accompany_Type_Person 多选 删除 按钮");
        [self deletchoosePeronArr];
    }else{
        DLog(@"Accompany_Type_car 多选 删除 按钮");
        [self deletchooseCarArr];
    }
}
#pragma mark === 删除 arr   person
- (void)deletchoosePeronArr{
    Y_SVP_SHOW_MES_IsDealing_15Delay
    [AccompanyOnePersonManage personDeletWithModelArr:self.personIsChooseDataSourceArr withReturn:^(BOOL delBool) {
        if (delBool) {
            [self initPersonData];
        }else{
            Y_SVP_DISMISS
            Y_SVP_SHOW_ERR_MES(@"删除当前已选的随行人员 失败");
        }
    }];
}
#pragma mark === 删除 arr   car
- (void)deletchooseCarArr{
    Y_SVP_SHOW_MES_IsDealing_15Delay
    [AccompanyOneCarManage carDeletWithModelArr:self.carIsChooseDataSourceArr withReturn:^(BOOL delBool) {
        if (delBool) {
            [self initCarData];
        }else{
            Y_SVP_DISMISS
            Y_SVP_SHOW_ERR_MES(@"删除当前已选的随行车辆 失败");
        }
    }];
}

#pragma mark ===  多选 按钮 到已选的随行arr notice
- (void)moreChooseAddWillNoticeListAction:(UIButton *)sender{
    if (_showAccompanyPersonOrCarType==Accompany_Type_Person) {
        DLog(@"Accompany_Type_Person 多选 按钮");
        [self noticePoostPersonModelArr];
    }else{
        DLog(@"Accompany_Type_car 多选 按钮");
        [self noticePostCarModelArr];
    }
//    //取消多选状态 完成按钮 点击事件所走方法  
    [self moreChooseBtnAction:self.sectionHeaderView.rightMoreChooseBtn];
    [self.tableView reloadData];
}
#pragma mark ===================== Pop——View
#pragma mark == popview show car add
-  (void)popCarDataAndShowPopView:(CarInfoModel *)oldModel{//nil==add else  edit
    //add
    [CarTypeListModel getCarTypeListWithBlock:^(NSArray * arr) {
        if (arr.count==0) {
            Y_SVP_SHOW_ERR_MES(@"车辆类型信息获取失败");
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.popViewAddCar showInView:self.view thePopViewSubViewHeight:250 WithArray:arr.mutableCopy WithOldCarInfoModel:oldModel];
        });
    }];
    
  
}
#pragma mark === popview delegete person 添加/修改
- (void)personAddNewInfoWithGuestInfoModel:(GuestInfoModel *)model{
    
    [AccompanyOnePersonManage personAddWithOneModel:model withReturn:^(BOOL resultBool) {
        if (resultBool) {
            [self.personDataSourceArr addObject:model];//是否刷新 待定
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }else{
            Y_SVP_SHOW_ERR_MES(@"添加人员失败");
        }
    }];
}
//修改
- (void)personRemoveOldGuestInfoModel:(GuestInfoModel *)model addNewInfoModel:(GuestInfoModel *)newModel{
    //替换旧的
    [AccompanyOnePersonManage personUpdateWithOneOldModel:model newModel:newModel withReturn:^(BOOL resultBool) {
        if (resultBool) {
            for (int i = 0 ; i <self.personDataSourceArr.count; i++) {
                if ([model isEqual:self.personDataSourceArr[i]]) {
                    [self.personDataSourceArr replaceObjectAtIndex:i withObject:newModel];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }else{
            Y_SVP_SHOW_ERR_MES(@"修改随行人员失败");
        }
    }];
}
#pragma mark === popview delegete person 删除one person
- (void)deletPeronOneModelWithIndexRowNum:(NSIndexPath*)indexPath{
    [AccompanyOnePersonManage personDeletWithOneModel:self.personDataSourceArr[indexPath.row] withReturn:^(BOOL delBool) {
        if (delBool) {
            [self.personDataSourceArr removeObjectAtIndex:indexPath.row];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationFade];
            });
        }else{
            Y_SVP_SHOW_ERR_MES(@"删除当前随行人员 失败");
        }
    }];
}

#pragma mark === popview delegete car 添加/修改
//car//添加
- (void)carAddNewModel:(CarInfoModel *)newCarInfoModel removeOldCarInfoModel:(CarInfoModel *)oldCarInfomodell{
    if (oldCarInfomodell==nil) {
        [AccompanyOneCarManage carAddWithOneModel:newCarInfoModel withReturn:^(BOOL resultBool) {
            if (resultBool) {
                [self.carDataSourceArr addObject:newCarInfoModel];//是否刷新 待定
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }else{
                Y_SVP_SHOW_ERR_MES(@"添加车辆失败");
            }
        }];
       
    }else{
        //替换旧的
        [AccompanyOneCarManage carUpdateWithOneOldModel:oldCarInfomodell newModel:newCarInfoModel withReturn:^(BOOL resultBool) {
            if (resultBool) {
                //替换旧的
                for (int i = 0 ; i <self.carDataSourceArr.count; i++) {
                    if ([oldCarInfomodell isEqual:self.carDataSourceArr[i]]) {
                        [self.carDataSourceArr replaceObjectAtIndex:i withObject:newCarInfoModel];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }else{
                Y_SVP_SHOW_ERR_MES(@"修改随行人员失败");
            }
        }];
    }
}
#pragma mark === popview delegete car 删除one car
- (void)deletCarOneModelWithIndexRowNum:(NSIndexPath*)indexPath{
    [AccompanyOneCarManage carDeletWithOneModel:self.carDataSourceArr[indexPath.row] withReturn:^(BOOL delBool) {
        if (delBool) {
            [self.carDataSourceArr removeObjectAtIndex:indexPath.row];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationFade];
            });
        }else{
            Y_SVP_SHOW_ERR_MES(@"删除当前随行车辆 失败");
        }
    }];
}

#pragma mark ==
#pragma mark== tablev delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.showAccompanyPersonOrCarType==Accompany_Type_Person) {
        return self.personDataSourceArr.count;
    }else{
        return self.carDataSourceArr.count;
    }
  
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isMoreChooseType==NO) {//单选cell
        AccompanyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AccompanyTableViewCell_Identifier];
        if (!cell) {
            cell = [[AccompanyTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:AccompanyTableViewCell_Identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        //查看状态
        if (self.type==Type_Show_GuestInfoRegistionEditVC) {
            cell.editorBtn.hidden = YES;
            if (self.showAccompanyPersonOrCarType==Accompany_Type_Person) {
                cell.personModel = self.personDataSourceArr[indexPath.row];
            }else{
                cell.carModel = self.carDataSourceArr[indexPath.row];
            }
         }
        //编辑状态
        if(self.type==Type_Add_GuestInfoRegistionEditVC){
            if (self.showAccompanyPersonOrCarType==Accompany_Type_Person) {
                cell.personModel = self.personDataSourceArr[indexPath.row];
                //选择状态
                if ([self.personIsChooseDataSourceArr containsObject:self.personDataSourceArr[indexPath.row]]) {
                    [cell isSelectedType];
                }else{
                    [cell isNomailType];
                }
            }else{
                cell.carModel = self.carDataSourceArr[indexPath.row];
                //选择状态
                if ([self.carIsChooseDataSourceArr containsObject:self.carDataSourceArr[indexPath.row]]) {
                    [cell isSelectedType];
                }else{
                    [cell isNomailType];
                }
            }
        }
        return cell;
    }else{//多选cell
        AccompanyMoreChooseTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AccompanyMoreChooseTypeTableViewCell_Identifier];
        if (!cell) {
            cell = [[AccompanyMoreChooseTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:AccompanyMoreChooseTypeTableViewCell_Identifier];
        }
//        cell.delegate = self;
        cell.moreChooseTypeCellDelegate = self;
        //查看状态
        if (self.type==Type_Show_GuestInfoRegistionEditVC) {
            cell.editorBtn.hidden = YES;
            if (self.showAccompanyPersonOrCarType==Accompany_Type_Person) {
                cell.personModel = self.personDataSourceArr[indexPath.row];
            }else{
                cell.carModel = self.carDataSourceArr[indexPath.row];
            }
         }
        //编辑状态
        if(self.type==Type_Add_GuestInfoRegistionEditVC){
            if (self.showAccompanyPersonOrCarType==Accompany_Type_Person) {
                cell.personModel = self.personDataSourceArr[indexPath.row];
                //选择状态
                if ([self.personIsChooseDataSourceArr containsObject:self.personDataSourceArr[indexPath.row]]) {
                    [cell isSelectedType];
                }else{
                    [cell isNomailType];
                }
            }else{
                cell.carModel = self.carDataSourceArr[indexPath.row];
                //选择状态
                if ([self.carIsChooseDataSourceArr containsObject:self.carDataSourceArr[indexPath.row]]) {
                    [cell isSelectedType];
                }else{
                    [cell isNomailType];
                }
            }
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.showAccompanyPersonOrCarType==Accompany_Type_Person) {
        if (self.personDataSourceArr.count<=1){//多选按钮 多选/完成
            self.sectionHeaderView.rightMoreChooseBtn.hidden = YES;
        }else{
            self.sectionHeaderView.rightMoreChooseBtn.hidden = NO;
        }
        
    }else{
        if (self.carDataSourceArr.count<=1) {
            self.sectionHeaderView.rightMoreChooseBtn.hidden = YES;
        }else{
            self.sectionHeaderView.rightMoreChooseBtn.hidden = NO;
        }
    }
    if (self.type == Type_Add_GuestInfoRegistionEditVC) {
        return self.sectionHeaderView;
    }else{
        return [UIView new];
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.type == Type_Add_GuestInfoRegistionEditVC) {
        return 30;
    }else{
        return 1;
    }
  
}
#pragma mark == 单选
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isMoreChooseType == YES) {//多选情况下 cell和数据 不响应这个点击方法
        return;
    }
    if (self.type == Type_Show_GuestInfoRegistionEditVC) {//展示type 不做操作
        return;
    }
    if (self.type == Type_Add_GuestInfoRegistionEditVC) {
        if (self.showAccompanyPersonOrCarType==Accompany_Type_Person) {
            if ([self.personIsChooseDataSourceArr containsObject:self.personDataSourceArr[indexPath.row]]) {//存在当前人员
                [self.personIsChooseDataSourceArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ([self.personDataSourceArr[indexPath.row] isEqual:self.personIsChooseDataSourceArr[idx]]) {
                        [self.personIsChooseDataSourceArr removeObjectAtIndex:idx];
                        NSLog(@"personIsChooseDataSourceArr removeObjectAtIndex %lu",(unsigned long)idx);
                    }
                }];
            }else{
                [self.personIsChooseDataSourceArr addObject:self.personDataSourceArr[indexPath.row]];
            }
            
        }
        if (self.showAccompanyPersonOrCarType==Accompany_Type_Car) {
             if ([self.carIsChooseDataSourceArr containsObject:self.carDataSourceArr[indexPath.row]]) {//存在当前车辆
                [self.carIsChooseDataSourceArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ([self.carDataSourceArr[indexPath.row] isEqual:self.carIsChooseDataSourceArr[idx]]) {
                        [self.carIsChooseDataSourceArr removeObjectAtIndex:idx];
                        NSLog(@"carIsChooseDataSourceArr removeObjectAtIndex %lu",(unsigned long)idx);
                    }
                }];
            }else{
                [self.carIsChooseDataSourceArr addObject:self.carDataSourceArr[indexPath.row]];
            }
        }
       //刷新UI
         [self.tableView reloadData];

    }
    
}
//cell删除相关
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == Type_Add_GuestInfoRegistionEditVC) {
        return YES;
    }else{
        return NO;//查看状态
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == Type_Add_GuestInfoRegistionEditVC) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;//查看状态
    }
  
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == Type_Add_GuestInfoRegistionEditVC) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            if (self.showAccompanyPersonOrCarType==Accompany_Type_Person) {
                [self deletPeronOneModelWithIndexRowNum:indexPath];
            }else{
                [self deletCarOneModelWithIndexRowNum:indexPath];
            }
        }
    }
   
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == Type_Add_GuestInfoRegistionEditVC) {
        return @"删除";
    }else{
        return @"";
    }
     
}
#pragma mark ==  UI
- (void)setNavOfPersonAndCar{
    self.title = @"随行车辆-----随行人员";
    self.navigationItem.titleView = self.navTopChooseBtnView;
}
#pragma mark == nav
- (AccompanyNavView *)navTopChooseBtnView{
    if (!_navTopChooseBtnView) {
        _navTopChooseBtnView = [[AccompanyNavView alloc]initWithFrame: CGRectMake(0, 0, Screen_W, KNavBarHeight)];
        _navTopChooseBtnView.delegate = self;
    }
    return _navTopChooseBtnView;
}
#pragma mark == popView
-  (PopViewAccompanyPerson *)popViewAddPerson{
    _popViewAddPerson = [[PopViewAccompanyPerson alloc]initWithFrame:CGRectZero];//不可用getter
    _popViewAddPerson.delegate = self;
    return _popViewAddPerson;
}
- (PopViewAccomPanyCar *)popViewAddCar{
    _popViewAddCar = [[PopViewAccomPanyCar alloc]initWithFrame:CGRectZero];
    _popViewAddCar.delegate = self;
    return _popViewAddCar;
}
#pragma mark == footer
- (AccompanyFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[AccompanyFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 90)];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAddAction:) forControlEvents:UIControlEventTouchUpInside];//新增按钮
        [_footerView.deletBtn addTarget:self action:@selector(deletBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView.moreChooseAddbtn addTarget:self action:@selector(moreChooseAddWillNoticeListAction:) forControlEvents:UIControlEventTouchUpInside];//多选添加按钮
        [_footerView.footerBtn setTitle:@"新增随行人员" forState:UIControlStateNormal];
        [_footerView.moreChooseAddbtn setTitle:@"添加至随行人员" forState:UIControlStateNormal];
    }
    return _footerView;
}
- (void)chanfooterBtnTitle:(Accompany_Type)type{
    if (type==Accompany_Type_Person) {
        [_footerView.footerBtn setTitle:@"新增随行人员" forState:UIControlStateNormal];
        [_footerView.moreChooseAddbtn setTitle:@"添加至随行人员" forState:UIControlStateNormal];
    }else{
        [_footerView.footerBtn setTitle:@"新增随行车辆" forState:UIControlStateNormal];
        [_footerView.moreChooseAddbtn setTitle:@"添加至随行车辆" forState:UIControlStateNormal];
    }
}
- (void)chanfooterUI:(BOOL)isDelet{//是否 删除的按钮出现
    if (isDelet) {
    }else{
    }
}
#pragma mark == sectionHeaderView
- (AccompanySectionHeaderView *)sectionHeaderView{
    if (!_sectionHeaderView) {
        _sectionHeaderView  = [[AccompanySectionHeaderView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 30)];
        [_sectionHeaderView.rightMoreChooseBtn addTarget:self action:@selector(moreChooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self changeSectionHeaderTitle:self.showAccompanyPersonOrCarType];
    }
    return _sectionHeaderView;
}
- (void)changeSectionHeaderTitle:(Accompany_Type)type{
    if (type==Accompany_Type_Person) {
        _sectionHeaderView.titleLabel.text = @"添加随行人员信息";
    }else{
        _sectionHeaderView.titleLabel.text = @"添加随行车辆信息";
    }
}
#pragma mark ==
- (NSMutableArray *)carDataSourceArr{
    if (!_carDataSourceArr) {
        _carDataSourceArr = [NSMutableArray array];
    }
    return _carDataSourceArr;
}
- (NSMutableArray *)personDataSourceArr{
    if (!_personDataSourceArr) {
        _personDataSourceArr  = [NSMutableArray array];
    }
    return _personDataSourceArr;
}
- (Accompany_Type)showAccompanyPersonOrCarType{//当前显示的列表
    if (!_showAccompanyPersonOrCarType) {
        _showAccompanyPersonOrCarType = Accompany_Type_Person;
    }
    return _showAccompanyPersonOrCarType;
}
- (BOOL)isMoreChooseType{//当前是多选状态
    if (!_isMoreChooseType) {
        _isMoreChooseType = NO;
    }
    return _isMoreChooseType;
}
//被选择的数据 存放区
- (NSMutableArray *)carIsChooseDataSourceArr{
    if (!_carIsChooseDataSourceArr) {
        _carIsChooseDataSourceArr = [NSMutableArray array];
    }
    return _carIsChooseDataSourceArr;
}
- (NSMutableArray *)personIsChooseDataSourceArr{
    if (!_personIsChooseDataSourceArr) {
        _personIsChooseDataSourceArr  = [NSMutableArray array];
    }
    return _personIsChooseDataSourceArr;
}
@end
