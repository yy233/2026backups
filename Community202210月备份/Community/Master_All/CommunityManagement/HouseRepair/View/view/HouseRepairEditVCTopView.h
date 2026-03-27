//
//  HouseRepairEditVCTopView.h
//  Community
//
//  Created by 余莹 on 2020/12/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HouseRepairEditVCTopViewDelegate <NSObject>
- (void)touchUpToChooseHousel;
- (void)changRepairType:(Repair_Type_PersonalOrPublic)type;
@end
@interface HouseRepairEditVCTopView : UIView
@property (nonatomic,strong) HouseRepairEditModel *model;
@property (nonatomic,strong) NSMutableArray *typeArr; //collectionView的数据源
@property (nonatomic,strong) NSMutableArray *arrOfTypeSelected;//type点击状态和最后OKbtn获取数据时用
@property (nonatomic,weak) id<HouseRepairEditVCTopViewDelegate> delegate;
- (void)setAddressShowStr:(NSString *)addressStr;
//个人报修 公共报修 改UI
- (void)changeRepairTypePersonalWithChangUI;
- (void)changeRepairTypePublicWithChangUI;
@end

NS_ASSUME_NONNULL_END
