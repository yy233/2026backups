//
//  IssuLastAddressCellSubBasePopView.h
//  Community
//
//  Created by 余莹 on 2021/1/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    IssuLastAddressCellSubBasePopView_Type_Community,
    IssuLastAddressCellSubBasePopView_Type_Address,
    IssShopBuniessCommmunityAddressCellSubBasePopView_Type_CommunityAddress,
    MyHouseListChangeShowHouseList_Type_House
} IssuLastAddressCellSubBasePopView_Type;

@protocol IssuLastAddressCellSubBasePopViewDelegate <NSObject>
- (void)okBtnWithChooseListCellWithPopType:(IssuLastAddressCellSubBasePopView_Type)type withCellData:(NSDictionary *)dic;
@end

@interface IssuLastAddressCellSubBasePopView : BasePopView
@property (nonatomic,assign) IssuLastAddressCellSubBasePopView_Type selfType;
@property (nonatomic,strong) NSMutableArray *showDataArr;
@property (nonatomic,strong) NSMutableArray *chooseTypeSaveArr;
//____
- (void)showInViewWithPopType:(IssuLastAddressCellSubBasePopView_Type)type
                withListArray:(NSMutableArray *)array;
@property (nonatomic,weak) id <IssuLastAddressCellSubBasePopViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
