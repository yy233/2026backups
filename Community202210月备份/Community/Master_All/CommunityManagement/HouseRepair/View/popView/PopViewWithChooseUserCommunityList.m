//
//  PopViewWithChooseUserCommunityList.m
//  Community
//
//  Created by 余莹 on 2021/4/1.
//

#import "PopViewWithChooseUserCommunityList.h"
#import "PopViewSubTableViewCell.h"
//@interface PopViewWithChooseUserCommunityList ()
//@property (nonatomic,strong) NSMutableArray *communityDataArr;
///**
// {
// id = 2;
// name = "\U8054\U60f3\U793e\U533a";
// },*/
//@end
//
//@implementation PopViewWithChooseUserCommunityList
//- (void)showViewWithfillDataArr:(NSMutableArray *)listArr{
////    [self showInView:self.superview thePopViewSubViewHeight:0 WithArray:@[].mutableCopy];
//    self.dataSource = listArr;
//    [self showInView:self.superview thePopViewTableViewHeight:0 WithArray:@[].mutableCopy];
//}
//#pragma mark == 重写
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
//    }
//    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;
//    NSDictionary *dic = self.dataSource[indexPath.row];
//    cell.textLabel.text = dic[@"name"];
//    return cell;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([self.delegate respondsToSelector:@selector(basePopViewTag:OfSubTableViewTouchWithIndexPath:)]) {
//        [self dismissThePopView];
//        [self.delegate basePopViewTag:0  OfSubTableViewTouchWithIndexPath:indexPath];
//    }
//}
//
 
#define   PopViewSubTableViewCell_Identifier   @"PopViewSubTableViewCell"

@interface PopViewWithChooseUserCommunityList () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIView *grayBackView;
//top
@property (nonatomic,strong) UIImageView *topImgView;//top
//center
@property (nonatomic,strong) UITableView *tableView;
//bottom
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *okBtn;
@end

@implementation PopViewWithChooseUserCommunityList
//
- (void)showInViewWithPopType:(RepairHousesPopView_Type)type
                withListArray:(NSMutableArray *)listArr{
    self.showDataArr = [[NSMutableArray alloc]init];
    //
    if (type==RepairHousesPopView_Type_Community) {
        //小区 id name
    }
    if (type==RepairHousesPopView_Type_House) {
        //房屋  id
    }
    self.selfType = type;
    for (int i = 0 ; i <listArr.count; i ++) {
        [self.chooseTypeSaveArr addObject:@(0)];
    }
    //
    [self showInView:self.superview thePopViewSubViewHeight:0 WithArray:listArr];
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
    if (self.selfType==RepairHousesPopView_Type_Community) {
        sectionHeaderL.text = @"选择社区";
    }
    if (self.selfType==RepairHousesPopView_Type_House) {
        sectionHeaderL.text = @"选择房屋";
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
    PopViewSubTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:PopViewSubTableViewCell_Identifier];
    if (!cell) {
        cell = [[PopViewSubTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PopViewSubTableViewCell_Identifier];
    }
    cell.chooseBtn.selected = [self.chooseTypeSaveArr[indexPath.row] integerValue];
    if (self.selfType==RepairHousesPopView_Type_Community) {
        //小区
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.showDataArr[indexPath.row]];//dataShowSaveArr dataSourceArr
        cell.titleL.text = [TextShowWithModelStr textShowWithModelStr:dic[@"name"]];//id name
       
    }
    if (self.selfType==RepairHousesPopView_Type_House) {
        //房屋 门牌
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.showDataArr[indexPath.row]];
        NSString *communityName = [[dic allKeys]containsObject:@"communityName"] ? dic[@"communityName"] : @"";
        NSString *address = [[dic allKeys]containsObject:@"address"] ? dic[@"address"] : @"";
        cell.titleL.text =  [communityName stringByAppendingString:address];
        
        /**
         address = "2\U680b2\U5355\U51431\U5c422-2-1-1-11";
         buildingId = 4;
         communityId = 2;
         communityName = "\U8054\U60f3\U793e\U533a";
         id = 115;
         idStr = 115;
         owner =
         */
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
        if (_delegate && [_delegate respondsToSelector:@selector(popViewChooseCommunityOrHouseListCellWithPopType:withCellData:)]) {
            [_delegate popViewChooseCommunityOrHouseListCellWithPopType:self.selfType  withCellData:self.showDataArr[i]];
        }
        [self dismissThePopView];
    }else{
        [self dismissThePopView];
    }
   
  
}
@end
