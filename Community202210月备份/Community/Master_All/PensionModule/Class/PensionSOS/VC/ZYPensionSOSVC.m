//
//  ZYPensionSOSVC.m
//  Community
//
//  Created by ZY on 2021/11/16.
//

#import "ZYPensionSOSVC.h"
#import "ZYSOSAddressBookVC.h"
#import "PensionMapVC.h"
#import "AllMapNavigatioManger.h"

#import "ZYPensionSOSTopView.h"
#import "ZYPensionSOSMapCell.h"
#import "ZYPensionSOSContentCell.h"
 
#import "PersionSosData.h"
#import "ZYFamilyArchiveModel.h"
#import "SosAddressFindWayGetModel.h"

#import "PensionSOSEmergencyCallTableViewCell.h"
static NSString * const pensionSOSEmergencyCallTableViewCell_Identifier = @"PensionSOSEmergencyCallTableViewCell";
#import "PersionDestinationAddressTableViewCell.h"
static NSString * const persionDestinationAddressTableViewCell_Identifier = @"PersionDestinationAddressTableViewCell";


static NSString * const pensionSOSMapCellID = @"ZYPensionSOSMapCell";
static NSString * const pensionSOSContentCellID = @"ZYPensionSOSContentCell";
#define kPensionSOSTopViewHeight 40
#define kPensionSOSMapCellHeight 240
#define kPensionSOSContentCellHeight 350
#define kPensionNomalCellHeight (120)
@interface ZYPensionSOSVC ()  <UITableViewDataSource, UITableViewDelegate, ZYPensionSOSMapCellDelegate, ZYPensionSOSContentCellDelegate,PensionSOSVcSubTableViewCellDeleagate>

@property (nonatomic, strong) ZYPensionSOSTopView *topView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYFamilyArchiveModel *saveNowFamilyModel;

@property (nonatomic, strong) NSMutableArray *saveFamilsArr;
@property (nonatomic, strong) SosAddressFindWayGetModel *saveFindWayAddressInfoModel;
@property (nonatomic, assign) BOOL saveAddressBookHaveInfoBool;

@end

@implementation ZYPensionSOSVC
- (NSMutableArray *)saveFamilsArr{
    if (!_saveFamilsArr) {
        _saveFamilsArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _saveFamilsArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"SOS";
    [self setUI];
    [self customTableView];
    [self initData];
    [self addRefresh];
    [self addNotice];
}
- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(NoticeName_SosFindWayAddressInfoChanged);
    Y_NSNotificationCenter_RemoveNotice_Name(NoticeName_SosAddressUpData);
}

