//
//  HistoryHolderTableViewCell.m
//  Socialize
//
//  Created by 余莹 on 2023/5/16.
//

#import "HistoryHolderTableViewCell.h"
 
@implementation HistoryHolderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        [self.contentView addSubview:self.bkView];
        [self.bkView addSubview:self.typeL];
        [self.bkView addSubview:self.imgv];
        [self.bkView addSubview:self.nickOrIdL];
        [self.bkView addSubview:self.centerLineV];
        [self.bkView addSubview:self.timeTitleL];
        [self.bkView addSubview:self.timeCountL];
 
        [self.bkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_bkView.superview).insets(UIEdgeInsetsMake(5, 10,5, 16));
        }];
        
        [_typeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(_typeL.superview).offset(10);
            make.height.offset(20);
        }];
        [_imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(40);
            make.left.equalTo(_imgv.superview).offset(10);
            make.top.equalTo(_typeL.mas_bottom).offset(15);
        }];
        
        [_nickOrIdL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imgv.mas_right).offset(5);
            make.centerY.equalTo(_imgv);
            make.right.equalTo(_nickOrIdL.superview).offset(-16);
            make.height.offset(20);
        }];
        [_centerLineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(1);
            make.top.equalTo(_imgv.mas_bottom).offset(15);
            make.centerX.equalTo(_centerLineV.superview);
            make.width.equalTo(_centerLineV.superview).offset(-20);
        }];
        [_timeTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_centerLineV);
            make.height.offset(20);
            make.top.equalTo(_centerLineV.mas_bottom).offset(15);
            make.width.offset(120);
        }];
        [_timeCountL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.equalTo(_timeTitleL);
            make.right.equalTo(_centerLineV);
        }];
        
        //
        _imgv.backgroundColor = [UIColor lightGrayColor];
        _imgv.layer.cornerRadius = 6;
        
        //虚线
        self.centerLineV.backgroundColor = rgba(215, 215, 215, 1);
 
       
    }
    return self;
}


- (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    [shapeLayer setBounds:lineView.bounds];
    
    if (isHorizonal) {
        
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
        
    } else{
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame)/2)];
    }
    
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    if (isHorizonal) {
        [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    } else {

        [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    }
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    
    if (isHorizonal) {
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    } else {
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(lineView.frame));
    }

    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

- (UIView *)bkView{
    if(!_bkView){
        _bkView = [[UIView alloc]init];
        _bkView.layer.cornerRadius = 6;
        _bkView.backgroundColor = [UIColor whiteColor];
    }
    return _bkView;
}


- (UILabel *)typeL{
    if(!_typeL){
        _typeL = [[UILabel alloc]init];
        _typeL.textColor = rgba(102, 102, 102, 1);
    }
    return _typeL;
}
 
- (UIImageView *)imgv{
    if(!_imgv){
        _imgv = [[UIImageView alloc]init];
    }
    return _imgv;
}

- (UILabel *)nickOrIdL{
    if(!_nickOrIdL){
        _nickOrIdL = [[UILabel alloc]init];
        _nickOrIdL.textColor = rgba(51, 51, 51, 1);
    }
    return _nickOrIdL;
}

- (UIView *)centerLineV{
    if(!_centerLineV){
        _centerLineV = [UIView new];//rgba(215, 215, 215, 1)
    }
    return _centerLineV;
}

- (UILabel *)timeTitleL{
    if(!_timeTitleL){
        _timeTitleL = [[UILabel alloc]init];
        _timeTitleL.textColor = rgba(51, 51, 51, 1);
    }
    return _timeTitleL;
}

- (UILabel *)timeCountL{
    if(!_timeCountL){
        _timeCountL = [[UILabel alloc]init];
        _timeCountL.textColor = rgba(153, 153, 153, 1);
        _timeCountL.textAlignment = NSTextAlignmentRight;
    }
    return _timeCountL;
}

@end
