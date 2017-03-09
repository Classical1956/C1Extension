#
# Be sure to run `pod lib lint C1Extension.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'C1Extension'
  s.version          = '1.0.1'
  s.summary          = 'C1Extension.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                      对一些实用类的扩展收集和封装
                       DESC

  s.homepage         = 'https://github.com/Classical1956/C1Extension'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dracula_1956' => 'dracula_1956@outlook.com' }
  s.source           = { :git => 'https://github.com/Classical1956/C1Extension.git', :tag => s.version, :submodules => true }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.requires_arc = true
  s.platform =:ios,'8.0'
  # s.default_subspec = 'All'

  # s.subspec 'All' do |ss|
  #   ss.dependency 'C1Extension/UIKit'
  #   ss.dependency 'C1Extension/Foundation'
  # end

  # UIKit
  s.subspec 'UIKit' do |ss|
    ss.source_files = 'C1Extension/UIKit/**/*.{h,m}'
    ss.frameworks = 'UIKit','CoreLocation'
    ss.platform =:ios,'7.0'
  end

  s.subspec 'Foundation' do |ss|
    ss.source_files = 'C1Extension/Foundation/**/*.{h,m}'
    ss.resources = 'C1Extension/Foundation/NSDate/NSDateTimeAgo.bundle'
    ss.frameworks = 'Foundation'
    ss.platform =:ios,'8.0'
  end


end
