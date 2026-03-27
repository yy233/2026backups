//
//  VoiceBottomToolPopView.m
//  TUIVoiceRoom-TUIVoiceRoomKitBundle
//
//  Created by 余莹 on 2023/5/31.
//

#import "VoiceBottomToolPopView.h"
#import "Masonry.h"
#define  Item_W  ( (Screen_W-100)/5 )
#define  Item_H  (75.0)
#import "VoiceOcTool.h"
//#import "TUIVoiceRoom-Swift.h"
#import <TUIVoiceRoom/TUIVoiceRoom-Swift.h>
#import <TUIVoiceRoom/TRTCVoiceRoom.h>
//#import <TUIVoiceRoom/TRTCVoiceRoomViewModel.h>
//#import <TUIVoiceRoom/MsgEntityCustoms.h>
 
#pragma mark === 底部工具Tool popV
  
static NSString *kVoiceBottomToolPopViewSubCell_I = @"VoiceBottomToolPopViewSubCell";

@interface VoiceBottomToolPopView () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) NSArray *imgArr;
@property (nonatomic,strong) NSArray *touchDelegaTypeNumArr;
@property (nonatomic,assign) BOOL isShenHeType;


@end

@implementation VoiceBottomToolPopView
#pragma mark == 重写
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self getShenheInfo];
        [self addSubAllView];
        [self setSubUIs];
    }
    return self;
}
#pragma mark == 内容高度 重写
- (void)initSubMainHeight{
    self.subMainViewHeight  = Screen_H*0.3;
}
#pragma mark == 边角 重写
- (void)changMainBackViewCornerRadius{
    self.subMainBackView.layer.cornerRadius = 30;
    self.subMainBackView.backgroundColor = podUse_rgba(27, 26, 39, 1);
}
- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr{
  
     [self.collectionView reloadData];
}
#pragma mark ==
- (void)addSubAllView{
    [self.subMainBackView addSubview:self.collectionView];
}
- (void)setSubUIs{
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_collectionView.superview).insets(UIEdgeInsetsMake(20, 20, 20, 20));//外层A
    }];
}


#define  userDef_Name_ShenHeInfo       @"userDef_Name_ShenHeInfo"
- (void)getShenheInfo{
    self.isShenHeType =  [[[NSUserDefaults standardUserDefaults] objectForKey:userDef_Name_ShenHeInfo] boolValue];
}

- (NSArray *)titleArr{
    if(!_titleArr){
        if(self.isShenHeType){
            _titleArr = @[
                          voiceRoomLocalize(@"管理成员"),
                          voiceRoomLocalize(@"清除弹幕"),
                          voiceRoomLocalize(@"分享"),
                          voiceRoomLocalize(@"连线设置"),
                          voiceRoomLocalize(@"直播设置"),
    //                      voiceRoomLocalize(@"音效设置"),
                          voiceRoomLocalize(@"管理员"),
//                          voiceRoomLocalize(@"打赏红包"),
                          voiceRoomLocalize(@"聊天"),
                          voiceRoomLocalize(@"关播")];
        }else{
            _titleArr = @[
                          voiceRoomLocalize(@"管理成员"),
                          voiceRoomLocalize(@"清除弹幕"),
                          voiceRoomLocalize(@"分享"),
                          voiceRoomLocalize(@"连线设置"),
                          voiceRoomLocalize(@"直播设置"),
    //                      voiceRoomLocalize(@"音效设置"),
                          voiceRoomLocalize(@"管理员"),
                          voiceRoomLocalize(@"打赏红包"),
                          voiceRoomLocalize(@"聊天"),
                          voiceRoomLocalize(@"关播")];
        }
       
         
     }
    return _titleArr;
}
- (NSArray *)imgArr{
    if(!_imgArr){
        if(self.isShenHeType){
            _imgArr = @[@"管理",@"清除",@"分享",@"连线",@"设置",@"管理员",@"分享",@"退出"];
        }else{
            _imgArr = @[@"管理",@"清除",@"分享",@"连线",@"设置",@"管理员",@"钱包",@"分享",@"退出"];
        }
 
    }
    return _imgArr;
}
- (NSArray *)touchDelegaTypeNumArr{
    if(!_touchDelegaTypeNumArr){
        if(self.isShenHeType){
            _touchDelegaTypeNumArr = @[
                                       @(Voice_Botom_Tool_Type_GuanLiChengYuan),
                                       @(Voice_Botom_Tool_Type_QinChu),
                                       @(Voice_Botom_Tool_Type_FenXiang),
                                       @(Voice_Botom_Tool_Type_LianXianSet),
                                       @(Voice_Botom_Tool_Type_ZhiBoSet),
    //                                   @(Voice_Botom_Tool_Type_YinXiaoSet),
                                       @(Voice_Botom_Tool_Type_GuanLiYuan),
//                                       @(Voice_Botom_Tool_Type_RewardRedEnv),
                                       @(Voice_Botom_Tool_Type_GoToChatWithHasVoiceIng),
                                       @(Voice_Botom_Tool_Type_GuanBi),
            ];
        }else{
            _touchDelegaTypeNumArr = @[
                                       @(Voice_Botom_Tool_Type_GuanLiChengYuan),
                                       @(Voice_Botom_Tool_Type_QinChu),
                                       @(Voice_Botom_Tool_Type_FenXiang),
                                       @(Voice_Botom_Tool_Type_LianXianSet),
                                       @(Voice_Botom_Tool_Type_ZhiBoSet),
    //                                   @(Voice_Botom_Tool_Type_YinXiaoSet),
                                       @(Voice_Botom_Tool_Type_GuanLiYuan),
                                       @(Voice_Botom_Tool_Type_RewardRedEnv),
                                       @(Voice_Botom_Tool_Type_GoToChatWithHasVoiceIng),
                                       @(Voice_Botom_Tool_Type_GuanBi),
            ];
        }
 
    }
    return _touchDelegaTypeNumArr;
}

- (void)changeArrInfoIsGuanZhong{
    if(self.titleArr.count <7){//7个为主播的 如果小于7 则已经更改为观众的 不再更新UI
        return;
    }
    if(self.isShenHeType){
        self.titleArr = @[
                      voiceRoomLocalize(@"清除弹幕"),
                      voiceRoomLocalize(@"分享"),
//                      voiceRoomLocalize(@"打赏红包"),
                      voiceRoomLocalize(@"聊天"),
                      voiceRoomLocalize(@"关播")];
        
        self.imgArr = @[@"清除",@"分享",@"分享",@"退出"];
        
        self.touchDelegaTypeNumArr = @[
                                       @(Voice_Botom_Tool_Type_QinChu),
                                       @(Voice_Botom_Tool_Type_FenXiang),
//                                       @(Voice_Botom_Tool_Type_RewardRedEnv),
                                       @(Voice_Botom_Tool_Type_GoToChatWithHasVoiceIng),
                                       @(Voice_Botom_Tool_Type_GuanBi),
            ];
    }else{
        self.titleArr = @[
                      voiceRoomLocalize(@"清除弹幕"),
                      voiceRoomLocalize(@"分享"),
                      voiceRoomLocalize(@"打赏红包"),
                      voiceRoomLocalize(@"聊天"),
                      voiceRoomLocalize(@"关播")];
        
        self.imgArr = @[@"清除",@"分享",@"钱包",@"分享",@"退出"];
        
        self.touchDelegaTypeNumArr = @[
                                       @(Voice_Botom_Tool_Type_QinChu),
                                       @(Voice_Botom_Tool_Type_FenXiang),
                                       @(Voice_Botom_Tool_Type_RewardRedEnv),
                                       @(Voice_Botom_Tool_Type_GoToChatWithHasVoiceIng),
                                       @(Voice_Botom_Tool_Type_GuanBi),
            ];
    }
   
 
    //self.subMainViewHeight //减少高度无效 collectionView_top给多一点 留一行足够显示了
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_collectionView.superview).insets(UIEdgeInsetsMake(60, 20, 20, 20));//外层A
    }];
    [self.collectionView reloadData];
    
}
#pragma mark ==

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[VoiceBottomToolPopViewSubCell class] forCellWithReuseIdentifier:kVoiceBottomToolPopViewSubCell_I];
        _collectionView.scrollEnabled = YES;
    }
    return _collectionView;
 
}

