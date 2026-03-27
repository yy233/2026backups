//
//  CartOneGoodsTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/3/1.
//

#import "CartOneGoodsTableViewCell.h"
@interface CartOneGoodsTableViewCell ()

@property (nonatomic,strong) UIButton *chooseBtn;
//数量加减btn
@property (nonatomic,strong) UIButton *addBtn;
@property (nonatomic,strong) UIButton *deletBtn;
//数据内部限制
@property (nonatomic,assign) NSInteger maxLimit;//最大限制

@end

@implementation CartOneGoodsTableViewCell 

- (void)changeChoooseBtnSelectedType:(BOOL)isSelected{
    self.chooseBtn.selected = isSelected;
}

- (void)addBtnAndDeletBtnUserInteractionEnabledSetNo{
    self.addBtn.userInteractionEnabled = NO;
    self.deletBtn.userInteractionEnabled = NO;
}
- (void)fillCartListOneGoodsInfoWithModel:(SmallShopCartListModel *)model{
 
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:model.commodityHeadImg] placeholderImage: [UIImage imageNamed:@"morentup_icon"]];
    
    NSString *oldMoneyStr = [NSString stringWithFormat:@"原价：¥%@",[TextShowWithModelStr textShowWithModelStr: model.payDto.commodityOriginalPrice]];
    NSDictionary* attribtDic = @{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),
                                 NSStrikethroughColorAttributeName: Y_ColorWith16FromRGB(0xAAAEB9),
                                 NSForegroundColorAttributeName: Y_ColorWith16FromRGB(0xAAAEB9) };
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldMoneyStr attributes:attribtDic];
    self.oldMoneyL.attributedText = attribtStr;
    self.moneyL.attributedText = [self attributeWithOneStr:@"¥" withSecondStr: [TextShowWithModelStr textShowWithModelStr: model.payDto.commoditySellPrice]];
    
    self.titleL.text =  [TextShowWithModelStr textShowWithModelStr:model.commodityName];
    self.rightCountL.text = [NSString stringWithFormat:@"%ld",(long)model.commodityNumber];
    [self changeDeletBtnImg];
    self.maxLimit = model.commodityRepertory;//库存数量
}
- (NSAttributedString*)attributeWithOneStr:(NSString*)first withSecondStr:(NSString*)second{//添加中划线，文字颜色

    NSMutableAttributedString* astring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",first,second]];
    
    NSRange range1 = NSMakeRange(0, first.length);
    NSRange range2 = NSMakeRange(first.length, (first.length + second.length)-1);
    //
    NSDictionary* attributes1 = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:9.0]  };
    NSDictionary* attributes2 = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0]  };
    [astring addAttributes:attributes1 range:range1];
    [astring addAttributes:attributes2  range:range2];//
    return astring;
}
 
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
        self.maxLimit = 999999;
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.titleL.numberOfLines = 2;
        self.rightCountL.text = @"1";//初始为1
        self.rightCountL.textAlignment = NSTextAlignmentCenter;
        self.rightCountL.textColor = Y_ColorWith16FromRGB(0x2B2C2F);
        self.rightCountL.font = [UIFont boldSystemFontOfSize:15.0];
        [self.contentView addSubview:self.chooseBtn]; 
        [self.contentView addSubview:self.addBtn];
        [self.contentView addSubview:self.deletBtn];
        
        WEAKSELF
        [_chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_chooseBtn.superview);
            make.left.equalTo(_chooseBtn.superview).offset(26);
            make.width.height.offset(20);
        }];
        [self.imgV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(80);
            make.left.equalTo(_chooseBtn.mas_right).offset(10);
            make.centerY.equalTo(weakSelf.imgV.superview);
        }];
        [self.moneyL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.imgV.mas_right).offset(10);
            make.height.offset(30);
            make.bottom.equalTo(weakSelf.imgV).offset(-10);
        }];
        //
        [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(20);
            make.bottom.equalTo(_addBtn.superview).offset(-10);
            make.right.equalTo(_addBtn.superview).offset(-26);
        }];
        
        [self.rightCountL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_addBtn.mas_left).offset(-5);
            make.top.bottom.equalTo(_addBtn);
            make.width.greaterThanOrEqualTo(_addBtn.mas_width);
        }];
        [_deletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.width.height.equalTo(_addBtn);
            make.right.equalTo(weakSelf.rightCountL.mas_left).offset(-5);
        }];
        [self changeDeletBtnImg];
        [self.chooseBtn setHitTestEdgeInsets: UIEdgeInsetsMake(-10, -5, -10, -5)];//扩大点击范围
        [self.addBtn    setHitTestEdgeInsets: UIEdgeInsetsMake(-10, 0, -10, 0)];//扩大点击范围
        [self.deletBtn  setHitTestEdgeInsets: UIEdgeInsetsMake(-10, 0, -10, 0)];//扩大点击范围
      
    }
    return self;
}

