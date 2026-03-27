//
//  VoiceTopView.m
//  TUIVoiceRoom
//
//  Created by 余莹 on 2023/5/31.
//

#import "VoiceTopView.h"
#import "VoiceOcFileUse_Header.h"
#import "Masonry.h"
#import "VoiceOcTool.h"
#import <SDWebImage/SDWebImage.h>

#import "VoiceTopViewSubCollectionViewCell.h"
#import "TRTCCloud.h"
 
#import <TUIVoiceRoom/TUIVoiceRoom-Swift.h>

#define Item_W  (34)
#define Item_H  (34)

#define  nameL_w (63.0)
#define  nameL_H (16.0)
 

@interface VoiceTopView () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSMutableArray *dataArr;
#pragma mark ==
//@property (nonatomic,strong) TRTCVoiceRoomViewModel *viewModel;

@end

@implementation VoiceTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.xuNiPersonSave = 0;
        //
        [self addSubview:self.leftBk];
        [self addSubview:self.rightBk];
        [self addSubview:self.gongGaoBk];
        
        [self.leftBk addSubview:self.headerImgv];
        [self.leftBk addSubview:self.nickNameLabel];
        [self.leftBk addSubview:self.reDuImgV];
        [self.leftBk addSubview:self.reDuNumLabel];
        [self.leftBk addSubview:self.guanZhuRedBtn];
        //
        [self.rightBk addSubview:self.memberBkView];
        [self.rightBk addSubview:self.closeBtn];
        [self.rightBk addSubview:self.collectionView];
        //
        [self.gongGaoBk addSubview:self.gonggaoImgv];
        [self.gongGaoBk addSubview:self.gonggaoLabel];
        [self selfViewsUI];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //
        [self addSubview:self.leftBk];
        [self addSubview:self.rightBk];
        [self addSubview:self.gongGaoBk];
        
        //
        [self.leftBk addSubview:self.headerImgv];
        [self.leftBk addSubview:self.nickNameLabel];
        [self.leftBk addSubview:self.reDuImgV];
        [self.leftBk addSubview:self.reDuNumLabel];
        [self.leftBk addSubview:self.guanZhuRedBtn];
        //
        [self.rightBk addSubview:self.memberBkView];
        [self.rightBk addSubview:self.closeBtn];
        [self.memberBkView addSubview:self.collectionView];//成员
        //
        [self.gongGaoBk addSubview:self.gonggaoImgv];
        [self.gongGaoBk addSubview:self.gonggaoLabel];
        [self selfViewsUI];
    }
    return self;
}

- (void)selfViewsUI{
    [_leftBk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(_leftBk.superview).offset(10);
        make.width.offset(150);
        make.height.offset(40);
    }];
    [_rightBk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftBk.mas_right).offset(3);
        make.right.equalTo(_rightBk.superview).offset(-15);
        //make.centerY.height.equalTo(_leftBk);
        make.top.equalTo(_headerImgv);
        make.height.equalTo(_headerImgv);
    }];
    [_gongGaoBk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftBk.mas_bottom).offset(5);
        make.left.equalTo(_leftBk);
        make.height.offset(20);
        //make.width.offset(64);
    }];
    
    
    //    _memberBkView.backgroundColor = [UIColor blueColor];
    //    _collectionView.backgroundColor = [UIColor brownColor];
    //    _rightBk.backgroundColor = [UIColor redColor];
    
    
    [self leftViewS];
    [self rightViewS];
    [self gongGaoViewS];
    
    
}

- (void)leftViewS{//40h 150w
    
    _leftBk.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    _leftBk.layer.cornerRadius = 20;
    _leftBk.layer.masksToBounds = YES;
    [_headerImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(34);
        make.centerY.equalTo(_headerImgv.superview);
        make.left.equalTo(_headerImgv.superview).offset(5);
    }];
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(nameL_w);
        make.left.equalTo(_headerImgv.mas_right).offset(5);
        make.height.offset(nameL_H);
        make.top.equalTo(_headerImgv);
    }];
    [_reDuImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(12);
        make.width.offset(10);
        make.left.equalTo(_nickNameLabel);
        make.bottom.equalTo(_headerImgv);
    }];
    
    [_reDuNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_reDuImgV);
        make.bottom.equalTo(_reDuImgV);
        make.left.equalTo(_reDuImgV.mas_right).offset(3);
        make.right.equalTo(_nickNameLabel);
    }];
    [_guanZhuRedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(24);
        make.width.offset(36);
        make.left.equalTo(_nickNameLabel.mas_right).offset(2);
        make.centerY.equalTo(_guanZhuRedBtn.superview);
    }];
}

- (void)rightViewS{
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(30);
        make.centerY.right.equalTo(_closeBtn.superview);
    }];
    [_memberBkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(_memberBkView.superview);
        make.right.equalTo(_closeBtn.mas_left).offset(-10);
    }];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_memberBkView);
    }];
}

