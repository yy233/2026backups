//
//  AddInvoiceView.m
//  Community
//
//  Created by 刘久炼 on 2021/2/23.
//

#import "AddInvoiceView.h"
#import "AddInvoiceTypeCell.h"
#import "AddInvoiceNormalCell.h"
#import "AddInvoiceDefaultCell.h"
#import "AddInvoiceModel.h"

@interface AddInvoiceView ()<UITableViewDelegate,UITableViewDataSource,AddInvoiceTypeCellDelegate,AddInvoiceNormalCellDelegate,AddInvoiceDefaultCellDelegate>

@property(nonatomic, strong) UITableView *tableV;


@property(nonatomic, strong) BaseTableViewFooterView *saveV;

@property(nonatomic, strong) UILabel *remarkL;

@property(nonatomic, strong) AddInvoiceModel *model;

@end


static NSString *const typeCellID = @"AddInvoiceTypeCell";
static NSString *const normalCellID = @"AddInvoiceNormalCell";
static NSString *const defaultCellID = @"AddInvoiceDefaultCell";

@implementation AddInvoiceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.model = [[AddInvoiceModel alloc] init];
        self.model.type = 0;
        self.model.isdefault = 0;
        [self initView];
    }
    return self;
}

- (void)initView{
    [self.remarkL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.bottom.offset(-10);
    }];
    
    [self.tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self.remarkL.mas_top);
    }];
}

- (UILabel *)remarkL{
    if (!_remarkL) {
        _remarkL = [[UILabel alloc] init];
        _remarkL.text = @"为方便您开票，您的发票抬头信息将用于未来物服进行统一管理";
        _remarkL.font = FontSize_Vip_Nomail(11);
        _remarkL.textColor = [Tool getColorWithHexString:@"#999999"];
        _remarkL.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_remarkL];
    }
    return _remarkL;
}

- (UITableView *)tableV{
    if (!_tableV ){
        _tableV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self addSubview:_tableV];
        _tableV.backgroundColor = [UIColor whiteColor];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableV.showsVerticalScrollIndicator = NO;
        _tableV.bounces = NO;
        if (@available(ios 11.0,*)) {
            // 针对 11.0 以上的iOS系统进行处理
            _tableV.estimatedRowHeight = 0;
            _tableV.estimatedSectionHeaderHeight = 5;
            _tableV.estimatedSectionFooterHeight = 5;
            _tableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [_tableV registerClass:[AddInvoiceTypeCell class] forCellReuseIdentifier:typeCellID];
        [_tableV registerClass:[AddInvoiceNormalCell class] forCellReuseIdentifier:normalCellID];
        [_tableV registerClass:[AddInvoiceDefaultCell class] forCellReuseIdentifier:defaultCellID];
    }
    return _tableV;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.model.type == 0) {
        return 2;
    }else{
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.model.type == 0) {
        if (section == 0) {
            return 3;
        }
        return 5;
    }else{
        
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.model.type == 0) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            AddInvoiceTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:typeCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.type = self.model.type;
            return cell;
        }else if (indexPath.section == 1 && indexPath.row == 4){
            AddInvoiceDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.isdefault = self.model.isdefault;
            return cell;
        }else{
            AddInvoiceNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.title = self.companyTitleArray[indexPath.section][indexPath.row];
            cell.pliceholder = self.companypliceholderArray[indexPath.section][indexPath.row];
            if (indexPath.section == 0) {
                switch (indexPath.row) {
                        
                    case 1:
                        cell.sub = self.model.companyName;
                        break;
                    case 2:
                        cell.sub = self.model.accont;
                        break;
                    default:
                        break;
                }
            }else{
                switch (indexPath.row) {
                        
                    case 0:
                        cell.sub = self.model.address;
                        break;
                    case 1:
                        cell.sub = self.model.tel;
                        break;
                    case 2:
                        cell.sub = self.model.bank;
                        break;
                    case 3:
                        cell.sub = self.model.bankAccont;
                        break;
                    default:
                        break;
                }
                
            }
            
            return cell;
        }
        
    }else{
        if (indexPath.row == 0) {
            AddInvoiceTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:typeCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.type = self.model.type;
            return cell;
        }else if (indexPath.row == 1){
            AddInvoiceNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.title = self.personTitleArray[indexPath.row];
            cell.pliceholder = self.personpliceholderArray[indexPath.row];
            cell.sub = self.model.personName;
            return cell;
        }else{
            
            AddInvoiceDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.isdefault = self.model.isdefault;
            return cell;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    return 54;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.model.type == 0) {
        if (section == 1) {
            return 100;
        }
    }else{
        return 50;
    }
    return 5;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    if ((self.model.type == 0 && section == 1) || self.model.type == 1) {
        BaseTableViewFooterView *saveV = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(15, 30, Screen_W-30, 50)];
        [saveV.footerBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveV.footerBtn addTarget:self action:@selector(saveBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        view.backgroundColor = [UIColor whiteColor];
        [view addSubview:saveV];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark - 数据刷新

- (void)reloadData{
    [self.tableV reloadData];
}

#pragma mark - AddInvoiceTypeCellDelegate

- (void)typeSelectedWithType:(NSInteger)type{
    self.model.type = type;
    [self.tableV reloadData];
}

#pragma mark - AddInvoiceNormalCellDelegate

- (void)subChangedWithTitle:(NSString *)title Sub:(NSString *)sub{
    if ([title isEqualToString: @"公司抬头"]) {
        self.model.companyName = sub;
    }else if ([title isEqualToString:@"公司税号"]){
        self.model.accont = sub;
    }else if ([title isEqualToString:@"公司地址"]){
        self.model.address = sub;
    }else if ([title isEqualToString:@"公司电话"]){
        self.model.tel = sub;
    }else if ([title isEqualToString:@"开户银行"]){
        self.model.bank = sub;
    }else if ([title isEqualToString:@"开户账号"]){
        self.model.bankAccont = sub;
    }else if ([title isEqualToString:@"抬头名称"]){
        self.model.personName = sub;
    }
}

#pragma mark - AddInvoiceDefaultCellDelegate
- (void)isdefaultChagedWithsIsdefalut:(NSInteger)isdefalut{
    self.model.isdefault = isdefalut;
}


#pragma mark - 按钮点击

- (void)saveBtnClicked: (UIButton *)sender{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
