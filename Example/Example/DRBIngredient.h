//
//  DRBIngredient.h
//  Example
//
//  Created by Dustin Barker on 12/15/13.
//  Copyright (c) 2013 dstnbrkr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DRBIngredient : NSManagedObject

+ (DRBIngredient *)ingredientWithJSON:(id)JSON context:(NSManagedObjectContext *)context;

@property (nonatomic, retain) NSString * name;

@end
