#
# Be sure to run `pod lib lint WKRequest.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WKRequest'
  s.version          = '1.0'
  s.summary          = 'This pod is useful for HTTP & TCP requests'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This pod is useful for HTTP & TCP requests, light and powerful.
                       DESC

  s.homepage         = 'https://bitbucket.org/wdkay/wkrequest'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Walid Kayhal' => 'walid@kayhal.fr' }
  s.source           = { :git => 'https://wdkay@bitbucket.org/wdkay/wkrequest.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'WKRequest/Classes/**/*'
  
  # s.resource_bundles = {
  #   'WKRequest' => ['WKRequest/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
