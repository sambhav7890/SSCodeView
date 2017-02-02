#
# Be sure to run `pod lib lint SSCodeView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
	s.name             = 'SSCodeView'
	s.version          = '0.1.0'
	s.summary          = 'SSCodeView: designed to handle the dashy view for entering codes.'

	# This description is used to generate tags and improve search results.
	#   * Think: What does it do? Why did you write it? What is the focus?
	#   * Try to keep it short, snappy and to the point.
	#   * Write the description between the DESC delimiters below.
	#   * Finally, don't worry about the indent, CocoaPods strips it!

	s.description      = <<-DESC

This pod is simply intended to show the dashy lines when entering a code/otp. The number of dashy lines/entry fields is variable and thus the view can handle configurations.

DESC

	s.homepage         = 'https://github.com/sambhav7890/SSCodeView'
	# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
	s.license          = { :type => 'MIT', :file => 'LICENSE' }
	s.author           = { 'sambhav7890' => 'sambhav.shah@practo.com' }
	s.source           = { :git => 'https://github.com/sambhav7890/SSCodeView.git', :tag => s.version.to_s }
	# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

	s.ios.deployment_target = '9.0'

	s.source_files = 'SSCodeView/Classes/**/*'

	s.frameworks = 'UIKit', 'MapKit'
end
