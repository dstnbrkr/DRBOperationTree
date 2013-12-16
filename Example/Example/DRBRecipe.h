//
//  DRBRecipe.h
//  Pods
//
//  Created by Dustin Barker on 12/16/13.
//  Copyright (c) 2013 Dustin Barker (http://github.com/dstnbrkr), Artsy (http://artsy.net). All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

@class DRBCookbook, DRBIngredient;

@interface DRBRecipe : NSManagedObject

+ (DRBRecipe *)recipeWithJSON:(id)JSON context:(NSManagedObjectContext *)context;
- (NSString *)imageFilePath;
- (UIImage *)image;

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * imagePath;
@property (nonatomic, strong) DRBCookbook *cookbook;
@property (nonatomic, strong) NSSet *ingredients;

// transient
@property (nonatomic, strong) NSArray *ingredientIDs;

@end

@interface DRBRecipe (CoreDataGeneratedAccessors)

- (void)addIngredientsObject:(DRBIngredient *)value;
- (void)removeIngredientsObject:(DRBIngredient *)value;
- (void)addIngredients:(NSSet *)values;
- (void)removeIngredients:(NSSet *)values;

@end
