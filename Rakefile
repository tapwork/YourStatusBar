desc "Bootstraps the repo"
task :bootstrap do
  sh 'bundle'
  sh 'cd YourStatusBarExample && bundle exec pod install'
end

desc "Runs the specs"
task :spec do
  sh 'xcodebuild -workspace YourStatusBarExample/YourStatusBar.xcworkspace -scheme \'YourStatusBar\' test -sdk iphonesimulator | xcpretty -tc; exit ${PIPESTATUS[0]}'
end
