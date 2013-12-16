//
//  DRBIngredientProvider.m
//  Example
//
//  Created by Dustin Barker on 12/15/13.
//  Copyright (c) 2013 dstnbrkr. All rights reserved.
//

#import "DRBIngredientProvider.h"
#import "DRBIngredient.h"
#import "DRBRecipe+Example.h"
#import "AFJSONRequestOperation.h"

@interface DRBIngredientProvider () {
    NSManagedObjectContext *_managedObjectContext;
}
@end

@implementation DRBIngredientProvider

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context
{
    if ((self = [super init])) {
        _managedObjectContext = context;
    }
    return self;
}

- (void)operationTree:(DRBOperationTree *)node objectsForObject:(DRBRecipe *)recipe completion:(void (^)(NSArray *))completion
{
    NSMutableArray *objects = [NSMutableArray array];
    for (NSString *ingredientID in recipe.ingredientIDs) {
        [objects addObject:@[ ingredientID, recipe ]];
    }
    completion(objects);
}

- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(NSArray *)params
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    NSString *ingredientID = params[0];
    DRBRecipe *recipe = params[1];
    NSString *path = [NSString stringWithFormat:@"http://api.example.com/ingredients/%@", ingredientID];
    NSURL *URL = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        DRBIngredient *ingredient = [DRBIngredient ingredientWithJSON:responseObject context:_managedObjectContext];
        [recipe addIngredientsObject:ingredient];
        continuation(ingredient, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
    return operation;
}

@end
