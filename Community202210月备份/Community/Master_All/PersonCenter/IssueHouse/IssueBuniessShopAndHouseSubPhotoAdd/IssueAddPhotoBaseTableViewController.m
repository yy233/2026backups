//
//  IssueAddPhoneTableViewController.m
//  Community
//
//  Created by 余莹 on 2021/1/20.
//。商铺类型的房屋选择列表

#import "IssueAddPhotoBaseTableViewController.h"
#import "IssueAddPhotoVCSubImgViewsTableViewCell.h"
#define  IssueAddPhotoVCSubImgViewsTableViewCell_Identifier           @"IssueAddPhotoVCSubImgViewsTableViewCell"
#import "IssueAddPhotoViewModel.h" //数据


#define  Height_cell_oneHang             100
@interface IssueAddPhotoBaseTableViewController () <IssueAddPhotoVCSubImgViewsTableViewCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong) BaseTableViewFooterView *footerView;


@property (nonatomic,assign) Cell_SubImgViews_Type nowType;
@end

@implementation IssueAddPhotoBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加照片";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = self.footerView;
    [self initData];
}
- (void)initData{
    [self.tableView reloadData];
}
#pragma mark ==
- (void)footerBtnFinishAction{
    if (self.sectionOneImgArr.count == 0 || self.sectionTwoImgArr.count == 0 || self.sectionThrImgArr.count == 0) {//必须>1
        Y_SVP_SHOW_INFO_MES(@"缺少图片数据");
        return;
    }
    
    Y_SVP_SHOW_MES_IsDealing_15Delay;
    [IssueAddPhotoViewModel issueAddBuniessPhotosWithHeadImgs:self.sectionOneImgArr withMiddleImgs:self.sectionTwoImgArr withOtherImgs:self.sectionThrImgArr block:^(NSDictionary * dic, BOOL success) {
        if (success) {
            NSInteger hCount = [NSArray arrayWithArray: dic[@"H"]].count;
            NSInteger mCount = [NSArray arrayWithArray: dic[@"M"]].count;
            NSInteger oCount = [NSArray arrayWithArray: dic[@"O"]].count;
            if (hCount==0 || mCount==0 || oCount ==0) {//必须>1
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MES(@"图片上传失败");
                });
            }else{
                NSString *msg = [NSString stringWithFormat:@"成功提交\n%@%ld张\n%@%ld张\n%@%ld张",self.sectionTitleArr.firstObject,hCount,self.sectionTitleArr[1],mCount,self.sectionTitleArr.lastObject,oCount];
                NSMutableDictionary *popPhotoImgAndUrlDic = [[NSMutableDictionary alloc]init];
                //图片url
                [popPhotoImgAndUrlDic setValue:dic forKey:@"PhotoUrlKey"];
                //图片img
                NSMutableDictionary *imgsDic = [[NSMutableDictionary alloc]init];
                [imgsDic setValue:self.sectionOneImgArr forKey:@"H"];
                [imgsDic setValue:self.sectionTwoImgArr forKey:@"M"];
                [imgsDic setValue:self.sectionThrImgArr forKey:@"O"];
                [popPhotoImgAndUrlDic setValue:imgsDic forKey:@"PhotoImgKey"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_SUCCESS_MES(msg);
                    Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(ShopBuniessPhotoAddEnd_Notice_Name, popPhotoImgAndUrlDic);//图片url数据
                    [self popVC];
                });
            }
        }else{
           //不处理
        }
    }];
    

}
#pragma mark == delet
- (void)subImgViewsCellDeletPhotoActionWithCellType:(Cell_SubImgViews_Type)type withIndex:(NSInteger)index{
    switch (type) {
        case Cell_SubImgViews_Type_mainImg:
            [self.sectionOneImgArr removeObjectAtIndex:index];
            break;
        case Cell_SubImgViews_Type_shiNeiImg:
            [self.sectionTwoImgArr removeObjectAtIndex:index];
            break;
        case Cell_SubImgViews_Type_otherImg:
            [self.sectionThrImgArr removeObjectAtIndex:index];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}
#pragma mark == edit
- (void)subImgViewsCellEditPhotoActionWithCellType:(Cell_SubImgViews_Type)type withIndex:(NSInteger)index{
    DLog(@"编辑 %ld",(long)index);
    switch (type) {
        case Cell_SubImgViews_Type_mainImg:
           
            break;
        case Cell_SubImgViews_Type_shiNeiImg:
           
            break;
        case Cell_SubImgViews_Type_otherImg:
          
            break;
        default:
            break;
    }
}
 
#pragma mark == add
- (void)subImgViewsCellAddPhotoActionWithCellType:(Cell_SubImgViews_Type)type{
    DLog(@"");
    switch (type) {
        case Cell_SubImgViews_Type_mainImg:
            self.nowType = Cell_SubImgViews_Type_mainImg;
            break;
        case Cell_SubImgViews_Type_shiNeiImg:
            self.nowType = Cell_SubImgViews_Type_shiNeiImg;
            break;
        case Cell_SubImgViews_Type_otherImg:
            self.nowType = Cell_SubImgViews_Type_otherImg;
            break;
            
        default:
            break;
    }
    [self iconImgTap];
}

#pragma mark ==
#pragma mark == img pick

//- (void)chooseImage {
//    //照相
//    
//    //相册
//    UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
//    pickVC.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//    pickVC.delegate = self;
//    pickVC.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:pickVC animated:YES completion:nil];
//}

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
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *photo = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self imgDetalWithPhoto:photo];
}
#pragma mark === 提交img信息的 //图片上传
- (void)imgDetalWithPhoto:(UIImage *)photo{
//    if (self.nowType == Cell_SubImgViews_Type_mainImg) { //门
//        [self.sectionOneImgArr addObject:photo];
//    }else if(self.nowType == Cell_SubImgViews_Type_shiNeiImg){ //室内
//        [self.sectionTwoImgArr addObject:photo];
//    }else if(self.nowType == Cell_SubImgViews_Type_otherImg){ //其他
//        [self.sectionThrImgArr addObject:photo];
//    }
    if (photo==nil) {
        return;
    }
    switch (self.nowType) {
        case Cell_SubImgViews_Type_mainImg:
            [self.sectionOneImgArr addObject:photo];
            break;
        case Cell_SubImgViews_Type_shiNeiImg:
            [self.sectionTwoImgArr addObject:photo];
            break;
        case Cell_SubImgViews_Type_otherImg:
            [self.sectionThrImgArr addObject:photo];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 40;
    }else{
        if (indexPath.section==0) {
            return Height_cell_oneHang;
        }else if (indexPath.section==1){
            if (self.sectionTwoImgArr.count>=4) {
                return Height_cell_oneHang*2;
            }else{
                return Height_cell_oneHang;
            }
         }else{
             if (self.sectionThrImgArr.count>=4) {
                 return Height_cell_oneHang*2;
             }else{
                 return Height_cell_oneHang;
             }
            
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont systemFontOfSize:17];
            cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5];
        }
        cell.textLabel.text = self.sectionTitleArr[indexPath.section];
        cell.detailTextLabel.text = self.sectionDetailTitleArr[indexPath.section];
        return cell;
    }else{
        IssueAddPhotoVCSubImgViewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueAddPhotoVCSubImgViewsTableViewCell_Identifier];
        if (!cell) {
            cell = [[IssueAddPhotoVCSubImgViewsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueAddPhotoVCSubImgViewsTableViewCell_Identifier];
        }
        cell.delegate = self;
        if (indexPath.section==0) {
            [cell dataSourceWithImgviewsArr:self.sectionOneImgArr andType:Cell_SubImgViews_Type_mainImg];
        }else if (indexPath.section==1){
            [cell dataSourceWithImgviewsArr:self.sectionTwoImgArr andType:Cell_SubImgViews_Type_shiNeiImg];
        }else{
            [cell dataSourceWithImgviewsArr:self.sectionThrImgArr andType:Cell_SubImgViews_Type_otherImg];
        }
        return cell;
    }
}
 
