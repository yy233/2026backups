//
//  GroupOfScanOkReqBecomGMember.m
//  Socialize
//
//  Created by 余莹 on 2023/8/18.
//

#import "GroupOfScanOk_DetailInfoVcOfApplingVc.h"



@interface GroupOfScanOk_DetailInfoVcOfApplingVc ()
@property (nonatomic,strong) NSMutableArray *listData;
@end

@implementation GroupOfScanOk_DetailInfoVcOfApplingVc
 

- (NSMutableArray *)listData{
    if(!_listData){
        NSString *mAllC = Y_LocaleTypeFile_NSLocalString(@"群成员信息") ;
        NSString *memberC = Y_LocaleTypeFile_NSLocalString(@"管理员") ;
        _listData = [[NSMutableArray alloc]initWithObjects:mAllC,memberC, nil];
    }
    return _listData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor orangeColor];
    if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
        self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str];
//        self.tableView.backgroundColor = self.view.backgroundColor;
    }else{
        self.view.backgroundColor = [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Drak_Str];
//        self.tableView.backgroundColor = self.view.backgroundColor;
    }
   
    self.title = Y_LocaleTypeFile_NSLocalString(@"群聊资料") ;
    [self initViews];
    [self initUisColor];
    [self initDatas];
    
    [self setNeedsStatusBarAppearanceUpdate];//顶部状态栏主题相关
}

//顶部状态栏主题相关
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    if (@available(iOS 13.0, *)) {
        NSString *nowThemeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:kTheme_Type_Key];//Theme_Type #define  kTheme_Type_Key   @"Theme_Type"
        if([nowThemeStr isEqualToString: @"light"]){
            return UIStatusBarStyleDarkContent ;//黑色内容
        }else{
            return UIStatusBarStyleLightContent;//白色内容
        }
    }
    return UIStatusBarStyleDefault;//白色内容
}
- (void)initViews{

    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];//透明色
    [self.view addSubview:self.applyForBecomeGroupMemberBtn];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
    }];
    [_applyForBecomeGroupMemberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(50);
        make.width.equalTo(_applyForBecomeGroupMemberBtn.superview.mas_width).offset(-40);
        make.centerX.equalTo(_applyForBecomeGroupMemberBtn.superview);
        make.bottom.equalTo(_applyForBecomeGroupMemberBtn.superview).offset(-100);
    }];
    self.tableView.tableHeaderView = self.headerView;
    
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = YES;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


- (GroupOfScanOk_DetailInfoVcOfApplingVc_SubHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[GroupOfScanOk_DetailInfoVcOfApplingVc_SubHeaderView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 100)];
    }
    return  _headerView;
}



