//
//  VoiceOnSpeckOrOnLinePopView.m
//  AFNetworking
//
//  Created by 余莹 on 2023/6/1.
//

#import "VoiceOnSpeckOrOnLinePopView.h"

#import <TUIVoiceRoom/TUIVoiceRoom-Swift.h>
//#import "TUIVoiceRoom-Swift.h"

#import  <TUIVoiceRoom/TXBaseDef.h>

@interface VoiceOnSpeckOrOnLinePopView () <UISearchBarDelegate>

@property (nonatomic,strong)  HeaderTypeChangeView *headerV;
@property (nonatomic,strong)  FooterJinYinView *footerV;

@property (nonatomic,strong) VoiceRoomUserInfo *crearRoomUserInfo;
@property (nonatomic,strong) NSMutableArray *onSpeckArr;
@property (nonatomic,strong) NSMutableArray *onLineArr;

@property (nonatomic,strong) NSMutableArray *onSpeckJinYinIDArr;
@property (nonatomic,strong) NSMutableArray *onLineJinYanIDArr;
@end

@implementation VoiceOnSpeckOrOnLinePopView

#pragma mark ---
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"%s searchText:%@",__FUNCTION__,searchBar.text);
    [searchBar canResignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"%s searchText:%@",__FUNCTION__,searchBar.text);
    [searchBar canResignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"%s searchText:%@",__FUNCTION__,searchBar.text);
    [searchBar canResignFirstResponder];
}

#pragma mark ---
- (void)leftBtnAction:(UIButton *)sender{//已经上麦
    NSLog(@"%s",__FUNCTION__);
    if(!sender.selected){//否状态 才转换成显示状态
        sender.selected = !sender.selected;
        self.headerV.rightBtn.selected = !sender.selected;
        
        if(_onSpeckOrOnLineDelegate && [_onSpeckOrOnLineDelegate respondsToSelector:@selector(touchTopChangeBtnsWithVoiceOnSpeckOrOnLineTopChooseTyp_Type:)]){
            [_onSpeckOrOnLineDelegate touchTopChangeBtnsWithVoiceOnSpeckOrOnLineTopChooseTyp_Type:VoiceOnSpeckOrOnLineTopChooseType_OnSpeckType];
        }
        self.saveNowPopViewTop_Type = VoiceOnSpeckOrOnLineTopChooseType_OnSpeckType;
        [self.tableView reloadData];
    }
   
   
}

- (void)rightBtnAction:(UIButton *)sender{//普通在线
    NSLog(@"%s",__FUNCTION__);
    if(!sender.selected){//否状态 才转换成显示状态
        sender.selected = !sender.selected;
        self.headerV.leftBtn.selected = !sender.selected;
        if(_onSpeckOrOnLineDelegate && [_onSpeckOrOnLineDelegate respondsToSelector:@selector(touchTopChangeBtnsWithVoiceOnSpeckOrOnLineTopChooseTyp_Type:)]){
            [_onSpeckOrOnLineDelegate touchTopChangeBtnsWithVoiceOnSpeckOrOnLineTopChooseTyp_Type:VoiceOnSpeckOrOnLineTopChooseTyp_OnLineType];
        }
        self.saveNowPopViewTop_Type = VoiceOnSpeckOrOnLineTopChooseTyp_OnLineType;
     
        [self.tableView reloadData];
    }
   
}

#pragma mark --- 静音 footer btns
- (void)allJinYinAction:(UIButton *)sender{
    NSLog(@"%s",__FUNCTION__);
    if(_onSpeckOrOnLineDelegate && [_onSpeckOrOnLineDelegate respondsToSelector:@selector(allJinYin)]){
        [_onSpeckOrOnLineDelegate allJinYin];
    }
    [self dismissThePopView];
}

- (void)allJieChuJinYinAction:(UIButton *)sender{
    NSLog(@"%s",__FUNCTION__);
    if(_onSpeckOrOnLineDelegate && [_onSpeckOrOnLineDelegate respondsToSelector:@selector(allJieChuJinYin)]){
        [_onSpeckOrOnLineDelegate allJieChuJinYin]; 
    }
    [self dismissThePopView];
}

