//
//  MyRepairPageBaseListOfMsgAndImgsTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/4/11.
//

#import "MyRepairPageBaseListOfMsgAndImgsTableViewCell.h"


static CGFloat imgBk_H   = (55.0 + 10.0);
static CGFloat img_HW   = 55.0;

@interface MyRepairPageBaseListOfMsgAndImgsTableViewCell ()

@property (nonatomic,strong) UIView *lineView;//顶部
@property (nonatomic,strong) UILabel *topLabel;
@property (nonatomic,strong) UILabel *contentL;
@property (nonatomic,strong) UIView *imgBackV;//最多3张

@end

@implementation MyRepairPageBaseListOfMsgAndImgsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//详情页用的
- (void)fillDetailVcModel:(MyRepairShowDetailWorkOrderInfoModel *)model{
    self.lineView.hidden = YES;
 
    //文本
    self.contentL.text = [TextShowWithModelStr textShowWithNotNullStr:model.problem];
    //图片
    
     [self.imgBackV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if ( model.repairImg.length >0 ) {
        //有图
        NSArray *imgArrs = [NSArray arrayWithArray: model.repairImgs ];  
        for (int i=0; i<imgArrs.count; i++) {
            if (i >= 3) {//最多3张
                break;
            }else{
                UIImageView *anImg = [self anSubImgV];
                if (i==0) {
                    anImg.frame = CGRectMake(0, 5, img_HW, img_HW);
                }else{
                    anImg.frame = CGRectMake( i*(img_HW+10 ), 5, img_HW, img_HW);//10的间隔 y5开始
                }
                [self.imgBackV addSubview:anImg];
                [anImg sd_setImageWithURL:[UrlWithString getURLWithStr:imgArrs[i]]  placeholderImage:Main_PlaceholderImg_WeqH];
                //
                UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = i+800;
                btn.frame = anImg.frame;
                [btn addTarget:self action:@selector(imgtopBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.imgBackV addSubview:btn];
            }
        }
 
        [_imgBackV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_lineView);
            make.bottom.equalTo(_imgBackV.superview).offset(0);
            make.height.offset(imgBk_H).priority(900);//有图时高度
        }];
    }else{
        //无图时
        [_imgBackV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_lineView);
            make.bottom.equalTo(_imgBackV.superview).offset(0);
            make.height.offset(10).priority(900);//无图时高度
        }];
        
    }
    
}

//列表页用的
- (void)fillDataWithModel:(MyRepairPageListUseModel *)model{
    self.lineView.hidden = NO;
    //文本
    self.contentL.text = [TextShowWithModelStr textShowWithNotNullStr:model.problem];
    //图片
    
     [self.imgBackV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if ( model.repairImg.length >0 ) {
        //有图
        NSArray *imgArrs = [NSArray arrayWithArray: model.repairImgs ];
        for (int i=0; i<imgArrs.count; i++) {
            if (i >= 3) {//最多3张
                break;
            }else{
                UIImageView *anImg = [self anSubImgV];
                if (i==0) {
                    anImg.frame = CGRectMake(0, 5, img_HW, img_HW);
                }else{
                    anImg.frame = CGRectMake( i*(img_HW+10 ), 5, img_HW, img_HW);//10的间隔
                }
             
                [self.imgBackV addSubview:anImg];
                [anImg sd_setImageWithURL:[UrlWithString getURLWithStr:imgArrs[i]]  placeholderImage:Main_PlaceholderImg_WeqH];
                //
                UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = i+800;
                btn.frame = anImg.frame;
                [btn addTarget:self action:@selector(imgtopBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.imgBackV addSubview:btn];
            }
        }
 
        [_imgBackV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_lineView);
            make.bottom.equalTo(_imgBackV.superview).offset(0);
            make.height.offset(imgBk_H+5).priority(900);//有图时高度// 列表页 最后一行给冗余高度 展示好看些
        }];
     
    }else{
 
        //无图时
        [_imgBackV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_lineView);
            make.bottom.equalTo(_imgBackV.superview).offset(0);
            make.height.offset(10).priority(900);//无图时高度
        }];
        
    } 
}
- (UIImageView *)anSubImgV{
    UIImageView *imgv = [[UIImageView alloc]init];
    imgv.contentMode = UIViewContentModeScaleAspectFit;
    imgv.layer.cornerRadius = 10;
    imgv.layer.masksToBounds = YES;
    return imgv;
    
}
- (void)imgtopBtnAction:(UIButton *)sender{
   NSInteger indexx =  sender.tag-800;
    if (isNotNil(self.msgAndImgsCellTouchOneImgBlock)) {
        self.msgAndImgsCellTouchOneImgBlock(indexx);
    }
}

#pragma mark ==

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
       // self.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        WEAKSELF
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.backView.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        }];
        
        [self.backView addSubview:self.lineView];
        [self.backView addSubview:self.topLabel];
        [self.backView addSubview:self.contentL];
        [self.backView addSubview:self.imgBackV];
        [self setUI];
  
    }
    return  self;
}
 
- (void)setUI{
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView.superview).offset(1);
        make.left.equalTo(_lineView.superview.mas_left).offset(10);
        make.right.equalTo(_lineView.superview.mas_right).offset(-10);
        make.height.offset(1.0);
    }];
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_lineView);
        make.top.equalTo(_lineView.mas_bottom).offset(10);
        make.height.offset(20).priority(1000);
    }];

    [_imgBackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_lineView);
        make.bottom.equalTo(_imgBackV.superview).offset(0);
        make.height.offset(imgBk_H);//有图时高度
    }];
    [_contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_lineView);
        make.top.equalTo(_topLabel.mas_bottom).offset(5);
        make.bottom.equalTo(_imgBackV.mas_top);
        make.height.greaterThanOrEqualTo(_topLabel).priority(900);//高度大于20
    }];
    
 
}
#pragma mark ===


- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        if ([ThemeManager shareManager].type==ThemeType_White) {
            _lineView.backgroundColor = Y_RGBA(240, 241, 246, 1);
        }else{
            _lineView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.2];
        }
    }
    return _lineView;
}
- (UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc]init];
        _topLabel.font = [UIFont systemFontOfSize:12.0];
        _topLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _topLabel.numberOfLines = 1;
        _topLabel.text = @"报事描述：";
    }
    return _topLabel;
}

- (UILabel *)contentL{
    if (!_contentL) {
        _contentL = [[UILabel alloc]init];
        _contentL.font = [UIFont systemFontOfSize:12.0];
        _contentL.textColor = [ThemeManager shareManager].mainTextColor;
        _contentL.numberOfLines = 0;
    }
    return _contentL;
}
- (UIView *)imgBackV{
    if (!_imgBackV) {
        _imgBackV = [[UIView alloc]init];
    }
    return _imgBackV;
}
@end
