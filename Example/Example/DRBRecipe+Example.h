//
//  DRBRecipe+Example.h
//  Example
//
//  Created by Dustin Barker on 12/16/13.
//  Copyright (c) 2013 dstnbrkr. All rights reserved.
//

#import "DRBRecipe.h"

@interface DRBRecipe (Example)

+ (DRBRecipe *)recipeWithJSON:(id)JSON context:(NSManagedObjectContext *)context;

- (NSString *)imageFilePath;

- (UIImage *)image;

@end
