//
//  LifeCostNewCostTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/8.
//

#import "LifeCostNewCostTableViewCell.h"
#define Item_H     60
#define Item_W     (Screen_W-32)/3
#define Img_H      30
#define Img_W      (Screen_W-32)/3
#define Text_H      30
#define Text_W     (Screen_W-32)/3

#define Tag_img     200
#define Tag_lab     300

#import "LifeCostPayTypeModel.h"

@interface LifeCostNewCostTableViewCell ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIView *itembackView;
@end
@implementation LifeCostNewCostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark ==
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
- (void)imgTouchup:(UITapGestureRecognizer *)gesture{
    NSInteger index = gesture.view.tag-Tag_img;
    if (_delegate && [_delegate respondsToSelector:@selector(touchNewCostCellItemWithNum:)]) {
        [_delegate touchNewCostCellItemWithNum:index];
    }
}

#pragma mark ==
- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr{
    _dataSourceArr = dataSourceArr;//model
    self.itembackView.userInteractionEnabled = YES;
    [self addSubV];
    
    
}
- (void)addSubV{
    NSInteger count  = _dataSourceArr.count;
    [self.itembackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//旧数据去掉
    for (int i = 0; i < count; i ++) {
//        LifeCostAddNewCostModel *model = _dataSourceArr[i];
        LifeCostPayTypeModel *model = _dataSourceArr[i];
        UIImageView *img = [self baseImgV];
        img.contentMode = UIViewContentModeScaleAspectFit;
        [img sd_setImageWithURL:[UrlWithString getURLWithStr:[TextShowWithModelStr textShowWithModelStr: model.picUrlClient]] placeholderImage:[UIImage imageNamed:kLifeCost_Placeholder_ImgName]];
        if (i>=3) {
            img.frame = CGRectMake(Img_W*(i%3), Img_H*(i/3) + (Text_H)*(i/3), Img_W, Img_H);
        }else{
            img.frame = CGRectMake(Img_W*(i%3), Img_H*(i/3), Img_W, Img_H);
        }
        img.tag = Tag_img+i;
        //
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTouchup:)];
        tap.delegate = self;
        [img addGestureRecognizer:tap];
        //
        UILabel *lab = [self baseLab];
         if (i>=3) {
            lab.frame = CGRectMake((Text_W*(i%3)),Img_H*(i/3+1)+(Text_H)*(i/3) -5, Text_W, Text_H);//-5 缩小label和img间隔 有重叠
        }else{
            lab.frame = CGRectMake((Text_W*(i%3)), Img_H+(Text_H)*(i/3) -5, Text_W, Text_H);
        }
        lab.text = [TextShowWithModelStr textShowWithModelStr: model.typeName];
        lab.tag = Tag_lab+i;
        //
        [self.itembackView addSubview:lab];
        [self.itembackView addSubview:img];
    }
}
- (UIImageView *)baseImgV{
    UIImageView *imgv = [[UIImageView alloc]init];
    imgv.contentMode = UIViewContentModeScaleAspectFit; //UIViewContentModeCenter
    imgv.userInteractionEnabled = YES;
    return imgv;
}
- (UILabel *)baseLab{
    UILabel *lab = [[UILabel alloc]init];
    lab.font = [UIFont systemFontOfSize:13];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [ThemeManager shareManager].mainTextColor;
    return lab;
}
#pragma mark ==
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.itembackView];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_itembackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_itembackView.superview).insets(UIEdgeInsetsMake(10, 16, 10, 16));
    }];
}
- (UIView *)itembackView{
    if (!_itembackView) {
        _itembackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 100)];
    }
    return _itembackView;
}
 
@end
