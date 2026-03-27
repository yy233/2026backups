//
//  CommunityManagementMainVC.m
//  Community
//
//  Created by 余莹 on 2020/11/16.
//

#import "CommunityManagementMainVC.h"
#import "ZYBannerDetailVc.h"
#import "WebSocketTestVc.h"
#import "ZYChatRootTabBarVc.h"
#import "ScanHelper.h"
#import "RentMainListVC.h"
 
 
// 投诉意见
#import "ZYComplaintsOpinionVC.h"
// 活动报名
#import "ZYActivityApplyVC.h"
// 社区集市
#import "ZYCommunityFairVC.h"
// 业主投票
#import "ZYOwnersVoteVC.h"
// 人脸上传
#import "ZYUploadFaceVC.h"
// 租赁签约详情
#import "ZYSigningDetailVC.h"
 
#import "CommunityManagementMainVcLate.h"


//0816合并end
 

@interface CommunityManagementMainVC () <UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,CenterMenuViewDelegate,SGAdvertScrollViewDelegate,AddressBookViewDelegate,MainTableViewPersionAndMedicalTableViewCellDelegate,ShoppingViewDelegate,MainConvenienceSeriveViewDelegate,MainCellRecommendedServiceHourseEstateDelegate,BasePopTableViewChooseDelegate,PopViewWithGoToRealCertificationDelegate,PopViewWithOtherFunctionDelegate,IssuLastAddressCellSubBasePopViewDelegate>
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) UIButton *cityItem;

@end

@implementation CommunityManagementMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view.layer setOpaque:NO];
    self.view.opaque = NO;
    [self initNav];//导航栏初始化
    [self initView];

    [self.view.layer setOpaque:NO];
    self.view.opaque = NO;
    
    [self initShareUserAndCommunityInfo];//取出数据or初始化modelsave
    if ([ShareUserInfo sharedUserInfo].commuityInfo.ID==0) {
        [ShareUserInfo sharedUserInfo].commuityInfo.name = @"暂未认证房屋";
        [ShareUserInfo sharedUserInfo].commuityInfo.ID = 1;//默认值使主页有数据
    }
    [self initNav];//导航栏初始化
    [self initView];
    [self initData];//默认值刷的主页数据
    
    // 定位处理
    [self positioningHandle];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setupNavigationBarTransparentStyle];//主页 透明导航
    dispatch_async(dispatch_get_main_queue(), ^{
        self.backImgView.image = [ThemeManager shareManager].mainViewLayerContentsImg;
    });
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setupNavigationBarStyleWithMainColor];
}

- (void)themeIsChange:(NSNotification*)notice{
    NSLog(@"-------themeIsChange----");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mainTableView reloadData];
        [self.tableViewHeaderView setSearchFieldColorAndCornerRadius];
    });
   
}

// 定位处理
- (void)positioningHandle {
    
    // 获取定位信息
    WEAKSELF
    [ZYPositioningManager startPositioningWithLocationCompletion:^(ZYPositioningModel * _Nullable model, NSError * _Nullable error) {
        if (model) {
            // 持久化
            [[ShareUserInfo sharedUserInfo] saveDefaultsPositioningInfo:model];
        }else {
            [[ShareUserInfo sharedUserInfo] getDefaultsPositioningInfo];
            if (![ShareUserInfo sharedUserInfo].positioningModel) {
                // 定位失败给一个默认地址
                ZYPositioningModel *positioningModel = [[ZYPositioningModel alloc] init];
                positioningModel.latitude = 29.606;
                positioningModel.longitude = 106.55;
                positioningModel.locality = @"重庆市";
                // 持久化
                [[ShareUserInfo sharedUserInfo] saveDefaultsPositioningInfo:positioningModel];
            }
            
            if (error) {
                if ([error code] == kCLErrorDenied) {
                    NSLog(@"定位访问被拒绝");
                }else if ([error code] == kCLErrorLocationUnknown) {
                    NSLog(@"无法获取位置信息");
                }else {
                    NSLog(@"定位失败error:%@", error.description);
                }
            }
        }
        
        [weakSelf useLocAndLatToGetCommunityInfo];// 已有的小区or经纬度获取就近小区 并显示文本 再获取小区相关数据
    }];
}

