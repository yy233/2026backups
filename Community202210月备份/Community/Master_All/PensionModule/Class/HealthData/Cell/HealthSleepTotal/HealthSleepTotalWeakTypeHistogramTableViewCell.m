//
//  HealthSleepTotalWeakTypeHistogramTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/11/18.
//

#import "HealthSleepTotalWeakTypeHistogramTableViewCell.h"
#import "HealthSleepTotalTableViewCellSubColorAndTextBtnTool.h"
#import "HealthSleepTotalWeakTypeHistogramTableViewCellSubCollectionViewCell.h"
#define  HealthSleepTotalWeakTypeHistogramTableViewCellSubCollectionViewCell_Identifier   @"HealthSleepTotalWeakTypeHistogramTableViewCellSubCollectionViewCell"
#import "HealthSleepTool.h"

//Row_Height_WeakType_One 300 h

#define SubCollectionView_W  (Screen_W  - 32)
#define SubCell_W            ((Screen_W  - 32) / 7)
#define SubCell_H            (200)
#define touchSubCollectionCellIndex_InitIntValue  (999)

#define BtnRightImg_WH  (10)

@interface HealthSleepTotalWeakTypeHistogramTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSMutableArray *btnTitleArr;
//
@property (nonatomic,strong) UIButton *oneSingBtn;
@property (nonatomic,strong) UIButton *twoSingBtn;
@property (nonatomic,strong) UIButton *thrSingBtn;
//
@property (nonatomic,strong) UIView *timeChangeShowBackView;
@property (nonatomic,strong) UIButton *goLastWeakBtn;
@property (nonatomic,strong) UIButton *goNextWeakBtn;
@property (nonatomic,strong) UILabel *showWeakTitleLabel;
//
@property (nonatomic,strong) UICollectionView *collectionView;//柱状图cv

@property (nonatomic,strong) HealthGetSleepOneWeakModel *saveOneWeakModel;
@property (nonatomic,assign) NSInteger touchSubCollectionCellIndex;//点击记录rownum


@end

@implementation HealthSleepTotalWeakTypeHistogramTableViewCell

- (void)fillDataOneWeak:(HealthGetSleepOneWeakModel *)oneWeakModel{
    self.saveOneWeakModel = oneWeakModel;
    self.touchSubCollectionCellIndex = touchSubCollectionCellIndex_InitIntValue;
    [self fillTopData];
    [self fillCenterTimeData];
    [self.collectionView reloadData];
}
- (void)fillTopData{
    //某天点击事件 也会改变  signsBtn name
     if ( self.touchSubCollectionCellIndex != touchSubCollectionCellIndex_InitIntValue) {
         
         //黄色+数据
         UIImage *btnImg1 = [ImgSetSize setimageSize:[UIImage imageWithColor: Color_HealthShow_SleepType_Orange_Deep] width:BtnRightImg_WH height:BtnRightImg_WH];
         [self.oneSingBtn newAnBtnWithImg:btnImg1];
         UIImage *btnImg2 = [ImgSetSize setimageSize:[UIImage imageWithColor: Color_HealthShow_SleepType_Orange_Light] width:BtnRightImg_WH height:BtnRightImg_WH];
         [self.twoSingBtn newAnBtnWithImg:btnImg2];
         UIImage *btnImg3 = [ImgSetSize setimageSize:[UIImage imageWithColor: Color_HealthShow_SleepType_Orange_Awake] width:BtnRightImg_WH height:BtnRightImg_WH];
         [self.thrSingBtn newAnBtnWithImg:btnImg3];
         //
         HealthGetSleepOneDayModel *oneDayModel = [self.saveOneWeakModel.list objectAtIndex:self.touchSubCollectionCellIndex];
         [self.oneSingBtn newAnBtnWithTextStr:[self.btnTitleArr.firstObject stringByAppendingString:[self showStrTimeMinNum:oneDayModel.deepSleepTime]]];
         [self.twoSingBtn newAnBtnWithTextStr:[self.btnTitleArr[1] stringByAppendingString:[self showStrTimeMinNum:oneDayModel.lightSleepTime]]];
         [self.thrSingBtn newAnBtnWithTextStr:[self.btnTitleArr.lastObject stringByAppendingString:[self showStrTimeMinNum:oneDayModel.wakeUpTime]]];
         
     }else{
         //绿色+暂无
         [self.oneSingBtn newAnBtnWithTextStr:[self.btnTitleArr.firstObject stringByAppendingString:@"暂无"]];
         [self.twoSingBtn newAnBtnWithTextStr:[self.btnTitleArr[1] stringByAppendingString:@"暂无"]];
         [self.thrSingBtn newAnBtnWithTextStr:[self.btnTitleArr.lastObject stringByAppendingString:@"暂无"]];
         //
         UIImage *btnImg1 = [ImgSetSize setimageSize:[UIImage imageWithColor: Color_HealthShow_SleepType_Green_Deep] width:BtnRightImg_WH height:BtnRightImg_WH];
         [self.oneSingBtn newAnBtnWithImg:btnImg1];
         UIImage *btnImg2 = [ImgSetSize setimageSize:[UIImage imageWithColor: Color_HealthShow_SleepType_Green_Light] width:BtnRightImg_WH height:BtnRightImg_WH];
         [self.twoSingBtn newAnBtnWithImg:btnImg2];
         UIImage *btnImg3 = [ImgSetSize setimageSize:[UIImage imageWithColor: Color_HealthShow_SleepType_Green_Awake] width:BtnRightImg_WH height:BtnRightImg_WH];
         [self.thrSingBtn newAnBtnWithImg:btnImg3];
         
     }
}
- (NSString *)showStrTimeMinNum:(NSInteger)minNum
{
    
    return  [HealthSleepTool showHMStrTimeWithMinIntValue:minNum];
}

