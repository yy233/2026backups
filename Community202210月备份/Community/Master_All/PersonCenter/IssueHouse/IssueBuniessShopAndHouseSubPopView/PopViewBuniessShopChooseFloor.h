//
//  PopViewBuniessShopChooseFloor.h
//  Community
//
//  Created by 余莹 on 2021/1/20.
// 滚轮 —— 商铺的楼层

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    PopView_Floor_Type_OnlyOneFloor,//单层
    PopView_Floor_Type_MoreFloor,//多层
    PopView_Floor_Type_DuLiFloor,//独栋
} PopView_Floor_Type;

@protocol PopViewBuniessShopChooseFloorDelegate <NSObject>
- (void)popViewChooseBuniessShopFloorWithType:(PopView_Floor_Type)type andFloorStr:(NSString *)str;
@end

@interface PopViewBuniessShopChooseFloor : BasePopView
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *concentL;
@property (nonatomic,strong) UILabel *centerTipLabel;
@property (nonatomic,strong) UIView *typeBtnBackView;
@property (nonatomic,strong) UIPickerView *pickView;

@property (nonatomic,weak) id <PopViewBuniessShopChooseFloorDelegate> floorDelegate;
@end

NS_ASSUME_NONNULL_END
