//
//  Parkinglot.h
//  SuperBikeMap
//
//  Created by user47 on 2016/12/13.
//  Copyright © 2016年 CHIEN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface Parkinglot : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) NSString *locationName;
//@property (nonatomic, strong) NSString *type;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (instancetype)init:(NSString *)title locationName:(NSString *)locationName coordinate:(CLLocationCoordinate2D)coordinate;

- (MKMapItem *)mapItem;

+ (Parkinglot *)fromJSON:(NSArray *)json;

//- (UIColor *) pinColor;

@end