- (void)gongGaoViewS{
    _gongGaoBk.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];//20h 64w
    _gongGaoBk.layer.cornerRadius = 10;
    _gongGaoBk.layer.masksToBounds = YES;
    
    
    [_gonggaoImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_gonggaoImgv.superview).offset(10);
        make.height.offset(10);
        make.width.offset(12);
        make.centerY.equalTo(_gonggaoImgv.superview);
    }];
    [_gonggaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_gonggaoLabel.superview);
        make.left.equalTo(_gonggaoImgv.mas_right).offset(3);
        make.right.equalTo(_gonggaoLabel.superview).offset(-3);
    }];
}
#pragma mark ==== bk
- (UIView *)leftBk{
    if(!_leftBk){
        _leftBk = [[UIView alloc]init];
    }
    return _leftBk;
}
- (UIView *)rightBk{
    if(!_rightBk){
        _rightBk = [[UIView alloc]init];
    }
    return _rightBk;
}
- (UIView *)gongGaoBk{
    if(!_gongGaoBk){
        _gongGaoBk = [[UIView alloc]init];
    }
    return _gongGaoBk;
}

#pragma mark ==== left
- (UIImageView *)headerImgv{
    if(!_headerImgv){
        _headerImgv = [[UIImageView alloc]init];
        _headerImgv.contentMode = UIViewContentModeScaleAspectFill;
        _headerImgv.layer.cornerRadius = 16;
        _headerImgv.layer.masksToBounds = YES;
        _headerImgv.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
        
    }
    return _headerImgv;
}
- (KJMarqueeLabel2 *)nickNameLabel{
    if(!_nickNameLabel){
       CGRect nameR = CGRectMake(34+5+5, 3, nameL_w, nameL_H);
        _nickNameLabel = [[KJMarqueeLabel2 alloc]initWithFrame:nameR];
        _nickNameLabel.textColor = podUse_rgba(255, 255, 255, 1);
        _nickNameLabel.font = [UIFont systemFontOfSize:13];
        _nickNameLabel.marqueeLabelType = KJMarqueeLabelTypeLeft;
    }
    return _nickNameLabel;
}
 

- (UIImageView *)reDuImgV{
    if(!_reDuImgV){
        _reDuImgV = [[UIImageView alloc]init];
        _reDuImgV.contentMode = UIViewContentModeScaleAspectFit;
        _reDuImgV.image = [VoiceOcTool getVoiceUseImgWithImgIconNameStr:@"热度"];
        
    }
    return _reDuImgV;
}
//0922改成总人数
- (UILabel *)reDuNumLabel{
    if(!_reDuNumLabel){
        _reDuNumLabel = [[UILabel alloc]init];
        _reDuNumLabel.textColor = podUse_rgba(255, 255, 255, 1);
        _reDuNumLabel.font = [UIFont systemFontOfSize:10];
        
    }
    return _reDuNumLabel;
}

-(UIButton *)guanZhuRedBtn{
    if (!_guanZhuRedBtn) {
        _guanZhuRedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_guanZhuRedBtn setBackgroundColor:podUse_rgba(255, 79, 79, 1)];
        _guanZhuRedBtn.layer.cornerRadius = 12;//h.w 24.36
        _guanZhuRedBtn.layer.masksToBounds = YES;
        
        //        [_guanZhuRedBtn setImage:[UIImage imageNamed:@"已关注"
        //                                            inBundle: [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"TUIVoiceRoomKitBundle" withExtension:@"bundle"]]
        //                       compatibleWithTraitCollection:nil]
        //                        forState:UIControlStateNormal];
        [_guanZhuRedBtn setImage:[VoiceOcTool getVoiceUseImgWithImgIconNameStr:@"已关注"] forState:UIControlStateNormal];
        
    }
    return _guanZhuRedBtn;
}

#pragma mark ==== left
- (UIButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_closeBtn setImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];//这是引到了主项目img
        [_closeBtn setImage:[VoiceOcTool getVoiceUseImgWithImgIconNameStr:@"btn_close"]
                   forState:UIControlStateNormal];
    }
    return _closeBtn;
}

- (UIView *)memberBkView{
    if(!_memberBkView){
        _memberBkView = [[UIView alloc]init];
    }
    return _memberBkView;
}
- (UICollectionView *)collectionView{
    if(!_collectionView){
        
        ///水平滑动 UICollectionViewScrollDirectionHorizontal
        //         UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //         layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero
        //                                            collectionViewLayout:layout];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero
                                            collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[VoiceTopViewSubCollectionViewCell class] forCellWithReuseIdentifier:VoiceTopViewSubCollectionViewCell_I];
        _collectionView.scrollEnabled = YES;
        
    }
    return _collectionView;
}
#pragma mark ==== gonggao

