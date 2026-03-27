//
//  ZYOtherIssueActivityTopView.m
//  Community
//
//  Created by ZY on 2021/11/16.
//

#import "ZYOtherIssueActivityTopView.h"

@interface ZYOtherIssueActivityTopView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;

@property (weak, nonatomic) IBOutlet UIButton *exchangeButton;

@end

@implementation ZYOtherIssueActivityTopView

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
    [self.addFriendButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:6];
    [self.exchangeButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:6];
    [self.addFriendButton addTarget:self action:@selector(addFriendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.exchangeButton addTarget:self action:@selector(exchangeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
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
            NSLog(@"是好友");
        }else{
            self.addFriendButton.userInteractionEnabled = YES;
            self.addFriendButton.hidden = NO;
            //
            self.exchangeButton.userInteractionEnabled = NO;
            self.exchangeButton.hidden = YES;
            NSLog(@"非好友");
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

@end
