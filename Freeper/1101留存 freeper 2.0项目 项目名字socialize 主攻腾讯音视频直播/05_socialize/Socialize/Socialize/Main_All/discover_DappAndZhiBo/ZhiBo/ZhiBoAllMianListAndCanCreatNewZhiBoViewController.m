//
//  DiscoverViewController.m
//  Socialize
//
//  Created by 余莹 on 2023/5/10.
//

#import "ZhiBoAllMianListAndCanCreatNewZhiBoViewController.h"
#import "LiveRoomBase.h"
#import "VoiceRoomBase.h"
#import "DiscoverTopView.h"
#import "DiscoverTopCollectionView.h"
#import "ZhiBoMainListSubCollectionViewCell.h"
#import "DiscoverDetailViewController.h"
#import "ZhiBoBaseInfoInputAndCreateLiveOrVoiceTypeRoomChooseVc.h"
#import "Socialize-Swift.h"
#import "CreatOfBottomBtnView.h"
#define  Item_W (Screen_W-32)
#define  Item_H ((Screen_W-32)*0.5)
#define DiscoverMainCollectionViewCell_I @"DiscoverMainCollectionViewCell"

#import "FBKVOController.h"
#import "ZhiBoListViewModel.h"

#import "BaseAlertManager.h"
 
#import "ZhiBoMyListVC.h"
#import "WaitForKaiBoViewController.h"
#import "ZhiBoPivTypeBaoMingVc.h"

#import "LoginUseModel.h"

#import "ZhiBoTopTypeChooseView.h"

@interface ZhiBoAllMianListAndCanCreatNewZhiBoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ZhiBoTopTypeChooseViewCollectionViewDelegate>
//kvo
{
    FBKVOController *fbKVO; 
}
@property (nonatomic,strong) ZhiBoListViewModel *viewModel;

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) ZhiBoListTopType nowDiscoverTopType;
@property (nonatomic,strong) NSMutableArray *dataSourceArr;

@property (nonatomic,strong) CreatOfBottomBtnView *goCreatVC_BttomView;

@property (nonatomic,assign) BOOL creatCanDoBool;


@end

@implementation ZhiBoAllMianListAndCanCreatNewZhiBoViewController

- (NSMutableArray *)dataSourceArr{
    if(!_dataSourceArr){
        _dataSourceArr = @[].mutableCopy;
    }
    return _dataSourceArr;
}
- (CreatOfBottomBtnView *)goCreatVC_BttomView{
    if(!_goCreatVC_BttomView){
        _goCreatVC_BttomView = [[CreatOfBottomBtnView alloc]initWithFrame:CGRectZero];
        [_goCreatVC_BttomView.footerB newAnBtnWithTextStr:Y_LocaleTypeFile_NSLocalString(@"创建直播")];
        [_goCreatVC_BttomView.footerB newAnBtnWithTextColor:rgba(51, 51, 51, 1)];
        [_goCreatVC_BttomView.footerB newAnBtnWithFont:[UIFont boldSystemFontOfSize:16.0]];
        //        [_goCreatVC_BttomView.footerB newAnBtnWithImg:[UIImage imageNamed:@""]];
        [_goCreatVC_BttomView.footerB addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goCreatVC_BttomView;
}
 
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(Item_W,Item_H);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ZhiBoMainListSubCollectionViewCell class] forCellWithReuseIdentifier:DiscoverMainCollectionViewCell_I];
        _collectionView.scrollEnabled = YES;
    }
    return _collectionView;
    
}

