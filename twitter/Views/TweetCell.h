//
//  TweetCell.h
//  twitter
//
//  Created by Apoorva Chilukuri on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *tweet;

- (IBAction)didTapReply:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *replyCount;

- (IBAction)didTapRetweet:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;

- (IBAction)didTapFavorite:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;

- (IBAction)didTapShare:(id)sender;


@end

NS_ASSUME_NONNULL_END
