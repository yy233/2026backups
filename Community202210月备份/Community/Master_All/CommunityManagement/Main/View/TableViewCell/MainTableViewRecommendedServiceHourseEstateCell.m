//
//  MainTableViewRecommendedServiceHourseEstateCell.m
//  Community
//
//  Created by 余莹 on 2020/11/24.
//
#define BTN_TAG_HOUSEESTATE_CELL_SUBVIEW 340
#import "MainTableViewRecommendedServiceHourseEstateCell.h"
#import "MainRecommendedServiceHourseEstateModel.h"
//#define Color_Before_PurpleColor  Y_RGB(115, 108, 186)
#define Color_Before_PurpleColor  Y_RGB(125, 125, 186)
#define Color_End_PurpleColor Y_RGB(60, 73, 137)

#define Height_TableView (140)
@interface MainTableViewRecommendedServiceHourseEstateCell () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIButton *rentHouseBtn;
@property (nonatomic,strong) UIButton *resaleHouseBtn;
@property (nonatomic,strong) UITableView *tableView;
 
@end
@implementation MainTableViewRecommendedServiceHourseEstateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr{//MainRecommendedServiceHourseEstateModel
    _dataSourceArr = dataSourceArr;
    [self.tableView reloadData];
}
#pragma mark == tbn
- (void)btnTouchAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(cellHourseEstateSubBtnTouchIndex:)]) {
        [_delegate cellHourseEstateSubBtnTouchIndex:(sender.tag-BTN_TAG_HOUSEESTATE_CELL_SUBVIEW)];
    }
}
#pragma mark ===
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.rentHouseBtn];
        [self.contentView addSubview:self.resaleHouseBtn];
        [self.contentView addSubview:self.tableView];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_rentHouseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rentHouseBtn.superview.mas_left);
        make.top.equalTo(_rentHouseBtn.superview.mas_top).offset(5);
        make.height.equalTo(_rentHouseBtn.superview.mas_height).multipliedBy(0.43);
        make.width.equalTo(_rentHouseBtn.mas_height);
    }];
    [_resaleHouseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rentHouseBtn.mas_left);
        make.height.equalTo(_rentHouseBtn.mas_height);
        make.width.equalTo(_rentHouseBtn.mas_width);
        make.bottom.equalTo(_tableView.superview.mas_bottom).offset(-5);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_tableView.superview.mas_right);
        make.left.equalTo(_rentHouseBtn.mas_right).offset(10);
        make.top.equalTo(_tableView.superview.mas_top).offset(5);
        make.bottom.equalTo(_tableView.superview.mas_bottom).offset(-5);
    }];
}
#pragma mark ===
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataSourceArr.count>0) {
        return _dataSourceArr.count;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Height_TableView/4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Height_TableView/4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:13];
    if (_dataSourceArr.count>0) {
        MainRecommendedServiceHourseEstateModel *model = _dataSourceArr[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld.%@",(long)indexPath.row+1,[TextShowWithModelStr textShowWithModelStr:model.houseTitle]];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%ld、小区楼盘基本信息介绍...",(long)indexPath.row+1];
    }
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"最新消息";
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.backgroundView = [UIView new];
    headerView.textLabel.backgroundColor = [UIColor clearColor];
    headerView.textLabel.font = [UIFont boldSystemFontOfSize:14];
    headerView.textLabel.textColor = [UIColor whiteColor];
    headerView.textLabel.textAlignment = NSTextAlignmentLeft;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataSourceArr.count>0) {
        if (_delegate && [_delegate respondsToSelector:@selector(cellHourseEstateSubTableViewTouchIndexPath:)]) {
            [_delegate cellHourseEstateSubTableViewTouchIndexPath:indexPath];
        }
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(cellHourseEstateSubTableViewTouchIndexPath:)]) {
//            [_delegate cellHourseEstateSubTableViewTouchIndexPath:indexPath];//测试 未有数据
        }
    }
}

#pragma mark ===
- (UIButton *)rentHouseBtn{
    if (!_rentHouseBtn) {
        _rentHouseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rentHouseBtn.layer.cornerRadius = 5;
        _rentHouseBtn.layer.masksToBounds = YES;
        [_rentHouseBtn setTitle:@"租房" forState:UIControlStateNormal];//租房
        _rentHouseBtn.tag = BTN_TAG_HOUSEESTATE_CELL_SUBVIEW+MainCellRecommendedServiceHourse_Type_RentHouse;
        [_rentHouseBtn addTarget:self action:@selector(btnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        [_rentHouseBtn setBackgroundImage:[UIImage imageNamed:@"Convenientservice_Renting_night"] forState:UIControlStateNormal];
        //
        _rentHouseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _rentHouseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _rentHouseBtn.titleEdgeInsets = UIEdgeInsetsMake(-25, 8, 0, 0);//tlbr
    }
    return _rentHouseBtn;
}
- (UIButton *)resaleHouseBtn{
    if (!_resaleHouseBtn) {
        _resaleHouseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resaleHouseBtn.layer.cornerRadius = 5;
        _resaleHouseBtn.layer.masksToBounds = YES;
        [_resaleHouseBtn setTitle:@"转让" forState:UIControlStateNormal];//商铺
        _resaleHouseBtn.tag = BTN_TAG_HOUSEESTATE_CELL_SUBVIEW+MainCellRecommendedServiceHourse_Type_BusinessShop;
        [_resaleHouseBtn addTarget:self action:@selector(btnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        [_resaleHouseBtn setBackgroundImage:[UIImage imageNamed:@"Convenientservice_Assignment_night"] forState:UIControlStateNormal];
        //调整文字距离边距的距离
        _resaleHouseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _resaleHouseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _resaleHouseBtn.titleEdgeInsets = UIEdgeInsetsMake(-25, 8, 0, 0);//tlbr
        
    }
    return _resaleHouseBtn;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];// UITableViewStylePlain
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.layer.cornerRadius = 5;
        _tableView.layer.masksToBounds = YES;
        _tableView.backgroundColor = [UIColor y_colorGradientChangeWithSize:CGSizeMake(Screen_W*0.8, 200) direction:IHGradientChangeDirectionLevel startColor:Color_Before_PurpleColor endColor:Color_End_PurpleColor];
    }
    return _tableView;
}
@end
