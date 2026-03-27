//
//  ZYChatView.h
//  Community
//
//  Created by ZY on 2021/4/22.
//

#import <UIKit/UIKit.h>
#import "ChatViewSubFunctionOfEmojiView.h"
#import "ZYChatFunctionView.h"
#import "ZYChatBarView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ZYChatViewDelegate <NSObject>

- (void)iconImageViewSelectedAtIndex:(NSInteger)index;
//
- (void)delegateTouchsSendMsgWithText:(NSString *)TextStr;
//相册照相等底部综合按钮
- (void)touchSubCollectionViewWithIndexFoundation:(NSInteger)index;
//0620更换底部菜单后的新方法 给录音相关使用
- (void)chooseBottomSubVoiceActionWithFoundation;
//图片cell的放大action
- (void)subViewCellImgTypeCellWillShowBigImgWithImgAllUrlStr:(NSString *)imgAllUrlStr;
//语音cell的下载存储播放action
- (void)subViewCllVoiceTypeCellPlayVoiceActionWitnMsgId:(NSString *)MsgId withFileSecret:(NSString *)fileSecret withFileSecretFileUrlStr:(NSString *)voiceFileIdStr;
//撤销键和删除后的刷新 当前刷新全部数据以后根据seqID刷新
- (void)messageInfoDeletOrCancelWillGetNewInfoList;

//定位地图数据
- (void)viewDeletWithShowBigLocateViewWithShowAddressStr:(NSString *)addressShowStr withlati:(CGFloat)lati withLongi:(CGFloat)longi;

@end

@interface ZYChatView : UIView

@property (nonatomic, strong) UITableView *tableView; 

@property (nonatomic, weak) id<ZYChatViewDelegate> delegate;
//音频数据停止动画 行row刷新
- (void)voiceEndCellRowNum:(NSInteger)index;
//刷新固定的row 附带新的listdata 常用于收到撤回数据后
- (void)msgListViewloadRowNum:(NSInteger)rowNum withMsgListData:(NSMutableArray *)dataSourceArr;
//ui数据
- (void)fillFriendImgStr:(NSString *)friendImgStr;
- (void)fillGroupMemberImgDic:(NSMutableDictionary *)imgDic andNameDic:(NSMutableDictionary *)nameDic;
//消息数据
- (void)fillDataWithFriendHistoryMsg:(NSMutableArray *)dataSourceArr;
- (void)fillDataWithGroupHistoryMsg:(NSMutableArray *)dataSourceArr;
//背景数据
- (void)fillChatViewBackImgWithUrlStr:(NSString *)backImgUrl;
//
- (void)bottomHidenFunctionView;
//发送数据后 主动回到底部
- (void)sendMsgWillGotoBottomShow;
//下拉刷新后 内容offset处理
- (void)headerRefreshMsgWillOneOffset;

//bottom表情功具
@property (nonatomic, strong) ChatViewSubFunctionOfEmojiView *emjBottomView;
@property (nonatomic, strong) NSMutableString *chtViewSaveTextViewStr;
//bottom菜单
@property (nonatomic, strong) ZYChatFunctionView *chatFunctionView;
//bottom输入框
@property (nonatomic, strong) ZYChatBarView *chatBarView;


@end

NS_ASSUME_NONNULL_END
