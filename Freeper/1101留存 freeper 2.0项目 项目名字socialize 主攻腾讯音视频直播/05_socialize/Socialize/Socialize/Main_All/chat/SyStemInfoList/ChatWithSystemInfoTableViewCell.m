//
//  ChatWithSystemInfoTableViewCell.m
//  Socialize
//
//  Created by 余莹 on 2023/8/11.
//

#import "ChatWithSystemInfoTableViewCell.h"

@implementation ChatWithSystemInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#define  kTheme_Type_Key   @"Theme_Type"
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.imgV];
        [self.contentView addSubview:self.nameL];
        [self.contentView addSubview:self.timeL];
        [self.contentView addSubview:self.contentL];
        [self.contentView addSubview:self.rightBottomBtn];
        [self setcelllUI];
        self.contentL.numberOfLines = 0;
        
        NSString *nowThemeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:kTheme_Type_Key];//Theme_Type #define  kTheme_Type_Key   @"Theme_Type"
        if([nowThemeStr isEqualToString: @"light"]){
            self.nameL.textColor = Color_51BlackColor;
            self.timeL.textColor = Color_153GrayColor;
            self.contentL.textColor = Color_51BlackColor;
        }else{
            self.nameL.textColor = [UIColor whiteColor];
            self.timeL.textColor = Color_153GrayColor;
            self.contentL.textColor = [UIColor whiteColor];
        }
    }
    return self;
}
- (void)setcelllUI{
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(40.0);
        make.left.equalTo(_imgV.superview).offset(10);
        make.top.equalTo(_imgV.superview).offset(10);
    }];
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgV.mas_right).offset(15);
        make.top.equalTo(_imgV);
        make.right.equalTo(_nameL.superview).offset(-20);
        make.height.offset(20);
    }];
    [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.right.equalTo(_nameL);
        make.bottom.equalTo(_imgV);
    }];
    [_rightBottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rightBottomBtn.superview).offset(-5);
        make.bottom.equalTo(_rightBottomBtn.superview);
        make.height.offset(20);
    }];
    [_contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgV);
        make.top.equalTo(_imgV.mas_bottom).offset(5);
        make.right.equalTo(_nameL);
        make.bottom.equalTo(_rightBottomBtn.mas_top);
    }];
  
}
- (UIImageView *)imgV{
    if(!_imgV){
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
        _imgV.layer.cornerRadius = 6;
        _imgV.layer.masksToBounds = YES;
    }
    return _imgV;
}
- (UILabel *)nameL{
    if(!_nameL){
        _nameL = [[UILabel alloc]init];
        _nameL.font = [UIFont boldSystemFontOfSize:18.0];
    }
    return _nameL;
}
- (UILabel *)timeL{
    if(!_timeL){
        _timeL = [[UILabel alloc]init];
        _timeL.font = [UIFont systemFontOfSize:14.0];
    }
    return _timeL;
}

- (UILabel *)contentL{
    if(!_contentL){
        _contentL = [[UILabel alloc]init];
        _contentL.font = [UIFont systemFontOfSize:16.0];
    }
    return _contentL;
}

- (UIButton *)rightBottomBtn{
    if(!_rightBottomBtn){
        _rightBottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBottomBtn newAnBtnWithTextStr:Y_LocaleTypeFile_NSLocalString(@"消息详情>")];
        [_rightBottomBtn newAnBtnWithTextColor: Color_Socialize_GreenColor];
        [_rightBottomBtn newAnBtnWithFont:[UIFont systemFontOfSize:16.0]];
    }
    return _rightBottomBtn;
}

@end
