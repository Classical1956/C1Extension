#
# Be sure to run `pod lib lint C1Extension.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'C1Extension'
  s.version          = '1.0.0'
  s.summary          = 'C1Extension.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                      自用extension
                       DESC

  s.homepage         = 'https://github.com/Classical1956/C1Extension'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dracula_1956' => 'dracula_1956@outlook.com' }
  s.source           = { :git => 'https://github.com/Classical1956/C1Extension.git', :tag => s.version, :submodules => true }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.requires_arc = true
  s.platform =:ios,'7.0'

  # UIKit
  s.subspec 'UIKit' do |s|
    ss.source_files = 'C1Extension/UIKit/*.{h,m}'
    ss.frameworks = 'UIKit'
  end

  s.subspec 'UIKit' do |s|
    ss.source_files = 'C1Extension/Foundation/*.{h,m}'
    s.resources = 'C1Extension/Foundation/NSDate/NSDateTimeAgo.bundle'
    ss.frameworks = 'Foundation'
  end


end
