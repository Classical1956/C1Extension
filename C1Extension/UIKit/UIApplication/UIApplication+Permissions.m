//
//  UIApplication-Permissions.m
//  UIApplication-Permissions Sample
//
//  Created by Jack Rostron on 12/01/2014.
//  Copyright (c) 2014 Rostron. All rights reserved.
//

#import "UIApplication+Permissions.h"
#import <objc/runtime.h>

//Import required frameworks
@import AddressBook;
@import AssetsLibrary;
@import Photos;
@import AVFoundation;
@import CoreBluetooth;
@import CoreLocation;
@import CoreMotion;
@import EventKit;


typedef void (^LocationSuccessCallback)();
typedef void (^LocationFailureCallback)();

static char PermissionsLocationManagerPropertyKey;
static char PermissionsLocationBlockSuccessPropertyKey;
static char PermissionsLocationBlockFailurePropertyKey;

@interface UIApplication () <CLLocationManagerDelegate>
@property (nonatomic, retain) CLLocationManager *permissionsLocationManager;
@property (nonatomic, copy) LocationSuccessCallback locationSuccessCallbackProperty;
@property (nonatomic, copy) LocationFailureCallback locationFailureCallbackProperty;
@end


@implementation UIApplication (Permissions)


#pragma mark - Check permissions
-(kPermissionAccess)hasAccessToBluetoothLE {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    switch ([[[CBCentralManager alloc] init] state]) {
        case CBCentralManagerStateUnsupported:
            return kPermissionAccessUnsupported;
            break;
            
        case CBCentralManagerStateUnauthorized:
            return kPermissionAccessDenied;
            break;
            
        default:
            return kPermissionAccessGranted;
            break;
    }
#pragma clang diagnostic pop
}

-(kPermissionAccess)hasAccessToCalendar {
    switch ([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent]) {
        case EKAuthorizationStatusAuthorized:
            return kPermissionAccessGranted;
            break;
            
        case EKAuthorizationStatusDenied:
            return kPermissionAccessDenied;
            break;
            
        case EKAuthorizationStatusRestricted:
            return kPermissionAccessRestricted;
            break;
            
        default:
            return kPermissionAccessUnknown;
            break;
    }
}

-(kPermissionAccess)hasAccessToContacts {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    switch (ABAddressBookGetAuthorizationStatus()) {
        case kABAuthorizationStatusAuthorized:
            return kPermissionAccessGranted;
            break;
            
        case kABAuthorizationStatusDenied:
            return kPermissionAccessDenied;
            break;
            
        case kABAuthorizationStatusRestricted:
            return kPermissionAccessRestricted;
            break;
            
        default:
            return kPermissionAccessUnknown;
            break;
    }
#pragma clang diagnostic pop
}

-(kPermissionAccess)hasAccessToLocation {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusAuthorized:
            return kPermissionAccessGranted;
            break;
            
        case kCLAuthorizationStatusDenied:
            return kPermissionAccessDenied;
            break;
            
        case kCLAuthorizationStatusRestricted:
            return kPermissionAccessRestricted;
            break;
            
        default:
            return kPermissionAccessUnknown;
            break;
    }
    return kPermissionAccessUnknown;
#pragma clang diagnostic pop
}

-(kPermissionAccess)hasAccessToPhotos {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    switch ([ALAssetsLibrary authorizationStatus]) {
        case ALAuthorizationStatusAuthorized:
            return kPermissionAccessGranted;
            break;
            
        case ALAuthorizationStatusDenied:
            return kPermissionAccessDenied;
            break;
            
        case ALAuthorizationStatusRestricted:
            return kPermissionAccessRestricted;
            break;
            
        default:
            return kPermissionAccessUnknown;
            break;
    }
#pragma clang diagnostic pop
}

