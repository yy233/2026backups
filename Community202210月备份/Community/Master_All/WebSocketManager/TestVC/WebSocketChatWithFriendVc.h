//
//  WebSocketChatWithFriendVc.h
//  Community
//
//  Created by 余莹 on 2021/4/23.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface WebSocketChatWithFriendVc : UITableViewController
@property (nonatomic,strong) NSMutableArray *dataSourceOfList;
//
@property (nonatomic,strong) NSString *friendUUID;
 

@end

NS_ASSUME_NONNULL_END
