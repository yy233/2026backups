//
//  ZhiBoMyListVC.m
//  Socialize
//
//  Created by 余莹 on 2023/7/1.
//

#import "ZhiBoMyListVC.h"
#import "LiveRoomBase.h"
#import "VoiceRoomBase.h"
#import "DiscoverTopView.h"
#import "DiscoverTopCollectionView.h"
#import "ZhiBoMainListSubCollectionViewCell.h"
#import "ZhiBoMyListCollectionViewCell.h"
#import "DiscoverDetailViewController.h"
#import "ZhiBoBaseInfoInputAndCreateLiveOrVoiceTypeRoomChooseVc.h"
#import "Socialize-Swift.h"
#import "CreatOfBottomBtnView.h"

//#define  Item_W ((Screen_W-32)*0.5-5)
//#define  Item_H ((Screen_W-32)*0.5-5 + 65)

#define  Item_W ((Screen_W-32)-5)
#define  Item_H (Item_W *0.5 + 65)

#define DiscoverMainCollectionViewCell_I @"DiscoverMainCollectionViewCell"
#import "FBKVOController.h"
#import "ZhiBoListViewModel.h"
#import "BaseAlertManager.h"
#import "WaitForKaiBoViewController.h"
#import "ZhiBoNetTool.h"
@interface ZhiBoMyListVC () <UICollectionViewDelegate,UICollectionViewDataSource>
//kvo
{
    FBKVOController *fbKVO;
    dispatch_source_t gcdTimer;
}
@property (nonatomic,strong) ZhiBoMyListViewModel *viewModel;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
 
@end

@implementation ZhiBoMyListVC

- (NSMutableArray *)dataSourceArr{
    if(!_dataSourceArr){
        _dataSourceArr = @[].mutableCopy;
    }
    return _dataSourceArr;
}

//@property (nonatomic,strong) DiscoverTopView *discoverTopView;
//- (DiscoverTopView *)discoverTopView{
//    if(!_discoverTopView){
//        _discoverTopView = [DiscoverTopView instaceThisViewSelf];
//    }
//    return _discoverTopView;
//}

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
        [_collectionView registerClass:[ZhiBoMyListCollectionViewCell class] forCellWithReuseIdentifier:DiscoverMainCollectionViewCell_I];
        _collectionView.scrollEnabled = YES;
    }
    return _collectionView;
    
}

#pragma mark ============================================
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addKvo];
    [self initSelfViews];//界面
    [self addRefresh];
    [self initListData];
}
#pragma mark ====

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //qing ko
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
        
        [self setupNavigationBarblackTextColorWithBackViewCustomColor:[UIColor tui_colorWithHex: Theme_Nav_COlOR_Light_Str]];
    }else{
        [self setupNavigationBarWhiteTextColorWithBackViewCustomColor:[UIColor tui_colorWithHex:Theme_Nav_COlOR_Drak_Str]];
    }
    
    
    
    //    UIColor *textColor = [UIColor grayColor];
    //    if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
    //        textColor  = Color_51BlackColor;
    //    }else{
    //        textColor = [UIColor whiteColor];
    //    }
    //    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    //    NSDictionary *attDic = @{
    //        NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
    //        NSForegroundColorAttributeName:textColor};
    //
    //    if (@available(iOS 15.0, *)) {
    //        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
    //        [appearance configureWithDefaultBackground];
    //        navigationBar.titleTextAttributes = attDic;
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
    //        navigationBar.titleTextAttributes = attDic;
    //        navigationBar.backgroundColor = [self navBackColor];
    //        navigationBar.barTintColor = [self navBackColor];
    //        navigationBar.shadowImage =  [UIImage new];// Y_gray_img;
    //        [[UINavigationBar appearance] setTranslucent:NO];
    //    }
    
    self.title = Y_LocaleTypeFile_NSLocalString(@"我的直播");
    //界面切换时也要做timer的
    if(self.dataSourceArr.count >0){
        [self upDataTimerrrInfo];
    }
    
    
    
}
- (UIColor *)navBackColor {
    if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
        //        return [UIColor whiteColor];
        return [Y_ToolOfOthers getColorWithHexString:Theme_Nav_COlOR_Light_Str];
    }else{
        //        return  Color_51BlackColor;
        return [Y_ToolOfOthers getColorWithHexString:Theme_Nav_COlOR_Drak_Str];
    }
}

