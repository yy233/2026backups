//
//  IssuLastAddressCellSubBasePopView.m
//  Community
//
//  Created by 余莹 on 2021/1/23.
// 地址 列表 自定 popview

#import "IssuLastAddressCellSubBasePopView.h"
#import "IssuLastAddressCellSubBasePopViewSubTableViewCell.h"
#define  IssuLastAddressCellSubBasePopViewSubTableViewCell_Identifier    @"IssuLastAddressCellSubBasePopViewSubTableViewCell"
@interface IssuLastAddressCellSubBasePopView () <UITableViewDelegate,UITableViewDataSource>

//__________
@property (nonatomic,strong) UIView *grayBackView;
//top
@property (nonatomic,strong) UIImageView *topImgView;//top
//center
@property (nonatomic,strong) UITableView *tableView;
//bottom
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *okBtn;
@end

@implementation IssuLastAddressCellSubBasePopView
//
- (void)showInViewWithPopType:(IssuLastAddressCellSubBasePopView_Type)type
                withListArray:(NSMutableArray *)array{
    self.showDataArr = [[NSMutableArray alloc]init];
    //
    if (type==IssuLastAddressCellSubBasePopView_Type_Community) {
        //小区 id name
    }
    if (type==IssuLastAddressCellSubBasePopView_Type_Address) {
        //门牌相关  id  mergeName
    }
    self.selfType = type;
    for (int i = 0 ; i <array.count; i ++) {
        [self.chooseTypeSaveArr addObject:@(0)];
    }
    //
    [self showInView:self.superview thePopViewSubViewHeight:0 WithArray:array];
}
#pragma mark == 重写
- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr{
   _showDataArr = [[NSMutableArray alloc]initWithArray:dataSourceArr];
    [self.tableView reloadData];
}
- (void)changMainBackViewBackColor{
    self.subMainBackView.backgroundColor = [UIColor clearColor];//
}
- (void)initSubMainHeight{
    self.subMainViewHeight  = Screen_H;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubAllView];
        [self setUI];
    }
    return self;
}
#pragma mark ==
- (void)addSubAllView{
    [self.subMainBackView addSubview:self.grayBackView];//
    [self.subMainBackView addSubview:self.topImgView];//
    [self.grayBackView addSubview:self.tableView];
    [self.grayBackView addSubview:self.cancelBtn];
    [self.grayBackView addSubview:self.okBtn];
}
- (void)setUI{
    [_grayBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_grayBackView.superview).offset(16);
        make.right.equalTo(_grayBackView.superview).offset(-16);
        make.height.equalTo(_grayBackView.superview).multipliedBy(0.7);
        make.centerY.equalTo(_grayBackView.superview);
    }];
    //
    [_topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_grayBackView.mas_top).offset(-25);
        make.width.height.offset(50);
        make.centerX.equalTo(_grayBackView.mas_centerX);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview).insets(UIEdgeInsetsMake(50, 0, 80, 0));
    }];
    //
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cancelBtn.superview).offset(10);
        make.right.equalTo(_cancelBtn.superview.mas_centerX).offset(-5);
        make.height.offset(50);
        make.bottom.equalTo(_cancelBtn.superview.mas_bottom).offset(-20);
    }];
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(_cancelBtn);
        make.right.equalTo(_okBtn.superview.mas_right).offset(-10);
    }];
    //
}
#pragma mark ==

