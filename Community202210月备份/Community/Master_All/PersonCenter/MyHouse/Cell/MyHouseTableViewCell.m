//
//  MyHouseTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/8/3.
//

#import "MyHouseTableViewCell.h"

@interface MyHouseTableViewCell ()
//
@property (nonatomic,strong) MyHousePersonRelationModel *savePersonRelationModel;
@property (nonatomic,strong) MyHousePersonRelationSubMemberModel *savePersonRelationSubMemberModel;
@end

@implementation MyHouseTableViewCell
- (void)chooseTypeSaveInfoWithHidedChooseBtn{
    self.chooseBtn.hidden = YES;
    //mas
    [self setNotManagerCellUI];
}
- (void)chooseTypeSaveInfoWithChooseBtnSelected:(BOOL)isSelected{
    self.chooseBtn.hidden = NO;
    self.chooseBtn.selected = isSelected;
  
    //mas
    [self setManagerCellUI];
}
- (void)fillDataWithTopCellWithModel:(MyHousePersonRelationModel*)model{
    self.savePersonRelationModel = model;
    self.bottomL.text =  [TextShowWithModelStr textShowWithModelStr:model.houseSite];
    self.nameL.text = [TextShowWithModelStr textShowWithModelStr:model.name];
    self.typeInfoL.text = [TextShowWithModelStr textShowWithModelStr:model.relationText];
    [self typeColorSetWithRelationNum:model.relation];
    [self.imgV sd_setImageWithURL:[UrlWithString getURLWithStr:model.avatarUrl] placeholderImage:Main_OwnImg];
    if (model.relation == PersonRelatio_Num_YeZhu) {
        self.editBtn.hidden = NO;//业主 显示 可跳转到 增房屋 按钮
    }else{
        self.editBtn.hidden = YES;//其他身份 不可增房屋
    }
    //主cell位置不可显示箭头关怀图片
    self.rightArrowImgV.hidden = YES;
    self.guanHuaiMoShiIconImgv.hidden = YES;
    self.examineStatusLabel.text = @"";//非关怀的数据 审核UI 不显示
    self.examineStatusLabel.hidden = YES;
}
- (void)fillDataWithPersonRelationCellWithModel:(MyHousePersonRelationSubMemberModel*)model{//头像键值待定
    self.savePersonRelationSubMemberModel = model;
    self.bottomL.text =  [TextShowWithModelStr textShowWithModelStr:model.mobile];
    self.nameL.text = [TextShowWithModelStr textShowWithModelStr:model.name];
    self.typeInfoL.text = [TextShowWithModelStr textShowWithModelStr:model.relationText];
    [self typeColorSetWithRelationNum:model.relation];
 
    //家属状态下 关怀模式键值yes (才显示右边箭头｜关怀Icon标志|判定审核状态UI)
    if (model.relation == PersonRelatio_Num_JiaShu && model.carePattern == 1) {
        //箭头
        self.rightArrowImgV.hidden = NO;
        //关怀Icon标志
        self.guanHuaiMoShiIconImgv.hidden = NO;
        //人脸数据
        [self.imgV sd_setImageWithURL:[UrlWithString getURLWithStr:model.faceUrl] placeholderImage:Main_OwnImg];
        //审核状态UI 0.同步中 1.成功 2.失败
        switch (model.examineStatus) {
            case 0:
                self.examineStatusLabel.text = @"同步中";
                self.examineStatusLabel.hidden = NO;
                break;
                
            case 1:
                self.examineStatusLabel.text = @"";//成功
                self.examineStatusLabel.hidden = YES;
                break;
                
            case 2:
                self.examineStatusLabel.text = @"失败";
                self.examineStatusLabel.hidden = NO;

                break;
                
            default:
                break;
        }
   

    }else{
        self.rightArrowImgV.hidden = YES;
        self.guanHuaiMoShiIconImgv.hidden = YES;
        [self.imgV sd_setImageWithURL:[UrlWithString getURLWithStr:model.avatarUrl] placeholderImage:Main_OwnImg];
        self.examineStatusLabel.text = @"";//非关怀的数据 审核UI 不显示
        self.examineStatusLabel.hidden = YES;
    }
    
}
- (void)typeColorSetWithRelationNum:(NSInteger)relation{
    switch (relation) {
        case 6:
        {//亲属
            _typeInfoL.layer.borderColor = Y_ColorWith16FromRGB(0xFFA82B).CGColor;
            _typeInfoL.textColor =  Y_ColorWith16FromRGB(0xFFA82B);
        }
            break;
        case 7:
        {//租客绿色
            _typeInfoL.layer.borderColor = Y_ColorWith16FromRGB(0x8BE195).CGColor;
            _typeInfoL.textColor =  Y_ColorWith16FromRGB(0x8BE195);
        }
            break;
            
        default:
            //业主
            _typeInfoL.layer.borderColor = Y_ColorWith16FromRGB(0xFFA82B).CGColor;
            _typeInfoL.textColor =  Y_ColorWith16FromRGB(0xFFA82B);
            break;
    }
   
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)cellEditBtnShowBool:(BOOL)editBtnShow{
    self.editBtn.hidden  = !editBtnShow;
}
- (void)changeCellIsWillDeletEditWithNowUserRelationNum:(NSInteger)nowUserRelationNum andNowManagerBool:(BOOL)isManagerBool{
    
    if (nowUserRelationNum != PersonRelatio_Num_YeZhu) {//非业主
        //判断当前身份 是否可删除对应submember
        if (isNil(self.savePersonRelationSubMemberModel)) {  //非member 则为主topSectionCell 不做删除
            return;
        }else{
            if (self.savePersonRelationSubMemberModel.relation == PersonRelatio_Num_YeZhu || self.savePersonRelationSubMemberModel.relation == PersonRelatio_Num_JiaShu) {//家属业主级别 不可被家属身份的用户删除
                return;
            }
        }
    }
    //处理UI
    if (isManagerBool) {
        [self setManagerCellUI];
    }else{
        [self setNotManagerCellUI];
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.backView.superview);
        }];
         
        [self.backView addSubview:self.imgV];
        [self.backView addSubview:self.examineStatusLabel];
        [self.backView addSubview:self.nameL];
        [self.backView addSubview:self.bottomL];
        [self.backView addSubview:self.typeInfoL];
        [self.backView addSubview:self.editBtn];
        [self.backView addSubview:self.guanHuaiMoShiIconImgv];
        [self.backView addSubview:self.rightArrowImgV];
        //
        [self.backView addSubview:self.chooseBtn];
        [self setBaseUI];
    }
    return self;
}
- (void)prepareForReuse{
    [super prepareForReuse];
    self.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
}
- (void)setBaseUI{
    _chooseBtn.hidden = YES;
    [_chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_chooseBtn.superview).offset(16);
        make.centerY.equalTo(_chooseBtn.superview);
        make.width.height.offset(25);
    }];
    //
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgV.superview).offset(16);
        make.centerY.equalTo(_imgV.superview);
        make.width.height.offset(60);
    }];
    [_examineStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_imgV);
    }];
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_imgV.mas_centerY).offset(-5);
        make.left.equalTo(_imgV.mas_right).offset(20);
        make.height.offset(20);
        make.width.lessThanOrEqualTo(_nameL.superview).multipliedBy(0.5);
    }];
    [_bottomL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgV.mas_centerY);
        make.left.equalTo(_nameL);
        make.right.equalTo(_bottomL.superview.mas_right).offset(-75);//留下距离
    }];
    [_typeInfoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.top.equalTo(_nameL);
        make.left.equalTo(_nameL.mas_right).offset(5);
        make.width.offset(40);
        make.right.lessThanOrEqualTo(_typeInfoL.superview.mas_right).offset(-75);//50+20
    }];
    [_guanHuaiMoShiIconImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_typeInfoL);
        make.width.height.offset(15.0);
        make.left.equalTo(_typeInfoL.mas_right).offset(5.0);
    }];
    //
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_editBtn.superview.mas_right).offset(-20);
        make.centerY.equalTo(_editBtn.superview);
        make.width.offset(50);
        make.height.offset(20);
    }];
    [_imgV zy_cornerRadiusRoundingRect];//圆
    
    [_rightArrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {//右箭头
        make.right.equalTo(_rightArrowImgV.superview.mas_right).offset(-20);
        make.centerY.equalTo(_editBtn.superview);
        make.width.offset(10);
    }];
    _rightArrowImgV.hidden = YES;
}
- (void)setManagerCellUI{
    self.chooseBtn.hidden = NO;
    [_imgV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_chooseBtn.mas_right).offset(20);
        make.centerY.equalTo(_imgV.superview);
        make.width.height.offset(60);
    }];
}
- (void)setNotManagerCellUI{
    self.chooseBtn.hidden = YES;
    [_imgV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgV.superview).offset(16);
        make.left.equalTo(_imgV.superview).offset(16);
        make.centerY.equalTo(_imgV.superview);
        make.width.height.offset(60);
    }];
}
#pragma mark ==
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
//        _imgV.backgroundColor = Color_153GrayColor;
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imgV;
}

