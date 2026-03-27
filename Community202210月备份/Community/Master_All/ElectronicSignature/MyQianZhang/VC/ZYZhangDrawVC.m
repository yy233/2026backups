//
//  ZYZhangDrawVC.m
//  Community
//
//  Created by ZY on 2021/5/11.
//

#import "ZYZhangDrawVC.h"
#import "ZYZhangDrawView.h"
#import "BaseDrawView.h"
#import "ZYSealImageModel.h"

typedef enum : NSUInteger {
    ZhangDrawColor_Type_Black,
    ZhangDrawColor_Type_Red,
    ZhangDrawColor_Type_Green,
} ZhangDrawColor_Type;

@interface ZYZhangDrawVC () <BaseDrawViewDelegate>

@property (nonatomic, strong) ZYZhangDrawView *zhangDrawView;

@property (nonatomic, strong) BaseDrawView *baseDrawView;

// 是否粗
@property (nonatomic, assign) BOOL isThick;

@property (nonatomic, strong) UIImage *drawImage;

@property (nonatomic, assign) ZhangDrawColor_Type zhangDrawColor_Type;

@property (nonatomic, strong) ZYSealImageDataModel *dataModel;

@property (nonatomic, strong) MBProgressHUD *progressHUD;

// 是否是空印章
@property (nonatomic, assign) BOOL isEmptySign;

@end

@implementation ZYZhangDrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"手写印章";
    self.isThick = NO;
    self.isEmptySign = YES;
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupNavigationBarWhiteStyle];
}

- (void)setUI {

    [self.zhangDrawView.drawView addSubview:self.baseDrawView];
    [_baseDrawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_baseDrawView.superview);
    }];
    [self.view addSubview:self.zhangDrawView];
    [_zhangDrawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_zhangDrawView.superview);
        make.width.offset(kScreenH - 44 - status_height);
        make.height.offset(kScreenW);
    }];
    self.zhangDrawView.transform = CGAffineTransformMakeRotation(M_PI/2);
    
    UIView *lineContentView = [[UIView alloc] init];
    lineContentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineContentView];
    [lineContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(lineContentView.superview);
        make.height.offset(2);
    }];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = Y_RGBA(235, 235, 235, 1);
    [lineContentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(lineView.superview);
        make.height.offset(1);
    }];
    lineContentView.layer.zPosition = MAXFLOAT;
}

