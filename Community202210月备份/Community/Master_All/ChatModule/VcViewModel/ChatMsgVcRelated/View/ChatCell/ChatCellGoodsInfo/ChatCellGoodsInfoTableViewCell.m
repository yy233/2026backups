//
//  ChatCellGoodsInfoTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/6/10.
//

#import "ChatCellGoodsInfoTableViewCell.h"
#import "ChatVcSubCellHeader.h"

@implementation ChatCellGoodsInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillGoodsCellWithDateStr:(NSString *)dateStr withfillGoodsInfo:(id)goodsInfo{
    //时间
   NSString *timeS = [TextShowWithModelStr textShowWithModelStr:dateStr];
   self.dateL.text = [ToolOfTimeChangeFormat getDataStrWithStr:timeS];
    
    
    self.imgV.image = Main_PlaceholderImg_WeqH;
    self.titleL.text = @"goodsInfogoodsInfogoodsInfogoodsInfogoodsInfo999";
    self.moneyL.text = [NSString  stringWithFormat:@"¥%0.2f",68.89];
    [self.goodsStuasBtn newAnBtnWithTextStr:@"明显使用痕迹"];
    CGFloat goodsStuasBtn_H = [Tool getTextWidthWhenOneLineWithTextStr:@"明显使用痕迹" withFont:[UIFont systemFontOfSize:14.0]];
    if (goodsStuasBtn_H > 0) {//有状态数据
        [_goodsStuasBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(goodsStuasBtn_H+10);
        }];
    }
  
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    if (self) {
        [self setBaseCellTypeLeftOrRightOrCenter:ChatThisCellShowLeftRightSystemOtherType_SystemCenter];
        [self.backView addSubview:self.centerMainBackView];
        [self.centerMainBackView addSubview:self.imgV];
        [self.centerMainBackView addSubview:self.titleL];
        [self.centerMainBackView addSubview:self.goodsStuasBtn];
        [self.centerMainBackView addSubview:self.moneyL];
        [self setGoodsInfoCellUI];
      
    }
    return self;
}
- (void)setGoodsInfoCellUI{
    WEAKSELF
    [_centerMainBackView mas_makeConstraints:^(MASConstraintMaker *make) {//纵向有3个约束用来确定本Cell高度
        make.width.centerX.equalTo(_centerMainBackView.superview);
        make.top.equalTo(weakSelf.dateL.mas_bottom).offset(10.0);
        make.bottom.equalTo(_centerMainBackView.superview).offset(-10);
        make.height.offset(kChatCellGoodsInfoTableViewCell_Height);
    }];
    
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgV.superview).offset(12);
        make.bottom.equalTo(_imgV.superview).offset(-12);
        make.left.equalTo(_imgV.superview).offset(12);
        make.width.equalTo(_imgV.mas_height).offset(0);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgV);
        make.left.equalTo(_imgV.mas_right).offset(15);
        make.right.equalTo(_titleL.superview).offset(-16);
    }];
    [_goodsStuasBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_bottom).offset(5);
        make.left.equalTo(_titleL);
        make.height.offset(24);
        make.width.offset(0);
        
    }];
    [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleL);
        make.height.offset(30);
        make.top.equalTo(_goodsStuasBtn.mas_bottom).offset(5);
    }];
    
}
#pragma mark ===
- (UIView *)centerMainBackView{
    if (!_centerMainBackView) {
        _centerMainBackView = [[UIView alloc]init];
        _centerMainBackView.layer.cornerRadius = 10.0;
        _centerMainBackView.clipsToBounds = YES;
        _centerMainBackView.backgroundColor = [UIColor whiteColor];
    }
    return _centerMainBackView;
}

- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imgV;
}

- (UIButton *)goodsStuasBtn{
    if (!_goodsStuasBtn) {
        _goodsStuasBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goodsStuasBtn newAnBtnWithFont: [UIFont systemFontOfSize:11]];
        [_goodsStuasBtn newAnBtnWithTextColor:Y_ColorWith16FromRGB(0xFF8319)];
        [_goodsStuasBtn newAnBtnWithLayerCorNerNum:5 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_goodsStuasBtn newAnBtnWithBackColor: [Y_ColorWith16FromRGB(0xFF8319) colorWithAlphaComponent:0.2]];
    }
    return _goodsStuasBtn;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.numberOfLines = 3;
        _titleL.font = [UIFont boldSystemFontOfSize:14.0];
        _titleL.textColor = Y_ColorWith16FromRGB(0x2B2C2F);
    }
    return _titleL;
}

- (UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.font = [UIFont boldSystemFontOfSize:14.0];
        _moneyL.textColor = Y_ColorWith16FromRGB(0xFF3A3A);
    }
    return _moneyL;
}

@end
