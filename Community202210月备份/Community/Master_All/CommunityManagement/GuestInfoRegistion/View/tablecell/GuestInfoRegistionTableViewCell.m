//
//  GuestInfoRegistionTableViewCell.m
//  Community
//
//  Created by 余莹 on 2020/12/4.
//

#import "GuestInfoRegistionTableViewCell.h"

 

@interface GuestInfoRegistionTableViewCell ()


@end
@implementation GuestInfoRegistionTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
 
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void)setModel:(GuestInfoModel *)model{
    
    _model = model;
     //DLog(@"主列表 时间数据 ==。%@ ",[NSString stringWithFormat:@"%@ %@ | %@",_model.endTime,_model.startTime,_model.createTime]);//临时才用creatT
//     
//    if (model.tempCodeStatus) {
//        /**
//         _titleLabel.text = @"姓名姓名";  //
//         _detailtitleLabel.text = @"来访时间：";
//         _titleContentLabel.text = @"电话";//
//         _detailContentLabel.text = @"日期";
//         */
//        _headImgV.image = [ThemeImg themeImageWithBaseName:@"erweima"];
//        _editorBtn.backgroundColor = EditorBtnBackColor_Temp;
//        _titleContentLabel.text = @"临时二维码";
//        _detailContentLabel.text  = [NSString stringWithFormat:@"生成时间：%@",[TextShowWithModelStr textShowWithModelStr:_model.createTime]];
//     
//        //
//        _titleLabel.text = @"";
//        _detailtitleLabel.text = @"";
//        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//           make.top.equalTo(_headImgV.mas_top);
//           make.left.equalTo(_headImgV.mas_right).offset(10);
//           make.height.offset(20);
//           make.width.offset(0);
//       }];
//        [_detailtitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_titleLabel.mas_left);
//            make.top.equalTo(_titleLabel.mas_bottom);
//            make.height.offset(20);
//            make.width.offset(0);
//       }];
//        
//    }else{
//        _headImgV.image = [ThemeImg themeImageWithBaseName:@"head_placeholderImage"];
//        _editorBtn.backgroundColor = Y_Gradient_Color(50, 30, BeginColor, EndColor);
//        _titleLabel.text = model.name;
//        _titleContentLabel.text = model.contact;//电话
//        [self setNameWidthUI];
//        [self timeText];
//    }
   
}
- (void)setNameWidthUI{
    CGSize titleLabelSize = [[NSString stringWithFormat:@"%@",_model.name] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}]; //姓名尺寸
     [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImgV.mas_top);
        make.left.equalTo(_headImgV.mas_right).offset(10);
        make.height.offset(20);
        make.width.offset(titleLabelSize.width+5);//
    }];
}
- (void)timeText{
    NSString *beginTimeStr =@"";
    NSString *endTimeStr = @"";
    NSString *timeStr = @"";
    
    //0917 适配物业后台时间精确到小时分秒
    NSString *showBegT = [TextShowWithModelStr textShowWithModelStr: _model.startTime];
    NSString *showEndT = [TextShowWithModelStr textShowWithModelStr: _model.endTime];
    beginTimeStr = showBegT.length > 10 ?  [showBegT substringWithRange:NSMakeRange(5, 11)] : showBegT;
    endTimeStr =  showEndT.length > 10 ?  [showEndT substringWithRange:NSMakeRange(5, 11)] : showEndT;
    //
    if (endTimeStr.length>0) {
        timeStr = [NSString stringWithFormat:@"%@至%@",beginTimeStr,endTimeStr];
    }else{
        timeStr = [NSString stringWithFormat:@"%@",beginTimeStr];
    }
    _detailContentLabel.text = timeStr;
    
 }
