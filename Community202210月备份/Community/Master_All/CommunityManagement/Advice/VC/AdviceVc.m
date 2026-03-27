//
//  AdviceVc.m
//  Community
//
//  Created by 余莹 on 2020/12/28.
//

#import "AdviceVc.h"
#import "AdviceView.h"
#import "AdviceCollectionViewCell.h"
#import "HouseRepairAdviceViewModel.h"//评价报修 上传评价图片 等接口
#define Cell_W 80
#define Cell_H 80
#define AdviceCollectionViewCell_Identifier @"AdviceCollectionViewCell"
@interface AdviceVc () <UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation AdviceVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价";
    [self initView];
}
#pragma mark ====
- (void)sendAllAdvice{
    if (self.adviceView.textView.text.length<=0) {
        Y_SVP_SHOW_INFO_MES(@"请输入文本");
        return;
    }
    if (self.adviceView.textView.text.length>=200) {
        Y_SVP_SHOW_INFO_MES(@"当前文本限制200");
        return;
    }
    NSInteger isStatus = 0;
    if (_adviceView.adviceBtn.selected==YES) {
        isStatus = 1;
    }
    NSString *strWithUrl = @"";
    if (self.imgUrlArr.count>0) {
        strWithUrl = [NSString stringWithFormat:@"%@",[self.imgUrlArr componentsJoinedByString:@","]];
    }
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setValue:@(isStatus) forKey:@"status"];
    [parms setValue:@(self.houseRepairId) forKey:@"id"];
    [parms setValue:strWithUrl forKey:@"filePath"];
    [parms setValue:self.adviceView.textView.text forKey:@"appraise"];
    Y_SVP_SHOW_MES_IsDealing_15Delay
    [HouseRepairAdviceViewModel houseAdviceSendParams:parms withblock:^(NSString * msg, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
        });
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_SUCCESS_MES(msg);
                [self popVC];
            });
        }else{
            Y_SVP_SHOW_ERR_MES(@"提交失败");
        }
    }];
}
- (void)sendImg:(UIImage *)img{
    Y_SVP_SHOW_MES_IsDealing_15Delay
    [HouseRepairAdviceViewModel houseAdviceSendImgWithOneFileArr:@[img].mutableCopy withblock:^(NSString *imgUrlStr, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_DISMISS
            });
            if (imgUrlStr.length>0) {
              NSString *lastStr = [imgUrlStr substringWithRange:NSMakeRange(imgUrlStr.length-1,1)];
                if ([lastStr isEqualToString:@";"]) {//分号去除
                    imgUrlStr = [imgUrlStr substringToIndex:imgUrlStr.length - 1];
                }
            }
            [self.imgSaveArr addObject:img];
            [self.imgUrlArr addObject:imgUrlStr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }else{
            Y_SVP_SHOW_ERR_MES(@"图片提交失败")
        }
    }];
}
#pragma mark ===
- (void)chooseImage{
    if (_imgUrlArr.count>=3) {
        Y_SVP_SHOW_ERR_MES(@"暂时仅支持3张图片");
        return;
    }
    UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
    pickVC.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    pickVC.delegate = self;
    pickVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:pickVC animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate 图片 回调
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *photo = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self sendImg:photo];
}


#pragma mark ====
- (void)initView{
    [self.view addSubview:self.adviceView];
    [self.adviceView.allImgBackView addSubview:self.collectionView];
    [self setUI];
}
- (void)setUI{
    [_adviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_adviceView.superview);
    }];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_collectionView.superview).insets(UIEdgeInsetsMake(10, 0, 10, 0));
    }];
}
#pragma mark ===
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.imgUrlArr.count==3) {
        return self.imgUrlArr.count;
    }else{
        return self.imgUrlArr.count+1;
    }
   
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AdviceCollectionViewCell *cell = (AdviceCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:AdviceCollectionViewCell_Identifier  forIndexPath:indexPath];
    if (indexPath.item==self.imgUrlArr.count) {//按钮item
        cell.imgView.image = [UIImage imageNamed:@"Pictureselection_Icon"];
    }else{//img item
        cell.imgView.image = self.imgSaveArr[indexPath.row];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.item==self.imgUrlArr.count) {//按钮item
        [self chooseImage];
    }
}
#pragma mark ===
- (void)okfooterBtnAction:(UIButton *)sender{
    NSLog(@"okfooterBtnAction");
    [self sendAllAdvice];
}
- (AdviceView *)adviceView{
    if (!_adviceView) {
        _adviceView = [[AdviceView alloc]initWithFrame:self.view.frame];
        [_adviceView.footerView.footerBtn addTarget:self action:@selector(okfooterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _adviceView;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(Cell_W,Cell_H);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(16, 0, Screen_W-32, self.view.frame.size.height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[AdviceCollectionViewCell class] forCellWithReuseIdentifier:AdviceCollectionViewCell_Identifier];
        _collectionView.scrollEnabled = YES;
        
    }
    return _collectionView;
}
#pragma mark ==
- (NSMutableArray *)imgUrlArr{
    if (!_imgUrlArr) {
        _imgUrlArr = [[NSMutableArray alloc]init];;
    }
    return _imgUrlArr;
}
- (NSMutableArray *)imgSaveArr{
    if (!_imgSaveArr) {
        _imgSaveArr = [[NSMutableArray alloc]init];;
    }
    return _imgSaveArr;
    
}
@end
