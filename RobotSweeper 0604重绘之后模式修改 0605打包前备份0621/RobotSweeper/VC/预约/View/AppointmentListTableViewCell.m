//
//  TimmerListTableViewCell.m
//  RobotSweeper
//
//  Created by Joey on 2018/4/16.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "AppointmentListTableViewCell.h"

@implementation AppointmentListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]; //2. Returning 'self' while it is not set to the result of '[(super or self) init...]'
    if(self){
    
        [self addview];
    }
    return self;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addview{
     [self.contentView addSubview:self.beginTimerTitleL];
     [self.contentView addSubview:self.beginTimerL];
//     [self.contentView addSubview:self.modelTitleL];
//     [self.contentView addSubview:self.modelL];
//     [self.contentView addSubview:self.strengthTitleL];
//     [self.contentView addSubview:self.strengthL];
//     [self.contentView addSubview:self.repeatTitleL];
//     [self.contentView addSubview:self.repeatL];
     [self.contentView addSubview:self.detailL];
     [self.contentView addSubview:self.offAndOnSwitch];
    
//     [self viewMask];
    [self viewMaskX];
    

}
- (void)viewMaskX{//3层数据
    //1 时间
    [_beginTimerTitleL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.height.offset(20);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.width.offset(100);
    }];
    [_beginTimerL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.beginTimerTitleL);
        make.height.offset(20);
        make.left.equalTo(self.beginTimerTitleL.mas_right);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    
    //2 开关switch
    [_offAndOnSwitch mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(2);
        make.centerY.equalTo(self.contentView);
        make.height.offset(15);
        make.width.offset(70);
    }];
    //3.其他属性label
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.beginTimerTitleL.mas_bottom).offset(2);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        make.left.equalTo(self.beginTimerTitleL.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-80);
    }];
    //model
//    [_modelTitleL mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.beginTimerTitleL.mas_bottom).offset(5);
//        make.height.offset(20);
//        make.left.equalTo(self.mas_left).offset(10);
//        make.width.offset(100);
//    }];
//    [_modelL mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.beginTimerL.mas_bottom).offset(5);
//        make.height.offset(20);
//        make.left.equalTo(self.beginTimerTitleL.mas_right).offset(10);
//        make.right.equalTo(self.mas_right).offset(-10);
//    }];
 
    
}
- (void)viewMask{
    [_beginTimerTitleL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.height.offset(20);
        make.left.equalTo(self.mas_left).offset(10);
        make.width.offset(100);
    }];
    [_beginTimerL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.height.offset(20);
        make.left.equalTo(self.beginTimerTitleL.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    [_modelTitleL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.beginTimerTitleL.mas_bottom).offset(5);
        make.height.offset(20);
        make.left.equalTo(self.mas_left).offset(10);
        make.width.offset(100);
    }];
    [_modelL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.beginTimerL.mas_bottom).offset(5);
        make.height.offset(20);
        make.left.equalTo(self.beginTimerTitleL.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    [_strengthTitleL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.modelTitleL.mas_bottom).offset(5);
        make.height.offset(20);
        make.left.equalTo(self.mas_left).offset(10);
        make.width.offset(100);

    }];
    [_strengthL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.modelL.mas_bottom).offset(5);
        make.height.offset(20);
        make.left.equalTo(self.beginTimerTitleL.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);

    }];
    [_repeatTitleL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.strengthTitleL.mas_bottom).offset(5);
        make.height.offset(20);
        make.left.equalTo(self.mas_left).offset(10);
        make.width.offset(100);

    }];
    [_repeatL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.strengthL.mas_bottom).offset(5);
        make.height.offset(20);
        make.left.equalTo(self.beginTimerTitleL.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    //switch
    [_offAndOnSwitch mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.modelL.mas_top).offset(5);
        make.height.offset(20);
        make.width.offset(70);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
}




#pragma mark -- getter

- (UILabel*)beginTimerTitleL{
    if (!_beginTimerTitleL) {
        _beginTimerTitleL = [[UILabel alloc]init];
        _beginTimerTitleL.text = NSLocalizedString( @"开始时间", nil);
        _beginTimerTitleL.textAlignment = NSTextAlignmentLeft;
    }
    
    return _beginTimerTitleL;
}

