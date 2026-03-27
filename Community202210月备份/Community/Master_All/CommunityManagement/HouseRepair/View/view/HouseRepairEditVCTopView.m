//
//  HouseRepairEditVCTopView.m
//  Community
//
//  Created by 余莹 on 2020/12/26.
//

#import "HouseRepairEditVCTopView.h"
#import "HouseRepairEditCellSubTextFieldTableViewCell.h"
#import "HouseRepairEditCellSubTypeBtnCollectionViewCell.h"
#define HouseRepairEditCellSubTextFieldTableViewCell_Identifier                @"HouseRepairEditCellSubTextFieldTableViewCell"
#define HouseRepairEditCellSubTextFieldAndChooseBtnTableViewCell_Identifier    @"HouseRepairEditCellSubTextFieldAndChooseBtnTableViewCell"
#define HouseRepairEditCellSubTextFieldOnlyShowTitleTableViewCell_Identifier   @"HouseRepairEditCellSubTextFieldOnlyShowTitleTableViewCell"
#define HouseRepairEditCellSubTypeBtnCollectionViewCell_Identifier             @"HouseRepairEditCellSubTypeBtnCollectionViewCell"
#define HouseRepairEditCellSubTwoChooseBtnTableViewCell_Identifier             @"HouseRepairEditCellSubTwoChooseBtnTableViewCell"
//用倍数--- (  make.height.offset(Screen_H*0.5-20);
#define Cell_H_TableViewCell                ((Screen_H/4)/5)
//#define Cell_H_CollectionViewCell           ((Screen_H/4)*0.25)
//#define Cell_W_CollectionViewCell           ((Screen_W-32)*0.5)
#define Cell_H_CollectionViewCell           ((Screen_H/4-50)*0.25)
#define Cell_W_CollectionViewCell           (((Screen_W-32)-40)*0.5)

#define Tag_TextField 300
@interface HouseRepairEditVCTopView () <UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,HouseRepairEditCellSubTwoChooseBtnTableViewCellDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *typeBackView;
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *titleArr;
@property (nonatomic,strong) NSMutableArray *titlePlaceholderArr;
@property (nonatomic,strong) NSMutableArray *detailArr;

@property (nonatomic,assign) Repair_Type_PersonalOrPublic personalOrPublicType;

@end
@implementation HouseRepairEditVCTopView

#pragma mark ===
//个人报修 改UI
- (void)changeRepairTypePersonalWithChangUI{
    self.titleArr = [NSMutableArray arrayWithObjects:@"报修类别",@"报修人",@"联系电话",@"报修地址",@"报修事项", nil];
    self.titlePlaceholderArr = [NSMutableArray arrayWithObjects:@"",@"请输入报修人",@"请输入联系电话",@"请选择  ",@"", nil];//空格 用于该cellUI右按钮不重叠 无效
    self.detailArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", nil]; //占位
    self.personalOrPublicType = Repair_Type_PersonalOrPublic_Person;
    [self.tableView reloadData];
}
// 公共报修
- (void)changeRepairTypePublicWithChangUI{
    self.titleArr = [NSMutableArray arrayWithObjects:@"报修类别",@"报修人",@"联系电话",@"所在社区",@"详细地址",@"报修事项", nil];
    self.titlePlaceholderArr = [NSMutableArray arrayWithObjects:@"",@"请输入报修人",@"请输入联系电话",@"请选择  ",@"请输入详细地址  ",@"", nil];//空格 用于该cellUI右按钮不重叠 无效
    self.detailArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"", nil]; //占位
    self.personalOrPublicType = Repair_Type_PersonalOrPublic_Public;
    [self.tableView reloadData];
}

