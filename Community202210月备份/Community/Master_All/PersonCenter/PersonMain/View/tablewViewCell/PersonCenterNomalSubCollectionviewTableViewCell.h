//
//  PersonCenterNomalSubCollectionviewTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/1/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    PersoncenterSubCollectionviewCell_Type_TopCell,
    PersoncenterSubCollectionviewCell_Type_Nomal,
    PersoncenterSubCollectionviewCell_Type_Money,
    PersoncenterSubCollectionviewCell_Type_House,
    PersoncenterSubCollectionviewCell_Type_MoreRrecommend,
} PersoncenterSubCollectionviewCell_Type;

@protocol PersonCenterNomalSubCollectionviewTableViewCellDelegate <NSObject>
- (void)personVcNomalSubCollectionViewCellTouchUpItemWithIndex:(NSInteger)index;
- (void)personVcNomalSubCollectionViewMoneyCellTouchUpItemWithIndex:(NSInteger)index;
- (void)personVcNomalSubCollectionViewHouseCellTouchUpItemWithIndex:(NSInteger)index;
- (void)personVcNomalSubCollectionViewMoreRecommendCellTouchUpItemWithIndex:(NSInteger)index;
@end

@interface PersonCenterNomalSubCollectionviewTableViewCell : UITableViewCell <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,assign) PersoncenterSubCollectionviewCell_Type selfSubCellType;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
@property (nonatomic,strong) NSMutableArray *imgNameDataSourceArr;
@property (nonatomic,strong) NSMutableArray *showUseModelArr;//PersonCenterUseShowModel 用来展示的自定model

- (void)showInitWithMoneyType:(PersoncenterSubCollectionviewCell_Type)type andTopTitleArr:(NSMutableArray *)topTitleArr andBottomTitleArr:(NSMutableArray *)bottomTitleArr  andMoneyCenterNumArr:(NSMutableArray *)centerNumArr;//钱包cell的
- (void)showInitWithType:(PersoncenterSubCollectionviewCell_Type)type andTitleArr:(NSMutableArray *)dataSourceArr imgArr:(NSMutableArray *)imgNameDataSourceArr;
- (void)showInitWithType:(PersoncenterSubCollectionviewCell_Type)type andShowUseModeArr:(NSMutableArray *)shwoUseModeArr;

@property (nonatomic,weak) id <PersonCenterNomalSubCollectionviewTableViewCellDelegate> nomalAndMoneyCellDelegate;
@end

NS_ASSUME_NONNULL_END
