//
//  LoginViewController.h
//  Blomaga
//
//  Created by User on 2/1/13.
//  Copyright (c) 2013 mtgto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *mailAddressField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)pushLogin:(id)sender;
- (IBAction)pushNoLogin:(id)sender;

@end