#pragma mark =================================== view infoThings
- (void)initSelfViews{
    
    //    if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
    //        self.view.backgroundColor = [UIColor whiteColor];//切到当前页时 上页残留view暂留视觉可解决
    //    }else{
    //        self.view.backgroundColor = Color_51BlackColor;//切到当前页时 上页残留view暂留视觉可解决
    //
    //    }
    if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
        self.view.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str]; //底部背景露出一截了
    }else{
        self.view.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Drak_Str ];;
    }
    
    [self.view addSubview:self.collectionView];
    //120-btns30 -- 底部位置60-15=45 --top25
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_collectionView.superview).offset(-32);
        make.centerX.equalTo(_collectionView.superview);
        make.top.equalTo(_collectionView.superview).offset(0);
        make.bottom.equalTo(_collectionView.superview).offset(-kBottom_SafeHeight-20);//不能贴地-20
    }];
    //other
    //[self addNavItem];
}

- (void)addNavItem{
    UIBarButtonItem *rightMaxItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"我的"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightNavItemAction)];
    [self.navigationItem setRightBarButtonItems:@[rightMaxItem] animated:YES];
    
}
- (void)rightNavItemAction{
    //我的直播
    NSLog(@"rightNavItemAction");
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initListData)];
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upDataListData)];//暂无
    self.collectionView.mj_header = headeerRefresh;
    self.collectionView.mj_footer = footerRefresh;
    self.collectionView.mj_footer.hidden = YES;
}


#pragma mark ============================================ data
- (ZhiBoMyListViewModel *)viewModel{//activity/auth/getUse你rActivityList
    if (!_viewModel) {
        _viewModel = [[ZhiBoMyListViewModel alloc]init];
    }
    return _viewModel;
}
- (void)initListData{
    if([ShareUserInfo share].userInfo.address.length <= 0){
        return;
    }
    
    //我的直播列表thisParms只有页数相关。 0908增入个人信息
    self.viewModel.thisParms = @{
        @"account":[ShareUserInfo share].userInfo.address
    }.mutableCopy;
    //请求第一页
    [self.viewModel getDataListOnePage];
    
}
- (void)upDataListData{
    if([ShareUserInfo share].userInfo.address.length <= 0){
        return;
    }
    //加载更多
    [self.viewModel getDataListNextPage];
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
                Y_SVP_SHOW_SUCCESS_MES(weakSelf.viewModel.showMsgStr);//成功有提示
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_MES(weakSelf.viewModel.showMsgStr);//请求失败有提示
            });
        }
    }else  if ([fbKvoKeyPath isEqualToString:kViewModel_dataOfArr]) {//data
        
        self.dataSourceArr = [self newallListWithDealDateInfoWithGetDataSourceArr:weakSelf.viewModel.dataOfArr];//mj_objectArrayWithKeyValuesArray:];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [self.collectionView reloadData];
            if (weakSelf.viewModel.dataOfArr.count >= Y_PAGE_SIZE_10) {
                weakSelf.collectionView.mj_footer.hidden = NO;
            }else{
                weakSelf.collectionView.mj_footer.hidden = YES;
            }
            
        });
        [weakSelf upDataTimerrrInfo];//倒计时数据计算初始
        
    }else{
    }
}

