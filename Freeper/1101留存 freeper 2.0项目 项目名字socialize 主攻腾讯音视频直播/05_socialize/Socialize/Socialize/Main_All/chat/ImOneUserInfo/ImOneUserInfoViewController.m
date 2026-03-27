//
//  ImOneUserInfoViewController.m
//  Socialize
//
//  Created by 余莹 on 2023/5/30.
//

#import "ImOneUserInfoViewController.h"
#import "IMUserInfoHeaderImg.h"
#import "NftBaseCollectionViewCell.h"
#define  Item_W  ((Screen_W-44)/3)
#define  Item_H  (175.0)
#define  ChooseType_H (60)
#define  ChooseType_W (Screen_W/3)

#import "IMBase.h"
#import "ImChatVc.h"

#import "TUIChatConversationModel.h"
#import "FenYouFreeIdInfoModel.h"

#import "NFTAddressModel.h"
#import "NftDetailWebVc.h"
#import <TUIBaseChatViewController_Minimalist.h>
#import <TUIGroupChatViewController_Minimalist.h>
#import <TUIC2CChatViewController_Minimalist.h>



 
typedef enum : NSUInteger {
    NFT_Type_MyYou,
    NFT_Type_MyFen,
    NFT_Type_MyFreeID,
} NFT_Type;
 
@interface ImOneUserInfoViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) IMUserInfoHeaderImg *topView;;
@property (nonatomic,strong) UIView *biaoQianChangeBackView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *fenQuandataArr;
@property (nonatomic,strong) NSMutableArray *youQuandataArr;
@property (nonatomic,strong) NSMutableArray *fIDdataArr;
@property (nonatomic,assign) NFT_Type nowChooseNftType;
@property (nonatomic,strong) NSMutableArray *nftAddressSaveArr;
@end
//框

@implementation ImOneUserInfoViewController
#pragma mark ==
- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = @[].mutableCopy;
    }
    return _dataArr;
}

- (NSMutableArray *)fenQuandataArr{
    if(!_fenQuandataArr){
        _fenQuandataArr = @[].mutableCopy;
    }
    return _fenQuandataArr;
}

- (NSMutableArray *)youQuandataArr{
    if(!_youQuandataArr){
        _youQuandataArr = @[].mutableCopy;
    }
    return _youQuandataArr;
}

- (NSMutableArray *)fIDdataArr{
    if(!_fIDdataArr){
        _fIDdataArr = @[].mutableCopy;
    }
    return _fIDdataArr;
}

#pragma mark ==
- (IMUserInfoHeaderImg *)topView{
    if(!_topView){
        _topView = [[IMUserInfoHeaderImg alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 120)];
        [_topView.callSiXinBtn addTarget:self action:@selector(siXinBtnAction) forControlEvents:UIControlEventTouchUpInside];//私信
    }
    return _topView;
}
- (UIView *)biaoQianChangeBackView{
    if(!_biaoQianChangeBackView){
        _biaoQianChangeBackView = [[UIView alloc]init];
    }
    return _biaoQianChangeBackView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 60, Screen_W, Screen_H-KNavBarHeight-60) collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[NftBaseCollectionViewCell class] forCellWithReuseIdentifier:NftBaseCollectionViewCell_I];
        [_collectionView registerClass:[NftBaseCollectionViewCell_ShowMoney class] forCellWithReuseIdentifier:NftBaseCollectionViewCell_ShowMoney_I];

        _collectionView.scrollEnabled = YES;
         
    }
    return _collectionView;
}
#pragma mark ===
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfViews];
//    [self initRightItems];//暂时隐藏本按钮
    [self initViews];
    self.nowChooseNftType = 0;
    [self initDatas];
    [self setNeedsStatusBarAppearanceUpdate];//顶部状态栏主题相关
}

//顶部状态栏主题相关
- (UIStatusBarStyle)preferredStatusBarStyle{
    if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
        return UIStatusBarStyleDarkContent ;//黑色内容
    }else{
        return UIStatusBarStyleLightContent;//白色内容
    }
}


