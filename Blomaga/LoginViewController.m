//
//  LoginViewController.m
//  Blomaga
//
//  Created by User on 2/1/13.
//  Copyright (c) 2013 mtgto. All rights reserved.
//

#import "LoginViewController.h"
#import "NicoAPIClient.h"
#import "MBProgressHUD.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushLogin:(id)sender {
    NicoAPIClient *client = [[NicoAPIClient alloc] init];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [client loginWithMail:self.mailAddressField.text
                 password:self.passwordField.text
                  success:^(NicoAPIClient *client, NSURL *nextUrl) {
                      if (![nextUrl.host isEqualToString:@"secure.nicovideo.jp"]) {
                          hud.labelText = @"ログイン完了";
                          hud.progress = 1.0f;
                          hud.mode = MBProgressHUDModeCustomView;
                          hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok.png"]];
                          [hud hide:YES afterDelay:1.0f];
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
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}
@end
