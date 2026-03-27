//
//  HouseRepairDetailShowHouseInfoTableViewCell.m
//  Community
//
//  Created by 余莹 on 2020/12/25.
//

#import "HouseRepairDetailShowHouseInfoTableViewCell.h"
@interface HouseRepairDetailShowHouseInfoTableViewCell () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *titleDataSource;
@property (nonatomic,strong) NSMutableArray *textDataSource;

@end

@implementation HouseRepairDetailShowHouseInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setDetailModel:(HouseRepairDetailModel *)detailModel{
    _detailModel = detailModel;
    self.titleLabel.text = @"房屋信息";
    self.textDataSource = [NSMutableArray arrayWithObjects:[TextShowWithModelStr textShowWithModelStr:detailModel.name],[TextShowWithModelStr textShowWithModelStr:detailModel.phone],[TextShowWithModelStr textShowWithModelStr:detailModel.typeName],[TextShowWithModelStr textShowWithModelStr:detailModel.address], nil];//house cell sub cell 4个元素
    [self.tableView reloadData];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView addSubview:self.tableView];
        [self setHouseInfoCellUI];
    }
    return  self;
}
#pragma mark == UI
- (void)setHouseInfoCellUI{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(10);
        make.bottom.equalTo(_tableView.superview.mas_bottom).offset(-10);
        make.left.equalTo(_tableView.superview.mas_left).offset(10);
        make.right.equalTo(_tableView.superview.mas_right).offset(-10);
    }];
}
#pragma mark == tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.textDataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HouseRepairDetailInfoCellSubTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRepairDetailInfoCellSubTextTableViewCell_Identifier];
    if (!cell) {
        cell = [[HouseRepairDetailInfoCellSubTextTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRepairDetailInfoCellSubTextTableViewCell_Identifier];
    }
    cell.titleLalel.text = self.titleDataSource[indexPath.row];
    cell.detailLalel.text = self.textDataSource[indexPath.row];
    return cell;
}
#pragma mark == getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}
- (NSMutableArray *)titleDataSource{
    if (!_titleDataSource) {
        _titleDataSource = [NSMutableArray arrayWithObjects:@"报修人",@"联系电话",@"报修类别",@"报修地址", nil];
    }
    return _titleDataSource;
}
- (NSMutableArray *)textDataSource{
    if (!_textDataSource) {
        _textDataSource = [[NSMutableArray alloc]init];
    }
    return _textDataSource;
}
@end