#pragma mark ----- poplist cells right action
- (void)popListCellsRightAction:(UIButton *)sender{
 
    NSInteger idx = sender.tag - 300;
    NSLog(@"popListCellsRightAction -- sender tag = %ld",(long)idx);
    NSLog(@"popListCellsRightAction -- sender selected %d",sender.selected);
    NSLog(@"popListCellsRightAction -- saveNowPopViewTop_Type  = %ld",self.saveNowPopViewTop_Type);

    switch (self.saveNowPopViewTop_Type) {
        case VoiceOnSpeckOrOnLineTopChooseTyp_OnLineType://在线 -- right
        {
            
            NSLog(@"%@ cell data onLineArr----",self.onLineArr[idx]);
            
            V2TIMGroupMemberFullInfo *userInfoM = self.onLineArr[idx];
            
            if(_onSpeckOrOnLineDelegate && [_onSpeckOrOnLineDelegate respondsToSelector:@selector(touchPopListCellRightItemVoiceOnSpeckOrOnLinePopList_Type:withNowTopChooseTyp_Type:withUserInfo:)]){
                
                if(userInfoM.role == V2TIM_GROUP_MEMBER_ROLE_SUPER){
                    NSLog(@"主播 不能禁言自己");
            
                    return;
                }
                //NoCallType
                //CanCallType
                if(sender.selected == YES){//  (当前为禁止 selected选中 则做解除禁止动作 --)｜非选中->做禁止的动作
                    NSLog(@"popListCellsRightAction---VoiceOnSpeckOrOnLineTopChooseTyp_OnLineType --- CanCallType 解禁");
                    [_onSpeckOrOnLineDelegate touchPopListCellRightItemVoiceOnSpeckOrOnLinePopList_Type:VoiceOnSpeckOrOnLinePopList_Type_CanCallType  withNowTopChooseTyp_Type:self.saveNowPopViewTop_Type withUserInfo:userInfoM.userID];
                }else{
                    NSLog(@"popListCellsRightAction---VoiceOnSpeckOrOnLineTopChooseTyp_OnLineType --- NoCallTyp 禁");
                    [_onSpeckOrOnLineDelegate touchPopListCellRightItemVoiceOnSpeckOrOnLinePopList_Type:VoiceOnSpeckOrOnLinePopList_Type_NoCallType  withNowTopChooseTyp_Type:self.saveNowPopViewTop_Type withUserInfo:userInfoM.userID];
                    
                }
            }
        }
            break;
        case VoiceOnSpeckOrOnLineTopChooseType_OnSpeckType:
        {
            NSLog(@"%@ cell data onSpeckArr----",self.onSpeckArr[idx]);
            V2TIMGroupMemberFullInfo *userInfoM = self.onSpeckArr[idx];
            
            
            if(userInfoM.role == V2TIM_GROUP_MEMBER_ROLE_SUPER){
                NSLog(@"主播 不能禁言自己");
                return;
            }
            
            //SpeckType
            //NotSpeckType 
            if(_onSpeckOrOnLineDelegate && [_onSpeckOrOnLineDelegate respondsToSelector:@selector(touchPopListCellRightItemVoiceOnSpeckOrOnLinePopList_Type:withNowTopChooseTyp_Type:withUserInfo:)]){
                if(sender.selected == YES){// (当前为禁止 selected选中 则做解除禁止动作 --)｜非选中->做禁止的动作
                  
                    NSLog(@"popListCellsRightAction---VoiceOnSpeckOrOnLineTopChooseType_OnSpeckType --- SpeckType 解禁");
                    [_onSpeckOrOnLineDelegate touchPopListCellRightItemVoiceOnSpeckOrOnLinePopList_Type: VoiceOnSpeckOrOnLinePopList_Type_SpeckType withNowTopChooseTyp_Type:self.saveNowPopViewTop_Type withUserInfo:userInfoM.userID];
                }else{
                    
                    NSLog(@"popListCellsRightAction---VoiceOnSpeckOrOnLineTopChooseType_OnSpeckType --- NotSpeckType 禁");
                    [_onSpeckOrOnLineDelegate touchPopListCellRightItemVoiceOnSpeckOrOnLinePopList_Type:VoiceOnSpeckOrOnLinePopList_Type_NotSpeckType withNowTopChooseTyp_Type:self.saveNowPopViewTop_Type withUserInfo:userInfoM.userID];
                    
                }
            }
        }
            break;
        default:
        {
            //
        }
            break;
    }
    
    
    [self dismissThePopView];//都做一次数据更改 然后隐藏当前popview
}
#pragma mark == 重写

