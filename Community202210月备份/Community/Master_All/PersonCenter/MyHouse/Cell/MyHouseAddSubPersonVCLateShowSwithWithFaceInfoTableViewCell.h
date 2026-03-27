//
//  MyHouseAddSubPersonVCLateShowSwithWithFaceInfoTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *MyHouseAddSubPersonVCLateShowSwithWithFaceInfoTableViewCell_I = @"MyHouseAddSubPersonVCLateShowSwithWithFaceInfoTableViewCell";


typedef void(^CellTouchChooseImgBlock)(void);
typedef void(^CellTouchChooseonceAgainBtnBlock)(void);

@interface MyHouseAddSubPersonVCLateShowSwithWithFaceInfoTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIImageView *faceImgV;
@property (nonatomic,strong) UIButton *imgTopBtn;
@property (nonatomic,strong) UIButton *onceAgainBtn;
@property (nonatomic,copy) CellTouchChooseImgBlock touchChooseImgBlcok;
@property (nonatomic,copy) CellTouchChooseonceAgainBtnBlock touchChooseOnceAgainBtnBlock;


@end

NS_ASSUME_NONNULL_END
