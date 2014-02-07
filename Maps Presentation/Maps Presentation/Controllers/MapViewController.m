//
//  MapViewController.m
//  Maps Presentation
//
//  Created by Julian on 01/02/14.
//  Copyright (c) 2014 Julian Król. All rights reserved.
//

#import "MapViewController.h"
#import "MyAnnotation.h"

@interface MapViewController () {
    CLLocationManager *locationManager;
    MKMapView *mapView;
}

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initializeLocationManager];
    [self initializeMapView];
    [self addRectangleToMap];
    [self addAnnotations];
}

- (void)initializeLocationManager {
    //CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    //if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;//ignored when significant location changes
    // locationManager.distanceFilter = 100; //meters!  look what happen if you set this :P
    locationManager.activityType = CLActivityTypeAutomotiveNavigation; //I'm an active person!
    [locationManager startUpdatingLocation];
    locationManager.pausesLocationUpdatesAutomatically = YES; //'more coal!!' as my friend says
    //[locationManager startMonitoringSignificantLocationChanges];
    //CLRegion * ... hang on! it is deprecated, use this:
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(123, 12)
                                                                 radius:120 identifier:@"my region"];
    [locationManager startMonitoringForRegion:region]; //watch dog has been set
    // }
}

- (void)initializeMapView {
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mapView.delegate = self;
    mapView.mapType = MKMapTypeSatellite;
    //mapView.scrollEnabled = NO; lets make a picture :P
    mapView.showsUserLocation = YES;

    [self.view addSubview:mapView];
}

- (void)addRectangleToMap {
    CLLocationCoordinate2D points[4];
    points[0] = CLLocationCoordinate2DMake(10, 10);
    points[1] = CLLocationCoordinate2DMake(10, 20);
    points[2] = CLLocationCoordinate2DMake(20, 20);
    points[3] = CLLocationCoordinate2DMake(20, 10);

    MKPolygon *poly = [MKPolygon polygonWithCoordinates:points count:4];
    poly.title = @"Some title";

    [mapView addOverlay:poly];
}

- (void)addAnnotations {
    [mapView addAnnotation:[[MyAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(15, 15) andTitle:@"wow"]];
}

#pragma mark - Core Location delegate methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"%@", [[locations firstObject] description]);
    //[mapView setCenterCoordinate:((CLLocation *) [locations firstObject]).coordinate animated:YES];
    //[mapView setRegion:MKCoordinateRegionMake(((CLLocation *) [locations firstObject]).coordinate, MKCoordinateSpanMake(.5, .5))];
    //[locationManager stopUpdatingLocation];//important, enough!
    //locationManager.heading;    <-- what it gives? location.course?
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
    NSLog(@"pause");
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    // on entering any of the monitored region
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    //on exiting any of the monitored region
}

#pragma mark - MapKit delegate methods
- (MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString *AnnotationIdentifier = @"MyAnnotation";
    MKAnnotationView *pinView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        pinView.canShowCallout = YES;
    } else {
        pinView.annotation = annotation;
    }

    return pinView;
}

//before iOS 7 it was - (MKOverlayView *)mapView:(MKMapView *)_mapView viewForOverlay:(id <MKOverlay>)overlay {
- (MKOverlayRenderer *)mapView:(MKMapView *)_mapView rendererForOverlay:(id <MKOverlay>)overlay {
    MKPolygonRenderer *line = nil;
    if ([overlay isKindOfClass:[MKPolygon class]]) {
        //previously MKPolygonView
        line = [[MKPolygonRenderer alloc] initWithPolygon:(MKPolygon *) overlay];
        line.strokeColor = [UIColor redColor];
        line.lineWidth = 1;
    }
    return line;
}

@end