#pragma mark ==
//动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(Item_W, Item_H);
}

//动态设置每个分区的EdgeInsets｜view轮廓距离v边
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);//cv内的左右
}

//动态设置每列的间距大小|每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 5;
}
//动态设置每行的间距|每个item之间的间距|数列之间
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

//动态设置某个分区头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(Screen_W, 1);
}
//动态设置某个分区尾视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(Screen_W, 1);
}


#pragma mark ==
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.titleArr.count>self.imgArr.count){
        return self.imgArr.count;
    }else{
        return self.titleArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VoiceBottomToolPopViewSubCell *cell = (VoiceBottomToolPopViewSubCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kVoiceBottomToolPopViewSubCell_I  forIndexPath:indexPath];
    if (!cell) {
        cell = [[VoiceBottomToolPopViewSubCell alloc]initWithFrame:CGRectZero];
    }
    cell.bottomL.text = [NSString stringWithFormat:@"%@",self.titleArr[indexPath.row]];
    cell.iconImgv.image = [VoiceOcTool getVoiceUseImgWithImgIconNameStr:self.imgArr[indexPath.row]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_delegate && [_delegate respondsToSelector:@selector(bottomToolTouchType:)]){
        Voice_Botom_Tool_Type touchType = [ self.touchDelegaTypeNumArr[indexPath.row] intValue];
        
        [_delegate bottomToolTouchType: touchType];
       
    }
    
 
}
@end

#pragma mark ====

@implementation VoiceBottomToolPopViewSubCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.iconImgv];
        [self.contentView addSubview:self.bottomL];
        [self setsubUI];
    }
    return self;
}
- (void)setsubUI{
    NSString *nowLg = [[NSUserDefaults standardUserDefaults] objectForKey:@"Locale_Type"];
    if([nowLg isEqualToString: @"zh-Hans"]){
        [_iconImgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(44.0);
            make.centerX.equalTo(_iconImgv.superview);
            make.top.equalTo(_iconImgv.superview).offset(5);
        }];
        [_bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.equalTo(_bottomL.superview);
            make.bottom.equalTo(_bottomL.superview);
            make.top.equalTo(_iconImgv.mas_bottom);
        }];

    }else{//缩小图片
        [_iconImgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(36.0);
            make.centerX.equalTo(_iconImgv.superview);
            make.top.equalTo(_iconImgv.superview).offset(5);
        }];
        _iconImgv.layer.cornerRadius = 18.0;
        [_bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.equalTo(_bottomL.superview);
            make.bottom.equalTo(_bottomL.superview);
            make.top.equalTo(_iconImgv.mas_bottom);
        }];
        
    }
   
    
}

- (UILabel *)bottomL{
    if(!_bottomL){
        _bottomL = [[UILabel alloc]init];
        _bottomL.textColor = podUse_rgba(153, 153, 153, 1);
        _bottomL.font = [UIFont systemFontOfSize:11.0];
        _bottomL.textAlignment = NSTextAlignmentCenter;
        _bottomL.numberOfLines = 2;
    }
    return _bottomL;
}
- (UIImageView *)iconImgv{
    if(!_iconImgv){
        _iconImgv = [[UIImageView alloc]init];
        _iconImgv.contentMode = UIViewContentModeCenter;
        _iconImgv.layer.cornerRadius = 22.0;
        _iconImgv.layer.masksToBounds = YES;
        _iconImgv.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.25];

    }
    return _iconImgv;
}
 
@end



#pragma mark === 红包popV


//触发接口 去获取我钱包币种列表
#define Chat_Get_Wallet_List_Notice     @"Chat_Get_Wallet_List_Notice"
//接口数据拿到后 触发需要币种列表的通知
#define Chat_Get_Wallet_List_Notice_Result     @"Chat_Get_Wallet_List_Notice_Result_Notice"
//查询当前用户 余额信息 的通知
#define Chat_Get_myBalanceInfo                 @"Chat_Get_myBalanceInfo"
//创建红包相关msg OK
#define Chat_RedEnv_CreatMsg_WillSend_Notice    @"Chat_RedEnv_CreatMsg_WillSend_Notice"
//红包数据调取web后，web的到信息发送过来 继续走创建红包接口的通知
#define RedEnv_OnWebVc_SignGeted_Notice        @"RedEnv_OnWebVc_SignGeted_Notice"

//红包创建
#define Chat_Create_RedEnv_Notice              @"Chat_Create_RedEnv_Notice"
#define CreateSubDataType_ZhiBoInfoKey         @"ZhiBoInfo" //接收到直播内的创建红包动作时 直播间的信息ke y



#pragma mark ====


static NSString *redCellType_morePerson = @"redCellType_morePerson";
static NSString *redCellType_moneyNum = @"redCellType_moneyNum";
static NSString *redCellType_myBanlance =@"redCellType_myBanlance";
static NSString *redCellType_moneyTip = @"redCellType_moneyTip";
static NSString *redCellType_moneyType = @"redCellType_moneyType";


static NSInteger redCell_Tag_morePerson= 500;
static NSInteger redCell_Tag_moneyNum  = 501;
static NSInteger redCell_Tag_MoneyTip  = 502;
 
static

@interface SendRedEnvViewController ()
@property (nonatomic,strong) UIButton *cellSubUseOfMoneyNumTFRightView;
@property (nonatomic,strong) UIButton *cellSubUseOfpersonTFRightView;
@property (nonatomic,strong) NSString *saveMoneyTypeOfTFRightUseStr;
@property (nonatomic,strong) NSString *saveMoneyTypeContractAddresssStr;//当前选择的币种合约 用于后续数据 且 用于余额切换
//@"activityId"

@property (nonatomic,strong) NSMutableArray *moneyTypeNoticeGetDataInfos;
@property (nonatomic,strong) NSMutableDictionary *moneyMyBanlanceNoticeGetDataDic;
@end

 
@implementation SendRedEnvViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initDatas];
    [self initViews];
    [self initNotice];
 }

