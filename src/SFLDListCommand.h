//
//  SFLDListCommand.h
//  mysides
//
//  Created by Eamon Brosnan on 26/09/2016.
//  Copyright © 2016 com.github.mosen. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SFLListItem : NSObject <NSSecureCoding, NSMutableCopying, NSCopying>
{
    NSUUID *_uniqueIdentifier;
    NSString *_name;
    NSURL *_URL;
    NSData *_bookmark;
    NSDictionary *_properties;
    double _order;
}

+ (BOOL)supportsSecureCoding;
+ (id)supportedPropertyClasses;
+ (BOOL)automaticallyNotifiesObserversForKey:(id)arg1;
@property double order; // @synthesize order=_order;
@property(readonly, copy) NSDictionary *properties; // @synthesize properties=_properties;
@property(readonly, copy) NSString *name; // @synthesize name=_name;
@property(readonly, retain) NSURL *URL; // @synthesize URL=_URL;
@property(readonly, copy) NSData *bookmark; // @synthesize bookmark=_bookmark;
@property(readonly, retain) NSUUID *uniqueIdentifier; // @synthesize uniqueIdentifier=_uniqueIdentifier;
- (id)debugDescription;
- (id)description;
- (id)mutableCopyWithZone:(struct _NSZone *)arg1;
- (id)copyWithZone:(struct _NSZone *)arg1;
- (void)encodeWithCoder:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (BOOL)isEqual:(id)arg1;
- (unsigned long long)hash;
- (unsigned long long)_cfTypeID;
- (void)synthesizeMissingPropertyValues;
- (void)dealloc;
- (id)initWithItem:(id)arg1;
- (id)initWithName:(id)arg1 bookmarkData:(id)arg2 properties:(id)arg3;
- (id)initWithName:(id)arg1 URL:(id)arg2 properties:(id)arg3;
- (id)_init;
- (id)init;

@end

// changetypes
// 1 - insert

@interface SFLListChange : NSObject <NSSecureCoding>
{
    NSUUID *_uniqueIdentifier;
    unsigned long long _type;
    id _updatedObject;
}

+ (BOOL)supportsSecureCoding;
+ (id)supportedPropertyClasses;
+ (id)changeWithUpdatedListProperties:(id)arg1;
+ (id)changeWithType:(unsigned long long)arg1 item:(id)arg2;
@property(readonly) unsigned long long type; // @synthesize type=_type;
@property(readonly, retain) NSUUID *uniqueIdentifier; // @synthesize uniqueIdentifier=_uniqueIdentifier;
- (void)encodeWithCoder:(id)arg1;
- (id)initWithCoder:(id)arg1;
@property(readonly, retain) NSDictionary *listProperties; // @dynamic listProperties;
@property(readonly, retain) SFLListItem *item; // @dynamic item;
- (id)description;
- (void)dealloc;
- (id)initWithType:(unsigned long long)arg1 updatedObject:(id)arg2;
- (id)init;

@end


@protocol SFLServiceProtocol <NSObject>
- (void)applyChange:(SFLListChange *)arg1 toListWithIdentifier:(NSString *)arg2 reply:(void (^)(NSArray *, NSError *))arg3;
- (void)resolveItemWithUUID:(NSUUID *)arg1 inListWithIdentifier:(NSString *)arg2 resolutionFlags:(unsigned int)arg3 reply:(void (^)(NSURL *, NSString *, NSError *))arg4;
- (void)unsubscribeToListWithIdentifier:(NSString *)arg1;
- (void)subscribeToListWithIdentifier:(NSString *)arg1 reply:(void (^)(NSArray *, NSDictionary *, NSError *))arg2;
@end

@protocol SFLServiceReplyProtocol <NSObject>
- (void)notifyChanges:(NSArray *)arg1 toListWithIdentifier:(NSString *)arg2;
@end

@interface SFLDListCommand : NSObject
- (int)run;
@end