- (UIView *)grayBackView{
    if (!_grayBackView) {
        _grayBackView = [[UIView alloc]init];
        _grayBackView.backgroundColor = Color_245Gray;
        _grayBackView.layer.masksToBounds = YES;
        _grayBackView.layer.cornerRadius = 7.5;
    }
    return _grayBackView;
}
//
- (UIImageView *)topImgView{
    if (!_topImgView) {
        _topImgView = [[UIImageView alloc]init];
        _topImgView.image = [UIImage imageNamed:@"Chooseahouse_Wholerent"];
        _topImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _topImgView;
}
//
- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = Color_245Gray;
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 7.5;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
//
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn newAnBtnWithFont:[UIFont systemFontOfSize:15]];
        [_cancelBtn newAnBtnWithTextColor:Color_136GrayColor];
        [_cancelBtn newAnBtnWithBackColor:[UIColor clearColor]];
        [_cancelBtn newAnBtnWithTextStr:@"取消"];
        [_cancelBtn newAnBtnWithLayerCorNerNum:5 withLayerLineWidth:1 withLayerLineColor:Color_136GrayColor];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIButton *)okBtn{
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okBtn newAnBtnWithFont:[UIFont systemFontOfSize:15]];
        [_okBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_okBtn newAnBtnWithBackColor:Color_38BlueColor];
        [_okBtn newAnBtnWithTextStr:@"确认"];
        [_okBtn newAnBtnWithLayerCorNerNum:5 withLayerLineWidth:0 withLayerLineColor:[UIColor clearColor]];
        [_okBtn addTarget:self action:@selector(okBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
}
#pragma mark ==
- (NSMutableArray *)chooseTypeSaveArr{
    if (!_chooseTypeSaveArr) {
        _chooseTypeSaveArr = [[NSMutableArray alloc]init];
    }
    return _chooseTypeSaveArr;
}
- (NSMutableArray *)showDataArr{
    if (!_showDataArr) {
        _showDataArr = [[NSMutableArray alloc]init];
    }
    return _showDataArr;
}

#pragma mark ==
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isNil(self.showDataArr)) {
        return 0;
    }
    return self.showDataArr.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *sectionHeaderL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 50)];
    sectionHeaderL.backgroundColor = Color_245Gray;
    sectionHeaderL.textAlignment = NSTextAlignmentCenter;
    sectionHeaderL.font = [UIFont boldSystemFontOfSize:20];
    sectionHeaderL.textColor = [UIColor blackColor];
    if (self.selfType==IssuLastAddressCellSubBasePopView_Type_Community) {
        sectionHeaderL.text = @"选择社区发布";
    }
    if (self.selfType==IssuLastAddressCellSubBasePopView_Type_Address) {
        sectionHeaderL.text = @"选择房屋发布";
    }
    if (self.selfType==IssShopBuniessCommmunityAddressCellSubBasePopView_Type_CommunityAddress) {
        sectionHeaderL.text = @"选择商铺地址";
    }
    if (self.selfType==MyHouseListChangeShowHouseList_Type_House) {
        sectionHeaderL.text = @"选择切换的房屋";
    }
    return sectionHeaderL;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IssuLastAddressCellSubBasePopViewSubTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:IssuLastAddressCellSubBasePopViewSubTableViewCell_Identifier];
    if (!cell) {
        cell = [[IssuLastAddressCellSubBasePopViewSubTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssuLastAddressCellSubBasePopViewSubTableViewCell_Identifier];
    }
    cell.chooseBtn.selected = [self.chooseTypeSaveArr[indexPath.row] integerValue];
    if (self.selfType==IssuLastAddressCellSubBasePopView_Type_Community) {
        //小区
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.showDataArr[indexPath.row]];//dataShowSaveArr dataSourceArr
        cell.titleL.text = [TextShowWithModelStr textShowWithModelStr:dic[@"name"]];// [NSString stringWithFormat:@"%@",dic[@"name"]];//[TextShowWithModelStr textShowWithModelStr:dic[@"name"]]
        ;
    }
    if (self.selfType==IssuLastAddressCellSubBasePopView_Type_Address) {
        //门牌相关
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.showDataArr[indexPath.row]];
        cell.titleL.text = [TextShowWithModelStr textShowWithModelStr:dic[@"mergeName"]];// [NSString stringWithFormat:@"%@",dic[@"mergeName"]];
    }
    if (self.selfType==IssShopBuniessCommmunityAddressCellSubBasePopView_Type_CommunityAddress) {
        //商铺地址
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.showDataArr[indexPath.row]];
        cell.titleL.text =  [TextShowWithModelStr textShowWithModelStr:dic[@"name"]];//用的是当前区域所取的小区数据
    }
    if (self.selfType == MyHouseListChangeShowHouseList_Type_House) {
        //我的房屋 总的房间house列表数据 MyHouseRelationHouseModel ｜ 物业缴费也用这个popv列表类型
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.showDataArr[indexPath.row]];
        cell.titleL.text = [NSString stringWithFormat:@"%@ %@",[TextShowWithModelStr textShowWithModelStr:dic[@"communityText"]], [TextShowWithModelStr textShowWithModelStr:dic[@"houseSite"]]];
         
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //处理01数组数据
    for (int i = 0;  i < self.chooseTypeSaveArr.count; i ++) {
        if (i==indexPath.row) {//选中
            [self.chooseTypeSaveArr replaceObjectAtIndex:i withObject:@(1)];
        }else{//置0
            [self.chooseTypeSaveArr replaceObjectAtIndex:i withObject:@(0)];
        }
    }
    [tableView reloadData];
}
 
#pragma mark ===  btn action
- (void)cancelBtnAction{
    [self dismissThePopView];
}
- (void)okBtnAction{
    NSInteger i = [self.chooseTypeSaveArr indexOfObject:@(1)];
    if (i != NSNotFound) {
        if (_delegate && [_delegate respondsToSelector:@selector(okBtnWithChooseListCellWithPopType:withCellData:)]) {
            [_delegate okBtnWithChooseListCellWithPopType:self.selfType withCellData:self.showDataArr[i]];
        }
        [self dismissThePopView];
    }else{
        [self dismissThePopView];
    }
   
  
}
@end

