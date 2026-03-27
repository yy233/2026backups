//
//  WebSocketTestView.h
//  Community
//
//  Created by 余莹 on 2021/4/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^BtnNum)(int);//按钮的
//cell点击
//好友
typedef void(^AgreefriendBlook)(NSString *);//同意
typedef void(^RejAgreefriendBlook)(NSString *);//拒绝
//聊天
typedef void(^ChatWithFriendBlock)(NSString *);//聊天
//删除会话
typedef void(^DeletOneSecceionBlock)(NSString *);
//______________________________
//建群
typedef void(^CreatGroupBlock)(void);
//建群
typedef void(^AddFriendsToGroupBlock)(void);
typedef void(^GetAllGroupBlock)(void);
//
typedef void(^ChangeUserInfo)(NSInteger);//用户信息相关
 
@interface WebSocketTestView : UIView
@property (weak, nonatomic) IBOutlet UIButton *addFbtn;

@property (weak, nonatomic) IBOutlet UITableView *friendReInfoList;
@property (weak, nonatomic) IBOutlet UITableView *friendList;
@property (nonatomic,copy)  BtnNum btnNNNNNN;

@property (copy, readwrite, nonatomic) void (^touchUpInsideImageButton)(id sender);

- (void)fFriendReqLiesArr:(NSMutableArray *)arr;
- (void)fFriendListArr:(NSMutableArray *)arr;
@property (nonatomic,strong) NSMutableArray *arrOfFReqList;
@property (nonatomic,strong) NSMutableArray *arrOfFList;


//

@property (nonatomic,copy)AgreefriendBlook  agreeFBlock;
@property (nonatomic,copy)RejAgreefriendBlook  regagreeFBlock;
@property (nonatomic,copy)ChatWithFriendBlock  chatFBlock;

@property (nonatomic,copy)DeletOneSecceionBlock deletSecceion;//删除单聊会话

//
@property (nonatomic,copy)CreatGroupBlock creatGroupBlock;
@property (nonatomic,copy)AddFriendsToGroupBlock addFriendsToGroupBlock;
@property (nonatomic,copy)GetAllGroupBlock getAllGroupBlock;
@property (nonatomic,copy)ChangeUserInfo changeUserInfo;

@end

NS_ASSUME_NONNULL_END
