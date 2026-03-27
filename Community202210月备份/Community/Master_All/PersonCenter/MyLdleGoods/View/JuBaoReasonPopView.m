//
//  JuBaoReasonPopView.m
//  Community
//
//  Created by 余莹 on 2022/6/11.
//

#import "JuBaoReasonPopView.h"

@implementation JuBaoReasonPopView


- (void)tableViewOtherSet{
    self.closeBtn.hidden = YES;
    self.tableView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    self.tableView.layer.cornerRadius = 0.1;
}
 
 
#pragma mark == 重写
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    JuBaoReasonPopViewSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JuBaoReasonPopViewSubCell"];
    if (!cell) {
        cell = [[JuBaoReasonPopViewSubCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"JuBaoReasonPopViewSubCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    }
    if (indexPath.row == 0 ) {
        cell.oneL.text =  @"违禁商品";
        cell.twoL.text =  @"国家明令禁止销售的商品与特殊服务";
    }else{
        cell.oneL.text =  @"滥发消息";
        cell.twoL.text =  @"包含夸大宣传，价格引流";
    }
    return cell;
}
@end

#pragma mark ====

@implementation JuBaoReasonPopViewSubCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        self.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self.contentView addSubview:self.oneL];
        [self.contentView addSubview:self.twoL];
        [self setUserInfoUI];
    }
    return self;
}
- (void)setUserInfoUI{
    [_oneL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_oneL.superview);
        make.height.offset(20);
        make.bottom.equalTo(_oneL.superview.mas_centerY);
    }];
    [_twoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_twoL.superview);
        make.height.offset(20);
        make.top.equalTo(_twoL.superview.mas_centerY);
    }];
}

- (UILabel *)oneL{
    if (!_oneL) {
        _oneL = [[UILabel alloc]init];
        _oneL.textAlignment = NSTextAlignmentCenter;
        _oneL.font = [UIFont systemFontOfSize:14.0];
        _oneL.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _oneL;
}
- (UILabel *)twoL{
    if (!_twoL) {
        _twoL = [[UILabel alloc]init];
        _twoL.textAlignment = NSTextAlignmentCenter;
        _twoL.font = [UIFont systemFontOfSize:13.0];
        _twoL.textColor = [ThemeManager shareManager].detailTextColor;
    }
    return _twoL;
}


@end

