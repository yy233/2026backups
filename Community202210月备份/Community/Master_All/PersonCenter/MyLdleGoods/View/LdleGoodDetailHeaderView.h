//
//  LdleGoodDetailHeaderView.h
//  Community
//
//  Created by 余莹 on 2022/6/11.
//

#import <UIKit/UIKit.h>
#import "LdleGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LdleGoodDetailHeaderView : UIView
@property (nonatomic,strong) UIView *centerMainBackView;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *moneyL;
@property (nonatomic,strong) UIButton *goodsStuasBtn;
@property (nonatomic,strong) UIButton *forwardingBtn;
@property (nonatomic,strong) UILabel *readCountL;

- (void)fillDetailInfoWithModel:(LdleGoodsModel *)model;

@end

NS_ASSUME_NONNULL_END
