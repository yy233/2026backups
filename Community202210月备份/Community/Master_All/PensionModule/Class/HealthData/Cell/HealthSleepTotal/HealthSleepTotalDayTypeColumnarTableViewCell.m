//
//  HealthSleepTotalDayTypeColumnarTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/11/18.
//

#import "HealthSleepTotalDayTypeColumnarTableViewCell.h"
#import "HealthSleepTool.h"

#define  Width_ShowConnect      (Screen_W-32-20)
#define  Height_ShowConnect     (30)

@interface HealthSleepTotalDayTypeColumnarTableViewCell ()
@property (nonatomic,strong) NSMutableArray *btnTitleArr;
@end
 

@implementation HealthSleepTotalDayTypeColumnarTableViewCell



- (void)fillDataWithAllTimeNum:(NSInteger)allT withDeepSleepTime:(NSInteger)deepT withLightSleepTime:(NSInteger)lightT withAwakeSleepTime:(NSInteger)awakeT{
    if (allT==0) {
        return;
    }else{
        //
        NSString *oneStr = [self.btnTitleArr.firstObject stringByAppendingString:[self showStrTimeMinNum:deepT]];
        [self.oneSingBtn newAnBtnWithTextStr:oneStr];
        NSString *twoStr = [self.btnTitleArr[1] stringByAppendingString:[self showStrTimeMinNum:lightT]];
        [self.twoSingBtn newAnBtnWithTextStr:twoStr];
        NSString *thrStr = [self.btnTitleArr.lastObject stringByAppendingString:[self showStrTimeMinNum:awakeT]];
        [self.thrSingBtn newAnBtnWithTextStr:thrStr];
        //
        double dtP = (double)deepT/allT;
        double ltP = (double)lightT/allT;
        double atP = (double)awakeT/allT;
       // NSLog(@"fillDataWithAllTimeNum dla_T %f %f %f",dtP,ltP,atP);
        [self.oneView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(dtP*Width_ShowConnect);
        }];
        [self.twoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(ltP*Width_ShowConnect);
        }];
        [self.thrView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(atP*Width_ShowConnect);
        }];
    
    }
}

- (NSString *)showStrTimeMinNum:(NSInteger)minNum
{
    
    return  [HealthSleepTool showHMStrTimeWithMinIntValue:minNum];
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
        [self.contentView addSubview:self.oneSingBtn];
        [self.contentView addSubview:self.twoSingBtn];
        [self.contentView addSubview:self.thrSingBtn];
        [self.contentView addSubview:self.oneView];
        [self.contentView addSubview:self.twoView];
        [self.contentView addSubview:self.thrView];
        [self setBaseUI];
    }
    return self;
}
- (void)setBaseUI{
    [_oneSingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_oneSingBtn.superview.mas_left).offset(26);
        make.height.offset(20);
        make.top.equalTo(_oneSingBtn.superview).offset(10);
        //make.width.offset(Width_ShowConnect/2);
    }];
    [_twoSingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_oneSingBtn.superview.mas_right).offset(-26);
        make.height.top.equalTo(_oneSingBtn);
        //make.width.offset(Width_ShowConnect/2);
    }];
    [_thrSingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.equalTo(_oneSingBtn);
        make.top.equalTo(_oneSingBtn.mas_bottom).offset(5);
        // make.width.offset(Width_ShowConnect/2);
    }];
    
    //
    [_oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_thrSingBtn.mas_bottom).offset(20);
        make.height.offset(Height_ShowConnect);
        make.left.equalTo(_oneView.superview.mas_left).offset(26);
        make.width.offset(0.1);
   
    }];
    [_twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(_oneView);
        make.left.equalTo(_oneView.mas_right);
        make.width.offset(0.1);
        
    }];
    [_thrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(_oneView);
        make.left.equalTo(_twoView.mas_right);
        make.width.offset(0.1);
    }];
}

#pragma mark ==

 
- (UIView *)oneView{
    if (!_oneView) {
        _oneView = [[UIView alloc]init];
        _oneView.backgroundColor = Color_HealthShow_SleepType_Green_Deep;
    }
    return _oneView;
}
- (UIView *)twoView{
    if (!_twoView) {
        _twoView = [[UIView alloc]init];
        _twoView.backgroundColor = Color_HealthShow_SleepType_Green_Light;
    }
    return _twoView;
}
- (UIView *)thrView{
    if (!_thrView) {
        _thrView = [[UIView alloc]init];
        _thrView.backgroundColor = Color_HealthShow_SleepType_Green_Awake;
    }
    return _thrView;
}
#pragma mark ==
- (UIButton *)oneSingBtn{
    if (!_oneSingBtn) {
        _oneSingBtn = [HealthSleepTotalTableViewCellSubColorAndTextBtnTool buttonWithType:UIButtonTypeCustom withCreatBtnRightImgColor:Color_HealthShow_SleepType_Green_Deep withShowBtnTextStr:[self.btnTitleArr.firstObject stringByAppendingString:@"暂无"]];
    }
    return _oneSingBtn;
}
- (UIButton *)twoSingBtn{
    if (!_twoSingBtn) {
        _twoSingBtn = [HealthSleepTotalTableViewCellSubColorAndTextBtnTool buttonWithType:UIButtonTypeCustom withCreatBtnRightImgColor:Color_HealthShow_SleepType_Green_Light withShowBtnTextStr:[self.btnTitleArr[1] stringByAppendingString:@"暂无"]];
    }
    return _twoSingBtn;
}
- (UIButton *)thrSingBtn{
    if (!_thrSingBtn) {
        _thrSingBtn = [HealthSleepTotalTableViewCellSubColorAndTextBtnTool buttonWithType:UIButtonTypeCustom withCreatBtnRightImgColor:Color_HealthShow_SleepType_Green_Awake withShowBtnTextStr:[self.btnTitleArr.lastObject stringByAppendingString:@"暂无"]];
    }
    return _thrSingBtn;
}

- (NSMutableArray *)btnTitleArr{
    if (!_btnTitleArr) {
//        _btnTitleArr = [NSMutableArray arrayWithObjects: @"深睡时长:暂无", @"浅睡时长:暂无", @"梦醒时长:暂无", nil];
        _btnTitleArr = [NSMutableArray arrayWithObjects: @"深睡时长:", @"浅睡时长:", @"梦醒时长:", nil];
    }
    return _btnTitleArr;
}
@end
