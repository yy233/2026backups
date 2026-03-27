//
//  MainAllTypeInformationListTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/9/4.
//

#import "MainAllTypeInformationListTableViewCell.h"

@implementation MainAllTypeInformationListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillDataWithModel:(MainAllTypeImInfoModel*)model{
    if (model.un_read_count >0 ) {
        self.redCountLabel.text = [NSString stringWithFormat:@"%ld",model.un_read_count];
        self.redCountLabel.hidden = NO;
    }else{
        self.redCountLabel.hidden = YES;
    }
    
    //
    if (model.head_img_max_url.length >= model.head_img_small_url.length) {
        [self.headImgv sd_setImageWithURL:[UrlWithString getURLWithStr:model.head_img_max_url] placeholderImage:[UIImage imageNamed:@"My_headportrait"]];
    }else{
        [self.headImgv sd_setImageWithURL:[UrlWithString getURLWithStr:model.head_img_small_url] placeholderImage:[UIImage imageNamed:@"My_headportrait"]];
    }
    //[self.headImgv sd_setImageWithURL:[UrlWithString getURLWithStr:model.head_img_small_url] placeholderImage:[UIImage imageNamed:@"My_headportrait"]];

    if(model.contact_type){
        
        self.titleLabel.text = model.contact.friendRemark.length>0 ? model.contact.friendRemark : model.contact.nickName;
        if (self.titleLabel.text.length==0) {//有第二级别数据备注和昵称都@“”的情况 还是需要第一级别的名字字段
            self.titleLabel.text = model.nike_name;
        }
    }else{
        self.titleLabel.text = model.nike_name;
    }
    if (self.titleLabel.text.length==0) {
        self.titleLabel.text = @"未知昵称";
    }
    if (model.exist_last_chat_msg) {
        NSString *timeIntervalStr = [TextShowWithModelStr textShowWithModelStr:model.last_chat_msg.create_time];
        BOOL isThisDay = [ToolOfTimeChangeFormat checkIsThisDayWithTheDateStr:timeIntervalStr];
        self.timeLabel.text = ( isThisDay ? [ToolOfTimeChangeFormat dateToString:timeIntervalStr Format:@"HH:mm"] : [ToolOfTimeChangeFormat dateToString:timeIntervalStr Format:@"YYYY/MM/dd"]);
    }else{
        self.timeLabel.text  = model.create_time;
    }
    //有公众号类型
    self.detailtitleLabel.text = [TextShowWithModelStr textShowWithModelStr:model.messagelistWillShowDetailText];

}
//init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        self.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    }
    return self;
}
@end
