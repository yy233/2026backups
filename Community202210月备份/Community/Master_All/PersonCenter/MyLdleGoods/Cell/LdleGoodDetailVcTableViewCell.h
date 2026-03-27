//
//  LdleGoodDetailVcTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/6/11.
//

#import "BaseTableViewCell.h"
#import "LdleGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *LdleGoodDetailVcTableViewCell_I   = @"LdleGoodDetailVcTableViewCell";
static NSString *LdleGoodDetailVcTitleTableViewCell_I   = @"LdleGoodDetailVcTitleTableViewCell";
static NSString *LdleGoodDetailVcContentTextTableViewCell_I   = @"LdleGoodDetailVcContentTextTableViewCell";
static NSString *LdleGoodDetailVcImgTableViewCell_I   = @"LdleGoodDetailVcImgTableViewCell";
static NSString *LdleGoodDetailVcMp4TableViewCell_I   = @"LdleGoodDetailVcMp4TableViewCell";



typedef void(^TouchJuBaoBtnBlock)(void);
@interface LdleGoodDetailVcTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIButton *vBtn;
@property (nonatomic,strong) UIButton *juBaoBtn;
@property (nonatomic,strong) TouchJuBaoBtnBlock touchJuBaoBtnBlock;

- (void)fillDetailInfoWithModel:(LdleGoodsModel*)model; 

@end

@interface LdleGoodDetailVcTitleTableViewCell : UITableViewCell
@property (nonatomic,strong) UIView *leftV;
@property (nonatomic,strong) UILabel *titleL;
@end

@interface LdleGoodDetailVcContentTextTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *contentL;
- (void)fillDetailInfoWithModel:(LdleGoodsModel *)model;
@end

@interface LdleGoodDetailVcImgTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *imgV;
- (void)fillDetailInfoWithImgStr:(NSString*)imgStr;
@end




typedef void(^TouchMp4CenterIsOpenTypeBlock)(BOOL isOpenMp4);

@interface LdleGoodDetailVcMp4TableViewCell : UITableViewCell
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIImageView *backImgV;
@property (nonatomic,strong) UIButton *centerBtn;
@property (nonatomic,copy) TouchMp4CenterIsOpenTypeBlock touchMp4CenterIsOpenTypeBlock;
- (void)fillIsHaveMp4Bool:(BOOL)isHave;
- (void)fillDetailInfoWithModel:(LdleGoodsModel*)model;
@end

NS_ASSUME_NONNULL_END
