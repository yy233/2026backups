//
//  DiscoverMainView.m
//  Socialize
//
//  Created by 余莹 on 2023/5/11.
//

#import "DiscoverTopView.h"


#define  viewSelf_H  120
@implementation DiscoverTopView

+ (DiscoverTopView *)instaceThisViewSelf{
    NSArray *nibView = [[NSBundle mainBundle]loadNibNamed:@"DiscoverTopView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}

- (id)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder: coder];
    if(self){
        
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    NSLog(@"awakeFromNib     %1f",self.bounds.size.height);
    [self subV];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.frame = CGRectMake(0, 0, Screen_W, viewSelf_H);
    NSLog(@"drawRect     %1f",self.bounds.size.height);
 
}

- (void)layoutSubviews{//UI更改时会被多次调用
    [super layoutSubviews];
    NSLog(@"layoutSubviews     %1f",self.bounds.size.height);
}


- (void)subV{
    
    
    self.tuiJianBtn.backgroundColor = Y_RGB(102, 208, 209);
    self.tuiJianBtn.layer.cornerRadius = 15;
    self.tuiJianBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    self.tuiJianBtn.titleLabel.textColor = rgba(51, 51, 51, 1);
 
    self.voiceBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    self.voiceBtn.titleLabel.textColor = rgba(51, 51, 51, 1);
    
    self.liveBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    self.liveBtn.titleLabel.textColor = rgba(51, 51, 51, 1);
 

    UIColor * beginColor =  Y_RGB(225, 249, 249);
    UIColor * endColor =  Y_RGB(232, 252, 242);
    self.backgroundColor = [UIColor y_colorGradientChangeWithSize:CGSizeMake(Screen_W, viewSelf_H) direction:IHGradientChangeDirectionVertical startColor:beginColor endColor:endColor];
    
    
    if(Screen_H < 812.0){
        self.tuiJianBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        self.voiceBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        self.liveBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];

    }
    

    
    
}

@end