- (void)initSelfViews{
    //渐变
    GreenAndJianBianBkView *bgColorView = [[GreenAndJianBianBkView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:bgColorView];
 
}

- (void)initRightItems{
    UIBarButtonItem *rightMaxItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"更多"] style:UIBarButtonItemStylePlain target:self action:@selector(rightNavItemAction)];
    [self.navigationItem setRightBarButtonItems:@[rightMaxItem] animated:YES];

}
- (void)initViews{
    self.view.backgroundColor = rgba(248, 248, 248, 1);
    [self.view addSubview:self.topView];
    [self.view addSubview:self.biaoQianChangeBackView];
    [self.view addSubview:self.collectionView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.superview).offset(KNavBarHeight);
        make.left.right.equalTo(_topView.superview).offset(0);
        make.height.offset(120);
    }];
    
    [_biaoQianChangeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom).offset(10);
        make.left.right.equalTo(_topView.superview);
        make.height.offset(ChooseType_H);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_biaoQianChangeBackView.mas_bottom);
        make.left.right.equalTo(_collectionView.superview);
        make.bottom.equalTo(_collectionView.superview).offset(-20-kBottom_SafeHeight);
    }];
    
    _biaoQianChangeBackView.backgroundColor = [UIColor whiteColor];//Color_Socialize_GreenColor;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    //中间类型切换项目
    UIImage *typeBottomImg = [UIImage imageWithColor:rgba(51, 51, 51, 1) size:CGSizeMake(24, 2)];
    NSArray *typeChooseArr = @[@"TA的友圈",@"TA的粉圈",@"TA的FreeID"];
    for (int i = 0; i < typeChooseArr.count; i++) {
        UIButton *chooseTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseTypeBtn.frame = CGRectMake(10+(i*(ChooseType_W-10)), 0, ChooseType_W, ChooseType_H);
        [chooseTypeBtn addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
        chooseTypeBtn.tag = 700+i;
        [chooseTypeBtn newAnBtnWithTextStr:typeChooseArr[i]];
        [chooseTypeBtn newAnBtnWithFont:[UIFont systemFontOfSize:16.0]];
        [chooseTypeBtn newAnBtnWithTextColorNomal:rgba(102, 102, 102, 1) withTextColorSelected:rgba(51, 51, 51, 1)];
        [chooseTypeBtn newAnBtnWithNomalImg:[UIImage new] selectedImg:typeBottomImg];
        [chooseTypeBtn layoutButtonWithEdgeInsetsStyle: GLButtonEdgeInsetsStyleBottom imageTitleSpace:10];
        [_biaoQianChangeBackView addSubview:chooseTypeBtn];
        if(i == 0){
            chooseTypeBtn.selected = YES;
        }
        
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
 
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (UIColor *)navBackColor {
    return [UIColor clearColor];;
}
 
 - (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setup_NavigationBar_TransparentBk_blackText];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithDefaultBackground];
        appearance.shadowColor = nil;
        appearance.backgroundEffect = nil;
        appearance.backgroundColor =  [self navBackColor];
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        navigationBar.backgroundColor = [self navBackColor];
        navigationBar.barTintColor = [self navBackColor];
        navigationBar.shadowImage = [UIImage new];
        NSDictionary *attDic = @{
            NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
            NSForegroundColorAttributeName:[UIColor blackColor]};
        navigationBar.titleTextAttributes = attDic;
        navigationBar.standardAppearance = appearance;
        navigationBar.scrollEdgeAppearance= appearance;
        
    }
    else {
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        navigationBar.backgroundColor = [self navBackColor];
        navigationBar.barTintColor = [self navBackColor];
        navigationBar.shadowImage = [UIImage new];
        [[UINavigationBar appearance] setTranslucent:NO];
    } 

}
#pragma mark ===
- (void)initDatas{
    self.dataArr = @[].mutableCopy;
    [self.collectionView reloadData];
    [self getMixPayment];//获取配置
    [self getUserInfo];
}

#pragma mark ===

