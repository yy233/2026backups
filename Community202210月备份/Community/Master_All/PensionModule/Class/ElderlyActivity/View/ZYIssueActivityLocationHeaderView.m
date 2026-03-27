//
//  ZYIssueActivityLocationHeaderView.m
//  Community
//
//  Created by ZY on 2021/11/15.
//

#import "ZYIssueActivityLocationHeaderView.h"
#import <MapKit/MapKit.h>
#import "ZYCustomAnnotationView.h"
#import "ZYAnnotation.h"

@interface ZYIssueActivityLocationHeaderView () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *mapContentView;

@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;

@property (weak, nonatomic) IBOutlet UIButton *exchangeButton;

@property (nonatomic, strong) UIImageView *animationImageView;

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate2D;

@property (nonatomic, assign) BOOL isMark;

@end

@implementation ZYIssueActivityLocationHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.iconImageView zy_cornerRadiusRoundingRect];
    
    [self.mapContentView addSubview:self.mapView];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_mapView.superview);
    }];
    [self.mapContentView addSubview:self.animationImageView];
    [_animationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_animationImageView.superview);
        make.width.height.offset(kScreenW - 64);
    }];
    [self.animationImageView bringSubviewToFront:self.mapContentView];
    
    [self.infoView cornerRadiusWithBounds:CGRectMake(0, 0, kScreenW, 80) radius:10 corners:UIRectCornerTopLeft|UIRectCornerTopRight];
    [self.addFriendButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:6];
    [self.exchangeButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:6];
    [self.addFriendButton addTarget:self action:@selector(addFriendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.exchangeButton addTarget:self action:@selector(exchangeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self playImageAnimationWithRepeatCount:1];
    //
    self.addFriendButton.hidden = YES;
    self.exchangeButton.hidden = YES;
}

- (void)setIsFriendBool:(BOOL)isFriendBool{
    if ([[ShareUserInfo sharedUserInfo].userInfo.uid isEqual:_model.userUuid]) {
        self.addFriendButton.userInteractionEnabled = NO;
        self.addFriendButton.hidden = YES;
        self.exchangeButton.userInteractionEnabled = NO;
        self.exchangeButton.hidden = YES;
    }else {
        if (isFriendBool) {
            self.addFriendButton.userInteractionEnabled = NO;
            self.addFriendButton.hidden = YES;
            //
            self.exchangeButton.userInteractionEnabled = YES;
            self.exchangeButton.hidden = NO;
        }else{
            self.addFriendButton.userInteractionEnabled = YES;
            self.addFriendButton.hidden = NO;
            //
            self.exchangeButton.userInteractionEnabled = NO;
            self.exchangeButton.hidden = YES;
        }
       
    }
}
// 设置数据model
- (void)setModel:(ZYPensionMainActivityDataModel *)model {
    _model = model;
    if ([[ShareUserInfo sharedUserInfo].userInfo.uid isEqual:_model.userUuid]) {
        self.addFriendButton.userInteractionEnabled = NO;
        self.addFriendButton.hidden = YES;
        self.exchangeButton.userInteractionEnabled = NO;
        self.exchangeButton.hidden = YES;
    }
    
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.avatarImages] placeholderImage:[UIImage imageNamed:@"yl_placeholder_head"]];
    self.nameLabel.text = _model.userName;
    self.ageLabel.text = [NSString stringWithFormat:@"%ld岁", _model.age];
    
    self.iconImageView.userInteractionEnabled = YES;
    [self.iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageViewTap)]];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([_model.latitude floatValue], [_model.longitude floatValue]);
    if (!self.isMark) {
        self.isMark = YES;
        MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.001, 0.001));
        [self.mapView setRegion:region animated:NO];
        ZYAnnotation *annotation = [[ZYAnnotation alloc] initWithCoordinate:coordinate];
        _model.isAnnotation = YES;
        annotation.activityModel = _model;
        [self.mapView addAnnotation:annotation];
    }
}

- (void)setActivityArray:(NSArray *)activityArray {
    _activityArray = activityArray;
    if (_activityArray.count > 0) {
        [self.mapView removeAnnotations:self.mapView.annotations];
        for (ZYPensionMainActivityDataModel *model in _activityArray) {
            if (![model.ID isEqual:self.model.ID]) {
                model.isAnnotation = NO;
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([model.latitude floatValue], [model.longitude floatValue]);
                ZYAnnotation *annotation = [[ZYAnnotation alloc] initWithCoordinate:coordinate];
                annotation.activityModel = model;
                [self.mapView addAnnotation:annotation];
            }
        }
        for (ZYPensionMainActivityDataModel *model in _activityArray) {
            if ([model.ID isEqual:self.model.ID]) {
                model.isAnnotation = YES;
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([model.latitude floatValue], [model.longitude floatValue]);
                ZYAnnotation *annotation = [[ZYAnnotation alloc] initWithCoordinate:coordinate];
                annotation.activityModel = model;
                [self.mapView addAnnotation:annotation];
            }
        }
    }
}

#pragma mark - 懒加载
- (UIImageView *)animationImageView {
    if (!_animationImageView) {
        _animationImageView = [[UIImageView alloc] init];
    }
    
    return _animationImageView;
}

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
        _mapView.showsUserLocation = NO;
        // 为MKMapView设置delegate
        _mapView.delegate = self;
    }
    
    return _mapView;
}

#pragma mark - MKMapViewDelegate
// 定制大头针
- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[ZYAnnotation class]]) {
        ZYCustomAnnotationView *annotationView = [ZYCustomAnnotationView annotationViewWithMapView:mapView withAnnotation:annotation];
        annotationView.annotation = annotation;
        
        return annotationView;
    }
    
    return nil;
}

// 选中大头针
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    if ([annotationView isKindOfClass:[ZYAnnotation class]]) {
        NSLog(@"选中");
    }
}

#pragma mark - 处理点击事件
- (void)addFriendButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addFriendButtonEvent)]) {
        [self.delegate addFriendButtonEvent];
    }
}

- (void)exchangeButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(exchangeButtonEvent)]) {
        [self.delegate exchangeButtonEvent];
    }
}

- (void)iconImageViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(iconImageViewEvent)]) {
        [self.delegate iconImageViewEvent];
    }
}

// 播放图片帧动画
- (void)playImageAnimationWithRepeatCount:(NSInteger)count {
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 2; i <= 21; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"yl_activity_location%d", i]];
        [imageArray addObject:image];
    }
    // 设置图片的序列帧
    self.animationImageView.animationImages = [imageArray copy];
    // 动画重复次数
    self.animationImageView.animationRepeatCount = count;
    // 动画执行的时长
    self.animationImageView.animationDuration = 1.5;
    // 开始动画
    [self.animationImageView startAnimating];
}

@end
