//
//  PopViewBuniessShopChooseShopStatus.m
//  Community
//
//  Created by 余莹 on 2021/1/21.
//

#import "PopViewBuniessShopChooseShopStatus.h"
#define  HeaderView_Height     50
@interface PopViewBuniessShopChooseShopStatus ()
@property (nonatomic,assign) NSInteger nowSelectedRowNum;
@end

@implementation PopViewBuniessShopChooseShopStatus

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self reUpMainViewMas];
    }
    return self;
}
- (void)reUpMainViewMas{
    self.tableView.layer.cornerRadius = 1;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.closeBtn setImage:<#(nullable UIImage *)#> forState:<#(UIControlState)#>]
}
#pragma mark == 重写

- (void)showInView:(UIView *)supview thePopViewTableViewHeight:(float)tableViewHeight WithArray:(NSMutableArray *)array withHeaderViewTitle:(NSString *)titleStr withNowShowRowNum:(NSInteger)showRowIndex{
    self.headertitleStr = titleStr;
    self.nowSelectedRowNum = showRowIndex;
    [self showInView:supview thePopViewTableViewHeight:tableViewHeight WithArray:array];
}
#pragma mark == header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HeaderView_Height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_W, HeaderView_Height)];
    headerLabel.font = [UIFont systemFontOfSize:14];
    headerLabel.backgroundColor = [UIColor whiteColor];
    headerLabel.text = self.headertitleStr;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    return headerLabel;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PopViewSubShopStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PopViewSubShopStatusCell"];
    if (!cell) {
        cell = [[PopViewSubShopStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PopViewSubShopStatusCell"];
    }
    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    cell.titleL.text = self.dataSource[indexPath.row];
    if (indexPath.row == self.nowSelectedRowNum) {
        cell.centerShowBtn.selected = YES;
        cell.titleL.textColor = Y_RGBA(38, 114, 249, 1);
    }else{
        cell.centerShowBtn.selected = NO;
        cell.titleL.textColor = [UIColor blackColor];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.nowSelectedRowNum = indexPath.row;
    [tableView reloadData];
    if ([self.delegate respondsToSelector:@selector(basePopViewTag:OfSubTableViewTouchWithIndexPath:)]) {
        [self dismissThePopView];
        [self.delegate basePopViewTag:0 OfSubTableViewTouchWithIndexPath:indexPath];//base=tag=0
    }
}

#pragma mark ==
- (NSInteger)nowSelectedRowNum{
    if (!_nowSelectedRowNum) {
        _nowSelectedRowNum = 0;
    }
    return _nowSelectedRowNum;
}
@end

#pragma mark ==== cell

@implementation PopViewSubShopStatusCell
 
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.centerShowBtn];
        [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleL.superview.mas_left);
            make.top.equalTo(_titleL.superview.mas_top);
            make.bottom.equalTo(_titleL.superview.mas_bottom);
            make.width.equalTo(_titleL.superview.mas_width).multipliedBy(0.55);
        }];
        [_centerShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleL.mas_right).offset(10);
            make.top.equalTo(_centerShowBtn.superview.mas_top);
            make.bottom.equalTo(_centerShowBtn.superview.mas_bottom);
            make.width.offset(20);
        }];
    }
    return self;
}
#pragma mark  ==
- (UIButton *)centerShowBtn{
    if (!_centerShowBtn) {
        _centerShowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_centerShowBtn setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
        [_centerShowBtn setTitleColor:Y_RGBA(38, 114, 249, 1)  forState:UIControlStateSelected];
        _centerShowBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        //
        [_centerShowBtn setImage:[UIImage imageNamed:@"Selectgroup_Select_night"] forState:UIControlStateSelected];
        [_centerShowBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:20];
    }
    return _centerShowBtn;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font =  [UIFont systemFontOfSize:16];
        _titleL.textAlignment = NSTextAlignmentRight;
    }
    return _titleL;
}
@end
