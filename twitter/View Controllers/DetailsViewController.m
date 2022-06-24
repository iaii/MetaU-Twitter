//
//  DetailsViewController.m
//  twitter
//
//  Created by Apoorva Chilukuri on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.tweet);
    self.username.text = self.tweet.user.screenName;
    self.name.text = self.tweet.user.name;

    self.tweetBody.text = self.tweet.text;

    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.profilePicture.image = [UIImage imageWithData:urlData];
        
    self.favoriteCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    
    NSLog(@"username");
    NSLog(@"%@", self.username.text);
}

- (IBAction)didTapReply:(id)sender {
    
}
- (IBAction)didTapRetweet:(id)sender {
    if(self.tweet.retweeted){
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        
        [self.retweetIcon setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
        
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error un-retweeting the tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully un-retweeted the tweet: %@", tweet.text);
             }
         }];
    }else{
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        
        [self.retweetIcon setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
        
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){

                 NSLog(@"Error retweeting the tweet: %@", error.localizedDescription);
             }             else{
                 NSLog(@"Successfully retweeted the tweet: %@", tweet.text);
             }
         }];
    }
    
    [self refreshData];
}
- (IBAction)didTapFavorite:(id)sender {
    if(self.tweet.favorited){
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        
        [self.favIcon setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
        
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
             }
         }];
    }else{
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        
        [self.favIcon setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
        
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){

                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }             else{
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
             }
         }];
    }
    
    [self refreshData];
}
- (IBAction)didTapShare:(id)sender {
}

- (void)refreshData {
    self.favoriteCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
}
@end