- (void)addNotice{
    Y_NSNotificationCenter_Creat_NameAction(NoticeName_SosFindWayAddressInfoChanged, initSosAddressData);//内层的目的地数据更改时 本页的到的更新
    Y_NSNotificationCenter_Creat_NameAction(NoticeName_SosAddressUpData, initSosAddressData);//内层的通讯录数据更改时 本页的到的更新

}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    self.tableView.mj_header = headeerRefresh;
}
- (void)initData{
    
    [self initUserAndFimilyList];
    
    [self initSosAddressData];//地址信息
    

}
- (void)initUserAndFimilyList{
    WEAKSELF
    //查询当前自己信息+家人信息（家人信息暂时没用）
    [PersionSosData getFamileWithBlock:^(NSArray * _Nonnull arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            NSArray *getFamileModelArr = [NSArray yy_modelArrayWithClass:[ZYFamilyArchiveModel class] json:arr];
            weakSelf.saveFamilsArr = [NSMutableArray arrayWithArray:getFamileModelArr];
            if (weakSelf.saveFamilsArr.count>0) {
                //
                for (int i = 0; i < weakSelf.saveFamilsArr.count ; i++) {
                    
                    ZYFamilyArchiveModel *model =   weakSelf.saveFamilsArr[i];
                    if (model.oneself) {//自己

                        weakSelf.saveNowFamilyModel = model;
                        NSLog(@"自己的id== %@",weakSelf.saveNowFamilyModel.ID);
                        [weakSelf initAddresBookData];//通讯录信息
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            weakSelf.topView.nameLabel.text = [TextShowWithModelStr textShowWithModelStr: model.name ];
                            [weakSelf.topView.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr:model.avatarUrl] placeholderImage:[UIImage imageNamed:@"jk1"]];
                        });
                        
                    }
                }
                
                
            }
        }
    }];
}
- (void)initSosAddressData{
    WEAKSELF
    //查询sos找路的终点信息
    [PersionSosData sosfindTheWayWithGetAnAddressInfowithBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            NSLog(@"查询sos找路的终点信息 == %@",dic);
            weakSelf.saveFindWayAddressInfoModel =  [SosAddressFindWayGetModel mj_objectWithKeyValues:dic];
            NSLog(@"查询sos找路的终点信息 == %@  %@ %@",[TextShowWithModelStr textShowWithNotNullStr:weakSelf.saveFindWayAddressInfoModel.address],self.saveFindWayAddressInfoModel.lat,self.saveFindWayAddressInfoModel.lon);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}
- (void)initAddresBookData{
    WEAKSELF
    [PersionSosData getFamilysAndAgencysListOfNowFamilyId:self.saveNowFamilyModel.ID WithBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            
            if (isNil(dic)) {
                weakSelf.saveAddressBookHaveInfoBool = NO;
            }else{
                NSArray *keys = [dic allKeys];
                if ([keys containsObject:kFamilyListKey]) {
                    if (isNotNil([dic objectForKey:kFamilyListKey])) {
                        NSArray *familyArr = [[NSArray alloc]initWithArray:[dic objectForKey:kFamilyListKey]];
                        if (familyArr.count > 0) {
                            weakSelf.saveAddressBookHaveInfoBool = YES;
                        }
                    }
                }
                if ([keys containsObject:kAgencyOneObjKey]) {//机构数据 非数组 是字典
                    if (isNotNil([dic objectForKey:kAgencyOneObjKey])) {
                        NSArray *agencyArr =  [NSArray arrayWithObject:[dic objectForKey:kAgencyOneObjKey]];
                        if (agencyArr.count > 0) {
                            weakSelf.saveAddressBookHaveInfoBool = YES;
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }
        }
    }];
   
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarStyleWithSOSBoldTextColor];
}

- (void)setUI {
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topView.superview);
        make.height.offset(kPensionSOSTopViewHeight);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.right.bottom.equalTo(_topView.superview);
    }];
}

#pragma mark - 懒加载
- (ZYPensionSOSTopView *)topView {
    if (!_topView) {
        _topView = [[NSBundle mainBundle] loadNibNamed:@"ZYPensionSOSTopView" owner:nil options:nil].lastObject;
    }
    
    return _topView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
    }
    
    return _tableView;
}

