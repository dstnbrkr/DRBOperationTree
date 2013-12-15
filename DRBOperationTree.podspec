Pod::Spec.new do |s|
  s.name         = "DRBOperationTree"
  s.version      = "0.0.1"
  s.summary      = "DRBOperationTree is an iOS and OSX API to express dependencies between NSOperations and the flow of data between them."

  s.description  = <<-DESC
                   DRBOperationTree will execute operations in level order. At each node in the tree, the output of it's operation is sent to it's child nodes for further processing.
                   DESC

  s.homepage     = "http://github.com/dstnbrkr/DRBOperationTree"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = { "Dustin Barker" => "dustin.barker@gmail.com" }

  s.platform     = :ios, :macos

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.7'

  s.source       = { :git => "https://github.com/dstnbrkr/DRBOperationTree.git", :tag => "0.0.1" }
  s.source_files  = 'DRBOperationTree', 'Classes/**/*.{h,m}'
  s.requires_arc = true
end
