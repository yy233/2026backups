//
//  GroupQrWillShareDoChooseGroupOrFriendListVc.h
//  Socialize
//
//  Created by 余莹 on 2023/8/23.
//

#import <UIKit/UIKit.h>
#import <TUIContactController_Minimalist.h>
NS_ASSUME_NONNULL_BEGIN

@interface GroupQrWillShareDoChooseGroupOrFriendListVc : TUIContactController_Minimalist
//
@property (nonatomic,strong) NSString *willShareGroupShowName;
@property (nonatomic,strong) NSString *willShareGroupID;
@property (nonatomic,strong) UIImage *willShareGroupimg;
@end


@interface ZhiBoGroupWillShareDoChooseGroupOrFriendListVc : TUIContactController_Minimalist
@property (nonatomic,strong) NSString *zhiBoShare_activityId;
@property (nonatomic,strong) NSString *zhiBoShare_activityImage;
@property (nonatomic,strong) NSString *zhiBoShare_address;
@property (nonatomic,strong) NSString *zhiBoShare_shareContent;
@property (nonatomic,assign) NSInteger category;
//activityId = "380207fb-f1bc-4f0a-807e-c96e888e3ac1";
//activityImage = "https://test.freeper.l-z.vip:61131/im/2023-09/5/3ykKE9w_4032_3024_662175_gmi.jpg";
//address = 0x864c3dd9ee6d3507cc734f72eff18fde5e278471;
//businessID = "text_share";
//category = 2;
//shareContent = Zhibo1;
- (void)goChatVcWithGroudId:(NSString *)groudId orWithFriendId:(NSString *)friendId;
@end


@interface ZhiBoGroupWillChooseGroupOrFriendToChatListVc : ZhiBoGroupWillShareDoChooseGroupOrFriendListVc
@property (nonatomic,assign) NSInteger zhiBoOnAirAndChooseGroupOrFriendToChatTypeBool;

@end

NS_ASSUME_NONNULL_END