- (void)clearnBtnAction{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismissViewC");
    }];
}
- (void)initNotice{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nnoticeWithCreatRedEnvSendMessage:) name:Chat_RedEnv_CreatMsg_WillSend_Notice object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMoneyTypeList:) name:Chat_Get_Wallet_List_Notice_Result object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMyBalanceInfo:) name:Chat_Get_myBalanceInfo object:nil];
}
- (void)getMyBalanceInfo:(NSNotification *)notice{//
    NSLog(@"余额信息 -- noticeobj- %@",notice.object);
    NSLog(@"余额信息 -- noticuseinfo- %@",notice.userInfo);
    if([notice.object isKindOfClass:[NSDictionary class]]){
        self.moneyMyBanlanceNoticeGetDataDic = notice.object;
        /**
         k contractAddress obj
         o balance obj
         */
    }

    
}
- (void)getMoneyTypeList:(NSNotification *)notice{//得到币种列表
    NSLog(@"getMoneyTypeList - %@",notice.object);
    if([notice.object isKindOfClass:[NSArray class]]){
        self.moneyTypeNoticeGetDataInfos = [NSMutableArray arrayWithArray:notice.object];

    }else if ([notice.object isKindOfClass:[NSString class]]){

    }else if ([notice.object isKindOfClass:[NSDictionary class]]){
        
    }
    [self.tableView reloadData];
}
- (void)initDatas{
     
    if(self.isGroupType == YES){
        self.showCellTitleArrs = @[voiceRoomLocalize(@"多人红包"),
                                   voiceRoomLocalize(@"红包金额"),
                                   voiceRoomLocalize(@""),//@"余额cell位置"
                                   voiceRoomLocalize(@"红包备注"),
                                   voiceRoomLocalize(@"选择币种")];
        self.showCellTypeArrs = @[redCellType_morePerson,redCellType_moneyNum,redCellType_myBanlance,redCellType_moneyTip,redCellType_moneyType];
        self.showCellTagArrs = @[@(redCell_Tag_morePerson),@(redCell_Tag_moneyNum),@(0),@(redCell_Tag_MoneyTip),@(0)];
    }else{
        self.showCellTitleArrs = @[ voiceRoomLocalize(@"红包金额"),
                                    voiceRoomLocalize(@""),//@"余额cell位置"
                                    voiceRoomLocalize(@"红包备注"),
                                    voiceRoomLocalize(@"选择币种")];
        self.showCellTypeArrs = @[redCellType_moneyNum,redCellType_myBanlance,redCellType_moneyTip,redCellType_moneyType];
        self.showCellTagArrs = @[@(redCell_Tag_moneyNum),@(0),@(redCell_Tag_MoneyTip),@(0)];
    }
    self.inputOk_save_personNum = 1;//默认1个红包
 
    self.saveMoneyTypeOfTFRightUseStr = @"";
    self.moneyTypeNoticeGetDataInfos = @[].mutableCopy;
    [[NSNotificationCenter defaultCenter] postNotificationName:Chat_Get_Wallet_List_Notice object:self];
   
}
- (void)initViews{
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:self.clearnBtn];
    [self.view addSubview:self.mainV];
    [self.mainV addSubview:self.titleL];
    [self.mainV addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 100)];
    [self.mainV addSubview:self.footerBtn];
}
#pragma mark -
- (UIButton *)clearnBtn{
    if(!_clearnBtn){
        _clearnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearnBtn.frame = CGRectMake(0, 0, Screen_Width, Screen_Height*0.3);
        _clearnBtn.backgroundColor = [UIColor clearColor];
        [_clearnBtn addTarget:self action:@selector(clearnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearnBtn;
}

- (UIView *)mainV{
    if(!_mainV){
        _mainV = [[UIView alloc]init];
        if(_isGroupType == YES){
            _mainV.frame = CGRectMake(0, Screen_Height*0.15, Screen_Width, Screen_Height*0.85+Bottom_SafeHeight+10);
        }else{
            _mainV.frame = CGRectMake(0, Screen_Height*0.3, Screen_Width, Screen_Height*0.7+Bottom_SafeHeight+10);
        }
     
        _mainV.layer.cornerRadius = 6;
        _mainV.layer.masksToBounds = YES;
        _mainV.backgroundColor = [UIColor whiteColor];
    }
    return _mainV;
}
- (UILabel *)titleL{
    if(!_titleL){
        _titleL = [[UILabel alloc]init];
        _titleL.frame = CGRectMake(0, 20, Screen_Width, 30);
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.font = [UIFont boldSystemFontOfSize:16.0];
        _titleL.textColor = [UIColor blackColor];
        _titleL.text = voiceRoomLocalize(@"发红包");
    }
    return _titleL;
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]init];
        if(_isGroupType == YES){
            _tableView.frame = CGRectMake(0, 50, Screen_Width, Screen_Height*0.85-Bottom_SafeHeight-NavBar_Height);//可滑动的高度更多

        }else{
            _tableView.frame = CGRectMake(0, 50, Screen_Width, Screen_Height*0.7-Bottom_SafeHeight-NavBar_Height);

        }
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[SendRedEnvSubInputTableViewCell class] forCellReuseIdentifier:@"SendRedEnvSubInputTableViewCell"];
        [_tableView registerClass:[SendRedEnvSubInputAndHaveSubTitleTableViewCell class] forCellReuseIdentifier:@"SendRedEnvSubInputAndHaveSubTitleTableViewCell"];
        [_tableView registerClass:[SendRedEnvSubChooseMoneyTypeTableViewCell class] forCellReuseIdentifier:@"SendRedEnvSubChooseMoneyTypeTableViewCell"];
        [_tableView registerClass:[SendRedEnvSubMyBanlanceInfoTypeTableViewCell class] forCellReuseIdentifier:@"SendRedEnvSubMyBanlanceInfoTypeTableViewCell"];
    }
    return _tableView;
}
- (UIButton *)footerBtn{
    if(!_footerBtn){
        _footerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(_isGroupType == YES){
            _footerBtn.frame = CGRectMake(30, (Screen_Height*0.85-Bottom_SafeHeight-NavBar_Height)-50, Screen_Width-60, 50);
        }else{
            _footerBtn.frame = CGRectMake(30, (Screen_Height*0.7-Bottom_SafeHeight-NavBar_Height)-50, Screen_Width-60, 50);

        }
        _footerBtn.layer.cornerRadius = 22;
        _footerBtn.layer.masksToBounds = YES;
        _footerBtn.backgroundColor = [UIColor colorWithRed:(61.0/255.0) green:(240.0/255.0) blue:(240.0/255.0) alpha:1.0];//rgba(61, 240, 240, 1);
        _footerBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_footerBtn setTitleColor:[UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0] forState:UIControlStateNormal];
        [_footerBtn setTitle:voiceRoomLocalize(@"提交") forState:UIControlStateNormal];
        [_footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    }
    return _footerBtn;
}
#pragma mark =

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.showCellTypeArrs.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellTypeStr = self.showCellTypeArrs[indexPath.section];
    if( [cellTypeStr isEqualToString:redCellType_moneyType] ){
        return 140;
    }else if (([cellTypeStr isEqualToString:redCellType_myBanlance])){
        return 80;//余额度的位置
    }else{
        return 110;
    }
}

 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellTypeStr = self.showCellTypeArrs[indexPath.section];
    if([cellTypeStr isEqualToString:redCellType_myBanlance]){
        
        SendRedEnvSubMyBanlanceInfoTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SendRedEnvSubMyBanlanceInfoTypeTableViewCell"];
        if(!cell){
            cell = [[SendRedEnvSubMyBanlanceInfoTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SendRedEnvSubMyBanlanceInfoTypeTableViewCell"];
        }
        [cell.chongZhiBtn addTarget:self action:@selector(chongZhiBtnAction) forControlEvents:UIControlEventTouchUpInside];
        cell.moneyL.text = @"0.0";
        if([self.moneyMyBanlanceNoticeGetDataDic allKeys].count>0 && self.saveMoneyTypeContractAddresssStr.length>0){
            NSMutableArray *moneyBanAdddressArr = [[NSMutableArray alloc]initWithArray:[self.moneyMyBanlanceNoticeGetDataDic allKeys]];
            NSString *willUseAddressKey = [[NSString stringWithString:self.saveMoneyTypeContractAddresssStr] lowercaseString];//转成小写再比较吧
            for (int i = 0 ; i < moneyBanAdddressArr.count; i++) {
               NSString *kAddressobj = [[NSString stringWithString:moneyBanAdddressArr[i]] lowercaseString];
                if([kAddressobj isEqualToString: willUseAddressKey]){
                    NSString *balanceStr =  [NSString stringWithFormat:@"%@",[self.moneyMyBanlanceNoticeGetDataDic objectForKey: willUseAddressKey]];
                    if(balanceStr.length>0 && ![balanceStr isEqualToString:@"(null)"] && ![balanceStr isEqualToString:@"（null）"] && ![balanceStr isEqualToString:@"0"]){
                        double ban = [balanceStr doubleValue] / pow(10, 18);
                        cell.moneyL.text =  [NSString stringWithFormat:@"%0.8f",ban];
                    }else{
                        cell.moneyL.text = @"0.0";
                    }
                    break;
                }
            }
        }
        return cell;
        
    }else  if( [cellTypeStr isEqualToString:redCellType_moneyType] ){
        
        SendRedEnvSubChooseMoneyTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SendRedEnvSubChooseMoneyTypeTableViewCell"];
        if(!cell){
            cell = [[SendRedEnvSubChooseMoneyTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SendRedEnvSubChooseMoneyTypeTableViewCell"];
        }
        cell.leftL.text = self.showCellTitleArrs[indexPath.section];
        [cell fillMoneyTypeUseList:self.moneyTypeNoticeGetDataInfos];
        
        cell.touchChooseTypeBlock = ^(NSDictionary *oneItem) {
            NSString *titleS = ([[oneItem allKeys] containsObject:@"symbol"] ? [oneItem objectForKey:@"symbol"] : @"");
            NSString *contractAddressS = ([[oneItem allKeys] containsObject:@"contractAddress"] ? [oneItem objectForKey:@"contractAddress"] : @"");
            self->_saveMoneyTypeOfTFRightUseStr = titleS;
            self->_saveMoneyTypeContractAddresssStr = contractAddressS;
            self.inputOk_save_moneyTypeStr = titleS;
            [tableView reloadData];//金额度单位需要刷新 
        };
        
        return cell;
        
    }else if ([cellTypeStr isEqualToString:redCellType_moneyTip]){
        SendRedEnvSubInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SendRedEnvSubInputTableViewCell"];
        if(!cell){
            cell = [[SendRedEnvSubInputTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SendRedEnvSubInputTableViewCell"];
        }
        
        cell.leftL.text = self.showCellTitleArrs[indexPath.section];
        
        cell.textView.tag = [self.showCellTagArrs[indexPath.section] intValue];
        cell.textView.delegate = self;
        cell.textView.keyboardType = UIKeyboardTypeDefault;
        //cell.textView.placeholder = @"恭喜发财，大吉大利";
        cell.textView.text = self.inputOk_save_tipStr;
        return cell;
                
    }else {
        SendRedEnvSubInputAndHaveSubTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SendRedEnvSubInputAndHaveSubTitleTableViewCell"];
        if(!cell){
            cell = [[SendRedEnvSubInputAndHaveSubTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SendRedEnvSubInputAndHaveSubTitleTableViewCell"];
            
        }
        cell.leftL.text = self.showCellTitleArrs[indexPath.section];
        cell.textF.tag = [self.showCellTagArrs[indexPath.section] intValue];
        cell.textF.delegate = self;
    
       
        
        if ([cellTypeStr isEqualToString:redCellType_moneyNum] ){
            cell.textF.keyboardType = UIKeyboardTypeDecimalPad;//金额
            NSLog(@"cell.textF.frame1 == %@ ",NSStringFromCGRect(cell.textF.frame));
            cell.textF.rightView = self.cellSubUseOfMoneyNumTFRightView;
            [cell.textLeftShowBtn setTitle:voiceRoomLocalize(@"总金额") forState:UIControlStateNormal];
           // [cell.textLeftShowBtn setImage: [UIImage imageNamed:TUIChatImagePath(@"红包总金额")]  forState:UIControlStateNormal];
            cell.textF.placeholder = @"0";
            cell.textF.text = self.inputOk_save_moneyStr;

        } else {//[cellTypeStr isEqualToString:redCellType_morePerson]
            cell.textF.keyboardType = UIKeyboardTypePhonePad;//个数
            cell.textF.rightView = self.cellSubUseOfpersonTFRightView;
            [cell.textLeftShowBtn setTitle:voiceRoomLocalize(@"红包个数") forState:UIControlStateNormal];
            [cell.textLeftShowBtn setImage:[UIImage new] forState:UIControlStateNormal];
            cell.textF.placeholder = @"1";
            cell.textF.text = [NSString stringWithFormat:@"%ld",(long)self.inputOk_save_personNum];

        }
        cell.textF.rightViewMode = UITextFieldViewModeAlways;

        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.view endEditing:YES];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

}

#define NoticeName_gotoMyChongZhiTIXianWebVc   @"NoticeName_gotoMyChongZhiTIXianWebVc"
- (void)chongZhiBtnAction{
    NSLog(@" voice 红包创建 弹出框 充值按钮 //跳转去充值提现web");
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NoticeName_gotoMyChongZhiTIXianWebVc object:self];
    });
    
}
#pragma mark ==
- (UIButton *)cellSubUseOfpersonTFRightView{
    if(!_cellSubUseOfpersonTFRightView){
        _cellSubUseOfpersonTFRightView = [UIButton buttonWithType:UIButtonTypeCustom];
        _cellSubUseOfpersonTFRightView.bounds = CGRectMake(0, 0, 20, 20);
        [_cellSubUseOfpersonTFRightView setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        _cellSubUseOfpersonTFRightView.titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    [_cellSubUseOfpersonTFRightView setTitle:@"个" forState:UIControlStateNormal];
    return _cellSubUseOfpersonTFRightView;
}
- (UIButton *)cellSubUseOfMoneyNumTFRightView{
    if(!_cellSubUseOfMoneyNumTFRightView){
        _cellSubUseOfMoneyNumTFRightView = [UIButton buttonWithType:UIButtonTypeCustom];
        _cellSubUseOfMoneyNumTFRightView.bounds = CGRectMake(0, 0, 40, 20);
        [_cellSubUseOfMoneyNumTFRightView setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        _cellSubUseOfMoneyNumTFRightView.titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    [_cellSubUseOfMoneyNumTFRightView setTitle:self.saveMoneyTypeOfTFRightUseStr forState:UIControlStateNormal];
    return _cellSubUseOfMoneyNumTFRightView;
}
 
#pragma mark ==
//static NSInteger redCell_Tag_morePerson= 500;
//static NSInteger redCell_Tag_moneyNum  = 501;
//static NSInteger redCell_Tag_MoneyTip  = 502;

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self dealViewTag:textField.tag textStr:textField.text];
    
}
- (void)textFieldDidChangeSelection:(UITextField *)textField{
    [self dealViewTag:textField.tag textStr:textField.text];
}


- (void)textViewDidChange:(UITextView *)textView{
    [self dealViewTag:textView.tag textStr:textView.text];
}
- (void)textViewDidChangeSelection:(UITextView *)textView{
   
    [self dealViewTag:textView.tag textStr:textView.text];
}
- (void)dealViewTag:(NSInteger)tag textStr:(NSString *)dealTextStr{
    if(tag == redCell_Tag_MoneyTip){
        self.inputOk_save_tipStr = dealTextStr;
        
    }else  if(tag == redCell_Tag_moneyNum){
        
        self.inputOk_save_moneyStr = dealTextStr;
        
    }else if(tag == redCell_Tag_morePerson){
         

        self.inputOk_save_personNum = dealTextStr.length==0 ? 1 :[dealTextStr integerValue];
    }
}

- (NSString *)transformDecimalNumberByNumber:(double)number andDoct:(NSInteger)doct {
    
    NSDecimalNumber *decNumber = nil;
    NSDecimalNumberHandler *handler1 = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:doct raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSString *numberString = [NSString stringWithFormat:@"%.5f",number];
    NSDecimalNumber * numDecimal = [[NSDecimalNumber alloc] initWithString:numberString];
    decNumber = [numDecimal decimalNumberByRoundingAccordingToBehavior:handler1];
    
    return [decNumber stringValue];
}


- (void)footerBtnAction{
    
    NSLog(@"");
    
    /**
     
     //    self.inputOk_save_moneyTypeStr = @"F-U";
     //    self.saveMoneyTypeContractAddresssStr = @"0xc026606FF35c50e26E18d9908df879B8a49857e7";
     {
     contractAddress = 0xc026606FF35c50e26E18d9908df879B8a49857e7;
     decimals = 18;
     icon = "https://source.freeper.io/icon/f-u.png";
     id = 1;
     name = FFF;
     note = "";
     rowCreate = "2023-09-12 18:51:28";
     rowUpdate = "2023-09-12 18:51:28";
     state = 1;
     symbol = "F-U";
     totalSupply = "";*/

    if(self.inputOk_save_moneyTypeStr.length<=0){
        [TUITool makeToast:voiceRoomLocalize(@"请选择币种")];
    
        return;
    }
    
    NSString *okMoneyStr=@"";
    if(self.inputOk_save_moneyStr.length<=0 || [self.inputOk_save_moneyStr floatValue] <= 0){
        [TUITool makeToast:voiceRoomLocalize(@"请填写红包金额")];
        return;
    }else{
        /**
         a的b次方
         （例）double val = pow(2, 3);
         　→8
         　double pow(double a, double b)
         　*/
//        okMoneyStr = [NSString stringWithFormat:@"%0.8f",[self.inputOk_save_moneyStr floatValue] * (pow(10.0,  8))];
        //        okMoneyStr = [NSString stringWithFormat:@"%f",round([self.inputOk_save_moneyStr floatValue] * (pow(10.0,  8))) ];
//        okMoneyStr = [NSString stringWithFormat:@"%ld",lround([self.inputOk_save_moneyStr floatValue] * (pow(10.0,  18))) ];//根据精度来，一般是10^18
        NSString *numStr1 = [self transformDecimalNumberByNumber:[self.inputOk_save_moneyStr  doubleValue] andDoct:3];
        NSDecimalNumber *aDN = [NSDecimalNumber decimalNumberWithString:numStr1];
        NSDecimalNumber *pwInfo = [[NSDecimalNumber decimalNumberWithString:@"10"] decimalNumberByRaisingToPower:18];
        NSDecimalNumber *okNum = [aDN decimalNumberByMultiplyingBy:pwInfo];
        NSLog(@"numStr1 %@ ,aDN = %@,pwInfo=%@ okNum = %@",numStr1,aDN,pwInfo,okNum);
        okMoneyStr = [okNum stringValue];
        NSLog(@"okMoneyStr === %@",okMoneyStr);
        if(okMoneyStr.length<=0 || [okMoneyStr floatValue] <= 0){
            [TUITool makeToast:  voiceRoomLocalize(@"请填写红包金额")];
            return;
        }
    }
    
    if(self.inputOk_save_tipStr.length<=0){
        NSLog(@"红包备注为默认值");
        self.inputOk_save_tipStr = voiceRoomLocalize(@"恭喜发财，大吉大利");
    }
    
   
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
    NSString *titleStr = @"";
    self.isGroupType=YES;//一定是群
    
    if(self.selfRoomGroupIDstr.length <= 0){
        NSLog(@"selfRoomGroupIDstr。空 groupID问题");
        return;
    }
    if(self.zhiBoInfoOfCustomMsgActivityIDStr.length<=0){
        self.zhiBoInfoOfCustomMsgActivityIDStr = @"";
    }
    dataDic = @{
        redCellType_morePerson:@(self.inputOk_save_personNum),
        redCellType_moneyNum:okMoneyStr,//self.inputOk_save_moneyStr,
        redCellType_moneyTip:self.inputOk_save_tipStr,
        redCellType_moneyType:self.inputOk_save_moneyTypeStr,
        @"address":self.saveMoneyTypeContractAddresssStr,
        @"groupID":[NSString stringWithFormat:@"%@",self.selfRoomGroupIDstr], //GroupID
        CreateSubDataType_ZhiBoInfoKey:self.zhiBoInfoOfCustomMsgTypeStr,
        @"activityId":self.zhiBoInfoOfCustomMsgActivityIDStr, //观众打赏给主播时需要的数据
    }.mutableCopy;
    
    if(self.inputOk_save_personNum > 1){
        titleStr = [NSString stringWithFormat:@"%@", voiceRoomLocalize(@"发送多人红包")];
    }else{
        titleStr = voiceRoomLocalize(@"发送单个红包");
    }
 
    
    NSString *subMsgStr =  [NSString stringWithFormat:@"%@ %@",self.inputOk_save_moneyStr,self.inputOk_save_moneyTypeStr];//展示和发送到=的金额不一样(pow(10.0,  18))

//    NSString *subMsgStr =  [NSString stringWithFormat:@"%@ %@",okMoneyStr ,self.inputOk_save_moneyTypeStr];//self.inputOk_save_moneyStr
    __weak typeof(self) weakSelf = self;

    UIAlertController *aleartVc = [UIAlertController alertControllerWithTitle:titleStr message:subMsgStr preferredStyle:UIAlertControllerStyleAlert];
   
    //tit-----
    NSMutableAttributedString *alertControllerTitleStr = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [alertControllerTitleStr addAttribute:NSForegroundColorAttributeName value:Color_Gray121
                                    range:NSMakeRange(0, alertControllerTitleStr.length)];
    [alertControllerTitleStr addAttribute:NSFontAttributeName
                                    value:[UIFont systemFontOfSize:15.0]
                                    range:NSMakeRange(0, alertControllerTitleStr.length)];
    [aleartVc setValue:alertControllerTitleStr forKey:@"attributedTitle"];
    
    
    
    //msg-----
    //创建图片
    //NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    //attach.image = [UIImage imageNamed:TUIChatImagePath(@"红包总金额")]; //设置图片
    //attach.bounds = CGRectMake(0, -8, 20, 20); //设置图片大小、位置
    //NSAttributedString *strImg = [NSAttributedString attributedStringWithAttachment:attach];
    
    //创建文本
    NSMutableDictionary *dicTextFC = [NSMutableDictionary dictionary];
    dicTextFC[NSForegroundColorAttributeName] = Color_Black51;
    dicTextFC[NSFontAttributeName] = [UIFont boldSystemFontOfSize:14.0];
    NSAttributedString *msgStrEnd = [[NSAttributedString alloc] initWithString:subMsgStr attributes:dicTextFC];
    //
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] init];
    //[alertControllerMessageStr appendAttributedString:strImg];//图标暂时不处理
    [alertControllerMessageStr appendAttributedString:msgStrEnd];
    [aleartVc setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    UIAlertAction* alertAction_Cancel = [UIAlertAction actionWithTitle:voiceRoomLocalize(@"取消") style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction* alertAction_Confirm = [UIAlertAction actionWithTitle:voiceRoomLocalize(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {//Green_main_Color
        NSLog(@"确认----- configm ---- 直播内发送信息 %@",dataDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:Chat_Create_RedEnv_Notice object:self userInfo:dataDic];
            [self selfVcDismis];
         
        });
        //调起web 拿到对应签名后 调用创建接口 接口OK后 回来发送信息
    }];
    [alertAction_Cancel setValue:Color_Gray153  forKey:@"_titleTextColor"];
    [alertAction_Confirm setValue:Green_main_Color forKey:@"_titleTextColor"];//Color_Black51
    [aleartVc addAction:alertAction_Cancel];
    [aleartVc addAction:alertAction_Confirm];


    
    //
    UIView *firstSubview = aleartVc.view.subviews.firstObject;
    UIView *alertContentView = firstSubview.subviews.firstObject;
    for (UIView *subSubView in alertContentView.subviews) { //This is main catch
        subSubView.backgroundColor =  [UIColor whiteColor];
        subSubView.layer.borderColor = [UIColor whiteColor].CGColor;
        subSubView.layer.borderWidth = 1.0;
        subSubView.layer.cornerRadius = 5.0;
    }
    [self presentViewController:aleartVc animated:YES completion:nil];

    
}
- (void)selfVcDismis{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{ NSLog(@"红包页 selfVcDismis");}];
    });
}

#pragma mark === 红包签名拿到后 才创建信息 回到这里做发送动作

- (NSString *)jsonStrWithDic:(NSMutableDictionary *)dic{
    if([dic allKeys].count == 0){
        return @"";
    }
    NSError *parseError;
    NSDate *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    if (parseError) {
      //解析出错
    }
    NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return str;

}
- (void)nnoticeWithCreatRedEnvSendMessage:(NSNotification *)notice{
    
    
    NSLog(@"nnoticeWithCreatRedEnvSendMessage 主播发送红包给个观众 或者 观众发打赏给主播 %@",notice.object);//MsgEntityCustoms
    if([ notice.object isKindOfClass:[NSString class]]){
        NSString *message = notice.object;
        NSLog(@"nnoticeWithCreatRedEnvSendMessage 主播发送红包给个观众 或者 观众发打赏给主播 %@",message);
        if(message.length>0){
            if(self.gotSignInfoSsendRedEnvAcBlock != nil){
                self.gotSignInfoSsendRedEnvAcBlock(message);
            }
        }
    }else if( [ notice.object isKindOfClass:[NSDictionary class]]){
        NSDictionary *noticeObjDic = [NSDictionary dictionaryWithDictionary:notice.object];
        NSMutableDictionary *customInfoDic = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *cusMsgOkWillSendInfo =  [[NSMutableDictionary alloc]init];//主播，发送红包后的自定义信息
        
        NSString *unoStr = @"";
        NSString *titleS = @"";
        NSString *amount = @"";
        if([self.zhiBoInfoOfCustomMsgTypeStr isEqualToString:BussinessID_ZhiBo_CUSTOM_onAudienceSendRedEnvelope]){//观众发红包打赏
            unoStr = [[noticeObjDic allKeys]containsObject:@"receiptNo"] ? [NSString stringWithFormat:@"%@",[noticeObjDic objectForKey:@"receiptNo"]] : @"";
            amount = [[noticeObjDic allKeys]containsObject:@"amount"] ? [NSString stringWithFormat:@"%@",[noticeObjDic objectForKey:@"amount"]] : @"";
            [customInfoDic setValue:amount forKey:@"amount"];

        }else{//主播发红包
            unoStr = [[noticeObjDic allKeys]containsObject:@"uno"] ? [NSString stringWithFormat:@"%@",[noticeObjDic objectForKey:@"uno"]] : @"";
            titleS = [[noticeObjDic allKeys]containsObject:@"title"] ? [NSString stringWithFormat:@"%@",[noticeObjDic objectForKey:@"title"]] : @"";
            //total总金额
            amount = [[noticeObjDic allKeys]containsObject:@"total"] ? [NSString stringWithFormat:@"%@",[noticeObjDic objectForKey:@"total"]] : @"";
            if(amount.length == 0 || [amount isEqualToString:@"(null)"] || [amount isEqualToString:@"（null）"]){
                [customInfoDic setValue:@"0" forKey:@"amount"];
            }else{
                [customInfoDic setValue:amount forKey:@"amount"];
            }
        }
        
        [customInfoDic setValue:unoStr forKey:@"id"];
        [customInfoDic setValue:titleS forKey:@"title"];
        [customInfoDic setValue:self.inputOk_save_moneyTypeStr forKey:@"unit"]; 
        
        NSString *customInfoJsonStr = [self jsonStrWithDic:customInfoDic];

        
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc]init];
        //
        if([self.creatUserID isEqual:@""]){
            self.creatUserID = [[noticeObjDic allKeys]containsObject:@"address"] ? [NSString stringWithFormat:@"%@",[noticeObjDic objectForKey:@"address"]] : @"";
        }
        if([self.creatUserName isEqual:@""]){
            self.creatUserName = [[noticeObjDic allKeys]containsObject:@"address"] ? [NSString stringWithFormat:@"%@",[noticeObjDic objectForKey:@"address"]] : @"";
        }
        //
        [userInfoDic setValue:self.creatUserFaceUrl forKey:@"avatar"];
        [userInfoDic setValue:self.creatUserName forKey:@"nick"];
        [userInfoDic setValue:self.creatUserID forKey:@"userID"];
       
      
        [cusMsgOkWillSendInfo setValue:customInfoJsonStr forKey:@"customInfo"];
        [cusMsgOkWillSendInfo setValue:userInfoDic forKey:@"userInfo"];
        [cusMsgOkWillSendInfo setValue:@(10000) forKey:@"timeout"];
        [cusMsgOkWillSendInfo setValue:self.zhiBoInfoOfCustomMsgTypeStr forKey:@"eventType"];
        
        NSString *willSendJsonStr  = [self jsonStrWithDic:cusMsgOkWillSendInfo];
        if(willSendJsonStr.length>0){
            if(self.gotSignInfoSsendRedEnvAcBlock != nil){
                 self.gotSignInfoSsendRedEnvAcBlock(willSendJsonStr);
            }
        }
        
    }else{

        
        /**
         po dicOfBlock
         {
             address = 0xf2504a866bed5fb0a58e5fd92e9cec069fa578f5;
             category = 0;
             channelId = 108;
             contractAddress = 0xc026606FF35c50e26E18d9908df879B8a49857e7;
             cover = "https://c-ssl.dtstatic.com/uploads/blog/202203/21/20220321204722_1fa16.thumb.1000_0.jpg";
             expireTs = 1695545673837;
             id = 73;
             pieces = 1;
             scene = 1;
             senderMsg = "aaaaaaaaaa.free";
             title = "\U54c8\U54c8\U54c8\U54c8\U54c85";
             total = 5;
             uno = 20230923085433825177389;
             wid = 651446;
         }
         */
       
    }
}
  

