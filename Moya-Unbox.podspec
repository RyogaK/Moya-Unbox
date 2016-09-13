Pod::Spec.new do |s|
  s.name         = "Moya-Unbox"
  s.version      = "1.0.0"
  s.summary      = "Unbox bindings for Moya"
  s.description  = <<-EOS
  [Unbox](https://github.com/JohnSundell/Unbox) bindings for
  [Moya](https://github.com/Moya/Moya) for fabulous JSON serialization.
  Includes [RxSwift](https://github.com/ReactiveX/RxSwift/) bindings as well.
  EOS
  s.homepage     = "https://github.com/RyogaK/Moya-Unbox"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Ryoga Kitagawa" => "ryoga.kitagawa@gmail.com" }
  s.ios.deployment_target = '8.0'
  s.source       = { :git => "https://github.com/RyogaK/Moya-Unbox.git", :tag => s.version }
  s.default_subspec = "Core"

  s.subspec "Core" do |ss|
    ss.source_files  = "Source/*.swift"
    ss.dependency "Moya", "~> 7.0"
    ss.dependency "Unbox", "~> 1.9"
    ss.framework  = "Foundation"
  end

  s.subspec "RxSwift" do |ss|
    ss.source_files = "Source/RxSwift/*.swift"
    ss.dependency "Moya/RxSwift", "~> 7.0"
    ss.dependency "Moya-Unbox/Core"
    ss.dependency "RxSwift", "~> 2.6"
  end

  s.subspec "ReactiveCocoa" do |ss|
    ss.source_files = "Source/ReactiveCocoa/*.swift"
    ss.dependency "Moya/ReactiveCocoa", "~> 7.0"
    ss.dependency "Moya-Unbox/Core"
    ss.dependency "ReactiveCocoa", "~> 4.2"
  end
end

