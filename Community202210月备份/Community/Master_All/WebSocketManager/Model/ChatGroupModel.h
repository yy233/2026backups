//
//  ChatGroupModel.h
//  Community
//
//  Created by 余莹 on 2021/5/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatGroupModel : NSObject
/**
 {
     avatarMediaId = "2021-05-06/f7de7a28183240d7977c850a594ea07e.jpg";
     createUserId = 2a314f0322884e1b927e89a636ac0ec2;
     groupName = "\U7fa4\U804a";
     groupUuid = 20235b866d9f47bfbed4dbedf5ebe41b;
 }
 */
@property (nonatomic,strong) NSString *avatarMediaId;
@property (nonatomic,strong) NSString *createUserId;
@property (nonatomic,strong) NSString *groupName;
@property (nonatomic,strong) NSString *groupUuid;


@end

NS_ASSUME_NONNULL_END