//取出数据+初始化model //初始化用户信息和小区信息model
- (void)initShareUserAndCommunityInfo{
    //userinfo
    [[ShareUserInfo sharedUserInfo] getDefaultsLoginUserInfo];
    if (isNil([ShareUserInfo sharedUserInfo].userInfo)) {
        UserModel *userInfo = [[UserModel alloc]init];
        [ShareUserInfo sharedUserInfo].userInfo = userInfo;
    }else{
        NSLog(@"initShareUserAndCommunityInfo  have userInfo");
    }
    //小区数据
    [[ShareUserInfo sharedUserInfo] getDefaultsCityCommnuit];
    if (isNil([ShareUserInfo sharedUserInfo].commuityInfo)) {
        CommunityModel *communityInfo = [[CommunityModel alloc]init];
        if ([IsLoginTool share].save_Login_Type==IS_Login_Nomal) {
            communityInfo.ID = 0;
            communityInfo.areaId = 0;
        }else{
            communityInfo.name = @"暂未认证房屋";
            communityInfo.ID = 1;
        }
      
        [ShareUserInfo sharedUserInfo].commuityInfo = communityInfo;
    }else{
        NSLog(@"initShareUserAndCommunityInfo  have commuityInfo");
    }
    
}
- (void)useLocAndLatToGetCommunityInfo{//经纬度最近小区
    
    Y_SVP_SHOW_MES_IsLoading_15Delay
    //存储信息没有有小区 获取当前最近的小区
    if ([ShareUserInfo sharedUserInfo].commuityInfo.name.length <= 0) {//当前没有小区的情况下
        
//        WEAKSELF
//        [PositionViewModel getCommunityInfoWithBlock:^(CommunityModel * model) {//经纬度获取model
//            STRONGSELF
//            Y_SVP_DISMISS
//            if (model.name==nil) {//空地址
//                NSLog(@"空地址小区");
////                [ShareUserInfo sharedUserInfo].commuityInfo.id=1;//test
//                [ShareUserInfo sharedUserInfo].commuityInfo.id=1;//游客账号登录
//                dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                    [strongSelf initData];//主页数据
//                });
//            }else{
//                [[ShareUserInfo sharedUserInfo] saveDefaultsCityCommnuitInfo:model];//存储
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [strongSelf.cityItem setTitle:[NSString stringWithFormat:@"%@",model.name] forState:UIControlStateNormal];
//                    CGSize buttonTitleLabelSize = [[NSString stringWithFormat:@"%@",model.name] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}]; //文本尺寸
//                    strongSelf.cityItem.frame = CGRectMake(0,0,30 + buttonTitleLabelSize.width+20,24);
//                    [strongSelf.cityItem layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:10];
//                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                        [strongSelf initData];//主页数据
//                    });
//
//                });
//            }
//        }];
        
    }else{ //登录信息有小区
        Y_SVP_DISMISS
        //name 小区名 字段待加 houseid待加 小区id==id已加
        //处理top btn
        [self useShareCommuityInfoModelTORefreshData];
        
    }
    
    WEAKSELF
    [[ShareUserInfo sharedUserInfo] getDefaultsPositioningInfo];
    [PositionViewModel getNewCommunityInfoWithLon:[ShareUserInfo sharedUserInfo].positioningModel.longitude AndLat:[ShareUserInfo sharedUserInfo].positioningModel.latitude WithModelBlock:^(CommunityModel * _Nonnull model) {
        STRONGSELF
        Y_SVP_DISMISS
        if (model.name==nil || [model.name isEqualToString:@"暂未认证房屋"]) {//空地址
            [ShareUserInfo sharedUserInfo].commuityInfo.name = @"暂未认证房屋";
            NSLog(@"空地址小区");
            [ShareUserInfo sharedUserInfo].commuityInfo.ID=1;//游客账号登录
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [strongSelf initData];//主页数据
            });
        }else{
            [[ShareUserInfo sharedUserInfo] saveDefaultsCityCommnuitInfo:model];//存储
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.cityItem setTitle:[NSString stringWithFormat:@"%@",model.name] forState:UIControlStateNormal];
                CGSize buttonTitleLabelSize = [[NSString stringWithFormat:@"%@",model.name] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}]; //文本尺寸
                strongSelf.cityItem.frame = CGRectMake(0,0,30 + buttonTitleLabelSize.width+20,24);
                [strongSelf.cityItem layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:10];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [strongSelf initData];//主页数据
                });
               
            });
        }
    }];
}
- (void)useShareCommuityInfoModelTORefreshData{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.cityItem setTitle:[NSString stringWithFormat:@"%@",[ShareUserInfo sharedUserInfo].commuityInfo.name] forState:UIControlStateNormal];
        CGSize buttonTitleLabelSize = [[NSString stringWithFormat:@"%@",[ShareUserInfo sharedUserInfo].commuityInfo.name] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}]; //文
        self.cityItem.frame = CGRectMake(0,0,30 + buttonTitleLabelSize.width+20,24);//间隔20
        [self.cityItem layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:10];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self initData];//主页数据
        });
        
    });
}
#pragma mark == nav action
#pragma mark == 小区切换
- (void)cityChooseAction{
    if ([IsLoginTool share].save_Login_Type==IS_Login_Tourists) {
        return;//游客不响应点击小区切换事件
    }
    //非游客
    Y_SVP_SHOW_MES_IsLoading_15Delay
    [UserHouseOrCommunityListModel getUerAllCommunityListWithBlock:^(NSArray * arr, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            DLog(@" \n %@",arr);
            if (arr.count<=1) {
                Y_SVP_SHOW_INFO_MES(@"暂无可切换的小区");
                return;//不做切换
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.popViewWithChangeCommunity showInViewWithPopType:IssuLastAddressCellSubBasePopView_Type_Community withListArray:arr.mutableCopy];
            });
        }
    }];
}
//小区切换
- (void)okBtnWithChooseListCellWithPopType:(IssuLastAddressCellSubBasePopView_Type)type withCellData:(NSDictionary *)dic{
    NSInteger communityId = [[dic allKeys]containsObject:@"id"] ? [[dic objectForKey:@"id"] integerValue] :1;
    NSString *communityName = [[dic allKeys]containsObject:@"name"] ? [dic objectForKey:@"name"] : @"暂无认证小区";
    [ShareUserInfo sharedUserInfo].commuityInfo.ID = communityId;
    [ShareUserInfo sharedUserInfo].commuityInfo.name = communityName;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self useShareCommuityInfoModelTORefreshData];//主页顶部UI+数据
    });
}


