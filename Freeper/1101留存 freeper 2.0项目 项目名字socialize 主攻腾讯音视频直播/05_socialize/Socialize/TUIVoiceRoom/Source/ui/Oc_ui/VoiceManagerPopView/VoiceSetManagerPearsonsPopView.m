//
//  VoiceSetManagerPearsonsPopView.m
//  AFNetworking
//
//  Created by 余莹 on 2023/6/1.
// 设置管理员

#import "VoiceSetManagerPearsonsPopView.h"

#import <TUIVoiceRoom/TUIVoiceRoom-Swift.h>
@interface VoiceSetManagerPearsonsPopView () <UISearchBarDelegate>

@end

@implementation VoiceSetManagerPearsonsPopView
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
#pragma mark == 重写
//0601
- (void)popViewAddOtherInfo{
    
    HeaderTitleAndSearchView *headerV = [[HeaderTitleAndSearchView alloc]initWithFrame:CGRectZero];
//    static NSString * _Nonnull kPopViewHeader_titleStr_setManagerPerson =  voiceRoomLocalize(@"设置管理员" ) ;
    headerV.popViewListTopTitleL.text = voiceRoomLocalize(@"设置管理员") ;
    headerV.popViewListTopSearchBar.delegate = self;
    self.tableView.tableHeaderView = headerV;
    self.tableView.tableFooterView = [UIView new];
    self.tag = popView_Tag_setManagerPerson;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VoiceManagerPopListViewCell_SetManagerPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:kVoiceManagerPopListViewCell_SetManagerPersonCell_I];
    if (!cell) {
        cell = [[VoiceManagerPopListViewCell_SetManagerPersonCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kVoiceManagerPopListViewCell_SetManagerPersonCell_I];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.rightBtn.userInteractionEnabled = YES;
        [cell.rightBtn addTarget:self action:@selector(tableSubRightBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
        cell.rightBtn.tag = popView_Tag_setManagerPerson+(100+indexPath.row);
        
    }
  
    
    V2TIMGroupMemberFullInfo*userInfoModel = self.dataSource[indexPath.row];
    if(userInfoModel && userInfoModel.nickName != nil &&  userInfoModel.nickName.length >0){
        NSString *tit = [NSString stringWithFormat:@"%@",  userInfoModel.nickName];
        cell.addressL.text = tit;
    }
    if(userInfoModel && userInfoModel.faceURL.length >0){
        [cell.heaImg sd_setImageWithURL:[NSURL URLWithString: userInfoModel.faceURL] placeholderImage:[VoiceOcTool getHeaderGrayColorImg]];
    }
    cell.typeL.text = (userInfoModel.role==V2TIM_GROUP_MEMBER_ROLE_SUPER ? voiceRoomLocalize(@"主播"):@"");
 
    //rightBtnUI
    if(userInfoModel.role == V2TIM_GROUP_MEMBER_ROLE_SUPER){//群主 无图无+
        [cell.rightBtn setImage:[UIImage new] forState:UIControlStateNormal];
        [cell.rightBtn setTitle:@"" forState:UIControlStateNormal];
    }else  if(userInfoModel.role == V2TIM_GROUP_MEMBER_ROLE_ADMIN){//群管理员 有图无+
        [cell.rightBtn setImage: [VoiceOcTool getVoiceUseImgWithImgIconNameStr: voiceRoomLocalize(@"管理员")] forState:UIControlStateNormal];
        [cell.rightBtn setTitle:@"" forState:UIControlStateNormal];
    }else{//有加号
        [cell.rightBtn setImage: [VoiceOcTool getVoiceUseImgWithImgIconNameStr: voiceRoomLocalize(@"管理员")] forState:UIControlStateNormal];
        [cell.rightBtn setTitle:@"+" forState:UIControlStateNormal];
    }
    
    return cell;
}

#pragma mark == 点击
//重写
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self endEditing:YES];
}
//right
- (void)tableSubRightBtnTouch:(UIButton *)sender{
    NSInteger index = sender.tag - 100 - popView_Tag_setManagerPerson;
    V2TIMGroupMemberFullInfo*userInfoModel = self.dataSource[index];
    if(userInfoModel.role == V2TIM_GROUP_MEMBER_ROLE_SUPER){//群主
        NSLog(@"是群主 不用设置或取消管理员身份");
  }else if(userInfoModel.role == V2TIM_GROUP_MEMBER_ROLE_ADMIN){//群管理员
      [self dismissThePopView];
      if ([self.setManagerPopDelegate respondsToSelector:@selector(setMamagerPopViewDeletPersonWithInfoIDStr:)]) {
          [self.setManagerPopDelegate setMamagerPopViewDeletPersonWithInfoIDStr:userInfoModel.userID];//删除管理员
      }
    }else{//其他普通人员
        [self dismissThePopView];
        if ([self.setManagerPopDelegate respondsToSelector:@selector(setMamagerPopViewAddPersonWithInfoIDStr:)]) {
            [self.setManagerPopDelegate setMamagerPopViewAddPersonWithInfoIDStr:userInfoModel.userID];//新增管理员
        }
        
    }
        
}


 

/**
 群成员角色
enum V2TIMGroupMemberRole {
    /// 未定义（没有获取该字段）
    V2TIM_GROUP_MEMBER_UNDEFINED = 0,
    /// 群成员
    V2TIM_GROUP_MEMBER_ROLE_MEMBER = 200,
    /// 群管理员
    V2TIM_GROUP_MEMBER_ROLE_ADMIN = 300,
    /// 群主
    V2TIM_GROUP_MEMBER_ROLE_SUPER = 400,*/
@end
