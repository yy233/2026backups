//
//  TopTypesChooseView.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/18.
//

#import <UIKit/UIKit.h>
#import "CigarBrandsUseModel.h"
NS_ASSUME_NONNULL_BEGIN

#define TopTypesChooseView_Tag   (500)

#pragma mark ===
static NSString * _Nullable TopTypesChooseViewCollectionViewCell_I = @"TopTypesChooseViewCollectionViewCell";
//横向滚动 多section 上下级刷新
@interface TopTypesChooseViewCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UILabel *titleLabel;
@end



#pragma mark ===
static NSString *ksectionTitileHeaderView_I = @"section_header";
static NSString *ksectionTitileFooterView_I = @"section_footer";
typedef void(^NewHeightChangeBlock)(CGFloat thisHeight);
typedef void(^HomeVcShowChangeBlock_anBansBlcok)(CigarBrandsUseModel *);;
typedef void(^HomeVcShowChangeBlock_oneBrandAnTypeBlcok)(BrandTypesModel *);;

@interface TopTypesChooseView : UIView <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSArray *mainSectionHeaderUseShowArr;//主要类型 点击位置
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,copy) NewHeightChangeBlock h_block;
@property (nonatomic,assign) BOOL isShowBool_brans;//展示和收起
@property (nonatomic,assign) BOOL isShowBool_Pos;//展示和收起
@property (nonatomic,copy) HomeVcShowChangeBlock_anBansBlcok anBansBlcok;
@property (nonatomic,copy) HomeVcShowChangeBlock_oneBrandAnTypeBlcok oneBrandAnTypeBlcok;
@property (nonatomic,strong) CigarBrandsUseModel *saveChooseBranModel;

 

@end

NS_ASSUME_NONNULL_END
