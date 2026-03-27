//
//  TextFieldInfoShowCircleView.m
//  Community
//
//  Created by 余莹 on 2021/10/14.
//

#import "TextFieldInfoShowCircleView.h"
#import "CircleShowCollectionViewCell.h"
#define  CircleShowCollectionViewCell_Identifier  @"CircleShowCollectionViewCell"

@interface TextFieldInfoShowCircleView () <UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property (nonatomic,assign) NSInteger allCellNum;
@property (nonatomic,assign) CGFloat selfViewMaxWidthFlaot;
@property (nonatomic,assign) CGFloat selfViewMaxHeightFlaot;
@property (nonatomic,strong) NSMutableArray *showDataSource;
//
@property (nonatomic,assign) NSInteger beginReplaceObjIndex;
@end

@implementation TextFieldInfoShowCircleView
- (instancetype)initWithFrame:(CGRect)frame
{
    self.selfViewMaxWidthFlaot = frame.size.width;
    self.selfViewMaxHeightFlaot = frame.size.height;
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textF];
        [self addSubview:self.showBackView];
        [self.showBackView addSubview:self.showCollectionView];
        [self setUI];
    }
    return self;
}
- (NSInteger)allCellNum{
    if (!_allCellNum) {
        _allCellNum = 6;
    }
    return _allCellNum;
}
- (NSMutableArray *)showDataSource{
    if (!_showDataSource) {
        _showDataSource = [[NSMutableArray alloc]init];
        for (int i = 0; i < self.allCellNum; i++) {
            [_showDataSource addObject:@""];
        }
    }
    return _showDataSource;
}
 
#pragma mark ==
- (void)setUI{
    [_textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(2);
        make.height.offset(2);
        make.centerX.centerY.equalTo(_textF);
    }];
    [_showBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_showBackView.superview);
    }];
    [_showCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_showBackView.superview);
    }];
}

#pragma mark ==
- (void)changeItemNumWithInt:(NSInteger)ItemNum{
    if (ItemNum == 0) {
        return;
    }
    self.allCellNum = ItemNum;
    [self.showDataSource removeAllObjects];
    for (int i = 0; i < self.allCellNum; i++) {
        [self.showDataSource addObject:@""];
    }
    [self.showCollectionView reloadData];
}
#pragma mark ==
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //弹出键盘
    if (self.textF.text.length == 0) {
        self.beginReplaceObjIndex = 0;//indexPath.row;
    }else{
        self.beginReplaceObjIndex = 0;//indexPath.row;
        self.textF.text = @"";
        [self changeItemNumWithInt:self.allCellNum];
    }
    [self.textF becomeFirstResponder];
  
}
#pragma mark==
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allCellNum;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    CircleShowCollectionViewCell *cell = (CircleShowCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CircleShowCollectionViewCell_Identifier  forIndexPath:indexPath];
    cell.showLabel.text = [NSString stringWithFormat:@"%@",self.showDataSource[indexPath.row]];
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat kongGeW = (self.allCellNum +1) *10;//空格所需宽度
    CGFloat cellW = (self.selfViewMaxWidthFlaot - kongGeW) /self.allCellNum;
    CGSize  size =  CGSizeMake( cellW , self.selfViewMaxHeightFlaot);
    return size;
}

- (UICollectionView *)showCollectionView{
    if (!_showCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(40, 40);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        _showCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _showCollectionView.backgroundColor = [UIColor clearColor];
        _showCollectionView.showsVerticalScrollIndicator = NO;
        _showCollectionView.bounces = NO;
        _showCollectionView.delegate = self;
        _showCollectionView.dataSource = self;
        [_showCollectionView registerClass:[CircleShowCollectionViewCell class] forCellWithReuseIdentifier:CircleShowCollectionViewCell_Identifier];
    }
    return _showCollectionView;
}
//

#pragma mark ==
- (UITextField *)textF{
    if (!_textF) {
        _textF = [[UITextField alloc]init];
        _textF.delegate = self;
    }
    return _textF;
}
- (UIView *)showBackView{
    if (!_showBackView) {
        _showBackView = [[UIView alloc]init];
    }
    return _showBackView;
}


#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {

}
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    self.textF.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];//空格去除
    if (self.textF.text.length == self.allCellNum) {
        if (isNil(self.textCircleOkBlock)) { 
            return;
        }else{
            self.textCircleOkBlock(self.textF.text);
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.textF.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];//空格去除
    textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];//空格去除
    BOOL textShouldChangeChar = [ValidateUtil isMachPasswordWithTextField:textField anMaxNumInt:self.allCellNum String:string];

    if ((self.beginReplaceObjIndex <= self.allCellNum) && ([string isEqualToString:@"\n"]||[string isEqualToString:@""])) {//删除
        [self textCircleViewDataWithRextField:textField addYesOrDeletNoBool:NO andreplacementString:string];
    }else if (textShouldChangeChar && (self.beginReplaceObjIndex < self.allCellNum)) {//更新collectionview
        [self textCircleViewDataWithRextField:textField addYesOrDeletNoBool:YES andreplacementString:string];
    }
    return textShouldChangeChar;
}
- (void)textCircleViewDataWithRextField:(UITextField *)textField  addYesOrDeletNoBool:(BOOL)addOrDeletBool andreplacementString:(NSString *)string {
    if (addOrDeletBool) {
        [self.showDataSource replaceObjectAtIndex:self.beginReplaceObjIndex withObject:string];
        self.beginReplaceObjIndex = self.beginReplaceObjIndex + string.length;
    
    }else{
        if (self.beginReplaceObjIndex <= string.length) {
            return;
        }
        self.beginReplaceObjIndex = self.beginReplaceObjIndex - 1;
        
        if ([string isEqualToString:@"\n"]||[string isEqualToString:@""]) {
            if (isNil(string) || string.length == 0) {
                [self.showDataSource replaceObjectAtIndex:self.beginReplaceObjIndex withObject:@""];
            }else{
                [self.showDataSource replaceObjectAtIndex:self.beginReplaceObjIndex withObject:string];
            }
        }else{
            DLog(@"非删除textF的chart");
        }
    }
  
    [self.showCollectionView reloadData];
  
}

@end
