//
//  SetupShorthand.h
//  TotalObserver
//
//  Created by Pierre Houston on 2015-11-04.
//  Copyright (c) 2015 Pierre Houston. All rights reserved.
//
//  *** this isn't working, currently omitted from podspec
//
//  To use shorthand method names that omit the "to_" prefix without adding any lines of code
//  (other than import/include directives):
//  - in your podfile use: pod 'TotalObserver/Shorthand' instead of just pod 'TotalObserver'
//  - either: use module import directive as normal: @import TotalObserver;
//    or: import <TotalObserver/TotalObserverShorthand.h> instead of the normal umbrealla header
//  - then in at least one .m file, also include <TotalObserver/SetupShorthand.h>
//    (if used module import syntax then its important to use #include and not #import)
//
//  In case of module import (ie. @import TotalObserver), this inevitably gets imported once
//  by the module umbrella header (can't help that because of how cocoapods autogenerates it)
//  and TO_SETUPSHORTHAND_IMPORTED_BY_UMBRELLA will not be defined. Logic below ensures the
//  declaration is omitted but that same macro is defined. A subsequent explicit include by a
//  .m will have that macro defined and the auto-setup declaration will be used.
//  NOTE: After "@import TotalObserver;" must use "#include <TotalObserver/SetupShorthand.h>"
//  with #include and not #import because the umbrealla header from will have imported this
//  header once, another #import will be short circuited.
//
//  WRONG?:
//  In case of old-style import (ie. #import <TotalObserver/TotalObserver.h>), this header
//  isn't initially imported, but a macro gets defined, either TO_IMPORTED_UMBRELLA_HEADER or
//  TO_IMPORTED_SHORTHAND_UMBRELLA_HEADER. In a subsequent explicit import of this header
//  from a .m, the logic below ensures the auto-setup declaration will be used.
//

#ifndef TO_SETUPSHORTHAND_IMPORTED_BY_UMBRELLA
// omit if this is imported from the umbrella header, setup to not omit if included again
#define TO_SETUPSHORTHAND_IMPORTED_BY_UMBRELLA 1
#warning autosetup declaration omitted
#else

#ifndef TO_IMPORTED_SHORTHAND_UMBRELLA_HEADER
// this is so #import <TotalObserver/TotalObserver.h> + #import <TotalObserver/SetupShorthand.h> will work
// as well as #import <TotalObserver/TotalObserverShorthand.h> + #import <TotalObserver/SetupShorthand.h>
#import <TotalObserver/TotalObserverShorthand.h>
#endif


// by declaring at least one of these autosetup classes, setupShorthandMethods will get
// called during launch
// assume its safe to call multiple times otherwise we have to require that this header
// is explcitly included from exactly one .m file, which may be impractical

#define TO_CATENATE(x, y) x ## y
#define TO_AUTOSETUP_CLASS TO_CATENATE(TOObservationAutosetup_, __COUNTER__)
@interface TO_AUTOSETUP_CLASS : NSObject
@end
@implementation TO_AUTOSETUP_CLASS
+ (void)load { if (self == [TO_AUTOSETUP_CLASS class]) [TOObservation setupShorthandMethods]; }
@end

#warning autosetup declaration NOT omitted

#endif
