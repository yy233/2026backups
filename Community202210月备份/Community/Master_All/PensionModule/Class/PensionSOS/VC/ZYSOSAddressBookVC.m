//
//  ZYSOSAddressBookVC.m
//  Community
//
//  Created by ZY on 2021/11/17.
//

#import "ZYSOSAddressBookVC.h"
#import "ZYSOSAddSalvorVC.h"
#import "ZYSOSSalvageServiceVC.h"
#import "ZYSOSAddressBookBottomView.h"
#import "ZYSOSAddressBookCell.h"
#import "ZYSOSAddressBookHospitalCell.h"
#import "ZYSOSAddressBookEmptyCell.h"
#import "ZYSOSAddressBookAddHospitalCell.h"

static NSString * const SOSAddressBookCellID = @"ZYSOSAddressBookCell";
static NSString * const SOSAddressBookHospitalCellID = @"ZYSOSAddressBookHospitalCell";
static NSString * const SOSAddressBookEmptyCellID = @"ZYSOSAddressBookEmptyCell";
static NSString * const SOSAddressBookAddHospitalCellID = @"ZYSOSAddressBookAddHospitalCell";
#define kSOSAddressBookBottomViewHeight button_bottom_height+85
#define kSOSAddressBookCellHeight 60
#define kSOSAddressBookHospitalCellHeight 138
#define kSOSAddressBookAddHospitalCellHeight 108


@interface ZYSOSAddressBookVC () <UITableViewDataSource, UITableViewDelegate, ZYSOSAddressBookCellDelegate, ZYSOSAddressBookHospitalCellDelegate, ZYSOSAddressBookAddHospitalCellDelegate, ZYSOSAddressBookBottomViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYSOSAddressBookBottomView *bottomView;

@property (nonatomic, assign) BOOL isEmpty;//1211更改成家人部分的显示状态判断值。

@property (nonatomic, strong) NSArray *emptyArray;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *fmilelyDataArray;
@property (nonatomic, strong) NSMutableArray *agencyDataArray;
@end

@implementation ZYSOSAddressBookVC
- (NSMutableArray *)fmilelyDataArray{
    if (!_fmilelyDataArray) {
        _fmilelyDataArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _fmilelyDataArray;
}
- (NSMutableArray *)agencyDataArray{
    if (!_agencyDataArray) {
        _agencyDataArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _agencyDataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"SOS通讯录";
    self.isEmpty = YES;
    [self setUI];
    [self customTableView];
    [self initData];
    [self addNotice];
   
}
- (void)addNotice{
    Y_NSNotificationCenter_Creat_NameAction(NoticeName_SosAddressUpData, initData); 
}
- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(NoticeName_SosAddressUpData);
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarStyleWithSOSColor];
    
}

- (void)setUI {
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_bottomView.superview);
        make.height.offset(kSOSAddressBookBottomViewHeight);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_tableView.superview);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
    }
    
    return _tableView;
}