#pragma mark ==
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 90)];
        [_footerView setBtnFram:CGRectMake(16, 0, Screen_W-32, 44)];
        [_footerView.footerBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnFinishAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
//
- (NSArray *)sectionTitleArr{
    if (!_sectionTitleArr) {
        _sectionTitleArr = [[NSArray alloc]initWithObjects:@"门头图（招牌照）",@"室内图",@"其他", nil];
    }
    return _sectionTitleArr;
}
- (NSArray *)sectionDetailTitleArr{
    if (!_sectionDetailTitleArr) {
        _sectionDetailTitleArr = [[NSArray alloc]initWithObjects:@"至少上传1张 1/3",@"至少上传1张 1/8",@"至少上传1张 1/8", nil];
    }
    return _sectionDetailTitleArr;
}

- (NSMutableArray *)sectionOneImgArr{
    if (!_sectionOneImgArr) {
        _sectionOneImgArr = [[NSMutableArray alloc]init];
    }
    return _sectionOneImgArr;
}
- (NSMutableArray *)sectionTwoImgArr{
    if (!_sectionTwoImgArr) {
        _sectionTwoImgArr = [[NSMutableArray alloc]init];
    }
    return _sectionTwoImgArr;
}
- (NSMutableArray *)sectionThrImgArr{
    if (!_sectionThrImgArr) {
        _sectionThrImgArr = [[NSMutableArray alloc]init];
    }
    return _sectionThrImgArr;
}
@end
