//
//  ZYSmallShopGoodsSpellGroupDetailBottomView.m
//  Community
//
//  Created by ZY on 2022/3/4.
//

#import "ZYSmallShopGoodsSpellGroupDetailBottomView.h"

@interface ZYSmallShopGoodsSpellGroupDetailBottomView ()

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UIButton *chatButton;

@property (weak, nonatomic) IBOutlet UIButton *spellGroupButton;

@end

@implementation ZYSmallShopGoodsSpellGroupDetailBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.chatButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:1];
    [self.chatButton addTarget:self action:@selector(chatButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.spellGroupButton addTarget:self action:@selector(spellGroupButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

// 设置数据model
- (void)setModel:(ZYSmallShopGoodsSpellGroupDetailModel *)model {
    _model = model;
    
    if (_model.groupSpellPersonNumber == _model.personSpell) {
        self.numLabel.hidden = YES;
    }else {
        self.numLabel.hidden = NO;
        self.numLabel.text = [NSString stringWithFormat:@"%ld/%ld人已参加拼团", _model.personSpell, _model.groupSpellPersonNumber];
    }
    if (_model.isJoin) {
        [self.spellGroupButton setTitle:@"查看进度" forState:UIControlStateNormal];
    }else {
        [self.spellGroupButton setTitle:@"参与拼团" forState:UIControlStateNormal];
    }
}

#pragma mark - 处理点击事件
// 联系商家
- (void)chatButtonClicked {
    if ([self.delegate respondsToSelector:@selector(chatButtonEvent)]) {
        [self.delegate chatButtonEvent];
    }
}

// 参加拼团
- (void)spellGroupButtonClicked {
    if ([self.delegate respondsToSelector:@selector(spellGroupButtonEvent)]) {
        [self.delegate spellGroupButtonEvent];
    }
}

@end
