//
//  MyOrderDetailVcTopBtnsTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/7.
//

#import "MyOrderDetailVcTopBtnsTableViewCell.h"

@interface MyOrderDetailVcTopBtnsTableViewCell ()
@property (nonatomic,assign)  MyOrderListCell_Type cellType;
@end

@implementation MyOrderDetailVcTopBtnsTableViewCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.backView.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        }];
        [self.backView addSubview:self.btnsBackV];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_btnsBackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_btnsBackV.superview);
        make.bottom.right.left.equalTo(_btnsBackV.superview);
    }];
}

- (UIView *)btnsBackV{
    if (!_btnsBackV) {
        _btnsBackV = [[UIView alloc]init];
    }
    return _btnsBackV;
}

- (void)fillBtnsWithArr:(NSMutableArray *)btnTitleArr andImgNameArr:(NSMutableArray *)imgNameArr whitType:(MyOrderListCell_Type)type{
    self.cellType = type;
    //
    float btnW = ((Screen_W-32)/btnTitleArr.count);
    for (int i = 0; i < btnTitleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*btnW, 5, btnW, 40);//
//        [btn newAnBtnWithImg:[UIImage imageNamed:@"Tobepaid_cancellationoforder"]];//占
        [btn newAnBtnWithTextStr:btnTitleArr[i]];
        [btn newAnBtnWithFont:FontSize_Orders_Nomail(12)];
        if (i==1) {
            [btn newAnBtnWithTextColor:Color_38BlueColor];
        }else{
            [btn newAnBtnWithTextColor:Color_51BlackColor];
        }
     
        [btn newAnBtnWithImg:[UIImage imageNamed:imgNameArr[i]]];
        btn.tag = 200+i;
        [btn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:1];//
        [self.btnsBackV addSubview:btn];
    }
}
- (void)subBtnAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(topBtncellType:subBtnTouchBtnIndex:)]) {
        [_delegate topBtncellType:self.cellType subBtnTouchBtnIndex:(sender.tag-200)];
    }
}
@end
