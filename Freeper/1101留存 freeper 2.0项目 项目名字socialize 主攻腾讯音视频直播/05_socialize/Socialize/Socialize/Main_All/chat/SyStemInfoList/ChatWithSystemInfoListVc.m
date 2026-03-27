//
//  ChatWithSystemInfoListVc.m
//  Socialize
//
//  Created by 余莹 on 2023/8/11.
//

#import "ChatWithSystemInfoListVc.h"
#import "ChatWithSystemInfoTableViewCell.h"
#import "IMBase.h"
#import "ImChangeTextTool.h"
#import "ZhiBoNetTool.h"
#import "BaseAlertManager.h"

@interface ChatWithSystemInfoListVc () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ChatWithSystemInfoListVc

- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dataArr;
}
- (UITableView *)tableView{
    if (!_tableView) {
        CGRect fram =  self.view.frame;
        _tableView = [[UITableView alloc]initWithFrame:fram style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = YES;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

#define  kFreeper_Message_ID   @"Freeper_Message"
#define  kFreeper_Notification_ID   @"Freeper_Notification"
#define  kFreeper_C2C_Freeper       @"c2c_Freeper" //0828判断条件处理
- (void)viewDidLoad {
    [super viewDidLoad];
    
    DLog(@"%@  self.conversation.conversationID  ",self.conversation.conversationID);
    DLog(@"%@  self.conversation.userID  ",self.conversation.userID);
    if([self.conversation.conversationID containsString:kFreeper_Message_ID]){
        self.title = Y_LocaleTypeFile_NSLocalString(@"系统消息");
    }else if([self.conversation.conversationID containsString:kFreeper_Notification_ID]){
        self.title = Y_LocaleTypeFile_NSLocalString(@"服务通知");
    }else{
        
    }
    
    [self initView];
    [self addRefresh];
    [self initListData];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self willNav];
}

- (void)willNav{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    NSString *nowThemeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:kTheme_Type_Key];//Theme_Type #define  kTheme_Type_Key   @"Theme_Type"
    if([nowThemeStr isEqualToString: @"light"]){
        [self setupNavigationBarblackTextColorWithBackViewCustomColor:[UIColor tui_colorWithHex: Theme_Nav_COlOR_Light_Str]];
    }else{
        [self setupNavigationBarWhiteTextColorWithBackViewCustomColor:[UIColor tui_colorWithHex:Theme_Nav_COlOR_Drak_Str]];
    }
}

- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initListData)];
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    self.tableView.mj_header = headeerRefresh;
    self.tableView.mj_footer = footerRefresh;
}
#define  kTheme_Type_Key   @"Theme_Type"
- (void)initView{
    NSString *nowThemeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:kTheme_Type_Key];//Theme_Type #define  kTheme_Type_Key   @"Theme_Type"
//    if([nowThemeStr isEqualToString: @"light"]){
//        self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:@"#FFFFFF"];
//    }else{
//        self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:@"#000000"];
//    }
    if([nowThemeStr isEqualToString: @"light"]){
        self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str];
    }else{
        self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Drak_Str];
    }
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
    }];
}
- (void)initListData{
    self.dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    [self getData];
    [self clearnRedWithRead];//暂时不清
}

