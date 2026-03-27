//
//  ZYSmallShopMainMenuCell.m
//  Community
//
//  Created by ZY on 2022/2/28.
//

#import "ZYSmallShopMainMenuCell.h"

@interface ZYSmallShopMainMenuCell ()

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;

//// 共享货柜
//@property (weak, nonatomic) IBOutlet UIView *sharedContainerView;
//
//@property (weak, nonatomic) IBOutlet UIImageView *sharedContainerImageView;
//
//@property (weak, nonatomic) IBOutlet UILabel *sharedContainerTitleLabel;
//
//@property (weak, nonatomic) IBOutlet UILabel *sharedContainerContentLabel;

// 特价商品
@property (weak, nonatomic) IBOutlet UIView *bargainShopView;

@property (weak, nonatomic) IBOutlet UIImageView *bargainShopImageView;

@property (weak, nonatomic) IBOutlet UILabel *bargainShopTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *bargainShopContentLabel;

// 便民服务
@property (weak, nonatomic) IBOutlet UIView *convenienceSerViceView;

@property (weak, nonatomic) IBOutlet UIImageView *convenienceSerViceImageView;

@property (weak, nonatomic) IBOutlet UILabel *convenienceSerViceTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *convenienceSerViceContentLabel;

@end

@implementation ZYSmallShopMainMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    [self.sharedContainerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sharedContainerViewTap)]];
    [self.convenienceSerViceView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(convenienceSerViceViewTap)]];
    [self.bargainShopView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bargainShopViewTap)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 设置数据model
- (void)setModel:(ZYSmallShopMainModel *)model {
    _model = model;
    
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:_model.value0] placeholderImage:[UIImage imageNamed:@"cc_toubu_piture"]];
    for (ZYSmallShopMainValue1Model *tempModel in _model.value1) {
        if (tempModel.moduleType == 1) {
            [self.bargainShopImageView sd_setImageWithURL:[NSURL URLWithString:tempModel.moduleImg] placeholderImage:[UIImage imageNamed:@"cc_tjsp01"]];
            self.bargainShopTitleLabel.text = tempModel.moduleTitle;
            self.bargainShopContentLabel.text = tempModel.modulePublicity;
        }else if (tempModel.moduleType == 2) {
            [self.convenienceSerViceImageView sd_setImageWithURL:[NSURL URLWithString:tempModel.moduleImg] placeholderImage:[UIImage imageNamed:@"cc_bmfw01"]];
            self.convenienceSerViceTitleLabel.text = tempModel.moduleTitle;
            self.convenienceSerViceContentLabel.text = tempModel.modulePublicity;
        }
//        else if (tempModel.moduleType == 3) {
//            [self.sharedContainerImageView sd_setImageWithURL:[NSURL URLWithString:tempModel.moduleImg] placeholderImage:[UIImage imageNamed:@"cc_container"]];
//            self.sharedContainerTitleLabel.text = tempModel.moduleTitle;
//            self.sharedContainerContentLabel.text = tempModel.modulePublicity;
//        }
    }
}

#pragma mark - 处理点击事件
//// 共享货柜
//- (void)sharedContainerViewTap {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(sharedContainerViewEvent)]) {
//        [self.delegate sharedContainerViewEvent];
//    }
//}

// 特价商品
- (void)bargainShopViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bargainShopViewEvent)]) {
        [self.delegate bargainShopViewEvent];
    }
}

// 便民服务
- (void)convenienceSerViceViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(convenienceSerViceViewEvent)]) {
        [self.delegate convenienceSerViceViewEvent];
    }
}

@end
