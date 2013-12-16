//
//  DRBAppDelegate.m
//  Example
//
//  Created by Dustin Barker on 12/15/13.
//  Copyright (c) 2013 dstnbrkr. All rights reserved.
//

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
    
    NSOperationQueue *requestQueue = [[NSOperationQueue alloc] init];
    [requestQueue setMaxConcurrentOperationCount:5];
    
    DRBOperationTree *cookbook = [DRBOperationTree tree];
    DRBOperationTree *recipes = [[DRBOperationTree alloc] initWithOperationQueue:requestQueue];
    DRBOperationTree *recipeImages = [[DRBOperationTree alloc] initWithOperationQueue:requestQueue];
    DRBOperationTree *ingredients = [[DRBOperationTree alloc] initWithOperationQueue:requestQueue];
    DRBOperationTree *ingredientImages = [[DRBOperationTree alloc] initWithOperationQueue:requestQueue];
    
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
