//
//  loginViewContoller.m
//  ios-demo
//
//  Created by wenxuan辛 on 15/12/2.
//  Copyright © 2015年 OTalk. All rights reserved.
//
#define kMainScreenWidth    ([UIScreen mainScreen].applicationFrame).size.width //应用程序的宽度
#define kMainScreenHeight   ([UIScreen mainScreen].applicationFrame).size.height //应用程序的高度
#define kMainBoundsHeight   ([UIScreen mainScreen].bounds).size.height //屏幕的高度

#import "loginViewContoller.h"

@interface loginViewContoller ()<UITextFieldDelegate>
{
     UITextField *_userNameTextField;
    UIButton *_loginButton;
    UIButton *_cancelButton;
}

@end

@implementation loginViewContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 60, kMainScreenWidth-40, 39)];
    _userNameTextField.backgroundColor = [UIColor clearColor];
    _userNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _userNameTextField.adjustsFontSizeToFitWidth = YES;
    _userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    _userNameTextField.keyboardType = UIKeyboardTypeDefault;
    _userNameTextField.placeholder = @"RoomID";
    _userNameTextField.backgroundColor=[UIColor whiteColor];
    _userNameTextField.font = [UIFont systemFontOfSize:16.0f];
    _userNameTextField.textAlignment = NSTextAlignmentLeft;
    _userNameTextField.textColor =[UIColor blackColor];
    _userNameTextField.tag = 100;
    [_userNameTextField setDelegate:self];
    _userNameTextField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_userNameTextField];
    
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginButton.frame = CGRectMake(20, 120, kMainScreenWidth-40, 40);
    [_loginButton setBackgroundColor:[UIColor grayColor]];
    [_loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [_loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [_loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(20, 180, kMainScreenWidth-40, 40);
    [_cancelButton setBackgroundColor:[UIColor grayColor]];
    [_cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
    [_cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginButtonClicked:(id)sender
{
    [[self view] endEditing:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"roomid" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[_userNameTextField text], @"roomid",nil]];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)cancelButtonClicked:(id)sender
{
    [[self view] endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