//startDatetime//处理后用新的本地时间作展示
- (NSMutableArray *)newallListWithDealDateInfoWithGetDataSourceArr:(NSArray *)dataSourceArr{
    NSMutableArray *dealOkArr = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0 ; i <dataSourceArr.count; i++) {
        ZhiBoShowInfoModel *model = dataSourceArr[i];
        NSLog(@"前端 是加UTC  转成时间戳 再转成本地时间的 =前  %@", model.startDatetime);
        model.startDatetime = [self zhuanLocaTimeWithGetSt:[TextShowWithModelStr textShowWithModelStr:model.startDatetime]];
        NSLog(@"前端 是加UTC  转成时间戳 再转成本地时间的 =后  %@", model.startDatetime);
        [dealOkArr addObject:model];
    }
    return dealOkArr;
    
}
- (NSMutableArray *)allListWithDealDateInfoWithGetDataSourceArr:(NSArray *)dataSourceArr{
    NSMutableArray *dealOkArr = [[NSMutableArray alloc]initWithCapacity:0];
    //转本地时间 ---前端 是加UTC  转成时间戳再转成本地时间的
//    NSString *UTC = @"UTC";
    for ( ZhiBoShowInfoModel *model  in dataSourceArr) {
        
//        NSString *getSt = [NSString stringWithFormat:@"%@ %@",model.startDatetime,UTC];
        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//        [formatter setDateStyle:NSDateFormatterMediumStyle];
//        [formatter setTimeStyle:NSDateFormatterShortStyle];
//        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
//        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//        [formatter setTimeZone:timeZone];
//
//        NSDate* thisDate = [formatter dateFromString:getSt]; //------------将字符串按formatter转成nsdate
//        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[thisDate timeIntervalSince1970]*1000];
//        NSLog(@"前端 是加UTC  转成时间戳 =  %@",timeSp);
//
//        NSDateFormatter *formatterY = [[NSDateFormatter alloc] init] ;
//        [formatterY setDateStyle:NSDateFormatterMediumStyle];
//        [formatterY setTimeStyle:NSDateFormatterShortStyle];
//        [formatterY setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//        NSTimeZone* timeZoneY = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//        [formatterY setTimeZone:timeZoneY];
//
//        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeSp integerValue]];
//        NSString *confromTimespStr = [formatterY stringFromDate:confromTimesp];
//        NSLog(@"前端 是加UTC  转成时间戳 再转成本地时间的 =  %@",timeSp);
        NSLog(@"前端 是加UTC  转成时间戳 再转成本地时间的 =前  %@", model.startDatetime);
        model.startDatetime = [self zhuanLocaTimeWithGetSt:[TextShowWithModelStr textShowWithModelStr:model.startDatetime]];
        NSLog(@"前端 是加UTC  转成时间戳 再转成本地时间的 =后  %@", model.startDatetime);
    }
    
    //0922排序由接口处理
    //谓词排序隐藏
    /**
     NSSortDescriptor *sorter = [[NSSortDescriptor alloc]initWithKey:@"startDatetime" ascending:YES];//ascending:YES 代表升序 如果为NO 代表降序
     NSMutableArray *sortDescriptors = @[sorter].mutableCopy;
     NSArray *sortArray = [dataSourceArr sortedArrayUsingDescriptors:sortDescriptors];//顺序后的模型数组
     NSLog (@"sortArray - %@",sortArray);
     dealOkArr = [NSMutableArray arrayWithArray:sortArray];
     
     return dealOkArr;
     */
  
    return dataSourceArr.mutableCopy;

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



#pragma mark ============================================

#pragma mark == collectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(Screen_W-32, 10);
}
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind  withReuseIdentifier:DiscoverMainCollectionViewCell_I   forIndexPath:indexPath];
////    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
////        MoreMenuSectionHeaderModle *model = self.dataSourceArr[indexPath.section];
////        MoreMenuCollectionHeaderView *sectionHeader = [[MoreMenuCollectionHeaderView alloc]initWithFrame:CGRectZero];
////        [sectionHeader headerTitleTest:model.menuName];
////        [view addSubview:sectionHeader];
////    }
// return view;
//}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZhiBoMyListCollectionViewCell *cell = (ZhiBoMyListCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:DiscoverMainCollectionViewCell_I  forIndexPath:indexPath];
    if (!cell) {
        cell = [[ZhiBoMyListCollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, Item_W, Item_H)];
    }

    ZhiBoShowInfoModel *model = self.dataSourceArr[indexPath.row];
    NSURL *imgu = [UrlWithString getURLWithStr: [self getPicutWithStr:model.picture].firstObject];
    //NSLog(@"imgu ---  %@",imgu);
    [cell.bkimgView sd_setImageWithURL:imgu placeholderImage:[UIImage imageWithColor:Color_238GrayColor size:CGSizeMake(Item_W, Item_W)]];

    cell.zhuBoUserNameLabel.text = [TextShowWithModelStr textShowWithModelStr: model.username];
    if( cell.zhuBoUserNameLabel.text.length > 0){
        cell.zhuBoUserNameLabel.hidden = NO;
    }else{
        cell.zhuBoUserNameLabel.hidden = YES;
    }
    cell.titleLabel.text = [TextShowWithModelStr textShowWithModelStr: model.title];//倒计时的位置 初始用本行处理文本 之后展示时则倒计时计算
    // NSLog(@"%@ initTimeInfoWithModelStartDatetime %@",model.title,[TextShowWithModelStr textShowWithModelStr:model.startDatetime]);
    if(model.recode.length>0){
        [cell.pubOrPivTypeBtn newAnBtnWithTextStr: Y_LocaleTypeFile_NSLocalString(@"私密")];//@"recode"//有值表示私密直播，无值表示公共直播
    }else{
        [cell.pubOrPivTypeBtn newAnBtnWithTextStr: Y_LocaleTypeFile_NSLocalString(@"公开")];
    }
    [cell.zhiBoTypeBtn newAnBtnWithTextStr: (model.state == 2) ? Y_LocaleTypeFile_NSLocalString(@"语音") : Y_LocaleTypeFile_NSLocalString(@"视频")];
    

    if([model.address isEqualToString:[ShareUserInfo share].userInfo.address]){//是创建者
        switch (model.state) {
                
            case 3:
            {
                [cell.statueTypeBtn newAnBtnWithTextStr:Y_LocaleTypeFile_NSLocalString(@"直播中")];
            }
                break;
            case 4:
            {
                [cell.statueTypeBtn newAnBtnWithTextStr:Y_LocaleTypeFile_NSLocalString(@"已结束")];
             }
                break;
                
            default:
                [cell.statueTypeBtn newAnBtnWithTextStr:Y_LocaleTypeFile_NSLocalString(@"待直播")];
                 break;
                
        }
    }else{
        
        if(model.state == 4){//完结
            [cell.statueTypeBtn newAnBtnWithTextStr:Y_LocaleTypeFile_NSLocalString(@"已结束")];
        }else if(model.state == 3){//直播中
            [cell.statueTypeBtn newAnBtnWithTextStr:Y_LocaleTypeFile_NSLocalString(@"直播中")];
        }else{
           switch (model.isSignUp) {//报名否
               case 0:
               {
                   [cell.statueTypeBtn newAnBtnWithTextStr:Y_LocaleTypeFile_NSLocalString(@"未报名")];
                }
                   break;
               case 1:
               {
                   [cell.statueTypeBtn newAnBtnWithTextStr:Y_LocaleTypeFile_NSLocalString(@"已报名")];
                }
                   break;
                   
               default:
                   [cell.statueTypeBtn newAnBtnWithTextStr:Y_LocaleTypeFile_NSLocalString(@"未报名")];//我的直播
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
    //去看直播 在我的列表 一定是 isSignUp == 1的
    model.isSignUp = 1;
    if([model.address isEqualToString:[ShareUserInfo share].userInfo.address]){//是创建者
        switch (model.state) {
                
            case 3:
            {
                //@"直播中"; ---继续直播
        
//                [self goToZhiBoVcWithCreatUserWithThisZhiBoInfoMode:model];
                [self checkZhiBoInfoWithDetailsId:model.activityId withJixuBool:YES];
                
                
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
                //[self goToZhiBoVcWithCreatUserWithThisZhiBoInfoMode:model];
                [self checkZhiBoInfoWithDetailsId:model.activityId withJixuBool:YES];
                
            }
                break;
                
        }
    }else{//非创建者
        if([ShareUserInfo share].userInfo.address.length <= 0){//未登录
            // @"未报名"---- 登录shwo
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
                        
                    {
                        [self goToBaoMingWithInfoMode:model];//@"未报名";
                    }
                        break;
                }
            }
            
        }
    }
    
}
#pragma mark ===