- (UILabel*)beginTimerL{
    if (!_beginTimerL) {
        _beginTimerL = [[UILabel alloc]init];
        _beginTimerL.text = @"12:30";
        _beginTimerL.textAlignment = NSTextAlignmentLeft;
    }
    
    return _beginTimerL;
}

- (UILabel*)modelTitleL{
    if (!_modelTitleL) {
        _modelTitleL = [[UILabel alloc]init];
        _modelTitleL.text =  [NSString stringWithFormat:@"%@：",NSLocalizedString(@"清扫模式",nil)] ;
        _modelTitleL.textAlignment = NSTextAlignmentRight;
    }
    return _modelTitleL;
}

- (UILabel*)modelL{
    if (!_modelL) {
        _modelL = [[UILabel alloc]init];
//        _modelL.text = @"自动清扫";
        _modelL.text = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].yuyueModeArrMain.firstObject];
        _modelL.textAlignment = NSTextAlignmentLeft;
    }
    return _modelL;
}

- (UILabel*)strengthTitleL{
    if (!_strengthTitleL) {
        _strengthTitleL = [[UILabel alloc]init];
        _strengthTitleL.text = [NSString stringWithFormat:@"%@：",NSLocalizedString(@"清扫力度",nil)];
        _strengthTitleL.textAlignment = NSTextAlignmentRight;
    }
    return _strengthTitleL;
}

- (UILabel*)strengthL{
    if (!_strengthL) {
        _strengthL = [[UILabel alloc]init];
        _strengthL.text = NSLocalizedString(@"标准",nil);
        _strengthL.textAlignment = NSTextAlignmentLeft;
        
    }
    return _strengthL;
}

- (UILabel*)repeatTitleL{
    if (!_repeatTitleL) {
        _repeatTitleL = [[UILabel alloc]init];
        _repeatTitleL.text = [NSString stringWithFormat:@"%@：",NSLocalizedString(@"重复规则",nil)];
        _repeatTitleL.textAlignment = NSTextAlignmentRight;
    }
    return _repeatTitleL;
}

- (UILabel*)repeatL{
    if (!_repeatL) {
        _repeatL = [[UILabel alloc]init];
        _repeatL.text = @"单次";
        _repeatL.textAlignment = NSTextAlignmentLeft;
    }
    return _repeatL;
}

- (UISwitch *)offAndOnSwitch{
    if (!_offAndOnSwitch) {
        _offAndOnSwitch = [[UISwitch alloc]init];
        _offAndOnSwitch.on = YES;
        _offAndOnSwitch.onTintColor = [DataManager shareDataManager].colorOfMainType;
         _offAndOnSwitch.transform= CGAffineTransformMakeScale(0.8,0.8);
     }
    return _offAndOnSwitch;
}

- (UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc]init];
        _detailL.textColor = [UIColor lightGrayColor];
        _detailL.numberOfLines = 0;
        _detailL.font = [UIFont systemFontOfSize:12];
        _detailL.textAlignment = NSTextAlignmentLeft;
    }
    return _detailL;
}
#pragma mark -- cellData
-(void)setStrOfcell:(NSString *)strOfcell{
    _strOfcell = strOfcell;
    [self dataSource];
}

- (void)dataSource{
    //数字部分
    NSString *time = [_strOfcell substringToIndex:5];
    NSString *model = [_strOfcell substringWithRange:NSMakeRange(6, 1)];
    NSString *strong = [_strOfcell substringWithRange:NSMakeRange(8, 1)];
    NSString *offOrNo = [_strOfcell substringWithRange:NSMakeRange(10, 1)];
    NSString *week = [_strOfcell substringWithRange:NSMakeRange(12, 13)];
    NSLog(@"%@ , %@   , %@  ,%@  , %@",time,model,strong,offOrNo,week);
    //文字部分
    NSString *strOfT = @"";
    NSString *strM = @"";
    NSString *strOfS = @"";
    NSString *strOfweek = @"";
    strOfT = [time stringByReplacingOccurrencesOfString:@" " withString:@":"];
    _beginTimerL.text = [time stringByReplacingOccurrencesOfString:@" " withString:@":"];
    
    switch ([model intValue]) {
        case 1:
//            strM = @"自动清扫";
//            _modelL.text = @"自动清扫";
            strM = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].yuyueModeArrMain.firstObject];
            _modelL.text = strM;
            break;
        case 2:
