//
//  PersionDestinationAddressTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/12/3.
//

#import "PersionDestinationAddressTableViewCell.h"

@implementation PersionDestinationAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)showFindWayStr:(NSString *)findWayAddressStr withHaveLatLongiInfoBool:(BOOL)haveInfo{
    if (haveInfo) {
        self.cellMainBtn.tag = Tag_PensionSOSMainCellSubBtn_GoAddress;
        [self.cellMainBtn newAnBtnWithTextStr:@"我要找路"];
        [self.cellMainBtn  newAnBtnWithImg:[UIImage imageNamed:@"yl_wyzl"]];
        [self.cellMainBtn newAnBtnWithTextColor:Color_Green_BtnShow  withBackColor:[UIColor whiteColor] withFont:[UIFont boldSystemFontOfSize:18] withLayerCorNerNum:5.0 withLayerLineWidth:2.0 withLayerLineColor:Color_Green_BtnShow];
         //
        self.cellMainLabel.text = (findWayAddressStr.length>0 ? findWayAddressStr : @"暂无具体地址文本信息");
        self.cellEditBtn.hidden = NO;
        self.cellEditBtn.tag = Tag_PensionSOSMainCellSubBtn_EditAddressInfo;
    }else{
        self.cellMainBtn.tag = Tag_PensionSOSMainCellSubBtn_AddAddressInfo;
        [self.cellMainBtn  newAnBtnWithTextStr:@"添加家庭地址"];
        [self.cellMainBtn  newAnBtnWithImg:[UIImage new]];
        [self.cellMainBtn newAnBtnWithTextColor:Color_Green_BtnShow  withBackColor:[UIColor whiteColor] withFont:[UIFont boldSystemFontOfSize:18] withLayerCorNerNum:5.0 withLayerLineWidth:2.0 withLayerLineColor:Color_Green_BtnShow];
        //
        self.cellMainLabel.text = @"进入找路导航，同时给您的sos通讯录的家人发送迷路信息，做到信息及时互通，保障您的安全。首次使用添加导航终点位置。";
        self.cellEditBtn.hidden = YES;
        self.cellEditBtn.tag = Tag_PensionSOSMainCellSubBtn_EditAddressInfo;
    }
}

@end
