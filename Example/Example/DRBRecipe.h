//
//  DRBRecipe.h
//  Example
//
//  Created by Dustin Barker on 12/15/13.
//  Copyright (c) 2013 dstnbrkr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DRBCookbook;

@interface DRBRecipe : NSManagedObject

+ (DRBRecipe *)recipeWithJSON:(id)JSON context:(NSManagedObjectContext *)context;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSManagedObject *ingredients;
@property (nonatomic, strong) DRBCookbook *cookbook;
@property (nonatomic, strong) NSArray *ingredientIDs;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) UIImage *image;

@end
