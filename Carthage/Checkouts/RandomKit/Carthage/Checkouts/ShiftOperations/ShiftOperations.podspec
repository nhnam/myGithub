Pod::Spec.new do |s|
    s.name                      = "ShiftOperations"
    s.version                   = "1.0.0"
    s.summary                   = "A µframework for a ShiftOperations protocol that doesn't appear in the Swift standard library."
    s.homepage                  = "https://github.com/nvzqz/#{s.name}"
    s.license                   = { :type => "MIT", :file => "LICENSE.md" }
    s.author                    = "Nikolai Vazquez"
    s.ios.deployment_target     = "8.0"
    s.osx.deployment_target     = "10.9"
    s.watchos.deployment_target = '2.0'
    s.tvos.deployment_target    = '9.0'
    s.source                    = { :git => "https://github.com/nvzqz/#{s.name}.git", :tag => "v#{s.version}" }
    s.source_files              = "Sources/**/*.swift"
end
