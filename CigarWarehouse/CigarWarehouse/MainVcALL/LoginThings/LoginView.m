//
//  LoginView.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/15.
//

#import "LoginView.h"


@implementation LoginViewSubCell 
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;//点击
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.separatorInset = UIEdgeInsetsMake(0, 50, 0, 50);//线位置
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.leftIcon];
        [self.contentView addSubview:self.rightBtn];
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.centerY.equalTo(_textField.superview);
            make.left.equalTo(_textField.superview).offset(100);
            make.right.equalTo(_textField.superview).offset(-100);
        }];
        [_leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_textField.mas_left).offset(-6);
            make.centerY.equalTo(_textField.superview);
            make.width.height.offset(20);
        }];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_textField.mas_right).offset(6);
            make.centerY.equalTo(_textField.superview);
            make.width.height.offset(30);
        }];
    }
    return self;
}

 
- (UIImageView *)leftIcon{
    if(!_leftIcon){
        _leftIcon = [[UIImageView alloc]init];
        _leftIcon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftIcon;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _rightBtn;
}

- (UITextField *)textField{
    if(!_textField){
        _textField = [[UITextField alloc]init];
    }
    return _textField;
}

@end

#pragma mark ==================================================================================================
@implementation LoginView 

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn newAnBtnWithTextStr:@"登录"];
        [_loginBtn newAnBtnWithFont:[UIFont boldSystemFontOfSize:18.0]];
        [_loginBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_loginBtn newAnBtnWithBackColor:CC_Brown_A];
        [_loginBtn newAnBtnWithLayerCorNerNum:10 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
    }
    return _loginBtn;
}

#define  logo_h             (130.0)
#define  sectionHeaderv_h   (80.0)
#define  tabView_oneCell_h  (60.0)

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor bm_colorGradientChangeWithSize:self.frame.size
                                                             direction:IHGradientChangeDirectionDownDiagonalLine
                                                            startColor:[CC_Brown_A colorWithAlphaComponent:0.7] endColor:CC_Brown_D];;
        [self addSubview:self.tableView];
        [self addSubview:self.loginBtn];
        self.loginUseModel = [[UserLoginUseModel alloc]init];
        
        [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_loginBtn.superview).offset(Y_Height_120);
            make.centerX.equalTo(_loginBtn.superview);
            make.width.equalTo(_loginBtn.superview).offset(-Y_Height_180);
            make.height.offset(Y_Height_50);
        }];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_tableView.superview);
            make.bottom.equalTo(_loginBtn.mas_top).offset(-30);//和按钮的间距
            make.height.offset(logo_h+sectionHeaderv_h+tabView_oneCell_h*2 +31);
        }];
        UIView *hh = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, logo_h)];
        [hh addSubview:self.hv];
        self.tableView.tableHeaderView  =  hh;
        
    }
    return self;
}
#pragma mark ===  data
- (void)fillLoginInfoAccountStr:(NSString *)astr withPasswordStr:(NSString *)pstr{
    if (isNil(self.loginUseModel)) {
        self.loginUseModel = [[UserLoginUseModel alloc]init];
    }
    self.loginUseModel.acccount = astr;
    self.loginUseModel.password = pstr;
    [self.tableView reloadData];
}
- (UIImageView *)hv{
    if (!_hv) {
        _hv = [[UIImageView alloc]initWithFrame:CGRectMake(((Screen_W-logo_h)*0.5), 0, logo_h, logo_h)];
        _hv.image  = [UIImage imageNamed:@"icon-192.png"];
//        CALayer *layer = _hv.layer;
//        layer.cornerRadius = 20;
//        layer.masksToBounds = YES;
        _hv.layer.masksToBounds = YES;
        _hv.clipsToBounds = YES;
        _hv.layer.cornerRadius = 16.0;
        _hv.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _hv;
}
- (UITableView *)tableView{
       if(!_tableView){
           _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
           _tableView.delegate = self;
           _tableView.dataSource = self;
           _tableView.backgroundColor = [UIColor clearColor];
           _tableView.tableFooterView = [UIView new];
       }
       return _tableView;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
    
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LoginViewSubCell *cell = [tableView dequeueReusableCellWithIdentifier:LoginViewSubCell_I];
    if(!cell){
        cell =  [[LoginViewSubCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LoginViewSubCell_I];
        cell.textField.delegate = self;
        cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    cell.textField.tag = 200+indexPath.row;
    if(indexPath.row == 0 ){
        cell.textField.text = [TextShowWithModelStr textShowWithModelStr:self.loginUseModel.acccount];
        cell.textField.secureTextEntry = NO;
        cell.leftIcon.image = [UIImage imageNamed:@"tob_shouji"];
        cell.rightBtn.hidden = YES;

    }else{
        cell.textField.text = [TextShowWithModelStr textShowWithModelStr:self.loginUseModel.password];
        cell.textField.secureTextEntry = YES;
        cell.leftIcon.image = [UIImage imageNamed:@"tob_suo"];
        cell.rightBtn.hidden = NO;
        [cell.rightBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"tob_zhengyan"] selectedImg:[UIImage imageNamed:@"tob_zhengyan"]];
        cell.rightBtn.hidden = YES;
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tabView_oneCell_h;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return sectionHeaderv_h;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return  [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return  [UIView new];
}
 
#pragma mark ===


- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self dealViewTag:textField.tag textStr:textField.text];
    
}
- (void)textFieldDidChangeSelection:(UITextField *)textField{
    [self dealViewTag:textField.tag textStr:textField.text];
}


- (void)textViewDidChange:(UITextView *)textView{
    [self dealViewTag:textView.tag textStr:textView.text];
}
- (void)textViewDidChangeSelection:(UITextView *)textView{
   
    [self dealViewTag:textView.tag textStr:textView.text];
}
- (void)dealViewTag:(NSInteger)tag textStr:(NSString *)dealTextStr{
    if (tag - 200 == 0) {
        self.loginUseModel.acccount = dealTextStr;
    }else{
        self.loginUseModel.password = dealTextStr;
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

@end
