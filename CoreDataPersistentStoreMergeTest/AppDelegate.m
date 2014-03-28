//
//  AppDelegate.m
//  CoreDataPersistentStoreMergeTest
//
//  Created by Daniel Tull on 28/03/2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import <DCTCoreDataStack/DCTCoreDataStack.h>
#import "AppDelegate.h"
#import "CDPSMTViewController.h"
#import "Event.h"

@interface AppDelegate ()
@property (nonatomic) DCTCoreDataStack *mainCoreDataStack;
@property (nonatomic) DCTCoreDataStack *importCoreDataStack;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	self.mainCoreDataStack = [[DCTCoreDataStack alloc] initWithStoreFilename:@"main"];
	self.importCoreDataStack = [[DCTCoreDataStack alloc] initWithStoreFilename:@"import"];

	UINavigationController *navigation = (UINavigationController *)self.window.rootViewController;
	CDPSMTViewController *viewController = (CDPSMTViewController *)navigation.topViewController;
	viewController.managedObjectContext = self.mainCoreDataStack.managedObjectContext;

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(importContextDidSaveNotification:)
												 name:NSManagedObjectContextDidSaveNotification
											   object:self.importCoreDataStack.managedObjectContext];

	[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(createEvent:) userInfo:nil repeats:YES];

    return YES;
}


- (void)createEvent:(id)timer {
	NSManagedObjectContext *context = self.importCoreDataStack.managedObjectContext;
	Event *event = [Event insertInManagedObjectContext:context];
	event.date = [NSDate new];
	[context save:NULL];
}

- (void)importContextDidSaveNotification:(NSNotification *)notification {

	NSManagedObjectContext *mainContext = self.mainCoreDataStack.managedObjectContext;

	NSURL *mainURL = self.mainCoreDataStack.storeURL;
	NSURL *importURL = self.importCoreDataStack.storeURL;

	[mainContext performBlock:^{

		NSPersistentStoreCoordinator *psc = mainContext.persistentStoreCoordinator;
		NSPersistentStore *store = [psc.persistentStores firstObject];

		NSError *removeStoreError;
		if (![psc removePersistentStore:store error:&removeStoreError]) {
			NSLog(@"%@:%@ REMOVE STORE ERROR: %@", self, NSStringFromSelector(_cmd), removeStoreError);
			return;
		}

		NSFileManager *fileManager = [NSFileManager defaultManager];

		NSError *removeFileError;
		if (![fileManager removeItemAtURL:mainURL error:&removeFileError]) {
			NSLog(@"%@:%@ REMOVE FILE ERROR: %@", self, NSStringFromSelector(_cmd), removeFileError);
			return;
		}

		NSError *copyError;
		if (![fileManager copyItemAtURL:importURL toURL:mainURL error:&copyError]) {
			NSLog(@"%@:%@ COPY FILE ERROR: %@", self, NSStringFromSelector(_cmd), copyError);
			return;
		}

		NSError *addStoreError;
		if (![psc addPersistentStoreWithType:self.mainCoreDataStack.storeType
							   configuration:self.mainCoreDataStack.modelConfiguration
										 URL:self.mainCoreDataStack.storeURL
									 options:self.mainCoreDataStack.storeOptions
									   error:&addStoreError]) {
			NSLog(@"%@:%@ ADD STORE ERROR: %@", self, NSStringFromSelector(_cmd), addStoreError);
			return;
		}

		[mainContext mergeChangesFromContextDidSaveNotification:notification];
	}];
}

@end