#pragma mark - 定制tableView
- (void)customTableView {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:pensionSOSMapCellID bundle:nil] forCellReuseIdentifier:pensionSOSMapCellID];
    [self.tableView registerNib:[UINib nibWithNibName:pensionSOSContentCellID bundle:nil] forCellReuseIdentifier:pensionSOSContentCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
        return kPensionSOSMapCellHeight;
    }else if (indexPath.row == 1) {
       
        return kPensionNomalCellHeight;
    }else{
        if (self.saveFindWayAddressInfoModel.address.length>0) {
            return   ([Tool getTextHeightWhenHaveWidthFloatNum:(Screen_W*0.8) withTextStr:[TextShowWithModelStr textShowWithModelStr:self.saveFindWayAddressInfoModel.address] withFont:[UIFont systemFontOfSize:15]] + 50+30 + 15);
        }
        return kPensionNomalCellHeight;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ZYPensionSOSMapCell *cell = [tableView dequeueReusableCellWithIdentifier:pensionSOSMapCellID forIndexPath:indexPath];
        cell.delegate = self;
        
        return cell;
    }else if (indexPath.row == 1) {
        /**
         弃用
         ZYPensionSOSContentCell *cell = [tableView dequeueReusableCellWithIdentifier:pensionSOSContentCellID forIndexPath:indexPath];
         cell.delegate = self;
         */
        PensionSOSEmergencyCallTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:pensionSOSEmergencyCallTableViewCell_Identifier];
        if (!cell) {
            cell = [[PensionSOSEmergencyCallTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: pensionSOSEmergencyCallTableViewCell_Identifier];
        }
        [cell showEmergencyCallWithHaveInfoBool:self.saveAddressBookHaveInfoBool];
        cell.delegate = self;
        return cell;
    }else{
        PersionDestinationAddressTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:persionDestinationAddressTableViewCell_Identifier];
        if (!cell) {
            cell = [[PersionDestinationAddressTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: persionDestinationAddressTableViewCell_Identifier];
        }
        [cell showFindWayStr: [TextShowWithModelStr textShowWithNotNullStr:self.saveFindWayAddressInfoModel.address] withHaveLatLongiInfoBool: (self.saveFindWayAddressInfoModel.address >0  ? YES :NO) ];
        cell.delegate = self;
         return cell;
        
    }
    
    return nil;
}
#pragma mark ==
- (void)touchCellSubBtnAction:(UIButton *)sender{
    switch (sender.tag) {
        case Tag_PensionSOSMainCellSubBtn_AddPhoneBook:
        {
            [self addressBookButtonEvent];
        }
            break;
        case Tag_PensionSOSMainCellSubBtn_EditPhoneBook:
        {
            [self addressBookButtonEvent];
        }
            break;
        case Tag_PensionSOSMainCellSubBtn_EmergencyCall:
        {
            [self urgencyButtonEvent];
        }
            break;
            
        case Tag_PensionSOSMainCellSubBtn_AddAddressInfo:
        {
            NSLog(@"新增目的地 PensionMapVC");
            PensionMapVC *vc = [[PensionMapVC alloc]init];
            [self pushVc:vc];
        }
            break;
        case Tag_PensionSOSMainCellSubBtn_EditAddressInfo:
        {
            NSLog(@"更改目的地 PensionMapVC");
            PensionMapVC *vc = [[PensionMapVC alloc]init];
            [self pushVc:vc];
        }
            break;
        case Tag_PensionSOSMainCellSubBtn_GoAddress:
        {
            [self findWayButtonEvent];
            NSLog(@"导航");
            
        }
            break;
            
            
        default:
            break;
    }
}

#pragma mark - ZYPensionSOSMapCellDelegate
// 语音
- (void)voiceButtonEvent {
    
    NSLog(@"语音");
}

#pragma mark - ZYPensionSOSContentCellDelegate
// 紧急呼救
- (void)urgencyButtonEvent {
    
    NSLog(@"紧急呼救");
    [PersionSosData sosOfNowFamilyId:self.saveNowFamilyModel.ID withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            Y_SVP_SHOW_SUCCESS_MES(@"紧急呼救成功!");
        }
    }];
}

// 我要找路
- (void)findWayButtonEvent {
    
    NSLog(@"我要找路");
 
    [AllMapNavigatioManger gotoAddressWithLat:[self.saveFindWayAddressInfoModel.lat doubleValue] lon:[self.saveFindWayAddressInfoModel.lon doubleValue] title:[TextShowWithModelStr textShowWithNotNullStr:self.saveFindWayAddressInfoModel.address] andPresntVC:self];

}

// sos通讯录
- (void)addressBookButtonEvent {
    
    NSLog(@"sos通讯录");
    ZYSOSAddressBookVC *vc = [[ZYSOSAddressBookVC alloc] init];
    vc.saveNowFamilyModel = self.saveNowFamilyModel;
    [self pushVc:vc];
}

@end
