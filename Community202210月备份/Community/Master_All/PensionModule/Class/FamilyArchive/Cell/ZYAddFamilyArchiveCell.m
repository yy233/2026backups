//
//  ZYAddFamilyArchiveCell.m
//  Community
//
//  Created by ZY on 2021/11/18.
//

#import "ZYAddFamilyArchiveCell.h"

@interface ZYAddFamilyArchiveCell ()

@property (weak, nonatomic) IBOutlet UIButton *codeButton;

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation ZYAddFamilyArchiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.codeButton addTarget:self action:@selector(codeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.addButton addTarget:self action:@selector(addButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 处理点击事件
- (void)codeButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(codeButtonEvent)]) {
        [self.delegate codeButtonEvent];
    }
}

- (void)addButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addButtonEvent)]) {
        [self.delegate addButtonEvent];
    }
}

#pragma mark - 验证码倒计时
- (void)countdown {
    __block NSInteger time = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.codeButton setTitle:@"重新发送" forState:UIControlStateNormal];
                self.codeButton.backgroundColor = [UIColor zy_colorWithHexString:@"#1EC0A9"];
                self.codeButton.userInteractionEnabled = YES;
            });
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.codeButton setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                self.codeButton.backgroundColor = [UIColor lightGrayColor];
                self.codeButton.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

@end
