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

+ (DRBIngredient *)ingredientWithJSON:(id)JSON context:(NSManagedObjectContext *)context
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DRBIngredient" inManagedObjectContext:context];
    DRBIngredient *ingredient = [[DRBIngredient alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    ingredient.name = [JSON objectForKey:@"name"];
    return ingredient;
}

@end