//0601
- (void)popViewAddOtherInfo{
    //header
    self.headerV = [[HeaderTypeChangeView alloc]initWithFrame:CGRectZero];
    self.headerV.frame = CGRectMake(0, 0, Screen_Width, Header_H_TitleAndSearchBarAndTwoBtns);
//    static NSString * _Nonnull kPopViewHeader_titleStr_onLineOrAllPerson =  voiceRoomLocalize(@"管理成员");//已连麦 + 普通在线
    self.headerV.popViewListTopTitleL.text = voiceRoomLocalize(@"管理成员");
    self.headerV.popViewListTopTitleL.numberOfLines = 2;
    self.headerV.popViewListTopSearchBar.delegate = self;
    [self.headerV.leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerV.rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = self.headerV;
    self.tag = popView_Tag_oneLineOrAllPersion;
    
    //footer
//    footerV
    self.footerV = [[FooterJinYinView alloc]initWithFrame:CGRectZero];
    [self.footerV.allJinYinBtn addTarget:self action:@selector(allJinYinAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerV.allJieChuJinYinBtn addTarget:self action:@selector(allJieChuJinYinAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.tableView.tableFooterView = self.footerV;
    self.tableView.tableFooterView = [UIView new];//暂时隐藏全员静音的两个按钮

    //初始状态
    self.headerV.leftBtn.selected = YES;
    self.saveNowPopViewTop_Type = VoiceOnSpeckOrOnLineTopChooseType_OnSpeckType;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.saveNowPopViewTop_Type == VoiceOnSpeckOrOnLineTopChooseType_OnSpeckType){
        return self.onSpeckArr.count;
    }else{
        return self.onLineArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VoiceMemberPopListViewCell_ShowOnLineCell *cell = [tableView dequeueReusableCellWithIdentifier:kVoiceMemberPopListViewCell_ShowOnLineCell_I];
    if (!cell) {
        cell = [[VoiceManagerPopListViewCell_SetManagerPersonCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kVoiceManagerPopListViewCell_SetManagerPersonCell_I];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.rightBtn addTarget:self action:@selector(popListCellsRightAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.rightBtn.tag = 300 + indexPath.row;
    
 
 
    V2TIMGroupMemberFullInfo *thisCellUserInfoModel;// = self.dataSource[indexPath.row];

    if(self.saveNowPopViewTop_Type == VoiceOnSpeckOrOnLinePopList_Type_SpeckType){
        thisCellUserInfoModel = self.onSpeckArr[indexPath.row];
        
    }else if (self.saveNowPopViewTop_Type == VoiceOnSpeckOrOnLineTopChooseTyp_OnLineType){
        thisCellUserInfoModel = self.onLineArr[indexPath.row];

    }else{
        return cell;
    }
    if(![thisCellUserInfoModel isKindOfClass:[V2TIMGroupMemberFullInfo class]]){
        //onSpeckArr数据有问题
        return cell;
    }
    NSString *tit = @"";
    if(thisCellUserInfoModel && thisCellUserInfoModel.nickName != nil && ![thisCellUserInfoModel.nickName isEqualToString:@""]){//非空
        tit = thisCellUserInfoModel.nickName;
    }else{
        //tit = voiceRoomLocalize(@"暂无昵称");
        tit = @"";
    }
    NSLog(@"昵称tit == %@",tit);
    NSLog(@" onSpeckJinYinIDArr == %@",self.onSpeckJinYinIDArr);
    NSLog(@" onLineJinYanIDArr == %@",self.onLineJinYanIDArr);
    
    cell.addressL.text = tit;
    cell.typeL.text = (thisCellUserInfoModel.role==V2TIM_GROUP_MEMBER_ROLE_SUPER ? voiceRoomLocalize(@"主播"):@"");
    NSLog(@"addressL == %@",cell.addressL.text);
    NSLog(@"typeL == %@",cell.typeL.text);
    [cell.heaImg sd_setImageWithURL:[NSURL URLWithString: thisCellUserInfoModel.faceURL] placeholderImage: [VoiceOcTool getHeaderGrayColorImg]];

    //______  cell.rightBtn.selected == 展示 禁止状态 和非禁止状态
    if(self.saveNowPopViewTop_Type == VoiceOnSpeckOrOnLineTopChooseType_OnSpeckType){//上麦list
        
        switch (thisCellUserInfoModel.role) {
            case V2TIM_GROUP_MEMBER_ROLE_SUPER:
            {//主播
                //                    [cell.rightBtn setImage:  [VoiceOcTool getVoiceUseImgWithImgIconNameStr:@"开启麦克风_g"] forState:UIControlStateNormal];
                [cell.rightBtn setImage:[UIImage new]   forState:UIControlStateNormal];
                
            }
                break;
                
            default:
            {
                //普通角色 两种状态 都设置成普通图片。 selected仅仅处理点击按钮时的代理数据
                if([self.onSpeckJinYinIDArr containsObject: [NSString stringWithFormat:@"%@",thisCellUserInfoModel.userID]] ){//包含被禁止语音流的ID
                    [cell.rightBtn setImage: [VoiceOcTool getVoiceUseImgWithImgIconNameStr:@"关闭麦克风"] forState:UIControlStateNormal];
                    cell.rightBtn.selected = YES;
                }else{
                    [cell.rightBtn setImage: [VoiceOcTool getVoiceUseImgWithImgIconNameStr:@"开启麦克风"] forState:UIControlStateNormal];
                    cell.rightBtn.selected = NO;
                }
            }
                break;
        }
    }else  if(self.saveNowPopViewTop_Type == VoiceOnSpeckOrOnLineTopChooseTyp_OnLineType){//在线list
        
        //普通角色 两种状态
        
        
        switch (thisCellUserInfoModel.role) {
            case V2TIM_GROUP_MEMBER_ROLE_SUPER:
                {//主播
//                    [cell.rightBtn setImage:  [VoiceOcTool getVoiceUseImgWithImgIconNameStr:@"开启麦克风_g"] forState:UIControlStateNormal];
                    [cell.rightBtn setImage:[UIImage new]   forState:UIControlStateNormal];
                }
                break;
                
            default:
            {
                //普通角色 两种状态 都设置成普通图片。 selected仅仅处理点击按钮时的代理数据
                if([self.onLineJinYanIDArr containsObject: [NSString stringWithFormat:@"%@",thisCellUserInfoModel.userID]] ){//包含被禁止发弹幕的ID
                    [cell.rightBtn setImage: [VoiceOcTool getVoiceUseImgWithImgIconNameStr:@"聊天_禁言"] forState:UIControlStateNormal];
                    cell.rightBtn.selected = YES;
                 }else{
                    [cell.rightBtn setImage: [VoiceOcTool getVoiceUseImgWithImgIconNameStr:@"聊天"] forState:UIControlStateNormal];
                    cell.rightBtn.selected = NO;
                 }
               
                
            }
                break;
        }
    }else{
    }
    return cell;
}
#pragma mark ==
//重写
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self endEditing:YES];
}
- (void)tableViewOtherSetWhenGetArrWithArray:(NSMutableArray *)array{
    /**
     private(set) var anchorSeatList: [SeatInfoModel] = []
     private(set) var memberAudienceList: [AudienceInfoModel] = []
     */
    if(array.count == 3){//0主播 1上麦组 2观众组
        self.crearRoomUserInfo = array.firstObject;
        self.onSpeckArr = @[].mutableCopy;
        self.onLineArr = @[].mutableCopy;
        
        self.onSpeckArr = [NSMutableArray arrayWithArray:array[1]];
        self.onLineArr = [NSMutableArray arrayWithArray:array.lastObject];
        NSLog(@"setDataSource传入数据  \n crearRoomUserInfo=%@ \n onSpeckArr=%@ \n  onLineArr=%@",self.crearRoomUserInfo,self.onSpeckArr,self.onLineArr);
        if(self.onSpeckArr.count==0){
            NSLog(@"onSpeckArr 数据 为0个");
        }
        [self.tableView reloadData];
    }else{
        NSLog(@"setDataSource传入数据格式出错");
    }
    
}


#pragma mark ==
- (NSMutableArray *)onSpeckArr{
    if(!_onSpeckArr){
        _onSpeckArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _onSpeckArr;
}

- (NSMutableArray *)onLineArr{
    if(!_onLineArr){
        _onLineArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _onLineArr;
}

- (NSMutableArray *)onSpeckJinYinIDArr{
    if(!_onSpeckJinYinIDArr){
        _onSpeckJinYinIDArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _onSpeckJinYinIDArr;
}

- (NSMutableArray *)onLineJinYanIDArr{
    if(!_onLineJinYanIDArr){
        _onLineJinYanIDArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _onLineJinYanIDArr;
}

 
- (void)speckOrOnLinePopViewNowTwoHaveShagnMaiJinYinIdsArr:(NSMutableArray *)shangMaijinYinIdArr andDanMuJinYanIdsArr:(NSMutableArray *)danMuJinYanIdArr{
    self.onSpeckJinYinIDArr = [[NSMutableArray alloc]initWithArray:shangMaijinYinIdArr];
    self.onLineJinYanIDArr = [[NSMutableArray alloc]initWithArray:danMuJinYanIdArr];
    //刷新数据后 才能得到新的右按钮
    [self.tableView reloadData];
}

 
@end