//            strM = @"边角清扫";//沿边
//            _modelL.text = @"边角清扫";
            strM = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].yuyueModeArrMain[1]];
            _modelL.text = strM;//第二个元素
            break;
        case 5:
           //4*4清扫
            strM = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].yuyueModeArrMain[2]];
            _modelL.text = strM;//第二个元素
            break;
            
        default://其他
            strM = [NSString stringWithFormat:@"%@",[DataManager shareDataManager].yuyueModeArrMain.firstObject];
            _modelL.text = strM;
            break;
    }
    
    switch ([strong intValue]) {
        case 1:
            strOfS = NSLocalizedString(@"标准", nil) ;
            _strengthL.text = NSLocalizedString(@"标准", nil);
            break;
        case 2:
            strOfS = NSLocalizedString(@"静音", nil);
            _strengthL.text = NSLocalizedString(@"静音", nil);
            break;
        case 3:
            strOfS = NSLocalizedString(@"强力", nil);
            _strengthL.text = NSLocalizedString(@"强力", nil);
            break;
            
        default:
            break;
    }

  
    if ([offOrNo isEqualToString:@"1"]) {
        [_offAndOnSwitch setOn:YES];

    }else{
         [_offAndOnSwitch setOn:NO];
    }
    
    NSArray *arrOfWeek = [week componentsSeparatedByString:@" "];
   
//国际化添加的weak相关
    //
     NSString *wOne = NSLocalizedString(@"周一", nil);
     NSString *wTwo = NSLocalizedString(@"周二", nil);
     NSString *wThr = NSLocalizedString(@"周三", nil);
     NSString *wFour = NSLocalizedString(@"周四", nil);
     NSString *wFiv = NSLocalizedString(@"周五", nil);
     NSString *wSix = NSLocalizedString(@"周六", nil);
     NSString *wSeve = NSLocalizedString(@"周日", nil);
    for (int i = 0; i<arrOfWeek.count; i++) {
        if ([arrOfWeek[i] intValue] == 1) {
            
            switch (i) {
                case 0:
                    
                    strOfweek = [NSString stringWithFormat:@"%@%@",strOfweek,wOne];
                    break;
                case 1:
                    strOfweek = [NSString stringWithFormat:@"%@%@",strOfweek,wTwo];
                    break;
                case 2:
                    strOfweek = [NSString stringWithFormat:@"%@%@",strOfweek,wThr];
                    break;
                case 3:
                    strOfweek = [NSString stringWithFormat:@"%@%@",strOfweek,wFour];
                    break;
                case 4:
                    strOfweek = [NSString stringWithFormat:@"%@%@",strOfweek,wFiv];
                    break;
                case 5:
                    strOfweek = [NSString stringWithFormat:@"%@%@",strOfweek,wSix];
                    break;
                case 6:
                    strOfweek = [NSString stringWithFormat:@"%@%@",strOfweek,wSeve];
                    break;

                default:
                    break;
            }
        }
    }
    
    
    if (strOfweek.length<=0) {
        strOfweek = NSLocalizedString(@"单次", nil) ;
    }else if([strOfweek isEqualToString:NSLocalizedString(@"周一周二周三周四周五周六周日", nil)]){
        strOfweek = NSLocalizedString(@"每天", nil);
    }else if([strOfweek isEqualToString:NSLocalizedString(@"周一周二周三周四周五", nil)]){
        strOfweek = NSLocalizedString(@"工作日", nil);
    }if([strOfweek isEqualToString:NSLocalizedString(@"周六周日", nil)]){
        strOfweek = NSLocalizedString(@"周末", nil);
    }else{
    }

    _repeatL.text = strOfweek;
    
     NSLog(@"%@ , %@   , %@  ,%@ ",time,model,strong,week);
      NSLog(@"%@ , %@   , %@  ,%@  ",strOfT,strM,strOfS,strOfweek);
    _detailL.text = [NSString stringWithFormat:@"%@:%@   %@:%@   %@:%@",NSLocalizedString(@"清扫模式",nil),strM,NSLocalizedString(@"清扫力度",nil),strOfS,NSLocalizedString(@"重复规则",nil),strOfweek];
}
@end