//- (void)web_ReadEnv_signGeted:(NSNotification *)notice{
//    DLog(@"红包  ---- noticeobject %@",notice.object);
//    DLog(@"红包  ---- noticeuserInfo %@",notice.userInfo);
//
//
//    NSString *signStr = [[NSString stringWithFormat:@"%@",notice.object] componentsSeparatedByString:@","].firstObject;
//    NSString *times = [[NSString stringWithFormat:@"%@",notice.object] componentsSeparatedByString:@","].lastObject;
//
////    NSString *signStr = [NSString stringWithFormat:@"%@",notice.object];
//
//    if(isNil(self.saveCreatRedEvnInfoModel)){
//        return;
//    }
//    RedEvnInfoModel *redCreatModel = self.saveCreatRedEvnInfoModel;
//    redCreatModel.signature = signStr;
//    redCreatModel.time = times;//[YTimeStamp getNowTimeTimestamp_haoMiao];
//    NSMutableDictionary *redCreatData = [[NSMutableDictionary alloc]initWithDictionary:[redCreatModel mj_keyValues]];
//    NSLog(@"redEnv CreatData --- %@",redCreatData);
//    [PopSendOrGetRedNoticeOfDataTool redEnvCreateWithData:redCreatData
//                                                withBlock:^(NSDictionary * _Nonnull dicOfBlock, BOOL succes) {
//        if(succes){
//            //发送红包的信息
//            [self doSendMessageAction:dicOfBlock];
//        }
//
//    }];
//
//}
//- (void)doSendMessageAction{
    
    
    
    /**
     {
         
         V2TIMMessage *sendMsg = [self dealCustomMsg];
         {
             NSString *groupID =  self.conversationData.groupID;
             [[V2TIMManager sharedInstance] sendMessage:sendMsg
                                               receiver:@""
                                                groupID:groupID
                                               priority:V2TIM_PRIORITY_DEFAULT
                                         onlineUserOnly:NO
                                        offlinePushInfo:nil
                                               progress:^(uint32_t progress) {
             } succ:^{
                 NSLog(@"发送成功");
                  [TUITool makeToast:@"成功"];

                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [self dismissViewControllerAnimated:YES completion:^{
                         NSLog(@"返回会话列表");
                         [NSNotificationCenter.defaultCenter postNotificationName:TUIKitNotification_onMessageStatusChanged object:sendMsg.msgID];
                     }];
                 });

                 
             } fail:^(int code, NSString *desc) {
                 NSLog(@"code %d desc %@ ",code,desc);
             }];
             
         }
      
     }*/