- (UIButton *)applyForBecomeGroupMemberBtn{
    if(!_applyForBecomeGroupMemberBtn){
        _applyForBecomeGroupMemberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_applyForBecomeGroupMemberBtn newAnBtnWithLayerCorNerNum:22.0 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_applyForBecomeGroupMemberBtn newAnBtnWithBackColor: Color_Socialize_GreenColor];
        [_applyForBecomeGroupMemberBtn newAnBtnWithTextColor: [UIColor blackColor]];
        NSString *titS = Y_LocaleTypeFile_NSLocalString(@"申请加入群聊") ;
        [_applyForBecomeGroupMemberBtn newAnBtnWithTextStr:titS];
        [_applyForBecomeGroupMemberBtn addTarget:self action:@selector(applyForBecomeGroupMemberBtnActionGoVc) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyForBecomeGroupMemberBtn;
}
- (void)applyForBecomeGroupMemberBtnActionGoVc{
    DLog(@"");
    GroupSendApplyInfoVc *vc = [[GroupSendApplyInfoVc alloc]init];
    vc.groupInfoRes = self.groupInfoRes;
    [self.navigationController pushViewController:vc animated:YES];
}

 
- (void)initUisColor{
//    self.tableView.backgroundColor = Color_245Gray;
}
- (void)initDatas{
    if(self.groupId.length<=0){
        return;
    }
    WEAKSELF
    [[V2TIMManager sharedInstance]getGroupsInfo:@[self.groupId] succ:^(NSArray<V2TIMGroupInfoResult *> *groupResultList) {
        weakSelf.groupInfoRes  =  groupResultList.firstObject;
        weakSelf.headerView.titleL.text = weakSelf.groupInfoRes.info.groupName;
        NSInteger creatTimeIV = weakSelf.groupInfoRes.info.createTime;
        weakSelf.headerView.titleLBittomL.text = [YTimeStamp getYMDhmsTimeStrUseInfoTimeIvStr: [NSString stringWithFormat:@"%ld",(long)creatTimeIV]];
        
        UIImage *placeholderImg = [UIImage lightGrayColorImage];
        if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
            placeholderImg = [UIImage imageNamed:@"default_c2c_head_0821W"];
        }else{
            placeholderImg = [UIImage imageNamed:@"default_c2c_head_0821D"];
        }
        if(weakSelf.groupInfoRes.info.faceURL.length>=0){
            [weakSelf.headerView.groupImg sd_setImageWithURL:[NSURL URLWithString:weakSelf.groupInfoRes.info.faceURL] placeholderImage:placeholderImg];
        }else{
            weakSelf.headerView.groupImg.backgroundColor =  [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
        }
        
        [weakSelf.tableView reloadData];
        
    } fail:^(int code, NSString *desc) {
        NSLog(@"获取失败 code=%d,desc= %@",code,desc);
        Y_SVP_SHOW_ERR_MES(desc);
    }];
    
}
#pragma mark ==
 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell_base"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell_base"];
        if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = Color_51BlackColor;
            cell.detailTextLabel.textColor = [Color_51BlackColor colorWithAlphaComponent:0.7];
        }else{
            cell.backgroundColor = [UIColor  tui_colorWithHex:@"333333"];
            cell.contentView.backgroundColor = [UIColor  tui_colorWithHex:@"333333"];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.detailTextLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        }
  
    }

    cell.textLabel.text = self.listData[indexPath.row];
    if(indexPath.row == 0 ){
        cell.detailTextLabel.text = self.groupInfoRes.info.memberCount > 0 ? [NSString stringWithFormat:@"%u", self.groupInfoRes.info.memberCount]  : 0;
    }else{
        cell.detailTextLabel.text = @"-";//self.groupInfoRes.info.memberMaxCount;//最大允许//暂时未获取
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
@end


#pragma mark === GroupOfScanOk_DetailInfoVcOfApplingVc_SubHeaderView


@implementation GroupOfScanOk_DetailInfoVcOfApplingVc_SubHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.groupImg];
        [self addSubview:self.titleL];
        [self addSubview:self.titleLBittomL];
        [self addSubview:self.groupQRTocuhBtn];
        [self setUIss];
        
        if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
            self.backgroundColor = [UIColor whiteColor];
            self.titleL.textColor = Color_51BlackColor;
            self.titleLBittomL.textColor = Color_51BlackColor;
            
        }else{
            self.backgroundColor = [UIColor tui_colorWithHex:@"#333333"];
            self.titleL.textColor = [UIColor whiteColor];
            self.titleLBittomL.textColor = [UIColor whiteColor];
        }

    }
    return self;
}
- (void)setUIss{
    [_groupImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_groupImg.superview).offset(20);
        make.width.height.offset(60.0);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_groupImg);
        make.left.equalTo(_groupImg.mas_right).offset(10);
        make.right.equalTo(_titleL.superview);
    }];
    [_titleLBittomL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleL);
        make.bottom.equalTo(_groupImg);
    }];
    [_groupQRTocuhBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.bottom.equalTo(_groupImg);
        make.right.equalTo(_groupQRTocuhBtn.superview).offset(-20);
    }];
    
}

- (UIImageView *)groupImg{
    if(!_groupImg){
        _groupImg = [[UIImageView alloc]init];
        _groupImg.contentMode = UIViewContentModeScaleAspectFill;
        _groupImg.layer.cornerRadius = 6.0;
        _groupImg.layer.maskedCorners = YES;
    }
    return _groupImg;
}
- (UILabel *)titleL{
    if(!_titleL){
        _titleL =[[UILabel alloc]init];
        _titleL.font = [UIFont boldSystemFontOfSize:24.0];
        _titleL.textColor = Color_51BlackColor;
    }
    return _titleL;
}
-  (UILabel *)titleLBittomL{
    if(!_titleLBittomL){
        _titleLBittomL =[[UILabel alloc]init];
        _titleLBittomL.font = [UIFont systemFontOfSize:14.0];
        _titleLBittomL.textColor = Color_51BlackColor;
    }
    return _titleLBittomL;
}
 
