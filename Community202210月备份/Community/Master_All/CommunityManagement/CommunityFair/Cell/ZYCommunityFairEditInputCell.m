//
//  ZYCommunityFairEditInputCell.m
//  Community
//
//  Created by ZY on 2021/8/7.
//

#import "ZYCommunityFairEditInputCell.h"
#import <objc/runtime.h>
#import "UITextView+YLTextView.h"

@interface ZYCommunityFairEditInputCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel4;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel5;

@property (weak, nonatomic) IBOutlet UILabel *discussLabel;

@property (weak, nonatomic) IBOutlet UIView *subContentView;

@property (weak, nonatomic) IBOutlet UIView *nameView;

@property (weak, nonatomic) IBOutlet UIView *priceView;

@property (weak, nonatomic) IBOutlet UIView *telView;

@end

@implementation ZYCommunityFairEditInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel1.textColor = [ ZYThemeManager shareManager].titleThemeColor;
    self.titleLabel2.textColor = [ ZYThemeManager shareManager].titleThemeColor;
    self.titleLabel3.textColor = [ ZYThemeManager shareManager].titleThemeColor;
    self.titleLabel4.textColor = [ ZYThemeManager shareManager].titleThemeColor;
    self.titleLabel5.textColor = [ ZYThemeManager shareManager].titleThemeColor;
    
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = [ZYThemeManager shareManager].borderThemeColor.CGColor;
    self.nameView.layer.borderWidth = 0.5;
    self.nameView.layer.borderColor = [ZYThemeManager shareManager].borderThemeColor.CGColor;
    self.priceView.layer.borderWidth = 0.5;
    self.priceView.layer.borderColor = [ZYThemeManager shareManager].borderThemeColor.CGColor;
    self.telView.layer.borderWidth = 0.5;
    self.telView.layer.borderColor = [ZYThemeManager shareManager].borderThemeColor.CGColor;
    
    self.textView.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.textView.limitLength = @300;
    self.textView.placeholdColor = [ZYThemeManager shareManager].placeholderThemeColor;
    self.textView.placeholdFont = [UIFont systemFontOfSize:14];
    self.textView.wordCountLabel.textColor = [ZYThemeManager shareManager].placeholderThemeColor;
    
    self.nameTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
    Ivar ivarN = class_getInstanceVariable([self.nameTF class], "_placeholderLabel");
    id placeholderLabelN = object_getIvar(self.nameTF, ivarN);
    [placeholderLabelN performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
    
    self.priceTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
    Ivar ivarP = class_getInstanceVariable([self.priceTF class], "_placeholderLabel");
    id placeholderLabelP = object_getIvar(self.priceTF, ivarP);
    [placeholderLabelP performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
    
    self.telTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
    Ivar ivarT = class_getInstanceVariable([self.telTF class], "_placeholderLabel");
    id placeholderLabelT = object_getIvar(self.telTF, ivarT);
    [placeholderLabelT performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
    
    self.discussLabel.textColor = [ZYThemeManager shareManager].placeholderThemeColor;
    self.discussButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    
    [self.subContentView addSubview:self.textTagCollectionView];
    [_textTagCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_textTagCollectionView.superview);
    }];
}

// 设置数据model
- (void)setModel:(ZYCommunityFairMarketModel *)model {
    _model = model;
    
    self.textView.text = _model.goodsExplain;
    self.textView.placeholder = @"简要说明物品...";
    self.nameTF.text = _model.goodsName;
    self.telTF.text = _model.phone;
    if (_model.negotiable == 0) {
        self.priceTF.userInteractionEnabled = YES;
        self.priceTF.text = _model.price;
        self.discussButton.selected = NO;
    }else {
        self.priceTF.userInteractionEnabled = NO;
        self.priceTF.text = @"";
        self.discussButton.selected = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 懒加载
- (TTGTextTagCollectionView *)textTagCollectionView {
    if (!_textTagCollectionView) {
        _textTagCollectionView = [[TTGTextTagCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 32, 26)];
        _textTagCollectionView.scrollDirection = TTGTagCollectionScrollDirectionHorizontal;
        _textTagCollectionView.showsVerticalScrollIndicator = NO;
        _textTagCollectionView.showsHorizontalScrollIndicator = NO;
        _textTagCollectionView.horizontalSpacing = 10;
        _textTagCollectionView.verticalSpacing = 10;
    }
    
    return _textTagCollectionView;
}

@end
