//
//  VoiceManagerShangMaiShengQingPopView.m
//  AFNetworking
//
//  Created by 余莹 on 2023/6/1.
// 上麦申请

#import "VoiceManagerShangMaiShengQingPopView.h"
#import <TUIVoiceRoom/TUIVoiceRoom-Swift.h>

@implementation VoiceManagerShangMaiShengQingPopView
 
#pragma mark == 重写
//0601
- (void)popViewAddOtherInfo{
    
    HeaderTitleAndSearchView *headerV = [[HeaderTitleAndSearchView alloc]initWithFrame:CGRectZero];
    [headerV onlyShowTitleLabel];
//    static NSString * _Nonnull kPopViewHeader_titleStr_managerShangMaiShengQing =  voiceRoomLocalize(@"上麦申请");
    headerV.popViewListTopTitleL.text = voiceRoomLocalize(@"上麦申请");
    self.tableView.tableHeaderView = headerV;
    self.tableView.tableFooterView = [UIView new];
    self.tag = popView_Tag_managerShangMaiShengqing;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VoiceManagerPopListViewCell_showGanZhongShangDealMaiCell *cell = [tableView dequeueReusableCellWithIdentifier:kVoiceManagerPopListViewCell_GanZhongShangMaiCell_I];
    if (!cell) {
        cell = [[VoiceManagerPopListViewCell_showGanZhongShangDealMaiCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kVoiceManagerPopListViewCell_GanZhongShangMaiCell_I];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.rightBtn_TongYi addTarget:self action:@selector(rightBtnTOngYi:) forControlEvents:UIControlEventTouchUpInside];
        [cell.rightBtn_JuJue addTarget:self action:@selector(rightBtnJuJue:) forControlEvents:UIControlEventTouchUpInside];
        cell.rightBtn_TongYi.tag = popView_Tag_managerShangMaiShengqing+(100+indexPath.row);
        cell.rightBtn_JuJue.tag = popView_Tag_managerShangMaiShengqing+(200+indexPath.row);
    }
    
    V2TIMGroupMemberFullInfo*userInfoModel = self.dataSource[indexPath.row];
    NSString *tit = [NSString stringWithFormat:@"%@",  userInfoModel.nickName];
    cell.addressL.text = tit;
    [cell.heaImg sd_setImageWithURL:[NSURL URLWithString: userInfoModel.faceURL] placeholderImage: [VoiceOcTool getHeaderGrayColorImg]];
     return cell;
}

#pragma mark == 点击
//重写
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self endEditing:YES];
}
//right
- (void)rightBtnTOngYi:(UIButton *)sender{
    NSInteger index = sender.tag - 100 - popView_Tag_managerShangMaiShengqing;
    V2TIMGroupMemberFullInfo*userInfoModel = self.dataSource[index];
    if(userInfoModel.role == V2TIM_GROUP_MEMBER_ROLE_SUPER){//群主
        NSLog(@"群主");
    }else{
        
        [self dismissThePopView];
        if ([self.shangMaiSheZhiDelegate respondsToSelector:@selector(shangMaiTongYiWithIdstr:)]) {
            [self.shangMaiSheZhiDelegate shangMaiTongYiWithIdstr:userInfoModel.userID];
        }
    }
    
}
- (void)rightBtnJuJue:(UIButton *)sender{
    NSInteger index = sender.tag - 200 - popView_Tag_managerShangMaiShengqing;
        V2TIMGroupMemberFullInfo*userInfoModel = self.dataSource[index];
    if(userInfoModel.role == V2TIM_GROUP_MEMBER_ROLE_SUPER){//群主
        NSLog(@"群主");
    }else{
        
        [self dismissThePopView];
        if ([self.shangMaiSheZhiDelegate respondsToSelector:@selector(shangMaiJuJueWithIdstr:)]) {
            [self.shangMaiSheZhiDelegate shangMaiJuJueWithIdstr:userInfoModel.userID];
        }
    }
}



//- (void)tableSubRightBtnTouch:(UIButton *)sender{
//    NSInteger index = sender.tag - 100 - popView_Tag_setManagerPerson;
//    V2TIMGroupMemberFullInfo*userInfoModel = self.dataSource[index];
//    if(userInfoModel.role == V2TIM_GROUP_MEMBER_ROLE_SUPER){//群主
//        NSLog(@"群主");
//  }else if(userInfoModel.role == V2TIM_GROUP_MEMBER_ROLE_ADMIN){//群管理员
//      [self dismissThePopView];
//      if ([self.setManagerPopDelegate respondsToSelector:@selector(setMamagerPopViewDeletPersonWithInfoIDStr:)]) {
//          [self.setManagerPopDelegate setMamagerPopViewDeletPersonWithInfoIDStr:userInfoModel.userID];
//      }
//    }else{//其他普通人员
//        [self dismissThePopView];
//        if ([self.setManagerPopDelegate respondsToSelector:@selector(setMamagerPopViewAddPersonWithInfoIDStr:)]) {
//            [self.setManagerPopDelegate setMamagerPopViewAddPersonWithInfoIDStr:userInfoModel.userID];
//        }
//
//    }
//
//}


@end
