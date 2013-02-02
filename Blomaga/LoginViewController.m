//
//  LoginViewController.m
//  Blomaga
//
//  Created by mtgto on 2/1/13.
//  Copyright (c) 2013 mtgto. All rights reserved.
//

#import "LoginViewController.h"
#import "NicoAPIClient.h"
#import "MBProgressHUD.h"
#import "SSKeychain.h"

NSString* const serviceName = @"blomaga";

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSArray *mailAddresses = [SSKeychain accountsForService:serviceName];
    DDLogVerbose(@"mailAddresses = %@", mailAddresses);
    if ([mailAddresses count]) {
        NSString *mailAddress = mailAddresses[0][kSSKeychainAccountKey];
        NSString *password = [SSKeychain passwordForService:serviceName account:mailAddress];
        self.mailAddressField.text = mailAddress;
        self.passwordField.text = password;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushLogin:(id)sender {
    if ([self.mailAddressField isFirstResponder]) {
        [self.mailAddressField resignFirstResponder];
    }
    if ([self.passwordField isFirstResponder]) {
        [self.passwordField resignFirstResponder];
    }
    NicoAPIClient *client = [[NicoAPIClient alloc] init];
    NSString *mailAddress = self.mailAddressField.text;
    NSString *password = self.passwordField.text;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [client loginWithMail:mailAddress
                 password:password
                  success:^(NicoAPIClient *client, NSURL *nextUrl) {
                      if (![nextUrl.host isEqualToString:@"secure.nicovideo.jp"]) {
                          hud.labelText = @"ログイン完了";
                          hud.progress = 1.0f;
                          hud.mode = MBProgressHUDModeCustomView;
                          hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok.png"]];
                          for (NSString *account in [SSKeychain accountsForService:serviceName]) {
                              [SSKeychain deletePasswordForService:serviceName account:account];
                          }
                          [SSKeychain setPassword:password forService:serviceName account:mailAddress];
                          [hud hide:YES afterDelay:1.0f];
                          [self.delegate setPostButtonVisible:YES];
                          [self.delegate goUrl:nextUrl];
                          [self dismissViewControllerAnimated:YES completion:^{
                              ;
                          }];
                      } else {
                          hud.labelText = @"ログイン失敗";
                          hud.progress = 1.0f;
                          hud.mode = MBProgressHUDModeCustomView;
                          hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fail.png"]];
                          [hud hide:YES afterDelay:1.0f];
                      }
                  }
                  failure:^(NicoAPIClient *client) {
                      hud.labelText = @"ログイン失敗";
                      hud.progress = 1.0f;
                      hud.mode = MBProgressHUDModeCustomView;
                      hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fail.png"]];
                      [hud hide:YES afterDelay:1.0f];
                  }];
}

- (IBAction)pushNoLogin:(id)sender {
    [self.delegate setPostButtonVisible:NO];
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}
@end