- (UIImageView *)gonggaoImgv{
    if(!_gonggaoImgv){
        _gonggaoImgv = [[UIImageView alloc]init];
        _gonggaoImgv.contentMode = UIViewContentModeScaleAspectFit;
        _gonggaoImgv.image = [VoiceOcTool getVoiceUseImgWithImgIconNameStr:@"公告"];
    }
    return _gonggaoImgv;
}
- (UILabel *)gonggaoLabel{
    if(!_gonggaoLabel){
        _gonggaoLabel = [[UILabel alloc]init];
        _gonggaoLabel.textColor = podUse_rgba(255, 255, 255, 1);
        _gonggaoLabel.font = [UIFont systemFontOfSize:10];
    }
    return _gonggaoLabel;
}


#pragma mark ====
//房间名字
- (void)topViewSetInfoWithRoomName:(NSString *)roomName{
    self.nickNameLabel.text = @"";
    if(roomName.length>0){
        self.nickNameLabel.text = roomName;
        NSLog(@"voice 房间 名字 = %@",roomName);

    }
}

- (BOOL)isNotNil:(id)obj
{
    return (obj != nil && ![obj isEqual:[NSNull null]] && ![obj isEqual:nil]);
}
- (BOOL)isNil:(id)obj
{
    return (obj == nil || [obj isEqual:[NSNull null]] || [obj isEqual:nil]);
}

- (void)dealloc{
     
}
 

- (void)topViewSetInfoWithHeaderUrlStr:(NSString *)headerUrl{
    if(headerUrl.length>0){
        [self.headerImgv sd_setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:[VoiceOcTool getHeaderGrayColorImg]];
    }else{
        self.headerImgv.image = [VoiceOcTool getHeaderGrayColorImg];
    }
}
- (void)topViewSetInfoWithRoomName:(NSString *)roomName withHeaderUrl:(NSString *)headerUrl{
    if(roomName.length>0){
        self.nickNameLabel.text = roomName;
    }
    if(headerUrl.length>0){
        [self.headerImgv sd_setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:[VoiceOcTool getHeaderGrayColorImg]];
    }else{
        self.headerImgv.image = [VoiceOcTool getHeaderGrayColorImg];
    }
    
}

#pragma mark ===

- (void)reloadRoomXuNiPersonIndex:(int)showNum{
    self.reDuNumLabel.text = [NSString stringWithFormat:@"%d",showNum];
}
- (void)topViewSetReDuNum:(int)reDuNum{
    //人数
//    self.reDuNumLabel.text = [NSString stringWithFormat:@"ID:%d",reDuNum];
    self.reDuNumLabel.text = [NSString stringWithFormat:@"%d",reDuNum];

}


- (void)topViewSetGongGaoInfoWithGongGaoStr:(NSString *)gongGao{
    if(gongGao.length>0){
        self.gonggaoLabel.text = gongGao;
    }else{
        self.gonggaoLabel.text = voiceRoomLocalize(@"暂无公告");
    }
  
}

//AudienceInfoModel
- (void)topViewSetListWithMemberListInfo:(NSMutableArray <VoiceRoomUserInfo *> *)memberList{

    if(memberList.count>0){
         NSLog(@"memberList == %@",memberList);
//        AudienceInfoModel *model = memberList.firstObject;
        self.dataArr = [NSMutableArray arrayWithArray:memberList];
     }else{
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
     }
    [self.collectionView reloadData];
 

    NSLog(@"memberList ===刷新=   | arr = %@",self.dataArr);
}
//- (void)topViewInfoWithZhuBoUserInfo:(VoiceRoomUserInfo *)zhuBoUserInfo withMyInfo:(VoiceRoomUserInfo *)myUserInfo{
//    if ([zhuBoUserInfo.userId isEqualToString: myUserInfo.userId]) {//观众端
//        [self topViewChangeUIwithIsZhuBoBool:NO];
//    }else{//主播端 不显示关注按钮
//        [self topViewChangeUIwithIsZhuBoBool:YES];
//
//    }
//}

- (void)topViewInfoIsZhuBoBool:(BOOL)isZhuBo{
    if(!isZhuBo){//观众端
        [self topViewChangeUIwithIsZhuBoBool:NO];
    }else{//主播端 不显示关注按钮
        [self topViewChangeUIwithIsZhuBoBool:YES];
        
    }
}
//== 关注端 有关注按钮 主播端没有关注按钮
- (void)topViewChangeUIwithIsZhuBoBool:(BOOL)isZhuBo{
    isZhuBo = YES; //0902 先隐藏掉关注功能
 
    CGFloat leftBk_W = isZhuBo ? 110.0 :150.0;//少关注按钮的宽度
    [_leftBk mas_updateConstraints:^(MASConstraintMaker *make) {
        //观众端(150);//主播端40 或 110  有无title位置
        make.width.offset(leftBk_W);
    }];
    if(isZhuBo){
        _guanZhuRedBtn.hidden = YES;
    }else{
        _guanZhuRedBtn.hidden = NO;

     
    }
 
    
   
}

#pragma mar空==
- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
 
