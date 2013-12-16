//
//  DRBIngredientProvider.m
//  Example
//
//  Created by Dustin Barker on 12/15/13.
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

#import "DRBIngredientProvider.h"
#import "DRBIngredient.h"
#import "DRBRecipe.h"
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
