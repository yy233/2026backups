//
//  GroupQrWillShareDoChooseGroupOrFriendListVc.m
//  Socialize
//
//  Created by 余莹 on 2023/8/23.
//
//分享群二维码时 选的节目 由通讯录来的界面

#import "GroupQrWillShareDoChooseGroupOrFriendListVc.h"
#import "TUIGroupConversationListController_Minimalist.h"
#import <TUICore/TUICore.h>
#import <TRTCLiveRoomIMAction.h>//ConversationParam
#import <TUIFriendProfileController_Minimalist.h>
#import "ImChatVc.h"
#import <TUIChatConversationModel.h>
#import <TUIBaseChatViewController_Minimalist.h>
#import <TUIGroupChatViewController_Minimalist.h>
#import <TUIC2CChatViewController_Minimalist.h>
 
@interface GroupQrWillShareDoChooseGroupOrFriendListVc ()

@end

@implementation GroupQrWillShareDoChooseGroupOrFriendListVc

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self.navigationController.navigationBar setTranslucent:NO];

}
#define  pushAddGroup @"pushAddGroupAction"
//群链接 群分享
- (V2TIMMessage *)dealCustomMsg{
    V2TIMMessage *cusmessage;
    NSMutableDictionary *customDic = [[NSMutableDictionary alloc]init];
    [customDic setValue:@(GroupCreate_Version) forKey:@"version"];
    [customDic setValue:BussinessID_TextLink forKey:BussinessID];
    [customDic setValue:@(1) forKey:@"type"];//Link_Type_AddGroup_1
    [customDic setValue:pushAddGroup forKey:@"link"];//Link_str
    [customDic setValue:self.willShareGroupID   forKey:@"groupId"];
    [customDic setValue:self.willShareGroupShowName  forKey:@"groupName"];

    NSError *err;
    NSData *customData= [NSJSONSerialization dataWithJSONObject:customDic options:NSJSONWritingPrettyPrinted error:&err];
    if(err){
        Y_SVP_SHOW_ERR_MES(@"转发失败");
        return cusmessage;
    }
    cusmessage = [[V2TIMManager sharedInstance] createCustomMessage:customData];
    cusmessage.customElem.desc = [NSString stringWithFormat:@"%ld",Link_Type_AddGroup_1];//用于主页显示[自定义消息]的desc处理 这里是群二维码分享数据
    return cusmessage;
    
}

//通讯录界面 重写点击s0群的方法

- (void)onGroupConversation:(TUICommonTableViewCell *)cell
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onGroupConversation:)]) {
        [self.delegate onGroupConversation:cell];
        return;
    }
   TUIGroupConversationListController_Minimalist *vc = TUIGroupConversationListController_Minimalist.new;

   @weakify(self)
   vc.onSelect = ^(TUICommonContactCellData_Minimalist * _Nonnull cellData) {
       NSLog(@"onGroupConversation  需要发送分享数据到%@%@群里",cellData.title,cellData.groupID);
       @strongify(self)
       [[V2TIMManager sharedInstance] sendMessage:[self dealCustomMsg]
                                         receiver:@""
                                          groupID:cellData.groupID
                                         priority:V2TIM_PRIORITY_DEFAULT
                                   onlineUserOnly:NO
                                  offlinePushInfo:nil
                                         progress:^(uint32_t progress) {
       } succ:^{
           NSLog(@"发送成功");
           //Y_SVP_SHOW_SUCCESS_MES( @"分享成功");
           Y_SVP_SHOW_SUCCESS_MES( @"成功");
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [self goChatVcWithGroudId:cellData.groupID orWithFriendId:@""];
           });

           
       } fail:^(int code, NSString *desc) {
           NSLog(@"code %d desc %@ ",code,desc);
       }];
       
   };
   [self.navigationController pushViewController:vc animated:YES];
}

 


