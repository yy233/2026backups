//
//  MoreMenuVC.m
//  Community
//
//  Created by 余莹 on 2020/11/19.
//

#import "MoreMenuVC.h"
#import "LifeCostPropertyFeeListVc.h"
#import "ZYComplaintsOpinionVC.h"
#import "MoreMenuCollectionViewCell.h"
#import "MoreMenuCollectionHeaderView.h"
#import "MoreMenuSectionHeaderModle.h"
#define MoreMenuCollectionViewCell_Identifier @"MoreMenuCollectionViewCell"
#define MoreMenuCollectionHeaderView_Identifier  @"MoreMenuCollectionHeaderView"

#import "ScanHelper.h"

#define Cell_W (Screen_W-32-30)/4
#define Cell_H 120

@interface MoreMenuVC () <UICollectionViewDelegate,UICollectionViewDataSource>
//@property (nonatomic,strong) MoreMenuCollectionHeaderView *sectionHeaderView;
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation MoreMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor grayColor];
//    self.title = @"全部分类";
    self.title = @"更多";
    [self initView];
    [self addRefresh];
    [self initData];
}
//
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];//ScanHelper 引起的hidden
}
//
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadMoreNewsData)];//暂无
    self.collectionView.mj_header = headeerRefresh;
    self.collectionView.mj_footer = footerRefresh;
    self.collectionView.mj_footer.hidden = YES;
}

- (void)initData{//URL_MORE_MENU_V2 当前arr只回复一个元素 ‘服务热线";
    
    if ( kMYAPP_Now_IS_HIDDEN_MORE_INDEX == 1 ) {//不做数据 保持空状态
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView reloadData];
        });
    }else{
        
        Y_SVP_SHOW_MES_IsLoading_15Delay
        [MainCenterOneMenuListViewModel getMoreMenuListArrWithMenuBlockNew:^(NSMutableArray * arr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_DISMISS
                [self.collectionView.mj_header endRefreshing];
            });
            self.dataSourceArr = [NSMutableArray arrayWithArray:[MainCenterCollectionViewCellModel mj_objectArrayWithKeyValuesArray:arr]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }];
    }

    
    
    
}
#pragma mark====

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectItemAtIndexPath indexPath %ld",(long)indexPath.item);
    //_____________新
    MainCenterCollectionViewCellModel *model = self.dataSourceArr[indexPath.item];
    NSInteger willPushVcNum_New = [MoreMenuChooseVCType getNewMenuChooseVcWithPathStr:model.path]; 
    switch (willPushVcNum_New) {
        case Menu_choose_Notice:
        {
            //游客和未绑定手机 则总消息按钮不可点击
            if ([self shouldShowLoginVcOrBindVcBool]) {
                return;
            }
            TopInformationVC *vc = [[TopInformationVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self pushVc:vc];
        }
            break;
        case Menu_choose_Property:
        {
            //判定弹出登录或者绑定手机
            if ([self shouldShowLoginVcOrBindVcBool]) {
                return;
            }
            NSLog(@" center_menu 生活缴费");//更换到物业缴费列表 不再走生活缴费界面
           /**
            LifeCostVC *vc = [[LifeCostVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self pushVc:vc];
            */
            LifeCostPropertyFeeListVc *vc = [[LifeCostPropertyFeeListVc alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self pushVc:vc];
            
        }
            break;
        case Menu_choose_Advice:
        {
            NSLog(@" center_menu  投诉建议");
            if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
                [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
                return;;
            }
            ZYComplaintsOpinionVC *vc = [[ZYComplaintsOpinionVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self pushVc:vc];
        }
            break;
        case Menu_choose_Activity: //活动报名
        {
            
        }
            break;
        case Menu_choose_Lease: //租房
        {
            HouseRentVC *rentVc = [[HouseRentVC alloc]init];
//            rentVc.viewType = MainCellRecommendedServiceHourse_Type_BusinessShop;
            rentVc.viewType = MainCellRecommendedServiceHourse_Type_RentHouse;
            rentVc.hidesBottomBarWhenPushed = YES;
            [self pushVc:rentVc];
        }
            break;
        case Menu_choose_Bbazaar:    //社区集市
        {
            
        }
            break;
        case Menu_choose_Vote:
        {
            //判定弹出登录或者绑定手机
            if ([self shouldShowLoginVcOrBindVcBool]) {
                return;
            }
            //判定业主家属租客身份
            //
        }
            break;
        case  Menu_choose_Hotline:
        {
            [self showHouLinePopV];
        }
            
        default:
            DLog(@"Menu_choose_NoThing");
            break;
    }
}
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
#pragma mark ==
#pragma mark ==   扫一扫
- (void)scanAction{
    WEAKSELF
    /**
     qqStyle,        //QQ风格
     ZhiFuBaoStyle,  //支付宝风格
     InnerStyle,     //无边框，内嵌4个角
     weixinStyle,    //微信风格
     OnStyle,        //4个角在矩形框线上,网格动画
     changeSize      //改变扫码区域位置
     */
    ScanQRViewController *vc = [[ScanHelper shareInstance] ScanVCWithStyle:ZhiFuBaoStyle qrResultCallBack:^(id result) {
        BaseViewController *vc = [[BaseViewController alloc] init];
        [vc.navigationController.navigationBar setTranslucent:NO];
        vc.title = [NSString stringWithFormat:@"%@",result];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        NSLog(@"result=%@", result);
    }];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark ==
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}
 
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(Screen_W-32, 30);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind  withReuseIdentifier:MoreMenuCollectionHeaderView_Identifier   forIndexPath:indexPath];
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        MoreMenuSectionHeaderModle *model = self.dataSourceArr[indexPath.section];
//        MoreMenuCollectionHeaderView *sectionHeader = [[MoreMenuCollectionHeaderView alloc]initWithFrame:CGRectZero];
//        [sectionHeader headerTitleTest:model.menuName];
//        [view addSubview:sectionHeader];
//    }
 return view;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MoreMenuCollectionViewCell *cell = (MoreMenuCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:MoreMenuCollectionViewCell_Identifier  forIndexPath:indexPath];
    if (!cell) {
        cell = [[MoreMenuCollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 120) reuseIdentifier:MoreMenuCollectionViewCell_Identifier];
    }
//    MoreMenuSectionHeaderModle *headerModel = self.dataSourceArr[indexPath.section];
//    MainCenterCollectionViewCellModel *cellModel = headerModel.childMenus[indexPath.item]; // 已经在MoreMenuSectionHeaderModle中实现objectClassInArray
    MainCenterCollectionViewCellModel *model = self.dataSourceArr[indexPath.item];
    cell.model = model;
    return cell;
}