- (ZYSOSAddressBookBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYSOSAddressBookBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

- (NSArray *)emptyArray {
    if (!_emptyArray) {
        _emptyArray = @[@"请点击下方“+”号添加SOS救助人/机构", @"当您绑定的硬件报告数据异常后，设备异常信息和求救信息将自动一键发送给您添加的SOS救助人。", @"SOS救助人可以是任何人，目前可支持添加上限3个救助人/1个救助机构，建议您添加可信任人/机构。"];
    }
    
    return _emptyArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 加载数据
- (void)initData { 
    [self.dataArray addObjectsFromArray:@[@"", @"", @""]];//无电话时的文本类cell占位
    [self.tableView reloadData];
    WEAKSELF
    [PersionSosData getFamilysAndAgencysListOfNowFamilyId:self.saveNowFamilyModel.ID WithBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
           
            if (isNil(dic)) {
                weakSelf.isEmpty = YES;
                [weakSelf.fmilelyDataArray removeAllObjects];
                [weakSelf.agencyDataArray removeAllObjects];
            }else{
                NSArray *keys = [dic allKeys];
                //普通通讯录数据
                if ([keys containsObject:kFamilyListKey] && isNotNil([dic objectForKey:kFamilyListKey]) ) {
                    weakSelf.fmilelyDataArray = [SosAddressBookFamilyModel mj_objectArrayWithKeyValuesArray:[dic objectForKey:kFamilyListKey]];
                }else{
                    [weakSelf.fmilelyDataArray removeAllObjects];//删除操作时 更新最后一条数据
                }
                //医疗机构数据
                if ([keys containsObject:kAgencyOneObjKey] && isNotNil([dic objectForKey:kAgencyOneObjKey])) {
                    weakSelf.agencyDataArray = [NSMutableArray arrayWithObject:[SosAddressBookAgencyModel  mj_objectWithKeyValues:[dic objectForKey:kAgencyOneObjKey]]];
                }else{
                    [weakSelf.agencyDataArray removeAllObjects];
                }
                //section0的提示展示状态
                if (weakSelf.fmilelyDataArray.count==0) {
                    weakSelf.isEmpty = YES;
                }else{
                    weakSelf.isEmpty = NO;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}
#pragma mark - tableView deletAction
- (void)deletFamilyWithIndex:(NSIndexPath *)indexPath{
    SosAddressBookFamilyModel* model = self.fmilelyDataArray[indexPath.row];
    NSString *idStr = model.ID;
    WEAKSELF
    [PersionSosData editFamilysOfNowFamilyId:self.saveNowFamilyModel.ID withDeletInfoId:idStr withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            [weakSelf initData];
        }
    }];
    
}
- (void)deletAgancy{ 
    
    SosAddressBookAgencyModel* model = self.agencyDataArray.firstObject;
    NSString *idStr =  [NSString stringWithFormat:@"%ld",model.ID];//机构数据ID
    WEAKSELF
    [PersionSosData editAgencysOfNowFamilyId:self.saveNowFamilyModel.ID withDeletInfoId:idStr withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            [weakSelf initData];
        }
    }];
}
#pragma mark - 定制tableView
- (void)customTableView {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:SOSAddressBookCellID bundle:nil] forCellReuseIdentifier:SOSAddressBookCellID];
    [self.tableView registerNib:[UINib nibWithNibName:SOSAddressBookHospitalCellID bundle:nil] forCellReuseIdentifier:SOSAddressBookHospitalCellID];
    [self.tableView registerNib:[UINib nibWithNibName:SOSAddressBookEmptyCellID bundle:nil] forCellReuseIdentifier:SOSAddressBookEmptyCellID];
    [self.tableView registerNib:[UINib nibWithNibName:SOSAddressBookAddHospitalCellID bundle:nil] forCellReuseIdentifier:SOSAddressBookAddHospitalCellID];
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0 && self.fmilelyDataArray.count!=0) {
        ZYSOSAddSalvorVC *vc = [[ZYSOSAddSalvorVC alloc] init];
        vc.saveNowFamilyModel = self.saveNowFamilyModel;
        vc.isEditTypeBool = YES;
        vc.saveEditOrAddFamilyModel = self.fmilelyDataArray[indexPath.row];
        [self pushVc:vc];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isEmpty) {
        if (section == 0) {
            
            return self.emptyArray.count;
        }else {
            
            return (self.agencyDataArray.count==0 ? 1 : self.agencyDataArray.count);//医院类 cellrow总要大于0
        }
    }else {
        if (section == 0) {
            
            return self.fmilelyDataArray.count;
        }else {
            return (self.agencyDataArray.count==0 ? 1 : self.agencyDataArray.count);//医院类 cellrow总要大于0
 
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEmpty) {//全空时 2种展示类
        if (indexPath.section == 0) {
            ZYSOSAddressBookEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:SOSAddressBookEmptyCellID forIndexPath:indexPath];
            [self configureCell:cell atIndexPath:indexPath];
            
            return cell;
        }else {
            //医院类 cellrow总要大于0
            //暂无机构数据
            if (self.agencyDataArray.count==0) {
                ZYSOSAddressBookAddHospitalCell *cell = [tableView dequeueReusableCellWithIdentifier:SOSAddressBookAddHospitalCellID forIndexPath:indexPath];
                cell.delegate = self;
                return cell;
            }else{
                ZYSOSAddressBookHospitalCell *cell = [tableView dequeueReusableCellWithIdentifier:SOSAddressBookHospitalCellID forIndexPath:indexPath];
                cell.delegate = self;
                [cell fillDataWithAgencyModel:self.agencyDataArray[indexPath.row]];
                return cell;
            }
        }
    }else {//非全空时
        if (indexPath.section == 0) {
            
            ZYSOSAddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:SOSAddressBookCellID forIndexPath:indexPath];
            cell.delegate = self;
            [cell fillDataWithFamilyModel:self.fmilelyDataArray[indexPath.row]];
            
            return cell;
        }else {
            //医院类 cellrow总要大于0
            //暂无机构数据
            if (self.agencyDataArray.count==0) {
                ZYSOSAddressBookAddHospitalCell *cell = [tableView dequeueReusableCellWithIdentifier:SOSAddressBookAddHospitalCellID forIndexPath:indexPath];
                cell.delegate = self;
                return cell;
            }else{
                ZYSOSAddressBookHospitalCell *cell = [tableView dequeueReusableCellWithIdentifier:SOSAddressBookHospitalCellID forIndexPath:indexPath];
                cell.delegate = self;
                [cell fillDataWithAgencyModel:self.agencyDataArray[indexPath.row]];
                return cell;
            }
          
        }
    }
}

- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
    ZYSOSAddressBookEmptyCell *cell = (ZYSOSAddressBookEmptyCell *)currentCell;
    cell.numLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    cell.contentLabel.text = self.emptyArray[indexPath.row];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEmpty) {
        if (indexPath.section == 0) {
            
            return [tableView fd_heightForCellWithIdentifier:SOSAddressBookEmptyCellID configuration:^(ZYSOSAddressBookEmptyCell *cell) {
                [self configureCell:cell atIndexPath:indexPath];
            }];
        }else {
            
            return (self.agencyDataArray.count==0 ? kSOSAddressBookAddHospitalCellHeight : kSOSAddressBookHospitalCellHeight);
        }
    }else {
        if (indexPath.section == 0) {
            
            return kSOSAddressBookCellHeight;
        }else {
            
            return (self.agencyDataArray.count==0 ? kSOSAddressBookAddHospitalCellHeight : kSOSAddressBookHospitalCellHeight);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        
        return 20;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        
        return [[UIView alloc] init];
    }
    
    return nil;
}

//cell删除相关
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0 && self.fmilelyDataArray.count!=0) {
        return YES;
    }else  if (indexPath.section==1 && self.agencyDataArray.count!=0) {
        return YES;
    }else{
        return NO;
    }
    

}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0 && self.fmilelyDataArray.count!=0) {
        return UITableViewCellEditingStyleDelete;
    }else  if (indexPath.section==1 && self.agencyDataArray.count!=0) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
 
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section==0 && self.fmilelyDataArray.count!=0) {
            [self deletFamilyWithIndex:indexPath];
        }
        if (indexPath.section==1 && self.agencyDataArray.count!=0) {
            [self deletAgancy];
        }
      
    }
   
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0 && self.fmilelyDataArray.count!=0) {
        return @"删除";
    }
    if (indexPath.section==1 && self.agencyDataArray.count!=0) {
        return @"删除";
    }
    return @"";
}
 

#pragma mark - ZYSOSAddressBookCellDelegate
// 打电话
- (void)telButtonEventWithPhoneStr:(NSString *)phoneStr {
    NSLog(@"打电话");
    [self callPhoneWithStr:phoneStr];
}

#pragma mark - ZYSOSAddressBookHospitalCellDelegate
// 医院电话
- (void)hospitalTelButtonEvent {
    
    NSLog(@"医院电话");
    SosAddressBookAgencyModel *agencyModel =  self.agencyDataArray.firstObject;
    NSString *phoneStrA = [TextShowWithModelStr textShowWithNotNullStr:agencyModel.mobile];
    NSString *phoneStrB = [TextShowWithModelStr textShowWithNotNullStr:agencyModel.shopPhone];
    NSMutableArray *pArrs = [[NSMutableArray alloc]initWithCapacity:0];
    if (phoneStrA.length>0) {
        [pArrs addObject:phoneStrA];
    }
    if (phoneStrB.length>0) {
        [pArrs addObject:phoneStrB];
    }
    NSString *shopNameTitle = [NSString stringWithFormat:@"医疗机构%@的通讯录",[TextShowWithModelStr textShowWithNotNullStr:agencyModel.shopName]];
    NSString *shopNameTitleNoHavePhoneNum = [@"暂无" stringByAppendingString:shopNameTitle];
    if (pArrs.count==0) {
        Y_SVP_SHOW_ERR_MES(shopNameTitleNoHavePhoneNum);
        return;
    }
    [[AlertManager shareManager]creatAlertWithTitle:shopNameTitle message:@"点击可拨打" preferredStyle:UIAlertControllerStyleActionSheet cancelTitle:@"取消" otherTitleArr:pArrs];
    [[AlertManager shareManager] showWithViewController:self IndexBlock:^(NSInteger index) {
        if ( index== AlertManagerCancelIndex) {
            NSLog(@"取消按钮");
        }else{
            [self callPhoneWithStr:pArrs[index]];
        }
    }];


}
 
- (void)callPhoneWithStr:(NSString *)phoneStr{
    DLog(@"callPhoneWithStr %@",phoneStr);
    NSMutableString *callStr=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneStr];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callStr] options:@{} completionHandler:nil];

}
// 更换医院
- (void)changeHospitalButtonEvent {
    
    NSLog(@"更换其他医院");
    ZYSOSSalvageServiceVC *vc = [[ZYSOSSalvageServiceVC alloc] init];
    vc.isEditType = YES;
    vc.saveNowFamilyModel = self.saveNowFamilyModel;
    vc.thisOldArchiveModel = self.agencyDataArray.firstObject;
    [self pushVc:vc];
}

#pragma mark - ZYSOSAddressBookAddHospitalCellDelegate
// 添加医院
- (void)addHospitalButtonEvent {
    NSLog(@"添加医院");
    ZYSOSSalvageServiceVC *vc = [[ZYSOSSalvageServiceVC alloc] init];
    vc.saveNowFamilyModel = self.saveNowFamilyModel;
    [self pushVc:vc];
}

#pragma mark - ZYSOSAddressBookBottomViewDelegate
// 添加联系人
- (void)addContactButtonEvent {
    if (self.fmilelyDataArray.count>=3) {
        Y_SVP_SHOW_INFO_MES(@"联系人最大添加数量为3。");
        return;
    }
    NSLog(@"添加联系人");
    ZYSOSAddSalvorVC *vc = [[ZYSOSAddSalvorVC alloc] init];
    vc.saveNowFamilyModel = self.saveNowFamilyModel;
    [self pushVc:vc];
}

@end
