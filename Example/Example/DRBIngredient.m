//
//  DRBIngredient.m
//  Example
//
//  Created by Dustin Barker on 12/15/13.
//  Copyright (c) 2013 dstnbrkr. All rights reserved.
//

#import "DRBIngredient.h"

@implementation DRBIngredient

@dynamic name;
@dynamic imagePath;

+ (DRBIngredient *)ingredientWithJSON:(id)JSON context:(NSManagedObjectContext *)context
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DRBIngredient" inManagedObjectContext:context];
    DRBIngredient *ingredient = [[DRBIngredient alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    ingredient.name = [JSON objectForKey:@"name"];
    ingredient.imagePath = [JSON objectForKey:@"image_path"];
    return ingredient;
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