#pragma mark 点击非S0 cell - 即点击好友的重写
- (void)onSelectFriend:(TUICommonContactCell_Minimalist *)cell
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSelectFriend:)]) {
        [self.delegate onSelectFriend:cell];
        return;
    }
    //处理数据 发送到该好友 再跳转到ChatVc回话页
    TUICommonContactCellData_Minimalist *data = cell.contactData;
    NSLog(@"onSelectFriend  需要发送分享数据到%@%@好友里",data.title,data.userID);

    [[V2TIMManager sharedInstance] sendMessage:[self dealCustomMsg]
                                      receiver:data.userID
                                       groupID:@""
                                      priority:V2TIM_PRIORITY_DEFAULT
                                onlineUserOnly:NO
                               offlinePushInfo:nil
                                      progress:^(uint32_t progress) {
    } succ:^{
        NSLog(@"发送成功");
        //Y_SVP_SHOW_SUCCESS_MES(@"分享成功");
        Y_SVP_SHOW_SUCCESS_MES( @"成功");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self goChatVcWithGroudId:@"" orWithFriendId:data.userID];
        });
    
    } fail:^(int code, NSString *desc) {
        NSLog(@"code %d desc %@ ",code,desc);
    }];
 
    
}

- (void)goChatVcWithGroudId:(NSString *)groudId orWithFriendId:(NSString *)friendId{
    
    TUIChatConversationModel *conversationModel = [TUIChatConversationModel new];
    conversationModel.groupID = groudId;
    conversationModel.userID = friendId;
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


@end



#pragma mark === ============================================================================== 直播分享调起

@interface ZhiBoGroupWillShareDoChooseGroupOrFriendListVc ()

@end

@implementation ZhiBoGroupWillShareDoChooseGroupOrFriendListVc


- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self.navigationController.navigationBar setTranslucent:NO];

}
#define  pushAddGroup @"pushAddGroupAction"
//群链接 群分享
- (V2TIMMessage *)dealCustomMsg{
    
    /* po param
     {
         activityId = "380207fb-f1bc-4f0a-807e-c96e888e3ac1";
         activityImage = "https://test.freeper.l-z.vip:61131/im/2023-09/5/3ykKE9w_4032_3024_662175_gmi.jpg";
         address = 0x864c3dd9ee6d3507cc734f72eff18fde5e278471;
         businessID = "text_share";
         category = 2;
         shareContent = Zhibo1;
     }**/
    
    V2TIMMessage *cusmessage;
    NSMutableDictionary *customDic = [[NSMutableDictionary alloc]init];
    [customDic setValue:@(GroupCreate_Version) forKey:@"version"];
    [customDic setValue:BussinessID_CUSTOM_SHARE forKey:BussinessID];
//    [customDic setValue:@(1) forKey:@"type"];//Link_Type_AddGroup_1
    //[customDic setValue:pushAddGroup forKey:@"link"];//Link_str
    //
    [customDic setValue:self.zhiBoShare_activityId       forKey:@"activityId"];
    [customDic setValue:self.zhiBoShare_activityImage    forKey:@"activityImage"];
    [customDic setValue:self.zhiBoShare_address          forKey:@"address"];
    [customDic setValue:self.zhiBoShare_shareContent     forKey:@"shareContent"];
    [customDic setValue:@(self.category )                forKey:@"category"];
    [customDic setValue:self.zhiBoShare_shareContent     forKey:@"shareContent"];
    NSLog(@"即将发送的直播活动分享数据 -- %@",customDic);
    NSError *err;
    NSData *customData= [NSJSONSerialization dataWithJSONObject:customDic options:NSJSONWritingPrettyPrinted error:&err];
    if(err){
        Y_SVP_SHOW_ERR_MES(@"转发失败");
        return cusmessage;
    }
    cusmessage = [[V2TIMManager sharedInstance] createCustomMessage:customData];
    cusmessage.customElem.desc = [NSString stringWithFormat:@"%ld",Link_Type_ShareActive_4];//用于主页显示[自定义消息]的desc处理//这里不处理是link 普通类

    return cusmessage;
    
}

//通讯录界面 重写点击s0群的方法

