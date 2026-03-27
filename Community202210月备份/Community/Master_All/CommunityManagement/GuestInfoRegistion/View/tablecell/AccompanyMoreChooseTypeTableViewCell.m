//
//  AccompanyMoreChooseTypeTableViewCell.m
//  Community
//。访客随行的车辆cell和人员cell 多选的情况cell 
//  Created by 余莹 on 2020/12/10.
//

#import "AccompanyMoreChooseTypeTableViewCell.h"

#define Tag_EdiBtn_Person 500
#define Tag_EdiBtn_Car 600
#define Tag_SelectedType_Person 700
#define Tag_SelectedType_Car 800

@interface AccompanyMoreChooseTypeTableViewCell ()
@property (nonatomic,strong) UIButton *moreChooseRightBtn;
@end
@implementation AccompanyMoreChooseTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma  mark ==
//多选状态的cell 取消选择的btn一直为隐藏状态
- (void)isSelectedType{
    self.isSelectedTypeBtn.hidden = YES;
    self.moreChooseRightBtn.selected = YES;
}
- (void)isNomailType{
    self.isSelectedTypeBtn.hidden = YES;
    self.moreChooseRightBtn.selected = NO;
}
#pragma  mark ==
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor  = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self.backGroundV addSubview:self.moreChooseRightBtn];
        [self setMoreBtnUI];
    }
    return self;
}

- (void)setMoreBtnUI{
    [_moreChooseRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.editorBtn);
    }];
    self.editorBtn.hidden = YES;//多选状态的cell 没有编辑按钮
}

- (void)moreChooseRightBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (self.editorBtn.tag == Tag_EdiBtn_Person) {
        if (_moreChooseTypeCellDelegate && [_moreChooseTypeCellDelegate respondsToSelector:@selector(cellIsMoreChooseTypeChooseBtnActionIsSelected:WithPersonModel:)]) {
            [_moreChooseTypeCellDelegate cellIsMoreChooseTypeChooseBtnActionIsSelected:sender.selected WithPersonModel:self.personModel];
        }
    }
    if (self.editorBtn.tag == Tag_EdiBtn_Car) {
        if (_moreChooseTypeCellDelegate && [_moreChooseTypeCellDelegate respondsToSelector:@selector(cellIsMoreChooseTypeChooseBtnActionIsSelected:WithCarModel:)]) {
            [_moreChooseTypeCellDelegate cellIsMoreChooseTypeChooseBtnActionIsSelected:sender.selected WithCarModel:self.carModel];
        }
    }
}

#pragma mark == //多选 右边的圆
- (UIButton *)moreChooseRightBtn{
    if (!_moreChooseRightBtn) {
        _moreChooseRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreChooseRightBtn.layer.cornerRadius = 15;//50h 30w
        _moreChooseRightBtn.layer.masksToBounds = YES;
        _moreChooseRightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        [_moreChooseRightBtn setTitle:@"没有选" forState:UIControlStateNormal];
//        [_moreChooseRightBtn setTitle:@"已选" forState:UIControlStateSelected];
        //20210225改 
        [_moreChooseRightBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"Checkbox_night"] selectedImg:[UIImage imageNamed:@"Checkbox_Orange"]];
        [_moreChooseRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_moreChooseRightBtn addTarget:self action:@selector(moreChooseRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _moreChooseRightBtn.selected = YES;//已选状态
    }
    return _moreChooseRightBtn;
}

@end
