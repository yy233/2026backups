//
//  PopViewOfUserQRUseInfo.m
//  Socialize
//
//  Created by 余莹 on 2023/7/24.
//

#import "PopViewOfUserQRUseInfo.h"

@implementation PopViewOfUserQRUseInfo
- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr{
}
- (void)changMainBackViewBackColor{
    self.subMainBackView.backgroundColor = [UIColor clearColor]; //Color_238GrayColor;//半截背景颜色配置
}

- (void)initSubMainHeight{
//     self.subMainViewHeight  = Screen_H*0.9;//几乎全屏
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubAllView];
        [self setQrInfoUI];
    }
    return self;
}

- (void)addSubAllView{
    [self.subMainBackView.superview addSubview:self.showUseCenterBackView];
    self.subMainBackView.backgroundColor = [UIColor clearColor];//原本pop主承接页 不使用。
    
    [self.showUseCenterBackView  addSubview:self.headerImgv];
    [self.showUseCenterBackView  addSubview:self.addressL];
    [self.showUseCenterBackView  addSubview:self.imidL];
    [self.showUseCenterBackView  addSubview:self.deletBtn];
    [self.showUseCenterBackView  addSubview:self.qRImgv];
    
}
- (void)setQrInfoUI{
    
    [_showUseCenterBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_showUseCenterBackView.superview);
        make.width.equalTo(_showUseCenterBackView.superview).multipliedBy(0.9);
        make.height.equalTo(_showUseCenterBackView.mas_width);
        
    }];
    [_headerImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_headerImgv.superview).offset(15);
//        make.width.height.offset(80.0);
        make.width.height.offset(68.0);
    }];
    [_deletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(24.0);
        make.top.equalTo(_headerImgv);
        make.right.equalTo(_deletBtn.superview).offset(-25);
    }];
    //
    [_addressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerImgv);
        make.height.offset(20);
        make.left.equalTo(_headerImgv.mas_right).offset(10);
        make.right.equalTo(_deletBtn.mas_left).offset(-20);
    }];
    [_imidL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.right.equalTo(_addressL);
        make.top.equalTo(_addressL.mas_bottom).offset(5);
    }];
    
    //
    [_qRImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerImgv.mas_bottom).offset(20);
        make.centerX.equalTo(_qRImgv.superview);
        make.bottom.equalTo(_qRImgv.superview).offset(-20);
        make.width.equalTo(_qRImgv.mas_height);
    }];
    
}

#pragma mark ===
- (UIView *)showUseCenterBackView{
    if(!_showUseCenterBackView){
        _showUseCenterBackView = [[UIView alloc]init];
        _showUseCenterBackView.backgroundColor = [UIColor whiteColor];
        _showUseCenterBackView.layer.cornerRadius = 10;
        _showUseCenterBackView.layer.masksToBounds = YES;
    }
    return _showUseCenterBackView;
}
- (UIImageView *)headerImgv{
    if(!_headerImgv){
        _headerImgv = [[UIImageView alloc]init];
        _headerImgv.contentMode = UIViewContentModeScaleAspectFill;
        _headerImgv.layer.cornerRadius = 6.0;
        _headerImgv.layer.masksToBounds = YES;
    }
    return _headerImgv;
}

- (UILabel *)addressL{
    if(!_addressL){
        _addressL = [[UILabel alloc]init];
        _addressL.font = [UIFont systemFontOfSize:15.0];
        _addressL.textColor = Color_51BlackColor;
    }
    return _addressL;
}
- (UILabel *)imidL{
    if(!_imidL){
        _imidL = [[UILabel alloc]init];
        _imidL.font = [UIFont systemFontOfSize:14.0];
        _imidL.textColor = Color_153GrayColor;
    }
    return _imidL;
}
- (UIButton *)deletBtn{
    if(!_deletBtn){
        _deletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deletBtn newAnBtnWithImg:[UIImage imageNamed:@"btn_close_slices"]];
        [_deletBtn newAnBtnWithLayerCorNerNum:12.0 withLayerLineWidth:0.0 withLayerLineColor:[UIColor whiteColor]];
        _deletBtn.userInteractionEnabled = NO;
    }
    return _deletBtn;
}

- (UIImageView *)qRImgv{
    if(!_qRImgv){
        _qRImgv = [[UIImageView alloc]init];
        _qRImgv.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _qRImgv;
}


- (void)fillPopQrInfoWithUse{
    
    if(isNil([ShareUserInfo share].userInfo.address)){
        return;
    }else{
        [self.headerImgv sd_setImageWithURL:[UrlWithString getURLWithStr: [ShareUserInfo share].userInfo.profileImageUrl] placeholderImage: [BaseImgTool placeholdHeadImg]];
        self.headerImgv.backgroundColor = Color_245Gray;
        self.addressL.text = [self suoDuanAddressStr];//昵称=address
        if([TextShowWithModelStr textShowWithModelStr:[ShareUserInfo share].userInfo.username].length > 0){//有昵称 则用昵称 不用address
            self.addressL.text = [TextShowWithModelStr textShowWithModelStr:[ShareUserInfo share].userInfo.username];
        }
        self.imidL.text = [NSString stringWithFormat:@"ID:%@", [ShareUserInfo share].userInfo.imId];//id=imId
    }
    
    
    [self detailRqImgV];
 
}


- (NSString *)suoDuanAddressStr{
    if([ShareUserInfo share].userInfo.saveMydomain.length>0){
        return [self suoDuanAddressStr:[ShareUserInfo share].userInfo.saveMydomain];

    }else{
        return [self suoDuanAddressStr:[ShareUserInfo share].userInfo.address];

    }
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

- (void)detailRqImgV{
    
    if(isNil( [ShareUserInfo share].userInfo.imId )){
        return;
    }
    NSDictionary *willUseDic = @{
        @"type":@2000,
        @"imId":  [TextShowWithModelStr textShowWithModelStr:[ShareUserInfo share].userInfo.imId]
    };
    NSString *willUseJsStr = [Y_ToolOfOthers jsonStrWithDic:willUseDic];
    CGFloat w_h = Screen_W*0.9-80-60;
    self.qRImgv.image = [SGGenerateQRCode generateQRCodeWithData:willUseJsStr size:w_h];
    
    
}

@end

