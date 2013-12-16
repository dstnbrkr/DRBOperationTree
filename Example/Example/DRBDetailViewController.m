//
//  DRBDetailViewController.m
//  Example
//
//  Created by Dustin Barker on 12/15/13.
//  Copyright (c) 2013 dstnbrkr. All rights reserved.
//

#import "DRBDetailViewController.h"
#import "DRBIngredient.h"

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    DRBIngredient *ingredient = [self.ingredients objectAtIndex:indexPath.row];
    cell.textLabel.text = ingredient.name;
    cell.imageView.image = ingredient.image;
    return cell;
}

@end