#pragma mark ==
- (UIButton *)chooseBtn{
    if (!_chooseBtn) {
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"cc_gouwucheyuan_icon"] selectedImg:[UIImage imageNamed:@"cc_gouwuchegouxuan_icon"]];
        [_chooseBtn addTarget:self action:@selector(chooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseBtn;
}
- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn newAnBtnWithImg:[UIImage imageNamed:@"cc_increase_icon"]];//绿色+
        [_addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}
 
- (UIButton *)deletBtn{
    if (!_deletBtn) {
        _deletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deletBtn newAnBtnWithImg:[UIImage imageNamed:@"cc_reduce_icon"] ];//绿色- 灰色-[UIImage imageNamed:@"cc_reducehui_icon"]
        [_deletBtn addTarget:self action:@selector(deletBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deletBtn;
}

#pragma mark ==
- (void)chooseBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    //
    if (isNotNil(self.touchChooseBtnBlock)) {
        self.touchChooseBtnBlock(sender);
    }
}

- (void)addBtnAction{
    //最大限制时
    NSInteger oldCount = [self.rightCountL.text integerValue];
    if (self.maxLimit == oldCount) {
        Y_SVP_SHOW_INFO_MES(@"已经达到库存数量，不可增加");
        return;
    }
    oldCount += 1;
    self.rightCountL.text  = [NSString stringWithFormat:@"%ld",oldCount];
    [self changeDeletBtnImg];
    //+
    if (isNotNil(self.touchAddBtnBlock)) {
        self.touchAddBtnBlock([self.rightCountL.text integerValue]);
    }
  
}

- (void)deletBtnAction{
    NSInteger oldCount = [self.rightCountL.text integerValue];
    if (oldCount <= 1) {
        Y_SVP_SHOW_INFO_MES(@"不能继续减少！");
        return;
    }else{
        oldCount -= 1;
    }
    self.rightCountL.text  = [NSString stringWithFormat:@"%ld",oldCount];
    [self changeDeletBtnImg];
    //-
    if (isNotNil(self.touchDeletBtnBlock)) {
        self.touchDeletBtnBlock([self.rightCountL.text integerValue]);
    }
}
 
- (void)changeDeletBtnImg{
    NSInteger oldCount = [self.rightCountL.text integerValue];
    if (oldCount<=1) {
        [_deletBtn newAnBtnWithImg: [UIImage imageNamed:@"cc_reducehui_icon"]];//灰色
    }else{
        [_deletBtn newAnBtnWithImg: [UIImage imageNamed:@"cc_reduce_icon"] ];//绿色-

    }
}


@end


#pragma mark == //购物车列表页 结算页使用
@interface CartOneGoodsNotAddDetBtnNotLeftChooseBtnTableViewCell ()
@end
@implementation CartOneGoodsNotAddDetBtnNotLeftChooseBtnTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
 
        self.addBtn.hidden = YES;
        self.deletBtn.hidden = YES;
        WEAKSELF
        [self.chooseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.chooseBtn.superview);
            make.left.equalTo(weakSelf.chooseBtn.superview).offset(26);
            make.width.height.offset(0.1);
        }];
    }
    return self;
}
 