- (void)fillCenterTimeData{
    NSString *beginObjShowTime = [TextShowWithModelStr textShowWithModelStr:self.saveOneWeakModel.list.firstObject.timeTitle];
    NSString *endObjShowTime = [TextShowWithModelStr textShowWithModelStr: self.saveOneWeakModel.list.lastObject.timeValue];
    if (beginObjShowTime.length>0 && endObjShowTime.length>0) {
        self.showWeakTitleLabel.text = [NSString stringWithFormat:@"%@ - %@", beginObjShowTime,endObjShowTime];
    }else{
        self.showWeakTitleLabel.text = @"";
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
      
        [self.contentView addSubview:self.oneSingBtn];
        [self.contentView addSubview:self.twoSingBtn];
        [self.contentView addSubview:self.thrSingBtn];
        [self.contentView addSubview:self.timeChangeShowBackView];
        [self.timeChangeShowBackView addSubview:self.goLastWeakBtn];//left
        [self.timeChangeShowBackView addSubview:self.goNextWeakBtn];//right
        [self.timeChangeShowBackView addSubview:self.showWeakTitleLabel];
        [self.contentView addSubview:self.collectionView];
        [self setBaseUI];
    }
    return self;
}
- (void)setBaseUI{
    [self topSignViewUI];
    [self timeShowViewUI];
    [self collectionViewUI];
}
- (void)topSignViewUI{
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
}
- (void)timeShowViewUI{
    [_timeChangeShowBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_thrSingBtn.mas_bottom).offset(25);
        make.height.offset(20);
        make.left.equalTo(_timeChangeShowBackView.superview.mas_left).offset(36);
        make.right.equalTo(_timeChangeShowBackView.superview.mas_right).offset(-36);
    }];
    [_goLastWeakBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(_goLastWeakBtn.superview);
        make.width.equalTo(_goLastWeakBtn.mas_height);
    }];
    [_goNextWeakBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(_goNextWeakBtn.superview);
        make.width.equalTo(_goNextWeakBtn.mas_height);
    }];
    [_showWeakTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_showWeakTitleLabel.superview);
        make.left.equalTo(_goLastWeakBtn.mas_right);
        make.right.equalTo(_goNextWeakBtn.mas_left);
    }];
    
}
- (void)collectionViewUI{
   
    /**
     cellH即300-( 其他viewH 10 20 5 20 25 20 )==cv_ h==200
     cv_w = sw-32
     */
    //柱状图位置不给间距 （14h的总时长，睡眠一般没这么长时间 上边会有空余间隔）
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeChangeShowBackView.mas_bottom).offset(0);
        make.bottom.equalTo(_collectionView.superview).offset(0);