#pragma mark == 刷新相关
- (void)reloadAudienceList{
//    [trtc v r getRoomInfoList];
    NSLog(@"得到信息 reloadAudienceList");
}

 
- (void)reloadRoomInfoWithVoiceRoomInfo:(VoiceRoomInfo *)infoModel{
    //房名 昵称 热度 等可以设置 ｜但无数据过来
    NSLog(@"得到信息 reloadRoomInfoWithVoiceRoomInfo 得到房间信息");
    NSLog(@"%ld %@ %@ %@, coverUrl= %@ \n memberCount %ld ",(long)infoModel.roomID,infoModel.roomName,infoModel.ownerId,infoModel.ownerName,infoModel.coverUrl,(long)infoModel.memberCount);
    //ownerName 有效数据 创建者的名字
 
}
- (void)reloadRoomAvatar:(NSString*)currBkImgUrl{
    //房 背景图
    NSLog(@"得到信息 reloadRoomAvatar");//似乎关联着心跳 但是没有图片数据
}

#pragma mark -
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@" 语音顶部collectionView didSelectItemAtIndexPath %ld",(long)indexPath.row);
    NSLog(@" 语音顶部collectionView didSelectItemAtIndexPath %@",self.dataArr);
    if([self.dataArr[indexPath.row] isKindOfClass:[VoiceRoomUserInfo class]]){
        VoiceRoomUserInfo *memberFullInfo = (VoiceRoomUserInfo *)self.dataArr[indexPath.row];
        NSLog(@"  voice top view sub  collectionView ----    userID= %@  faceURL=%@  nickName= %@",memberFullInfo.userId,memberFullInfo.userName ,memberFullInfo.userAvatar);
   //    indexPath.row;
       if(_topViewDelegate && [_topViewDelegate respondsToSelector:@selector(voiceTopViewDelegateWithTouchMember:)]){
           [_topViewDelegate voiceTopViewDelegateWithTouchMember:memberFullInfo];
       }
    }else{
        V2TIMGroupMemberFullInfo *memberFullInfo = (V2TIMGroupMemberFullInfo *)self.dataArr[indexPath.row];
        NSLog(@"  voice top view sub  collectionView ----    userID= %@  faceURL=%@  nickName= %@",memberFullInfo.userID,memberFullInfo.faceURL ,memberFullInfo.nickName);
   //    indexPath.row;
       if(_topViewDelegate && [_topViewDelegate respondsToSelector:@selector(voiceTopViewDelegateWithTouchMember:)]){
           [_topViewDelegate voiceTopViewDelegateWithTouchMember:memberFullInfo];
       }
    }
 
   

}


#pragma mark - UICollectionViewDelegateFlowLayout
//动态设置每个Item的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Item_W, Item_H);
   
}

//动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);//某Section总的上下左右
}

//动态设置每列的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 3;
}
//动态设置每行的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

//动态设置某个分区头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(Screen_W, 0);
}
//动态设置某个分区尾视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(Screen_W, 0);
}
#pragma mark ==

//代理相应方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.dataArr.count>=20){
        return 20;
    }else{
        return self.dataArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VoiceTopViewSubCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:VoiceTopViewSubCollectionViewCell_I forIndexPath:indexPath];
 
     VoiceRoomUserInfo *userInfo =   self.dataArr[indexPath.row];
    if(userInfo.userAvatar.length>0){
        [cell.onlyShowImgView sd_setImageWithURL:[NSURL URLWithString:userInfo.userAvatar] placeholderImage:[VoiceOcTool getHeaderGrayColorImg]];
    }else{
        cell.onlyShowImgView.image = [VoiceOcTool getHeaderGrayColorImg];
    }
 
    return cell;
    
}


@end



#pragma mark ==  VoiceTopRedEnvView 红包

#define WaitGotView_W (48.0)
#define WaitGotView_H (44.0)

@interface VoiceTopRedEnv_WaitGotView ()

@end

@implementation VoiceTopRedEnv_WaitGotView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backView];
        [self.backView addSubview:self.redEnv_imgV];
        [self.backView addSubview:self.redEnv_TopBtn];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(WaitGotView_W);
            make.height.offset(WaitGotView_H);
            make.top.left.equalTo(_backView.superview);
        }];
        [_redEnv_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(WaitGotView_W);
            make.height.offset(WaitGotView_H);
            make.top.centerX.equalTo(_backView.superview);
        }];
        [_redEnv_TopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_redEnv_imgV);
        }];
        
        /**
         func addNoticeOfRedEnv() {
             
             let notice_name_GotSuccess : String = Chat_Got_RedEnv_Notice_Result as String;
             let notice_name_GotFail : String = Chat_Got_RedEnv_Notice_Result_isFail as String;
             
             NotificationCenter.default.addObserver(self, selector: #selector(red_Got_SucessAction(_:)), name:NSNotification.Name(notice_name_GotSuccess) , object: nil)
             NotificationCenter.default.addObserver(self, selector: #selector(red_Got_FailAction(_:)), name:NSNotification.Name(notice_name_GotFail) , object: nil)
     //        NotificationCenter.default.addObserver(self, selector: #selector(red_Got_FailAction(_:))), name:NSNotification.Name(notice_name_GotFail)  , object: nil)
         }
      
         
         @objc func red_Got_SucessAction(_ notification: Notification?) {
             let n_obj = notification?.object ?? "";
             if n_obj  && viewModel.thisRoomAllRedEnv_ZhuBoSendInfoList.count == 1 {
                 viewModel?.thisRoomAllRedEnv_ZhuBoSendInfoList.removeAllObjects()
                 self.topredview hiden
             }
             
             viewModel?.thisRoomAllRedEnv_ZhuBoSendInfoList.forEach({ redEnvdic in
             });
             
         }
         
         @objc func red_Got_FailAction(_ notification: Notification?)  {
         }*/
        
        [self addNoticeOfRedEnv];
    }
    return self;
}
- (void)addNoticeOfRedEnv{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(red_Got_SucessAction:) name:Chat_Got_RedEnv_Notice_Result object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(red_Got_FailAction:) name:Chat_Got_RedEnv_Notice_Result_isFail object:nil];
}

