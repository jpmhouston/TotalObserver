#
# Be sure to run `pod lib lint TotalObserver.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "TotalObserver"
  s.version          = "0.1.0"
  s.summary          = "Consistent blocks API for disparate Cocoa observation techniques."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
  Simplified API for unifying NSNotifications and KVO style observer patterns into a consistent API.
  Uses blocks exclusively, but unlike NSNotification's blocks API, allows removal using matching parameters instead of requiring storage of an observation object. Supports autoremoval when either observer or observee is deallocated.
  Extensible to other styles of observers, an included example is a wrapper for UIControl event actions.
                       DESC

  s.homepage         = "https://github.com/jpmhouston/TotalObserver"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Pierre Houston" => "jpmhouston@gmail.com" }
  s.source           = { :git => "https://github.com/jpmhouston/TotalObserver.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  # s.resource_bundles = {
  #   'TotalObserver' => ['Pod/Assets/*.png']
  # }

  s.public_header_files = 'Pod/Classes/**/*.h'

  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  # s.dependency 'extobjc/EXTKeyPathCoding'

end
