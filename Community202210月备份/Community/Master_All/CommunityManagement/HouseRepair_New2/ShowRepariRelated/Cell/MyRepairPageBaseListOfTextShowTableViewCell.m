//
//  MyRepairPageBaseListOfTextShowTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/4/11.
//

#import "MyRepairPageBaseListOfTextShowTableViewCell.h"
@interface MyRepairPageBaseListOfTextShowTableViewCell ()


@end

@implementation MyRepairPageBaseListOfTextShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillDataWithModel:(MyRepairPageListUseModel *)model{
 
 
}
 
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
       // self.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        WEAKSELF
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.backView.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        }];
     
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.textL];
        [self setTextSelfBaseUI];
  
    }
    return  self;
}
 
- (void)setTextSelfBaseUI{
    WEAKSELF
    
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_titleL.superview);
        make.left.equalTo(_titleL.superview.mas_left).offset(10);
    }];
    [_textL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_textL.superview);
        make.left.equalTo(_titleL.mas_right).offset(5);
        make.right.lessThanOrEqualTo(_textL.superview.mas_right).offset(-10);
    }];
}
#pragma mark ===
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = [UIFont systemFontOfSize:12.0];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.numberOfLines = 1;
    }
    return _titleL;
}
- (UILabel *)textL{
 
    if (!_textL) {
        _textL = [[UILabel alloc]init];
        _textL.font = [UIFont systemFontOfSize:12.0];
        _textL.textColor = [ThemeManager shareManager].mainTextColor;
        _textL.numberOfLines = 1;
    }
    return _textL;
}

@end