#define VoiceAndLiveNotice_ChangeActivity_Statu_Notice    @"VoiceAndLiveNotice_ChangeActivity_Statu_Notice"
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addTopTypeViewNav];//更换成navview
    //创建位置的判断
    self.creatCanDoBool = NO;
    [self checkCreatOrNotCreat];
    //界面和数据
    self.nowDiscoverTopType = ZhiBoListTopType_LiveIng;
    [self initSelfViews];//界面
    [self addKvo];//监听
    //各种登录
    if([ShareUserInfo share].userInfo.address.length > 0){
        [self initLiveAndLogin];//live登录
        [self initVoiceLogin];//voice登录
        
    }else{
        NSLog(@"游客状态 无法登录直播");
    }
    
    //加载数据
    [self initListData];
    Y_NSNotificationCenter_Creat_NameAction(VoiceAndLiveNotice_ChangeActivity_Statu_Notice, initListData);//直播开播和关播时 更新时刷新列表

    DLog(@"直播 主列表页 加载");
    
}
#pragma mark ====
//发现主界面 无nav 用hidden
//主页 透明nav 则保持当前即可
 
  
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    if (@available(iOS 15.0, *)) {
//        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
//        [appearance configureWithDefaultBackground];
//        appearance.shadowColor = nil;
//        appearance.backgroundEffect = nil;
//        appearance.backgroundColor =  [self navBackColor];
//        UINavigationBar *navigationBar = self.navigationController.navigationBar;
//        navigationBar.backgroundColor = [self navBackColor];
//        navigationBar.barTintColor = [self navBackColor];
//        navigationBar.shadowImage =  [UIImage new];// Y_gray_img;
//        navigationBar.standardAppearance = appearance;
//        navigationBar.scrollEdgeAppearance= appearance;
//    }
//    else {
//        UINavigationBar *navigationBar = self.navigationController.navigationBar;
//        navigationBar.backgroundColor = [self navBackColor];
//        navigationBar.barTintColor = [self navBackColor];
//        navigationBar.shadowImage =  [UIImage new];// Y_gray_img;
//        [[UINavigationBar appearance] setTranslucent:NO];
//    }
//
//
////    [self.navigationController.navigationBar setTranslucent:YES];//透明的
//
//
    //游客时。不出现   创建按钮
    if([ShareUserInfo share].userInfo.address.length <= 0){
        self.goCreatVC_BttomView.hidden = YES;
    }else{//非游客时 才显示创建按钮
        self.goCreatVC_BttomView.hidden = NO;
    }
    DLog(@"直播 主列表页 显示");
    [self setNeedsStatusBarAppearanceUpdate];//顶部状态栏主题相关
}


 
//- (void)addTopTypeViewNav{
//    if([self.navigationItem.titleView isKindOfClass: [ZhiBoTopTypeChooseView class]]){
//        //已经存在
//    }else{
//        ZhiBoTopTypeChooseView *navview = [[ZhiBoTopTypeChooseView alloc]initWithFrame:CGRectMake(0, 0, Screen_W*0.9, KNavBarHeight)];
//        navview.delegate = self;
//        navview.tag = 3333;//用于创建页处理显示隐藏
//        self.navigationItem.titleView = navview;
//    }
//    self.navigationItem.titleView.hidden = NO;
//
//}
//- (UIColor *)navBackColor {
//    return [UIColor clearColor];;
//    if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
////        UIColor * beginColor =  rgba(216, 251, 235, 1);//取中间值 和ZhiBoTopTypeChooseView同色不透明
//        UIColor * beginColor = JianBian_Blue_Color;//浅蓝
//        return beginColor;
//    }else{
//        return [Y_ToolOfOthers getColorWithHexString:Theme_Nav_COlOR_Drak_Str];
//    }
//}

#pragma mark ===================================
- (void)initSelfViews{
    //渐变色
    self.view.backgroundColor = [UIColor whiteColor];//切到当前页时 此处白色可以把上页残留view暂留视觉可解决
    CGRectMake(0, 0, Screen_W, 999);
    GreenAndJianBianBkView *bgColorView = [[GreenAndJianBianBkView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:bgColorView];
 
    [bgColorView addSubview:self.collectionView];
 
  
    //120-btns30 -- 底部位置60-15=45 --top25
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_collectionView.superview).offset(-32);
        make.centerX.equalTo(_collectionView.superview);
        //make.bottom.equalTo(_collectionView.superview).offset(-kBottom_SafeHeight-20);//不能贴地-20
        make.height.offset(Screen_Height-KNavBarHeight-kBottom_SafeHeight-20);
        make.top.equalTo(_collectionView.superview).offset(20);
        
    }];
    
    //创建跳转按钮
    WEAKSELF
    [bgColorView addSubview:self.goCreatVC_BttomView];
    [_goCreatVC_BttomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(Screen_W);
        make.height.offset(100);
        make.bottom.equalTo(weakSelf.view).offset(-kBottom_SafeHeight);
    }];
    
    //游客时。不出现   创建按钮
    if([ShareUserInfo share].userInfo.address.length <= 0){
        self.goCreatVC_BttomView.hidden = YES;
    }else{//非游客时 才显示创建按钮
        self.goCreatVC_BttomView.hidden = NO;
    }
  
    
    
    //other
    [self addRefresh];
    [self addNavItem];

}

- (void)addNavItem{
    //游客时。不出现 右上角的按钮 我的直播
    if([ShareUserInfo share].userInfo.address.length <= 0){
        return;
    }
    
    UIBarButtonItem *rightMaxItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"我的"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightNavItemAction)];
    [self.navigationItem setRightBarButtonItems:@[rightMaxItem] animated:YES];
    
}
- (void)rightNavItemAction{
    //我的直播
    NSLog(@"我的直播");
    ZhiBoMyListVC *vc = [[ZhiBoMyListVC alloc]init];
    [self pushVc:vc];
    
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initListData)];
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upDataListData)];//暂无
    self.collectionView.mj_header = headeerRefresh;
    self.collectionView.mj_footer = footerRefresh;
    self.collectionView.mj_footer.hidden = YES;
}
#pragma mark === live voice 登录

- (void)initLiveAndLogin{
    WEAKSELF
    [LiveRoomBase liveRoomLoginInfoUserID:([ShareUserInfo share].userInfo.imId.length > 0 ? [ShareUserInfo share].userInfo.imId : @"")
                                  userSig:([ShareUserInfo share].userInfo.imSignature.length > 0 ? [ShareUserInfo share].userInfo.imSignature : @"")
                               withBlockk:^(BOOL loginStue) {
        if(loginStue){
            
        }else{
        }
    }];
}
- (void)initVoiceLogin{
    [[VoiceRoomBase shareVoice]voiceRoomLoginAction];
}

 
#pragma mark === footerBtn

