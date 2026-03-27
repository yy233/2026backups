//
//  IssueBaseSubBlueBtnsViewTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/19.
//

#import "IssueBaseSubBlueBtnsViewTableViewCell.h"
#define Color_subBtn_blue     Y_RGBA(38, 114, 249, 1)
#define H_SubBtn              32
#define Tag_SubBtn            300
@interface IssueBaseSubBlueBtnsViewTableViewCell ()
@property (nonatomic,strong) NSMutableArray *dataSourceModelArr;
@property (nonatomic,assign) Cell_type_BlueBtn type;
//0305
@property (nonatomic,assign) BOOL isOneChooseType;//是否单选type (装修情况 18， @"室友性别 20 )————————单选
@end

@implementation IssueBaseSubBlueBtnsViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)showSubBtnWithDataSourceArr:(NSMutableArray *)subBtnDataSourceArr andCellType:(Cell_type_BlueBtn)type{
    self.type = type;
    if (self.type == Cell_type_BlueBtn_HouseAllType24 ||self.type == Cell_type_BlueBtn_HouseAllType23 || self.type == Cell_type_BlueBtn_HouseAllType22 || self.type == Cell_type_BlueBtn_HouseAllType21 || self.type == Cell_type_BlueBtn_HouseAllType20 || self.type == Cell_type_BlueBtn_HouseAllType19 || self.type == Cell_type_BlueBtn_HouseAllType18 || self.type == Cell_type_BlueBtn_HouseAllType13 ||self.type == Cell_type_BlueBtn_HouseAllType12 ||self.type == Cell_type_BlueBtn_HouseAllType11) {//房屋
        self.dataSourceModelArr =  subBtnDataSourceArr;//已经是model了 IssueHouseCellBlueSubBtnCellModel
        [self markBackViewAddSubView];
    }else{//商铺
        self.dataSourceModelArr =  [NSMutableArray arrayWithArray:[IssueBuniessShopTagsModel mj_objectArrayWithKeyValuesArray:subBtnDataSourceArr]];
        [self markBackViewAddSubView];
    }
    [self initSelfIsOneChoose];
  
}
//初始化是否单选type
- (void)initSelfIsOneChoose{
    if (self.type == Cell_type_BlueBtn_HouseAllType18 || self.type == Cell_type_BlueBtn_HouseAllType20 || self.type == Cell_type_BlueBtn_HouseAllType14) {//(装修是否豪华等情况 18， @"室友性别 20) 日期类型单选
        self.isOneChooseType = YES;
    }else{
        self.isOneChooseType = NO;
    }
}
//_______已选状态的btn
- (void)cellShowBtnTypeWithSelectedIndexArr:(NSMutableArray *)selectedIndexArr{
    if (self.isOneChooseType) {//单选
    }else{//多选
    }
    for (UIButton *subB in  self.subBtnsBackV.subviews) {
        if ([selectedIndexArr containsObject:@(subB.tag-Tag_SubBtn)]) {
            subB.selected = YES;
        }else{
            subB.selected = NO;
        }
    }
}
#pragma mark===

