//
//  LiveRoomOCInfo.h
//  AFNetworking
//
//  Created by 余莹 on 2023/7/8.
//

#import <Foundation/Foundation.h>
#import "LiveRoomOCInfo.h"
#import <Masonry/Masonry.h>

#define podUse_rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

/** 屏幕宽高*/

#define Screen_W             [UIScreen mainScreen].bounds.size.width
#define Screen_H             [UIScreen mainScreen].bounds.size.height
/////////////////////////////////////////////////////////////////////////////////
#define Screen_Width        [UIScreen mainScreen].bounds.size.width
#define Screen_Height       [UIScreen mainScreen].bounds.size.height
//#define Is_Iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//#define Is_IPhoneX (Screen_Width >=375.0f && Screen_Height >=812.0f && Is_Iphone)
#define Is_IPhoneXX (Screen_Width >=375.0f && Screen_Height >=812.0f)
#define KNavBarHeight        (Is_IPhoneXX ? (88.0):(64.0))          /** 导航栏高度 */
#define kStatusBar_Height    (Is_IPhoneXX ? (44.0):(20.0))          /** 状态栏高度 */
#define kTabBar_Height       (Is_IPhoneXX ? (49.0 + 34.0):(49.0))   /** 标签栏高度 */
#define kBottom_SafeHeight   (Is_IPhoneXX ? (34.0):(0))             /** 底部横条高度 */
#define kRGBA(r, g, b, a)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define kRGB(r, g, b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.f]
#define kkScale390(x) (x * (UIScreen.mainScreen.bounds.size.width / 390.0))



//清空弹幕
#define Notice_ClearnDanMu @"ClearnDanMu"
//分享功能
#define kShareStr_Open_Freeper_NSLocalStrKey  @"在Freeper，记录美好生活，来和我一起支持Ta吧。复制下方链接，打开【Freeper】，直接观看直播！"
#define kShareStr_Open_Freeper_Io   @"https://freeper.io"
#define kShareStr_ActivityId_Prex   @"?actid="
#define kShareStr_Open_Freeper_NSLocalStrKey_PassStr   @"直播邀请，房间密码"
 
typedef enum : NSUInteger {
    Botom_Tool_Type_GuanLiChengYuan = 0,//管理成员
    Botom_Tool_Type_JinYin =        1,//静音
    Botom_Tool_Type_DanMuQingKong = 2,//弹幕清空
    Botom_Tool_Type_ShangMai =      3,//观众上麦
    Botom_Tool_Type_XiaMai =        4,//观众下麦
    Botom_Tool_Type_FenXiang =      5,//分享
    Botom_Tool_Type_GuanBi =        9,//关闭当前直播
    Botom_Tool_Type_HidenSelfPopView =    999,//关闭当前popview
} Botom_Tool_Type;


NS_ASSUME_NONNULL_BEGIN

@interface LiveRoomOCInfo : NSObject
//@property (nonatomic,strong) ChatPopView *chatPOpView
@end

#pragma mark === 底部按钮弹出框

@protocol BottomUsePopViewDelegate <NSObject>

- (void)touchCellWithBotomToolType:(Botom_Tool_Type)type;
@end


@interface BottomUsePopView : UIView
@property (nonatomic,assign) BOOL isAudienceType;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) NSArray *imgArr;
@property (nonatomic,strong) NSArray *touchDelegaTypeNumArr;
@property (nonatomic,strong) UIView *blackBackView;
@property (nonatomic,strong) UIButton *hidenPopViewBtn;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,weak) id <BottomUsePopViewDelegate> delegate;
@end

//subcell
static NSString *kBottomToolPopViewSubCell_I = @"BottomToolPopViewSubCell";
@interface BottomToolPopViewSubCell : UICollectionViewCell
@property (nonatomic,strong) UILabel *bottomL;
@property (nonatomic,strong) UIImageView *iconImgv;
@end

#pragma mark === 管理员popview

@protocol AdmainManagerPopViewDelegate <NSObject>
- (void)touchCellWithHidenAdmangerPopView;
//- (void)admangerPopViewTouchCell;//暂时无点击相关动作 先保存显示即可
@end

static NSString *kAdmainManagerPopViewSubTableViewCelll_I = @"AdmainManagerPopViewSubTableViewCell";
@interface AdmainManagerPopViewSubTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *nameStrLabel;
@property (nonatomic,strong) UIImageView *headerImgv;
@end


@interface AdmainManagerPopViewSubHeaderView : UIView
@property (nonatomic,strong) UILabel *popViewTitleL;
@property (nonatomic,strong) UIButton *onLineTypeBtn;
@property (nonatomic,strong) UIButton *nomalTypeBtn;
@property (nonatomic,assign) BOOL isNomalTypeListShow;
@property (nonatomic,copy)  void(^showListTypeChangeBlock)(void);


@end

@interface AdmainManagerPopView : UIView
@property (nonatomic,strong) UIView *blackBackView;
@property (nonatomic,strong) UIButton *hidenPopViewBtn;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) AdmainManagerPopViewSubHeaderView *headerView;
@property (nonatomic,weak) id <AdmainManagerPopViewDelegate> delegate;

@end



NS_ASSUME_NONNULL_END
