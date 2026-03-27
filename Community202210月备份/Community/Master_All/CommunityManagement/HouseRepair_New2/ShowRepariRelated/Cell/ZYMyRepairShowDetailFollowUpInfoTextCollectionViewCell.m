//
//  ZYMyRepairShowDetailFollowUpInfoTextCollectionViewCell.m
//  Community
//
//  Created by ZY on 2022/4/15.
//

#import "ZYMyRepairShowDetailFollowUpInfoTextCollectionViewCell.h"

@interface ZYMyRepairShowDetailFollowUpInfoTextCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ZYMyRepairShowDetailFollowUpInfoTextCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    [self.contentLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(conentLabelTap)]];;
}

// 设置数据model
- (void)setModel:(ZYMyRepairShowDetailFollowUpInfoListModel *)model {
    _model = model;
    
    NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc] initWithString:_model.info];
    NSRange range = [_model.info rangeOfString:@"]"];
    if (range.location != NSNotFound) {
        UIImage *image = [UIImage imageNamed:@"hr_dianhua_icon"];
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = image;
        attach.bounds = CGRectMake(5, -4, image.size.width, image.size.height);
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attach];
        [mAttr insertAttributedString:imageStr atIndex:range.location];
    }
    self.contentLabel.attributedText = mAttr;
}

#pragma mark - 处理点击事件
- (void)conentLabelTap {
    NSLog(@"拨号");
    if (self.model.mobile.length > 0) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
            //设备系统为IOS 10.0或者以上的
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.model.mobile]] options:@{} completionHandler:nil];
        }else{
            //设备系统为IOS 10.0以下的
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.model.mobile]]];
        }
    }
}

@end
