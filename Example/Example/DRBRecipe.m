//
//  DRBRecipe.m
//  Example
//
//  Created by Dustin Barker on 12/15/13.
//  Copyright (c) 2013 dstnbrkr. All rights reserved.
//

#import "DRBRecipe.h"
#import "DRBCookbook.h"


@implementation DRBRecipe

@synthesize ingredientIDs;
@synthesize imagePath;
@synthesize image;

@dynamic name;
@dynamic ingredients;
@dynamic cookbook;

+ (DRBRecipe *)recipeWithJSON:(id)JSON context:(NSManagedObjectContext *)context
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DRBRecipe" inManagedObjectContext:context];
    DRBRecipe *recipe = [[DRBRecipe alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    recipe.name = [JSON objectForKey:@"name"];
    recipe.ingredientIDs = [JSON objectForKey:@"ingredient_ids"];
    recipe.imagePath = [JSON objectForKey:@"image_path"];
    return recipe;
}

@end
