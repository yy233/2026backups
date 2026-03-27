//
//  LifeCostProgressEndBillAddNoteVC.m
//  Community
//
//  Created by 余莹 on 2021/1/13.
//

#import "LifeCostProgressEndBillAddNoteVC.h"

@interface LifeCostProgressEndBillAddNoteVC () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UITextField *noteTextField;
@property (nonatomic,strong) UIView *lineV;
@property (nonatomic,strong) UIButton *imgBavkBtn;
@property (nonatomic,strong) UIImageView *img;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
//
@property (nonatomic,strong) NSString *saveImgUrl;
@end

@implementation LifeCostProgressEndBillAddNoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"备注";
    self.saveImgUrl = @"";
    [self initView];
}
#pragma mark===
- (void)imgBavkBtnAction{
    NSLog(@"加图片");
    [self chooseImage];
}
#pragma mark == img pick

- (void)chooseImage {
    UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
    pickVC.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    pickVC.delegate = self;
    pickVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:pickVC animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate 图片 回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *photo = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self imgDetalWithPhoto:photo];
}
- (void)imgDetalWithPhoto:(UIImage *)phone{
    self.img.hidden = NO;
    self.img.image = phone;
    WEAKSELF
//    YrequestPostImagesWithURL
    [[ToolOfNetWork sharedTools]YrequestPostImagesWithURL:URL_Life_addMarkImgWithGetUrl withParams:@{}.mutableCopy fileImgData:@[phone].mutableCopy fileNameStr:@"file" imgNameAllStr:@"oneimg.png" finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                weakSelf.saveImgUrl = Y_ResponsObject_dataStr;
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_SUCCESS_MES(@"图片提交成功!");
                 });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MESSAGE
                    self.img.image = [UIImage new];
                 });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
                self.img.image = [UIImage new];
             });
        }
    }];
}
#pragma mark ==
- (void)footerSaveAction{
    if (self.noteTextField.text.length==0) {
        Y_SVP_SHOW_INFO_MES(@"备注为空");
        return;
    }
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(self.orderId) forKey:@"orderId"];
    [parms setValue:self.noteTextField.text forKey:@"remark"];
    [parms setValue:self.saveImgUrl forKey:@"remarkImg"];//url
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueue:URL_Life_addOrderMarkOrNote withParams:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                Y_SVP_SHOW_SUCCESS_MES(@"备注提交成功!");
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *userinfo = [NSDictionary dictionaryWithObject:self.noteTextField.text forKey:Notice_UserInfo_Key];
                    Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(LifeCost_BillNote_Save_Notice_Name, userinfo);
                    [self.navigationController popViewControllerAnimated:YES];
                 });
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
    

}
#pragma mark===
- (void)initView{
    [self.view addSubview:self.titleL];
    [self.view addSubview:self.noteTextField];
    [self.view addSubview:self.lineV];
    [self.view addSubview:self.imgBavkBtn];
    [self.view addSubview:self.img];
     [self.view addSubview:self.footerView];
    
    [self setTopUI];
    [self setCneterUI];
    [self setBottomUI];
}
- (void)setTopUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview.mas_top).offset(20);
        make.left.equalTo(_titleL.superview.mas_left).offset(16);
        make.right.equalTo(_titleL.superview.mas_right).offset(-16);
        make.height.offset(20);
    }];
    [_noteTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_bottom).offset(20);
        make.left.equalTo(_noteTextField.superview.mas_left).offset(16);
        make.right.equalTo(_noteTextField.superview.mas_right).offset(-16);
        make.height.offset(40);
    }];
    [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_noteTextField.mas_bottom);
        make.left.equalTo(_noteTextField.mas_left);
        make.right.equalTo(_noteTextField.mas_right);
        make.height.offset(1);
    }];
}
- (void)setCneterUI{
    [_imgBavkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineV.mas_bottom).offset(20);
        make.left.equalTo(_lineV.mas_left);
        make.right.equalTo(_lineV.mas_right);
        make.height.offset(90);//90_h
    }];
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imgBavkBtn.mas_centerX);
        make.centerY.equalTo(_imgBavkBtn.mas_centerY);
        make.width.offset(90);
        make.height.offset(90);
    }];
    _img.hidden = YES;//初始化时为隐藏状态
}
- (void)setBottomUI{
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_footerView.superview.mas_bottom).offset(-30);
        make.left.equalTo(_footerView.superview.mas_left).offset(16);
        make.right.equalTo(_footerView.superview.mas_right).offset(-16);
        make.height.offset(90);
    }];
    
}
#pragma mark ==
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font  = [UIFont boldSystemFontOfSize:16];
        _titleL.text = @"标签";
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.textAlignment = NSTextAlignmentLeft;
    }
    return _titleL;
}
- (UITextField *)noteTextField{
    if (!_noteTextField) {
        _noteTextField = [[UITextField alloc]init];
        _noteTextField.textColor = [ThemeManager shareManager].mainTextColor;
        _noteTextField.font = [UIFont systemFontOfSize:14];
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"输入标签" attributes:@{NSForegroundColorAttributeName:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7]}];
        _noteTextField.attributedPlaceholder = placeholderString;
    }
    return _noteTextField;
}
- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]init];
        _lineV.backgroundColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.2];
    }
    return _lineV;
}
- (UIButton *)imgBavkBtn{
    if (!_imgBavkBtn) {
        _imgBavkBtn = [[UIButton alloc]init];
        [_imgBavkBtn setTitleColor:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
        [_imgBavkBtn setTitle:@"添加一张图片" forState:UIControlStateNormal];
        _imgBavkBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _imgBavkBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_imgBavkBtn setImage:[UIImage imageNamed:@"Remarks_Add_night"] forState:UIControlStateNormal];
        [_imgBavkBtn addTarget:self action:@selector(imgBavkBtnAction) forControlEvents:UIControlEventTouchUpInside];
        //上下
        [_imgBavkBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:10];
        //虚线框
        CAShapeLayer *border = [CAShapeLayer layer];
        border.strokeColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.2].CGColor;
        border.fillColor = nil;
        _imgBavkBtn.bounds = CGRectMake(0, 0,Screen_W-32, 90);
        border.path = [UIBezierPath bezierPathWithRect:_imgBavkBtn.bounds].CGPath;
        border.frame = _imgBavkBtn.bounds;
        border.lineWidth = 1.f;
        border.lineCap = @"square";
        border.lineDashPattern = @[@4, @2];
        [_imgBavkBtn.layer addSublayer:border];
    }
    return _imgBavkBtn;
}
- (UIImageView *)img{
    if (!_img) {
        _img = [[UIImageView alloc]init];
        _img.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.2];
    }
    return _img;
}
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0,0, Screen_W, 90)];
        [_footerView setBtnFram:CGRectMake(16, 0, Screen_W-32, 50)];
        [_footerView.footerBtn setTitle:@"保存" forState:UIControlStateNormal];
        _footerView.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;
        [_footerView.footerBtn addTarget:self action:@selector(footerSaveAction) forControlEvents:UIControlEventTouchUpInside];;
    }
    return _footerView;
}
@end
