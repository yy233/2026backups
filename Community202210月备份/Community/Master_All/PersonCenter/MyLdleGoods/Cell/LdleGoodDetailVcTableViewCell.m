//
//  LdleGoodDetailVcTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/6/11.
//

#import "LdleGoodDetailVcTableViewCell.h"

@implementation LdleGoodDetailVcTableViewCell

- (void)fillDetailInfoWithModel:(LdleGoodsModel *)model{
    //头像
    [self.imgV sd_setImageWithURL:[UrlWithString getURLWithStr:model.avatarUrl] placeholderImage:Main_OwnImg];
    self.titleL.text = [TextShowWithModelStr textShowWithModelStr:model.userName];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark ====
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
        self.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
        [self.contentView addSubview:self.imgV];
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.vBtn];
        [self.contentView addSubview:self.juBaoBtn];
        [self setUserInfoUI];
    }
    return self;
}
- (void)setUserInfoUI{
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgV.superview).offset(16);
        make.top.equalTo(_imgV.superview).offset(5);
        make.bottom.equalTo(_imgV.superview).offset(-5);
        make.height.width.offset(48.0);
    }];
    [_juBaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(45);
        make.height.offset(22);
        make.right.equalTo(_juBaoBtn.superview).offset(-16);
        make.centerY.equalTo(_imgV);
    }];
    
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imgV);
        make.left.equalTo(_imgV.mas_right).offset(10);
        make.height.offset(20);
        make.width.lessThanOrEqualTo(_titleL.superview).multipliedBy(0.5);
    }];
    [_vBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imgV);
        make.height.width.offset(20);
        make.left.equalTo(_titleL.mas_right).offset(10);
    }];
}

#pragma mark ==
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
        _imgV.layer.cornerRadius = 24.0;
        _imgV.layer.masksToBounds = YES;
    }
    return _imgV;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.numberOfLines = 1;
        _titleL.font = [UIFont boldSystemFontOfSize:14.0];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _titleL;
}
- (UIButton *)vBtn{
    if (!_vBtn) {
        _vBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_vBtn newAnBtnWithImg:[UIImage imageNamed:@"smrz_icon"]];
    }
    return _vBtn;
}
- (UIButton *)juBaoBtn{
    if (!_juBaoBtn) {
        _juBaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_juBaoBtn newAnBtnWithFont: [UIFont systemFontOfSize:13.0]];
        [_juBaoBtn newAnBtnWithTextColor: [ThemeManager shareManager].detailTextColor];
        [_juBaoBtn newAnBtnWithLayerCorNerNum:5 withLayerLineWidth:0.5 withLayerLineColor: [ThemeManager shareManager].detailTextColor];
        [_juBaoBtn newAnBtnWithTextStr:@"举报"];
        [_juBaoBtn addTarget:self action:@selector(juBaoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _juBaoBtn;
}
- (void)juBaoBtnAction{
    if (isNil(self.touchJuBaoBtnBlock)) {
        return;
    }
    self.touchJuBaoBtnBlock();
}

@end

#pragma mark ==== LdleGoodDetailVcTitleTableViewCell

@implementation LdleGoodDetailVcTitleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
        self.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
        [self.contentView addSubview:self.leftV];
        [self.contentView addSubview:self.titleL];
        [self setTitleUI];
    }
    return self;
}
- (void)setTitleUI{
    [_leftV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(2.0);
        make.height.offset(14.0);
        make.left.equalTo(_leftV.superview).offset(16);
        make.centerY.equalTo(_leftV.superview);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_leftV.superview);
        make.left.equalTo(_leftV.mas_right).offset(10);
        make.height.offset(30);
        make.top.bottom.equalTo(_titleL.superview);
    }];
}

- (UIView *)leftV{
    if (!_leftV) {
        _leftV = [[UIView alloc]init];
        _leftV.backgroundColor =  Y_ColorWith16FromRGB(0xFF3A3A);
    }
    return _leftV;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.numberOfLines = 1;
        _titleL.font = [UIFont boldSystemFontOfSize:15.0];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.text = @"商品详情";
    }
    return _titleL;
}
@end

