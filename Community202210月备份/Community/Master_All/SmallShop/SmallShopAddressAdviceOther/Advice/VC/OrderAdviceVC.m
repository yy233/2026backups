//
//  OrderAdviceVC.m
//  Community
//
//  Created by 余莹 on 2022/3/1.
//

#import "OrderAdviceVC.h"
#import "SmallShppOrderTableViewCell.h"
#import "OrderAdviceVcSubInputTableViewCell.h"
#import "OrderAdviceVcSubImgTableViewCell.h"
#import "OrderAdviceSuccessVC.h"
#import "OrderAdviceData.h"

@interface OrderAdviceVC () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) NSMutableArray *saveChooseImgUpedArr;//图片img
@property (nonatomic,strong) NSMutableArray *saveUpImgUrlInfoArr;//图片url信息
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong) NSString *saveAdviceStr;
@end

@implementation OrderAdviceVC

- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView  alloc]initWithFrame:CGRectMake(0, 0, Screen_W-100, 120)];
        [_footerView.footerBtn newAnBtnWithLayerCorNerNum:20.0 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_footerView.footerBtn newAnBtnWithTextStr:@"提交"];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
- (NSMutableArray *)saveUpImgUrlInfoArr{
    if (!_saveUpImgUrlInfoArr) {
        _saveUpImgUrlInfoArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _saveUpImgUrlInfoArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投诉建议";
    [self initView];
    [self initData];
}

- (void)initView{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.footerView.footerBtn newAnBtnWithBackColor:Y_ColorWith16FromRGB(0x22D1AD)];
    self.tableView.tableFooterView = self.footerView;
}
- (void)initData{
//    self.orderModel
    [self.tableView reloadData];
    
}

#pragma mark ===

- (void)footerBtnAction{
    NSLog(@"总提交");
    if (self.saveAdviceStr.length<10) {
        Y_SVP_SHOW_INFO_MES(@"反馈内容限制为10-300字");
        return;
    }else if (self.saveAdviceStr.length>300){
        Y_SVP_SHOW_INFO_MES(@"反馈内容限制为10-300字");
        return;
    }
     
    
    WEAKSELF
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    [parms setValue:[SmallShopNowShopShare share].saveNowShopId forKey:@"storeId"];
    [parms setValue:@([ShareUserInfo sharedUserInfo].commuityInfo.ID) forKey:@"communityId"];
    [parms setValue:@(self.orderListUseModel.ID) forKey:@"orderId"];
    [parms setValue:self.orderListUseModel.orderNumber forKey:@"orderNumber"];
    [parms setValue:self.saveAdviceStr forKey:@"feedbackContent"];
    if (self.saveUpImgUrlInfoArr.count>0) {
        NSString *allImgUrlStr = [self.saveUpImgUrlInfoArr componentsJoinedByString:@","];//逗号分割
        [parms setValue:allImgUrlStr   forKey:@"images"];
    }

    [OrderAdviceData smallOrderAdviceInfo:parms withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                OrderAdviceSuccessVC *vc = [[OrderAdviceSuccessVC alloc]init];
                [weakSelf pushVc:vc];
            });
        }
        
    }];
    
}

#pragma mark ==

- (void)touchSubImgCollectionCellWithItemIndex:(NSInteger)itemIndex{
    if (itemIndex == self.saveUpImgUrlInfoArr.count) {
        //add img
        //选图/拍照后上传
        [self iconImgTap];
    }else{
        //change
        NSLog(@"查看大图？");
        [self imgBigWithImgUrlStr:self.saveUpImgUrlInfoArr[itemIndex]];
    }
}
 

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 105;
    }else{
        return (indexPath.row==0 ? 160 : 130);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        SmallShppOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SmallShppOrderTableViewCell_I ];
        if(!cell){
            cell = [[SmallShppOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SmallShppOrderTableViewCell_I];
        }
        [cell fillDataWithOrderModel:self.orderListUseModel];
        return cell;
    }else{
        if (indexPath.row==0) {
            OrderAdviceVcSubInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderAdviceVcSubInputTableViewCell_I ];
            if(!cell){
                cell = [[OrderAdviceVcSubInputTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:OrderAdviceVcSubInputTableViewCell_I];
            }
            WEAKSELF
            cell.saveSelfTextViewStrBlock = ^(NSString * _Nonnull textViewStr) {
                weakSelf.saveAdviceStr = textViewStr;
            };
            return cell;
        }else{
            OrderAdviceVcSubImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderAdviceVcSubImgTableViewCell_I ];
            if(!cell){
                cell = [[OrderAdviceVcSubImgTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:OrderAdviceVcSubImgTableViewCell_I];
            }
            WEAKSELF
            cell.touchSubImgCollectionCellBlock = ^(NSInteger itemIndex) {
                [weakSelf touchSubImgCollectionCellWithItemIndex:itemIndex];
            };
            [cell fillShowArrWith:self.saveUpImgUrlInfoArr];
            return cell;
        }
    }
  
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark ==

