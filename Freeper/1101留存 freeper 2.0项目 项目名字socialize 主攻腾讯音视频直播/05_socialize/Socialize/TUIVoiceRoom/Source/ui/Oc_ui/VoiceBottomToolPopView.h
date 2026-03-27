//
//  VoiceBottomToolPopView.h
//  TUIVoiceRoom-TUIVoiceRoomKitBundle
//
//  Created by 余莹 on 2023/5/31.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "VoiceBasePopView.h"
 
#import <SDWebImage/SDWebImage.h>

NS_ASSUME_NONNULL_BEGIN



#pragma mark === 底部工具tool popview
typedef enum : NSUInteger {
    Voice_Botom_Tool_Type_JinYin = 0,
    Voice_Botom_Tool_Type_GuanLiChengYuan,
    Voice_Botom_Tool_Type_QinChu,
    Voice_Botom_Tool_Type_FenXiang,
    Voice_Botom_Tool_Type_LiaoTian,
    Voice_Botom_Tool_Type_LianXianSet,
    Voice_Botom_Tool_Type_ZhiBoSet,
    Voice_Botom_Tool_Type_YinXiaoSet,
    Voice_Botom_Tool_Type_GuanLiYuan,
    Voice_Botom_Tool_Type_RewardRedEnv,
    Voice_Botom_Tool_Type_GoToChatWithHasVoiceIng,//保持直播的情况下 去聊天
    Voice_Botom_Tool_Type_GuanBi,
} Voice_Botom_Tool_Type;

@protocol VoiceBottomToolPopViewDelegate <NSObject>

- (void)bottomToolTouchType:(Voice_Botom_Tool_Type)type;

@end


@interface VoiceBottomToolPopView : VoiceBasePopView
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,weak) id <VoiceBottomToolPopViewDelegate> delegate;
- (void)changeArrInfoIsGuanZhong;
@end


@interface VoiceBottomToolPopViewSubCell : UICollectionViewCell
@property (nonatomic,strong) UILabel *bottomL;
@property (nonatomic,strong) UIImageView *iconImgv;
@end




#pragma mark === 红包popV

typedef  void(^GotSignInfoSsendRedEnvAcBlock)(NSString *sigOkOfDataMsg);

@interface SendRedEnvViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>
//@property (nonatomic, strong) TUIChatConversationModel *conversationData;
@property (nonatomic, strong) NSString *creatUserName;
@property (nonatomic, strong) NSString *creatUserID;
@property (nonatomic, strong) NSString *creatUserFaceUrl;
@property (nonatomic, strong) NSString *selfRoomGroupIDstr;
@property (nonatomic, strong) id conversationData;
@property (nonatomic, strong) UIViewController *msgVc;
@property (nonatomic,strong) NSString *zhiBoInfoOfCustomMsgTypeStr;
@property (nonatomic,strong) NSString *zhiBoInfoOfCustomMsgActivityIDStr;
//
@property (nonatomic,strong) UIButton *clearnBtn;
@property (nonatomic,strong) UIView *mainV;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *footerBtn;
@property (nonatomic,strong) NSString *inputOk_save_moneyStr;
@property (nonatomic,strong) NSString *inputOk_save_tipStr;
@property (nonatomic,strong) NSString *inputOk_save_moneyTypeStr;
@property (nonatomic,assign) NSInteger inputOk_save_personNum;

@property (nonatomic,assign) BOOL isGroupType;
@property (nonatomic,strong) NSArray *showCellTypeArrs;
@property (nonatomic,strong) NSArray *showCellTitleArrs;
@property (nonatomic,strong) NSArray *showCellTagArrs;
//红包创建成功后 才调用
@property (nonatomic,copy) GotSignInfoSsendRedEnvAcBlock gotSignInfoSsendRedEnvAcBlock;
@end

@interface SendRedEnvSubInputTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *leftL;
@property (nonatomic,strong) UITextView *textView;
@end

@interface SendRedEnvSubInputAndHaveSubTitleTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *leftL;
@property (nonatomic,strong) UIButton *textLeftShowBtn;
@property (nonatomic,strong) UITextField *textF;
@property (nonatomic,strong) UIView *textFbkView;//当作背景位置

@end


typedef void(^MoneyTypeChooseOneItemBlock)(NSDictionary *oneItem);

static NSString *ksectionTitileHeaderView_I = @"section_header";
static NSString *ksectionTitileFooterView_I = @"section_footer";

@interface SendRedEnvSubChooseMoneyTypeTableViewCell : UITableViewCell <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UILabel *leftL;
@property (nonatomic,strong) UIView *typesBkV;
@property (nonatomic,strong) UICollectionView *typesBkSubCollV;
@property (nonatomic,strong) NSMutableArray *saveListArr;
@property (nonatomic,strong) NSMutableArray *saveListArr_InfoTypeList;
@property (nonatomic,strong) NSMutableDictionary *saveListArr_InfoTypeObjDic;
@property (nonatomic,strong) NSDictionary *saveNowChooseItemDic;
@property (nonatomic,copy) MoneyTypeChooseOneItemBlock touchChooseTypeBlock;
- (void)fillMoneyTypeUseList:(NSMutableArray *)listArr;

@end



@interface ImgTextCollectionViewCell : UICollectionViewCell
//@property (nonatomic,strong) UIImageView *imgV;
//@property (nonatomic,strong) UILabel  *textL;
@property (nonatomic,strong) UIButton *centerBtn;
@end

@interface SendRedEnvSubMyBanlanceInfoTypeTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *botttomL;
@property (nonatomic,strong) UIButton *chongZhiBtn;
@property (nonatomic,strong) UILabel *tileL;
@property (nonatomic,strong) UILabel *moneyL;
@end

NS_ASSUME_NONNULL_END