#pragma mark - 懒加载
- (ZYZhangDrawView *)zhangDrawView {
    if (!_zhangDrawView) {
        _zhangDrawView = [[NSBundle mainBundle] loadNibNamed:@"ZYZhangDrawView" owner:nil options:nil].lastObject;
        [_zhangDrawView.blackButton addTarget:self action:@selector(blackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_zhangDrawView.redButton addTarget:self action:@selector(redButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_zhangDrawView.greenButton addTarget:self action:@selector(greenButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_zhangDrawView.thickThinButton addTarget:self action:@selector(thickThinButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_zhangDrawView.clearButton addTarget:self action:@selector(clearButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_zhangDrawView.saveButton addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _zhangDrawView;
}

- (BaseDrawView *)baseDrawView {
    if (!_baseDrawView) {
        _baseDrawView = [[BaseDrawView alloc] init];
        _baseDrawView.lineWidth = 3;
        _baseDrawView.delegate = self;
    }
    
    return _baseDrawView;
}

- (UIImage *)drawImage {
    if (!_drawImage) {
        _drawImage = [[UIImage alloc] init];
    }
    
    return _drawImage;
}

#pragma mark - 加载数据
// 印章图片上传
- (void)initSealImageUploadData {
    
    NSDictionary *parms = @{@"description" : @"手写印章"};
    NSMutableArray *mArray = [NSMutableArray arrayWithObject:self.drawImage];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignature100KBImgFilesWithURL:kFileUploadUrl withParams:parms.mutableCopy fileDataArr:mArray fileNameStr:@"" finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                
                ZYSealImageModel *model = [ZYSealImageModel yy_modelWithJSON:responsObject];
                self.dataModel = model.data;
                [self initAddPersonSealData];
            }else {
                [self.progressHUD hide:YES];
                
                NSString *msg = [[responsObject allKeys] containsObject:@"message"] ? [NSString stringWithFormat:@"%@",[responsObject objectForKey:@"message"]] : @"暂无具体信息";
                [ZYProgressHUDTool showCustomHUDTextNoUserInteractionMessage:msg toView:self.zhangDrawView];
            }
        }else {
            [self.progressHUD hide:YES];
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 添加个人印章数据
- (void)initAddPersonSealData {
    NSDictionary *parms = @{@"userUuid" : [ShareUserInfo sharedUserInfo].userInfo.uid, @"fileUuid" : self.dataModel.uuid, @"sealName" : self.dataModel.fileName};
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kAddHandwrittenSealUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        [self.progressHUD hide:YES];
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                
                // 对data数据解密
                NSString *jsonStr = [ZYSignatureEncryptionTool decryptionSignatureEncryptionWithBase64Str:responsObject[@"data"]];
                ZYZhangManagerDataModel *model = [ZYZhangManagerDataModel yy_modelWithJSON:jsonStr];
                if (self.delegate && [self.delegate respondsToSelector:@selector(zhangDrawWithModel:)]) {
                    [self.delegate zhangDrawWithModel:model];
                }
                [self popVC];
            }else {
                
                NSString *msg = [[responsObject allKeys] containsObject:@"message"] ? [NSString stringWithFormat:@"%@",[responsObject objectForKey:@"message"]] : @"暂无具体信息";
                [ZYProgressHUDTool showCustomHUDTextNoUserInteractionMessage:msg toView:self.zhangDrawView];
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - BaseDrawViewDelegate
- (void)baseDrawViewDrawRect {
    
    self.isEmptySign = NO;
    self.zhangDrawView.placeholderLabel.hidden = YES;
    [self.view reloadInputViews];
}

#pragma mark - 处理点击事件
// 黑色
- (void)blackButtonClicked {
    
    self.baseDrawView.color = [UIColor blackColor];
    [self setColorViewWithType:ZhangDrawColor_Type_Black];
}

// 红色
- (void)redButtonClicked {
    
    self.baseDrawView.color = [UIColor redColor];
    [self setColorViewWithType:ZhangDrawColor_Type_Red];
}

// 绿色
- (void)greenButtonClicked {
    
    self.baseDrawView.color = [UIColor greenColor];
    [self setColorViewWithType:ZhangDrawColor_Type_Green];
}

// 粗细
- (void)thickThinButtonClicked {
    
    if (!self.isThick) {
        self.isThick = YES;
        self.baseDrawView.lineWidth = 6;
        [self.zhangDrawView.thickThinButton setImage:[UIImage imageNamed:@"ic_crude"] forState:UIControlStateNormal];
    }else {
        self.isThick = NO;
        self.baseDrawView.lineWidth = 3;
        [self.zhangDrawView.thickThinButton setImage:[UIImage imageNamed:@"ic_fine"] forState:UIControlStateNormal];
    }
    [self.view reloadInputViews];
}

// 清除
- (void)clearButtonClicked {
    
    [self.baseDrawView clear];
    self.isEmptySign = YES;
    self.zhangDrawView.placeholderLabel.hidden = NO;
    [self.view reloadInputViews];
}

// 保存
- (void)saveButtonClicked {
    
    if (!self.isEmptySign) {
        
        self.drawImage = [self.baseDrawView getDrawingImg];
        self.progressHUD = [MBProgressHUD showMessage:@"保存中..." toView:self.zhangDrawView];
        self.progressHUD.dimBackground = NO;
        [self initSealImageUploadData];
    }else {

        [ZYProgressHUDTool showCustomHUDTextMessage:@"手写印章不能为空!" toView:self.zhangDrawView];
    }
}

// 设置颜色视图
- (void)setColorViewWithType:(ZhangDrawColor_Type)type {
    
    if (type == ZhangDrawColor_Type_Black) {
        self.zhangDrawView.blackButton.backgroundColor = [UIColor blackColor];
        self.zhangDrawView.blackButton.layer.borderColor = [UIColor blackColor].CGColor;
        self.zhangDrawView.blackButton.layer.cornerRadius = 12.5;
        self.zhangDrawView.blackButton.layer.borderWidth = 1;
        self.zhangDrawView.blackButton.layer.masksToBounds = YES;
        
        self.zhangDrawView.redButton.backgroundColor = [UIColor whiteColor];
        self.zhangDrawView.redButton.layer.borderColor = Y_RGBA(230, 230, 230, 1).CGColor;
        self.zhangDrawView.redButton.layer.cornerRadius = 12.5;
        self.zhangDrawView.redButton.layer.borderWidth = 1;
        self.zhangDrawView.redButton.layer.masksToBounds = YES;
        
        self.zhangDrawView.greenButton.backgroundColor = [UIColor whiteColor];
        self.zhangDrawView.greenButton.layer.borderColor = Y_RGBA(230, 230, 230, 1).CGColor;
        self.zhangDrawView.greenButton.layer.cornerRadius = 12.5;
        self.zhangDrawView.greenButton.layer.borderWidth = 1;
        self.zhangDrawView.greenButton.layer.masksToBounds = YES;
    }else if (type == ZhangDrawColor_Type_Red) {
        
        self.zhangDrawView.blackButton.backgroundColor = [UIColor whiteColor];
        self.zhangDrawView.blackButton.layer.borderColor = Y_RGBA(230, 230, 230, 1).CGColor;
        self.zhangDrawView.blackButton.layer.cornerRadius = 12.5;
        self.zhangDrawView.blackButton.layer.borderWidth = 1;
        self.zhangDrawView.blackButton.layer.masksToBounds = YES;
        
        self.zhangDrawView.redButton.backgroundColor = [UIColor redColor];
        self.zhangDrawView.redButton.layer.borderColor = [UIColor redColor].CGColor;
        self.zhangDrawView.redButton.layer.cornerRadius = 12.5;
        self.zhangDrawView.redButton.layer.borderWidth = 1;
        self.zhangDrawView.redButton.layer.masksToBounds = YES;
        
        self.zhangDrawView.greenButton.backgroundColor = [UIColor whiteColor];
        self.zhangDrawView.greenButton.layer.borderColor = Y_RGBA(230, 230, 230, 1).CGColor;
        self.zhangDrawView.greenButton.layer.cornerRadius = 12.5;
        self.zhangDrawView.greenButton.layer.borderWidth = 1;
        self.zhangDrawView.greenButton.layer.masksToBounds = YES;
    }else if (type == ZhangDrawColor_Type_Green) {
        self.zhangDrawView.blackButton.backgroundColor = [UIColor whiteColor];
        self.zhangDrawView.blackButton.layer.borderColor = Y_RGBA(230, 230, 230, 1).CGColor;
        self.zhangDrawView.blackButton.layer.cornerRadius = 12.5;
        self.zhangDrawView.blackButton.layer.borderWidth = 1;
        self.zhangDrawView.blackButton.layer.masksToBounds = YES;
        
        self.zhangDrawView.redButton.backgroundColor = [UIColor whiteColor];
        self.zhangDrawView.redButton.layer.borderColor = Y_RGBA(230, 230, 230, 1).CGColor;
        self.zhangDrawView.redButton.layer.cornerRadius = 12.5;
        self.zhangDrawView.redButton.layer.borderWidth = 1;
        self.zhangDrawView.redButton.layer.masksToBounds = YES;
        
        self.zhangDrawView.greenButton.backgroundColor = [UIColor greenColor];
        self.zhangDrawView.greenButton.layer.borderColor = [UIColor greenColor].CGColor;
        self.zhangDrawView.greenButton.layer.cornerRadius = 12.5;
        self.zhangDrawView.greenButton.layer.borderWidth = 1;
        self.zhangDrawView.greenButton.layer.masksToBounds = YES;
    }
    [self.view reloadInputViews];
}

@end
