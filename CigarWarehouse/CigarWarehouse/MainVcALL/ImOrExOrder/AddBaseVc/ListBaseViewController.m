//
//  ListBaseViewController.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/20.
//

#import "ListBaseViewController.h"

typedef enum : NSUInteger {
    Photo_Choose_Type_Grapht,
    Photo_Choose_Type_Album
} Photo_Choose_Type;



@implementation BaseOfTopBtnView

- (instancetype)initWithFrame:(CGRect)frame{
    frame =  CGRectMake(0, 0, Screen_W, 80);
    self = [super initWithFrame:frame];
    if(self){
        [self addSubview:self.showImgBtn];
        [self setsubViews];
    }
    return self;
}
- (void)setsubViews{
    [_showImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_showImgBtn.superview);
        make.width.equalTo(_showImgBtn.superview).offset(-32);
        make.height.equalTo(_showImgBtn.superview).offset(-10);
    }];
    
}
- (UIButton *)showImgBtn{
    if(!_showImgBtn){
        _showImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showImgBtn newAnBtnWithImg:CC_img_placeholder_branner];
    }
    return _showImgBtn;
}

@end
@implementation BaseOfBottomBtnView

- (instancetype)initWithFrame:(CGRect)frame{
    frame =  CGRectMake(0, 0, Screen_W, 100);
    self = [super initWithFrame:frame];
    if(self){
        [self addSubview:self.footerB];
        [self setsubViews];
    }
    return self;
}
- (void)setsubViews{
    [_footerB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_footerB.superview).offset(-100);
        make.centerY.centerX.equalTo(_footerB.superview);
        make.height.offset(50);
    }];
}
- (UIButton *)footerB{
    if(!_footerB){
        _footerB = [UIButton buttonWithType:UIButtonTypeCustom];
        [_footerB newAnBtnWithTextStr:@"提交"];
        [_footerB newAnBtnWithTextColor:[UIColor whiteColor]
                          withBackColor:CC_Red_Drak_B
                               withFont:[UIFont systemFontOfSize:16.0]
                     withLayerCorNerNum:24.0 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
    }
    return _footerB;
}
@end


@interface ListBaseViewController ()

@end

@implementation ListBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.edgesForExtendedLayout = UIRectEdgeNone; // view向四周延伸 不允许
    self.navigationController.navigationBar.translucent = NO; // bar不透明
    self.extendedLayoutIncludesOpaqueBars = NO; // 在不透明情况下允许view向四周延伸 否
  //  self.automaticallyAdjustsScrollViewInsets = YES;//默认为YES，系统对tableView中的子控件下调64个点，保证tableView中的子控件不会被navigationBar覆盖。
    [self.navigationItem setBackButtonTitle:@""];//之后的返回按钮文本滞空
    [self initViews];
}
- (void)initViews{
    self.view.backgroundColor = CC_Brown_D;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];//透明色
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
    }];
    self.tableView.tableFooterView = self.footerView;
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];

    if (@available(iOS 15.0, *)) {
        [[UITableView appearance] setSectionHeaderTopPadding:0.1];
    } else {
        // Fallback on earlier versions
    }
}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    [cell setSeparatorInset:UIEdgeInsetsZero];
//    [cell setLayoutMargins:UIEdgeInsetsZero];
//}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = YES;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionHeaderHeight = 0.1;
        _tableView.sectionFooterHeight = 0.1;
        _tableView.estimatedSectionHeaderHeight = 0.1;
        _tableView.estimatedSectionFooterHeight = 0.1;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        } else {
            // Fallback on earlier versions
        }//设置这个组头顶部填充 = 0解决问题
        
        _tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (BaseOfTopBtnView *)topShowImgView{
    if (!_topShowImgView) {
        _topShowImgView = [[BaseOfTopBtnView alloc]initWithFrame:CGRectZero];
        [_topShowImgView.showImgBtn addTarget:self action:@selector(addImgBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topShowImgView;
}
- (BaseOfBottomBtnView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseOfBottomBtnView alloc]initWithFrame:CGRectZero];
        [_footerView.footerB addTarget:self action:@selector(footerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
#pragma mark === getter

- (NSMutableArray *)dataSourceTitleArr{
    if (!_dataSourceTitleArr) {
        _dataSourceTitleArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dataSourceTitleArr;
}
- (NSMutableArray *)dataSourceSourceArr{
    if (!_dataSourceSourceArr) {
        _dataSourceSourceArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dataSourceSourceArr;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceTitleArr.count;
}

#pragma mark ========= cell


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ListBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListBaseTableViewCell_I];
    if (!cell) {
        cell = [[ListBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ListBaseTableViewCell_I];
    }
    cell.titL.text = self.dataSourceTitleArr[indexPath.row];
    cell.textF.text = self.dataSourceSourceArr[indexPath.row];
    cell.textF.tag = cell_tf_BaseTag + indexPath.row;
    cell.textF.delegate = self;
    return cell;
    
   /**
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    return cell;
    */
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark === UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
  [self getTextSave:textField];

}
- (void)textFieldDidChangeSelection:(UITextField *)textField{
  [self getTextSave:textField];
}

- (void)getTextSave:(UITextField *)textField{
    NSInteger tagIndex = textField.tag-cell_tf_BaseTag;
    [self dealCellTfWithTagIndex:tagIndex withTfStr:textField.text];
    
}
- (void)dealCellTfWithTagIndex:(NSInteger)tIndex withTfStr:(NSString *)textFieldStr{
    [self.dataSourceSourceArr replaceObjectAtIndex:tIndex withObject:textFieldStr];
}

#pragma mark ===
- (void)footerBtnAction:(UIButton *)sender{
    [self.view endEditing:YES];
    DLog(@"%@ \n %@",self.dataSourceTitleArr,self.dataSourceSourceArr);
}




#pragma mark == == == == == == == == == == == == ==

- (void)addImgBtn:(UIButton *)sender{
    [self iconImgTap];
}
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
   
}

@end