#define mixPayment_subFix           @"/config/mixPayment"
- (void)getMixPayment{
    WEAKSELF
    NSString *allUrl = [NSString stringWithFormat:@"%@%@",URL_Main_URL_Prefix,mixPayment_subFix];
    [[Y_NetWorkBaseTool sharedTool]YrequestGetALLURL:allUrl
                                          withParams:@{ }.mutableCopy
                                            finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success_status) {
                
                NSMutableDictionary *getDataDic  = Y_ResponsObject_dataDic;
                if([[getDataDic allKeys]containsObject:@"nftAddresses"]){
                    weakSelf.nftAddressSaveArr = [NSMutableArray arrayWithArray: [getDataDic objectForKey:@"nftAddresses"]];
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MESSAGE
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
            
    }];
}
#pragma mark ===

#define GetFreeperIDList_SubUrl @"/user/home/domain/list"
#define GetFenYouList_SubUrl @"/chatGroup/getUserGroupAllReqDto"
#define  data_records_Key                   @"records"

- (void)getUserInfo{
    NSLog(@"fid ==== %@",self.friendId);
    NSLog(@"addressShowStr ==== %@",self.addressShowStr);
    NSLog(@"headerImgstr ==== %@",self.headerImgstr);
    
    self.topView.nameL.text = [self suoDuanAddressStr:self.addressShowStr];
    
    [self.topView.addressBtn setTitle:self.friendId forState:UIControlStateNormal];
    self.topView.addressBtn.hidden = YES;//隐藏掉
    [self.topView.imgView sd_setImageWithURL: [UrlWithString getURLWithStr:self.headerImgstr] placeholderImage:[UIImage imageWithColor:[UIColor lightGrayColor]]];
    [self getFenYouList];
    [self getFreeIdList];

}

//长度0816
#define Free_SubStr @".free"
- (NSString *)suoDuanAddressStr:(NSString *)addressStrOrDomainStr{
    
    NSInteger Free_SubStrLen = Free_SubStr.length;
    if(addressStrOrDomainStr.length <= Free_SubStrLen){
        return addressStrOrDomainStr;
    }
    
    NSString *subfixStr = [addressStrOrDomainStr substringFromIndex:addressStrOrDomainStr.length-5];
    if([subfixStr isEqualToString:Free_SubStr]){//域名模样的nike
        if(addressStrOrDomainStr.length>16){//前四后4+5==9个 中间拼*号
            NSString *okStr = @"";
            //取后四位和前四位
            NSString *preStr = [addressStrOrDomainStr substringToIndex:4];
            NSString *suStr = [addressStrOrDomainStr substringFromIndex: addressStrOrDomainStr.length-(4+Free_SubStrLen)];//倒数4的字符 加上后缀 位置截取
            okStr = [NSString stringWithFormat:@"%@...%@",preStr,suStr];
            return okStr;
        }else{//没超过16
            return addressStrOrDomainStr;//返回整个
        }
    }else{//非域名模样 昵称或者0x地址
        if( addressStrOrDomainStr.length > 12){ //12位以上 就*
            NSString *okStr = @"";
//            取后6位和前6位
            NSString *preStr = [addressStrOrDomainStr substringToIndex:6];
            NSString *suStr = [addressStrOrDomainStr substringFromIndex: addressStrOrDomainStr.length-6];//倒数6的位置截取
            okStr = [NSString stringWithFormat:@"%@...%@",preStr,suStr];
            return  okStr;

        }else if ( addressStrOrDomainStr.length > 0){
            return addressStrOrDomainStr;
            
        }else{
            return @"-";//@"地址缺失"
        }
    }
   
}

- (void)getFreeIdList{
    NSString *allUrl = [NSString stringWithFormat:@"%@%@",URL_Main_URL_Prefix,GetFreeperIDList_SubUrl];
    //域名
    WEAKSELF
    [[Y_NetWorkBaseTool sharedTool]YYrequestALLURLGetNotMainQueue:allUrl withParams:@{@"imId":self.friendId}.mutableCopy finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success_status) {
                NSMutableArray *getArrs  = Y_ResponsObject_dataArr;
                weakSelf.fIDdataArr = [NSMutableArray arrayWithArray: [FenYouFreeIdInfoModel mj_objectArrayWithKeyValuesArray:getArrs]];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MESSAGE
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
        
    }];
}

