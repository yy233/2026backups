//
//  ChatCellGoodsInfoTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/6/10.
//

#import "ChatVcSubBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString *ChatCellGoodsInfoTableViewCell_I   = @"ChatCellGoodsInfoTableViewCell";

@interface ChatCellGoodsInfoTableViewCell : ChatVcSubBaseTableViewCell
@property (nonatomic,strong) UIView *centerMainBackView;
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIButton *goodsStuasBtn;
@property (nonatomic,strong) UILabel *moneyL;

- (void)fillGoodsCellWithDateStr:(NSString *)dateStr withfillGoodsInfo:(id)goodsInfo;
@end

NS_ASSUME_NONNULL_END
