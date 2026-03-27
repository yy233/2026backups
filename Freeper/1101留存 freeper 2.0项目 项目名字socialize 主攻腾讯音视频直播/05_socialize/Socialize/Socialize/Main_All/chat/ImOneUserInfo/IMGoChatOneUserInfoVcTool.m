//
//  IMGoChatVcTool.m
//  Socialize
//
//  Created by 余莹 on 2023/7/20.
//

#import "IMGoChatOneUserInfoVcTool.h"
#import "MySubsWebVc.h"

@implementation IMGoChatOneUserInfoVcTool



+ (void)gotoImOneUserInfoViewControllerWithUserImId:(NSString *)imidStr withOtherInfo:(id)otherInfo  withusePushVc:(UIViewController *)vc{
    /**
     
     goOnePersonInfoVcWithNotice object (
        ulzwwyPSkOcDQ,
        "panda.free",
        "https://test.freeper.l-z.vip:61131/avatar/2023-07/1/1dKZTPi_657_698_45845_gmi.jpg"
    )
     
     */
    
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

    }
     
}



//
//
// + (void)gotoImOneUserInfoViewControllerWithUserImId:(NSString *)imidStr withOtherInfo:(id)otherInfo  withusePushVc:(UIViewController *)vc{
//
//     ImOneUserInfoViewController *chatOneUserInfoVc = [[ImOneUserInfoViewController alloc]init];
//     //数据相关
//     if( [otherInfo isKindOfClass:[NSArray class]]){
//         NSArray *otherInfoArr = [NSArray arrayWithArray:otherInfo];
//         if( otherInfoArr.count == 3){
//             chatOneUserInfoVc.headerImgstr = otherInfoArr.lastObject;
//             chatOneUserInfoVc.addressShowStr = otherInfoArr[1];
//             chatOneUserInfoVc.friendId = otherInfoArr.firstObject;
//         }else{
//             //空的otherinfo 主用 imidStr
//             chatOneUserInfoVc.friendId = imidStr;
//         }
//     }
//
//     //跳转相关
//     if([vc isKindOfClass:[UITabBarController class]]){
//         UITabBarController *tabvc = (UITabBarController *)vc;
//
//          if([tabvc.childViewControllers[tabvc.selectedIndex] isKindOfClass:[UINavigationController class]]){
//             UINavigationController * useNav =  (UINavigationController *)tabvc.childViewControllers[tabvc.selectedIndex];
//             [useNav pushViewController:chatOneUserInfoVc animated:YES];
//
//          }else{
//              UIViewController * usevc =  (UIViewController *)tabvc.childViewControllers[tabvc.selectedIndex];
//              [usevc.navigationController pushViewController:chatOneUserInfoVc animated:YES];
//          }
//     }else{
//         [vc.navigationController pushViewController:chatOneUserInfoVc animated:YES];
//
//     }
//
// }
 


/**
+ (void)gotoImOneUserInfoViewControllerWithUserImId:(NSString *)imidStr withOtherInfo:(id)otherInfo
                                      withusePushVc:(UIViewController *)vc{
    
//    ImOneUserInfoViewController *chatOneUserInfoVc = [[ImOneUserInfoViewController alloc]init];
//    ImOneUserInfoViewController *chatOneUserInfoVc = [[ImOneUserInfoViewController alloc]init];
    //数据相关
    
    NSLog(@"");  


    MySubsWebVc *chatOneUserInfoVc = [[MySubsWebVc alloc]init];
    chatOneUserInfoVc.subTypeUrlSuix = MySubVc_Url_Suix_userPersonal;
    
    //数据相关
    if( [otherInfo isKindOfClass:[NSArray class]]){
        NSArray *otherInfoArr = [NSArray arrayWithArray:otherInfo];
        if( otherInfoArr.count > 3){
            DLog(@"otherInfoArr = %@",otherInfoArr);
            chatOneUserInfoVc.userPersonalImIdStr = imidStr;
        }else{
            //空的otherinfo 主用 imidStr
            DLog(@"otherInfoAs = %@",imidStr);
            chatOneUserInfoVc.userPersonalImIdStr = imidStr;
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

    }
     
}
 */




@end
