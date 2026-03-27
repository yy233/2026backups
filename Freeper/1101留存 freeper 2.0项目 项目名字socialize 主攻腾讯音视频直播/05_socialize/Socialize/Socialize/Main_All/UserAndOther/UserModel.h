//
//  UserModel.h
//  Socialize
//
//  Created by 余莹 on 2023/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject <NSSecureCoding,NSObject, NSCoding>
@property (nonatomic ,copy) NSString *username;
@property (nonatomic ,copy) NSString *twitterName;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *rowCreate;
@property (nonatomic, copy) NSString *profileImageUrl;
@property (nonatomic, copy) NSString *issueTypes;
@property (nonatomic, copy) NSString *imSignature;
@property (nonatomic, copy) NSString *imId;
@property (nonatomic, copy) NSString *imToken;
@property (nonatomic, copy) NSString *cogChannelId;
@property (nonatomic, copy) NSString *address;
@property (nonatomic ,assign) NSInteger  uid;
@property (nonatomic, strong) NSArray *userVerified;
@property (nonatomic, strong) NSString *saveMydomain;//     验证用户是否已经发行过圈子 其中键值   domain = "aaaaaaaaaa.free";
//0901
@property (nonatomic,strong) NSString *domainNftId;
@property (nonatomic,strong) NSString *useDomain;

/**
 
 
 address = 0x864c3dd9ee6d3507cc734f72eff18fde5e278471;
 cogChannelId = "g0_";
 domainNftId = 10000;
 imId = ulzwwyPSkOcDQ;
 imSignature = "eJw1jssKgkAUht9ltoadUccpoZ1IoJU1LtpKjnG8DqaZRe*eaS3-ywffi0SB0OVDYSOJQxljBgAspvYuG*IQQwcy51uSx0phMv4sAM5Nyq15wURWLaY4AV3x7PshFPnh4h7-KF7HJWAaeD6vVXbSBkEr6Hjr1Swqz1VouNJc*vsm2xarNNhtfmCL5dfLXpvMhlHt-QHbxzOV";
 imToken = "";
 issueTypes = friend;
 profileImageUrl = "https://test.freeper.l-z.vip:61131/avatar/2023-07/1/1dKZTPi_657_698_45845_gmi.jpg";
 rowCreate = "2023-07-24 06:53:32";
 token = P57kCxYJEuf6sQjo;
 twitterName = "";
 uid = 657552;
 useDomain = "panda.free";
 userVerified =         (
     "account_mail"
 );
 username = "";
 
 */
/**
 {
 address = 0xa3885c5812400eeef554f39b5cdeb53427aaa451;
 cogChannelId = "g2_KfjnVZ7hes";
 imId = uAVExpu8Y3I7T;
 imSignature = "eJyrVgrxCdZLrSjILEpVsjI0NTU1MjAw0AGLlqUWKVkpGekZKEH4xSnZiQUFmSlAdSYGBubmxobmJhCZzJTUvJLMtEywhlLHMNeKglKLSGNP8xCY1sx0oExlWECWS35ipaFXgI9xZLG3Y2BUcZWXt7G5k7tTmXalo19eZEqWh5uxu4eJLVRjSWYuyF1mlgYGhgaGhga1ALWQMxA_";
 imToken = "";
 issueTypes = "";
 profileImageUrl = "";
 rowCreate = "2023-07-03 02:22:06";
 token = KBqnPg5vTc2Er07f;
 twitterName = carlosmx1985;
 uid = 245;
 userVerified =     (
     "account_twitter"
 );
 username = "";
};
 */
@end

NS_ASSUME_NONNULL_END
