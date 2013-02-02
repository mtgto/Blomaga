//
//  ViewController.h
//  Blomaga
//
//  Created by mtgto on 1/26/13.
//  Copyright (c) 2013 mtgto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowURLDelegate.h"

@interface ViewController : UIViewController<UIWebViewDelegate, ShowURLDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)pushHome:(id)sender;

@end