//}

//- (V2TIMMessage *)dealCustomMsg{
    /**
     {
         V2TIMMessage *cusmessage;
         NSMutableDictionary *customDic = [[NSMutableDictionary alloc]init];
         [customDic setValue:@(GroupCreate_Version) forKey:@"version"];
         [customDic setValue:BussinessID_CUSTOM_RED_ENVELOPE forKey:BussinessID];
         [customDic setValue:@(1) forKey:@"type"];//
     //    [customDic setValue:pushAddGroup forKey:@"link"];//Link_str
     //    [customDic setValue:self.willShareGroupID   forKey:@"groupId"];
     //    [customDic setValue:self.willShareGroupShowName  forKey:@"groupName"];

         NSError *err;
         NSData *customData= [NSJSONSerialization dataWithJSONObject:customDic options:NSJSONWritingPrettyPrinted error:&err];
         if(err){
             NSLog(@"dealCustomMsg -- 失败");
             return cusmessage;
         }
         cusmessage = [[V2TIMManager sharedInstance] createCustomMessage:customData];
         cusmessage.customElem.desc = [NSString stringWithFormat:@"%ld",Link_Type_RedEnv_2];//用于主页显示[自定义消息]的desc处理
         NSLog(@"sendMsg.msgid == %@",cusmessage.msgID);
         return cusmessage;
         
     }
     */