- (void)red_Got_SucessAction:(NSNotification *)notice{
    NSLog(@"red_Got_SucessAction");
    NSString *nObjStr = @"";
    if([notice.object isKindOfClass:[NSString class]]){
        nObjStr = [NSString stringWithFormat:@"%@",notice.object];
    }else{
        nObjStr = @"其他red_Got_SucessAction数据";
    }
    
    if(_zhuBoSendRedEnvList_GotRedEnvSuccessUseListArr.count>0){
        for (int i = 0 ; i < _zhuBoSendRedEnvList_GotRedEnvSuccessUseListArr.count; i++) {
            NSString *objStr = _zhuBoSendRedEnvList_GotRedEnvSuccessUseListArr[i];
            if([objStr containsString:nObjStr]){
                [_zhuBoSendRedEnvList_GotRedEnvSuccessUseListArr removeObjectAtIndex:i];
                break;
            }
        }
        
    }
    if(_zhuBoSendRedEnvList_GotRedEnvSuccessUseListArr.count == 0){
        self.hidden = YES;
    }else{
        //保持显示状态
    }
    
}

//----
typedef enum : NSUInteger {
    RedEnvelopePopView_GotedFail_Type_369001 = 369001,
    RedEnvelopePopView_GotedFail_Type_369002 = 369002,
    RedEnvelopePopView_GotedFail_Type_369003 = 369003,
    RedEnvelopePopView_GotedFail_Type_369004 = 369004,
    RedEnvelopePopView_GotedFail_Type_369005 = 369005,
    RedEnvelopePopView_GotedFail_Type_369006 = 369006,
    RedEnvelopePopView_GotedFail_Type_369007 = 369007,
    RedEnvelopePopView_GotedFail_Type_369008 = 369008,
    RedEnvelopePopView_GotedFail_Type_369009 = 369009,
    RedEnvelopePopView_GotedFail_Type_369010 = 369010,
    RedEnvelopePopView_GotedFail_Type_369011 = 369011,
    RedEnvelopePopView_GotedFail_Type_369012 = 369012,
    RedEnvelopePopView_GotedFail_Type_10101 = 10101,
    RedEnvelopePopView_GotedFail_Type_358005 = 358005,
} RedEnvelopePopView_GotedFail_Type;