#pragma mark ===
//当前报修类型arr
- (void)setTypeArr:(NSMutableArray *)typeArr{
    self.arrOfTypeSelected = [[NSMutableArray alloc]init];
    for (int i = 0; i <typeArr.count; i++) {
        [self.arrOfTypeSelected addObject:@(0)];
    }
    _typeArr = typeArr;
    [self.collectionView reloadData];
}
//当前报修地址__个人（房屋地址） 公共（小区地址）
- (void)setAddressShowStr:(NSString *)addressStr{
    self.model.address = addressStr;
    self.detailArr[3] =  self.model.address;
    [self.tableView reloadData];
}
#pragma mark ===
- (void)textFieldDidChangeSelection:(UITextField *)textField{
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag-Tag_TextField == 1) {
        self.model.name = textField.text;
        self.detailArr[1] = [TextShowWithModelStr textShowWithModelStr: self.model.name];
    }
    if (textField.tag-Tag_TextField == 2) {
        self.model.phone = textField.text;
        self.detailArr[2] = [TextShowWithModelStr textShowWithModelStr: self.model.phone];
        
    }
    if (self.personalOrPublicType==Repair_Type_PersonalOrPublic_Public) {
        if (textField.tag-Tag_TextField == 4) {//公共报修情况下的详细地址
            self.model.detailAddress = textField.text;
            self.detailArr[4] = [TextShowWithModelStr textShowWithModelStr: self.model.detailAddress];
        }
    }
   
}
#pragma mark ==
- (void)chooseBtnWithRepairType:(Repair_Type_PersonalOrPublic)type{
    self.model.type = type;
    if (_delegate && [_delegate respondsToSelector:@selector(changRepairType:)]) {
        [_delegate changRepairType:type];
    }
    
}
#pragma mark === tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return Cell_H_TableViewCell;
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.personalOrPublicType == Repair_Type_PersonalOrPublic_Person) {//个人报修 5
//    }else{//公共报修  6
//    }
    
    if (indexPath.row==0) {
        HouseRepairEditCellSubTwoChooseBtnTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:HouseRepairEditCellSubTwoChooseBtnTableViewCell_Identifier];
        if (!cell) {
            cell = [[HouseRepairEditCellSubTwoChooseBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRepairEditCellSubTwoChooseBtnTableViewCell_Identifier];
        }
        cell.titleLabel.text = self.titleArr[indexPath.row];
        cell.delegate = self;
        return cell;
    }else if (indexPath.row==3){
        HouseRepairEditCellSubTextFieldAndChooseBtnTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:HouseRepairEditCellSubTextFieldAndChooseBtnTableViewCell_Identifier];
        if (!cell) {
            cell = [[HouseRepairEditCellSubTextFieldAndChooseBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRepairEditCellSubTextFieldAndChooseBtnTableViewCell_Identifier];
        }
        cell.titleLabel.text = self.titleArr[indexPath.row];
        cell.textField.text = self.detailArr[indexPath.row];
        [cell.textField mainModuleAttributedPlaceholderNewColorWithStr:self.titlePlaceholderArr[indexPath.row]];
        [cell.textFieldTopChooseBtn addTarget:self action:@selector(chooseHouseAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1){//[tableView numberOfSections]-1 (indexPath.row==4)
        HouseRepairEditCellSubTextFieldOnlyShowTitleTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:HouseRepairEditCellSubTextFieldOnlyShowTitleTableViewCell_Identifier];
        if (!cell) {
            cell = [[HouseRepairEditCellSubTextFieldOnlyShowTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRepairEditCellSubTextFieldOnlyShowTitleTableViewCell_Identifier];
        }
        cell.titleLabel.text = self.titleArr[indexPath.row];
        cell.lineView.hidden = YES;
        return cell;
    }else{
        HouseRepairEditCellSubTextFieldTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:HouseRepairEditCellSubTextFieldTableViewCell_Identifier];
        if (!cell) {
            cell = [[HouseRepairEditCellSubTextFieldTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRepairEditCellSubTextFieldTableViewCell_Identifier];
        }
        cell.titleLabel.text = self.titleArr[indexPath.row];
        cell.textField.text = self.detailArr[indexPath.row];
        cell.textField.delegate = self;
        cell.textField.tag = Tag_TextField + indexPath.row;
        [cell.textField mainModuleAttributedPlaceholderNewColorWithStr:self.titlePlaceholderArr[indexPath.row]];
        cell.lineView.hidden = NO;
        return cell;
    }
 
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)chooseHouseAction:(UIButton *)sender{
    //选择房屋
    if (_delegate &&[_delegate respondsToSelector:@selector(touchUpToChooseHousel)]) {
            [_delegate touchUpToChooseHousel];
    }
}

#pragma mark === collectionView
#pragma mark ==== center one
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectItemAtIndexPath");
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.arrOfTypeSelected[indexPath.item] = @(1);
    for (int i = 0; i < self.arrOfTypeSelected.count; i ++) {
        if (i  != indexPath.item) {
            self.arrOfTypeSelected[i] = @(0);
        }
    }
    [self.collectionView reloadData];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.typeArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HouseRepairEditCellSubTypeBtnCollectionViewCell *cell = (HouseRepairEditCellSubTypeBtnCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:HouseRepairEditCellSubTypeBtnCollectionViewCell_Identifier  forIndexPath:indexPath];
    HouseRepairTypeModel *model = self.typeArr[indexPath.item];
    cell.titleLabel.text = [TextShowWithModelStr textShowWithModelStr:model.constName] ;
    if ([self.arrOfTypeSelected[indexPath.item] isEqual:@(0)]) {
        [cell nowSelectedType:NO];
    }else{
        [cell nowSelectedType:YES];
    }
    return cell;
}

#pragma mark == initWithFrame
- (instancetype)initWithFrame:(CGRect)frame{
    self.personalOrPublicType = Repair_Type_PersonalOrPublic_Person;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
        [self addSubview:self.tableView];
        [self addSubview:self.typeBackView];
        [self.typeBackView addSubview:self.collectionView];
        [self setUI];
      
    }
    return self;
}
- (void)setUI{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {//0.5
        make.top.equalTo(_tableView.superview.mas_top);
        make.left.equalTo(_tableView.superview.mas_left);
        make.right.equalTo(_tableView.superview.mas_right);
//        make.height.equalTo(_tableView.superview.mas_height).multipliedBy(0.5);
        make.height.equalTo(_tableView.superview.mas_height).multipliedBy(0.6);
    }];
    [_typeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_bottom);
        make.width.equalTo(_typeBackView.superview.mas_width).offset(-20);
        make.centerX.equalTo(_typeBackView.superview.mas_centerX);
        make.height.equalTo(_typeBackView.superview.mas_height).multipliedBy(0.5);
       
    }];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {//0.5
        make.edges.equalTo(_collectionView.superview);
    }];
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (UIView *)typeBackView{
    if (!_typeBackView) {
        _typeBackView = [[UIView alloc]init];
    }
    return _typeBackView;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(Cell_W_CollectionViewCell,Cell_H_CollectionViewCell);
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(10,5, 10, 5);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//UICollectionViewScrollDirectionHorizontal;//竖
    
//        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,Cell_W_CollectionViewCell*2,Cell_H_CollectionViewCell*4) collectionViewLayout:flowLayout];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,Cell_W_CollectionViewCell*2,Cell_H_CollectionViewCell*3) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[HouseRepairEditCellSubTypeBtnCollectionViewCell class] forCellWithReuseIdentifier:HouseRepairEditCellSubTypeBtnCollectionViewCell_Identifier];
        _collectionView.scrollEnabled = YES;
    }
    return _collectionView;
}
#pragma mark  ===
- (NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [NSMutableArray arrayWithObjects:@"报修类别",@"报修人",@"联系电话",@"报修地址",@"报修事项", nil];
    }
    return _titleArr;
}
- (NSMutableArray *)titlePlaceholderArr{
    if (!_titlePlaceholderArr) {
        _titlePlaceholderArr = [NSMutableArray arrayWithObjects:@"",@"请输入报修人",@"请输入联系电话",@"请选择  ",@"", nil];//空格 用于该cellUI右按钮不重叠 无效
    }
    return _titlePlaceholderArr;
}
- (NSMutableArray *)detailArr{
    if (!_detailArr) {
        _detailArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", nil]; //占位
    }
    return _detailArr;
}

#pragma mark ==
- (HouseRepairEditModel *)model{
    if (!_model) {
        _model = [[HouseRepairEditModel alloc]init];
    }
    return _model;
}
@end
