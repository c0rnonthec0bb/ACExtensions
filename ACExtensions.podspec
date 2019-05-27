Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '11.0'
s.name = "ACExtensions"
s.summary = "Extensions to facilitate efficient cross-platform development."
s.requires_arc = true

# 2 THIS NEXT LINE MUST REMAIN LINE 11
s.version = "0.1.16"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Adam Cobb" => "cobb.2326@gmail.com" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://github.com/c0rnonthec0bb/ACExtensions"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/c0rnonthec0bb/ACExtensions.git",
:tag => "#{s.version}" }

# 7
s.framework = "UIKit"

# 8
s.source_files = "ACExtensions/**/*.{swift}"

# 9
# s.resources = "ACExtensions/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

# 10
s.swift_version = "5.0"

end
