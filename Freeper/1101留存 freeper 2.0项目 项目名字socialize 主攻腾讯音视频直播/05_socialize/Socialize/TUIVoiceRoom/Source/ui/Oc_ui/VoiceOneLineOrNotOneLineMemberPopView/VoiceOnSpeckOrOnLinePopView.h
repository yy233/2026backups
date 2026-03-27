//
//  VoiceOnSpeckOrOnLinePopView.h
//  AFNetworking
//
//  Created by 余莹 on 2023/6/1.
//

#import <UIKit/UIKit.h>
#import "VoiceMemberPopListView.h"
#import "TRTCVoiceRoomDef.h"


NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    VoiceOnSpeckOrOnLineTopChooseType_OnSpeckType = 0,
    VoiceOnSpeckOrOnLineTopChooseTyp_OnLineType = 1,
} VoiceOnSpeckOrOnLineTopChooseTyp_Type;


typedef enum : NSUInteger {
    VoiceOnSpeckOrOnLinePopList_Type_SpeckType = 0,
    VoiceOnSpeckOrOnLinePopList_Type_NotSpeckType = 1,
    VoiceOnSpeckOrOnLinePopList_Type_CanCallType = 2,
    VoiceOnSpeckOrOnLinePopList_Type_NoCallType = 3,
} VoiceOnSpeckOrOnLinePopList_Type;



@protocol VoiceOnSpeckOrOnLinePopViewDelegate <NSObject>

- (void)touchTopChangeBtnsWithVoiceOnSpeckOrOnLineTopChooseTyp_Type:(VoiceOnSpeckOrOnLineTopChooseTyp_Type)type;//切tabview类型行 
- (void)touchPopListCellRightItemVoiceOnSpeckOrOnLinePopList_Type:(VoiceOnSpeckOrOnLinePopList_Type)rightBtnNowNeedType
                                         withNowTopChooseTyp_Type:(VoiceOnSpeckOrOnLineTopChooseTyp_Type)nowTopType
                                                     withUserInfo:(NSString *)userInfoIDstr;

- (void)allJinYin;
- (void)allJieChuJinYin;
 
 

@end


@interface VoiceOnSpeckOrOnLinePopView : VoiceMemberPopListView <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) VoiceOnSpeckOrOnLineTopChooseTyp_Type saveNowPopViewTop_Type;
@property (nonatomic,weak) id <VoiceOnSpeckOrOnLinePopViewDelegate> onSpeckOrOnLineDelegate;
- (void)speckOrOnLinePopViewNowTwoHaveShagnMaiJinYinIdsArr:(NSMutableArray *)shangMaijinYinIdArr andDanMuJinYanIdsArr:(NSMutableArray *)danMuJinYanIdArr;

@end

NS_ASSUME_NONNULL_END
