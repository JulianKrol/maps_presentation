//
//  MapViewController.m
//  Maps Presentation
//
//  Created by Julian on 01/02/14.
//  Copyright (c) 2014 Julian Król. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () {
    CLLocationManager *locationManager;
}


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initializeLocationManager];
}

- (void)initializeLocationManager {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;//ignored when significant location changes
   // locationManager.distanceFilter = 100; //meters!  look what happen if you set this :P
    locationManager.activityType = CLActivityTypeAutomotiveNavigation; //I'm an active person!
    [locationManager startUpdatingLocation];
    locationManager.pausesLocationUpdatesAutomatically = YES; //'more coal!!' as my friend says
    //[locationManager startMonitoringSignificantLocationChanges];
    //CLRegion * ... hang on! it is deprecated, use this:
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:
            CLLocationCoordinate2DMake(123, 12) radius:120 identifier:@"my region"];
    [locationManager startMonitoringForRegion:region]; //watch dog has been set
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

#pragma mark - Core Location delegate methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"%@", [[locations firstObject] description]);
    CLLocation *location = [locations firstObject];
    //[locationManager stopUpdatingLocation];//important, enough!
    //locationManager.heading;    <-- what it gives? location.course?
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
    NSLog(@"pause");
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    // on entering any of the monitored region
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    //on exiting any of the monitored region
}


@end
