//
//  DRBDetailViewController.h
//  Example
//
//  Created by Dustin Barker on 12/15/13.
//  Copyright (c) 2013 dstnbrkr. All rights reserved.
//

#import "DRBRecipe.h"
#import <UIKit/UIKit.h>

@interface DRBDetailViewController : UITableViewController

@property (strong, nonatomic) DRBRecipe *recipe;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
