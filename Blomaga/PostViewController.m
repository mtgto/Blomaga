//
//  PostViewController.m
//  Blomaga
//
//  Created by mtgto on 1/26/13.
//  Copyright (c) 2013 mtgto. All rights reserved.
//

#import "PostViewController.h"
#import "NicoAPIClient.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Resize.h"
#import "MBProgressHUD.h"

@interface PostViewController ()

@property (nonatomic, strong) NSDictionary *parameters;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIPopoverController *imagePopoverController;
@end

@implementation PostViewController

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
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.textView.layer.cornerRadius = 8;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [self.imageView addGestureRecognizer:tapGestureRecognizer];
    UITapGestureRecognizer *bgTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    [self.view addGestureRecognizer:bgTapGestureRecognizer];

    NicoAPIClient *apiClient = [[NicoAPIClient alloc] init];
    [apiClient getNewArticleSuccess:^(NicoAPIClient *client, NSDictionary *parameters) {
        if (!parameters[@"article_id"]) {
            // No authentication to write new article
        }
        self.parameters = parameters;
        DDLogVerbose(@"success");
    } failure:^(NicoAPIClient *client) {
        DDLogVerbose(@"failure");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushPost:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"投稿中";
    NicoAPIClient *apiClient = [[NicoAPIClient alloc] init];
    void (^sendArticle)(NSString *) = ^(NSString *imageUrl) {
        NSString *body = self.textView.text;
        if (imageUrl) {
            body = [body stringByAppendingFormat:@"<br><br><img src=\"%@\" height=\"400px\" style=\"\">", imageUrl];
        }
        Article *article = [[Article alloc] initWithId:self.parameters[@"article_id"]
                                               subject:self.titleField.text
                                                  body:body
                                                blogId:self.parameters[@"blog_id"]
                                             channelId:self.parameters[@"channel_id"]
                                            screenName:self.parameters[@"screen_name"]
                                                   key:self.parameters[@"key"]
                                              apiToken:self.parameters[@"scp_api_token"]
                                                  time:self.parameters[@"time"]];
        [apiClient sendArticle:article
                       success:^(NicoAPIClient *client, NSURL *nextUrl) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               if ([nextUrl.path hasPrefix:@"/tool/blomaga/edit"]) {
                                   hud.labelText = @"投稿に失敗しました";
                                   hud.progress = 1.0f;
                                   hud.mode = MBProgressHUDModeCustomView;
                                   hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fail.png"]];
                                   [hud hide:YES afterDelay:1.0f];
                               } else {
                                   hud.labelText = @"完了";
                                   hud.progress = 1.0f;
                                   [hud hide:YES afterDelay:1.0f];
                                   hud.mode = MBProgressHUDModeCustomView;
                                   hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok.png"]];
                                   [self.navigationController dismissViewControllerAnimated:YES completion:^{

                                   }];
                               }
                           });
                       } failure:^(NicoAPIClient *client) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               hud.labelText = @"投稿に失敗しました";
                               hud.progress = 1.0f;
                               hud.mode = MBProgressHUDModeCustomView;
                               hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fail.png"]];
                               [hud hide:YES afterDelay:1.0f];
                           });
                       }];
    };
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        if (self.image) {
            hud.detailsLabelText = @"画像の投稿中";
            NSData *data = UIImageJPEGRepresentation(self.image, 0.5f);
            NicoAPIClient *apiClient = [[NicoAPIClient alloc] init];
            [apiClient sendImageData:data
                           channelId:self.parameters[@"channel_id"]
                           articleId:self.parameters[@"article_id"]
                               token:self.parameters[@"key"]
                                time:self.parameters[@"time"]
                             success:^(NicoAPIClient *client, NSString *imageUrl) {
                                 hud.detailsLabelText = nil;
                                 sendArticle(imageUrl);
                             }
                            progress:^(NicoAPIClient *client, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                                hud.progress = (long double)totalBytesWritten / totalBytesExpectedToWrite;
                            } failure:^(NicoAPIClient *client) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    hud.labelText = @"失敗しました";
                                    hud.progress = 1.0f;
                                    hud.mode = MBProgressHUDModeCustomView;
                                    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fail.png"]];
                                    [hud hide:YES afterDelay:1.0f];
                                });
                            }];
        } else {
            sendArticle(nil);
        }
    });
}

- (IBAction)doneTextEditing:(id)sender {
    [sender resignFirstResponder];
}

- (void)backgroundTapped:(id)sender
{
    [self.textView resignFirstResponder];
    [self.titleField resignFirstResponder];
}

- (void)imageTapped:(id)sender {
    DDLogVerbose(@"imageTapped");
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.imagePopoverController = [[UIPopoverController alloc] initWithContentViewController:picker];
        [self.imagePopoverController presentPopoverFromBarButtonItem:sender
                                   permittedArrowDirections:UIPopoverArrowDirectionAny
                                                   animated:YES];
    } else {
        [self.navigationController presentViewController:picker animated:YES completion:^{
            
        }];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    DDLogVerbose(@"didFinishPickingMediaWithInfo");
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.image = [originalImage resizedImageToFitInSize:CGSizeMake(800.f, 800.f) scaleIfSmaller:NO];
    self.imageView.image = self.image;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self.imagePopoverController dismissPopoverAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    DDLogVerbose(@"imagePickerControllerDidCancel");
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

@end
