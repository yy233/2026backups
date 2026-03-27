//
//  SmallShopWaitingPayOfTheCountdownTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/3/22.
//

#import "SmallShopWaitingPayOfTheCountdownTableViewCell.h"

static NSString *cellShowTextDf = @"剩余";
static NSString *cellShowTimeStrDf = @"00:15:00";
static NSInteger  secondsCountDown = 60*15; //倒计时总的秒数15分钟

@interface SmallShopWaitingPayOfTheCountdownTableViewCell ()
@property (nonatomic,strong) UILabel *rightL;
@property (nonatomic,strong) UILabel *leftAndTimeInfoL;

@end

@implementation SmallShopWaitingPayOfTheCountdownTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.rightL];
        [self.contentView addSubview:self.leftAndTimeInfoL];
        [self setUI];
        [self addNotice];
    }
    return self;
}
- (void)addNotice{
    NSLog(@"kNotice_HaveOrderAndWaitForPay  add");
    Y_NSNotificationCenter_Creat_NameAction(kNotice_HaveOrderAndWaitForPay, orderCountownTimeChangeBegin);
}
- (void)dealloc{
    NSLog(@"kNotice_HaveOrderAndWaitForPay  dealloc");
    Y_NSNotificationCenter_RemoveNotice_Name(kNotice_HaveOrderAndWaitForPay);

}
- (void)setUI{
    //super中心x为左右准线
    [_rightL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rightL.superview).offset(15);
        make.height.offset(30);
        make.left.equalTo(_rightL.superview.mas_centerX);
        
    }];
  
    [_leftAndTimeInfoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rightL);
        make.height.offset(30);
        make.right.equalTo(_leftAndTimeInfoL.superview.mas_centerX);
    }];
    _leftAndTimeInfoL.attributedText = [self attributeWithOneStr:cellShowTextDf withSecondStr:cellShowTimeStrDf];

}

- (NSAttributedString*)attributeWithOneStr:(NSString*)first withSecondStr:(NSString*)second{
 
    NSMutableAttributedString* astring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",first,second]];
    
    NSRange range1 = NSMakeRange(0, first.length);
     NSRange range2 = NSMakeRange(first.length,  second.length );//f任意位数时
    //
    NSDictionary* attributes1 = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0] , NSForegroundColorAttributeName: Y_ColorWith16FromRGB(0x2B2C2F) };
    NSDictionary* attributes2 = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0] ,    NSForegroundColorAttributeName: Y_ColorWith16FromRGB(0xFF0033) };
    [astring addAttributes:attributes1 range:range1];
    [astring addAttributes:attributes2  range:range2];
    return astring;
}
 
#pragma mark ==
- (UILabel *)rightL{
    if (!_rightL) {
        _rightL = [[UILabel alloc]init];
        _rightL.text = @"订单自动关闭";
        _rightL.textColor = Y_ColorWith16FromRGB(0x2B2C2F);
        _rightL.font = [UIFont boldSystemFontOfSize:18.0];
    }
    return _rightL;
}
- (UILabel *)leftAndTimeInfoL{
    if (!_leftAndTimeInfoL) {
        _leftAndTimeInfoL = [[UILabel alloc]init];
        _leftAndTimeInfoL.textAlignment = NSTextAlignmentRight;
    }
    return _leftAndTimeInfoL;
}
#pragma mark ==

- (void)orderCountownTimeChangeBegin{
    NSLog(@"\n countdown \n 倒计时 \n");
    __block NSInteger time = secondsCountDown; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.leftAndTimeInfoL.attributedText = [self attributeWithOneStr:cellShowTextDf withSecondStr:@"00:00:00"];
                if (isNotNil(self.waitingPayOfTheCountdownEndBlock)) {
                    self.waitingPayOfTheCountdownEndBlock();//通知vc做订单过期处理
                }
            });
        }else{
            //重新计算 时/分/秒
            NSString *str_hour = [NSString stringWithFormat:@"%02ld",time/3600];
            NSString *str_minute = [NSString stringWithFormat:@"%02ld",(time%3600)/60];
            NSString *str_second = [NSString stringWithFormat:@"%02ld",time%60];
            NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
            dispatch_async(dispatch_get_main_queue(), ^{
                //修改倒计时标签及显示内容
                self.leftAndTimeInfoL.attributedText = [self attributeWithOneStr:cellShowTextDf withSecondStr:format_time];
            });
            time--;
        }
    });
    dispatch_resume(_timer);
    
    
}
#pragma mark ==
//@property(nonatomic,strong)NSTimer*countDownTimer;
/**  timer 的定时 不准确 受run loop的影响。换gcd*/
/**
 - (void)orderCountownTimeChangeBegin{
      //设置定时器
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
     //启动倒计时后会每秒钟调用一次方法 countDownAction
    
     //设置倒计时显示的时间
     NSString *str_hour = [NSString stringWithFormat:@"%02ld",secondsCountDown/3600];//时
     NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%3600)/60];//分
     NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%60];//秒
     NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
     self.leftAndTimeInfoL.attributedText = [self attributeWithOneStr:cellShowTextDf withSecondStr:format_time];
 }
 //实现倒计时动作
 -(void)countDownAction{
     //倒计时-1
     secondsCountDown--;

     //重新计算 时/分/秒
     NSString *str_hour = [NSString stringWithFormat:@"%02ld",secondsCountDown/3600];
   
     NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%3600)/60];
   
     NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%60];
    
     NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
     //修改倒计时标签及显示内容
     self.leftAndTimeInfoL.attributedText = [self attributeWithOneStr:cellShowTextDf withSecondStr:format_time];

     
     //当倒计时到0时做需要的操作，比如验证码过期不能提交
     if(secondsCountDown<=0){
         
         [_countDownTimer invalidate];
         
         if (isNotNil(self.waitingPayOfTheCountdownEndBlock)) {
             self.waitingPayOfTheCountdownEndBlock();//通知vc做订单过期处理
         }
     }
     
     
 }
 */

 
@end