#pragma mark == UI
- (void)initView{
//    self.view.backgroundColor = [ThemeManager shareManager].meueMoreVcBackgroundColor;
    [self.view addSubview:self.collectionView];
}
#pragma mark ==
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(Cell_W,Cell_H);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(16, 0, Screen_W-32, self.view.frame.size.height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MainCenterCollectionViewCell class] forCellWithReuseIdentifier:MoreMenuCollectionViewCell_Identifier];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MoreMenuCollectionHeaderView_Identifier];//舍弃
        _collectionView.scrollEnabled = YES;
    }
    return _collectionView;
}

#pragma mark ==
- (void)showHouLinePopV{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"服务热线" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    alertController.view.backgroundColor = [UIColor whiteColor];
    alertController.view.layer.cornerRadius = 5;
    alertController.view.layer.masksToBounds = YES;
    alertController.view.bounds = CGRectMake(0, 0, alertController.view.bounds.size.width, 280);
    //
    UIView *alertBackView = [[UIView alloc] init];//back
    alertBackView.backgroundColor = [alertController.view.backgroundColor colorWithAlphaComponent:0.8];
//    alertBackView.layer.cornerRadius = 5;
//    alertBackView.layer.masksToBounds = YES;
    //
    UILabel *alertNameL = [[UILabel alloc]init];
    alertNameL.textColor = [UIColor blackColor];
    alertNameL.font = [UIFont boldSystemFontOfSize:20];
    alertNameL.textAlignment = NSTextAlignmentCenter;
    alertNameL.text = Hot_Photos;
    [alertBackView addSubview:alertNameL];
    //
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [callBtn newAnBtnWithFont:[UIFont systemFontOfSize:15]];
    [callBtn newAnBtnWithTextStr:@"立即拨打"];
    [callBtn newAnBtnWithBackColor:Color_38BlueColor];
    [callBtn newAnBtnWithLayerCorNerNum:5 withLayerLineWidth:0 withLayerLineColor:Color_38BlueColor];
    [callBtn addTarget:self action:@selector(callBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [alertBackView addSubview:callBtn];
    //
    [alertNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alertNameL.superview).offset(10);
        make.left.equalTo(callBtn.superview.mas_left).offset(10);
        make.right.equalTo(alertNameL.superview).offset(-10);
        make.height.offset(20);
    }];
    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alertNameL.mas_bottom).offset(20);
        make.left.equalTo(callBtn.superview.mas_left).offset(10);
        make.right.equalTo(callBtn.superview.mas_right).offset(-10);
        make.height.offset(40);
    }];
    //
    [alertController.view addSubview:alertBackView];
    [alertBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alertBackView.superview).offset(60);
        make.left.equalTo(alertBackView.superview).offset(0);
        make.right.equalTo(alertBackView.superview).offset(0);
        make.height.offset(100);
    }];
    //占位
    UIAlertAction *centerZanWeiOneAlertAction = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *centerZanWeiTwoAlertAction = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleDefault handler:nil];

    //
    UIAlertAction *bottomKnowAlertAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:centerZanWeiOneAlertAction];
    [alertController addAction:centerZanWeiTwoAlertAction];
    [alertController addAction:bottomKnowAlertAction];
    //
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)callBtnAction:(UIButton *)sender{
    NSString *phoneStr = Hot_Photos;//热线服务号码
    [self callPhoneWithStr:phoneStr];
}

- (void)callPhoneWithStr:(NSString *)phoneStr{
 
    NSMutableString *callStr=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneStr];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callStr] options:@{} completionHandler:nil];
}
@end
