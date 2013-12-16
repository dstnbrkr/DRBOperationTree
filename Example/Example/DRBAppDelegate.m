//
//  DRBAppDelegate.m
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

#import "DRBAppDelegate.h"
#import "DRBMasterViewController.h"
#import "DRBOperationTree.h"
#import "DRBCookbookProvider.h"
#import "DRBRecipeProvider.h"
#import "DRBRecipeImageProvider.h"
#import "DRBIngredientProvider.h"
#import "DRBIngredientImageProvider.h"
#import "VCR.h"

@implementation DRBAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DRBMasterViewController *controller = [[DRBMasterViewController alloc] initWithStyle:UITableViewStylePlain];
    controller.managedObjectContext = self.managedObjectContext;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    NSString *cassettePath = [[NSBundle mainBundle] pathForResource:@"cassette" ofType:@"json"];
    NSURL *cassetteURL = [NSURL fileURLWithPath:cassettePath];
    [VCR loadCassetteWithContentsOfURL:cassetteURL];
    [VCR start];
    
    [[DRBOperationTree defaultOperationQueue] setMaxConcurrentOperationCount:5];
    
    DRBOperationTree *cookbook = [DRBOperationTree tree];
    DRBOperationTree *recipes = [DRBOperationTree tree];
    DRBOperationTree *recipeImages = [DRBOperationTree tree];
    DRBOperationTree *ingredients = [DRBOperationTree tree];
    DRBOperationTree *ingredientImages = [DRBOperationTree tree];
    
    cookbook.provider = [[DRBCookbookProvider alloc] initWithManagedObjectContext:self.managedObjectContext];
    recipes.provider = [[DRBRecipeProvider alloc] initWithManagedObjectContext:self.managedObjectContext];
    recipeImages.provider = [[DRBRecipeImageProvider alloc] init];
    ingredients.provider = [[DRBIngredientProvider alloc] initWithManagedObjectContext:self.managedObjectContext];
    ingredientImages.provider = [[DRBIngredientImageProvider alloc] init];
    
    [cookbook addChild:recipes];
    [recipes addChild:recipeImages];
    [recipes addChild:ingredients];
    [ingredients addChild:ingredientImages];
    
    [cookbook enqueueOperationsForObject:@"a-cookbook" completion:^{
        NSLog(@"All entities downloaded");
    }];
    
    return YES;
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Example" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Example.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
