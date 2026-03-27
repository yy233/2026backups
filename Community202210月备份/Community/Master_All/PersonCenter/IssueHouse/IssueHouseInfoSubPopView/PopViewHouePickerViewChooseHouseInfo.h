//
//  PopViewHouePickerViewChooseHouseInfo.h
//  Community
//
//  Created by 余莹 on 2021/1/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    PopviewChooseHouseInfo_ChooseType_doorModel,//户型
    PopviewChooseHouseInfo_ChooseType_toward,//朝向
    PopviewChooseHouseInfo_ChooseType_floor,//楼层
} PopviewChooseHouseInfo_ChooseType;

@protocol PopViewHouePickerViewChooseHouseInfoDelegate <NSObject>
- (void)okActionWithHouseInfoGetStrArr:(NSMutableArray*)showStrArr withInfoGetCodeArr:(NSMutableArray *)notShowCodeArr withGetSaveRowNumArr:(NSMutableArray *)saveRowNunArr;
@end
@interface PopViewHouePickerViewChooseHouseInfo : BasePopView
@property (nonatomic,assign) PopviewChooseHouseInfo_ChooseType chooseType;
- (void)showInView:(UIView *)supview withHouseInfoStrArr:(NSMutableArray*)showStrArr andSaveAllRowNumArr:(NSMutableArray *)allRowNumArr; 
@property (nonatomic,weak) id <PopViewHouePickerViewChooseHouseInfoDelegate> houseInfoDelegate;
@end

NS_ASSUME_NONNULL_END