- (void)red_Got_FailAction:(NSNotification *)notice{
    NSLog(@"red_Got_FailAction");
    if([notice.object isKindOfClass:[NSDictionary class]] ){
        NSDictionary *fobjDic = [NSDictionary dictionaryWithDictionary: notice.object];
        if([[fobjDic allKeys]containsObject: @"status"]){
           NSInteger status = [[fobjDic objectForKey:@"status"] integerValue];
            NSString *shwoStr = @"";
           
            switch (status) {
                case RedEnvelopePopView_GotedFail_Type_369001:
                {
                    shwoStr = [TUIGlobalization getLocalizedStringForKey:@"红包金额过低"  bundle:TUIChatLocalizableBundle] ;
                }
                    break;
             
                case RedEnvelopePopView_GotedFail_Type_369002:
                {
                    shwoStr = [TUIGlobalization getLocalizedStringForKey:@"余额加载异常，请稍后再试"  bundle:TUIChatLocalizableBundle];
                }
                    break;
                case RedEnvelopePopView_GotedFail_Type_369003:
                {
                    shwoStr = [TUIGlobalization getLocalizedStringForKey:@"您存在于该群组，请联系管理"  bundle:TUIChatLocalizableBundle];
                }
                    break;
                case RedEnvelopePopView_GotedFail_Type_369004:
                {
                    shwoStr = [TUIGlobalization getLocalizedStringForKey:@"红包记录不存在"  bundle:TUIChatLocalizableBundle];
                }
                    break;
                case RedEnvelopePopView_GotedFail_Type_369005:
                {
                    shwoStr= [TUIGlobalization getLocalizedStringForKey:@"您已经领取过该红包"  bundle:TUIChatLocalizableBundle];
                 }
                    break;
                case RedEnvelopePopView_GotedFail_Type_369006:
                {
                    shwoStr = [TUIGlobalization getLocalizedStringForKey:@"您手慢了，红包已经派完"  bundle:TUIChatLocalizableBundle];
                }
                    break;
                case RedEnvelopePopView_GotedFail_Type_369007:
                {
                    shwoStr = [TUIGlobalization getLocalizedStringForKey:@"定向红包，您无法领取"  bundle:TUIChatLocalizableBundle];
                }
                    break;
                case RedEnvelopePopView_GotedFail_Type_369008:
                {
                    shwoStr = [TUIGlobalization getLocalizedStringForKey:@"红包已过期"  bundle:TUIChatLocalizableBundle];
                }
                    break;
                case RedEnvelopePopView_GotedFail_Type_369009:
                {
                    shwoStr = [TUIGlobalization getLocalizedStringForKey:@"红包金额不能被平均分配"  bundle:TUIChatLocalizableBundle];
                }
                    break;
                    
                case RedEnvelopePopView_GotedFail_Type_369010:
                {
                    shwoStr = [TUIGlobalization getLocalizedStringForKey:@"领取错误"  bundle:TUIChatLocalizableBundle];
                }
                    break;
             

                case RedEnvelopePopView_GotedFail_Type_369011:
                {
                    shwoStr = [TUIGlobalization getLocalizedStringForKey:@"钱包超时，失效了"  bundle:TUIChatLocalizableBundle];
                }
                    break;

                case RedEnvelopePopView_GotedFail_Type_369012:
                {
                    shwoStr = [TUIGlobalization getLocalizedStringForKey:@"领取者重复了"  bundle:TUIChatLocalizableBundle];
                }
                    break;
                //
                case RedEnvelopePopView_GotedFail_Type_10101:
                {
                    shwoStr = [TUIGlobalization getLocalizedStringForKey:@"验签失败"  bundle:TUIChatLocalizableBundle];
                }
                    break;

                default:
                {
                    shwoStr = @"";
                }
                    
                    break;
            }
            NSLog(@"失败文本---- %@",shwoStr);
             
            if(self.showGotRedInfoMsgBlock != nil && ![self.showGotRedInfoMsgBlock isEqual:[NSNull null]] && ![self.showGotRedInfoMsgBlock isEqual:nil]){
                self.showGotRedInfoMsgBlock(shwoStr);
            }
            
        }
        
    }
    
}