- (void)fillCartListOneGoodsInfoWithModel:(SmallShopCartListModel *)model{
 
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:model.commodityHeadImg] placeholderImage: [UIImage imageNamed:@"morentup_icon"]];
    
    NSString *oldMoneyStr = [NSString stringWithFormat:@"原价：¥%@",[TextShowWithModelStr textShowWithModelStr: model.payDto.commodityOriginalPrice]];
    NSDictionary* attribtDic = @{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),
                                 NSStrikethroughColorAttributeName: Y_ColorWith16FromRGB(0xAAAEB9),
                                 NSForegroundColorAttributeName: Y_ColorWith16FromRGB(0xAAAEB9) };
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldMoneyStr attributes:attribtDic];
    self.oldMoneyL.attributedText = attribtStr;
    self.moneyL.attributedText = [self attributeWithOneStr:@"¥" withSecondStr: [TextShowWithModelStr textShowWithModelStr: model.payDto.commoditySellPrice]];
    
    self.titleL.text =  [TextShowWithModelStr textShowWithModelStr:model.commodityName];
    self.rightCountL.text = [NSString stringWithFormat:@"x%ld",(long)model.commodityNumber];//只展示数量
    [self changeDeletBtnImg];
    self.maxLimit = model.commodityRepertory;//库存数量
}
- (NSAttributedString*)attributeWithOneStr:(NSString*)first withSecondStr:(NSString*)second{//添加中划线，文字颜色

    NSMutableAttributedString* astring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",first,second]];
    
    NSRange range1 = NSMakeRange(0, first.length);
    NSRange range2 = NSMakeRange(first.length, (first.length + second.length)-1);
    //
    NSDictionary* attributes1 = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:9.0]  };
    NSDictionary* attributes2 = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0]  };
    [astring addAttributes:attributes1 range:range1];
    [astring addAttributes:attributes2  range:range2];//
    return astring;
}
 

@end

#pragma mark == //单个商品的商品购买结算页使用 (有按+—钮)

@interface CartOneGoodsNotLeftChooseBtnTableViewCell ()

@end
@implementation CartOneGoodsNotLeftChooseBtnTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
 
        WEAKSELF
        [self.chooseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.chooseBtn.superview);
            make.left.equalTo(weakSelf.chooseBtn.superview).offset(26);
            make.width.height.offset(0.1);
        }];
    }
    return self;
}

//(结算页 单个商品的数据)
- (void)fillCartPayDetailVcSubGoodsArrFirstInfoOfDetailVCModeInfoWithModel:(SmallShopCartListModel *)showUseModel{
    SmallShopCartListModel *model = showUseModel;
     
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:model.commodityHeadImg] placeholderImage: [UIImage imageNamed:@"morentup_icon"]];
    
    NSString *oldMoneyStr = [NSString stringWithFormat:@"原价：¥%@", [TextShowWithModelStr textShowWithModelStr: model.payDto.commodityOriginalPrice]];
    NSDictionary* attribtDic = @{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),
                                 NSStrikethroughColorAttributeName: Y_ColorWith16FromRGB(0xAAAEB9),
                                 NSForegroundColorAttributeName: Y_ColorWith16FromRGB(0xAAAEB9) };
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldMoneyStr attributes:attribtDic];
    self.oldMoneyL.attributedText = attribtStr;
    self.moneyL.attributedText = [self attributeWithOneStr:@"¥" withSecondStr: [TextShowWithModelStr textShowWithModelStr: model.payDto.actualPrice] ];//活动价格
    
    self.titleL.text =  [TextShowWithModelStr textShowWithModelStr:model.commodityName];
    self.rightCountL.text = [NSString stringWithFormat:@"%ld",(long)model.commodityNumber];
    [self changeDeletBtnImg];
    self.maxLimit = model.commodityRepertory;//库存数量
}
- (NSAttributedString*)attributeWithOneStr:(NSString*)first withSecondStr:(NSString*)second{//添加中划线，文字颜色

    NSMutableAttributedString* astring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",first,second]];
    
    NSRange range1 = NSMakeRange(0, first.length);
    NSRange range2 = NSMakeRange(first.length, (first.length + second.length)-1);
    //
    NSDictionary* attributes1 = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:9.0]  };
    NSDictionary* attributes2 = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0]  };
    [astring addAttributes:attributes1 range:range1];
    [astring addAttributes:attributes2  range:range2];//
    return astring;
}
 

@end



#pragma mark == //单个服务的商品购买结算页使用 （无+- 无count）

@interface CartOneServiceNotLeftChooseBtnTableViewCell ()

@end
@implementation CartOneServiceNotLeftChooseBtnTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.addBtn.hidden = YES;
        self.deletBtn.hidden = YES;
        self.rightCountL.hidden = YES;
        WEAKSELF
        [self.chooseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.chooseBtn.superview);
            make.left.equalTo(weakSelf.chooseBtn.superview).offset(26);
            make.width.height.offset(0.1);
        }];
        
    }
    return self;
}

 
@end
