//
//  ActivityDetailTopVC.m
//  Community
//
//  Created by 余莹 on 2022/6/7.
//

#import "ActivityDetailTopView.h"

@interface ActivityDetailTopView ()

//@property (nonatomic,strong) UIImageView *topImgV;
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *subPersonNumL;

@end

@implementation ActivityDetailTopView
- (void)fillModel:(ActivityListUseModel *)model{
 
    self.titleL.text = [TextShowWithModelStr textShowWithModelStr:model.theme];
    NSString *stuStr = [self selfActiveStatusWithModel:model];
    self.subPersonNumL.text = [NSString stringWithFormat:@"%@：%ld/%ld",stuStr,model.count,model.applyCount];//状态 总人数 已报名人数
    //图片
//    NSArray *imgUrlArr = [model.picture componentsSeparatedByString:@","];
//    self.cycleScrollView.imageURLStringsGroup = imgUrlArr;
    //换成数组
     self.cycleScrollView.imageURLStringsGroup = [NSArray arrayWithArray:model.pictures];

}
#pragma mark === 状态处理

- (NSString *)selfActiveStatusWithModel:(ActivityListUseModel *)model{
    NSString *statusStr = @"";
    
    
    if ( model.status == 1 && model.activityStatus == 2) {//_______ 报过名的 且在截止日前 (非取消状态)
        statusStr = @"已报名";
    }else{
        //activityStatus    1预发布，2报名进行中，3报名已结束，5活动已结束,6未开始
        switch (model.activityStatus) {
            case 1:
            {
                statusStr = @"预发布";
            }
                break;
                
            case 2:
            {
                statusStr = @"报名进行中";
            }
                break;
                
            case 3:
            {
                statusStr = @"报名已结束";
            }
                break;
            case 5:
            {
                statusStr = @"活动结束";
                
            }
                break;
            case 6:
            {
                statusStr = @"即将开始";
               
            }
                break;
            default:
            {
                statusStr = @"未知状态";
            }
                break;
        }
    }
    return statusStr;
}

#pragma mark ===
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.cycleScrollView];
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.titleL];
        [self.bottomView addSubview:self.subPersonNumL];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_cycleScrollView.superview);
    }];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_bottomView.superview);
        make.height.offset(45);
    }];
    
    //
    [_subPersonNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_subPersonNumL.superview);
        make.right.equalTo(_subPersonNumL.superview).offset(-16);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_titleL.superview);
        make.left.equalTo(_titleL.superview).offset(16);
        make.right.equalTo(_titleL.superview).offset(-130);//留100的数量显示宽度和部分间距
    }];
}
#pragma mark ==
//- (UIImageView *)topImgV{
//    if (!_topImgV) {
//        _topImgV = [[UIImageView alloc]init];
//        _topImgV.contentMode = UIViewContentModeScaleAspectFill;
//        _topImgV.clipsToBounds = YES;
//        _topImgV.image = [UIImage imageNamed:@"cc_placeholder_big_banner"];
//    }
//    return _topImgV;
//}

- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [[SDCycleScrollView alloc]init];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
//        _cycleScrollView.currentPageDotColor = Y_RGBA(37, 95, 255, 1);
//        _cycleScrollView.pageDotColor = [UIColor lightGrayColor];
//        _cycleScrollView.tag = MainTopCycleScrollView_TAG;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"cc_placeholder_big_banner"];
        
    }
    return _cycleScrollView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [Y_ColorWith16FromRGB(0x000000) colorWithAlphaComponent:0.7];
    }
    return _bottomView;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [UIColor whiteColor];
        _titleL.font = [UIFont boldSystemFontOfSize:15.0];
    }
    return _titleL;
}
- (UILabel *)subPersonNumL{
    if (!_subPersonNumL) {
        _subPersonNumL = [[UILabel alloc]init];
        _subPersonNumL.textColor = [UIColor whiteColor];
        _subPersonNumL.font = [UIFont systemFontOfSize:13.0];
    }
    return _subPersonNumL;
}
@end