- (void)checkCreatOrNotCreat{
    //加载时间花费 需要在点击之前有结果
    //chat主页放一份 用share专门做个值好了
    if([ShareUserInfo share].userInfo.useDomain.length>0){
        self.creatCanDoBool = YES;
        [ShareUserInfo share].canCreatZhiboBool = self.creatCanDoBool;
        return;
    }
    if([ShareUserInfo share].canCreatZhiboBool){//已经发过粉友了
        self.creatCanDoBool = YES;//已经发过粉友了
    }else{
        if([ShareUserInfo share].userInfo.address.length >0 && [ShareUserInfo share].userInfo.token.length >0 && [ShareUserInfo share].userInfo.imSignature.length >0){
            [LoginUseModel checkVerifySignaturewithBlock:^(NSDictionary * _Nonnull dicOfBlock, BOOL succes) {
                if(succes){
                    if([[dicOfBlock allKeys] containsObject:@"nftDomainGroupList"]){
                        NSArray *nftDomainGroupListArr = [[NSArray alloc]initWithArray:[dicOfBlock objectForKey:@"nftDomainGroupList"]];
                        //验证用户是否已经发行过圈子  //其他情况下 校验另一个接口 如登陆时未发行圈子，发行之后再去创建直播页面
                        if(nftDomainGroupListArr.count>0){
                            self.creatCanDoBool = YES;//已经发过粉友了
                            [ShareUserInfo share].canCreatZhiboBool = self.creatCanDoBool;
                            
                        }else{
                            if([ShareUserInfo share].userInfo.useDomain.length>0){
                                self.creatCanDoBool = YES;
                                [ShareUserInfo share].canCreatZhiboBool = self.creatCanDoBool;
                            }else{
                                self.creatCanDoBool = NO;
                                [ShareUserInfo share].canCreatZhiboBool = self.creatCanDoBool;
                            }
                           
                        }
                    }
                }
            }];
        }
    }
    
    
}



