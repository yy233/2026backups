//
//  PopViewBuniessShopChooseShopType.h
//  Community
//
//  Created by 余莹 on 2021/1/21.
//  滚轮 —— 商铺的类型和行业

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PopViewBuniessShopChooseShopPublishTypesDelegate <NSObject>
- (void)popViewChooseBuniessShopPublishTypeWithType:(BuniessShopOrHousePublish_Type)type andModel:(IssueBuniessShopPublishTypeModel *)model;
- (void)popViewChooseBuniessShopPublishTypeWithBedRoomTypeWithTouchIndex:(NSInteger)index withShowStr:(NSString *)showStr;
@end

@interface PopViewBuniessShopChooseShopPublishTypes : PopViewBuniessShopChooseFloor
@property (nonatomic,strong) NSMutableArray *typeDataSourceModelArr;
@property (nonatomic,assign) NSInteger nowChooseRowNum;
//
- (void)showInView:(UIView *)supview thePopViewBuniessShopPublishType:(BuniessShopOrHousePublish_Type)type WithArray:(NSMutableArray *)array;
@property (nonatomic,weak) id <PopViewBuniessShopChooseShopPublishTypesDelegate> publishTypesDelegate;

@end

NS_ASSUME_NONNULL_END
