#
# Be sure to run `pod lib lint TotalObserver.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TotalObserver'
  s.version          = '0.5.1'
  s.summary          = 'Simplified Objective-C blocks API for NSNotifications, KVO, and more.'
  
  s.description      = <<-DESC
  A simplified Objective-C API for using (primarily) NSNotifications and KVO with consistent terminology and useful convenience features.
  Uses blocks exclusively, but unlike NSNotification's blocks API, allows manual removal without requiring storage of an observation object.
  Supports automatic removal when either observer or observee is deallocated, and an easy shorthand header when imported lets you omit method prefixes.
  Extensible to other styles of observers, included are a wrapper for UIControl event actions, and darwin notifications across app groups.
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
    cs.source_files = "Source/**/*.{h,m}"
    cs.public_header_files = "Source/**/*.h"
    cs.private_header_files = "Source/**/*+Private.h", "Source/AppGroups/TOAppGroupNotificationManager.h"
    cs.ios.exclude_files = "Source/ShorthandAutosetup.h", "Source/**/*Shorthand.{h,m}"
    cs.osx.exclude_files = "Source/ShorthandAutosetup.h", "Source/**/*Shorthand.{h,m}", "Source/UIControl/*"
  end
  
  s.subspec 'Shorthand' do |shs|
    shs.dependency 'TotalObserver/Core'
    
    shs.source_files = "Source/ShorthandAutosetup.h", "Source/**/*Shorthand.h"
    shs.public_header_files = "Source/**/*Shorthand.h"
    shs.private_header_files = "Source/ShorthandAutosetup.h"
    shs.osx.exclude_files = "Source/UIControl/*Shorthand.h"
  end
  
end
