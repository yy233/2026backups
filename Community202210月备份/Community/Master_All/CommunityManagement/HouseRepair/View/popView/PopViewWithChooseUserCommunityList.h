//
//  PopViewWithChooseUserCommunityList.h
//  Community
//
//  Created by 余莹 on 2021/4/1.
//

#import <UIKit/UIKit.h>
//#import "IssuLastAddressCellSubBasePopView.h"  //和发布商铺 选择区域的view 类似
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    RepairHousesPopView_Type_Community,
    RepairHousesPopView_Type_House,
} RepairHousesPopView_Type;

@protocol PopViewWithChooseUserCommunityListDelegate <NSObject>
- (void)popViewChooseCommunityOrHouseListCellWithPopType:(RepairHousesPopView_Type)type withCellData:(NSDictionary *)dic;
@end

@interface PopViewWithChooseUserCommunityList : BasePopView
@property (nonatomic,assign) RepairHousesPopView_Type selfType;
@property (nonatomic,strong) NSMutableArray *showDataArr;
@property (nonatomic,strong) NSMutableArray *chooseTypeSaveArr;
//____
- (void)showInViewWithPopType:(RepairHousesPopView_Type)type
                withListArray:(NSMutableArray *)listArr;
@property (nonatomic,weak) id <PopViewWithChooseUserCommunityListDelegate> delegate;

@end
NS_ASSUME_NONNULL_END