- (void)infoItemAction{
    //游客和未绑定手机 则总消息按钮不可点击
    if ([self shouldShowLoginVcOrBindVcBool]) {
        return;
    }
    
    TopInformationVC *vc = [[TopInformationVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}
- (void)scanningItemAction{
    NSLog(@"扫描");
//    [self showPopViewWithMoreServiceWillBeOpen];
    
//    __weak typeof(self) weakSelf = self;
//    ScanQRViewController *vc = [[ScanHelper shareInstance] ScanVCWithStyle:ZhiFuBaoStyle qrResultCallBack:^(id result) {
//        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
//        NSLog(@"result=%@", result);
//    }];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"活动报名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 活动报名
        ZYActivityApplyVC *vc = [[ZYActivityApplyVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf pushVc:vc];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"投诉建议" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 投诉建议
        ZYComplaintsOpinionVC *vc = [[ZYComplaintsOpinionVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf pushVc:vc];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"社区集市" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 社区集市
        ZYCommunityFairVC *vc = [[ZYCommunityFairVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf pushVc:vc];
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"业主投票" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 业主投票
        ZYOwnersVoteVC *vc = [[ZYOwnersVoteVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf pushVc:vc];
    }];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"人脸上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 人脸上传
        ZYUploadFaceVC *vc = [[ZYUploadFaceVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf pushVc:vc];
    }];
    UIAlertAction *action6 = [UIAlertAction actionWithTitle:@"租赁签约" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf handleSignDetailPush];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [alertVC addAction:action3];
    [alertVC addAction:action4];
    [alertVC addAction:action5];
    [alertVC addAction:action6];
    [alertVC addAction:cancleAction];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)handleSignDetailPush {
    
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"租客未认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        ZYSigningDetailVC *vc = [[ZYSigningDetailVC alloc] init];
//        vc.typeStr = @"0";
//        vc.hidesBottomBarWhenPushed = YES;
//        [self pushVc:vc];
//    }];
//    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"租客发起签约" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        ZYSigningDetailVC *vc = [[ZYSigningDetailVC alloc] init];
//        vc.typeStr = @"1";
//        vc.hidesBottomBarWhenPushed = YES;
//        [self pushVc:vc];
//    }];
//    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"租客取消签约" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        ZYSigningDetailVC *vc = [[ZYSigningDetailVC alloc] init];
//        vc.typeStr = @"2";
//        vc.hidesBottomBarWhenPushed = YES;
//        [self pushVc:vc];
//    }];
//    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"租客重新发起签约" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        ZYSigningDetailVC *vc = [[ZYSigningDetailVC alloc] init];
//        vc.typeStr = @"3";
//        vc.hidesBottomBarWhenPushed = YES;
//        [self pushVc:vc];
//    }];
//    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"租客再次申请" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        ZYSigningDetailVC *vc = [[ZYSigningDetailVC alloc] init];
//        vc.typeStr = @"4";
//        vc.hidesBottomBarWhenPushed = YES;
//        [self pushVc:vc];
//    }];
//    UIAlertAction *action6 = [UIAlertAction actionWithTitle:@"租客查看合同" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        ZYSigningDetailVC *vc = [[ZYSigningDetailVC alloc] init];
//        vc.typeStr = @"5";
//        vc.hidesBottomBarWhenPushed = YES;
//        [self pushVc:vc];
//    }];
//    UIAlertAction *action7 = [UIAlertAction actionWithTitle:@"房东处理签约申请" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        ZYSigningDetailVC *vc = [[ZYSigningDetailVC alloc] init];
//        vc.typeStr = @"6";
//        vc.hidesBottomBarWhenPushed = YES;
//        [self pushVc:vc];
//    }];
//    UIAlertAction *action8 = [UIAlertAction actionWithTitle:@"房东拟定合同" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        ZYSigningDetailVC *vc = [[ZYSigningDetailVC alloc] init];
//        vc.typeStr = @"7";
//        vc.hidesBottomBarWhenPushed = YES;
//        [self pushVc:vc];
//    }];
//    UIAlertAction *action9 = [UIAlertAction actionWithTitle:@"房东拒绝申请" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        ZYSigningDetailVC *vc = [[ZYSigningDetailVC alloc] init];
//        vc.typeStr = @"8";
//        vc.hidesBottomBarWhenPushed = YES;
//        [self pushVc:vc];
//    }];
//    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    [alertVC addAction:action1];
//    [alertVC addAction:action2];
//    [alertVC addAction:action3];
//    [alertVC addAction:action4];
//    [alertVC addAction:action5];
//    [alertVC addAction:action6];
//    [alertVC addAction:action7];
//    [alertVC addAction:action8];
//    [alertVC addAction:action9];
//    [alertVC addAction:cancleAction];
//    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark ==== 切换房屋后 小区变了 数据刷新
- (void)noticeWithCommnityIdIsChangeToRefreshMainVcInfo{
    NSLog(@"notice CommnityIdIsChangeTo RefreshMainVcInfo");
    [self useShareCommuityInfoModelTORefreshData];
}
#pragma mark ==== Refresh  action
- (void)headerInitData{
    NSLog(@"------------headeerRefres------------");
    [self useLocAndLatToGetCommunityInfo];//    [self initData];
    [self.mainTableView.mj_header endRefreshing];
}
#pragma mark ==== action
- (void)initData{
    [self upJiGuangRegId];//极光
    //
    [self topScrollViewBannerListData];
    [self centerOneMenuListData];
    [self centerScrollViewUrgenMessageListData];
    [self centerAddressBookData];
    [self centerShoppingData];
    [self bottomNewsData];
    [self weatherData];
    [self rentHouseRightListData];
}
//
- (void)upJiGuangRegId{
    NSString *url = [NSString stringWithFormat:@"%@?regId=%@",URL_PUT_JG_regId,JiGuang_RegId];
    [[ToolOfNetWork sharedTools]YrequestPutURLNoMainQueue:url withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        
    }];
}

- (void)topScrollViewBannerListData{
    WEAKSELF
    [MainBannerListViewModel getTopBannerListDataWithListBlock:^(NSArray * arr) {
        STRONGSELF
        strongSelf.topSourceArr = [NSMutableArray arrayWithArray:[TableViewTopAndCenterBannerCellModel mj_objectArrayWithKeyValuesArray:arr]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.mainTableView reloadData];
        });
    }];
   
}
- (void)centerOneMenuListData{
    WEAKSELF
    [MainCenterOneMenuListViewModel getCenterOneMenuListArrWithMenuBlock:^(NSMutableArray * arr) {
        STRONGSELF
        strongSelf.centerMenuSourceArr =  [NSMutableArray arrayWithArray:[MainCenterCollectionViewCellModel mj_objectArrayWithKeyValuesArray:arr]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.mainTableView reloadData];
        });
    }];
}
- (void)centerScrollViewUrgenMessageListData{
    WEAKSELF
    [MainUrgentMessageListViewModel getCenterUrgentMessageListDataWithListBlock:^(NSArray * arr,BOOL success) {
        STRONGSELF
        if (success) {
            strongSelf.centeradvertScrollviewSourceArr = [NSMutableArray arrayWithArray:[TableViewTopAndCenterBannerCellModel mj_objectArrayWithKeyValuesArray:arr]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.mainTableView reloadData];
            });
        }
    }];
}
- (void)centerAddressBookData{
    WEAKSELF
    [MainAddressBookViewModel getAddressBookListArrWithBlock:^(NSMutableArray * arr) {
        STRONGSELF
        strongSelf.centerAddressBookSourceArr  = [NSMutableArray arrayWithArray:[MainCenterCollectionViewAddressBookCellModel mj_objectArrayWithKeyValuesArray:arr]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.mainTableView reloadData];
        });
    }];
    
}

