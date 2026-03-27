//
//  IssueBaseSubBlueBtnsViewTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/1/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    Cell_type_BlueBtn_Nil,
    Cell_type_BlueBtn_shopType,//商铺类型
    Cell_type_BlueBtn_shopIndustry,//商铺行业
    Cell_type_BlueBtn_facility,//商铺配套设施";
    Cell_type_BlueBtn_people,//商铺客流人群";
//    Cell_type_BlueBtn_HouseAllType,//房屋的所有类型
    Cell_type_BlueBtn_HouseAllType6,
    Cell_type_BlueBtn_HouseAllType7,
    Cell_type_BlueBtn_HouseAllType8,
    Cell_type_BlueBtn_HouseAllType10,
    Cell_type_BlueBtn_HouseAllType11,
    Cell_type_BlueBtn_HouseAllType12,
    Cell_type_BlueBtn_HouseAllType13,
    Cell_type_BlueBtn_HouseAllType14,//租房日期 单选
    Cell_type_BlueBtn_HouseAllType16,
    Cell_type_BlueBtn_HouseAllType17,
    Cell_type_BlueBtn_HouseAllType18,//装修 单选
    Cell_type_BlueBtn_HouseAllType19,
    Cell_type_BlueBtn_HouseAllType20,//性别单选
    Cell_type_BlueBtn_HouseAllType21,
    Cell_type_BlueBtn_HouseAllType22,
    Cell_type_BlueBtn_HouseAllType23,
    Cell_type_BlueBtn_HouseAllType24
} Cell_type_BlueBtn;  //1015新改动

 
@protocol IssueBaseSubBlueBtnsViewTableViewCellDelegate <NSObject>
//- (void)cellTouchSubBlueBtnWithIndex:(NSInteger)index andCellType:(Cell_type_BlueBtn)type;
- (void)cellTouchSubBlueBtnWithIndexArr:(NSMutableArray *)indexArr andCellType:(Cell_type_BlueBtn)type;
@end
@interface IssueBaseSubBlueBtnsViewTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *titelL;
@property (nonatomic,strong) UIView *subBtnsBackV;
- (void)showSubBtnWithDataSourceArr:(NSMutableArray *)subBtnDataSourceArr andCellType:(Cell_type_BlueBtn)type;
@property (nonatomic,weak) id <IssueBaseSubBlueBtnsViewTableViewCellDelegate> delegate;
//
- (void)cellShowBtnTypeWithSelectedIndexArr:(NSMutableArray *)selectedIndexArr;

@end

NS_ASSUME_NONNULL_END
