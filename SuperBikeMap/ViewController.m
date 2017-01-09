//
//  ViewController.m
//  SuperBikeMap
//
//  Created by user47 on 2016/11/29.
//  Copyright © 2016年 CHIEN. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Parkinglot.h"

@interface ViewController ()<CLLocationManagerDelegate,MKMapViewDelegate,NSURLSessionDelegate>{
    NSString *title;
    NSString *subtitle;
    NSString *locationName;
    CLLocationCoordinate2D coordinate;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,retain) NSMutableArray *locationArray;
@property (strong, nonatomic) NSMutableArray<Parkinglot *> *parkinlots;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D selectAnnLotation ;
@property (nonatomic) CLLocationCoordinate2D currentLocation;
@property (nonatomic) NSString* annationTitle;
@property (nonatomic) NSString* annationAddress;

@property (weak, nonatomic) IBOutlet UIView *vc_Detail;
@property (weak, nonatomic) IBOutlet UILabel *label_Title;
@property (weak, nonatomic) IBOutlet UILabel *label_Address;

@property (weak, nonatomic) IBOutlet UIButton *btn_Navigation;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _locationManager=[CLLocationManager new];
    
    if([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self centerMapOnLocation];
    self.mapView.delegate = self;
    
    [_locationManager startUpdatingLocation];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self addAnnotation];
    [self loadInitialData];
    [self.mapView addAnnotations:self.parkinlots];
    self.vc_Detail.hidden = YES;
    
    
}

- (void)checkLocationStatus {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.mapView.showsUserLocation = YES;
    } else {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkLocationStatus];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [_locationManager stopUpdatingLocation];
    
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

- (NSMutableArray *)parkinlots {
    if (!_parkinlots) {
        _parkinlots = [[NSMutableArray alloc] init];
    }
    return _parkinlots;
}

- (void)addAnnotation {
    CLLocationCoordinate2D coordinate1 = {25.034849, 121.544091};
    Parkinglot *parkinglot = [[Parkinglot alloc] init: @"測試"
                                         locationName: @"大安區"
                                           coordinate: coordinate1];
    [self.mapView addAnnotation:parkinglot];
    
}

- (void)centerMapOnLocation {
    CLLocationCoordinate2D initialLocation = {25.034858, 121.544099};
    CLLocationDistance regionRadius = 1000;
    
    MKCoordinateRegion coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation, regionRadius * 2, regionRadius * 2);
    [self.mapView setRegion:coordinateRegion];
}

- (void)loadInitialData {
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"Parkinglot" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:fileName];
    NSError *error;
    
    id rawJsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (error == nil && [rawJsonObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *jsonObject = (NSDictionary *)rawJsonObject;
        NSArray *jsonData = jsonObject[@"data"];
        if (jsonData != nil) {
            for (NSArray *parkinglotJSON in jsonData) {
                Parkinglot *parkinglot = [Parkinglot fromJSON:parkinglotJSON];
                [self.parkinlots addObject:parkinglot];
            }
        }
    }
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //CLLocationCoordinate2D LocationCoordinate = userLocation.coordinate;
//    _currentLocation = CLLocationCoordinate2D(latitude: LoactionCoordinate.latitude, longitude: LoactionCoordinate.longitude);
}

#pragma MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[Parkinglot class]]) {
        NSString *identifier = @"pin";
        MKPinAnnotationView *view = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!view) {
            view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            view.canShowCallout = YES;
            view.calloutOffset = CGPointMake(-10, 5);
            view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        
        //view.pinTintColor = [UIColor blueColor];
        
        //Parkinglot *parkinglot = (Parkinglot *)annotation;
        //view.pinTintColor = [parkinglot pinColor];
        return view;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"開啟內建地圖進行導航" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        Parkinglot *parkinglot = (Parkinglot *)view.annotation;
//        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving};
//        [[parkinglot mapItem] openInMapsWithLaunchOptions:launchOptions];
//    }];
//    
//    [alert addAction:okAction];
//    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    
//    [alert addAction:cancelAction];
//    
//    [self presentViewController:alert animated:YES completion:nil];
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    _selectAnnLotation = view.annotation.coordinate;
    _annationTitle = view.annotation.title;
    _annationAddress = view.annotation.subtitle;
    
    self.vc_Detail.hidden = NO;
    
    _label_Title.text = self.annationTitle;
    _label_Address.text = self.annationAddress;
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    self.vc_Detail.hidden = YES;

}

- (IBAction)btn_NavigationPress:(UIButton *)sender {

    MKPlacemark *markuserlocation = [[MKPlacemark alloc] initWithCoordinate:_currentLocation addressDictionary:nil];
    MKMapItem *userlocation = [[MKMapItem alloc] initWithPlacemark:markuserlocation];
    
    MKPlacemark *markgoallocation = [[MKPlacemark alloc] initWithCoordinate:_selectAnnLotation addressDictionary:nil];
    MKMapItem *goallocation = [[MKMapItem alloc] initWithPlacemark:markgoallocation];

    NSArray *array = [[NSArray alloc] initWithObjects:userlocation,goallocation, nil];

    
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving};
    [MKMapItem openMapsWithItems:array launchOptions:launchOptions];


}


//- (void)dealloc
//{
//#if DEBUG
//    // Xcode8/iOS10 MKMapView bug workaround
//    static NSMutableArray* unusedObjects;
//    if (!unusedObjects)
//        unusedObjects = [NSMutableArray new];
//    [unusedObjects addObject:_mapView];
//#endif
//}


// https://drive.google.com/file/d/0B_vZyUMcAuBALXVEeFFSamRFMlE/view?usp=sharing
// https://drive.google.com/a/gapp.fju.edu.tw/uc?export=download&id=0B_vZyUMcAuBAZmJMT05meFZPb28

@end