#pragma mark === 组圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cornerRadius = 7.5f;
    UIColor *sectionFillColor = [UIColor whiteColor];
    //UIColor *separatoColor = Y_ColorWith16FromRGB(0xF0F1F6);
    if ([cell respondsToSelector:@selector(tintColor)]) {
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 16.0, 0);
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);// 实体剧形状
        } else if (indexPath.row == 0) {//上部分有圆角
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
            
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {//下部分有圆角
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
         
        } else {//填充？
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        //颜色修改
        layer.fillColor = sectionFillColor.CGColor;
        layer.strokeColor= sectionFillColor.CGColor;
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];// CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);//过小
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-1.0, bounds.size.width-20, 1.0);
            
            [layer addSublayer:lineLayer];
            lineLayer.backgroundColor = [UIColor clearColor].CGColor; 

        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}


#pragma mark == == == == == == == == == == == == ==
#pragma mark == img pick
 
- (void)iconImgTap{
    DLog(@"");
        //非处理状态
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        __weak typeof(self) weakSelf = self;
        UIAlertAction *photographAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //图片拍照
            [weakSelf chooseImageWithType:Photo_Choose_Type_Grapht];
        }];
        UIAlertAction *photoalbumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //图片相册选择
            [weakSelf chooseImageWithType:Photo_Choose_Type_Album];
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:photographAction];
        [alertVC addAction:photoalbumAction];
        [alertVC addAction:cancleAction];
        alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:alertVC animated:YES completion:nil];
   
}

- (void)chooseImageWithType:(Photo_Choose_Type)type {
   
   UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
   pickVC.delegate = self;
   if (type == Photo_Choose_Type_Grapht) {
       
       pickVC.allowsEditing = NO;
       pickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
   }else {
       
       pickVC.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
   }
   pickVC.modalPresentationStyle = UIModalPresentationFullScreen;
   [self presentViewController:pickVC animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate 图片 回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *photo = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self imgDetalWithPhoto:photo];
}
#pragma mark === 提交img信息的 //图片上传
- (void)imgDetalWithPhoto:(UIImage *)photo{

    DLog(@"仓储订单 投诉 单个图片上传");
    WEAKSELF
    [OrderAdviceData smallOrderAdviceImg:@[photo].mutableCopy withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            
            //NSString *urlStr = [[dic allKeys] containsObject:@"url0"] ? [TextShowWithModelStr textShowWithModelStr: [dic objectForKey:@"url0"]] : @"";//20220424改url0为url
            NSString *urlStr = [[dic allKeys] containsObject:@"url"] ? [TextShowWithModelStr textShowWithModelStr: [dic objectForKey:@"url"]] : @"";
            if (urlStr.length<=0) {
                Y_SVP_SHOW_INFO_MES(@"图片回调错误。");
            }else{
                [weakSelf.saveUpImgUrlInfoArr addObject:urlStr];
                [weakSelf.saveChooseImgUpedArr addObject:photo];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }
            
        }
    }];
}


#pragma mark ==
#pragma mark == 图片放大
- (void)imgBigWithImgUrlStr:(NSString *)imgUrlStr{
    
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.maximumZoomScale=5.0;//图片的放大倍数
    _scrollView.minimumZoomScale=1.0;//图片的最小倍率
    _scrollView.contentSize=CGSizeMake(self.view.bounds.size.width*1.5, self.view.bounds.size.height*1.5);//可以左右滑
    //    _scrollView.contentSize=CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);//禁止左右滑
    _scrollView.delegate=self;
    _scrollView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    _imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    _imageView.center = CGPointMake(self.view.center.x, self.view.center.y - KNavBarHeight);
    [_imageView sd_setImageWithURL: [UrlWithString getURLWithStr:imgUrlStr] placeholderImage:[UIImage imageNamed:@"Repair_picture_icon"]];
    [_scrollView addSubview:_imageView];
    [self.view addSubview:_scrollView];
    _imageView.userInteractionEnabled=YES;//注意:imageView默认是不可以交互,在这里设置为可以交互
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    tap.numberOfTapsRequired=1;//单击
    tap.numberOfTouchesRequired=1;//单点触碰
    [_imageView addGestureRecognizer:tap];
    UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired=2;//避免单击与双击冲突
    [tap requireGestureRecognizerToFail:doubleTap];
    [_imageView addGestureRecognizer:doubleTap];
    _imageView.contentMode=UIViewContentModeScaleAspectFit;
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView  //委托方法,必须设置  delegate
{
    return _imageView;//要放大的视图
}

-(void)doubleTap:(id)sender
{
    _scrollView.zoomScale=2.0;//双击放大到两倍
}
- (void)tapImage:(id)sender
{
    //    [self dismissViewControllerAnimated:YES completion:nil];//单击图像,关闭图片详情(当前图片页面)
    [_scrollView removeFromSuperview];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan-----------------------------------------");
}
#pragma mark == 图片放大 end

 
@end