#pragma mark ==== LdleGoodDetailVcContentTextTableViewCell

@implementation LdleGoodDetailVcContentTextTableViewCell

- (void)fillDetailInfoWithModel:(LdleGoodsModel *)model{
    NSString *contentTextStr = [TextShowWithModelStr textShowWithModelStr:model.goodsExplain];
    self.contentL.text = contentTextStr;
 
    CGFloat contentText_H = [Tool getTextHeightWhenHaveWidthFloatNum:(Screen_W-32) withTextStr:contentTextStr withFont:[UIFont systemFontOfSize:14.0]];
    if (contentText_H > 0) {//有文本数据
        [_contentL mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(contentText_H+10);
        }];
    }else{
        [_contentL mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0.1);
        }];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
        self.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
        [self.contentView addSubview:self.contentL];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentL.superview).offset(16);
        make.right.equalTo(_contentL.superview).offset(-16);
        make.top.equalTo(_contentL.superview).offset(0);
        make.bottom.equalTo(_contentL.superview).offset(0);
        make.height.offset(20);
    }];
}
- (UILabel *)contentL{
    if (!_contentL) {
        _contentL = [[UILabel alloc]init];
        _contentL.numberOfLines = 0;
        _contentL.font = [UIFont systemFontOfSize:14.0];
        _contentL.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _contentL;
}
@end

#pragma mark ==== LdleGoodDetailVcImgTableViewCell

@implementation LdleGoodDetailVcImgTableViewCell : UITableViewCell
- (void)fillDetailInfoWithModel:(LdleGoodsModel *)model{} //本方法在图片cell 不使用
//赋予当前section顺序的图片
- (void)fillDetailInfoWithImgStr:(NSString*)imgStr{
    NSLog(@"fillDetailInfoWithImgStr %@",imgStr);
    [self.imgV sd_setImageWithURL:[UrlWithString getURLWithStr:imgStr] placeholderImage:Main_PlaceholderImg_WeqH];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
        self.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
        [self.contentView addSubview:self.imgV];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgV.superview).offset(16);
        make.right.equalTo(_imgV.superview).offset(-16);
        make.top.equalTo(_imgV.superview).offset(5);
        make.bottom.equalTo(_imgV.superview).offset(-5);
        make.height.equalTo(_imgV.mas_width).multipliedBy(0.68);
    }];
}

- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
        _imgV.layer.cornerRadius = 10.0;
        _imgV.layer.masksToBounds = YES;
    }
    return _imgV;
}
@end

#pragma mark ==== LdleGoodDetailVcMp4TableViewCell

@implementation  LdleGoodDetailVcMp4TableViewCell : UITableViewCell
- (void)fillDetailInfoWithModel:(LdleGoodsModel*)model{
    
   NSString *mvU =  [TextShowWithModelStr textShowWithModelStr:model.mvUrl];
    if (mvU.length <= 0 ) {
        self.backImgV.backgroundColor = [UIColor clearColor];
    }else{
        //有视频 取视频
        self.backImgV.backgroundColor = [UIColor grayColor];

    }

    
}
- (void)fillIsHaveMp4Bool:(BOOL)isHave{
    if (!isHave) {//无视频数据 做隐藏
        [_backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backView.superview).offset(16);
            make.right.equalTo(_backView.superview).offset(-16);
            make.top.equalTo(_backView.superview).offset(0);
            make.bottom.equalTo(_backView.superview).offset(-0);
            make.height.offset(1);//不能用0.1 会自动走44的高度数据
        }];        
        self.backView.hidden = YES;

        
    }else{//有视频数据
        [_backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backView.superview).offset(16);
            make.right.equalTo(_backView.superview).offset(-16);
            make.top.equalTo(_backView.superview).offset(5);
            make.bottom.equalTo(_backView.superview).offset(-5);
            make.height.equalTo(_backView.mas_width).multipliedBy(0.68);
        }];
        self.backView.hidden = NO;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
        self.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
        [self.contentView addSubview:self.backView];
        [self.contentView addSubview:self.backImgV];
        [self.contentView addSubview:self.centerBtn];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backView.superview).offset(16);
        make.right.equalTo(_backView.superview).offset(-16);
        make.top.equalTo(_backView.superview).offset(5);
        make.bottom.equalTo(_backView.superview).offset(-5);
        make.height.equalTo(_backView.mas_width).multipliedBy(0.68);
    }];
    
    [_backImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView);
    }];
    [_centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView);
    }];
    [self.backImgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentImgViewTap)]];
    self.backImgV.userInteractionEnabled = YES;

}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
    }
    return _backView;
}
 
