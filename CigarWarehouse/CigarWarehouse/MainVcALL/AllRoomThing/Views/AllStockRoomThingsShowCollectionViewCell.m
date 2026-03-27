//
//  AllStockRoomThingsShowCollectionViewCell.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/18.
//

#import "AllStockRoomThingsShowCollectionViewCell.h"

@implementation AllStockRoomThingsShowCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)dealloc{
}
-(void)prepareForReuse{
    [super prepareForReuse];
    _imgView.image = nil;
}
/**

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.imgView];
        
        [self.backView addSubview:self.t_BNameL];
        [self.backView addSubview:self.t_PosL];
        [self.backView addSubview:self.t_PackL];
        [self.backView addSubview:self.t_PiecesL];
        [self.backView addSubview:self.t_BuyPirceL];
        [self.backView addSubview:self.t_BuyFromL];
        [self.backView addSubview:self.t_ProduceFromL];
        [self.backView addSubview:self.t_OwenrL];
        [self.backView addSubview:self.t_Date_DoneL];
        [self.backView addSubview:self.t_Date_UnPackL];
        
        
        [self.backView addSubview:self.BNameL];
        [self.backView addSubview:self.PosL];
        [self.backView addSubview:self.PackL];
        [self.backView addSubview:self.PiecesL];
        [self.backView addSubview:self.BuyPirceL];
        [self.backView addSubview:self.BuyFromL];
        [self.backView addSubview:self.ProduceFromL];
        [self.backView addSubview:self.OwenrL];
        [self.backView addSubview:self.Date_DoneL];
        [self.backView addSubview:self.Date_UnPackL];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(2, 1, 2, 1));
    }];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_imgView.superview);
        make.height.equalTo(_imgView.superview).multipliedBy(0.4);
    }];
    
    //
    [_t_BNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_t_BNameL.superview).offset(10);
        make.height.offset(20);
        make.top.equalTo(_imgView.mas_bottom);
    }];
    [_BNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(_t_BNameL);
        make.centerY.equalTo(_t_BNameL);
        make.left.equalTo(_t_BNameL.mas_right).offset(4);
    }];
    
    [_t_BuyFromL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(_t_BNameL);
        make.left.equalTo(_t_BNameL);
        make.top.equalTo(_t_BNameL.mas_bottom);
    }];
    [_BuyFromL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(_t_BuyFromL);
        make.centerY.equalTo(_t_BuyFromL);
        make.left.equalTo(_t_BuyFromL.mas_right);
    }];
    
    
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.layer.cornerRadius = 10;
        _backView.layer.masksToBounds = YES;
        _backView.backgroundColor  = [UIColor whiteColor];
    }
    return _backView;
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.image = CC_img_placeholder_branner;
    }
    return _imgView;
}

//名字

- (UILabel *)t_BNameL{
    if (!_t_BNameL) {
        _t_BNameL = [[UILabel alloc]initWithFrame:CGRectZero];
        _t_BNameL.textColor = CC_Red_Drak_B;
        _t_BNameL.font = [UIFont boldSystemFontOfSize:12];
    }
    return _t_BNameL;
}
- (UILabel *)BNameL{
    if (!_BNameL) {
        _BNameL = [[UILabel alloc]initWithFrame:CGRectZero];
        _BNameL.textColor = CC_Red_Drak_A;
        _BNameL.font = [UIFont boldSystemFontOfSize:12];
    }
    return _BNameL;
}

//购买地
- (UILabel *)t_BuyFromL{
    if (!_t_BuyFromL) {
        _t_BuyFromL = [[UILabel alloc]initWithFrame:CGRectZero];
        _t_BuyFromL.textColor = CC_Red_Drak_B;
        _t_BuyFromL.font = [UIFont boldSystemFontOfSize:12];
    }
    return _t_BuyFromL;
}
- (UILabel *)BuyFromL{
    if (!_BuyFromL) {
        _BuyFromL = [[UILabel alloc]initWithFrame:CGRectZero];
        _BuyFromL.textColor = CC_Red_Drak_A;
        _BuyFromL.font = [UIFont boldSystemFontOfSize:12];
    }
    return _BuyFromL;
}
//原本产地
- (UILabel *)t_ProduceFromL{
    if (!_t_ProduceFromL) {
        _t_ProduceFromL = [[UILabel alloc]initWithFrame:CGRectZero];
        _t_ProduceFromL.textColor = CC_Red_Drak_B;
        _t_ProduceFromL.font = [UIFont boldSystemFontOfSize:12];
    }
    return _t_ProduceFromL;
}
- (UILabel *)ProduceFromL{
    if (!_ProduceFromL) {
        _ProduceFromL = [[UILabel alloc]initWithFrame:CGRectZero];
        _ProduceFromL.textColor = CC_Red_Drak_A;
        _ProduceFromL.font = [UIFont boldSystemFontOfSize:12];
    }
    return _ProduceFromL;
}
//位置
- (UILabel *)t_PosL{
    if (!_t_PosL) {
        _t_PosL = [[UILabel alloc]initWithFrame:CGRectZero];
        _t_PosL.textColor = CC_Red_Drak_B;
        _t_PosL.font = [UIFont boldSystemFontOfSize:12];
    }
    return _t_PosL;
}
- (UILabel *)PosL{
    if (!_PosL) {
        _PosL = [[UILabel alloc]initWithFrame:CGRectZero];
        _PosL.textColor = CC_Red_Drak_A;
        _PosL.font = [UIFont boldSystemFontOfSize:12];
    }
    return _PosL;
}

//拥有者
- (UILabel *)t_OwenrL{
    if (!_t_OwenrL) {
        _t_OwenrL = [[UILabel alloc]initWithFrame:CGRectZero];
        _t_OwenrL.textColor = CC_Red_Drak_B;
        _t_OwenrL.font = [UIFont boldSystemFontOfSize:12];
    }
    return _t_OwenrL;
}
- (UILabel *)OwenrL{
    if (!_OwenrL) {
        _OwenrL = [[UILabel alloc]initWithFrame:CGRectZero];
        _OwenrL.textColor = CC_Red_Drak_A;
        _OwenrL.font = [UIFont boldSystemFontOfSize:12];
    }
    return _OwenrL;
}
 */