//}


@end


#pragma mark =
@implementation  SendRedEnvSubInputTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.leftL];
        [self.contentView addSubview:self.textView];
    }
    return self;
}
- (UILabel *)leftL{
    if(!_leftL){
        _leftL = [[UILabel alloc]init];
        _leftL.frame = CGRectMake(30, 10, 190, 20);
        _leftL.font = [UIFont systemFontOfSize:16.0];
        _leftL.textColor = [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0];
    }
    return _leftL;
}

- (UITextView *)textView{
    if(!_textView){
        _textView = [[UITextView alloc]init];
        _textView.frame = CGRectMake(12, CGRectGetMaxY(_leftL.frame)+10, Screen_Width-24, 62);
        _textView.textColor = [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0];
        _textView.backgroundColor = [UIColor colorWithRed:(248.0/255.0) green:(248.0/255.0) blue:(248.0/255.0) alpha:1.0];
        _textView.layer.cornerRadius = 6;
        _textView.layer.masksToBounds = YES;
    }
    return _textView;
}
@end
#pragma mark =


@implementation  SendRedEnvSubInputAndHaveSubTitleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.leftL];
        [self.contentView addSubview:self.textFbkView];
        [self.textFbkView addSubview:self.textF];
        [self.textFbkView addSubview:self.textLeftShowBtn];
    }
    return self;
}
- (UILabel *)leftL{
    if(!_leftL){
        _leftL = [[UILabel alloc]init];
        _leftL.frame = CGRectMake(30, 10, 190, 20);
        _leftL.font = [UIFont systemFontOfSize:16.0];
        _leftL.textColor = [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0];
    }
    return _leftL;
}