-(kPermissionAccess)hasAccessToReminders {
    switch ([EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder]) {
        case EKAuthorizationStatusAuthorized:
            return kPermissionAccessGranted;
            break;
            
        case EKAuthorizationStatusDenied:
            return kPermissionAccessDenied;
            break;
            
        case EKAuthorizationStatusRestricted:
            return kPermissionAccessRestricted;
            break;
            
        default:
            return kPermissionAccessUnknown;
            break;
    }
    return kPermissionAccessUnknown;
}


#pragma mark - Request permissions
-(void)requestAccessToCalendarWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                accessGranted();
            } else {
                accessDenied();
            }
        });
    }];
}

-(void)requestAccessToContactsWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    if(addressBook) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    accessGranted();
                } else {
                    accessDenied();
                }
            });
        });
    }
#pragma clang diagnostic pop
    
}

-(void)requestAccessToMicrophoneWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied {
    AVAudioSession *session = [[AVAudioSession alloc] init];
    [session requestRecordPermission:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                accessGranted();
            } else {
                accessDenied();
            }
        });
    }];
}

-(void)requestAccessToMotionWithSuccess:(void(^)())accessGranted {
    CMMotionActivityManager *motionManager = [[CMMotionActivityManager alloc] init];
    NSOperationQueue *motionQueue = [[NSOperationQueue alloc] init];
    [motionManager startActivityUpdatesToQueue:motionQueue withHandler:^(CMMotionActivity *activity) {
        accessGranted();
        [motionManager stopActivityUpdates];
    }];
}

-(void)requestAccessToPhotosWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f) {

        if ([PHPhotoLibrary authorizationStatus] == 3) {
            accessGranted();
        }else
            accessDenied();
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if ([ALAssetsLibrary authorizationStatus] == 3) {
            accessGranted();
        }else
            accessDenied();
#pragma clang diagnostic pop
    }
    accessDenied();
}

-(void)requestAccessToRemindersWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                accessGranted();
            } else {
                accessDenied();
            }
        });
    }];
}


#pragma mark - Needs investigating
/*
 -(void)requestAccessToBluetoothLEWithSuccess:(void(^)())accessGranted {
 //REQUIRES DELEGATE - NEEDS RETHINKING
 }
 */

-(void)requestAccessToLocationWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied {
    self.permissionsLocationManager = [[CLLocationManager alloc] init];
    self.permissionsLocationManager.delegate = self;
    
    self.locationSuccessCallbackProperty = accessGranted;
    self.locationFailureCallbackProperty = accessDenied;
    [self.permissionsLocationManager startUpdatingLocation];
}


#pragma mark - Location manager injection
-(CLLocationManager *)permissionsLocationManager {
    return objc_getAssociatedObject(self, &PermissionsLocationManagerPropertyKey);
}

-(void)setPermissionsLocationManager:(CLLocationManager *)manager {
    objc_setAssociatedObject(self, &PermissionsLocationManagerPropertyKey, manager, OBJC_ASSOCIATION_RETAIN);
}

-(LocationSuccessCallback)locationSuccessCallbackProperty {
    return objc_getAssociatedObject(self, &PermissionsLocationBlockSuccessPropertyKey);
}

-(void)setLocationSuccessCallbackProperty:(LocationSuccessCallback)locationCallbackProperty {
    objc_setAssociatedObject(self, &PermissionsLocationBlockSuccessPropertyKey, locationCallbackProperty, OBJC_ASSOCIATION_COPY);
}

-(LocationFailureCallback)locationFailureCallbackProperty {
    return objc_getAssociatedObject(self, &PermissionsLocationBlockFailurePropertyKey);
}

-(void)setLocationFailureCallbackProperty:(LocationFailureCallback)locationFailureCallbackProperty {
    objc_setAssociatedObject(self, &PermissionsLocationBlockFailurePropertyKey, locationFailureCallbackProperty, OBJC_ASSOCIATION_COPY);
}


#pragma mark - Location manager delegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if (status == kCLAuthorizationStatusAuthorized) {
            self.locationSuccessCallbackProperty();
        } else if (status != kCLAuthorizationStatusNotDetermined) {
            self.locationFailureCallbackProperty();
        }
#pragma clang diagnostic pop
    }
}

@end
