desc "Bootstraps the repo"
task :bootstrap do
  sh 'bundle'
  sh 'cd YourStatusBarExample && bundle exec pod install'
end

desc "Runs the specs"
task :spec do
  sh("xcodebuild -workspace YourStatusBarExample/YourStatusBar.xcworkspace -scheme YourStatusBar -destination platform='iOS Simulator',OS=8.2,name='iPhone 5s' clean build test -sdk iphonesimulator | xcpretty -t -c; exit ${PIPESTATUS[0]}")
end
