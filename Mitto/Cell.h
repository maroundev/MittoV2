//
//  Cell.h
//  Mitto
//
//  Created by Maroun Abi ramia on 8/23/14.
//  Copyright (c) 2014 MAR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic) BOOL isGrayedOut;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoader;

@end
