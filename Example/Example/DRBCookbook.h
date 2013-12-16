//
//  DRBCookbook.h
//  Example
//
//  Created by Dustin Barker on 12/15/13.
//  Copyright (c) 2013 dstnbrkr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DRBCookbook : NSManagedObject

+ (DRBCookbook *)cookbookWithJSON:(id)JSON context:(NSManagedObjectContext *)context;

@property (nonatomic, strong) NSArray *recipeIDs;
@property (nonatomic, strong) NSManagedObject *recipes;

@end
