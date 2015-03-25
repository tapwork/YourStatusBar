desc "Runs the specs"
task :spec do
  sh("xcodebuild YourStatusBarExample/YourStatusBar.xcodeproj -scheme YourStatusBar -destination platform='iOS Simulator',OS=8.1,name='iPhone 5s' clean build test -sdk iphonesimulator | xcpretty -t -c; exit ${PIPESTATUS[0]}")
end
