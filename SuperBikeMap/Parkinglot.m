//
//  Parkinglot.m
//  SuperBikeMap
//
//  Created by user47 on 2016/12/13.
//  Copyright © 2016年 CHIEN. All rights reserved.
//

#import "Parkinglot.h"
#import <Contacts/Contacts.h>

@implementation Parkinglot

- (instancetype)init:(NSString *)title locationName:(NSString *)locationName coordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    if (self) {
        self.title = title;
        self.locationName = locationName;
        self.coordinate = coordinate;
    }
    return self;
}

- (NSString *)description {
    NSString *desc = [NSString stringWithFormat: @"title:%@, locationName:%@, coordinate:%f,%f", self.title, self.locationName, self.coordinate.latitude, self.coordinate.longitude];
    return desc;
}

- (NSString *)subtitle {
    return self.locationName;
}

- (MKMapItem *)mapItem {
    NSDictionary *addressDictionary = @{CNPostalAddressStreetKey: self.locationName};
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:addressDictionary];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    return mapItem;
}

//- (UIColor *) pinColor {
//    UIColor __block *color;
//    ((void (^)())@{
//                   @"" : ^{
//        color = [MKPinAnnotationView redPinColor];
//    },
//                   @"" : ^{
//        color = [MKPinAnnotationView redPinColor];
//    },
//                   @"" : ^{
//        color = [MKPinAnnotationView purplePinColor];
//    },
//                   @"" : ^{
//        color = [MKPinAnnotationView purplePinColor];
//    },
//                   }[self.discipline] ?: ^{
//                       color = [MKPinAnnotationView greenPinColor];
//                   })();
//    return color;
//}

+ (Parkinglot *)fromJSON:(NSArray *)json {
    id title = json[0];
    if (title == [NSNull null]) {
        title = @"no title";
    }
    NSString *locationName = json[1];
    
    CLLocationDegrees latitude = [json[2] doubleValue];
    CLLocationDegrees longitude = [json[3] doubleValue];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    Parkinglot *parkinglot = [[Parkinglot alloc] init:title locationName:locationName coordinate:coordinate];
    return parkinglot;
}


@end
