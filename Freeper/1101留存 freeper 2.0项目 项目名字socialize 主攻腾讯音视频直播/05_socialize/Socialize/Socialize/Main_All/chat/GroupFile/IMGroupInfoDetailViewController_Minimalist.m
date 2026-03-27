//
//  IMGroupInfoDetailViewController_Minimalist.m
//  Socialize
//
//  Created by 余莹 on 2023/5/18.
//

#import "IMGroupInfoDetailViewController_Minimalist.h"

@interface IMGroupInfoDetailViewController_Minimalist ()

@end

@implementation IMGroupInfoDetailViewController_Minimalist

#define  kTheme_Type_Key   @"Theme_Type"
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *nowThemeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:kTheme_Type_Key];//Theme_Type #define  kTheme_Type_Key   @"Theme_Type"
    if([nowThemeStr isEqualToString: @"light"]){
        self.view.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str]; //底部背景露出一截了

    }else{
        self.view.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Drak_Str ];;


    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
