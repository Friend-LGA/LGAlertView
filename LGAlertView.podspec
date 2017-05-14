Pod::Spec.new do |s|

    s.name = 'LGAlertView'
    s.version = '2.4.0'
    s.platform = :ios, '8.0'
    s.license = 'MIT'
    s.homepage = 'https://github.com/Friend-LGA/LGAlertView'
    s.author = { 'Grigory Lutkov' => 'Friend.LGA@gmail.com' }
    s.source = { :git => 'https://github.com/Friend-LGA/LGAlertView.git', :tag => s.version }
    s.summary = 'Customizable implementation of UIAlertViewController, UIAlertView and UIActionSheet. All in one.'
    s.description = 'Customizable implementation of UIAlertViewController, UIAlertView and UIActionSheet. All in one. ' \
                    'You can customize every detail. Make AlertView of your dream! :)'

    s.requires_arc = true

    s.source_files = 'LGAlertView/*.{h,m}'

end