#define  kFreeper_C2C_Freeper       @"c2c_Freeper" //0828判断条件处理
- (void)clearnRedWithRead{
    //单聊     会话唯一 ID 清理单聊会话的未读消息计数 |0829系统消息暂时不走清除动作
    //回话ID c2c userid 半截
//    if( [self.conversation.conversationID containsString:kFreeper_C2C_Freeper]){
//        return;
//    }//0901 继续已读
    [[V2TIMManager sharedInstance] cleanConversationUnreadMessageCount:self.conversation.conversationID cleanTimestamp:0 cleanSequence:0 succ:^{
    } fail:^(int code, NSString *desc) {
    }];
}
- (void)getData{

    
    V2TIMMessage *lastMsg = nil;
    
    if(self.dataArr.count != 0){
        lastMsg = self.dataArr.lastObject;
    }
    WEAKSELF
    [[V2TIMManager sharedInstance] getC2CHistoryMessageList:self.conversation.userID count:Y_PAGE_SIZE_10 lastMsg:lastMsg succ:^(NSArray<V2TIMMessage *> *msgs) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        NSLog(@"dataArr %ld",self.dataArr.count);
        [weakSelf.dataArr addObjectsFromArray:msgs];
        NSLog(@"dataArr addObjectsFromArray后 %ld",self.dataArr.count);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } fail:^(int code, NSString *desc) {
        
        NSLog(@"code %d, desc %@",code ,desc);
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
    
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatWithSystemInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatWithSystemInfoTableViewCell_I];
    if(!cell){
        cell =  [[ChatWithSystemInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ChatWithSystemInfoTableViewCell_I];
    }
    
    V2TIMMessage *msg = self.dataArr[indexPath.row];
    cell.timeL.text = [YTimeStamp getTimeShwoStr_Date:msg.timestamp];
    cell.nameL.text = msg.nickName.length>0 ? msg.nickName : msg.userID;
    
    if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
        [cell.imgV sd_setImageWithURL:[NSURL URLWithString:msg.faceURL] placeholderImage:[UIImage imageNamed:@"default_c2c_head_0821W"]];
    }else{
        [cell.imgV sd_setImageWithURL:[NSURL URLWithString:msg.faceURL] placeholderImage:[UIImage imageNamed:@"default_c2c_head_0821D"]];
    }
    
    cell.contentL.text  = [self imTextMsgToolOfSystemMsgChangeShowStr: msg.textElem.text];
    if([cell.nameL.text isEqualToString:@"服务通知"]){
        cell.nameL.text = Y_LocaleTypeFile_NSLocalString(@"服务通知");
    }else if([cell.nameL.text isEqualToString:@"系统消息"] ){
        cell.nameL.text = Y_LocaleTypeFile_NSLocalString(@"系统消息");
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    V2TIMMessage *msg = self.dataArr[indexPath.row];
    NSString *okStr = msg.textElem.text;
    NSMutableDictionary *allDic_C = [Y_ToolOfOthers dictionaryWithJsonString:okStr].mutableCopy;
    ImChangeTextUseContentModel *contMMM;
    if([[allDic_C allKeys] containsObject:@"content"]){
        if( [[allDic_C objectForKey:@"content"] isKindOfClass:[NSString class]]){
            NSString *contentStr =  [allDic_C objectForKey:@"content"];
            NSDictionary *contentStrDic = [Y_ToolOfOthers dictionaryWithJsonString:contentStr];
            [allDic_C setObject:contentStrDic forKey:@"content"];
            NSLog(@" allDic_C contentStrDic == %@",contentStrDic);
            
            contMMM = [ImChangeTextUseContentModel mj_objectWithKeyValues:contentStrDic];
            if(isNil(contMMM.detailsIdSSSS)){
                if([[contentStrDic allKeys] containsObject:@"detailsId"]){
                    NSString *detailsIdOk = [TextShowWithModelStr textShowWithModelStr:[contentStrDic objectForKey:@"detailsId"]];
                    contMMM.detailsIdSSSS = detailsIdOk;
                }
            }
            NSLog(@"allDic_C contMMM .detailsId == %@",contMMM.detailsIdSSSS);
 
        }else{
            
        }
     }
    ImChangeTextUseMainModel *mainModel =   [ImChangeTextUseMainModel mj_objectWithKeyValues:allDic_C];
    if(isNil(contMMM)){
        contMMM = mainModel.content;
    }else{
        mainModel.content = contMMM;//给detailsId
    }
 
//    if([mainModel.msgType isEqualToString: @"txt"] && [mainModel.from isEqualToString:@"Service"]){//文本类型
    if([mainModel.msgType isEqualToString: @"txt"] && ([mainModel.from isEqualToString:@"Service"] || [mainModel.from isEqualToString:@"System"]) ){
        NSLog(@" didSelectRowAtIndexPath changeImTextToolWithDic -- %@",allDic_C);
        if ([mainModel.content.category isEqualToString: @"SystemNotice"]) {//SystemNotice类型
         }else if([mainModel.content.category isEqualToString: @"MarketAuctionRecord"]){//直播通
         }else if([mainModel.content.category isEqualToString: @"ActivityMember"]){//
         }else if([mainModel.content.category isEqualToString: @"Activity"]){//
            
            if(mainModel.content.contentIndex == 2 || mainModel.content.contentIndex == 3 ){//快去观看吧
                /**
                 {
                     "category": "Activity",
                     "contentIndex": 3,
                     "detailsId": "c9ae54f8-c80e-4bcd-8aee-6f1f7ae9bcad",
                     "myUser": {
                         "address": "0xf2504a866bed5fb0a58e5fd92e9cec069fa578f5",
                         "domain": "aaaaaaaaaa.free",
                         "imId": "ueVPpA2rSrKnT",
                         "profileImageUrl": "https://test.freeper.l-z.vip:61131/avatar/2023-08/5/1jFW9OF_720_543_32751_gmi.jpg"
                     },
                     "othersUser": {
                         "address": "0xf2504a866bed5fb0a58e5fd92e9cec069fa578f5",
                         "domain": "aaaaaaaaaa.free",
                         "imId": "ueVPpA2rSrKnT",
                         "profileImageUrl": "https://test.freeper.l-z.vip:61131/avatar/2023-08/5/1jFW9OF_720_543_32751_gmi.jpg"
                     },
                     "parameters": {
                         "title": "0810v1"
                     },
                     "state": 3
                 }
                 */
                
                
                NSString *detailsId = [NSString stringWithFormat:@"%@",mainModel.content.detailsIdSSSS];
               
                
                
                ImChangeTextUseContent_subParametersOrMyUser_Model *myUser = [ImChangeTextUseContent_subParametersOrMyUser_Model mj_objectWithKeyValues:mainModel.content.myUser];
                ImChangeTextUseContent_subParametersOrMyUser_Model *otherUser = [ImChangeTextUseContent_subParametersOrMyUser_Model mj_objectWithKeyValues:mainModel.content.othersUser];
                if([myUser.address isEqualToString:otherUser.address]){//继续直播
                    [self checkZhiBoInfoWithDetailsId:detailsId withJixuBool:YES] ;
                    
                }else{//观看直播
                    [self checkZhiBoInfoWithDetailsId:detailsId withJixuBool:NO];
                    
                }

                
                
                NSLog(@"detailsId %@",detailsId);
            }
         }else if([mainModel.content.category isEqualToString: @"GroupCreated"]){
         }else if([mainModel.content.category isEqualToString: @"NftDomain"]){//
         }else if([mainModel.content.category isEqualToString: @"MarketTradingRecord"]){//
         }else if([mainModel.content.category isEqualToString: @"MarketTradingPlatform"]){//
 
      
            
        }else{
            
        }
    }
    
}

#pragma mark ====

//系统消息才调用本方法
- (NSString *)imTextMsgToolOfSystemMsgChangeShowStr:(NSString *)willUseStr{
    NSString *okStr = willUseStr;
    NSDictionary *allDic = [Y_ToolOfOthers dictionaryWithJsonString:willUseStr];
    if(isNil(allDic)){//判断有无 再处理各种类型文本
        return okStr;
    }else{
        return [ImChangeTextTool changeImTextToolWithDic:allDic];
    }
    
}

#pragma mark ===
- (void)checkZhiBoInfoWithDetailsId:(NSString *)detailsId withJixuBool:(BOOL)jiXuBool{
    
    WEAKSELF
    [[ZhiBoNetTool share] getOneZhiBoDetailInfoWithActivityID:detailsId withBlock:^(NSDictionary * _Nonnull dicOfBlock, BOOL succes) {
       
        if(succes){
            ZhiBoShowInfoModel *model = [ZhiBoShowInfoModel mj_objectWithKeyValues:dicOfBlock];
            if(jiXuBool){
                [weakSelf goToZhiBoVcWithCreatUserWithThisZhiBoInfoMode:model];

            }else{
                [weakSelf aleatOk_LookerGotoZhiBoWithInfoMode:model];
            }
        }
        
    }];
    
    
    
}



#pragma mark ===//去开直播
- (void)goToZhiBoVcWithCreatUserWithThisZhiBoInfoMode:(ZhiBoShowInfoModel*)zhiBoInfoModel{
    NSString *showMsg = @"";
    
    NSString *typeS = (zhiBoInfoModel.category==2) ? Y_LocaleTypeFile_NSLocalString(@"语音") : Y_LocaleTypeFile_NSLocalString(@"视频");
        NSString *zhibo = Y_LocaleTypeFile_NSLocalString(@"直播");
    if(zhiBoInfoModel.state == 4){
        NSString *jiesu = Y_LocaleTypeFile_NSLocalString(@"已结束");
        Y_SVP_SHOW_INFO_MES(jiesu)
        return;
    }
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
                weakSelf.navigationItem.titleView = nil;
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
 
@end
