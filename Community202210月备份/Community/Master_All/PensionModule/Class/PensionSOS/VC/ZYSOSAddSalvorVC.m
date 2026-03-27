//
//  ZYSOSAddSalvorVC.m
//  Community
//
//  Created by ZY on 2021/11/17.
//

#import "ZYSOSAddSalvorVC.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "ZYSOSAddSalvorBottomView.h"
#import "ZYSOSAddSalvorCell.h"

static NSString * const SOSAddSalvorCellID = @"ZYSOSAddSalvorCell";

#define kSOSAddSalvorBottomViewHeight button_bottom_height+140
#define kSOSAddSalvorCellHeight 230

@interface ZYSOSAddSalvorVC ()<UITableViewDataSource, UITableViewDelegate, CNContactPickerDelegate, ZYSOSAddSalvorBottomViewDelegate ,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYSOSAddSalvorBottomView *bottomView;


@end

@implementation ZYSOSAddSalvorVC
- (SosAddressBookFamilyModel *)saveEditOrAddFamilyModel{
    if (!_saveEditOrAddFamilyModel) {
        _saveEditOrAddFamilyModel = [[SosAddressBookFamilyModel alloc]init];
    }
    return _saveEditOrAddFamilyModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self setUI];
    [self customTableView];
    if (self.isEditTypeBool) {
        self.title = @"修改救助者";
        [self.tableView reloadData];
    }else{
        self.title = @"添加救助者";
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarStyleWithSOSColor];
}

- (void)setUI {
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_bottomView.superview);
        make.height.offset(kSOSAddSalvorBottomViewHeight);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_tableView.superview);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
    if (self.isEditTypeBool) {
        [self.bottomView.okButton  newAnBtnWithTextStr:@"确认修改"];
    }else{
        [self.bottomView.okButton  newAnBtnWithTextStr:@"确认添加"];
    }
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
    }
    
    return _tableView;
}

- (ZYSOSAddSalvorBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYSOSAddSalvorBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

#pragma mark - 定制tableView
- (void)customTableView {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:SOSAddSalvorCellID bundle:nil] forCellReuseIdentifier:SOSAddSalvorCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYSOSAddSalvorCell *cell = [tableView dequeueReusableCellWithIdentifier:SOSAddSalvorCellID forIndexPath:indexPath];
    cell.nameTF.tag = 500;
    cell.nameTF.delegate = self;
    cell.telTF.tag =  501;
    cell.telTF.delegate = self;
    //
    cell.nameTF.text = [TextShowWithModelStr textShowWithModelStr:self.saveEditOrAddFamilyModel.name];
    cell.telTF.text = [TextShowWithModelStr textShowWithModelStr:self.saveEditOrAddFamilyModel.mobile];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kSOSAddSalvorCellHeight;
}

#pragma mark - CNContactPickerDelegate
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    
    CNContact *contact = contactProperty.contact;
    NSString  *name = [NSString stringWithFormat:@"%@%@",contact.familyName, contact.givenName];
    NSString  *phone = [[[contactProperty.value stringValue] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSIndexPath *indePath = [NSIndexPath indexPathForRow:0 inSection:0];
    ZYSOSAddSalvorCell *cell = [self.tableView cellForRowAtIndexPath:indePath];
    cell.nameTF.text = name;
    cell.telTF.text = phone;
    //倒入的数据存储
    self.saveEditOrAddFamilyModel.name = name;
    self.saveEditOrAddFamilyModel.mobile = phone;
}

#pragma mark === UITextFieldDelegate
 
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self getTextSave:textField];

}
- (void)textFieldDidChangeSelection:(UITextField *)textField{
    [self getTextSave:textField];
}

- (void)getTextSave:(UITextField *)textField{
    if (textField.tag == 500) {
        self.saveEditOrAddFamilyModel.name = [TextShowWithModelStr textShowWithModelStr:textField.text];
    }else{
        self.saveEditOrAddFamilyModel.mobile = [TextShowWithModelStr textShowWithModelStr:textField.text];
    }
}
#pragma mark - ZYSOSAddSalvorBottomViewDelegate
// 确认
- (void)okButtonEvent {
    [self.view endEditing:YES];
    NSLog(@"确认");
    if (self.saveEditOrAddFamilyModel.name.length==0 || self.saveEditOrAddFamilyModel.mobile.length==0) {
        Y_SVP_SHOW_ERR_MES(@"请输入！");
        return;
    }
    if ( self.saveEditOrAddFamilyModel.mobile.length<8) {
        Y_SVP_SHOW_ERR_MES(@"联系号码有误！");
        return;
    }
    WEAKSELF
    //修改 添加
    if (self.isEditTypeBool) {
        [PersionSosData editFamilysOfNowFamilyId:self.saveNowFamilyModel.ID withNameStr:self.saveEditOrAddFamilyModel.name withMobile:self.saveEditOrAddFamilyModel.mobile withChangeInfoId:self.saveEditOrAddFamilyModel.ID  withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
            if (success) {
                Y_NSNotificationCenter_PostNotice_NilObject_Name(NoticeName_SosAddressUpData);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf popVC];
                });
            }
        }];
    }else{
        [PersionSosData addFamilysOfNowFamilyId:self.saveNowFamilyModel.ID withNameStr:self.saveEditOrAddFamilyModel.name withMobile:self.saveEditOrAddFamilyModel.mobile withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
            if (success) {
                Y_NSNotificationCenter_PostNotice_NilObject_Name(NoticeName_SosAddressUpData);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf popVC];
                });
            }
        }];
    }
    
}

// 导入通讯录
- (void)inputButtonEvent {
    
    NSLog(@"导入通讯录");
    if ([[ZYAuthorizationManager sharedManager] requestAuthorization:KABAddressBook presentVc:self]) {
        // 已经授权
        CNContactPickerViewController * contactPickerVc = [CNContactPickerViewController new];
        contactPickerVc.delegate = self;
        contactPickerVc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:contactPickerVc animated:YES completion:nil];
    }
}

@end