- (UIView *)backView{
    if(!_backView){
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _backView.layer.cornerRadius = 2.0;
    }
    return _backView;
}
- (UIImageView *)redEnv_imgV{
    if(!_redEnv_imgV){
        _redEnv_imgV = [[UIImageView alloc]init];
        _redEnv_imgV.contentMode = UIViewContentModeScaleToFill;
        _redEnv_imgV.image = [VoiceOcTool getVoiceUseImgWithImgIconNameStr:@"Voice_TopLeftUse_红包"];
    }
    return _redEnv_imgV;
}
- (UIButton *)redEnv_TopBtn{
    if(!_redEnv_TopBtn){
        _redEnv_TopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_redEnv_TopBtn addTarget:self action:@selector(redEnv_TopBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _redEnv_TopBtn;
}

- (void)redEnv_TopBtnAction:(UIButton *)sender{
    
    if(_delegate && [_delegate respondsToSelector:@selector(touchRedEnvAction)]){
        [_delegate touchRedEnvAction];
    }
}

//抢红包
#define Chat_Got_RedEnv_Notice                 @"Chat_Got_RedEnv_Notice"
#define Chat_Got_RedEnv_Notice_Result          @"Chat_Got_RedEnv_Notice_Result"
#define Chat_Got_RedEnv_Notice_Result_isFail   @"Chat_Got_RedEnv_Notice_Result_isFail"
#define Chat_Got_RedEnv_SaveUnoIdKey           @"Save_Got_RedEnv_Uno" //保存自己抢过的红包ID 用于cell展示时的类型处理
#define CreateSubDataType_ZhiBoInfoKey         @"ZhiBoInfo" //接收到直播内的创建红包动作时 直播间的信息key 直播间抢红包时也用到

- (void)fillDataOfNewOneDataStr:(NSString *)message{
    [self setHidden:NO];
    //存在数据 做显示红包UI 用户可以走点击事件 做抢红包动作
//    self.saveThisNewRedEnvOfData
//    self.saveThisNewRedEnvOfDataUnoIDStr
    NSLog(@"主播发出红包的信息动画展示");
    NSDictionary *messageDic = [VoiceTopRedEnvView_ZhuBoGotDaShangeAndShowTipView dictionaryWithJsonString:message];
    NSDictionary *userInfoDic =  [[messageDic allKeys] containsObject:@"userInfo"] ? [messageDic objectForKey:@"userInfo"] :@{};
    NSString *customInfoStr =  [[messageDic allKeys] containsObject:@"customInfo"] ? [NSString stringWithFormat:@"%@",[messageDic objectForKey:@"customInfo"]] :@"";
    NSDictionary *customDic = [NSDictionary dictionaryWithDictionary:[VoiceTopRedEnvView_ZhuBoGotDaShangeAndShowTipView dictionaryWithJsonString:customInfoStr]];
    NSString *uno =  [[customDic allKeys] containsObject:@"id"] ? [NSString stringWithFormat:@"%@",[customDic objectForKey:@"id"]] :@"";
    self.saveThisNewRedEnvOfDataUnoIDStr = uno;

    //抢红包
    NSMutableDictionary *dicOfGR = [NSMutableDictionary dictionaryWithDictionary:customDic];
    [dicOfGR setValue:self.willUseGroupIdStr forKey:@"groupID"];
    [dicOfGR setValue:BussinessID_ZhiBo_CUSTOM_onAnchorSendRedEnvelope forKey:CreateSubDataType_ZhiBoInfoKey];

    //得到的当前红包总list去重复
    if(self.zhuBoSendRedEnvList_GotRedEnvSuccessUseListArr.count>0){
        NSOrderedSet *orderSet = [NSOrderedSet orderedSetWithArray:self.zhuBoSendRedEnvList_GotRedEnvSuccessUseListArr];
        NSArray *newArray = orderSet.array;
        self.zhuBoSendRedEnvList_GotRedEnvSuccessUseListArr = [NSMutableArray arrayWithArray:newArray];
        NSLog(@"得到的当前红包总list去重复 -- %@",self.zhuBoSendRedEnvList_GotRedEnvSuccessUseListArr);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:Chat_Got_RedEnv_Notice object:self.saveThisNewRedEnvOfDataUnoIDStr userInfo:dicOfGR];
}
@end

#pragma mark ==  VoiceTopRedEnvView 红包 抢到红包后 大家收到信息的显示

#define GottedView_H (44.0)

@interface VoiceTopRedEnvView_ZhuBoGotDaShangeAndShowTipView  ()
@property (nonatomic,assign) NSInteger countTimerHidenWithDelayNum;
@property (nonatomic,strong) NSTimer *timer;
@end


@implementation VoiceTopRedEnvView_ZhuBoGotDaShangeAndShowTipView

 
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backView];
        [self.backView addSubview:self.headeView];
        [self.backView addSubview:self.moneyAndUnitL];
        [self.backView addSubview:self.subL];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(WaitGotView_H);
            make.top.left.right.equalTo(_backView.superview);
        }];
        [_headeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(40.0);
            make.centerY.equalTo(_headeView.superview);
            make.right.equalTo(_headeView.superview).offset(-4);
        }];
        [_subL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_headeView);
            make.height.offset(20.0);
            make.right.equalTo(_headeView.mas_left).offset(0);
            make.left.equalTo(_subL.superview);
        }];
        [_moneyAndUnitL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(_subL);
            make.top.equalTo(_headeView);
        }];
        
    }
    return self;
}
- (UIView *)backView{
    if(!_backView){
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _backView.layer.cornerRadius = 22.0;
    }
    return _backView;
}
- (UIImageView *)headeView{
    if(!_headeView){
        _headeView = [[UIImageView alloc]init];
        _headeView.layer.cornerRadius = 20;//40
        _headeView.layer.masksToBounds = YES;
        _headeView.contentMode = UIViewContentModeScaleToFill;
        _headeView.image = [VoiceOcTool getHeaderGrayColorImg];
    }
    return _headeView;
}
- (UILabel *)moneyAndUnitL{
    if(!_moneyAndUnitL){
        _moneyAndUnitL = [[UILabel alloc]init];
        _moneyAndUnitL.font = [UIFont systemFontOfSize:11.0];// [UIFont systemFontOfSize:15.0];
        _moneyAndUnitL.textColor = [UIColor whiteColor];
        _moneyAndUnitL.textAlignment = NSTextAlignmentRight;
        _moneyAndUnitL.numberOfLines = 2;
    }
    return _moneyAndUnitL;
}
- (UILabel *)subL{
    if(!_subL){
        _subL = [[UILabel alloc]init];
        _subL.font = [UIFont systemFontOfSize:10.0];
        _subL.textColor = [UIColor whiteColor];
        _subL.textAlignment = NSTextAlignmentRight;
        _subL.numberOfLines = 2;
    }
    return _subL;
}


