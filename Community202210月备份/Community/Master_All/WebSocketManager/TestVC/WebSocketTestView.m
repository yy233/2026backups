//
//  WebSocketTestView.m
//  Community
//
//  Created by 余莹 on 2021/4/22.
//

#import "WebSocketTestView.h"

@interface WebSocketTestView () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation WebSocketTestView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)fFriendReqLiesArr:(NSMutableArray *)arr{
    self.arrOfFReqList = arr;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.friendReInfoList reloadData];
    });
  
}
- (void)fFriendListArr:(NSMutableArray *)arr{
    self.arrOfFList = arr;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.friendList reloadData];
    });
  
}
- (IBAction)addFAction:(id)sender {
//    _BtnNum(1);
    _btnNNNNNN(1);
}
- (IBAction)getFriendsResInfo:(id)sender {
//    _BtnNum(10);
    _btnNNNNNN(10);
}
- (IBAction)getFriendList:(id)sender {
//    _BtnNum(100);
    _btnNNNNNN(100);
}
- (IBAction)cancelF:(id)sender {
//    _BtnNum(0);
    _btnNNNNNN(0);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.friendReInfoList) {
        return self.arrOfFReqList.count;
    }
    if (tableView==self.friendList) {
        return self.arrOfFList.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
 
    if (tableView==self.friendReInfoList) {
        NSDictionary *dic = self.arrOfFReqList[indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
//        cell.textLabel.text =  [dic[@"toNickname"] stringByAppendingString:dic[@"to_user"]];//
        cell.textLabel.text =  [NSString stringWithString:dic[@"from_user"]];//某某fromuser请求加你touser为好友
        cell.textLabel.font = [UIFont systemFontOfSize:10];
    }
    if (tableView==self.friendList) {
        NSDictionary *dic = self.arrOfFList[indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.text =  [dic[@"userNickname"] stringByAppendingString:dic[@"userUuid"]];//
        cell.textLabel.font = [UIFont systemFontOfSize:11];
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView==self.friendReInfoList) {
        NSDictionary *dic = self.arrOfFReqList[indexPath.row];
//        NSString *uuid =  [NSString stringWithString:dic[@"to_user"]];
        
        NSString *uuid =  [NSString stringWithString:dic[@"from_user"]];//某某fromuser请求加你touser为好友
        _agreeFBlock(uuid);//同意
//        _regagreeFBlock(uuid); //拒绝
        
    }
    if (tableView==self.friendList) {
        NSDictionary *dic = self.arrOfFList[indexPath.row]; 
        NSString *uuid =  [NSString stringWithString:dic[@"userUuid"]];
        //跳转聊天界面
        _chatFBlock(uuid);
        
    }
}

//cell删除相关
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.friendList) {
        return YES;
    }else{
        return NO;
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.friendList) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (tableView==self.friendList) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            NSDictionary *dic = self.arrOfFList[indexPath.row];
            NSString *uuid =  [NSString stringWithString:dic[@"userUuid"]];
            _deletSecceion(uuid);
        }
    }else{
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
//
- (NSMutableArray *)arrOfFList{
    if (!_arrOfFList) {
        _arrOfFList = [[NSMutableArray alloc]init];
    }
    return _arrOfFList;
}
- (NSMutableArray *)arrOfFReqList{
    if (!_arrOfFReqList) {
        _arrOfFReqList = [[NSMutableArray alloc]init];
    }
    return _arrOfFReqList;
}

#pragma mark =========  群

- (IBAction)getAllGroupBtnAction:(id)sender {
    _getAllGroupBlock();
}
- (IBAction)creatGroupBtnAction:(id)sender {
    _creatGroupBlock();
}
- (IBAction)AddFriendsToGroupBtnAction:(id)sender {
    _addFriendsToGroupBlock();
}
- (IBAction)changNickName:(id)sender {
    _changeUserInfo(1);//名字
}
@end
