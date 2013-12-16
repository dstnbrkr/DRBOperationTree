//
//  DRBIngredient.h
//  Example
//
//  Created by Dustin Barker on 12/15/13.
//  Copyright (c) 2013 dstnbrkr. All rights reserved.
//

@interface DRBIngredient : NSManagedObject

+ (DRBIngredient *)ingredientWithJSON:(id)JSON context:(NSManagedObjectContext *)context;

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * imagePath;

// derived
@property (nonatomic, readonly) NSString *imageFilePath;
@property (nonatomic, readonly) UIImage *image;

@end