#pragma mark ===
- (void)checkZhiBoInfoWithDetailsId:(NSString *)detailsId withJixuBool:(BOOL)jiXuBool{
    DLog(@"0901 增入roomid 查询");
    WEAKSELF
    [[ZhiBoNetTool share] getOneZhiBoDetailInfoWithActivityID:detailsId withBlock:^(NSDictionary * _Nonnull dicOfBlock, BOOL succes) {

        if(succes){
            ZhiBoShowInfoModel *model = [ZhiBoShowInfoModel mj_objectWithKeyValues:dicOfBlock];
            if(jiXuBool){
                [weakSelf goToZhiBoVcWithCreatUserWithThisZhiBoInfoMode:model];

            }else{//jiXuBool == no 去看直播
                [weakSelf aleatOk_LookerGotoZhiBoWithInfoMode:model];
            }
        }

    }];



}


 



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
            Y_SVP_SHOW_ERR_MES(  Y_LocaleTypeFile_NSLocalString(@"无房间ID，不能开播") ) ;
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
            
            [weakSelf pushVc:vc];
            
        }else{
            DLog(@"进语音房间失败");
        }
    }];
}

#pragma mark ===//去看直播
- (void)goiToZhiBoVcLookerTypeWithInfoMode:(ZhiBoShowInfoModel*)zhiBoInfoModel{
//    NSString *showMsg = @"";
//    if(zhiBoInfoModel.category == 2){
//        showMsg = [NSString stringWithFormat:@"去看'%@'语音直播？",zhiBoInfoModel.title];
//    }else{
//        showMsg = [NSString stringWithFormat:@"去看'%@'视频直播？",zhiBoInfoModel.title];
//    }
    
    
    
    NSString *showMsg = @"";
    NSString *quKan =  Y_LocaleTypeFile_NSLocalString(@"去看");
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
//            [self aleatOk_LookerGotoZhiBoWithInfoMode:zhiBoInfoModel];
            [self checkZhiBoInfoWithDetailsId:zhiBoInfoModel.activityId withJixuBool:NO];
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
                [weakSelf pushVc:vc];
                
            }else{
                DLog(@"进语音房间失败");
            }
        }];
        
    }else if(zhiBoInfoModel.category == 1){//1视频
        NSString *roomNameStr = [TextShowWithModelStr textShowWithModelStr:zhiBoInfoModel.title];
        if([TextShowWithModelStr textShowWithModelStr:zhiBoInfoModel.recode].length > 0){//私密直播
            [LiveRoomBase liveTypeLookerGotoVcWithRoomNameStr:roomNameStr
                                               withActivityId:zhiBoInfoModel.activityId
                                  withThisLiveRoomEnterRoomID: [zhiBoInfoModel.roomId intValue]
                                           withResPasswordStr:[TextShowWithModelStr textShowWithModelStr:zhiBoInfoModel.recode]
                                                 withOtherDic:@{}];
        }else{
             [LiveRoomBase liveTypeLookerGotoVcWithRoomNameStr:roomNameStr
                                               withActivityId:zhiBoInfoModel.activityId
                                  withThisLiveRoomEnterRoomID: [zhiBoInfoModel.roomId intValue] ];
        }
    }
}