//        make.left.right.equalTo(_collectionView.superview);
        make.left.equalTo(_timeChangeShowBackView.superview.mas_left).offset(16);
        make.right.equalTo(_timeChangeShowBackView.superview.mas_right).offset(-16);
        
    }];
}


#pragma mark =======================
#pragma mark==
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //选择某一天
    self.touchSubCollectionCellIndex = indexPath.row;
    [self fillTopData];
    [collectionView reloadData];
 
}
#pragma mark==
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.saveOneWeakModel.list.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HealthSleepTotalWeakTypeHistogramTableViewCellSubCollectionViewCell *cell = (HealthSleepTotalWeakTypeHistogramTableViewCellSubCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:HealthSleepTotalWeakTypeHistogramTableViewCellSubCollectionViewCell_Identifier  forIndexPath:indexPath];
    HealthGetSleepOneDayModel *oneDayModel = [self.saveOneWeakModel.list objectAtIndex:indexPath.row];
    [cell fillDataWithOneDayModel:oneDayModel];
    if (self.touchSubCollectionCellIndex  == indexPath.row) {
        [cell setSubViewColorIsTouchTypeBool:YES];;
    }else{
        [cell setSubViewColorIsTouchTypeBool:NO];;
    }
     return cell;
}
 
 
#pragma mark ==
 
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake((SubCell_W), SubCell_H);
        //间隔
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);// {top, left, bottom, right};
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,  SubCollectionView_W ,  SubCell_H) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
//        _collectionView.showsVerticalScrollIndicator = NO;
//        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[HealthSleepTotalWeakTypeHistogramTableViewCellSubCollectionViewCell class] forCellWithReuseIdentifier: HealthSleepTotalWeakTypeHistogramTableViewCellSubCollectionViewCell_Identifier];
    }
    return _collectionView;
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

#pragma mark ==
- (UIView *)timeChangeShowBackView{
    if (!_timeChangeShowBackView) {
        _timeChangeShowBackView = [[UIView alloc]init];
        _timeChangeShowBackView.backgroundColor = [UIColor clearColor];
    }
    return _timeChangeShowBackView;
}
- (UIButton *)goLastWeakBtn{
    if (!_goLastWeakBtn) {
        _goLastWeakBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goLastWeakBtn newAnBtnWithImg:[UIImage imageNamed:@"yl_back"]];
        [_goLastWeakBtn addTarget:self action:@selector(goLastWeakBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goLastWeakBtn;
}
- (UIButton *)goNextWeakBtn{
    if (!_goNextWeakBtn) {
        _goNextWeakBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goNextWeakBtn newAnBtnWithImg:[UIImage imageNamed:@"yl_next"]];
        [_goNextWeakBtn addTarget:self action:@selector(goNextWeakBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goNextWeakBtn;
}
- (UILabel *)showWeakTitleLabel{
    if (!_showWeakTitleLabel) {
        _showWeakTitleLabel = [[UILabel alloc]init];
        _showWeakTitleLabel.font = [PensionThemeManager shareManager].Pension_TextFont_14;
        _showWeakTitleLabel.textColor = Y_ColorWith16FromRGB(0x2B2C2F);
        _showWeakTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _showWeakTitleLabel;
}

#pragma mark ====

- (NSMutableArray *)btnTitleArr{
    if (!_btnTitleArr) {
//        _btnTitleArr = [NSMutableArray arrayWithObjects: @"深睡时长:暂无", @"浅睡时长:暂无", @"梦醒时长:暂无", nil];
        _btnTitleArr = [NSMutableArray arrayWithObjects: @"深睡时长:", @"浅睡时长:", @"梦醒时长:", nil];
    }
    return _btnTitleArr;
}
#pragma mark == 上一周
- (void)goLastWeakBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(timeChangeWithLastWeak)]) {
        [_delegate timeChangeWithLastWeak];
    }
    
}
#pragma mark == 下一周
- (void)goNextWeakBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(timeChangeWithNextWeak)]) {
        [_delegate timeChangeWithNextWeak];
    }
}
@end
