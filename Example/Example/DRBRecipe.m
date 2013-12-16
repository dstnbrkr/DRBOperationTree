//
//  DRBRecipe.m
//  Pods
//
//  Created by Dustin Barker on 12/16/13.
//
//

#import "DRBRecipe.h"
#import "DRBCookbook.h"
#import "DRBIngredient.h"

@implementation DRBRecipe

@dynamic name;
@dynamic imagePath;
@dynamic cookbook;
@dynamic ingredients;

@synthesize ingredientIDs;

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