#pragma mark ============================================
//倒计时相关
- (void)upDataTimerrrInfo{
    [self timerPpause];//每次重新更新处理数据
    
    WEAKSELF
    //创建GCD定时器
    gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0)); //    //将定时器写成属性，是因为内存管理的原因，使用了dispatch_source_create方法，这种方法GCD是不会帮你管理内存的。
    //设置定时器
    dispatch_source_set_timer(gcdTimer, dispatch_walltime(NULL, 0), 1ull * NSEC_PER_SEC, 0);
    /*
     第二个参数：dispatch_time_t start, 定时器开始时间，类型为 dispatch_time_t，其API的abstract标明可参照dispatch_time()和dispatch_walltime()，同为设置时间，但是后者为“钟表”时间，相对比较准确，所以选择使用后者。dispatch_walltime(const struct timespec *_Nullable when, int64_t delta),参数when可以为Null，默认为获取当前时间，参数delta为增量，即获取当前时间的基础上，增加X秒的时间为开始计时时间，此处传0即可。
     第三个参数：uint64_t interval，定时器间隔时长，由业务需求而定。
     第四个参数：uint64_t leeway， 允许误差，此处传0即可。
    */
    //定时器需要执行的操作
    dispatch_source_set_event_handler(gcdTimer, ^{
        //遍历数据源，计算时间差,并且给对应的cell设置对应的时间差
        for (int index = 0; index<weakSelf.dataSourceArr.count; index++) {
            ZhiBoShowInfoModel * model = weakSelf.dataSourceArr[index];
            model.daoJiShiUseTimeIv = [weakSelf dateTimeIntervalWithEndTimeStr:model.startDatetime withCellRomIndexNum:index];
            __block typeof(model) blockModel = model;
            
            dispatch_async(dispatch_get_main_queue(), ^{//主线更新
                NSIndexPath* iph =  [NSIndexPath indexPathForRow:index inSection:0];
                ZhiBoMyListCollectionViewCell * cell = (ZhiBoMyListCollectionViewCell *)[weakSelf.collectionView cellForItemAtIndexPath: iph];
                if(blockModel.daoJiShiUseTimeIv.length>0){
                    [cell upDataTimeInfoWithNowUseDaoJiShiHMSTimeIv:blockModel.daoJiShiUseTimeIv];
                }
            });
        }
    });
    // 启动任务，GCD计时器创建后需要手动启动
    dispatch_resume(gcdTimer);
    
}
- (void)timerPpause{
    if (gcdTimer) {
        dispatch_cancel(gcdTimer);
        gcdTimer = nil;
    }
    NSLog(@"pause gcdTimer --- %@",gcdTimer);
    /**
     停止 Dispatch Timer 有两种方法，一种是使用 dispatch_suspend，另外一种是使用 dispatch_source_cancel。
     dispatch_suspend 严格上只是把 Timer 暂时挂起   dispatch_suspend 之后的 Timer，是不能被释放的 会引起崩溃。
     用 dispatch_source_cancel 则没有这个限制
     */
}