- (void)fillDataOfNewOneDataStr:(NSString *)message{
    /**
     "eventType" : "onAudienceSendRedEnvelope",
     "customInfo" : "{\n  \"amount\" : \"1000000000000000000\",\n  \"id\" : \"20230926035711406087544\",\n  \"title\" : \"\",\n  \"unit\" : \"F-U\"\n}",
     "userInfo" : {
     "avatar" : "",
     "nick" : "0x99d710319f306c6c7013350555640bce5851218f",
     "userID" : "u9mSFTOxBmDRi"
     },
     "timeout" : 10000
     */
    
    NSLog(@"主播收到打赏的信息动画展示");
    
    NSDictionary *messageDic = [VoiceTopRedEnvView_ZhuBoGotDaShangeAndShowTipView dictionaryWithJsonString:message];
    NSString *eventType = [[messageDic allKeys] containsObject:@"eventType"] ? [NSString stringWithFormat:@"%@",[messageDic objectForKey:@"eventType"]] : @"";
    if([eventType isEqualToString:BussinessID_ZhiBo_CUSTOM_onAudienceSendRedEnvelope]){
        
        
        NSDictionary *userInfoDic =  [[messageDic allKeys] containsObject:@"userInfo"] ? [messageDic objectForKey:@"userInfo"] :@{};
        NSString *customInfoStr =  [[messageDic allKeys] containsObject:@"customInfo"] ? [NSString stringWithFormat:@"%@",[messageDic objectForKey:@"customInfo"]] :@"";
        NSDictionary *customDic = [NSDictionary dictionaryWithDictionary:[VoiceTopRedEnvView_ZhuBoGotDaShangeAndShowTipView dictionaryWithJsonString:customInfoStr]];
        //
        NSString *amountStr = [[customDic allKeys] containsObject:@"amount"] ? [NSString stringWithFormat:@"%@",[customDic objectForKey:@"amount"]] :@"";
        NSString *unitStr = [[customDic allKeys] containsObject:@"unit"] ? [NSString stringWithFormat:@"%@",[customDic objectForKey:@"unit"]] :@"";
        
        //
        NSString *avatar =  [[userInfoDic allKeys] containsObject:@"avatar"] ? [NSString stringWithFormat:@"%@",[userInfoDic objectForKey:@"avatar"]] :@"";
        NSString *nick =  [[userInfoDic allKeys] containsObject:@"nick"] ? [NSString stringWithFormat:@"%@",[userInfoDic objectForKey:@"nick"]] :@"";
        if(avatar.length>0){
            [_headeView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[VoiceOcTool getHeaderGrayColorImg]];
        }else{
            _headeView.image = [VoiceOcTool getHeaderGrayColorImg];
        }
        
        
        //[TUIGlobalization getLocalizedStringForKey:@"%@打赏给主播"  bundle:TUIChatLocalizableBundle] ;
        if(nick.length == 0 || [nick isEqualToString:@"(null)"] || [nick isEqualToString:@"（null）"] ){
            nick = @"";
        }
        self.subL.text = [NSString stringWithFormat:[TUIGlobalization getLocalizedStringForKey:@"%@打赏给主播"  bundle:TUIChatLocalizableBundle],nick];
        /**
         //科学计数 除10 18
         let longDecimalNum_Amount = NSDecimalNumber(string: value_customInfoSub as? String)
         let pwInfo = NSDecimalNumber(string: "10").raising(toPower: 18)
         let showDecimalNum:NSDecimalNumber = longDecimalNum_Amount.dividing(by: pwInfo)
         moneyStr = showDecimalNum.stringValue
         */
        NSString *ok_amountStr = @"0";
        if([amountStr isEqualToString: @""] || [amountStr isEqualToString: @"(null)"] || [amountStr isEqualToString: @"（null）"]){
        }else{
            NSDecimalNumber *longDN_Amount = [NSDecimalNumber decimalNumberWithString:amountStr];
            NSLog(@"longDN_Amount = %@",longDN_Amount);
            NSDecimalNumber *pwInfo = [[NSDecimalNumber decimalNumberWithString:@"10"] decimalNumberByRaisingToPower:18];
            NSLog(@"pwInfo = %@",pwInfo);
            NSDecimalNumber *showDecimalNum  = [longDN_Amount decimalNumberByDividingBy:pwInfo];
            NSLog(@"showDecimalNum = %@",showDecimalNum);
            ok_amountStr = showDecimalNum.stringValue;
        }
        
       
        self.moneyAndUnitL.text = [NSString stringWithFormat:@"%@%@",ok_amountStr,unitStr];
        //显示
        self.hidden = NO;
        self.countTimerHidenWithDelayNum = 5;
        if(self.timer == nil || [self.timer isEqual:[NSNull null]] || [self.timer isEqual:nil]){
            self.timer  = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerWillHidenAction:) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }else{//时间变长
        }
    }
}


- (void)timerWillHidenAction:(NSTimer *)ti{
    if(self.countTimerHidenWithDelayNum > 0){
        self.countTimerHidenWithDelayNum -= 1;
    }else{//到时间了
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        [ti invalidate];
        ti = nil;
        self.timer = nil;
        [UIView animateWithDuration:0.9 animations:^{
            [self setHidden:YES];
            //删除当前最后一位打赏数据 防止下一次触发 没有回调 则判断显示吧 不做删除
        }];
    
    }
    

}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil || jsonString.length <= 0)
    {
        return @{};
        //return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding]; NSError *err; NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return @{};
    }
    return dic;
}
@end