- (UILabel *)examineStatusLabel{
    if (!_examineStatusLabel) {
        _examineStatusLabel = [[UILabel alloc]init];
        _examineStatusLabel.font =  [UIFont systemFontOfSize:15];
        _examineStatusLabel.textAlignment = NSTextAlignmentCenter;
        _examineStatusLabel.textColor = [UIColor whiteColor];
        _examineStatusLabel.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        _examineStatusLabel.hidden = YES;//初始为隐藏状态
        _examineStatusLabel.layer.cornerRadius = 30.0;//h=60
        _examineStatusLabel.layer.masksToBounds = YES;
    }
    return _examineStatusLabel;
}

- (UILabel *)nameL{
    if (!_nameL) {
        _nameL = [[UILabel alloc]init];
        _nameL.font =  [UIFont boldSystemFontOfSize:15];
    }
    _nameL.textColor = [ThemeManager shareManager].mainTextColor;
    return _nameL;
}
- (UILabel *)bottomL{
    if (!_bottomL) {
        _bottomL = [[UILabel alloc]init];
        _bottomL.font =  [UIFont systemFontOfSize:15];
        _bottomL.textColor = [ThemeManager shareManager].mainTextColor;
        _bottomL.numberOfLines = 2;
    }
    return _bottomL;
}
- (UILabel *)typeInfoL{
    if (!_typeInfoL) {
        _typeInfoL = [[UILabel alloc]init];
        _typeInfoL.font =  [UIFont systemFontOfSize:12];
        _typeInfoL.layer.cornerRadius = 8.5;
        _typeInfoL.layer.masksToBounds = YES;
        _typeInfoL.layer.borderWidth = 0.5;
        _typeInfoL.layer.borderColor = Y_ColorWith16FromRGB(0xFFA82B).CGColor;
        _typeInfoL.textColor =  Y_ColorWith16FromRGB(0xFFA82B);
        _typeInfoL.textAlignment = NSTextAlignmentCenter;
    }
    return _typeInfoL;
}
- (UIImageView *)guanHuaiMoShiIconImgv{
    if (!_guanHuaiMoShiIconImgv) {
        _guanHuaiMoShiIconImgv = [[UIImageView alloc]init];
        _guanHuaiMoShiIconImgv.image = [UIImage imageNamed:@"ghms_icon"];
        _guanHuaiMoShiIconImgv.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _guanHuaiMoShiIconImgv;
}
- (UIImageView *)rightArrowImgV{
    if (!_rightArrowImgV) {
        _rightArrowImgV = [[UIImageView alloc]init];
        _rightArrowImgV.image = [UIImage imageNamed:@"ghskip_icon"];
        _rightArrowImgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightArrowImgV;
}
- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_editBtn newAnBtnWithTextStr:@"编辑"]; //编辑房屋 变成 查看房屋按钮 1020
        [_editBtn newAnBtnWithTextStr:@"查看"]; 
        [_editBtn newAnBtnWithFont:[UIFont systemFontOfSize:15]];
        [_editBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_editBtn newAnBtnWithLayerCorNerNum:5 withLayerLineWidth:0 withLayerLineColor:Color_38BlueColor];
        UIColor *beginColor = Y_ColorWith16FromRGB(0x3C9CFF);
        UIColor *endColor = Y_ColorWith16FromRGB(0x003CFF);
        CGSize size = CGSizeMake(50, 20);
        _editBtn.backgroundColor = [UIColor y_colorGradientChangeWithSize:size direction:IHGradientChangeDirectionVertical startColor:beginColor endColor:endColor];
        [_editBtn addTarget:self action:@selector(editBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _editBtn.hidden = YES;
      
    }
    return _editBtn;
}
- (UIButton *)chooseBtn{
    if (!_chooseBtn) {
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"Selectgroup_Default_night"] selectedImg:[UIImage imageNamed:@"Selectgroup_Select_night"]];
        [_chooseBtn addTarget:self action:@selector(chooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _chooseBtn.selected = NO;
    }
    return _chooseBtn;
}

- (void)chooseBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.chooseBtnSelectedBlock(sender.selected);
}
- (void)editBtnAction{
    self.editBtnBlock();
}
@end
