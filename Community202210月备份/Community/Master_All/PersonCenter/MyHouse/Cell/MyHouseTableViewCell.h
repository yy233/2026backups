//
//  MyHouseTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/8/3.
//

#import <UIKit/UIKit.h>
#import "MyHousePersonRelationModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^CellSunEditBtnBlock)();
typedef void(^CellSubChooseBtnSelectedBlock)(BOOL);


@interface MyHouseTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UIImageView *imgV;//头像
@property (nonatomic,strong) UILabel *examineStatusLabel;//审核状态UI  |  examineStatus 0.同步中 1.成功 2.失败
@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UILabel *bottomL;
@property (nonatomic,strong) UILabel *typeInfoL;
@property (nonatomic,strong) UIButton *editBtn;
@property (nonatomic,strong) UIButton *chooseBtn;
@property (nonatomic,strong) UIImageView *rightArrowImgV;//家属cell的关怀模式下 有右箭头
@property (nonatomic,strong) UIImageView *guanHuaiMoShiIconImgv;//家属cell的关怀模式下 有小图标
//
- (void)cellEditBtnShowBool:(BOOL)editBtnShow;
- (void)changeCellIsWillDeletEditWithNowUserRelationNum:(NSInteger)nowUserRelationNum andNowManagerBool:(BOOL)isManagerBool;

@property (nonatomic,copy) CellSunEditBtnBlock editBtnBlock;
@property (nonatomic,copy) CellSubChooseBtnSelectedBlock chooseBtnSelectedBlock;

- (void)fillDataWithTopCellWithModel:(MyHousePersonRelationModel*)model;
- (void)fillDataWithPersonRelationCellWithModel:(MyHousePersonRelationSubMemberModel*)model;
- (void)chooseTypeSaveInfoWithHidedChooseBtn;
- (void)chooseTypeSaveInfoWithChooseBtnSelected:(BOOL)isselected;
 
@end



NS_ASSUME_NONNULL_END
