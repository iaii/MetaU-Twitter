//
//  ComposeViewController.m
//  twitter
//
//  Created by Apoorva Chilukuri on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "TimelineViewController.h"
#import "APIManager.h"

@interface ComposeViewController ()
- (IBAction)didTapPostTweet:(id)sender;
- (IBAction)didTapClose:(id)sender;
@end


@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // if([self textView:_composeTweet shouldChangeTextInRange:<#(NSRange)#> replacementText:<#(NSString *)#>]){
        
    }
    


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    self.composeTweet.delegate = self;
    // Set the max character limit
    int characterLimit = 140;

    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.composeTweet.text stringByReplacingCharactersInRange:range withString:text];

    // TODO: Update character count label
    self.charCount.text = newText;

    // Should the new text should be allowed? True/False
    return newText.length < characterLimit;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)didTapPostTweet:(id)sender {
    
    NSString *tweetText = _composeTweet.text;
    
    [[APIManager shared]postStatusWithText:tweetText completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            NSLog(@"Compose Tweet Success!");
        }
    }];
}

@end
