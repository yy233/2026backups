//
//  ZYPensionSOSMapCell.m
//  Community
//
//  Created by ZY on 2021/11/17.
//

#import "ZYPensionSOSMapCell.h"
#import <MapKit/MapKit.h>

@interface ZYPensionSOSMapCell () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *mapContentView;

@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UIButton *voiceButton;

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIButton *bottomBtn;

@end

@implementation ZYPensionSOSMapCell

- (UIButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBtn newAnBtnWithImg:[UIImage imageNamed:@"yl_dingwshuax"]];
        [_bottomBtn addTarget:self action:@selector(bottomBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.mapContentView addSubview:self.mapView];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_mapView.superview);
    }];
    
    [self addShadow];
    self.voiceButton.hitTestEdgeInsets = UIEdgeInsetsMake(-8, -8, -8, -8);
    [self.voiceButton addTarget:self action:@selector(voiceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    //20211203隐藏导航相关 增加复位按钮
    self.searchView.hidden = YES;
    [self.mapContentView addSubview:self.bottomBtn];
    [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomBtn.superview).offset(-10);
        make.right.equalTo(_bottomBtn.superview).offset(-10);
        make.width.height.offset(50);
    }];
    
}

// 给视图添加阴影
- (void)addShadow{
    self.searchView.layer.shadowColor = Y_RGBA(227, 229, 238, 1).CGColor; //shadowColor阴影颜色
    self.searchView.layer.shadowOffset = CGSizeZero; //shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.searchView.layer.shadowOpacity = 1; //阴影透明度，默认0
    self.searchView.layer.shadowRadius = 5; //阴影半径，默认3
    self.searchView.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 懒加载
- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] init];
        // 设置地图显示样式(必须注意,设置时 注意对应的版本)
        _mapView.mapType = MKMapTypeStandard;
        // 设置地图是否可以缩放
        _mapView.zoomEnabled = YES;
        //是否可以滚动
        _mapView.scrollEnabled = YES;
        //旋转
        _mapView.rotateEnabled = NO;
        //设置显示用户当前位置
        _mapView.showsUserLocation = YES;
        // 为MKMapView设置delegate
        _mapView.delegate = self;
    }
    
    return _mapView;
}

#pragma mark - MKMapViewDelegate
// 选中大头针
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    id <MKAnnotation> mp = [annotationView annotation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 500, 500);
    [mapView setRegion:region animated:NO];
}

#pragma mark - 处理点击事件
- (void)voiceButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceButtonEvent)]) {
        [self.delegate voiceButtonEvent];
    }
}

- (void)bottomBtnAction{
 
    //设置中心显示 数值为用户当前位置
    self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;
    NSLog(@"地图复位键");
}

@end
