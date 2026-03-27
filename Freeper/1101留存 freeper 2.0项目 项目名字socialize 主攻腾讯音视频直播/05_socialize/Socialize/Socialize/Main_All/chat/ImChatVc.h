//
//  ImChatVc.h
//  Socialize
//
//  Created by 余莹 on 2023/5/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImChatVc : Y_BaseViewController
@property (nonatomic,strong) id converInfo;
@property (nonatomic,assign) BOOL isGroupType;
@property (nonatomic,strong) NSString *groupId;
@property (nonatomic,strong) NSString *friendId;
@end

NS_ASSUME_NONNULL_END
