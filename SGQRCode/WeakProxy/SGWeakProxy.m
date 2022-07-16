//
//  SGWeakProxy.m
//  SGQRCodeExample
//
//  Created by kingsic on 2022/7/2.
//

#import "SGWeakProxy.h"

@interface SGWeakProxy ()
@property (nonatomic, weak) id target;
@end

@implementation SGWeakProxy

+ (instancetype)weakProxyWithTarget:(id)aTarget {
    SGWeakProxy *weakProxy = [SGWeakProxy alloc];
    weakProxy.target = aTarget;
    return weakProxy;
}


- (id)forwardingTargetForSelector:(SEL)selector {
    return _target;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    void *nullPointer = NULL;
    [invocation setReturnValue:&nullPointer];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

@end