- (UIView *)textFbkView{
    if(!_textFbkView){
        _textFbkView = [[UIView alloc]init];
        _textFbkView.frame = CGRectMake(12, CGRectGetMaxY(_leftL.frame)+10, Screen_Width-24, 62);
        _textFbkView.backgroundColor = [UIColor colorWithRed:(248.0/255.0) green:(248.0/255.0) blue:(248.0/255.0) alpha:1.0];
        _textFbkView.layer.cornerRadius = 6;
        _textFbkView.layer.masksToBounds = YES;
    }
    return _textFbkView;
}

- (UIButton *)textLeftShowBtn{
    if(!_textLeftShowBtn){
        _textLeftShowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _textLeftShowBtn.frame = CGRectMake(10, 0, 80, CGRectGetHeight(_textFbkView.frame));
        _textLeftShowBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_textLeftShowBtn setTitleColor:[UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0] forState:UIControlStateNormal];
        
    }
    return _textLeftShowBtn;
}

- (UITextField *)textF{
    if(!_textF){
        _textF = [[UITextField alloc]init];
        _textF.textColor = [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0];
        _textF.frame = CGRectMake(100, 0, CGRectGetWidth(_textFbkView.frame) - 100-10, CGRectGetHeight(_textFbkView.frame));
        _textF.textAlignment = NSTextAlignmentRight;
    }
    return _textF;
}


@end
#pragma mark =

@implementation  SendRedEnvSubChooseMoneyTypeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.saveListArr = @[].mutableCopy;
        self.saveListArr_InfoTypeList = @[].mutableCopy;
        self.saveListArr_InfoTypeObjDic = @{}.mutableCopy;
        
        [self.contentView addSubview:self.leftL];
        [self.contentView addSubview:self.typesBkV];
        [self.typesBkV addSubview:self.typesBkSubCollV];
    }
    return self;
}
- (UILabel *)leftL{
    if(!_leftL){
        _leftL = [[UILabel alloc]init];
        _leftL.frame = CGRectMake(30, 10, 190, 20);
        _leftL.font = [UIFont systemFontOfSize:16.0];
        _leftL.textColor = [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0];
    }
    return _leftL;
}

- (UIView *)typesBkV{
    if(!_typesBkV){
        _typesBkV = [[UIView alloc]init];
        _typesBkV.frame = CGRectMake(12, CGRectGetMaxY(_leftL.frame)+10, Screen_Width-24, 80);

    }
    return _typesBkV;
}

//typesBkV的宽高位置
- (UICollectionView *)typesBkSubCollV{
    if (!_typesBkSubCollV) {
        _typesBkSubCollV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width-24, 80) collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
        _typesBkSubCollV.backgroundColor = [UIColor clearColor];
        _typesBkSubCollV.showsHorizontalScrollIndicator = NO;
        _typesBkSubCollV.delegate = self;
        _typesBkSubCollV.dataSource = self;
        [_typesBkSubCollV registerClass:[ImgTextCollectionViewCell class] forCellWithReuseIdentifier:@"ImgTextCollectionViewCell"];
        [_typesBkSubCollV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ksectionTitileHeaderView_I];
        [_typesBkSubCollV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ksectionTitileHeaderView_I];
        _typesBkSubCollV.scrollEnabled = YES;
         
    }
    return _typesBkSubCollV;
}

#pragma mark ===

#define CollectionV_Item_W (100)
#define CollectionV_Item_H (34)

#define subMoneyTag_base (600)
#define btn_Img_WH (20)

#pragma mark - UICollectionViewDelegateFlowLayout
//动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CollectionV_Item_W, CollectionV_Item_H);
}

//动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 0, 0);//某Section总的上下左右
}

//动态设置每列的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

    return 5;
}
//动态设置每行的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

    return 5;
}

//动态设置某个分区头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(Screen_Width-24, 20);
}
//动态设置某个分区尾视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(Screen_Width-24, 1);
}
#pragma mark ==

//代理相应方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.saveListArr_InfoTypeList.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSString *secK = self.saveListArr_InfoTypeList[section];
    NSArray *oneTypeInfo = [[NSArray alloc]initWithArray: [self.saveListArr_InfoTypeObjDic objectForKey:secK]];
    
    return oneTypeInfo.count;

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImgTextCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImgTextCollectionViewCell" forIndexPath:indexPath];
    
    NSString *secK = self.saveListArr_InfoTypeList[indexPath.section];
    NSArray *oneTypeInfo = [[NSArray alloc]initWithArray: [self.saveListArr_InfoTypeObjDic objectForKey:secK]];
    NSDictionary *collInfoItem =  oneTypeInfo[indexPath.row];
    //
    NSString *titleS = ([[collInfoItem allKeys] containsObject:@"symbol"] ? [collInfoItem objectForKey:@"symbol"] : @"");
    NSString *iconS = ([[collInfoItem allKeys] containsObject:@"icon"] ? [collInfoItem objectForKey:@"icon"] : @"");
    NSString *contractAddressS = ([[collInfoItem allKeys] containsObject:@"contractAddress"] ? [collInfoItem objectForKey:@"contractAddress"] : @"");
    //
    [cell.centerBtn setTitle:titleS forState:UIControlStateNormal];
    [cell.centerBtn sd_setImageWithURL:[NSURL URLWithString:iconS] forState:UIControlStateNormal];
    [cell.centerBtn addTarget:self action:@selector(touchOneMoneyType:) forControlEvents:UIControlEventTouchUpInside];
    cell.centerBtn.tag  = indexPath.row+indexPath.section*10+subMoneyTag_base;
    
    if([self.saveNowChooseItemDic allKeys].count != 0){//被选中的
        NSLog(@"saveNowChooseItemDic -- 被选中的是%@ 相关颜色判断处理",self.saveNowChooseItemDic);
        NSString *symbol_NowChoosed = ([[self.saveNowChooseItemDic allKeys] containsObject:@"symbol"] ? [self.saveNowChooseItemDic objectForKey:@"symbol"] : @"");
        NSString *contractAddressS_NowChoose = ([[self.saveNowChooseItemDic allKeys] containsObject:@"contractAddress"] ? [self.saveNowChooseItemDic objectForKey:@"contractAddress"] : @"");

//        if([symbol_NowChoosed isEqualToString:titleS] ){
        if([contractAddressS_NowChoose isEqualToString:contractAddressS] ){
            [self btnIsSelectedUIwithBtn:cell.centerBtn];//被选中的
        }else{
            [self btnIsNomalUIwithBtn:cell.centerBtn];
        }
    }else{
        [self btnIsNomalUIwithBtn:cell.centerBtn];
    }
    
    return cell;

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {//这是头部视图
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind  withReuseIdentifier:ksectionTitileHeaderView_I   forIndexPath:indexPath];
        [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [view addSubview:[self collectionHeader_sectionTitileHeaderViewAtIndexPath:indexPath]];
        return view;

    }else{//15后foot复用UICollectionElementKindSectionHeader闪退。都得注册
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind  withReuseIdentifier:ksectionTitileHeaderView_I   forIndexPath:indexPath];
        return view;
    }

}
- (UIView *)collectionHeader_sectionTitileHeaderViewAtIndexPath:(NSIndexPath *)indexPath{
    NSString *secK = self.saveListArr_InfoTypeList[indexPath.section];
    
    UIView *sectionTitileHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 20)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, Screen_Width-32, 20)];
    titleLabel.text = secK;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:12.0];
    [sectionTitileHeaderView addSubview:titleLabel];
    return sectionTitileHeaderView;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@" 红包币种选择--- %s %ld   %ld",__func__,indexPath.section,indexPath.row);
    
    NSString *secK = self.saveListArr_InfoTypeList[indexPath.section];
    NSArray *oneTypeInfo = [[NSArray alloc]initWithArray: [self.saveListArr_InfoTypeObjDic objectForKey:secK]];
    NSDictionary *collInfoItem =  oneTypeInfo[indexPath.row];
    NSLog(@" 红包币种选择 由centerbtn处理数据 此处不处理数据---%@",collInfoItem);
    
}
 