- (void)subBtnAction:(UIButton *)sender{
    NSInteger index = sender.tag - Tag_SubBtn;
    NSLog(@"subBtnAction == %ld", index);
    if (self.isOneChooseType) {//单选
        NSMutableArray *selectedTypeBtnIndexSaveArr = [[NSMutableArray alloc]init];
        [selectedTypeBtnIndexSaveArr addObject:@(sender.tag-Tag_SubBtn)];//单选的数据 只一个元素
        if (_delegate && [_delegate respondsToSelector:@selector(cellTouchSubBlueBtnWithIndexArr:andCellType:)]) {
            [_delegate cellTouchSubBlueBtnWithIndexArr:selectedTypeBtnIndexSaveArr andCellType:self.type];
        }
        //单选的UI更新
        [self reNewUI:sender];
    }else{
        [self getSelectedTypeNewUIIndexArr:sender];//多选
    }
}
//单选
- (void)reNewUI:(UIButton *)sender{
    for (UIButton *subB in    sender.superview.subviews) {
        if (subB.tag == sender.tag) {
            subB.selected = YES;
        }else{
            subB.selected = NO;
        }
    }
}
////多选
- (void)getSelectedTypeNewUIIndexArr:(UIButton *)sender{
    sender.selected = !sender.selected;
    NSMutableArray *selectedTypeBtnIndexSaveArr = [[NSMutableArray alloc]init];
    for (UIButton *subB in    sender.superview.subviews) {
        if (subB.selected == YES) {
            [selectedTypeBtnIndexSaveArr addObject:@(subB.tag-Tag_SubBtn)];
        }
    }
    //
    if (_delegate && [_delegate respondsToSelector:@selector(cellTouchSubBlueBtnWithIndexArr:andCellType:)]) {
        [_delegate cellTouchSubBlueBtnWithIndexArr:selectedTypeBtnIndexSaveArr andCellType:self.type];
    }
    
}
- (void)markBackViewAddSubView{
    [self.subBtnsBackV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger count  =  self.dataSourceModelArr.count;
    if (count>=6) {
//        count = 6;//限制数量  不限制
    }
    float subAllW = 0;//总宽度 （已经使用的btns+各自间距总宽==subAllW）
    float subThisSectionW = 0; //当前行 num
    float subbecomeBigW = 10; //文本左右各5宽度 算入btn总宽
    float subJianGeW = 10;//间距
    float subJianGeH = 10;//间距
    for (int  i=0; i <count; i ++) {
        UIButton *btn = [self baseBtn];
        btn.tag = i + Tag_SubBtn;
        //
        float subBtnWidth = 0;
        if (self.type == Cell_type_BlueBtn_HouseAllType24 ||self.type == Cell_type_BlueBtn_HouseAllType23 ||self.type == Cell_type_BlueBtn_HouseAllType22 || self.type == Cell_type_BlueBtn_HouseAllType21 || self.type == Cell_type_BlueBtn_HouseAllType20 || self.type == Cell_type_BlueBtn_HouseAllType19 || self.type == Cell_type_BlueBtn_HouseAllType18 || self.type == Cell_type_BlueBtn_HouseAllType13 ||self.type == Cell_type_BlueBtn_HouseAllType12 ||self.type == Cell_type_BlueBtn_HouseAllType11) {
            IssueHouseCellBlueSubBtnCellModel *model = self.dataSourceModelArr[i];
            [btn setTitle:[TextShowWithModelStr textShowWithModelStr:model.houseConstName] forState:UIControlStateNormal];
            subBtnWidth =  [Tool getTextWidthWhenOneLineWithTextStr:[TextShowWithModelStr textShowWithModelStr:model.houseConstName] withFont:[UIFont systemFontOfSize:14]] + subbecomeBigW;
        }else{
            IssueBuniessShopTagsModel *model = self.dataSourceModelArr[i];
            [btn setTitle:[TextShowWithModelStr textShowWithModelStr:model.houseConstName] forState:UIControlStateNormal];
            subBtnWidth =  [Tool getTextWidthWhenOneLineWithTextStr:[TextShowWithModelStr textShowWithModelStr:model.houseConstName] withFont:[UIFont systemFontOfSize:14]] + subbecomeBigW;
        }
        if (subBtnWidth<H_SubBtn) {//单字+10的总宽度不够圆角的扩大宽度
            subBtnWidth = H_SubBtn;//正圆
        }
//        if ((subAllW+subBtnWidth)>(Screen_W-32-subJianGeW*3)) {//大约3个分隔 取3个分隔的冗余=-----有bug 上下行区分不开会重叠且右边站不完全
//        if ((subAllW+subBtnWidth)>(Screen_W-32-subJianGeW*1)) {//1分隔 取个最后一个分隔的冗余 （subAllW+当前要加的btn_w即将要使用的） > (剩余可使用 即宽度总宽-最后一个间隔空间)则换行
//        if ((Screen_W-32)-(subAllW+subBtnWidth)<(subJianGeW*1)*0.5) {//1分隔 取个最后一个分隔的冗余 （subAllW+当前要加的btn_w即将要使用的） > (剩余可使用 即宽度总宽-最后一个间隔空间)则换行 0。5个间隔冗余
         if ((Screen_W-32)-(subAllW+subBtnWidth)<0) {//0分隔  【总宽度-（已使用的subAllW+当前要加的btn_w即将要使用的）】< 0 则换行
//            NSInteger hangNum = (subAllW+subBtnWidth) / (Screen_W-32);//第几行
//            NSInteger hangNumYue = (subAllW+subBtnWidth) - hangNum*(Screen_W-32);//余数
            NSInteger hangNum = (subAllW+subBtnWidth+subJianGeW*1) / (Screen_W-32);//第几行
            NSInteger hangNumYue = (subAllW+subBtnWidth+subJianGeW*1) - hangNum*(Screen_W-32);//余数
            if (hangNumYue<=subBtnWidth) {
                //新行 换一行
                subThisSectionW = 0;
            }
            //
            btn.frame = CGRectMake(subThisSectionW,hangNum*(H_SubBtn+subJianGeH), subBtnWidth, H_SubBtn);
            //
            subThisSectionW = subThisSectionW + subJianGeW +subBtnWidth;
            subAllW = subAllW + subJianGeW + subBtnWidth;//总 当前行width 更新用于下一个
        }else{
   
            btn.frame = CGRectMake(subAllW, 0, subBtnWidth, H_SubBtn);
            subAllW = subAllW + subJianGeW + subBtnWidth;
        }
        [self.subBtnsBackV addSubview:btn];
    }
}
//
- (UIButton *)baseBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:Color_subBtn_blue] forState:UIControlStateSelected];
    btn.layer.cornerRadius = H_SubBtn*0.5;
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5].CGColor;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    return btn;
}
#pragma mark ==
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        [self.contentView addSubview:self.titelL];
        [self.contentView addSubview:self.subBtnsBackV];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titelL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titelL.superview.mas_left).offset(16);
        make.top.equalTo(_titelL.superview.mas_top).offset(5);
        make.right.equalTo(_titelL.superview.mas_right).offset(-16);
        make.height.offset(20);
    }];
    [_subBtnsBackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titelL.mas_bottom).offset(5);
        make.left.equalTo(_titelL.mas_left);
        make.right.equalTo(_titelL.mas_right);
        make.bottom.equalTo(_subBtnsBackV.superview.mas_bottom).offset(-5);
    }];
}
#pragma mark ==
#pragma mark ==
- (UILabel *)titelL{
    if (!_titelL) {
        _titelL = [[UILabel alloc]init];
        _titelL.font = [UIFont systemFontOfSize:15.f];
        _titelL.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _titelL;
}
- (UIView *)subBtnsBackV{
    if (!_subBtnsBackV) {
        _subBtnsBackV = [[UIView alloc]init];
    }
    return _subBtnsBackV;
}

#pragma mark == 是否单选
-  (BOOL)isOneChooseType{
    if (!_isOneChooseType) {
        _isOneChooseType = NO;
    }
    return _isOneChooseType;
}
@end