- (void)footerBtnAction{
//    self.creatCanDoBool = YES;//test
    if(self.creatCanDoBool == YES){
        
    }else{
        NSString *cantCreatMsg = Y_LocaleTypeFile_NSLocalString(@"创建活动前，请先创建一个友圈或者粉圈");
        Y_SVP_SHOW_INFO_MES_5Delay(cantCreatMsg);
        return;
    }
    
    
    DLog(@"创建直播  voice live 类型选择页面");
    ZhiBoBaseInfoInputAndCreateLiveOrVoiceTypeRoomChooseViewController *vc = [[ZhiBoBaseInfoInputAndCreateLiveOrVoiceTypeRoomChooseViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
//    vc.boolPushLastVcIsWebOrNotClearnNavVc = NO;//
    vc.boolPushLastVcIsWebOrNotClearnNavVc = YES;
    //0901 创建页的nav颜色问题 给个黑色
    self.navigationController.navigationBar.translucent = NO;
    [self setupNavigationBarWhiteTextColorWithBackViewCustomColor:rgba(27, 26, 39, 1)];
    [self.navigationController pushViewController:vc animated:YES];
}
  
 

#pragma mark === serarchbtn
- (void)topSearchBtnAction{
    DLog();
    
    //    AnchorPKPanel *a =[[AnchorPKPanel alloc]init];
    //    [a loadRoomsInfo];
    
    //
    //    [[TUILiveRoomProfileManager sharedManager]getRoomListWithSuccess:^(NSArray<NSString *> * _Nonnull roomList) {
    //        NSLog(@" getRoomListWithSuccess  -- %@",roomList);
    //    } failed:^(int32_t, NSString * _Nonnull errMsg) {
    //        NSLog(@"getRoomListWithSuccess errMsg == %@",errMsg);
    //    }];
    //
    
    
}
#pragma mark === topTypeDetelget

- (void)nowSelectedType:(ZhiBoListTopType)discoverTopType{
    self.nowDiscoverTopType = discoverTopType;
    [self initListData];
}


#pragma mark ==
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(Screen_W-32, 10);
}

- (NSString *)zhuanLocaTimeWithGetSt:(NSString *)getstartDatetime{
    NSString *UTC = @"UTC";
    NSString *getSt = [NSString stringWithFormat:@"%@",getstartDatetime];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithAbbreviation:UTC]; //UTC本地时区
    [formatter setTimeZone:timeZone];

    NSDate* thisDate = [formatter dateFromString:getSt]; //------------将字符串按formatter转成nsdate
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[thisDate timeIntervalSince1970]];
    NSLog(@"前端 是加UTC  转成时间戳 =  %@",timeSp);
    
    NSDateFormatter *formatterY = [[NSDateFormatter alloc] init] ;
    [formatterY setDateStyle:NSDateFormatterMediumStyle];
    [formatterY setTimeStyle:NSDateFormatterShortStyle];
    [formatterY setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone* timeZoneY = [NSTimeZone localTimeZone];  //可取别的本地时区
    [formatterY setTimeZone:timeZoneY];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeSp integerValue]];
    NSString *confromTimespStr = [formatterY stringFromDate:confromTimesp];
    NSLog(@"前端 是加UTC  转成时间戳 再转成本地时间的 =  %@",timeSp);

    return confromTimespStr;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZhiBoMainListSubCollectionViewCell *cell = (ZhiBoMainListSubCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:DiscoverMainCollectionViewCell_I  forIndexPath:indexPath];
    if (!cell) {
        cell = [[ZhiBoMainListSubCollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, Item_W, Item_H)];
    }
    
    
    
    ZhiBoShowInfoModel *model = self.dataSourceArr[indexPath.row];
    cell.topRightVOiceOrLiveTypeLabel.text = (model.category == 1) ? Y_LocaleTypeFile_NSLocalString(@"视频") : Y_LocaleTypeFile_NSLocalString(@"语音");// category 1、video音视频， 2、audio音频， 3、else 其他
    cell.topRightPubOrPivTypeLabel.text = ( isNil(model.recode) || model.recode.length == 0 ) ?  Y_LocaleTypeFile_NSLocalString(@"公开") : Y_LocaleTypeFile_NSLocalString(@"私密");
    //
    NSString *nameStr = [TextShowWithModelStr textShowWithModelStr: model.domain];
    if(nameStr.length <= 0){
        nameStr = [TextShowWithModelStr textShowWithModelStr: model.username];
    }
    if(nameStr.length <= 0){
        nameStr = [TextShowWithModelStr textShowWithModelStr: model.address];
    }
    if( nameStr.length > 0){
        cell.titleLabel.hidden = NO;
    }else{
        cell.titleLabel.hidden = YES;
    }
    cell.titleLabel.text = nameStr;
    cell.subtitleLabel_S.text = [TextShowWithModelStr textShowWithModelStr: model.title];

    cell.dealLineTimeLabel.text = [TextShowWithModelStr textShowWithModelStr: [self zhuanLocaTimeWithGetSt: [TextShowWithModelStr textShowWithModelStr:model.startDatetime]]  ];
    if(self.nowDiscoverTopType == ZhiBoListTopType_LiveIng){//播出状态
        cell.dealLineTimeLabel.hidden = YES;
    }else{//全部
        cell.dealLineTimeLabel.hidden = NO;
    }
    cell.numLabel.text = [NSString stringWithFormat:@"%@%@",Y_LocaleTypeFile_NSLocalString(@"报名人数"),[TextShowWithModelStr textShowWithModelIntType:model.applicants]];
    [cell.imgView sd_setImageWithURL:[UrlWithString getURLWithStr: [self getPicutWithStr:model.picture].firstObject] placeholderImage:[UIImage imageWithColor: Color_222GrayColor size:CGSizeMake(Item_W, Item_H)]];

    if([model.address isEqualToString:[ShareUserInfo share].userInfo.address]){//是创建者
        switch (model.state) {
                
            case 3:
            {
                cell.typeLabel.text = Y_LocaleTypeFile_NSLocalString(@"直播中");;
            }
                break;
            case 4:
            {
                cell.typeLabel.text = Y_LocaleTypeFile_NSLocalString(@"已结束");;
            }
                break;
                
            default:
                cell.typeLabel.text = Y_LocaleTypeFile_NSLocalString(@"待直播");;
                break;
                
        }
    }else{//非创建者

        if(model.state == 4){//完结
            cell.typeLabel.text = Y_LocaleTypeFile_NSLocalString(@"已结束");;
        }else if(model.state == 3){//直播中
            cell.typeLabel.text = Y_LocaleTypeFile_NSLocalString(@"直播中");;
        }else{
            switch (model.isSignUp) {//报名否
                case 0:
                {
                    cell.typeLabel.text = Y_LocaleTypeFile_NSLocalString(@"未报名");
                }
                    break;
                case 1:
                {
                    cell.typeLabel.text = Y_LocaleTypeFile_NSLocalString(@"已报名");
                }
                    break;
                    
                default:
                    cell.typeLabel.text = Y_LocaleTypeFile_NSLocalString(@"未报名");
                    break;
            }
        }
    }

    return cell;
}

