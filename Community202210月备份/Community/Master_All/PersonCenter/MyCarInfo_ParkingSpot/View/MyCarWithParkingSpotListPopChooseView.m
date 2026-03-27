//
//  MyCarWithParkingSpotListPopChooseView.m
//  Community
//
//  Created by 余莹 on 2022/5/7.
//

#import "MyCarWithParkingSpotListPopChooseView.h"
#import "MyCarWithParkingSpotHeader.h"

@interface MyCarWithParkingSpotListPopChooseView ()

@end


@implementation MyCarWithParkingSpotListPopChooseView


- (void)tableViewOtherSet{
    self.closeBtn.hidden = YES;
    self.chooseSpotIndex = kChooseSpotIndexBaseI;
    self.tableView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;

}
- (void)thisPopViewHeaderOkBtnChangeColor{
    [self.headerVv.okBtn newAnBtnWithTextColor: Color_Blue];
}
- (MyCarWithParkingSpotListPopChooseViewSubHeaderView *)headerVv{
    if (!_headerVv) {
        _headerVv = [[MyCarWithParkingSpotListPopChooseViewSubHeaderView alloc]initWithFrame:CGRectZero];
        [_headerVv.okBtn addTarget:self action:@selector(okBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_headerVv.cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerVv;
}

#pragma mark == 重写
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerVv;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    CarInfoBaseModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text =  [TextShowWithModelStr textShowWithModelStr:model.carNumber];
    if (indexPath.row != self.chooseSpotIndex ) {
        cell.textLabel.textColor =   [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.4];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
    }else{
        cell.textLabel.textColor =   [ThemeManager shareManager].mainTextColor;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.chooseSpotIndex = indexPath.row;
    [tableView reloadData];
}

- (void)okBtnAction{
    if (self.chooseSpotIndex == kChooseSpotIndexBaseI) {
        [self dismissThePopView];
    }else{
        if ([self.delegate respondsToSelector:@selector(basePopViewTag:OfSubTableViewTouchWithIndexPath:)]) {
            [self.delegate basePopViewTag:0 OfSubTableViewTouchWithIndexPath: [NSIndexPath indexPathForRow:self.chooseSpotIndex inSection:0]];//self.tag
            [self dismissThePopView];
        }
    }
   
}
- (void)cancelBtnAction{
    [self dismissThePopView];
}


@end


@interface MyCarWithParkingSpotListPopChooseViewSubHeaderView ()

@end

@implementation MyCarWithParkingSpotListPopChooseViewSubHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, 50);
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;//父圆角换直角
        [self addSubview:self.centerL];
        [self addSubview:self.cancelBtn];
        [self addSubview:self.okBtn];
        [self setBaseUI];
        self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    }
    return self;
}

- (void)setBaseUI{
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cancelBtn.superview);
        make.top.bottom.equalTo(_cancelBtn.superview);
        make.width.offset(80);
    }];
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_okBtn.superview);
        make.top.bottom.equalTo(_okBtn.superview);
        make.width.offset(80);
    }];
    [_centerL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_centerL.superview);
        make.left.equalTo(_cancelBtn.mas_right);
        make.right.equalTo(_okBtn.mas_left);
    }];
    
}
#pragma mark ==
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn newAnBtnWithTextStr:@"取消"];
        [_cancelBtn newAnBtnWithTextColor:  [ThemeManager shareManager].mainTextColor ];
        [_cancelBtn newAnBtnWithFont: [UIFont boldSystemFontOfSize:15.0]];
    }
    return _cancelBtn;
}
- (UIButton *)okBtn{
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okBtn newAnBtnWithTextStr:@"确认"];
        [_okBtn newAnBtnWithTextColor:kParkingSpotColor_Green];
        [_okBtn newAnBtnWithFont: [UIFont boldSystemFontOfSize:15.0]];
    }
    return _okBtn;
}
- (UILabel *)centerL{
    if (!_centerL) {
        _centerL = [[UILabel alloc]init];
        _centerL.text = @"请选择";
        _centerL.textColor =  [ThemeManager shareManager].mainTextColor ;
        _centerL.font = [UIFont systemFontOfSize:15.0];
        _centerL.textAlignment = NSTextAlignmentCenter;
    }
    return _centerL;
}

@end



