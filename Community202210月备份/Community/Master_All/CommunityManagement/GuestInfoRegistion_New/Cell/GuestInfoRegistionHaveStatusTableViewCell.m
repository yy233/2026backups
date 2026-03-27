//
//  GuestInfoRegistionHaveStatusTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/5/19.
//

#import "GuestInfoRegistionHaveStatusTableViewCell.h"

#define Color_Green_Text    Y_ColorWith16FromRGB(0x0DA368)
#define Color_Green_BackV   Y_ColorWith16FromRGB(0xC3F8E3)

#define Color_Red_Text      Y_ColorWith16FromRGB(0xF4393C)
#define Color_Red_BackV     Y_ColorWith16FromRGB(0xF4DADB)

 



@implementation GuestInfoRegistionHaveStatusTableViewCell

- (void)fillCellModel:(GuestInfoModel *)model{
    WEAKSELF
    weakSelf.model = model;
  
    if (model.tempCodeStatus) {

        self.headImgV.image = [ThemeImg themeImageWithBaseName:@"erweima"];
        self.editorBtn.backgroundColor = EditorBtnBackColor_Temp;
        self.titleContentLabel.text = @"临时二维码";
        self.titleLabel.text = @"";
        [ self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(weakSelf.headImgV.mas_top);
           make.left.equalTo(weakSelf.headImgV.mas_right).offset(10);
           make.height.offset(20);
           make.width.offset(0);
       }];
        [self timeText];
    }else{
        self.headImgV.image = [ThemeImg themeImageWithBaseName:@"head_placeholderImage"];
        self.editorBtn.backgroundColor = Y_Gradient_Color(50, 30, BeginColor, EndColor);
        self.titleLabel.text = model.name;
        self.titleContentLabel.text = model.contact;//电话
        [self setNameWidthUI];
        [self timeText];
    }
   
    [self statusBtnUI];
}
 
- (void)setNameWidthUI{
    WEAKSELF
    CGSize titleLabelSize = [[NSString stringWithFormat:@"%@",self.model.name] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}]; //姓名尺寸
    
     [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headImgV.mas_top);
        make.left.equalTo(weakSelf.headImgV.mas_right).offset(10);
        make.height.offset(20);
        make.width.offset(titleLabelSize.width+5);
    }];
}
 
- (void)timeText{
    //0520改 时间格式 普通== x月y日至x月y日 临时x月y日 00:00
    
    NSString *showBegT = [TextShowWithModelStr textShowWithModelStr: self.model.startTime];
    NSString *showEndT = [TextShowWithModelStr textShowWithModelStr: self.model.endTime];
    
    NSString *getOneS = @"";
    if (self.model.tempCodeStatus == 1) {
        getOneS = [ToolOfTimeChangeFormat longChineseStrOfMonthDayHMStr:showEndT];
    }else{
        NSString *oneTStr = showBegT.length > 0 ? [ToolOfTimeChangeFormat shortChineseStrOfMonthDayStr:showBegT] : @"";
        NSString *twoTStr = showEndT.length > 0 ? [ToolOfTimeChangeFormat shortChineseStrOfMonthDayStr:showEndT] : @"";
        if (oneTStr.length == 0) {
            getOneS = twoTStr;
        }else if (twoTStr.length == 0){
            getOneS = oneTStr;
        }else  if ([oneTStr isEqualToString:twoTStr]) {
            getOneS = oneTStr;
        }else{
            getOneS = [NSString stringWithFormat:@"%@至%@",oneTStr,twoTStr];
        }
    }
    self.detailContentLabel.text = getOneS;
    
 }


- (void)statusBtnUI{
    
    //查看按钮 隐藏
    self.editorBtn.hidden = YES;
    //self.detailtitleLabel.text = @"有效日期为:";
    
    //状态按钮展示
    switch (self.model.status ) {//status    状态 1.待入园 2.已入园 3.已出园 4.已失效
        case 2:
        {
            self.cellInfoStatusBtn.hidden = NO;
            [self.cellInfoStatusBtn  newAnBtnWithTextStr:@"已到访"];
            [self.cellInfoStatusBtn  newAnBtnWithTextColor:Color_Green_Text];
            [self.cellInfoStatusBtn  newAnBtnWithBackColor:Color_Green_BackV];
        }
            break;
        case 3:
        {
            self.cellInfoStatusBtn.hidden = NO;
            [self.cellInfoStatusBtn  newAnBtnWithTextStr:@"已到访"];
            [self.cellInfoStatusBtn  newAnBtnWithTextColor:Color_Green_Text];
            [self.cellInfoStatusBtn  newAnBtnWithBackColor:Color_Green_BackV];
        }
            break;
        case 4:
        {
            self.cellInfoStatusBtn.hidden = NO;
            [self.cellInfoStatusBtn  newAnBtnWithTextStr:@"已失效"];
            [self.cellInfoStatusBtn  newAnBtnWithTextColor:Color_Red_Text];
            [self.cellInfoStatusBtn  newAnBtnWithBackColor:Color_Red_BackV];
        }
            break;
        default:
            self.cellInfoStatusBtn.hidden = YES;
            break;
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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      WEAKSELF
        [self.backGroundV addSubview:self.cellInfoStatusBtn];
        [_cellInfoStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.titleLabel);
            make.height.offset(24.0);
            make.width.offset(50.0);
            make.right.equalTo(_cellInfoStatusBtn.superview).offset(-10);
        }];
    }
    return self;
}
 
- (UIButton *)cellInfoStatusBtn{
    if (!_cellInfoStatusBtn) {
        _cellInfoStatusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cellInfoStatusBtn newAnBtnWithFont: [UIFont systemFontOfSize:14.0]];
        [_cellInfoStatusBtn newAnBtnWithLayerCorNerNum:3.0 withLayerLineWidth:0.0 withLayerLineColor:[UIColor whiteColor]];
    }
    return _cellInfoStatusBtn;
}
@end
