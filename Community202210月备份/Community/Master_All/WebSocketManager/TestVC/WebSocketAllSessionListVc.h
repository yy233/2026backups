//
//  WebSocketAllSessionListVc.h
//  Community
//
//  Created by 余莹 on 2021/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebSocketAllSessionListVc : UITableViewController
@property (nonatomic,strong) NSMutableArray *friendsArr;
@property (nonatomic,strong) NSMutableArray *groupsArr;
@property (nonatomic,assign) BOOL isAllGroupSectionList;
@end

NS_ASSUME_NONNULL_END
