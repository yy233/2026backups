//
//  UserCertificationBtnTableViewCell.m
//  Community
//
//  Created by 余莹 on 2020/11/23.
//
#define cerCellBtn_W (Screen_W/3-20)-20
#define cerCellBtn_H 40
#define cerCellBtn_Max_W ((Screen_W-32)/3)
#define cerCellBtn_Max_H 50
#define cerCellBtn_OneLine_MaxNum 3

#define Choose_Gender_Cell__Btn_TAG 200
#define Choose_CarType_Cell__Btn_TAG 300


#import "UserCertificationBtnTableViewCell.h"
@interface UserCertificationBtnTableViewCell ()
@property (nonatomic,strong) UIView *btnBackView;
@property (nonatomic,strong) UILabel *titleL;
 
@property (nonatomic,strong) NSMutableArray *genderTitleArr;
@property (nonatomic,strong) NSMutableArray *carTypeTitleArr;

@end

@implementation UserCertificationBtnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)cellBtnAction:(UIButton *)sender{
    NSLog(@"cellBtnAction===");
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withNumber:(NSInteger)btnNumber{

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.btnBackView];
        [self setUI];
        
        if (btnNumber == 3) {
            self.titleL.text = @"性别";
            for (int i = 0; i < btnNumber; i++) {
                UIButton *newBtn = [self newBtn];
                newBtn.tag = Choose_Gender_Cell__Btn_TAG+i;
                CGFloat x = (i%cerCellBtn_OneLine_MaxNum)*cerCellBtn_Max_W;
                CGFloat y = (i/cerCellBtn_OneLine_MaxNum)*cerCellBtn_Max_H +5;
                newBtn.frame = CGRectMake(x, y, cerCellBtn_W, cerCellBtn_H);
                [newBtn addTarget:self.superview action:@selector(cellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [newBtn addTarget:self action:@selector(cellBtnActionChangeSelected:) forControlEvents:UIControlEventTouchUpInside];
                [newBtn setTitle:self.genderTitleArr[i]  forState:UIControlStateNormal];
                [self.btnBackView addSubview:newBtn];
            }
        }else{
            self.titleL.text = @"车辆类型";
            for (int i = 0; i < btnNumber; i++) {
                UIButton *newBtn = [self newBtn];
                newBtn.tag = Choose_CarType_Cell__Btn_TAG+i;
                CGFloat x = (i%cerCellBtn_OneLine_MaxNum)*cerCellBtn_Max_W;
                CGFloat y = (i/cerCellBtn_OneLine_MaxNum)*cerCellBtn_Max_H +5;
                newBtn.frame = CGRectMake(x, y, cerCellBtn_W, cerCellBtn_H);
                [newBtn addTarget:self.superview action:@selector(cellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [newBtn addTarget:self action:@selector(cellBtnActionChangeSelected:) forControlEvents:UIControlEventTouchUpInside];
                [newBtn setTitle:self.carTypeTitleArr[i] forState:UIControlStateNormal];
                [self.btnBackView addSubview:newBtn];
            }
        }
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview.mas_top).offset(5);
        make.left.equalTo(_titleL.superview.mas_left).offset(16);
        make.right.equalTo(_titleL.superview.mas_right).offset(-16);
        make.height.offset(20);
    }];
    [_btnBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_bottom);
        make.left.equalTo(_titleL.mas_left);
        make.right.equalTo(_titleL.mas_right);
        make.bottom.equalTo(_btnBackView.superview.mas_bottom).offset(-5);
    }];
}
- (void)cellBtnActionChangeSelected:(UIButton *)sender{
    NSLog(@"cellBtnActionChangeSelected==");
    sender.selected = !sender.selected;
    for (int i = 0; i<self.btnBackView.subviews.count; i++) {
        UIView *subV = self.btnBackView.subviews[i];
        if ([subV isKindOfClass:[UIButton class]] && (subV.tag != sender.tag)) {
           UIButton *thisBtn =  (UIButton *)subV;
            if (thisBtn.selected == YES) {
                thisBtn.selected = !sender.selected;
            }
        }
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
}
- (void)setNumberOfBtn:(NSInteger)numberOfBtn{
    if (numberOfBtn == 3) {
        for (int i = 0; i < numberOfBtn; i++) {
            UIButton *newBtn = [self newBtn];
            newBtn.tag = Choose_Gender_Cell__Btn_TAG+i;
            CGFloat x = (i%cerCellBtn_OneLine_MaxNum)*cerCellBtn_Max_W +20;
            CGFloat y = (i/cerCellBtn_OneLine_MaxNum)*cerCellBtn_Max_H +10;
            newBtn.frame = CGRectMake(x, y, cerCellBtn_W, cerCellBtn_H);
            [newBtn addTarget:self.superview action:@selector(cellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [newBtn addTarget:self action:@selector(cellBtnActionChangeSelected:) forControlEvents:UIControlEventTouchUpInside];
            [newBtn setTitle:self.genderTitleArr[i]  forState:UIControlStateNormal];
            [self.contentView addSubview:newBtn];
        }

        
    }else{
        for (int i = 0; i < numberOfBtn; i++) {
            UIButton *newBtn = [self newBtn];
            newBtn.tag = Choose_CarType_Cell__Btn_TAG+i;
            CGFloat x = (i%cerCellBtn_OneLine_MaxNum)*cerCellBtn_Max_W +20;
            CGFloat y = (i/cerCellBtn_OneLine_MaxNum)*cerCellBtn_Max_H +10;
            newBtn.frame = CGRectMake(x, y, cerCellBtn_W, cerCellBtn_H);
            [newBtn addTarget:self.superview action:@selector(cellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [newBtn addTarget:self action:@selector(cellBtnActionChangeSelected:) forControlEvents:UIControlEventTouchUpInside];
            [newBtn setTitle:self.carTypeTitleArr[i] forState:UIControlStateNormal];
            [self.contentView addSubview:newBtn];
        }
    }
}
- (UIButton *)newBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor blueColor]] forState:UIControlStateSelected];
    btn.layer.borderColor = [UIColor grayColor].CGColor;
    btn.layer.borderWidth = 1;
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    btn.clipsToBounds = YES;
    return  btn;
    
//    btn.layer.shadowOffset = CGSizeMake(1, 10);
//    btn.layer.shadowOpacity = 0.7;
//    btn.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    
    /**
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(10, 10);
    layer.shadowOpacity = 0.7;
    layer.cornerRadius = 5;
    [self.contentView.layer addSublayer:layer];

     */
}

- (NSMutableArray *)genderTitleArr{
    if (!_genderTitleArr) {
        _genderTitleArr = [NSMutableArray arrayWithObjects:@"男",@"女",@"不明",@"",@"",@"",@"", nil];
    }
    return _genderTitleArr;
}
- (NSMutableArray *)carTypeTitleArr{
    if (!_carTypeTitleArr) {
        _carTypeTitleArr = [NSMutableArray arrayWithObjects:@"微型车",@"小型车",@"紧凑型车",@"中型车",@"大型车",@"豪华车",@"型车", nil];
    }
    return _carTypeTitleArr;
}
 
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [UIColor blackColor];
        _titleL.font = [UIFont boldSystemFontOfSize:16];
    }
    return _titleL;
}
- (UIView *)btnBackView{
    if (!_btnBackView) {
        _btnBackView = [[UIView alloc]init];
    }
    return _btnBackView;
}


/**
 #pragma mark ==//////////旧btn——cell的选择 vc方法
 - (void)cellBtnAction:(UIButton *)sender{ //性别
     NSLog(@"cellBtnAction=sender=="); //200 300
     NSMutableArray *carTypeArray = [NSMutableArray arrayWithObjects:@"微型车",@"小型车",@"紧凑型车",@"中型车",@"大型车",@"豪华车",@"型车", nil];

     if (sender.tag>=300) {
         NSLog(@"cartype sender==%ld",(long)sender.tag); //200 300
         self.okModel.carEntity.carType = [NSString stringWithFormat:@"%@",carTypeArray[sender.tag-300]];
     }else{
         NSLog(@"gender sender==%ld",(long)sender.tag); //200 300
         //        0未知，1男，2女
         switch (sender.tag-200) {
             case 0:
             {
                 self.okModel.sex = 1;
             }
                 break;
             case 1:
             {
                 self.okModel.sex = 2;
             }
                 break;
             case 2:
             {
                 self.okModel.sex = 0;
             }
                 break;
                 
             default:
                 break;
         }
        
     }
 }*/
@end
