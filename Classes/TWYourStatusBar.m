//
//  YourStatusBar
//
//  Created by Christian Menschel on 24/03/15.
//  Copyright (c) 2015 Christian Menschel. All rights reserved.
//

#import "TWYourStatusBar.h"
#import <malloc/malloc.h>
#import <mach/mach.h>
#import <objc/runtime.h>

typedef void (^HeapEnumeratorBlock)(__unsafe_unretained id object, __unsafe_unretained Class actualClass);
typedef struct {
    Class isa;
} rm_maybe_object_t;

static CFMutableSetRef classesLoadedInRuntime;
static UIWindow *kStatusBarWindow = nil;
static UIView *kCustomView = nil;
static UILabel *kTextLabel = nil;

@implementation TWYourStatusBar

+ (void)initialize
{
    if (self == [TWYourStatusBar class]) {
        [self retrieveStatusBarWindow];
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor lightGrayColor];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont systemFontOfSize:11];
        CGSize size = [UIApplication sharedApplication].statusBarFrame.size;
        label.frame = CGRectMake(0, 0, size.width, size.height);
        [kStatusBarWindow addSubview:label];
        kTextLabel = label;
    }
}

+ (void)setCustomView:(UIView *)customView
{
    if (!kStatusBarWindow) {
        [self retrieveStatusBarWindow];
    }
    if (![kCustomView isEqual:customView]) {
        if (customView) {
            [kStatusBarWindow addSubview:customView];
        } else {
            [kCustomView removeFromSuperview];
        }
        kCustomView = customView;
        kTextLabel.hidden = !customView;
    }
}

+ (void)setCustomText:(NSString*)text;
{
    if (!kStatusBarWindow) {
        [self retrieveStatusBarWindow];
    }
    kTextLabel.text = text;
}

+ (UIWindow*)statusBarWindow
{
    return kStatusBarWindow;
}

#pragma mark - internal class methods & C functions

+ (void)retrieveStatusBarWindow {
    [self enumerateLiveObjectsUsingBlock:^(__unsafe_unretained id object,
                                           __unsafe_unretained Class actualClass) {
        if (!kStatusBarWindow && [object isKindOfClass:[UIWindow class]]) {
            UIWindow *window = (UIWindow *)object;
            if ([window respondsToSelector:@selector(subviews)]) {
                [[window subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                kStatusBarWindow = window;
            }
        }
    }];
}

+ (void)enumerateLiveObjectsUsingBlock:(HeapEnumeratorBlock)block
{
    if (!block) {
        return;
    }
    
    if (!classesLoadedInRuntime) {
        classesLoadedInRuntime = CFSetCreateMutable(NULL, 0, NULL);
    } else {
        CFSetRemoveAllValues(classesLoadedInRuntime);
    }
    unsigned int count = 0;
    Class *classes = objc_copyClassList(&count);
    for (unsigned int i = 0; i < count; i++) {
        CFSetAddValue(classesLoadedInRuntime, (__bridge const void *)(classes[i]));
    }
    free(classes);
    
    vm_address_t *zones = NULL;
    unsigned int zoneCount = 0;
    kern_return_t result = malloc_get_all_zones(mach_task_self(), &memory_reader, &zones, &zoneCount);
    if (result == KERN_SUCCESS) {
        for (unsigned int i = 0; i < zoneCount; i++) {
            malloc_zone_t *zone = (malloc_zone_t *)zones[i];
            if (zone->introspect && zone->introspect->enumerator) {
                zone->introspect->enumerator(mach_task_self(), (__bridge void *)(block), MALLOC_PTR_IN_USE_RANGE_TYPE, zones[i], &memory_reader, &range_callback);
            }
        }
    }
}

static kern_return_t memory_reader(task_t task, vm_address_t remote_address, vm_size_t size, void **local_memory)
{
    *local_memory = (void *)remote_address;
    return KERN_SUCCESS;
}

static void range_callback(task_t task, void *context, unsigned type, vm_range_t *ranges, unsigned rangeCount)
{
    HeapEnumeratorBlock block = (__bridge HeapEnumeratorBlock)context;
    if (!block) {
        return;
    }
    
    for (unsigned int i = 0; i < rangeCount; i++) {
        vm_range_t range = ranges[i];
        rm_maybe_object_t *tryObject = (rm_maybe_object_t *)range.address;
        Class tryClass = NULL;
#ifdef __arm64__
        // See http://www.sealiesoftware.com/blog/archive/2013/09/24/objc_explain_Non-pointer_isa.html
        extern uint64_t objc_debug_isa_class_mask WEAK_IMPORT_ATTRIBUTE;
        tryClass = (__bridge Class)((void *)((uint64_t)tryObject->isa & objc_debug_isa_class_mask));
#else
        tryClass = tryObject->isa;
#endif
        if (CFSetContainsValue(classesLoadedInRuntime, (__bridge const void *)(tryClass))) {
            if (tryClass == objc_getClass("UIStatusBarWindow")) {
                block((__bridge id)tryObject, tryClass);
                break;
            }
        }
    }
}

@end