- (NSArray *)getPicutWithStr:(NSString *)longPicStr{
    if(longPicStr.length>0){
        return [longPicStr componentsSeparatedByString:@","];
    }else{
        return @[];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZhiBoShowInfoModel *model = self.dataSourceArr[indexPath.row];
    
    if([model.address isEqualToString:[ShareUserInfo share].userInfo.address]){//是创建者
        switch (model.state) {
                
            case 3:
            {
                //@"直播中"; ---继续直播
                [self goToZhiBoVcWithCreatUserWithThisZhiBoInfoMode:model];
                
            }
                break;
            case 4:
            {
                // @"已结束";-- 无动作
                Y_SVP_SHOW_INFO_MES( Y_LocaleTypeFile_NSLocalString(@"直播已结束") );
            }
                break;
                
            default:
                // @"待直播";---去开启直播
            {
                [self goToZhiBoVcWithCreatUserWithThisZhiBoInfoMode:model];
            }
                break;
                
        }
    }else{//非创建者
        if([ShareUserInfo share].userInfo.address.length <= 0){//未登录
            // @"未报名"---- 登录提示
//            Y_SVP_SHOW_INFO_MES(@"游客状态，请登录。")
            NSString *shwoPleseLogin = Y_LocaleTypeFile_NSLocalString(@"请登录");
            Y_SVP_SHOW_INFO_MES_5Delay(shwoPleseLogin);//调起登录相关签名
            
        }else{
            
            if(model.state == 3){
                //@"直播中" //分为报名和没报名
                if(model.isSignUp == 1){
                    //去看直播
                    [self goiToZhiBoVcLookerTypeWithInfoMode:model];
                }else{
                    //去报名
                    [self goToBaoMingWithInfoMode:model];
                }
                
            }else{//没直播
                switch (model.isSignUp) {
                    case 0:
                    {
                        //@"未报名"; 去报名
                        [self goToBaoMingWithInfoMode:model];
                        
                    }
                        break;
                    case 1:
                    {
                        //@"已报名"; 去详情
                        [self goToDetailVcWithInfoMode:model];
                    }
                        break;
                    default:
                        //@"未报名";
                    {
                        [self goToBaoMingWithInfoMode:model];
                    }
                        break;
                }
            }
            
        }
    }
    
}
#pragma mark ===
#pragma mark ===//去详情
- (void)goToDetailVcWithInfoMode:(ZhiBoShowInfoModel*)zhiBoInfoModel{
    
  //暂不支持去详情页 显示当前点击信息即可
    NSString *categoryStr = @"";
    if(zhiBoInfoModel.category == 2){
        categoryStr = Y_LocaleTypeFile_NSLocalString(@"语音");
    }else{
        categoryStr = Y_LocaleTypeFile_NSLocalString(@"视频");
    }
    
    NSString *zhiBojian  = Y_LocaleTypeFile_NSLocalString(@"直播间");
    NSString *leixin =  Y_LocaleTypeFile_NSLocalString(@"类型");
    NSString *showMsg = [NSString stringWithFormat:@"%@：%@ \n%@：%@",zhiBojian,zhiBoInfoModel.title,leixin,categoryStr];
    BaseAlertManager *baseAlertManager = [[BaseAlertManager shareManager]creatAlertWithTitle:@"" message:showMsg preferredStyle:UIAlertControllerStyleAlert cancelTitle: Y_LocaleTypeFile_NSLocalString(@"知道了") otherTitleArr:@[   Y_LocaleTypeFile_NSLocalString(@"开播情况") ].mutableCopy];
    [baseAlertManager showWithViewController:self IndexBlock:^(NSInteger chooseIndex) {
        if(chooseIndex == AlertManagerCancelIndex){//取消
        }else{//
            //[self aleatOk_goDetailVcWithInfoMode:zhiBoInfoModel];
            [self aleatOk_goWaitVcWithInfoMode:zhiBoInfoModel];
        }
        
    }];
}
- (void)aleatOk_goDetailVcWithInfoMode:(ZhiBoShowInfoModel*)zhiBoInfoModel{
}

- (void)aleatOk_goWaitVcWithInfoMode:(ZhiBoShowInfoModel*)zhiBoInfoModel{
    WaitForKaiBoViewController *vc = [[WaitForKaiBoViewController alloc]init];
    vc.showMode = [zhiBoInfoModel copy];
   // self.navigationItem.titleView = nil;
    [self pushVc:vc];
}
#pragma mark ===//报名
- (void)goToBaoMingWithInfoMode:(ZhiBoShowInfoModel*)zhiBoInfoModel{
    
    NSString *typeS = (zhiBoInfoModel.category==2) ? Y_LocaleTypeFile_NSLocalString(@"语音") : Y_LocaleTypeFile_NSLocalString(@"视频");
    
    NSString *baoming = Y_LocaleTypeFile_NSLocalString(@"报名");
    NSString *zhibo = Y_LocaleTypeFile_NSLocalString(@"直播");
    NSString *showMsg = [NSString stringWithFormat:@"%@'%@'%@%@？",baoming,zhiBoInfoModel.title,typeS,zhibo];
    BaseAlertManager *baseAlertManager = [[BaseAlertManager shareManager]creatAlertWithTitle:@"" message:showMsg preferredStyle:UIAlertControllerStyleAlert cancelTitle: Y_LocaleTypeFile_NSLocalString(@"取消") otherTitleArr:@[ Y_LocaleTypeFile_NSLocalString(@"确定")].mutableCopy];
    [baseAlertManager showWithViewController:self IndexBlock:^(NSInteger chooseIndex) {
        if(chooseIndex == AlertManagerCancelIndex){//取消
        }else{//确定
            [self aleatOk_BaoMingWithInfoMode:zhiBoInfoModel];
        }
    }];
    
}


- (void)aleatOk_BaoMingWithInfoMode:(ZhiBoShowInfoModel*)zhiBoInfoModel{
    //私密直播类型 跳转后输入密码再报名
    if( zhiBoInfoModel.recode.length > 0 ){//@"recode"];//有值表示私密直播，无值表示公共直播
        ZhiBoPivTypeBaoMingVc *vc = [[ZhiBoPivTypeBaoMingVc alloc]init];
        vc.zhiBoInfoModel = [zhiBoInfoModel copy];
        WEAKSELF
        vc.baoMingSuccessNeedRefActionBool = ^{
            [weakSelf.collectionView.mj_header beginRefreshing];
        };
        [self pushVc:vc];
        return;
    }
    
    //公开直播类型 直接报名
    NSDictionary *baoMinDic = @{
        @"activityId" : zhiBoInfoModel.activityId,
        @"account" : [ShareUserInfo share].userInfo.address,
    };
    
    WEAKSELF
    NSString *baoming = Y_LocaleTypeFile_NSLocalString(@"报名");
    NSString *chegngong = Y_LocaleTypeFile_NSLocalString(@"成功");
    [ZhiBoBaseNetTools oneLookerBaoMinOneActivityWithParms:baoMinDic withBlock:^(NSDictionary * _Nonnull dicOfBlock, BOOL succes) {
        if(succes){
            if(zhiBoInfoModel.title.length > 0){
                NSString *rooNme = [NSString stringWithFormat:@"%@",zhiBoInfoModel.title];
                NSString *showStr = [NSString stringWithFormat:@"%@‘%@’%@！",baoming,rooNme,chegngong];
                Y_SVP_SHOW_SUCCESS_MES(showStr);
            }else{
                NSString *bmcg = [NSString stringWithFormat:@"%@%@",baoming,chegngong];
                Y_SVP_SHOW_SUCCESS_MES( bmcg );
            }
            [weakSelf initListData];//重新加载数据
        }
    }];
}

#pragma mark ===//去开直播
- (void)goToZhiBoVcWithCreatUserWithThisZhiBoInfoMode:(ZhiBoShowInfoModel*)zhiBoInfoModel{
    NSString *showMsg = @"";
    
    NSString *typeS = (zhiBoInfoModel.category==2) ? Y_LocaleTypeFile_NSLocalString(@"语音") : Y_LocaleTypeFile_NSLocalString(@"视频");
        NSString *zhibo = Y_LocaleTypeFile_NSLocalString(@"直播");
    if(zhiBoInfoModel.state == 3){
        NSString *jixu = Y_LocaleTypeFile_NSLocalString(@"继续");
        showMsg = [NSString stringWithFormat:@"%@'%@'%@%@？",jixu,zhiBoInfoModel.title,typeS,zhibo];
    }else{
        NSString *qukaiqi = Y_LocaleTypeFile_NSLocalString(@"去开启");
        showMsg = [NSString stringWithFormat:@"%@'%@'%@%@？",qukaiqi,zhiBoInfoModel.title,typeS,zhibo];
    }

    BaseAlertManager *baseAlertManager = [[BaseAlertManager shareManager]creatAlertWithTitle:@"" message:showMsg preferredStyle:UIAlertControllerStyleAlert cancelTitle: Y_LocaleTypeFile_NSLocalString(@"取消") otherTitleArr:@[ Y_LocaleTypeFile_NSLocalString(@"确定")].mutableCopy];

    [baseAlertManager showWithViewController:self IndexBlock:^(NSInteger chooseIndex) {
        if(chooseIndex == AlertManagerCancelIndex){//取消
        }else{//确定
            [self aleatOk_CreaterKaiBoWithInfoMode:zhiBoInfoModel];
        }
    }];
    
}
- (void)aleatOk_CreaterKaiBoWithInfoMode:(ZhiBoShowInfoModel*)zhiBoInfoModel{
     if(zhiBoInfoModel.category == 2){//语音
         //去 语音房间 开播
        VoiceRoomChuanZhiModel *vChuanZhiModel = [[VoiceRoomChuanZhiModel alloc]init];
 
         vChuanZhiModel.Voice_User_NickName = [ShareUserInfo share].userInfo.address;
         vChuanZhiModel.Voice_User_HeadImg = [ShareUserInfo share].userInfo.profileImageUrl;
         
         vChuanZhiModel.Voice_Room_ID = zhiBoInfoModel.roomId;//10086 //1704024694 //307895640 @"1179402493"
         vChuanZhiModel.Voice_Room_ActivityID = zhiBoInfoModel.activityId;
         vChuanZhiModel.Voice_Room_Name = zhiBoInfoModel.title;
         vChuanZhiModel.Voice_Room_BkImg = [TextShowWithModelStr textShowWithModelStr:zhiBoInfoModel.picture];
         vChuanZhiModel.Voice_Room_Introduction = [TextShowWithModelStr textShowWithModelStr:zhiBoInfoModel.description_D];
         vChuanZhiModel.Voice_Room_NeedRequest = YES;
         vChuanZhiModel.Voice_Room_rec_passWordStr = [TextShowWithModelStr textShowWithModelStr:zhiBoInfoModel.recode];//私密直播的密码0908
         vChuanZhiModel.Voice_Room_OhterDic = @{};
         if(isNil(vChuanZhiModel.Voice_Room_ID)){
             Y_SVP_SHOW_ERR_MES(  Y_LocaleTypeFile_NSLocalString(@"无房间ID，不能开播")  );
             return;
         }
        
         [self creatVoiceRoomUseSwiftVcWithInfo:vChuanZhiModel];
        
        
    }else if(zhiBoInfoModel.category == 1){//1视频 开播
        
        if(isNil( zhiBoInfoModel.roomId )){
            Y_SVP_SHOW_ERR_MES(  Y_LocaleTypeFile_NSLocalString(@"无房间ID，不能开播")  );
            return;
        }
       
        if([TextShowWithModelStr textShowWithModelStr:zhiBoInfoModel.recode].length>0){//私密
            [LiveRoomBase liveroomCreateWithRoomIdStr:zhiBoInfoModel.roomId
                                    withActivityIdstr:zhiBoInfoModel.activityId
                                            withTitle:zhiBoInfoModel.title
                                   withFengMianUrlStr:[TextShowWithModelStr textShowWithModelStr:zhiBoInfoModel.picture]
                                     withIsPublicBool:YES
                                   withResPasswordStr:[TextShowWithModelStr textShowWithModelStr:zhiBoInfoModel.recode]
                                         withOtherDic:@{}];
        }else{
            [LiveRoomBase liveroomCreateWithRoomIdStr:zhiBoInfoModel.roomId withActivityIdstr:zhiBoInfoModel.activityId withTitle:zhiBoInfoModel.title withFengMianUrlStr:[TextShowWithModelStr textShowWithModelStr:zhiBoInfoModel.picture] withIsPublicBool:YES];
        }
    }
}



#pragma mark == //用swift重写的方法-----
- (void)creatVoiceRoomUseSwiftVcWithInfo:(VoiceRoomChuanZhiModel *)vChuanZhiModel{//VoiceRoomChuanZhiModel
    WEAKSELF
    [[VoiceRoomBase shareVoice]creatVoiceRoomWithRootVc:self withVoiceXiangGuanInfo:vChuanZhiModel withVcBlock:^(BOOL succes, UIViewController * _Nonnull vc) {
        if(succes){
            DLog(@" -------creatVoiceRoomUseSwiftVcWithInfo ---------进语音房间  succ ");
            //weakSelf.navigationItem.titleView = nil;
            [weakSelf pushVc:vc];
            
        }else{
            DLog(@"进语音房间失败");
        }
    }];
}

#pragma mark ===//去看直播
- (void)goiToZhiBoVcLookerTypeWithInfoMode:(ZhiBoShowInfoModel*)zhiBoInfoModel{
    NSString *showMsg = @"";
    NSString *quKan = Y_LocaleTypeFile_NSLocalString(@"去看");
    if(zhiBoInfoModel.category == 2){
        NSString *yuyingzhibo = Y_LocaleTypeFile_NSLocalString(@"语音直播");
        showMsg = [NSString stringWithFormat:@"%@'%@'%@？",quKan,zhiBoInfoModel.title,yuyingzhibo];
    }else{
        NSString *shipingzhibo =Y_LocaleTypeFile_NSLocalString(@"视频直播");
        showMsg = [NSString stringWithFormat:@"%@'%@'%@？",quKan,zhiBoInfoModel.title,shipingzhibo];
    }
    
    BaseAlertManager *baseAlertManager = [[BaseAlertManager shareManager]creatAlertWithTitle:@"" message:showMsg preferredStyle:UIAlertControllerStyleAlert cancelTitle: Y_LocaleTypeFile_NSLocalString(@"取消") otherTitleArr:@[ Y_LocaleTypeFile_NSLocalString(@"确定")].mutableCopy];
    [baseAlertManager showWithViewController:self IndexBlock:^(NSInteger chooseIndex) {
        if(chooseIndex == AlertManagerCancelIndex){//取消
        }else{//确定
            [self aleatOk_LookerGotoZhiBoWithInfoMode:zhiBoInfoModel];
        }
    }];
    
}

//观众
- (void)aleatOk_LookerGotoZhiBoWithInfoMode:(ZhiBoShowInfoModel*)zhiBoInfoModel{
    // category 1、video音视频， 2、audio音频， 3、else 其他
    if(zhiBoInfoModel.category == 2){//语音
        
        //去 语音房间
        VoiceRoomChuanZhiModel *vChuanZhiModel = [[VoiceRoomChuanZhiModel alloc]init];
        vChuanZhiModel.Voice_User_NickName = [ShareUserInfo share].userInfo.address;
        vChuanZhiModel.Voice_User_HeadImg = [ShareUserInfo share].userInfo.profileImageUrl;
        vChuanZhiModel.Voice_Room_ID = zhiBoInfoModel.roomId;//10086 //1704024694 //307895640 @"1179402493"
        vChuanZhiModel.Voice_Room_Name = zhiBoInfoModel.title;
        vChuanZhiModel.Voice_Room_Introduction = zhiBoInfoModel.description_D;
        vChuanZhiModel.Voice_Room_BkImg = zhiBoInfoModel.picture;
        vChuanZhiModel.Voice_Room_ActivityID = zhiBoInfoModel.activityId;
        vChuanZhiModel.Voice_Room_rec_passWordStr = [TextShowWithModelStr textShowWithModelStr:zhiBoInfoModel.recode];//私密直播的密码0908
        vChuanZhiModel.Voice_Room_OhterDic = @{};
 
        
        WEAKSELF
        [[VoiceRoomBase shareVoice]enterVoiceRoomWithRootVc:self withInfo:vChuanZhiModel  withVcBlock:^(BOOL succes, UIViewController * _Nonnull vc) {
            if(succes){
                DLog(@" ----------------进语音房间 %@  succ ",zhiBoInfoModel.roomId);
                //weakSelf.navigationItem.titleView = nil;
                [weakSelf pushVc:vc];
                
            }else{
                DLog(@"进语音房间失败");
            }
        }];
        
    }else if(zhiBoInfoModel.category == 1){//1视频
        NSString *roomNameStr = [TextShowWithModelStr textShowWithModelStr:zhiBoInfoModel.title];
        
        if([TextShowWithModelStr textShowWithModelStr:zhiBoInfoModel.recode].length > 0){
            [LiveRoomBase liveTypeLookerGotoVcWithRoomNameStr:roomNameStr
                                               withActivityId:zhiBoInfoModel.activityId
                                  withThisLiveRoomEnterRoomID: [zhiBoInfoModel.roomId intValue]
                                           withResPasswordStr:[TextShowWithModelStr textShowWithModelStr:zhiBoInfoModel.recode]
                                                 withOtherDic:@{}];
        }else{
            [LiveRoomBase liveTypeLookerGotoVcWithRoomNameStr:roomNameStr withActivityId:zhiBoInfoModel.activityId withThisLiveRoomEnterRoomID: [zhiBoInfoModel.roomId intValue] ];
        }
       
    }
}

#pragma mark ====  data
 
- (void)initListData{
    //增入address
    /**
     activityType  和  content二选一
     activityType ：0 热门活动  1、闪播， 2、付费直播， 3正在直播
     content:搜索关键字
      
     ZhiBoListTopType_LiveIng = 0,
     ZhiBoListTopType_waitLive,
     ZhiBoListTopType_Live,
     */
    
    if([ShareUserInfo share].userInfo.address.length > 0 ){
    }else{
        [ShareUserInfo share].userInfo.address = @"";//防止空崩溃
    }
    self.viewModel.thisParms = @{}.mutableCopy;
    if (self.nowDiscoverTopType == ZhiBoListTopType_LiveIng) {//推荐
        self.viewModel.thisParms = @{
            @"activityType" : @0, //推荐0 免费1 付费2 ｜0时不定直播类型
            @"content":@"",
            @"account":[ShareUserInfo share].userInfo.address
        }.mutableCopy;
    }else{
        self.viewModel.thisParms = @{
            @"activityType" : @1, //推荐0 免费1 付费2 |免费1时可以直播子类型
//            @"category" : self.nowDiscoverTopType == ZhiBoListTopType_waitLive ? @2: @1, //类型 语音=2 非语音=1 //0921类型更改为 待播类型？数据待确定
            @"content":@"",
            @"account":[ShareUserInfo share].userInfo.address
        }.mutableCopy;
    }
   
    //请求第一页
    [self.viewModel getDataListOnePage];
 
}
- (void)upDataListData{
    //加载更多
    [self.viewModel getDataListNextPage];
}



- (ZhiBoListViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[ZhiBoListViewModel alloc]init];
    }
    return _viewModel;
}
#pragma mark ==
- (void)addKvo{
    
    fbKVO = [FBKVOController controllerWithObserver:self];
    //列表
    WEAKSELF
    NSArray *listKvoKeyArr = @[kViewModel_dataOfArr,
                                    kViewModel_thisIsSuccessBool];//keyPaths keyPath
    [fbKVO observe:self.viewModel  keyPaths:listKvoKeyArr  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *fbKvoKeyPath = [NSString stringWithString:[change objectForKey:@"FBKVONotificationKeyPathKey"]];
        DLog(@"fbKvoKeyPath = %@ ; objectChangeInfoData==%@ observerVM==%@   changeO= =%@ ",fbKvoKeyPath,change,object,observer);
        [weakSelf getKVoPathStr:fbKvoKeyPath];
    }];
  
}
- (void)getKVoPathStr:(NSString *)fbKvoKeyPath{
    WEAKSELF
    if ([fbKvoKeyPath isEqualToString:kViewModel_thisIsSuccessBool]){//msg
        //success or fail
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView.mj_footer endRefreshing];
         });
        
        if (weakSelf.viewModel.thisIsSuccessBool) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                Y_SVP_SHOW_SUCCESS_MES(weakSelf.viewModel.showMsgStr);//成功有提示 0902去除成功的提示
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_MES(weakSelf.viewModel.showMsgStr);//请求失败有提示
            });
        }
    }else  if ([fbKvoKeyPath isEqualToString:kViewModel_dataOfArr]) {//data
        //SUCCESS
        self.dataSourceArr = weakSelf.viewModel.dataOfArr.mutableCopy;//mj_objectArrayWithKeyValuesArray:];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            if (weakSelf.viewModel.dataOfArr.count >= Y_PAGE_SIZE_10) {
                weakSelf.collectionView.mj_footer.hidden = NO;
            }else{
                weakSelf.collectionView.mj_footer.hidden = YES;
            }
           
         });
    }else{
    }
}
 
 
@end

 
