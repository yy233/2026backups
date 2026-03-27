//
//  HouseRentChooseHouseMoreSubViewTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/15.
//

#import "HouseRentChooseHouseMoreSubViewTableViewCell.h"
#define Color_lightBlue     Y_RGBA(38, 114, 249, 1)
#define Width_leftKong      50
#define Height_BottomBtn    44
#define Width_cellSubBtn       (Screen_W-Width_leftKong-40)/3
#define Height_cellSubBtn   50
#define Tag_cellSubBtn      200
//
#define Height_Cell_SectionHeaderView 60
#define Height_Cell_OneHang 60
#define Width_Cell_OneHang   (Screen_W-Width_leftKong-20)/3

@interface HouseRentChooseHouseMoreSubViewTableViewCell ()
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) NSArray *dataSourceArr;
@property (nonatomic,strong) NSMutableArray *allSelectedModelArr;
@property (nonatomic,strong) NSMutableArray *arrSelectedNameStrArr;
@end
@implementation HouseRentChooseHouseMoreSubViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark ==
- (void)sendAllDataSource:(NSArray *)datas andSelectedModelArr:(NSMutableArray *)arr{//dic model
 
    self.allSelectedModelArr = arr;
    if (arr.count == 0) {
        self.arrSelectedNameStrArr = @[].mutableCopy;
        [self initDataSource:datas];
    }else{
        for (int i = 0 ; i < arr.count ; i ++) {
            HouseRentMoreShaixuanModel *model = arr[i];
            NSString *nameStr = [TextShowWithModelStr textShowWithModelStr: model.houseConstName];//str
            [self.arrSelectedNameStrArr addObject:nameStr];
            if (i == arr.count-1 ) {
                [self initDataSource:datas];
            }
        }
    }
   
   
}
#pragma mark ==
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self.contentView addSubview:self.backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_backView.subviews);
        }];
        self.backView.frame = self.contentView.frame;
    }
    return self;
}
- (void)initDataSource:(NSArray *)dataS{
    [self.backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//删除所有
    self.dataSourceArr = dataS;
    for (int i = 0;i < self.dataSourceArr.count ; i ++) {
        UIButton *subBtn = [self baseBtn];
        NSDictionary *oneBtnDic = [NSDictionary dictionaryWithDictionary:self.dataSourceArr[i]];
        NSString *nameStr = [[oneBtnDic allKeys] containsObject:@"houseConstName"]?[NSString stringWithFormat:@"%@",oneBtnDic[@"houseConstName"]]:@"其他";//str
        [subBtn setTitle:nameStr forState:UIControlStateNormal];
        if ([self.arrSelectedNameStrArr containsObject:nameStr]) {//一选择状态
            subBtn.backgroundColor = Color_38BlueColor;
        }else{//
            subBtn.backgroundColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.3];
        }
        
       
        NSInteger sectionNum = i/3;
        NSInteger lieNum = i%3;
        subBtn.frame = CGRectMake(lieNum*Width_Cell_OneHang+10, sectionNum*Height_Cell_OneHang, Width_cellSubBtn, Height_cellSubBtn);
        subBtn.tag = Tag_cellSubBtn +i;
      
        //
        _backView.frame = CGRectMake(0, 0, Screen_W-50, (sectionNum+1)*Height_Cell_OneHang);
        subBtn.userInteractionEnabled = YES;
        [_backView addSubview:subBtn];
    }
}

- (UIButton *)baseBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"btnt" forState:UIControlStateNormal];
    [btn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
    btn.backgroundColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.3];
    //    [btn setImage:[UIImage imageWithColor:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.3]] forState:UIControlStateNormal];
    //    [btn setImage:[UIImage imageWithColor:Color_lightBlue] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(moreSubBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
- (void)moreSubBtnAction:(UIButton *)sender{
    NSInteger indexNum = sender.tag-Tag_cellSubBtn;
    HouseRentMoreShaixuanModel *model = [HouseRentMoreShaixuanModel mj_objectWithKeyValues:_dataSourceArr[indexNum]];
//    HouseRentMoreShaixuanModel *cancelModel = [HouseRentMoreShaixuanModel mj_objectWithKeyValues:_dataSourceArr[]];
    if (_delegate && [_delegate respondsToSelector:@selector(chooseHouseMoreShaiXuanItemWithShaiXuanModel:)]) {
        [_delegate chooseHouseMoreShaiXuanItemWithShaiXuanModel:model];
//        [_delegate cancelHouseMoreShaiXuanItemWithShaiXuanModel:model];//删除的部分暂停
    }
    [self changeUISelected:indexNum];
    
}
//可多选
- (void)changeUISelected:(NSInteger)indexNum{
    for (UIButton *btn in self.backView.subviews) {
        if ( btn.tag == Tag_cellSubBtn +indexNum ) {//转换状态
            if (btn.selected==YES) {
                btn.selected = NO;
                btn.backgroundColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.3];
            }else{
                btn.selected = YES;
                btn.backgroundColor = Color_38BlueColor;
            }
           
        }
    }
    
}
#pragma mark ==

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
    }
    return _backView;
}
- (NSArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc]init];
    }
    return _dataSourceArr;
}
- (NSMutableArray *)allSelectedModelArr{
    if (!_allSelectedModelArr) {
        _allSelectedModelArr = [[NSMutableArray alloc]init];
    }
    return _allSelectedModelArr;
}
- (NSMutableArray *)arrSelectedNameStrArr{
    if (!_arrSelectedNameStrArr) {
        _arrSelectedNameStrArr = [[NSMutableArray alloc]init];
    }
    return _arrSelectedNameStrArr;
}
/**
 cell.dataSourceArr = cellArr;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.backgroundColor = [UIColor clearColor];
//    cell.contentView.backgroundColor = [UIColor clearColor];
//    //
//    NSArray *cellArr = [NSArray arrayWithArray:self.allDataSourceDic[self.keyArr[indexPath.section]]];
//
//    for (int i = 0; i < cellArr.count; i ++) {
//        UIButton *subBtn = [self baseBtn];
//        NSInteger sectionNum = cellArr.count/3;
//        NSInteger lieNum = cellArr.count%3;
//        subBtn.frame = CGRectMake(lieNum*Width_Cell_OneHang, sectionNum*Height_Cell_OneHang, Width_cellSubBtn, Height_cellSubBtn);
//        [cell.contentView addSubview:subBtn];
//        NSLog(@"%lf",self.frame.origin.x)
//    }
 return cell;
 
}
- (UIButton *)baseBtn{
 UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
 [btn setTitle:@"btnt" forState:UIControlStateNormal];
 [btn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
 btn.backgroundColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.3];
//    [btn setImage:[UIImage imageWithColor:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.3]] forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageWithColor:Color_lightBlue] forState:UIControlStateSelected];
 btn.titleLabel.font = [UIFont systemFontOfSize:15];
 return btn;
}*/
@end
