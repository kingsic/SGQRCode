
Pod::Spec.new do |s|
    s.name         = 'SGQRCode'
    s.version      = '2.5.4'
    s.summary      = 'An easy way to use two-dimensional code scan for iOS'
    s.homepage     = 'https://github.com/kingsic/SGQRCode'
    s.license      = 'Apache-2.0'
    s.authors      = {'kingsic' => 'kingsic@126.com'}
    s.platform     = :ios, '8.0'
    s.source       = {:git => 'https://github.com/kingsic/SGQRCode.git', :tag => s.version}
    s.source_files = 'SGQRCode/**/*.{h,m}'
    s.resource     = 'SGQRCode/SGQRCode.bundle'
    s.requires_arc = true
end
