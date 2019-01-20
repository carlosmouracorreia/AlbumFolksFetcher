#
# Be sure to run `pod lib lint AlbumFolks.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AlbumFolks'
  s.version          = '0.4'
  s.summary          = 'Track information fetcher from LastFM API.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/carlosmouracorreia/AlbumFolksFetcher'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'carlosmouracorreia' => 'pm.correia.carlos@gmail.com' }
  s.source           = { :git => 'https://github.com/carlosmouracorreia/AlbumFolksFetcher.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/correiask8'

  s.ios.deployment_target = '10.0'
  s.swift_version = '4.0'
  s.source_files = 'AlbumFolks/Classes/**/*'
  
   s.resource_bundles = {
     'AlbumFolks' => ['AlbumFolks/Assets/*', 'AlbumFolks/Assets/Main.storyboard', 'AlbumFolks/Assets/AlbumCell.xib', 'AlbumFolks/Assets/ArtistCell.xib', 'AlbumFolks/Assets/ArtistInfoHeaderCell.xib']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Alamofire', '~> 5.0.0.beta.1'
  s.dependency 'ObjectMapper'
  s.dependency 'Kingfisher'
  s.dependency 'DynamicBlurView', '~> 2.0'

end
