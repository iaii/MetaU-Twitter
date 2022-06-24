//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIRefreshControl *refreshControl;
- (IBAction)didTapLogout:(id)sender;

@end

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@end


@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(setTimeline) forControlEvents:(UIControlEventValueChanged)];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self setTimeline];
}

- (void) setTimeline{
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            for (Tweet *tweet in tweets) {
                NSString *text = tweet.text;
                NSLog(@"%@", text);
                self.arrayOfTweets = (NSMutableArray *)tweets;
                [self.tableView reloadData];
            }
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    TweetCell *tweetCell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    tweetCell.tweet = tweet;
    

    tweetCell.username.text = tweet.user.screenName;
    tweetCell.name.text = tweet.user.name;
    
    tweetCell.tweetBody.text = tweet.text;
    //NSLog(tweetCell.tweetBody.text);

    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    tweetCell.profilePicture.image = [UIImage imageWithData:urlData];
        
    tweetCell.favoriteCount.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    tweetCell.retweetCount.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    
//    //string that hold the api data
//    NSString *createdAtOriginalString = dictionary[@"created_at"];
//    //date formatter object to help format the date object we will make
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    // Configure the input format to parse the date string (this is the format codepath uses originally)
//    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
//
//    //Creating a time interval object with the difference between the current time and time the tweet was posted
//    //Form two dates to subtract the time between them pretty much
//    NSDate *tweetDate = [formatter dateFromString:createdAtOriginalString];
//    NSDate *curDate = [NSDate date];
//    NSTimeInterval diff = [curDate timeIntervalSinceDate:tweetDate];
//
//    //format the created string based on if it was tweeted an hour or more ago or a minute or more ago
//    NSInteger interval = diff; // Apparently you can just convert timeintervals to integers
//    long seconds = interval % 60; //the integer will be in the format 238132 or smth like that so if we % 60 we get the remaining seconds since each 60 in the interval is a second
//    long minutes = (interval / 60) % 60; //dividing by 60 then doing modulo gets the minutes because thats the remaining minutes when dividing by hours
//    long hours = (interval / 3600); //this is just the whole number of hours spent
//    //then you format the string based on if there were any hours spent if not then minutes if not then seconds like how twitter does
//    if(hours > 1) {
//        self.createdAtString = [NSString stringWithFormat:@"%ldh", hours];
//    } else if(minutes > 1) {
//        self.createdAtString = [NSString stringWithFormat:@"%ldm", minutes];
//    } else {
//        self.createdAtString = [NSString stringWithFormat:@"%lds", seconds];
//    }
//
//



    return tweetCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}



//  Makes a network request to get updated data
//  Updates the tableView with the new data
//  Hides the RefreshControl
//- (void)beginRefresh:(UIRefreshControl *)refreshControl {
//
//        // Create NSURL and NSURLRequest
//
//        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
//                                                              delegate:nil
//                                                         delegateQueue:[NSOperationQueue mainQueue]];
//        session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
//
//        NSURLSessionDataTask *task = [session dataTaskWithRequest: request
//                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//
//           // ... Use the new data to update the data source ...
//
//           // Reload the tableView now that there is new data
//            [self.tableView reloadData];
//
//           // Tell the refreshControl to stop spinning
//            [refreshControl endRefreshing];
//
//        }];
//
//        [task resume];
//}


- (void)didTweet:(Tweet *)tweet {
    [self viewDidLoad];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if(([[segue identifier] isEqualToString:@"CompareViewController"])){
       UINavigationController *navigationController = [segue destinationViewController];
       ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
       composeController.delegate = self;
    }else{
        NSLog(@"Destination View controller class: %@", [segue.destinationViewController class]);
        DetailsViewController *detailsViewController = [segue destinationViewController];
        
        UITableViewCell *cell = sender;
        NSIndexPath *myIndexPath = [self.tableView indexPathForCell:cell];
        //Pass the selected object to the new view controller.
        Tweet *tweetToPass = self.arrayOfTweets[myIndexPath.row];
        detailsViewController.tweet = tweetToPass;
//        NSLog(@"%@", detailsViewController.tweet);
    }
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}


@end