#define subMoneyTag_base (600)
#define btn_Img_WH (20)
- (void)fillMoneyTypeUseList:(NSMutableArray *)listArr{
    
    self.saveListArr = listArr.mutableCopy;
    self.saveListArr_InfoTypeList = @[].mutableCopy;
    self.saveListArr_InfoTypeObjDic = @{}.mutableCopy;
    
    if(self.saveListArr.count != 3){
        return;
    }

    NSArray *contractArr = self.saveListArr.firstObject;
    NSArray *networkArr = self.saveListArr[1];
    NSArray *wallce_Info = self.saveListArr.lastObject;
    
    for (int  i = 0; i < networkArr.count; i++) {
        NSDictionary *netDic = networkArr[i];
        NSString *chainCode_N = ([[netDic allKeys] containsObject:@"chainCode"] ? [netDic objectForKey:@"chainCode"] : @"");
        NSString *name_N = ([[netDic allKeys] containsObject:@"name"] ? [netDic objectForKey:@"name"] : @"");
        [self.saveListArr_InfoTypeList addObject:name_N];//用于headerL
        NSMutableArray *saveListArr_InfoTypeList_ObjArr = @[].mutableCopy;
        for (int  k = 0; k < contractArr.count; k++) {
            NSDictionary *contracDic = contractArr[k];
            NSString *chainCode_C = ([[contracDic allKeys] containsObject:@"chainCode"] ? [contracDic objectForKey:@"chainCode"] : @"");
    
            if([chainCode_C isEqualToString:chainCode_N]){
                [saveListArr_InfoTypeList_ObjArr addObject:contracDic];
            }
        }
        [self.saveListArr_InfoTypeObjDic setValue:saveListArr_InfoTypeList_ObjArr forKey:name_N];//用于collv数据
    }
    NSLog(@"saveListArr_InfoTypeList --- %@",self.saveListArr_InfoTypeList);
    NSLog(@"saveListArr_InfoTypeObjDic --- %@",self.saveListArr_InfoTypeObjDic);
    
    [self.typesBkSubCollV reloadData];
    
 

}
- (void)btnIsNomalUIwithBtn:(UIButton *)sender{
    sender.backgroundColor = Color_White248;
}
- (void)btnIsSelectedUIwithBtn:(UIButton *)sender{
    sender.backgroundColor = Green_main_Color;
}

- (void)touchOneMoneyType:(UIButton *)sender{
    NSInteger idx_section = (sender.tag-subMoneyTag_base)/10;
    NSInteger idx_row = (sender.tag-subMoneyTag_base)%10;
    
    NSString *secK = self.saveListArr_InfoTypeList[idx_section];
    NSArray *oneTypeInfo = [[NSArray alloc]initWithArray: [self.saveListArr_InfoTypeObjDic objectForKey:secK]];
    NSDictionary *oneDic = oneTypeInfo[idx_row];
    self.saveNowChooseItemDic = oneDic;
    self.touchChooseTypeBlock(oneDic);
    
}

@end

//币种subItem collv cell
@implementation ImgTextCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //100  34
        [self.contentView addSubview:self.centerBtn];
        _centerBtn.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 100-7-btn_Img_WH);//34-btn_Img_WH ==14 7
    }
    return self;
}
 
- (UIButton *)centerBtn{
    if(!_centerBtn){
        _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _centerBtn.frame = CGRectMake(0, 0, 100, 34);
        [_centerBtn setTitleColor:Color_Black51 forState:UIControlStateNormal];
        _centerBtn.layer.cornerRadius = 15;
        _centerBtn.layer.masksToBounds = YES;
        _centerBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _centerBtn;
}
@end


//余额cell
#define label_H (35)
#define chongzhi_W (60)
#define title_W    (30)
#define money_W    (100)

@implementation SendRedEnvSubMyBanlanceInfoTypeTableViewCell 
 

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.chongZhiBtn];
        //self.chongZhiBtn.hidden = YES;
        [self.contentView addSubview:self.moneyL];
        [self.contentView addSubview:self.tileL];
        [self.contentView addSubview:self.botttomL];
    }
    return self;
}

- (UIButton *)chongZhiBtn{
    if(!_chongZhiBtn){
        _chongZhiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _chongZhiBtn.frame = CGRectMake(Screen_Width-chongzhi_W-20,  0  ,chongzhi_W , label_H);
        _chongZhiBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_chongZhiBtn setTitleColor:Green_main_Color forState:UIControlStateNormal];
        [_chongZhiBtn setTitle:voiceRoomLocalize(@"充值")  forState:UIControlStateNormal];
     }
    return _chongZhiBtn;
}

- (UILabel *)moneyL{
    if(!_moneyL){
        _moneyL = [[UILabel alloc]init];
        _moneyL.frame = CGRectMake(Screen_Width-chongzhi_W-20-money_W, 0, money_W, label_H);
        _moneyL.font = [UIFont systemFontOfSize:13.0];
        _moneyL.textColor = [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0];
    }
    return _moneyL;
 
}
- (UILabel *)tileL{
    if(!_tileL){
        _tileL = [[UILabel alloc]init];
        _tileL.frame = CGRectMake(Screen_Width-chongzhi_W-20-money_W-title_W, 0, title_W, label_H);
        _tileL.font = [UIFont systemFontOfSize:13.0];
        _tileL.textColor = [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0];
        _tileL.text = voiceRoomLocalize(@"余额");
    }
    return _tileL;
}

- (UILabel *)botttomL{
    if(!_botttomL){
        _botttomL = [[UILabel alloc]init];
        _botttomL.frame = CGRectMake(30, 10, 100, 20);
        _botttomL.font = [UIFont systemFontOfSize:13.0];
        _botttomL.textColor = [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0];
        _botttomL.text = voiceRoomLocalize(@"单个红包金额不可超过100");
        _botttomL.textAlignment = NSTextAlignmentRight;
        _botttomL.frame = CGRectMake(0,  30  ,Screen_Width-20 , label_H);
    }
    return _botttomL;
}
 
@end




