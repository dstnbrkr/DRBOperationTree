//
//  DRBDetailViewController.m
//  Example
//
//  Created by Dustin Barker on 12/15/13.
//  Copyright (c) 2013 dstnbrkr. All rights reserved.
//

#import "DRBDetailViewController.h"

@interface DRBDetailViewController ()
@property (nonatomic, strong) NSArray *ingredients;
@end

@implementation DRBDetailViewController

- (void)setRecipe:(DRBRecipe *)recipe
{
    self.ingredients = [[recipe.ingredients allObjects] sortedArrayUsingSelector:@selector(name)];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.ingredients count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.ingredients objectAtIndex:indexPath.row];
    return cell;
}

@end
