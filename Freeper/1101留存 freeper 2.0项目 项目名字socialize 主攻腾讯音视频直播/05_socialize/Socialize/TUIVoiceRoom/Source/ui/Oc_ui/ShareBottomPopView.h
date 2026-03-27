//
//  ShareBottomPopView.h
//  TUIVoiceRoom
//
//  Created by 余莹 on 2023/6/13.
//
#import <UIKit/UIKit.h>
#import "VoiceOcFileUse_Header.h"
#import "VoiceBasePopView.h"

NS_ASSUME_NONNULL_BEGIN

 
typedef enum : NSUInteger {
    Now_Share_Type_Web = 0,
    Now_Share_Type_FreeperApp,
    Now_Share_Type_Group,
} Now_Share_Type;

//#define kShareStr_Open_Freeper_Des  @"在Freeper，记录美好生活，来和我一起支持Ta吧。复制下方链接，打开【Freeper】，直接观看直播！"//不能用 已经写入语言文件做siwft类型的获取文本
//static let kShareStr_Open_Freeper_Des = voiceRoomLocalize("在Freeper，记录美好生活，来和我一起支持Ta吧。复制下方链接，打开【Freeper】，直接观看直播！)
                                                          
                                                          
#define kShareStr_Open_Freeper_Io   @"https://freeper.io"
#define kShareStr_ActivityId_Prex   @"?actid="



@protocol ShareBottomPopViewDelegate <NSObject>

- (void)touchShareType:(Now_Share_Type)shareType;

@end



@interface TopImgBottomTextCollectionCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *topImg;
@property (nonatomic,strong) UILabel *bottomL;

@end


@interface ShareBottomPopView : VoiceBasePopView
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,weak) id <ShareBottomPopViewDelegate>shareBottomPopViewDelegate;
@property (nonatomic,strong) NSString *groupFaceUrlStr;
@property (nonatomic,strong) NSString *thisActivityIdStr;//活动id
@property (nonatomic, strong) NSString *rec_passWordStr;//私密直播时 增加的密码数据
@property (nonatomic, strong) NSDictionary *otherDic;//0908增加的数据

@end

 

NS_ASSUME_NONNULL_END