- (UIImageView *)backImgV{
    if (!_backImgV) {
        _backImgV = [[UIImageView alloc]init];
        _backImgV.contentMode = UIViewContentModeScaleAspectFill;
        _backImgV.layer.cornerRadius = 10.0;
        _backImgV.layer.masksToBounds = YES;
    }
    return _backImgV;
}

- (UIButton *)centerBtn{
    if (!_centerBtn) {
        _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_centerBtn newAnBtnWithImg:[UIImage imageNamed:@"bofang_icon"]];
        [_centerBtn addTarget:self action:@selector(centerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerBtn;
}
    
#pragma mark ==
//停止
- (void)contentImgViewTap{
    if (isNil(self.touchMp4CenterIsOpenTypeBlock)) {
        return;
    }
    self.touchMp4CenterIsOpenTypeBlock(NO);
    self.centerBtn.hidden = NO;
}

//播放
- (void)centerBtnAction:(UIButton *)sender{
    if (isNil(self.touchMp4CenterIsOpenTypeBlock)) {
        return;
    }
    self.touchMp4CenterIsOpenTypeBlock(YES);
    self.centerBtn.hidden = YES;//隐藏按钮
}

//    //data
//    sender.selected = !sender.selected;
//    self.touchMp4CenterBtnBlock(sender);
//    //UI
//    if (sender.selected == YES) {
//        //播放 centbtnSubImg 变小        ////  make.height.equalTo(_backView.mas_width).multipliedBy(0.68); //(Screen_W-32)*0.68 == h; 0.5
//
//
//        [sender setImageEdgeInsets: UIEdgeInsetsMake(0, ((Screen_W-32)*0.68)*0.5-0.1, 0, ((Screen_W-32)*0.68)*0.5)];
//        sender.imageView.contentMode = UIViewContentModeScaleAspectFit;
//
//        NSLog(@"播放");
//    }else{
//        //停止 有centbtnSubImg  {top, left, bottom, right};
//        [sender setImageEdgeInsets: UIEdgeInsetsMake(0, ((Screen_W-32)*0.68)*0.5 - 44*0.5, 0, ((Screen_W-32)*0.68)*0.5 - 44*0.5)];
//        sender.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        NSLog(@"停止");
//    }
 
    
 /**
  
  #import "MovEncodeToMpegTool.h"
  #import <ZFPlayer/ZFAVPlayerManager.h>
  #import <ZFPlayer/ZFPlayerControlView.h>
  #import <ZFPlayer/ZFPlayerConst.h>

  // 处理视频
  - (void)handleVideo:(NSURL *)url {
      dispatch_async(dispatch_get_main_queue(), ^{
          self.videoDeleteButton.hidden = NO;
          ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
          playerManager.shouldAutoPlay = NO;
          self.player.shouldAutoPlay = NO;
          // 1.0是完全消失的时候
          self.player.playerDisapperaPercent = 1.0;
          // 播放器相关
          self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.videoView];
          self.player.controlView = self.controlView;
          // 设置退到后台继续播放
          self.player.pauseWhenAppResignActive = NO;
          self.player.assetURL = url;
          [self.controlView showTitle:@"" coverURLString:@"" fullScreenMode:ZFFullScreenModeAutomatic];
      });
  }

  @import AVKit;
  */
    
@end