- (void)centerShoppingData{
    [self shoppingScrollData];

    MainCenterCollectionViewShoppingCellModel *model = [[MainCenterCollectionViewShoppingCellModel alloc]init];
    model.titleStr = @"限时秒杀";
    model.detailTitleStr = @"好货不断、不容错过";
    model.rightImgStr = @"Affordablelife_Timelimitedsecondkill";
    [self.centerShoppingSourceArr addObject:model];
    MainCenterCollectionViewShoppingCellModel *model1 = [[MainCenterCollectionViewShoppingCellModel alloc]init];
    model1.titleStr = @"美食榜单";
    model1.detailTitleStr = @"好货不断、不容错过";
    model1.rightImgStr = @"Affordablelife_Foodlist";
    [self.centerShoppingSourceArr addObject:model1];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mainTableView reloadData];
    });
    
}
- (void)shoppingScrollData{
    WEAKSELF
    [MainBannerListViewModel getShoppingBannerListDataWithListBlock:^(NSArray * arr) {
        STRONGSELF
        strongSelf.shoppingScrollViewArr = [NSMutableArray arrayWithArray:[TableViewTopAndCenterBannerCellModel mj_objectArrayWithKeyValuesArray:arr]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.mainTableView reloadData];
        });
    }];
}
//天气接口改成用城市名字获取
- (void)weatherData{
    WEAKSELF
    [MainWeatherCellViewModel getWeatherNowWithCityNameStr:@"" withWeatherBlock:^(NSDictionary * cityDic, NSDictionary * nowDayDic, NSMutableArray * otherDaysArr, BOOL success) {
//    [MainWeatherCellViewModel getWeatherNowWithLat:106.514787 andLon:29.622701 withWeatherBlock:^(NSDictionary * cityDic, NSDictionary * nowDayDic, NSMutableArray * otherDaysArr, BOOL success) {//lat29 long100+
        STRONGSELF
        if (success) {
            MainWeatherModel *cityM = [MainWeatherModel mj_objectWithKeyValues:cityDic];
            MainWeatherModel *nowDayM = [MainWeatherModel mj_objectWithKeyValues:nowDayDic];
            strongSelf.wearherMainDic = [[NSMutableDictionary alloc]init];
            [strongSelf.wearherMainDic setValue:[TextShowWithModelStr textShowWithModelStr:cityM.pname] forKey:@"pname"];
            [strongSelf.wearherMainDic setValue:[TextShowWithModelStr textShowWithModelStr:cityM.name] forKey:@"name"];
            [strongSelf.wearherMainDic setValue:@(nowDayM.temp) forKey:@"temp"];
            [strongSelf.wearherMainDic setValue:[TextShowWithModelStr textShowWithModelStr:nowDayM.condition] forKey:@"condition"];
            [strongSelf.wearherMainDic setValue:[TextShowWithModelStr textShowWithModelStr:nowDayM.updateDay] forKey:@"updateDay"];
            [strongSelf.wearherMainDic setValue:[TextShowWithModelStr textShowWithModelStr:nowDayM.dayOfWeek] forKey:@"dayOfWeek"];
            [strongSelf.wearherMainDic setValue:[TextShowWithModelStr textShowWithModelStr:nowDayM.tips] forKey:@"tips"];
            strongSelf.wearherRightArr = otherDaysArr;
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.mainTableView reloadData];
            });
        }
    }];
}

- (void)rentHouseRightListData{//房屋租赁右边list
    WEAKSELF
    [MainRecommendedServiceHourseEstateCellViewModel getRentServiceHourseRightNewsInfoListArr:^(NSArray * arr, BOOL success) {
        STRONGSELF
        if (success) {
            strongSelf.recommendedServiceNewsListArr = [NSMutableArray arrayWithArray:[MainRecommendedServiceHourseEstateModel mj_objectArrayWithKeyValuesArray:arr]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.mainTableView reloadData];
            });
        }
    }];
}
- (void)bottomNewsData{//社区趣事
    WEAKSELF
    self.bottomNewsPageNum = 1;
    [CommunityFunListViewModel comunityFunListInitWithListBlock:^(BOOL success, NSArray * arr, NSInteger total) {
        STRONGSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.mainTableView.mj_header endRefreshing];
        });
        if (success) {
            strongSelf.bottomNewsPageNum += 1;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (arr.count<PageSize_CommunityFunList) {
                    strongSelf.mainTableView.mj_footer.hidden = YES;
                }else{
                    strongSelf.mainTableView.mj_footer.hidden = NO;
                }
            });
            if (arr>0) {
                strongSelf.bottomNewsSourceArr = [NSMutableArray arrayWithArray:[CommunityFunModel mj_objectArrayWithKeyValuesArray:arr]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.mainTableView reloadData];
            });
        }else{
            strongSelf.bottomNewsPageNum = 1;
        }
    }];
    
}
- (void)footerLoadMoreNewsData{
    NSLog(@"------------footerRefres------------");
    [self bottmNewsDataMore];
}
- (void)bottmNewsDataMore{//社区趣事
    WEAKSELF
    [CommunityFunListViewModel  comunityFunListWithPageNum:self.bottomNewsPageNum UpdateWithListBlock:^(BOOL success, NSArray * arr, NSInteger total) {//total数据有bug 用arr。count
        STRONGSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.mainTableView.mj_footer endRefreshing];
        });
        if (success) {
            strongSelf.bottomNewsPageNum += 1;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (arr.count<PageSize_CommunityFunList) {
                    strongSelf.mainTableView.mj_footer.hidden = YES;
                }else{
                    strongSelf.mainTableView.mj_footer.hidden = NO;
                }
            });
            if (strongSelf.bottomNewsSourceArr.count>0) {
                [strongSelf.bottomNewsSourceArr addObjectsFromArray:[CommunityFunModel mj_objectArrayWithKeyValuesArray:arr]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.mainTableView reloadData];
            });
        }else{
            strongSelf.bottomNewsPageNum -= 1;
        }
    }];
    
}
#pragma mark === UI
- (void)initNav{
    
    _cityItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cityItem setImage:[UIImage imageWithColor:[UIColor blueColor]] forState:UIControlStateNormal];
    [_cityItem setImage:[UIImage imageNamed:@"Head_Positioning_night"] forState:UIControlStateNormal];
    _cityItem.titleLabel.textAlignment = NSTextAlignmentLeft;
    _cityItem.titleLabel.font = [UIFont systemFontOfSize:14];
    _cityItem.frame = CGRectMake(0 , 0, Screen_W*0.5, 24);
    [_cityItem addTarget:self action:@selector(cityChooseAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cityBarItem = [[UIBarButtonItem alloc]initWithCustomView:_cityItem];
    [self.navigationItem setLeftBarButtonItem:cityBarItem];
    
    UIButton *scanningItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanningItem setImage:[UIImage imageNamed:@"Head_Sweepit_night"] forState:UIControlStateNormal];
    scanningItem.bounds = CGRectMake(0 , 0, 24, 24);
    [scanningItem addTarget:self action:@selector(scanningItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *scanningItemBar = [[UIBarButtonItem alloc]initWithCustomView:scanningItem];
    
    UIButton *infoItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoItem setImage:[UIImage imageNamed:@"head_news_night"] forState:UIControlStateNormal];
    [infoItem setImage:[UIImage imageNamed:@"Head_News_Default_content_night"] forState:UIControlStateSelected];
//    infoItem.selected = YES;//红点的
    infoItem.bounds = CGRectMake(0 , 0, 24, 24);
    [infoItem addTarget:self action:@selector(infoItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infoItemBar = [[UIBarButtonItem alloc]initWithCustomView:infoItem];
    
 
    [self.navigationItem setRightBarButtonItems:@[infoItemBar,scanningItemBar]];
    
}
- (void)initView{
    [self.view addSubview:self.backImgView];
    [self.view addSubview:self.mainTableView];
    [self initMianBottomRightBtnView];
    [self setUI];
    [self addRefresh];
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerInitData)];
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadMoreNewsData)];
    self.mainTableView.mj_header = headeerRefresh;
    self.mainTableView.mj_footer = footerRefresh;
    self.mainTableView.mj_footer.hidden = YES;
}
- (void)setUI{
    [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backImgView.superview);
    }];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainTableView.superview.mas_top).offset(KNavBarHeight);
        make.left.equalTo(_mainTableView.superview.mas_left).offset(16);
        make.right.equalTo(_mainTableView.superview.mas_right).offset(-16);
        make.bottom.equalTo(_mainTableView.superview.mas_bottom).offset(-KTabBarHeight);
    }];
}
#pragma mark ==== topScollview 第一 主滚动视图
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (cycleScrollView.tag == MainTopCycleScrollView_TAG) {
        NSLog(@" 顶部滚动图点击了 %ld  ==== cycleScrollView ",(long)index);
        
        ZYBannerDetailVc *vc = [[ZYBannerDetailVc alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }
}
#pragma mark === 判定是否需要弹出登录vc或绑定vc
- (BOOL)shouldShowLoginVcOrBindVcBool{
    WEAKSELF
    STRONGSELF
    if ([IsLoginTool share].save_Login_Type==IS_Login_Tourists) {
        //登录view
        [[IsLoginTool share]willPresentLoginViewControllerWithLoginVCBlock:^(UINavigationController * _Nonnull navc) {
                navc.modalPresentationStyle = UIModalPresentationFullScreen;
                [strongSelf presentViewController:navc animated:YES completion:^{
                    NSLog(@"present弹出登录vc");
                }];
        }];
        return YES;
  
    } else if( [IsLoginTool share].save_Login_Type==IS_Login_UnboundPhone){
        //用三方ID绑定电话
        //苹果 绑定手机操作
        AppleLoginModel *model = [[AppleLoginModel alloc]init];
        model.thirdPlatformId = [IsLoginTool share].appleLoginSaveThridIdWillUseToBindPhone;
        //
        BindingPhoneVC *bindVc = [[BindingPhoneVC alloc]init];
        bindVc.appleUserModel = model;
        bindVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bindVc animated:YES];
        return YES;
    }
    return NO;
}