- (void)editorBtnAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(guestInfoListCellRightBtnTouch:)]) {
        [_delegate guestInfoListCellRightBtnTouch:_model];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor  = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backGroundV];
        [self.backGroundV addSubview:self.headImgV];
        [self.backGroundV addSubview:self.titleLabel];
        [self.backGroundV addSubview:self.detailtitleLabel];
        [self.backGroundV addSubview:self.titleContentLabel];
        [self.backGroundV addSubview:self.detailContentLabel];
        [self.backGroundV addSubview:self.editorBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    _titleLabel.text = @"姓名姓名";
    //_detailtitleLabel.text = @"来访时间：";
    _detailtitleLabel.text = @"有效日期为:";
    _titleContentLabel.text = @"电话";
    _detailContentLabel.text = @"日期";
  
    //cell70 self80
    [_backGroundV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_backGroundV.superview.mas_centerY);
        make.centerX.equalTo(_backGroundV.superview.mas_centerX);
        make.width.equalTo(_backGroundV.superview.mas_width).offset(-32);
        make.height.offset(70.0);
    }];
    [_headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_backGroundV.superview.mas_centerY);
        make.left.equalTo(_headImgV.superview.mas_left).offset(10);
        make.width.offset(36);
        make.height.equalTo(_headImgV.mas_width);
    }];
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(_headImgV.mas_top);
       make.left.equalTo(_headImgV.mas_right).offset(10);
       make.height.offset(20);
       make.width.offset(65);//四个字左右
   }];
   //电话 >=90w
   [_titleContentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
       make.centerY.equalTo(_titleLabel.mas_centerY);
       make.left.equalTo(_titleLabel.mas_right);
       make.right.mas_greaterThanOrEqualTo(_titleContentLabel.superview.mas_right).offset(-70);//（50+15）btn +5间隔
       make.height.equalTo(_titleLabel.mas_height);
   }];
    [_detailtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.top.equalTo(_titleLabel.mas_bottom);
        make.height.offset(20);
        make.width.offset(_detailTitleLabelSize.width+10);
    }];
    [_detailContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_detailtitleLabel.mas_centerY);
        make.left.equalTo(_detailtitleLabel.mas_right);
        make.right.equalTo(_detailContentLabel.superview.mas_right).offset(-60);//（50+10）btn +5间隔
        make.height.equalTo(_detailtitleLabel.mas_height);
    }];
    
    [_editorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_headImgV.mas_centerY).offset(0);
        make.right.equalTo(_editorBtn.superview.mas_right).offset(-10);
        make.width.offset(50);
        make.height.offset(30);
    }];
}
#pragma mark ===
- (UIView *)backGroundV{
    if (!_backGroundV) {
        _backGroundV = [[UIView alloc]init];
        _backGroundV.layer.cornerRadius = 5;
        if ([ThemeManager shareManager].type==ThemeType_White) {
            _backGroundV.backgroundColor = [UIColor whiteColor];
        }else if([ThemeManager shareManager].type==ThemeType_Drak){
            _backGroundV.backgroundColor = Y_RGBA(17, 41, 87, 1);
        }
    }
    return _backGroundV;
}
- (UIImageView *)headImgV{
    if (!_headImgV) {
        _headImgV = [[UIImageView alloc]init];
        _headImgV.contentMode = UIViewContentModeScaleAspectFit;
//        _headImgV.layer.masksToBounds = YES;
//        _headImgV.layer.borderWidth = 1;
//        _headImgV.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        _headImgV.layer.cornerRadius = 18;//35h-36
        _headImgV.image = [ThemeImg themeImageWithBaseName:@"head_placeholderImage"];
        [_headImgV zy_cornerRadiusAdvance:18 rectCornerType:UIRectCornerAllCorners];
        [_headImgV zy_attachBorderWidth:0.5 color:Color_245Gray];

    }
    return _headImgV;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _titleLabel;
}

- (UILabel *)detailtitleLabel{
    if (!_detailtitleLabel) {
        _detailtitleLabel = [[UILabel alloc]init];
        _detailtitleLabel.font = [UIFont boldSystemFontOfSize:12];
        _detailtitleLabel.textColor = [ThemeManager shareManager].mainTexDetailLightBluetColor;
        _detailTitleLabelSize = [[NSString stringWithFormat:@"有效日期为:"] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];//记录size
    }
    return _detailtitleLabel;
}

- (UILabel *)titleContentLabel{
    if (!_titleContentLabel) {
        _titleContentLabel = [[UILabel alloc]init];
        _titleContentLabel.font = [UIFont systemFontOfSize:14];
        _titleContentLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _titleContentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleContentLabel;
}
- (UILabel *)detailContentLabel{
    if (!_detailContentLabel) {
        _detailContentLabel = [[UILabel alloc]init];
        _detailContentLabel.font = [UIFont systemFontOfSize:12];
        _detailContentLabel.textColor = [ThemeManager shareManager].mainTexDetailLightBluetColor;
    }
    return _detailContentLabel;
}

- (UIButton *)editorBtn{
    if (!_editorBtn) {
        _editorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editorBtn.layer.cornerRadius = 15;//50h 30w
        _editorBtn.layer.masksToBounds = YES;
        _editorBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_editorBtn setTitle:@"查看" forState:UIControlStateNormal];
        [_editorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_editorBtn addTarget:self action:@selector(editorBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editorBtn;
}
@end
