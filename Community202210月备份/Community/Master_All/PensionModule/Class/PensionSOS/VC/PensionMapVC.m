//
//  ZYPensionMapVC.m
//  Community
//
//  Created by 余莹 on 2021/12/1.
//非展示固定某个位置 而是（中心点固定 移动地图 用点获取当前中心view的经纬度｜搜索文本 得到搜索到的列表 取一个位置的经纬度） 上传经纬度
//地图可移动 点非固定值 手势后更新点所对应的相关位置信息

#import "PensionMapVC.h"
#import "PensionMapAllView.h"

@interface PensionMapVC ()
@property (nonatomic,strong) PensionMapAllView *mapAllView;
@property (nonatomic,strong) NSMutableArray *chooseOkAddressArr;
@end

@implementation PensionMapVC
 
- (NSMutableArray *)chooseOkAddressArr{
    if (!_chooseOkAddressArr) {
        _chooseOkAddressArr = [[NSMutableArray alloc]init];
    }
    return _chooseOkAddressArr;
}
- (PensionMapAllView *)mapAllView{
    if (!_mapAllView) {
        _mapAllView = [[PensionMapAllView alloc]init];
     }
    return _mapAllView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加导航信息";
    [self initView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigationBarStyleWithSOSColor];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initData];
}

- (void)initView{
    [self.view addSubview:self.mapAllView];
    [_mapAllView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_mapAllView.superview);
    }];
    WEAKSELF
    _mapAllView.touchBtoomBtnActionBlock = ^(NSArray * _Nonnull arr) {
        if (arr.count>=3) {
            weakSelf.chooseOkAddressArr = [NSMutableArray arrayWithArray:arr];
            [weakSelf goToChooseAction];
        }
    };
}
- (void)initData{
    [self initShowUserAddress];
}

- (void)initShowUserAddress{
    //初始展示经纬度和文本
    WEAKSELF
    __block NSString *willSnedAddressStr = @"";
    __block double lati = 29.0;
    __block double longi = 106.0;
    [ZYPositioningManager startPositioningWithLocationCompletion:^(ZYPositioningModel * _Nullable model, NSError * _Nullable error) {
        if (!error) {
            NSString *addressStr = [NSString stringWithFormat:@"%@%@%@%@ %@",model.locality,model.subLocality,model.thoroughfare,model.thoroughfare,model.name];
            lati = model.latitude;
            longi = model.longitude;
            if (addressStr.length<=0) {
                [ZYLocationInfoTool getLocatonInfoWithLat:model.latitude AndLon:model.longitude LocatonInfoBlock:^(NSString * _Nonnull locationStr) {
                    willSnedAddressStr = locationStr;
                    [weakSelf sendAddressWithLat:lati withLong:longi withShowAddressStr:willSnedAddressStr];
                }];
            }else{
                willSnedAddressStr = addressStr;
                [weakSelf sendAddressWithLat:lati withLong:longi withShowAddressStr:willSnedAddressStr];
            }
          
        }else{
            Y_SVP_SHOW_ERR_MES(@"当前");
        }
    }];
}
- (void)sendAddressWithLat:(double)lati withLong:(double)longi withShowAddressStr:(NSString *)willShowAddressStr{
    [self.mapAllView initShowAddressWithLat:lati withLong:longi withShowAddressStr:willShowAddressStr];
}

- (void)goToChooseAction{
    //上传经纬度
    NSLog(@"上传经纬度  %@ %@ 展示的地址文本 %@",self.chooseOkAddressArr.firstObject,self.chooseOkAddressArr[1],self.chooseOkAddressArr.lastObject);
    NSString *titleStr = @"确定添加的终点信息";
    NSString *messStr = [NSString stringWithFormat:@"%@ 经度:%@ 纬度:%@",self.chooseOkAddressArr.lastObject,self.chooseOkAddressArr.firstObject,self.chooseOkAddressArr[1]];
    AlertManager *alert = [[AlertManager shareManager] creatAlertWithTitle:titleStr message:messStr preferredStyle:UIAlertControllerStyleAlert cancelTitle:@"取消" otherTitleArr:@[@"添加"].mutableCopy];
    [alert showWithViewController:self IndexBlock:^(NSInteger index) {
        if (index == AlertManagerCancelIndex) {
            NSLog(@"取消按钮");
        }else{
            [self upAddressData];
        }
    }];
}
- (void)upAddressData{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:[self.chooseOkAddressArr.firstObject numberValue] forKey:@"lat"];
    [parms setValue:[self.chooseOkAddressArr[1] numberValue] forKey:@"lon"];
    [parms setValue:self.chooseOkAddressArr.lastObject forKey:@"address"];
    WEAKSELF
    [PersionSosData  sosSaveAnNewDestinationAddressWithParms:parms withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            Y_SVP_SHOW_SUCCESS_MES(@"终点信息已成功添加！");
            Y_NSNotificationCenter_PostNotice_NilObject_Name(NoticeName_SosFindWayAddressInfoChanged);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf popVC];
            });
        }
    }];

}
@end
