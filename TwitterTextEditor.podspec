Pod::Spec.new do |spec|
  spec.name = "TwitterTextEditor"
  spec.version = "1.0.0" # Find the the version from the Git tags
  spec.authors = ""
  spec.summary = "TwitterTextEditor"
  spec.homepage = "https://github.com/twitter/TwitterTextEditor"
  spec.platform = :ios, "11.0"
  spec.source = {
    :git => "https://github.com/twitter/TwitterTextEditor.git", :tag => "#{spec.version}"
  }
  spec.source_files  = "Sources/TwitterTextEditor/*.swift"
end