- (NSString *)dateTimeIntervalWithEndTimeStr:(NSString *)startDatetime withCellRomIndexNum:(NSInteger)cellRomIndex{
    WEAKSELF
    if(startDatetime.length <= 0){
        //不符合要求 处理成空串
        return @"";
    }else{
        //有数据 
        /**
         //1转型
         //2判断显示文本还是做倒计时 (之前更新 直到时间OK无需倒计时的 直接给展示文本)
         //3倒计时放到 返回到mode 调cell处理 文本更新
         
         */

        NSInteger timeIv = [[YTimeStamp getTimeIvWithTimeStr_YMDHMS:startDatetime] integerValue];
        NSInteger nowTimeIV = [[YTimeStamp getNowTimeTimestamp_haoMiao] integerValue];
        if(nowTimeIV > timeIv){
            dispatch_async(dispatch_get_main_queue(), ^{//主线更新
                NSIndexPath* iph =  [NSIndexPath indexPathForRow:cellRomIndex inSection:0];
                ZhiBoMyListCollectionViewCell * cell = (ZhiBoMyListCollectionViewCell *)[weakSelf.collectionView cellForItemAtIndexPath: iph];
                cell.kaiBoJuLiTimeLabel.text = [YTimeStamp getTimeMDHMSUseTimeYMDHMSstr:startDatetime];
                cell.kaiBoJuLiTimeTitleLabel.text = Y_LocaleTypeFile_NSLocalString(@"开始时间");
            });
            //展示时间比现在小 已经结束状态 == 展示旧的时间嘛 处理成空串
            return @"";
        }else if(nowTimeIV == timeIv){//更新到相同时间 做cell更新 直接更新MDhms文本
            dispatch_async(dispatch_get_main_queue(), ^{//主线更新
                NSIndexPath* iph =  [NSIndexPath indexPathForRow:cellRomIndex inSection:0];
                ZhiBoMyListCollectionViewCell * cell = (ZhiBoMyListCollectionViewCell *)[weakSelf.collectionView cellForItemAtIndexPath: iph];
                cell.kaiBoJuLiTimeLabel.text = [YTimeStamp getTimeMDHMSUseTimeYMDHMSstr:startDatetime];
                cell.kaiBoJuLiTimeTitleLabel.text = Y_LocaleTypeFile_NSLocalString(@"开始时间");
            });
            return @"";
        }else{
            //返回给Model的数据  做过减法的未来时间 //时间戳 转MDHms
            NSInteger useShowDaoJishiTimeIv = ([YTimeStamp timeIvZhuan10w:timeIv] - [YTimeStamp timeIvZhuan10w:nowTimeIV] );
            return [NSString stringWithFormat:@"%ld",useShowDaoJishiTimeIv];
        }
    }
    
    
}

//界面切换时也要做timer的
 //包括will
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self timerPpause];
}

- (void)dealloc{
    [self timerPpause];
    
}

@end