- (void)fillDataModel:(BrandStockInFoModel *)model{
    /**
     self.t_BNameL.text = @"品牌名：";
     self.t_BuyFromL.text = @"购买地：";
     self.t_ProduceFromL.text = @"原产地：";
     self.t_OwenrL.text = @"拥有者：";
     
     self.BNameL.text = [TextShowWithModelStr textShowWithModelStr:model.Name.s];
     self.BuyFromL.text = [TextShowWithModelStr textShowWithModelStr:model.BuyFrom];
     
     if (model.Owner.v==true) {
         self.OwenrL.text = [TextShowWithModelStr textShowWithModelStr:model.Owner.s];
     }else{
         self.OwenrL.hidden = YES;
         self.t_OwenrL.hidden = YES;
     }
     */
}

- (void)fillDataModel:(BrandStockInFoModel *)model haveAddBtnShow:(BOOL)isShow{
    
}
@end



#pragma mark =========================================================



@implementation SubBaseTableViewCell

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
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titL];
        [self.contentView addSubview:self.contL];

        [_titL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titL.superview).offset(10);
            make.top.bottom.equalTo(_titL.superview);
        }];
        [_contL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_titL.superview).offset(-10);
            make.top.bottom.equalTo(_contL.superview);
            make.width.equalTo(_titL.superview).multipliedBy(0.65);
        }];
        
    }
    return self;
}


- (UILabel *)titL{
    if (!_titL) {
        _titL = [[UILabel alloc]init];
        _titL.textColor = CC_Red_Drak_A;
        _titL.font = [UIFont systemFontOfSize:13.0];
    }
    return _titL;
}
- (UILabel *)contL{
    if (!_contL) {
        _contL = [[UILabel alloc]init];
        _contL.textColor = CC_Red_Drak_A;
        _contL.font = [UIFont systemFontOfSize:14.0];
    }
    return _contL;
}

@end

#pragma mark ===

@interface AllStockRoomThingsShowCollectionViewCell_subHaveTabv () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation AllStockRoomThingsShowCollectionViewCell_subHaveTabv
 
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)dealloc{
}

- (void)prepareForReuse{
    [super prepareForReuse];
    _imgView.image = nil;
}
 
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleArr = @[@"品牌",@"原产地",@"购买地",@"存放位置",@"支数总量",@"包装单位",@"购买价格",@"拥有者"].mutableCopy;
        self.sourceTextArr = @[@"",@"",@"",@"",@"",@"",@"",@""].mutableCopy;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.imgView];
        [self.backView addSubview:self.tableView];
        [self.backView addSubview:self.buyAddBtn];
        [self setUI];
        self.buyAddBtn.hidden = YES;

    }
    return self;
}

