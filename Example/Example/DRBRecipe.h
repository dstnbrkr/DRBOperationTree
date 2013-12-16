//
//  DRBRecipe.h
//  Pods
//
//  Created by Dustin Barker on 12/16/13.
//
//

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
