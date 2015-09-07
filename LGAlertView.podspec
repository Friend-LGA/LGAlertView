Pod::Spec.new do |s|

    s.name = 'LGAlertView'
    s.version = '1.0.2'
    s.platform = :ios, '6.0'
    s.license = 'MIT'
    s.homepage = 'https://github.com/Friend-LGA/LGAlertView'
    s.author = { 'Grigory Lutkov' => 'Friend.LGA@gmail.com' }
    s.source = { :git => 'https://github.com/Friend-LGA/LGAlertView.git', :tag => s.version }
    s.summary = 'Customizable implementation of UIAlertView'

    s.requires_arc = true

    s.source_files = 'LGAlertView/*.{h,m}'

end