#define subTabView_Row_Num      (8)
#define subTabView_Row_H        (MainVc_CellItem_H * 0.6-4)/subTabView_Row_Num
- (void)setUI{
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(2, 1, 2, 1));
    }];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_imgView.superview);
        make.height.equalTo(_imgView.superview).multipliedBy(0.35);
    }];
   
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgView);
        make.right.equalTo(_imgView).offset(-50);
        make.top.equalTo(_imgView.mas_bottom);
        make.bottom.equalTo(_tableView.superview);
    }];
    [_buyAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_buyAddBtn.superview).offset(-20);
        make.height.width.offset(30);
        make.bottom.equalTo(_tableView.mas_bottom).offset(-20);
    }];
    
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.layer.cornerRadius = 10;
        _backView.layer.masksToBounds = YES;
        _backView.backgroundColor  = [UIColor whiteColor];
    }
    return _backView;
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.image = CC_img_placeholder_branner;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}

- (UIButton *)buyAddBtn{
    if (!_buyAddBtn) {
        _buyAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyAddBtn newAnBtnWithBackColor:CC_Red_Drak_A];
        [_buyAddBtn newAnBtnWithTextStr:@"+"];
        [_buyAddBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_buyAddBtn newAnBtnWithFont:FontSize_Bold(20.0)];
        [_buyAddBtn newAnBtnWithLayerCorNerNum:6.0 withLayerLineWidth:0.0 withLayerLineColor:[UIColor whiteColor]];
    }
    return _buyAddBtn;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];//MainVc_CellItem_H * 0.6-4的高度
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.sectionHeaderHeight = 0.1;
        _tableView.sectionFooterHeight = 0.1;
        _tableView.estimatedSectionHeaderHeight = 0.1;
        _tableView.estimatedSectionFooterHeight = 0.1;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0.1;
        } else {
            // Fallback on earlier versions
        }//设置这个组头顶部填充 = 0解决问题
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}



#pragma mark ===

- (void)fillDataModel:(BrandStockInFoModel *)model{
    [self setShowTextArrDataModel:model];
    self.buyAddBtn.hidden = YES;
}
- (void)fillDataModel:(BrandStockInFoModel *)model haveAddBtnShow:(BOOL)isShow{
    [self setShowTextArrDataModel:model];
    self.buyAddBtn.hidden = NO;
}
- (void)setShowTextArrDataModel:(BrandStockInFoModel *)model{
    if (isNil(model)) {
        return;
    }
    NSString *lvguanStr = @"无";//铝管
 
//    if (model.tubos == YES) {
    if (model.tubos >= 1) {
        lvguanStr = @"有";
    }
    [self.imgView sd_setImageWithURL:[UrlWithString getURLWithStr:model.ProduceFrom]
                    placeholderImage:CC_img_placeholder_branner];
    
//    self.titleArr = @[@"品牌",@"原本产地",@"购买地",@"存放位置",@"数量",@"包装单位",@"购买价格",@"拥有者"].mutableCopy;
    self.sourceTextArr = @[[TextShowWithModelStr textShowWithModelStr_MinHaveLine:model.Name.s],
                           [TextShowWithModelStr textShowWithModelStr_MinHaveLine:model.ProduceFrom],
                           [TextShowWithModelStr textShowWithModelStr_MinHaveLine:model.BuyFrom],
                           [TextShowWithModelStr textShowWithModelStr_MinHaveLine:model.Pos],
                           [NSString stringWithFormat:@"%ld",(long)model.Pieces],
                            [TextShowWithModelStr textShowWithModelStr_MinHaveLine:model.Pack],
                           [TextShowWithModelStr textShowWithModelStr:model.BuyPrice],//金额
                             [TextShowWithModelStr textShowWithModelStr_MinHaveLine:model.Owner.s],
    ].mutableCopy;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}

#pragma mark ========= cell


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SubBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubBaseTableViewCell"];
    if (!cell) {
        cell = [[SubBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SubBaseTableViewCell"];
    }
    cell.titL.text = self.titleArr[indexPath.row];
    cell.contL.text = self.sourceTextArr[indexPath.row];
    return cell;
    
   /**
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    return cell;
    */
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return subTabView_Row_H;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end



