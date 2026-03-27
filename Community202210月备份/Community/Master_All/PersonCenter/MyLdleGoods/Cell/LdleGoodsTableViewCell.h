//
//  LdleGoodsTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/6/11.
//

#import "BaseTableViewCell.h"
#import "LdleGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *LdleGoodsTableViewCell_I   = @"LdleGoodsTableViewCell";

static NSString *LdleGoodsOfShowRedWeiGuiViewTableViewCell_I   = @"LdleGoodsOfShowRedWeiGuiViewTableViewCell";

static NSString *LdleGoodsBottomTwoBtnTableViewCell_I   = @"LdleGoodsBottomTwoBtnTableViewCell";

static NSString *LdleGoodsBottomTwoBtnOfNeedUpDataTableViewCell_I   = @"LdleGoodsBottomTwoBtnOfNeedUpDataTableViewCell";

//普通信息cell
@interface LdleGoodsTableViewCell : UITableViewCell
@property (nonatomic,strong) UIView *centerMainBackView;
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIButton *goodsStuasBtn;
@property (nonatomic,strong) UILabel *moneyL;
- (void)fillLdleGoodsInfoWithModel:(LdleGoodsModel *)model;
@end

//违规信息cell
@interface LdleGoodsOfShowRedWeiGuiViewTableViewCell : LdleGoodsTableViewCell
@property (nonatomic,strong) UILabel *weiGuiRedL;//违规view
@end

//普通编辑按钮
typedef void(^TouchCellSubBtnBlock)(BOOL isRightBtn);
@interface LdleGoodsBottomTwoBtnTableViewCell : UITableViewCell
@property (nonatomic,strong) UIButton *oneBtn;
@property (nonatomic,strong) UIButton *twoBtn;
@property (nonatomic,copy) TouchCellSubBtnBlock touchCellSubBtnBlock;
@end

//普通重新上架按钮
@interface LdleGoodsBottomTwoBtnOfNeedUpDataTableViewCell : LdleGoodsBottomTwoBtnTableViewCell

@end


NS_ASSUME_NONNULL_END