- (UIButton *)groupQRTocuhBtn{
    if(!_groupQRTocuhBtn){
        _groupQRTocuhBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _groupQRTocuhBtn;
}
@end


#pragma mark === GroupSendApplyInfoVc


@implementation GroupSendApplyInfoVc
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor orangeColor];
    self.title = Y_LocaleTypeFile_NSLocalString(@"申请加群") ;
    [self initViews];
    [self initUisColor];

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
- (void)initUisColor{
    
    if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
        self.view.backgroundColor = [UIColor tui_colorWithHex:Theme_Bk_COlOR_Light_Str];
        self.textView.backgroundColor = [UIColor whiteColor];
        self.textView.textColor = Color_51BlackColor;
        self.textView.tintColor =  self.textView.textColor;
    }else{
        self.view.backgroundColor = [UIColor tui_colorWithHex:Theme_Bk_COlOR_Drak_Str];
        self.textView.backgroundColor = [UIColor clearColor];
        self.textView.textColor = Color_245Gray;
        self.textView.tintColor =  self.textView.textColor;
    }
    
   
    
    
}
- (void)initViews{
     
    [self.view addSubview:self.sendBtn];
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(50);
        make.width.equalTo(_sendBtn.superview.mas_width).offset(-40);
        make.centerX.equalTo(_sendBtn.superview);
        make.bottom.equalTo(_sendBtn.superview).offset(-100);
    }];
    
    UILabel *hetextV = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, Screen_W-20, 30)];
    hetextV.text = Y_LocaleTypeFile_NSLocalString(@"验证消息") ;
    hetextV.backgroundColor = [UIColor clearColor];
    hetextV.textColor = Color_153GrayColor;
    hetextV.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:hetextV];
    [self.view addSubview:self.textView];
    
}
- (UITextView *)textView{
    if(!_textView){
        _textView = [[UITextView alloc]init];
        _textView.frame = CGRectMake(10, 30, Screen_W-20, 66);
        _textView.font = [UIFont systemFontOfSize:14.0];
    }
    return _textView;
}

 
- (UIButton *)sendBtn{
    if(!_sendBtn){
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn newAnBtnWithLayerCorNerNum:22.0 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_sendBtn newAnBtnWithBackColor: Color_Socialize_GreenColor];
        [_sendBtn newAnBtnWithTextColor: [UIColor blackColor]];
        NSString *titS = Y_LocaleTypeFile_NSLocalString(@"发送") ;
        [_sendBtn newAnBtnWithTextStr:titS];
        [_sendBtn addTarget:self action:@selector(sendBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}
- (void)sendBtnAction{
//    self.groupInfoRes.info.groupType;//加群需群主或管理员审批Public  或者自由进出Meeting
    if(self.groupInfoRes.info.groupID.length<=0){
        return;
    }
    if(self.textView.text.length<=0){
        self.textView.text = @"";
    }
    WEAKSELF
    if([self.groupInfoRes.info.groupType isEqual:@"Meeting"]){//直接加入群
        [[V2TIMManager sharedInstance] joinGroup:self.groupInfoRes.info.groupID msg:@"" succ:^{
            Y_SVP_SHOW_SUCCESS_MES(@"success");
            [weakSelf successSendApplyAndGoBackRootVc];
            
        } fail:^(int code, NSString *desc) {
            NSLog(@"加群失败 code=%d,desc= %@",code,desc);
            Y_SVP_SHOW_ERR_MES(desc);
        }];
        
    }else{//提交加群申请
        [[V2TIMManager sharedInstance] joinGroup:self.groupInfoRes.info.groupID msg:self.textView.text succ:^{
            Y_SVP_SHOW_SUCCESS_MES(@"success");
            [weakSelf successSendApplyAndGoBackRootVc];
        } fail:^(int code, NSString *desc) {
            NSLog(@"加群申请提交失败 code=%d,desc= %@",code,desc);
            Y_SVP_SHOW_ERR_MES(desc);
        }];
        
    }
}

/**
 GroupSendApplyInfoVc
 GroupOfScanOk_DetailInfoVcOfApplingVc
 */

/**
 ImChatVc *vc = [[ImChatVc alloc]init];
 vc.converInfo  = data;
 vc.isGroupType =  YES;
 vc.groupId = groupID;
 vc.title = self.headerView.textFied.text;
 vc.hidesBottomBarWhenPushed = YES;
 [self.navigationController pushViewController:vc animated:YES];
 */
- (void)successSendApplyAndGoBackRootVc{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        for (UIViewController * vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:NSClassFromString(@"GroupSendApplyInfoVc")] || [vc isKindOfClass:NSClassFromString(@"GroupOfScanOk_DetailInfoVcOfApplingVc")]) {
                [tempArray removeObject:vc];
            }
        }
    self.navigationController.viewControllers = tempArray;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
