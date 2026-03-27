//
//  MyHouseAddSubPersonTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/8/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyHouseAddSubPersonTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UILabel *titleL;
@end


//
@protocol MyHouseAddSubPersonTableViewCellTextFeildDelegate <NSObject>
- (void)cellTextFieldWithTag:(NSInteger)tag andTextFieldStr:(NSString *)textStr;
@end

@interface MyHouseAddSubPersonTableViewCellTextFeild : MyHouseAddSubPersonTableViewCell
@property (nonatomic,strong) UITextField *textField;
- (void)setTextShowBeginLeft;
- (void)setTextFiePstr:(NSString *)pStr;
@property (nonatomic,weak) id <MyHouseAddSubPersonTableViewCellTextFeildDelegate> delegate;
@end

//
typedef void(^FeildHaveChooseBtnBlock)(void);  

@interface MyHouseAddSubPersonTableViewCellTextFeildHaveChooseBtn : MyHouseAddSubPersonTableViewCellTextFeild
@property (nonatomic,strong) UIButton *viewTopChooseBtn;
@property (nonatomic,strong) UIImageView *rightImgV;
@property (nonatomic,copy) FeildHaveChooseBtnBlock touchBtnBlock;
@end

//
@interface BaseShowRedRightTextTableViewCell : MyHouseAddSubPersonTableViewCellTextFeild
@end

NS_ASSUME_NONNULL_END
