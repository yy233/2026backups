//
//  HouseRepairOldInputLookDetailVoiceTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/3/7.
//

#import "HouseRepairOldInputLookDetailVoiceTableViewCell.h"

@implementation HouseRepairOldInputLookDetailVoiceTableViewCell

- (void)fillVoiceLengthWithInt:(NSInteger)voiceLength{
    
    if (voiceLength <=0 ) {//隐藏
        self.contentView.hidden = YES;

    }else{//显示并且赋值
        self.contentView.hidden = NO;
//        self
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.topBtn];
        [self setUI];
    }
    return  self;
}

- (void)setUI{
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imgView.superview).offset(5);//y-5 == t-10
        make.centerX.equalTo(_imgView.superview);
        make.width.equalTo(_imgView.superview).offset(-26*2);
        make.height.offset(40);
    }];
    [_topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_imgView);
    }];
    
    //
    self.topBtn.backgroundColor = [UIColor blueColor];
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imgView;
}
- (UIButton *)topBtn{
    if (!_topBtn) {
        _topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topBtn addTarget:self action:@selector(touchVoiceAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topBtn;
}
- (void)touchVoiceAction{
    if (isNotNil(self.touchVoiceBlock)) {//帧动画
        self.touchVoiceBlock();
    }
}
@end