- (void)onGroupConversation:(TUICommonTableViewCell *)cell
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onGroupConversation:)]) {
        [self.delegate onGroupConversation:cell];
        return;
    }
   TUIGroupConversationListController_Minimalist *vc = TUIGroupConversationListController_Minimalist.new;

   @weakify(self)
   vc.onSelect = ^(TUICommonContactCellData_Minimalist * _Nonnull cellData) {
       NSLog(@"onGroupConversation  需要发送分享数据到%@%@群里",cellData.title,cellData.groupID);
       @strongify(self)
       [[V2TIMManager sharedInstance] sendMessage:[self dealCustomMsg]
                                         receiver:@""
                                          groupID:cellData.groupID
                                         priority:V2TIM_PRIORITY_DEFAULT
                                   onlineUserOnly:NO
                                  offlinePushInfo:nil
                                         progress:^(uint32_t progress) {
       } succ:^{
           NSLog(@"发送成功");
           //Y_SVP_SHOW_SUCCESS_MES( @"分享成功");
           Y_SVP_SHOW_SUCCESS_MES( @"成功");
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [self goChatVcWithGroudId:cellData.groupID orWithFriendId:@""];
           });

           
       } fail:^(int code, NSString *desc) {
           NSLog(@"code %d desc %@ ",code,desc);
       }];
       
   };
   [self.navigationController pushViewController:vc animated:YES];
}

 


#pragma mark 点击非S0 cell - 即点击好友的重写
- (void)onSelectFriend:(TUICommonContactCell_Minimalist *)cell
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSelectFriend:)]) {
        [self.delegate onSelectFriend:cell];
        return;
    }
    //处理数据 发送到该好友 再跳转到ChatVc回话页
    TUICommonContactCellData_Minimalist *data = cell.contactData;
    NSLog(@"onSelectFriend  需要发送分享数据到%@%@好友里",data.title,data.userID);

    [[V2TIMManager sharedInstance] sendMessage:[self dealCustomMsg]
                                      receiver:data.userID
                                       groupID:@""
                                      priority:V2TIM_PRIORITY_DEFAULT
                                onlineUserOnly:NO
                               offlinePushInfo:nil
                                      progress:^(uint32_t progress) {
    } succ:^{
        NSLog(@"发送成功");
        //Y_SVP_SHOW_SUCCESS_MES(@"分享成功");
        Y_SVP_SHOW_SUCCESS_MES( @"成功");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self goChatVcWithGroudId:@"" orWithFriendId:data.userID];
        });
    
    } fail:^(int code, NSString *desc) {
        NSLog(@"code %d desc %@ ",code,desc);
    }];
 
    
}

- (void)goChatVcWithGroudId:(NSString *)groudId orWithFriendId:(NSString *)friendId{
    
    TUIChatConversationModel *conversationModel = [TUIChatConversationModel new];
    conversationModel.groupID = groudId;
    conversationModel.userID = friendId;
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

@end


#pragma mark ====

@implementation  ZhiBoGroupWillChooseGroupOrFriendToChatListVc

//通讯录界面 重写点击s0群的方法

- (void)onGroupConversation:(TUICommonTableViewCell *)cell
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onGroupConversation:)]) {
        [self.delegate onGroupConversation:cell];
        return;
    }
   TUIGroupConversationListController_Minimalist *vc = TUIGroupConversationListController_Minimalist.new;
   @weakify(self)
   vc.onSelect = ^(TUICommonContactCellData_Minimalist * _Nonnull cellData) {
       //无需发信息 直接跳转
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [self goChatVcWithGroudId:cellData.groupID orWithFriendId:@""];
       });
   };
   [self.navigationController pushViewController:vc animated:YES];
}

 


#pragma mark 点击非S0 cell - 即点击好友的重写
- (void)onSelectFriend:(TUICommonContactCell_Minimalist *)cell
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSelectFriend:)]) {
        [self.delegate onSelectFriend:cell];
        return;
    }
    //处理数据 发送到该好友 再跳转到ChatVc回话页
    TUICommonContactCellData_Minimalist *data = cell.contactData;
    //无需发信息 直接跳转
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self goChatVcWithGroudId:@"" orWithFriendId:data.userID];
    });
 
    
}
@end
 
