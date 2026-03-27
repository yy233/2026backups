//
//  ZYLocationView.m
//  Community
//
//  Created by ZY on 2021/12/9.
//

#import "ZYLocationView.h"
#import "ZYAnnotation.h"

@interface ZYLocationView ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@end

@implementation ZYLocationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.headImageView zy_cornerRadiusRoundingRect];
    
    [self addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationViewTap)]];
}

// 设置数据model
- (void)setActivityModel:(ZYPensionMainActivityDataModel *)activityModel {
    _activityModel = activityModel;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:_activityModel.avatarImages] placeholderImage:[UIImage imageNamed:@"yl_placeholder_head"]];
}

- (void)locationViewTap {
    
    NSLog(@"点击大头针 %@", self.activityModel.activityDesc);
    if (!self.activityModel.isAnnotation) {
        // 发送通知
        Y_NSNotificationCenter_PostNotice_HaveObject_Name(@"LOCATION_VIEW_ANNOTATION_BACK", self.activityModel)
    }
}

@end
