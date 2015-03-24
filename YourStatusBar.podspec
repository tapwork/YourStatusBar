Pod::Spec.new do |s|
  s.name     = 'YourStatusBar'
  s.version  = '1.0.0'
  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.summary = 'Customize the iOS statusBar with your text or UIView'
  s.description  = ''
  s.homepage = 'https://github.com/tapwork/YourStatusBar'
  s.social_media_url = 'https://twitter.com/cmenschel'
  s.authors  = { 'Christian Menschel' => 'christian@tapwork.de' }
  s.source = {
    :git => 'https://github.com/tapwork/YourStatusBar.git',
    :tag => s.version.to_s
  }
  s.ios.deployment_target = '7.0'
  s.source_files = 'Classes/**.{h,m}'
end
