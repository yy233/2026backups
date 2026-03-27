//
//  TUIBarrageCell.m
//  lottie-ios
//
//  Created by WesleyLei on 2021/9/26.
//

#import "TUIBarrageCell.h"
#import "TUIBarrageModel.h"
#import "UIView+TUILayout.h"
#import "TUILogin.h"
#import "TUIBarrageLocalized.h"
#import "UIColor+TUIHexColor.h"
#import "Masonry.h"

@interface TUIBarrageCell ()<UITextFieldDelegate>
@property (nonatomic, strong) TUIBarrageModel *barrage;
@property (nonatomic, strong) UILabel *barrageLabel;
@property (nonatomic, strong) UIView *containerView;
@end

@implementation TUIBarrageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.barrageLabel];
    self.backgroundColor = [UIColor clearColor];
}

 
//长度0816
#define Free_SubStr @".free"
- (NSString *)suoDuanAddressStr:(NSString *)addressStrOrDomainStr{
    
    NSInteger Free_SubStrLen = Free_SubStr.length;
    if(addressStrOrDomainStr.length <= Free_SubStrLen){
        return addressStrOrDomainStr;
    }
    
    NSString *subfixStr = [addressStrOrDomainStr substringFromIndex:addressStrOrDomainStr.length-5];
    if([subfixStr isEqualToString:Free_SubStr]){//域名模样的nike
        if(addressStrOrDomainStr.length>16){//前四后4+5==9个 中间拼*号
            NSString *okStr = @"";
            //取后四位和前四位
            NSString *preStr = [addressStrOrDomainStr substringToIndex:4];
            NSString *suStr = [addressStrOrDomainStr substringFromIndex: addressStrOrDomainStr.length-(4+Free_SubStrLen)];//倒数4的字符 加上后缀 位置截取
            okStr = [NSString stringWithFormat:@"%@...%@",preStr,suStr];
            return okStr;
        }else{//没超过16
            return addressStrOrDomainStr;//返回整个
        }
    }else{//非域名模样 昵称或者0x地址
        if( addressStrOrDomainStr.length > 12){ //12位以上 就*
            NSString *okStr = @"";
//            取后6位和前6位
            NSString *preStr = [addressStrOrDomainStr substringToIndex:6];
            NSString *suStr = [addressStrOrDomainStr substringFromIndex: addressStrOrDomainStr.length-6];//倒数6的位置截取
            okStr = [NSString stringWithFormat:@"%@...%@",preStr,suStr];
            return  okStr;

        }else if ( addressStrOrDomainStr.length > 0){
            return addressStrOrDomainStr;
            
        }else{
            return @"-";//@"地址缺失"
        }
    }
   
}

- (void)setBarrage:(TUIBarrageModel *)barrage index:(NSInteger)index {
    NSString *userID = barrage.extInfo[@"userID"];
    NSString *nickName = barrage.extInfo[@"nickName"]?:@"";
    if (![userID isKindOfClass:[NSString class]]) {
        userID = @"";
    }
    if (![nickName isKindOfClass:[NSString class]]) {
        nickName = @"";
    }
    if ([userID isEqualToString:[TUILogin getUserID]?:@""]) {
        nickName = TUIBarrageLocalize(@"TUIBarrageView.me");
    } else {
        if (!nickName.length) {
            nickName = userID;
        }
    }
    nickName = [self suoDuanAddressStr:nickName];
    self.containerView.mm_w = self.mm_w;
    self.barrageLabel.mm_w = self.mm_w - 16 * 2;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:%@",nickName,barrage.message?:@""]];
    if (nickName.length) {
        [attributeString setAttributes:@{NSForegroundColorAttributeName:[self getColor:index]} range:NSMakeRange(0, nickName.length)];
    }
    self.barrageLabel.attributedText = attributeString;
    [self.barrageLabel sizeToFit];
    self.containerView.mm_h = self.barrageLabel.mm_h+20;
    self.containerView.mm_w = self.barrageLabel.mm_w+32;
    if (self.containerView.mm_h < 50) {
        self.containerView.layer.cornerRadius = self.containerView.mm_h*0.5;
    } else {
        self.containerView.layer.cornerRadius = 18;
    }
}

- (CGFloat)getCellHeight {
    return self.containerView.mm_h+5;
}

#pragma mark - set/get
- (UIView*)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0 , 0, 0, 0)];
        _containerView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.2];
    }
    return _containerView;
}

- (UILabel*)barrageLabel {
    if (!_barrageLabel) {
        _barrageLabel = [[UILabel alloc] initWithFrame:CGRectMake(16 , 10, 0, 0)];
        _barrageLabel.font = [UIFont systemFontOfSize:14];
        _barrageLabel.numberOfLines = 4;//0902弹幕限制4行
        _barrageLabel.textAlignment = NSTextAlignmentLeft;
        _barrageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _barrageLabel.textColor = [UIColor whiteColor];
    }
    return _barrageLabel;
}

- (UIColor *)getColor:(NSInteger)index {
    switch (index) {
        case 0:
            return  [UIColor tui_colorWithHex:@"0x3074FD"];
            break;
        case 1:
            return  [UIColor tui_colorWithHex:@"0x3CCFA5"];
            break;
        case 2:
            return  [UIColor tui_colorWithHex:@"0xFF8607"];
            break;
        case 3:
            return  [UIColor tui_colorWithHex:@"0xF7AF97"];
            break;
        case 4:
            return  [UIColor tui_colorWithHex:@"0xFF8BB7"];
            break;
        case 5:
            return  [UIColor tui_colorWithHex:@"0xFC6091"];
            break;
        case 6:
            return  [UIColor tui_colorWithHex:@"0xFCAF41"];
            break;
        default:
            break;
    }
    return [UIColor whiteColor];
}

@end
