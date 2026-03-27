//
//  ImChatVc.m
//  Socialize
//
//  Created by 余莹 on 2023/5/11.
//

#import "ImChatVc.h"
#import "TUIC2CChatViewController_Minimalist.h"//会话界面
#import "IMGroupDetailViewController.h"
#import "IMGroupInfoDetailViewController_Minimalist.h"

#import "TUIFriendProfileController_Minimalist.h"
#import "IMGoChatOneUserInfoVcTool.h"
@import TUICore;
@interface ImChatVc ()

@end

@implementation ImChatVc



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initRightItems];
    //[self addChatGoOnePersonInfoVcNotice];//点击头像的跳转通知
    
    TUIC2CChatViewController_Minimalist *vc = [[TUIC2CChatViewController_Minimalist alloc] init];
    [vc setConversationData:self.converInfo];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
 
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if(![self.friendId isEqualToString:@"Freeper_Message"] && self.friendId.length>0){//非系统消息 且是用户 非群
        NSString *willUseTitleStr = [self suoDuanAddressStr:self.title];
        self.title = willUseTitleStr;
    }
   
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
- (void)initRightItems{
 
    if(self.isGroupType){
        UIBarButtonItem *groupDetailItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"更多"] style:UIBarButtonItemStylePlain target:self action:@selector(goToGroupDetailInfo)];
//        self.navigationController.navigationItem.rightBarButtonItem = groupDetailItem;
        [self.navigationItem setRightBarButtonItems:@[groupDetailItem] animated:YES];
    }else{
        
        if(![self.friendId isEqualToString:@"Freeper_Message"]){//非系统消息 则有右按钮
            UIBarButtonItem *friendsDetailItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"更多"] style:UIBarButtonItemStylePlain target:self action:@selector(goToFirendsDtailInfo)];
    //        self.navigationController.navigationItem.rightBarButtonItem = groupDetailItem;
            [self.navigationItem setRightBarButtonItems:@[friendsDetailItem] animated:YES];
        }
            
            

    }
    
    


  
}
- (void)goToGroupDetailInfo{
    DLog(@"");
//    IMGroupDetailViewController *vc = [[IMGroupDetailViewController alloc]init];
    IMGroupInfoDetailViewController_Minimalist *vc = [[IMGroupInfoDetailViewController_Minimalist alloc]init];
    vc.groupId = self.groupId;
    [self pushVc:vc];
}

- (void)goToFirendsDtailInfo{
    
     Y_NSNotificationCenter_PostNotice_HaveObject_Name(Notice_Name_GotoImOneUserInfoVc, self.friendId);//去个人中心页

    /**
     
     WEAKSELF
     //即时通讯个人信息页
     TUIFriendProfileController_Minimalist *vc = [[TUIFriendProfileController_Minimalist alloc]init];
     [[V2TIMManager sharedInstance] getFriendsInfo:@[self.friendId] succ:^(NSArray<V2TIMFriendInfoResult *> *resultList) {
         if (resultList.firstObject != nil) {
             V2TIMFriendInfo *info =  resultList.firstObject.friendInfo;
             info.userID = self.friendId;
             vc.friendProfile  = info;
             [weakSelf pushVc:vc];
         }
     } fail:^(int code, NSString *desc) {
         
     }];
     
     */
   
 
}

@end
