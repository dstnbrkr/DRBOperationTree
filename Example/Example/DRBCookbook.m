//
//  DRBCookbook.m
//  Example
//
//  Created by Dustin Barker on 12/15/13.
//  Copyright (c) 2013 dstnbrkr. All rights reserved.
//

#import "DRBCookbook.h"


@implementation DRBCookbook

@synthesize recipeIDs;

@dynamic recipes;

+ (DRBCookbook *)cookbookWithJSON:(id)JSON context:(NSManagedObjectContext *)context {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DRBCookbook" inManagedObjectContext:context];
    DRBCookbook *cookbook = [[DRBCookbook alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    cookbook.recipeIDs = [JSON objectForKey:@"recipe_ids"];
    return cookbook;
}

@end
