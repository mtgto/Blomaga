//
//  PostViewController.h
//  Blomaga
//
//  Created by mtgto on 1/26/13.
//  Copyright (c) 2013 mtgto. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PostURLDelegate

- (void)goUrl:(NSURL *)url;

@end

@interface PostViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) id<PostURLDelegate> delegate;
- (IBAction)pushPost:(id)sender;
- (IBAction)doneTextEditing:(id)sender;

@end
