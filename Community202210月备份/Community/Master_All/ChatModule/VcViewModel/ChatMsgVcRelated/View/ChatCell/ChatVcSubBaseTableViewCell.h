//
//  ChatVcSubBaseTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/5/10.
//

#import <UIKit/UIKit.h>
#import "ChatFriendMessageModel.h"
#import "ChatGroupMessageModel.h"
#import "ChatVcSubAllTypeCellsProtocol.h"
NS_ASSUME_NONNULL_BEGIN
//聊天展示类型
typedef enum : NSUInteger {
    ChatThisCellShowLeftRightSystemOtherType_Left,
    ChatThisCellShowLeftRightSystemOtherType_Right,
    ChatThisCellShowLeftRightSystemOtherType_SystemCenter,
} ChatThisCellShowLeftRightSystemOtherType;

//数据属于的会话类型
typedef enum : NSUInteger {
    ChatVcSessionType_FriendGroupSystemOtehr_Friend,
    ChatVcSessionType_FriendGroupSystemOtehr_Group,
    ChatVcSessionType_FriendGroupSystemOtehr_Other,
} ChatVcSessionType_FriendGroupSystemOtehr;

@interface ChatVcSubBaseTableViewCell : BaseTableViewCell

@property (nonatomic,weak) id <ChatVcSubAllTypeCellsProtocol> chatVcSubCellsDeletage;

@property (nonatomic,strong) UILabel *nickL;//昵称
@property (nonatomic,strong) UIButton *readStateBtn;//220324已读未读
@property (nonatomic,strong) UIImageView *iconImgV;
@property (nonatomic,strong) UILabel *dateL;
@property (nonatomic,strong) ChatFriendMessageModel *fmodel;
@property (nonatomic,strong) ChatGroupMessageModel *gmodel;

//
@property (nonatomic,strong) UIImageView *bubbleImageView_New;  // 拉伸气泡
@property (nonatomic,strong) UIImageView *contentView_New;//保留做大小wh的支撑和删除和撤回的位置定标物；和 图片承接img
//删除撤销键暂时不动
//@property (nonatomic,strong) UIButton *deletThisMsgBtn;
//@property (nonatomic,strong) UIButton *undoThisMsgBtn;



//
- (void)setBaseCellTypeLeftOrRightOrCenter:(ChatThisCellShowLeftRightSystemOtherType)chatBaseCellType_RightOrLeft;
- (void)fillMsgCellWithFriendMsgData:(nullable ChatFriendMessageModel *)fmodel orGroupModel:(nullable ChatGroupMessageModel *)gmodel;
//220324
- (void)fillBeginWithUILeftOrRightOrCenter:(ChatThisCellShowLeftRightSystemOtherType)showType;
//220324 数据入口 给基础数据赋值和其他存储
- (void)fillMsgCellBasePublicInfoWithThisMsgCellShowLeftRightSystemType:(ChatThisCellShowLeftRightSystemOtherType)showType
                                                    withThisMsgInfoType:(NSString *)msgInfoTypeStr
                                               withFriendGroupOtherType:(ChatVcSessionType_FriendGroupSystemOtehr)friendGroupSystemType
                                                           withMsgModel:(id)msgModel;//全类型cell的基础公共数据fill
//220324 给子类赋内容值时 重用
- (void)fillMsgCellContentInfoWithFriendGroupOtherType:(ChatVcSessionType_FriendGroupSystemOtehr)friendGroupSystemType withMsgModel:(id)msgModel;
//voice 分左右
- (void)fillMsgCellContentInfoWithFriendGroupOtherType:(ChatVcSessionType_FriendGroupSystemOtehr)friendGroupSystemType withMsgModel:(id)msgModel withRightOrLeft:(ChatThisCellShowLeftRightSystemOtherType)showType;

@end

NS_ASSUME_NONNULL_END
