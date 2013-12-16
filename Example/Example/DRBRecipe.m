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

@dynamic name;
@dynamic ingredients;
@dynamic cookbook;
@dynamic imagePath;

+ (DRBRecipe *)recipeWithJSON:(id)JSON context:(NSManagedObjectContext *)context
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DRBRecipe" inManagedObjectContext:context];
    DRBRecipe *recipe = [[DRBRecipe alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    recipe.name = [JSON objectForKey:@"name"];
    recipe.ingredientIDs = [JSON objectForKey:@"ingredient_ids"];
    recipe.imagePath = [JSON objectForKey:@"image_path"];
    return recipe;
}

- (NSString *)imageFilePath
{
    NSString *fileName = [[self.imagePath componentsSeparatedByString:@"/"] lastObject];
    return fileName ? [NSString stringWithFormat:@"%@/%@", NSTemporaryDirectory(), fileName] : nil;
}

- (UIImage *)image
{
    return [UIImage imageWithContentsOfFile:[self imageFilePath]];
}

@end