#pragma mark ==== CenterMenu ViewDelegate 菜单
- (void)centerMenuViewCollectionCellDidSelectWithItem:(NSIndexPath *)indexPath{
    if (indexPath.row != self.centerMenuSourceArr.count) {//更多按钮 需要能点击跳转
        if ([self shouldShowLoginVcOrBindVcBool]) {
            return;
        }
    }
    //更多
    if (indexPath.row == self.centerMenuSourceArr.count) {
        NSLog(@"center_menu点击了 更多");
                MoreMenuVC *moreMenuVc = [[MoreMenuVC alloc]init];
                moreMenuVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:moreMenuVc animated:YES];
    }else{
        NSLog(@" center_menu点击了 %ld  ==== CollectionCell DidSelectWithIntem",(long)indexPath.row);
        MainCenterCollectionViewCellModel *model = self.centerMenuSourceArr[indexPath.row];
        NSInteger willPushVcNum = [MoreMenuChooseVCType getMenuChooseVcWithStr:model.path];
        switch (willPushVcNum) {
            case Menu_choose_userInfoRegist://房屋认证item
            {
                //判断认证的位置 处理跳转
                Y_SVP_SHOW_MES_IsDling_15Delay(@"正在获取认证信息")
                [UserInfoRegistWillEnterWhichVcWithData goToWhichVcWithType:^(UserInfoRegistVC_GoToVC_Type goToVcType, BOOL success) {
                    Y_SVP_DISMISS
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!success) {
                            Y_SVP_SHOW_ERR_MES(@"认证数据请求失败");
                        }else{
                            
                            switch (goToVcType) {
                                case UserInfoRegistVC_GoToVC_Type_PersonInfoUnRegistered://都没认证
                                {
//                                    // 未实名认证的vc 与签章共用同一个UI
//
//                                    ElectroniNewRealNameAuthenticationCardVc *vc = [[ElectroniNewRealNameAuthenticationCardVc alloc]init];
//                                    vc.hidesBottomBarWhenPushed = YES;
//                                    [self pushVc:vc];
                                    [self notGoRealCertificationPopViewShow];
                                }
                                    break;
                                case UserInfoRegistVC_GoToVC_Type_HouseUnRegistered: //已经认证过 个人信息+ 未认证 房屋信息
                                {
                                    UserInfoRegistVC *vc = [[UserInfoRegistVC alloc]init];
                                    vc.userInfoListIsRegistered = NO;//只有人认证过+房屋没有认证过 no
                                    vc.hidesBottomBarWhenPushed = YES;
                                    [self pushVc:vc];
                                }
                                    break;
                                case UserInfoRegistVC_GoToVC_Type_Registered: //已经认证过 个人信息+房屋信息
                                {
                                   
                                    UserInfoRegistVC *vc = [[UserInfoRegistVC alloc]init];
                                    vc.userInfoListIsRegistered = YES;//已经认证过房屋 yes
                                    vc.hidesBottomBarWhenPushed = YES;
                                    [self pushVc:vc];
                                }
                                    break;
                                default:
                                    break;
                            }
                        }
                    });
                    
                }];
              
            }
                break;
            case Menu_choose_liftCost:
            {
                NSLog(@" center_menu 生活缴费");
                LifeCostVC *vc = [[LifeCostVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }
                break;
            case Menu_choose_visitorGuest:
            {
                GuestInfoRegistionVC *vc = [[GuestInfoRegistionVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }
                break;
            case Menu_choose_scan:
            {
                NSLog(@" center_menu  扫一扫");
//                [self showPopViewWithMoreServiceWillBeOpen];
                [self scanAction];
            }
                break;
            case Menu_choose_repair:
            {
                NSLog(@" center_menu  一键报修");
                HouseRepairListVC *vc = [[HouseRepairListVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }
                break;
            case Menu_choose_hotline:
            {
                NSLog(@" center_menu  服务热线");
                [self showHouLinePopV];
            }
                break;
            case Menu_choose_advice:
            {
                NSLog(@" center_menu  投诉建议");
                ComplaintsSuggestionsVC *vc = [[ComplaintsSuggestionsVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }
                break;
          
            case Menu_choose_No:
            {
                NSLog(@" center_menu  Menu_choose_No");
            }
                break;
                
            default:
                NSLog(@" center_menu  Menu_choose_No other");
                break;
        }
        
    }
    
}

#pragma mark ==   扫一扫
- (void)scanAction{
    WEAKSELF
    ScanQRViewController *vc = [[ScanHelper shareInstance] ScanVCWithStyle:qqStyle qrResultCallBack:^(id result) {
        BaseViewController *vc = [[BaseViewController alloc] init];
        vc.title = [NSString stringWithFormat:@"%@",result];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        NSLog(@"result=%@", result);
    }];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ==  更多社区服务正在逐步开放中
- (void)showPopViewWithMoreServiceWillBeOpen{
    [self.popViewMoreServiceWillOpening showInView:self.view thePopViewSubViewHeight:0 WithArray:@[].mutableCopy];
}
#pragma mark == 右下角 按钮 弹出的其他点击协议

- (void)popViewOtherFunctionSubTouchPopViewWithOtherFunction:(PopViewWithOtherFunction_Type)type{

    self.mainVcBottomRightBtn.selected = NO;
    switch (type) {
        case PopViewWithOtherFunction_Type_DisMissPopView:
        {
        }
            break;
        case PopViewWithOtherFunction_Type_forum://论坛
        {
            DLog(@"论坛");
//            [self showPopViewWithMoreServiceWillBeOpen];
            CommunityManagementMainVcLate *vc = [[CommunityManagementMainVcLate alloc]init];
            [self pushVc:vc];
        }
            break;
        case PopViewWithOtherFunction_Type_shortvideo://短视频
        {
            DLog(@"短视频");
            [self showPopViewWithMoreServiceWillBeOpen];
        }
            break;
        case PopViewWithOtherFunction_Type_chat://聊天
        {
            DLog(@"聊天");
 
            if ([self shouldShowLoginVcOrBindVcBool]) {
                return;
            }
            ZYChatRootTabBarVc *vc = [[ZYChatRootTabBarVc alloc] init];
            //设置模态视图弹出样式
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
// 
        }
            break;
        case PopViewWithOtherFunction_Type_fleaMarket://跳蚤市场
        {
            DLog(@"跳蚤市场");
            [self showPopViewWithMoreServiceWillBeOpen];

        }
            break;
            
        default:
            break;
    }
}
#pragma mark == 未实名认证的popView
- (void)notGoRealCertificationPopViewShow{
    [self.popViewGotoCertification showInView:self.view thePopViewSubViewHeight:0 WithArray:@[].mutableCopy];
}
- (void)popViewBtnActionWithGoToRealCertificationAction{
    DLog(@"去认证"); 
    ElectroniNewRealNameAuthenticationCardVc *vc = [[ElectroniNewRealNameAuthenticationCardVc alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}
#pragma mark ==== 紧急消息
- (void)advertScrollView:(SGAdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index{
    if (advertScrollView.tag == MainCenterAdvertScrollView_TAG) {
        UrgentInfoOrTopInfoDetailVC *detailVc = [[UrgentInfoOrTopInfoDetailVC alloc]init];
        TableViewTopAndCenterBannerCellModel *model =  self.centeradvertScrollviewSourceArr[index];
        detailVc.communityId =  [ShareUserInfo sharedUserInfo].commuityInfo.ID;//当前小区id
        detailVc.infoId = model.id;
        detailVc.hidesBottomBarWhenPushed = YES;
        [self pushVc:detailVc];
    }
}
//紧急消息 跳转 列表页面
- (void)urgentMoreBtnAction{
    MoreUrgentListVC *vc = [[MoreUrgentListVC alloc]init];
    vc.isTopInfoVcDetailListVc = NO;
    vc.dataSourceArr = self.centeradvertScrollviewSourceArr;//dataarr暂不需要了
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}
#pragma mark === 便民服务
//天气 暂无事件

//楼盘 租房转让
- (void)cellHourseEstateSubBtnTouchIndex:(NSInteger)index{
    NSLog(@" HourseEstateSubBtn 点击了 %ld ",(long)index);
    HouseRentVC *rentVc = [[HouseRentVC alloc]init];//正在更新的代码
//    RentMainListVC *rentVc = [[RentMainListVC alloc]init];//保留原本的代码
    if (index == MainCellRecommendedServiceHourse_Type_BusinessShop) {//转让
        rentVc.viewType = MainCellRecommendedServiceHourse_Type_BusinessShop;
    }else{//租房
        rentVc.viewType = MainCellRecommendedServiceHourse_Type_RentHouse;
    }
    rentVc.hidesBottomBarWhenPushed = YES;
    [self pushVc:rentVc];
}
//商铺false 房屋true 
- (void)cellHourseEstateSubTableViewTouchIndexPath:(NSIndexPath *)indexPath{
    MainRecommendedServiceHourseEstateModel *model = self.recommendedServiceNewsListArr[indexPath.row];
    if (model.leaseHouse) {//房屋
        HouseRentHouseDetailVc *houseDetailVc = [[HouseRentHouseDetailVc alloc]init];
        houseDetailVc.hidesBottomBarWhenPushed = YES;
        houseDetailVc.IDNum = model.id;
        [self pushVc:houseDetailVc];
    }else{
        HouseRentBuniessShopDetailVc *buinessShopDetailVc = [[HouseRentBuniessShopDetailVc alloc]init];
        buinessShopDetailVc.hidesBottomBarWhenPushed = YES;
        buinessShopDetailVc.IDNum = model.id;
        [self pushVc:buinessShopDetailVc];
    }
    
}
#pragma mark ====  养老医疗
- (void)goPersionAction{
    DLog(@"");
    PesionVC *vc = [[PesionVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}
- (void)goMedicalAction{
    DLog(@"");
    MedicalVC *vc = [[MedicalVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}

#pragma mark ==== 推荐服务convenience Serive
- (void)convenienceSeriveViewTouchIndex:(NSInteger)index{
    switch (index) {
        case 1:
            NSLog(@"家电清理");
            [self showPopViewWithMoreServiceWillBeOpen];
            break;
        case 2:
            NSLog(@"衣物清洁");
            [self showPopViewWithMoreServiceWillBeOpen];
            break;
        case 3:
            NSLog(@"上门维修");
        {
            if ([self shouldShowLoginVcOrBindVcBool]) {
                return;
            }
            HouseRepairListVC *vc = [[HouseRepairListVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self pushVc:vc];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark ==== addressBook
- (void)addressBookViewCollectionCellDidSelectWithItem:(NSIndexPath *)indexPath{//弃用vc 用popview
    NSLog(@"点击了 %ld  ==== addressBookViewCollectionCell  ",(long)indexPath.item);
    MainCenterCollectionViewAddressBookCellModel *aepartmentModel = self.centerAddressBookSourceArr[indexPath.item];//部门
    Y_SVP_SHOW_MES_IsLoading_15Delay
    [MainAddressBookViewModel getAddressBookDetailPhoneArrWithDepartmentId:aepartmentModel.ID detailPhoneblock:^(NSMutableArray * arr) {
        Y_SVP_DISMISS
        UIView *popViewSuperView =  self.view.window.rootViewController.view;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (arr.count>0) {
                [self.popViewPhoneBookList showInView:popViewSuperView thePopViewTableViewHeight:200 WithArray:arr withHeaderViewTitle:aepartmentModel.department];
            }else{
                Y_SVP_SHOW_ERR_MES(@"当前部门 暂无电话");
            }
        });
    }];
}
#pragma mark == addressBook popView Delagate
- (void)basePopViewTag:(NSInteger)tag OfSubTableViewTouchWithIndexPath:(NSIndexPath *)indexPath{
    if (tag==TAG_PopTableView_PhoneList) {
        NSLog(@"点击了 %ld  ==== addressBook popView Delagate   ",(long)indexPath.item);//不做操作 popViewPhoneBookList里直接响应打电话
        //        self.popViewPhoneDetailListDataSource  暂时不用了
    }
    
}

#pragma mark ==== shopping
- (void)shoppingViewCollectionCellDidSelectWithItem:(NSIndexPath *)indexPath{
    NSLog(@"点击了 %ld  ==== shoppingViewCollectionCell  ",(long)indexPath.item);
    [self showPopViewWithMoreServiceWillBeOpen];
}
- (void)shoppingViewCollectionCellDidSelectWithScrollViewItem:(NSInteger)index{
    NSLog(@"点击了 %ld  ==== shoppingViewCollectionCell  ScrollViewItem ",(long)index);
    [self showPopViewWithMoreServiceWillBeOpen];
}
#pragma mark === tableView interesting news cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==RowNum_LifeInterestNews){//社区趣事
        CommunityFunModel *model = self.bottomNewsSourceArr[indexPath.row];//
        CommunityFunDetialVC *detailVc = [[CommunityFunDetialVC alloc]init];
        detailVc.id = model.id;
        detailVc.hidesBottomBarWhenPushed = YES;
        [self pushVc:detailVc];
    }
}
//更多
- (void)funMoreBtnAction:(UIButton *)sender{
    CommunityFunMoreVC *vc = [[CommunityFunMoreVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}
#pragma mark ==== tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return SectionAllNum;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == RowNum_OneCell_Mene_JingJiInfo_BannerOne) {
        return 3;
    }else if(section == RowNum_BianMingFuWu){//便民生活
        return 2;
    }else if (section <= RowNum_ShopingLife && section>RowNum_BianMingFuWu && section != RowNum_PhonesAddress){
        return 1;
    }else if (section == RowNum_PhonesAddress) {
        if (self.centerAddressBookSourceArr.count > 0) {
            return 1;
        }else {
            return 0;
        }
    }else{
        return self.bottomNewsSourceArr.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == RowNum_OneCell_Mene_JingJiInfo_BannerOne) {
        return 1;
    }
    if (section == RowNum_PhonesAddress) {
        if (!self.centerAddressBookSourceArr.count) {
            return 1;
        }
    }
    return mainTableViewCell_Height_cell_HeaderView;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{  
    MainSectionHeaderViewTextLabel *headerViewTextLabel = [[MainSectionHeaderViewTextLabel alloc]initWithFrame:CGRectMake(0, 0,Screen_W-32, 20)];
    NSArray *headerTextArr = self.headerViewRightTextArr;//
    headerViewTextLabel.text = headerTextArr[section];
    if (headerTextArr.count-1==section) {
        headerViewTextLabel.userInteractionEnabled = YES;
        headerViewTextLabel.rightBtnFunCellSectionHeaderWillShow.hidden = NO;
        [headerViewTextLabel.rightBtnFunCellSectionHeaderWillShow addTarget:self action:@selector(funMoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        headerViewTextLabel.rightBtnFunCellSectionHeaderWillShow.hidden = YES;
        if (section == RowNum_PhonesAddress) {
            if (!self.centerAddressBookSourceArr.count) {
                headerViewTextLabel.text = @"";
            }
        }
    }
    
    return headerViewTextLabel;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == RowNum_OneCell_Mene_JingJiInfo_BannerOne) {
        if(indexPath.row == 0){
            return mainTableViewCell_Height_cell_centerOneFunctionView;
        }else if(indexPath.row == 1){
            return mainTableViewCell_Height_cell_centerRollingView;
        }else if (indexPath.row == 2) {
            return mainTableViewCell_Height_cell_topRollingView;
        }else{
            return mainTableViewCell_Height_cell_centerRollingView;
        }
    }else if (indexPath.section == RowNum_BianMingFuWu){//便民服务
        if(indexPath.row==0){//天气
            return mainTableViewCell_Height_cell_RecommendedServiceView_Weather;
        }else if(indexPath.row==1){//楼盘
            return mainTableViewCell_Height_cell_RecommendedServiceView_House;
        }else{
            return mainTableViewCell_Height_cell_RecommendedServiceView_House;
        }
    }else if (indexPath.section == RowNum_YangLaoYiLiao){//养老医疗
        return mainTableViewCell_Height_cell_PeisonAndMedical;
    }else if (indexPath.section == RowNum_TuiJianFuWu){
        return mainTableViewCell_Height_cell_ConvenienceServiceView;
    }else if (indexPath.section == RowNum_PhonesAddress){
        return mainTableViewCell_Height_cell_centerAddressBookView;
    }else if (indexPath.section == RowNum_ShopingLife){
        return mainTableViewCell_Height_cell_centerShoppingView;
    }else{
        return mainTableViewCell_Height_cell_centerInterestingNewsView;
    }
    return mainTableViewCell_Height_cell_centerRollingView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == RowNum_OneCell_Mene_JingJiInfo_BannerOne) {
        return [self oneSectionWithtableView:tableView cellForRowAtIndexPath:indexPath];
    }else if (indexPath.section == RowNum_BianMingFuWu){//便民生活
        return [self recommendedServiceSectionWithtableView:tableView cellForRowAtIndexPath:indexPath];
    }else if (indexPath.section == RowNum_YangLaoYiLiao){//养老医疗
        return [self yanglaoAndYiLiaoSectionWithtableView:tableView cellForRowAtIndexPath:indexPath];
    }else if (indexPath.section == RowNum_TuiJianFuWu){
        return [self convenienceServiceSectionWithtableView:tableView cellForRowAtIndexPath:indexPath];
    }else if (indexPath.section == RowNum_PhonesAddress){
        return [self addressBookSectionWithtableView:tableView cellForRowAtIndexPath:indexPath];
    }else if (indexPath.section == RowNum_ShopingLife){
        return [self shoppingSectionWithtableView:tableView cellForRowAtIndexPath:indexPath];
    }else if (indexPath.section == RowNum_LifeInterestNews){
        return [self interestingNewsSectionWithtableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
         UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainTableViewCell_Identifier];
         if (!cell) {
             cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:mainTableViewCell_Identifier];
         }
        cell.backgroundColor = [UIColor grayColor];
        return cell;
    }
}
- (UITableViewCell *)recommendedServiceSectionWithtableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {//天气
        MainTableViewRecommendedServiceWeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:mainTableViewCell_RecommendedService_Weather_Identifier];
        if (!cell || ![cell isKindOfClass:[MainTableViewRecommendedServiceWeatherCell class]]) {
            cell = [[MainTableViewRecommendedServiceWeatherCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mainTableViewCell_RecommendedService_Weather_Identifier];
        }
        [cell showCellDataSourceWithWeathOtherNowDayDic:self.wearherMainDic.mutableCopy withWeathOtherDaysDataSourceArr:self.wearherRightArr];
        return cell;
    }else{//楼房
        MainTableViewRecommendedServiceHourseEstateCell *cell = [tableView dequeueReusableCellWithIdentifier:mainTableViewCell_RecommendedService_HourseEstate_Identifier];
        if (!cell || ![cell isKindOfClass:[MainTableViewRecommendedServiceHourseEstateCell class]]) {
            cell = [[MainTableViewRecommendedServiceHourseEstateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mainTableViewCell_RecommendedService_HourseEstate_Identifier];
        }
        cell.dataSourceArr = self.recommendedServiceNewsListArr;//MainRecommendedServiceHourseEstateModel
        cell.delegate = self;
        return cell;
    }
    
}
- (UITableViewCell *)yanglaoAndYiLiaoSectionWithtableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewPersionAndMedicalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainTableViewCell_PersionAndMedical_Identifier];
    if (!cell || ![cell isKindOfClass:[MainTableViewPersionAndMedicalTableViewCell class]]) {
        cell = [[MainTableViewPersionAndMedicalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mainTableViewCell_PersionAndMedical_Identifier];
    }
    cell.delegate = self;
    return cell;
}
- (UITableViewCell *)convenienceServiceSectionWithtableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewConvenienceServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:mainTableViewCell_ConvenienceService_Identifier];
    if (!cell || ![cell isKindOfClass:[MainTableViewConvenienceServiceCell class]]) {
        cell = [[MainTableViewConvenienceServiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mainTableViewCell_ConvenienceService_Identifier];
    }
    cell.delegate = self;
    return cell;
}
- (UITableViewCell *)oneSectionWithtableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){//集合视图 菜单功能view
        MainTableViewCenterMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:mainTableViewCell_cneter_Menu_Identifier];
        if (!cell || ![cell isKindOfClass:[MainTableViewCenterMenuCell class]]) {
            cell = [[MainTableViewCenterMenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mainTableViewCell_cneter_Menu_Identifier];
        }
        cell.delegate = self;
        cell.sourceArr = self.centerMenuSourceArr;
        return cell;
    }else if(indexPath.row == 1){//中间的上下轮播图
        MainTableViewCenterBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:mainTableViewCell_cneter_BannerScrollView_Identifier];
        if (!cell || ![cell isKindOfClass:[MainTableViewCenterBannerCell class]]) {
            cell = [[MainTableViewCenterBannerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mainTableViewCell_cneter_BannerScrollView_Identifier];
        }
        cell.advertScrollView.delegate = self;
        [cell.rightMoreBtn addTarget:self action:@selector(urgentMoreBtnAction) forControlEvents:UIControlEventTouchUpInside];
        cell.dataSource = self.centeradvertScrollviewSourceArr;
        return cell;
    }else  if (indexPath.row == 2) {//顶部轮播图
        MainTableViewTopBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:mainTableViewCell_top_BannerScrollView_Identifier];
        if (!cell || ![cell isKindOfClass:[MainTableViewTopBannerCell class]]) {
            cell = [[MainTableViewTopBannerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mainTableViewCell_top_BannerScrollView_Identifier];
        }
        cell.cycleScrollView.delegate = self;
        cell.dataSource = self.topSourceArr;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainTableViewCell_Identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:mainTableViewCell_Identifier];
        }
        return cell;
    }
}

- (UITableViewCell *)addressBookSectionWithtableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewAddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:mainTableViewCell_cneter_AddressBook_Identifier];
    if (!cell || ![cell isKindOfClass:[MainTableViewAddressBookCell class]]) {
        cell = [[MainTableViewAddressBookCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mainTableViewCell_cneter_AddressBook_Identifier];
    }
    cell.sourceArr = self.centerAddressBookSourceArr;
    cell.delegate = self;
    return cell;
}
- (UITableViewCell *)shoppingSectionWithtableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewShoppingCell *cell = [tableView dequeueReusableCellWithIdentifier:mainTableViewCell_cneter_Shopping_Identifier];
    if (!cell || ![cell isKindOfClass:[MainTableViewShoppingCell class]]) {
        cell = [[MainTableViewShoppingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mainTableViewCell_cneter_Shopping_Identifier];
    }
    cell.sourceArr = self.centerShoppingSourceArr;
    cell.scrollViewSourceArr = self.shoppingScrollViewArr;
    cell.delegate = self;
    return cell;
    
}
- (UITableViewCell *)interestingNewsSectionWithtableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewInterestingNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:mainTableViewCell_Bottom_News_Identifier];
    if (!cell || ![cell isKindOfClass:[MainTableViewInterestingNewsCell class]]) {
        cell = [[MainTableViewInterestingNewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mainTableViewCell_Bottom_News_Identifier];
    }
    [cell fillData:self.bottomNewsSourceArr[indexPath.row]];
    return cell;
    
}
#pragma mark ====
- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H) style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = [UIView new];
        [_mainTableView setTableHeaderView:self.tableViewHeaderView];
        _mainTableView.tag = MainTableView_TAG;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = [UIColor clearColor];
        _mainTableView.delaysContentTouches = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.bounces = YES;
    }
    return _mainTableView;
}
@end
