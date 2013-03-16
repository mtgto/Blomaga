//
//  LoginViewController.h
//  Blomaga
//
//  Created by mtgto on 2/1/13.
//  Copyright (c) 2013 mtgto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowURLDelegate.h"

@interface LoginViewController : UIViewController
@property (weak, nonatomic) id<ShowURLDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *mailAddressField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)pushLogin:(id)sender;

@end
