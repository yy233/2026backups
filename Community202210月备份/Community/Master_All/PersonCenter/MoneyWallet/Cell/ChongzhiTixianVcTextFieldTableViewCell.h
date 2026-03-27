//
//  ChongzhiTixianVcTextFieldTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/2/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    TiXianAndChongZhi_Type_tixian,
    TiXianAndChongZhi_Type_chognzhi,
} TiXianAndChongZhi_Type;

@interface ChongzhiTixianVcTextFieldTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UILabel *leftL;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIView *lineV;
@property (nonatomic,strong) UILabel *bottomTipL;
@property (nonatomic,strong) UIButton *allTixianBtn;
@end

NS_ASSUME_NONNULL_END