- (void)getFenYouList{
    
    NSMutableDictionary *fenParms = @{@"imId":self.friendId,
                                      @"category":@"fans",
                                      @"page":@"1",
                                      @"count":@"99999",
                                      
    }.mutableCopy;
    
    NSMutableDictionary *youParms = @{@"imId":self.friendId,
                                      @"category":@"friend",
                                      @"page":@"1",
                                      @"count":@"99999",
                                      
    }.mutableCopy;
    
    
    NSString *allUrl = [NSString stringWithFormat:@"%@%@",URL_Main_URL_Prefix,GetFenYouList_SubUrl];
    //粉圈
    WEAKSELF
    [[Y_NetWorkBaseTool sharedTool]YrequestPostALLURLNoMainQueueWithBodyNotParms:allUrl withBody:fenParms finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success_status) {
                NSDictionary *dataDic = Y_ResponsObject_dataDic;
                NSMutableArray *getArrs =  ( [[dataDic allKeys] containsObject:data_records_Key] && isNotNil([dataDic objectForKey:data_records_Key]) ) ? [dataDic objectForKey:data_records_Key] : [NSMutableArray array];
                weakSelf.fenQuandataArr = [NSMutableArray arrayWithArray: [FenYouFreeIdInfoModel mj_objectArrayWithKeyValuesArray:getArrs]];
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MESSAGE
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
        
    }];
    //友圈
    [[Y_NetWorkBaseTool sharedTool]YrequestPostALLURLNoMainQueueWithBodyNotParms:allUrl withBody:youParms finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success_status) {
                NSDictionary *dataDic = Y_ResponsObject_dataDic;
                NSMutableArray *getArrs =  ( [[dataDic allKeys] containsObject:data_records_Key] && isNotNil([dataDic objectForKey:data_records_Key]) ) ? [dataDic objectForKey:data_records_Key] : [NSMutableArray array];
                weakSelf.youQuandataArr = [NSMutableArray arrayWithArray: [FenYouFreeIdInfoModel mj_objectArrayWithKeyValuesArray:getArrs]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.collectionView reloadData];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MESSAGE
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
        
    }];
}

#pragma mark ===
- (void)rightNavItemAction{
    DLog()
}
- (void)siXinBtnAction{
    DLog(@"私信");
    
    TUIChatConversationModel *conversationModel = [[TUIChatConversationModel alloc] init];
    conversationModel.userID = self.friendId;
    conversationModel.title = self.addressShowStr;

    TUIBaseChatViewController_Minimalist *chatVC = nil;
    if (conversationModel.groupID.length > 0) {
        chatVC = [[TUIGroupChatViewController_Minimalist alloc] init];
    } else if (conversationModel.userID.length > 0) {
        chatVC = [[TUIC2CChatViewController_Minimalist alloc] init];
    }
    chatVC.conversationData = conversationModel;
    chatVC.title = conversationModel.title;
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
    

    
}
- (void)changeType:(UIButton *)sender{

  NSInteger index =  sender.tag - 700;
    DLog(@" changeType ---- %ld",(long)index);
    self.nowChooseNftType = index;
    dispatch_async(dispatch_get_main_queue(), ^ {  //加入到主线程，强制执行reload
        [self.collectionView reloadData];
    });
  

    for ( UIButton *btns in self.biaoQianChangeBackView.subviews) {
        if(   btns.tag - 700 == index){
            btns.selected = YES;
        }else{
            btns.selected = NO;
        }
    }
    
}

#pragma mark ===

#pragma mark - UICollectionViewDelegateFlowLayout
//动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Item_W, Item_H);
   
}

//动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 10, 0, 10);//某Section总的上下左右
}

//动态设置每列的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}
//动态设置每行的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

