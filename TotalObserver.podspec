#
# Be sure to run `pod lib lint TotalObserver.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TotalObserver'
  s.version          = '0.1.2'
  s.summary          = 'Simplified Objective-C blocks API for NSNotifications and KVO.'
  
  s.description      = <<-DESC
  A simplified Objective-C API for using NSNotifications and KVO with consistent terminology and useful convenience features.
  Uses blocks exclusively, but unlike NSNotification's blocks API, allows manual removal without requiring storage of an observation object.
  Supports automatic removal when either observer or observee is deallocated, and an easy shorthand header when imported lets you omit method prefixes.
  Extensible to other styles of observers, an included example is a wrapper for UIControl event actions.
  Swift support to come.
                       DESC
  
  s.homepage         = 'https://github.com/jpmhouston/TotalObserver'
  s.license          = 'MIT'
  s.author           = { 'Pierre Houston' => 'jpmhouston@gmail.com' }
  s.source           = { :git => 'https://github.com/jpmhouston/TotalObserver.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
  
  s.ios.frameworks = 'Foundation', 'UIKit'
  s.osx.frameworks = 'Foundation'
  
  s.default_subspec = 'Core'
  s.subspec 'Core' do |cs|
    cs.ios.source_files = "Pod/TotalObserver.h", "Pod/TOObservation.{h,m}", "Pod/TOObservation-Private.h", "Pod/NSObject+TotalObserver.{h,m}", "Pod/UIControl+TotalObserver.{h,m}"
    cs.osx.source_files = "Pod/TotalObserver.h", "Pod/TOObservation.{h,m}", "Pod/TOObservation-Private.h", "Pod/NSObject+TotalObserver.{h,m}"

    cs.ios.public_header_files = "Pod/TotalObserver.h", "Pod/TOObservation.h", "Pod/NSObject+TotalObserver.h", "Pod/UIControl+TotalObserver.h"
    cs.osx.public_header_files = "Pod/TotalObserver.h", "Pod/TOObservation.h", "Pod/NSObject+TotalObserver.h"
    cs.private_header_files = "Pod/TOObservation-Private.h"
  end
  
  s.subspec 'Shorthand' do |shs|
    shs.dependency 'TotalObserver/Core'
    
    shs.ios.source_files = "Pod/TotalObserverShorthand.h", "Pod/TOObservation+Shorthand.{h,m}", "Pod/NSObject+TotalObserverShorthand.h", "Pod/UIControl+TotalObserverShorthand.h"
    shs.osx.source_files = "Pod/TotalObserverShorthand.h", "Pod/TOObservation+Shorthand.{h,m}", "Pod/NSObject+TotalObserverShorthand.h"
    
    shs.ios.public_header_files = "Pod/TotalObserverShorthand.h", "Pod/TOObservation+Shorthand.h", "Pod/NSObject+TotalObserverShorthand.h", "Pod/UIControl+TotalObserverShorthand.h"
    shs.osx.public_header_files = "Pod/TotalObserverShorthand.h", "Pod/TOObservation+Shorthand.h", "Pod/NSObject+TotalObserverShorthand.h"
  end
  
end
