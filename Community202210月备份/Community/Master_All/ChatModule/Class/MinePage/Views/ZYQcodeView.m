//
//  ZYQcodeView.m
//  Community
//
//  Created by ZY on 2021/4/22.
//

#import "ZYQcodeView.h"
#import "ScanHelper.h"

@implementation ZYQcodeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)fillUserInfo:(NSMutableDictionary *)userInfoDic{
    //自己的二维码相关数据
    ChatUserModel *model = [ChatUserModel mj_objectWithKeyValues:userInfoDic];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.nameLabel.text = [TextShowWithModelStr textShowWithModelStr: model.nickName];
        self.uidLabel.text = [TextShowWithModelStr textShowWithModelStr: model.imId];//0909新版  不用uuid 用imid
        if([[TextShowWithModelStr textShowWithModelStr: model.headImgMaxUrl] rangeOfString:@"http"].location !=NSNotFound){
            [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr: [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,[TextShowWithModelStr textShowWithModelStr: model.headImgMaxUrl]]]  placeholderImage:[UIImage imageNamed:@"My_headportrait"]];
        }else{
            [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr: [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL_AddBase,[TextShowWithModelStr textShowWithModelStr: model.headImgMaxUrl]]]  placeholderImage:[UIImage imageNamed:@"My_headportrait"]];
        }
        if ([TextShowWithModelStr textShowWithModelStr: model.imId].length == 0) {//账号数据空则不显示
            self.qcodeImageView.hidden = YES;
            return;
        }else{
            self.qcodeImageView.hidden = NO;
        }
        // 生成二维码图片
        NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      model.imId, @"name",
                                      @(1), @"code",
                                      nil];
        NSString *QRJson = [mDict yy_modelToJSONString];
    
        UIImage *QRImage = [LBXScanWrapper createQRWithString:QRJson size:self.qcodeImageView.bounds.size];
        self.qcodeImageView.image = QRImage;
        
        // 图片切圆角
        [self.iconImageView zy_cornerRadiusAdvance:self.iconImageView.bounds.size.width / 2 rectCornerType:UIRectCornerAllCorners];
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    });

}
@end
