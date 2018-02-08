
Pod::Spec.new do |s|
s.name         = 'SGQRCode'
s.version      = '2.2.0'
s.summary      = 'iOS native two-dimensional code generation and scanning'
s.homepage     = 'https://github.com/kingsic/SGQRCode'
s.license      = 'Apache-2.0'
s.authors      = {'kingsic' => 'kingsic@126.com'}
s.platform     = :ios, '7.0'
s.source       = {:git => 'https://github.com/kingsic/SGQRCode.git', :tag => s.version}
s.source_files = 'SGQRCode/**/*.{h,m}'
s.resource     = 'SGQRCode/SGQRCode.bundle'
s.requires_arc = true
end
