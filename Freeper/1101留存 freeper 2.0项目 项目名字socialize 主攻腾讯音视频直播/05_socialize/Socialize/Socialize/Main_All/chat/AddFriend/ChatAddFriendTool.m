//
//  ChatAddFriendTool.m
//  Socialize
//
//  Created by 余莹 on 2023/8/17.
//

#import "ChatAddFriendTool.h"
#import "TUIFindContactViewController_Minimalist.h"
#import "TUIFriendRequestViewController_Minimalist.h"
#import "TUIFloatViewController.h"

#import "GroupOfQRvc.h"
@implementation ChatAddFriendTool

+ (void)addOnePersonWithUserImId:(NSString *)imidStr withOtherInfo:(id)otherInfo  withusePushVc:(UIViewController *)vc{
    DLog(@"");
    //    [self addToContacts];
    /**
     
     MySubsWebVc *chatOneUserInfoVc = [[MySubsWebVc alloc]init];
     chatOneUserInfoVc.subTypeUrlSuix = MySubVc_Url_Suix_userPersonal;
     //数据相关
     if(imidStr.length>0){
     chatOneUserInfoVc.userPersonalImIdStr  = imidStr;
     }else{
     if( [otherInfo isKindOfClass:[NSArray class]]){
     NSArray *otherInfoArr = [NSArray arrayWithArray:otherInfo];
     if( otherInfoArr.count > 0){
     chatOneUserInfoVc.userPersonalImIdStr = otherInfoArr.firstObject;
     }else{
     //空的otherinfo 主用 imidStr
     chatOneUserInfoVc.userPersonalImIdStr = imidStr;
     }
     }
     }
     
     
     //跳转相关
     if([vc isKindOfClass:[UITabBarController class]]){
     UITabBarController *tabvc = (UITabBarController *)vc;
     
     if([tabvc.childViewControllers[tabvc.selectedIndex] isKindOfClass:[UINavigationController class]]){
     UINavigationController * useNav =  (UINavigationController *)tabvc.childViewControllers[tabvc.selectedIndex];
     [useNav pushViewController:chatOneUserInfoVc animated:YES];
     
     }else{
     UIViewController * usevc =  (UIViewController *)tabvc.childViewControllers[tabvc.selectedIndex];
     [usevc.navigationController pushViewController:chatOneUserInfoVc animated:YES];
     }
     }else{
     [vc.navigationController pushViewController:chatOneUserInfoVc animated:YES];
     
     }*/
    //}
    //
    //
    //#pragma mark === addToContacts
    ////弹出搜索界面可以加好友
    //+ (void)addToContacts {
    
    //u6dR6NbVBndff
    
    if(imidStr.length<=0){
        Y_SVP_SHOW_ERR_MES(@"数据有误");
        return;
    }
    
//    TUIFindContactViewController_Minimalist *add = [[TUIFindContactViewController_Minimalist alloc] init];
//    add.type = TUIFindContactTypeC2C_Minimalist;
//    add.searchBar.text = imidStr;
//    @weakify(vc)
//    add.onSelect = ^(TUIFindContactCellModel_Minimalist * cellModel) {
//        @strongify(vc)
//        [vc dismissViewControllerAnimated:NO completion:^{
//            TUIFriendRequestViewController_Minimalist *frc = [[TUIFriendRequestViewController_Minimalist alloc] init];
//            frc.profile = cellModel.userInfo;
//            
//            TUIFloatViewController *bfloatVC = [[TUIFloatViewController alloc] init];
//            [bfloatVC appendChildViewController:(id)frc topMargin:kScale390(87.5)];
//            [bfloatVC.topGestureView setTitleText:TIMCommonLocalizableString(Info) subTitleText:imidStr leftBtnText:TIMCommonLocalizableString(TUIKitCreateCancel) rightBtnText:@""];
//            bfloatVC.topGestureView.rightButton.hidden = YES;
//            bfloatVC.topGestureView.subTitleLabel.hidden = YES;
//            bfloatVC.modalPresentationStyle = UIModalPresentationFullScreen;
//            [vc presentViewController:bfloatVC animated:YES completion:nil];
//            bfloatVC.topGestureView.leftButtonClickCallback = ^{
//                [vc dismissViewControllerAnimated:YES completion:^{}];
//            };
//        }];
//
//    };
//    [vc presentViewController:add animated:YES completion:^{
//        DLog(@"");
//        [add searchBarSearchButtonClicked: add.searchBar];
//     
//    }];
//   
////    - (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
//    
  
     
     TUIFindContactViewController_Minimalist *add = [[TUIFindContactViewController_Minimalist alloc] init];
     add.type = TUIFindContactTypeC2C_Minimalist;
     add.searchBar.text = imidStr;
     @weakify(vc)
     add.onSelect = ^(TUIFindContactCellModel_Minimalist * cellModel) {
         @strongify(vc)
         [vc dismissViewControllerAnimated:NO completion:^{
             TUIFriendRequestViewController_Minimalist *frc = [[TUIFriendRequestViewController_Minimalist alloc] init];
             frc.profile = cellModel.userInfo;
 //            cellModel.userInfo.userID = imidStr;
             
             TUIFloatViewController *bfloatVC = [[TUIFloatViewController alloc] init];
             [bfloatVC appendChildViewController:(id)frc topMargin:kScale390(87.5)];
             [bfloatVC.topGestureView setTitleText:TIMCommonLocalizableString(Info) subTitleText:imidStr leftBtnText:TIMCommonLocalizableString(TUIKitCreateCancel) rightBtnText:@""];
             bfloatVC.topGestureView.rightButton.hidden = YES;
             bfloatVC.topGestureView.subTitleLabel.hidden = YES;
             bfloatVC.modalPresentationStyle = UIModalPresentationFullScreen;
             [vc presentViewController:bfloatVC animated:YES completion:nil];
             bfloatVC.topGestureView.leftButtonClickCallback = ^{
                 [vc dismissViewControllerAnimated:YES completion:^{}];
             };
         }];

     };
         
     TUIFloatViewController *floatVC = [[TUIFloatViewController alloc] init];
     [floatVC appendChildViewController:(id)add topMargin:kScale390(87.5)];
     [floatVC.topGestureView setTitleText:TIMCommonLocalizableString(TUIKitAddFriend) subTitleText:imidStr leftBtnText:TIMCommonLocalizableString(TUIKitCreateCancel) rightBtnText:@""];
     
     floatVC.topGestureView.rightButton.hidden = YES;
     floatVC.topGestureView.subTitleLabel.hidden = YES;
     floatVC.topGestureView.leftButtonClickCallback = ^{
         [vc dismissViewControllerAnimated:YES completion:^{}];
     };
     floatVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [vc presentViewController:floatVC animated:YES completion:^{
        [add searchBarSearchButtonClicked: add.searchBar];

    }];
      
    
}
@end


#pragma mark ===


@implementation ChatGroupQRTool

+ (void)groupToolQrWithGroupID:(NSString *)groupID withGroupImg:(UIImage *)gimg withGroupName:(NSString *)groupName  withusePushVc:(UIViewController *)vc{

    GroupOfQRvc *gQrVc = [[GroupOfQRvc alloc]init];
    gQrVc.groupShowName = groupName;
    gQrVc.groupimg = gimg;
    gQrVc.groupID = groupID;
    gQrVc.hidesBottomBarWhenPushed = YES;
    [vc.navigationController pushViewController:gQrVc animated:YES];
     
}

+ (void)cheackGroupHaveReqListDataWithBlock:(CheckChatGroupApplicationList)block{
    [[V2TIMManager sharedInstance] getGroupApplicationList:^(V2TIMGroupApplicationResult *result) {
        NSLog(@"cheackGroupHaveReqListDataWithBlock -- res %@",result);
        block(result.applicationList, result.unreadCount ,YES);
    } fail:^(int code, NSString *desc) {
        block(@[].mutableCopy,0,NO);
    }];
    
}
@end
