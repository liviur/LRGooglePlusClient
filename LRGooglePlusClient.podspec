#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "LRGooglePlusClient"
  s.version          = "1.1.0"
  s.summary          = "Simple Google Plus client - 2 files that will make integrating Google plus a breeze."
  s.description      = <<-DESC
                       LRGoogle Plus Client was created to simplify the integration of Google Plus framework into an iOS App.

Since the Google documentation is pretty extensive, but not always that clear - I went onwards with creating a simpler solution - a singleton class that does anything from logging in , one line sharing and properly notifying you on various events.

I find this solution much easier to implement and maintain as it also removes a lot of the overhead when copying this solution from project to project.

The less code you duplicate and write - the less bugs you will have.
                       DESC
  s.homepage         = "https://github.com/liviur/LRGooglePlusClient"
  s.license          = 'MIT'
  s.author           = { "Liviu Romascanu" => "livius16@gmail.com" }
  s.source           = { :git => "https://github.com/liviur/LRGooglePlusClient.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/livius16'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'

  s.public_header_files = 'Pod/Classes/*.h'
  s.frameworks = 'AddressBook', 'AssetsLibrary', 'Foundation' , 'CoreLocation' , 'CoreMotion' , 'CoreGraphics' , 'CoreText' , 'MediaPlayer' , 'Security' , 'SystemConfiguration' , 'UIKit'
  s.dependency 'google-plus-ios-sdk', '~> 1.5'
end