//动态设置某个分区头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(Screen_W, 10);
}
//动态设置某个分区尾视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(Screen_W, 10);
}
#pragma mark ==

//代理相应方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    switch (self.nowChooseNftType) {
        case NFT_Type_MyYou:
        {
            return self.youQuandataArr.count;
        }
            break;
        case NFT_Type_MyFen:
        {
            return self.fenQuandataArr.count;
        }
            break;
        case NFT_Type_MyFreeID:
        {
            return self.fIDdataArr.count;
        }
            break;
            
        default:
            break;
    }
    return self.dataArr.count;

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    switch (self.nowChooseNftType) {
        case NFT_Type_MyYou: case NFT_Type_MyFen://友
        {
            NftBaseCollectionViewCell_ShowMoney * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:NftBaseCollectionViewCell_ShowMoney_I forIndexPath:indexPath];
            
             FenYouFreeIdInfoModel *model = self.youQuandataArr[indexPath.row];
            [cell.nftImgV sd_setImageWithURL:[UrlWithString getURLWithStr:model.profileImageUrl] placeholderImage:[UIImage imageNamed:@"Free_RobotIcon"]];
            cell.nftLabel.text = [NSString stringWithFormat:@"%@#%@",model.domain, model.nftId];
            cell.mongyL.text = [NSString stringWithFormat:@"%0.4f",model.lastDealPrice];//@"mmm.9999";
            //lastDealSymbol 类型
            [cell.moneyIcon sd_setImageWithURL:[UrlWithString getURLWithStr:@""] placeholderImage:[UIImage new]];
            return cell;
        }
            break;
            
        case NFT_Type_MyFreeID://FID
        {
            NftBaseCollectionViewCell * cell_f  = [collectionView dequeueReusableCellWithReuseIdentifier:NftBaseCollectionViewCell_I forIndexPath:indexPath];

            FenYouFreeIdInfoModel *model = self.fIDdataArr[indexPath.row];
            [cell_f.nftImgV sd_setImageWithURL:[UrlWithString getURLWithStr:model.profileImageUrl] placeholderImage:[UIImage imageNamed:@"Free_RobotIcon"]];
            cell_f.nftLabel.text = model.domain;
            return cell_f;
        }
            break;
            
        default:
        {
            return [[UICollectionViewCell alloc]init];
        }
            break;
            
    }
 

    
 

    
}


#define DetailUrl_pfix  @"/pages/nft/details"
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"%ld",(long)indexPath.row);
    FenYouFreeIdInfoModel *cellModel = self.fIDdataArr[indexPath.row];
    NSString *willUseSubStr = [cellModel.domain componentsSeparatedByString:@"."].lastObject;
    if(willUseSubStr.length <= 0){
        return;//没有后缀数据
    }
    NSString *willNeedNftAddressStr = @"";
    for (int i = 0;  i < self.nftAddressSaveArr.count; i++) {
        NFTAddressModel *nftPaymentModel = [NFTAddressModel mj_objectWithKeyValues:self.nftAddressSaveArr[i]];
        if([nftPaymentModel.suffix isEqualToString:willUseSubStr]){
            willNeedNftAddressStr = nftPaymentModel.contactAddress;
            break;
        }
    }
    if(willNeedNftAddressStr.length <= 0){
        return;//没有对应数据
    }
    
    NSString *willUseInfo_NftId = [TextShowWithModelStr textShowWithModelStr:cellModel.nftId];
    NSString *willUseInfo_NftAddress = willNeedNftAddressStr;
    NSString *willUseInfo_WebUrl = [NSString stringWithFormat:@"%@%@?nftId=%@&nftAddress=%@",WebVc_Base_URL,DetailUrl_pfix,willUseInfo_NftId,willUseInfo_NftAddress];
    DLog(@"willUseInfo_WebUrl -- %@",willUseInfo_WebUrl);
    NftDetailWebVc *vc = [[NftDetailWebVc alloc]init];
    vc.nftDetailAllUrl = willUseInfo_WebUrl;
    [self pushVc:vc];
}

@end
