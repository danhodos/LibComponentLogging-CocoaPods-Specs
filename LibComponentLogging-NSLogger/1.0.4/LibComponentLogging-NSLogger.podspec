Pod::Spec.new do |s|

  s.name         = 'LibComponentLogging-NSLogger'
  s.version      = '1.0.4'
  s.source       = { :git => 'https://github.com/aharren/LibComponentLogging-NSLogger.git',
                     :tag => '1.0.4' }

  s.homepage     = 'http://0xc0.de/LibComponentLogging'
  s.author       = { 'Arne Harren' => 'ah@0xc0.de' }
  s.license      = 'MIT'

  s.summary      = 'LibComponentLogging logging back-end for Florent '         \
                   'Pillet\'s NSLogger client.'
  s.description  = 'LibComponentLogging-NSLogger is a logging back-end for '   \
                   'LibComponentLogging which integrates the logging '         \
                   'client from Florent Pillet\'s NSLogger project. '          \
                   'See http://github.com/fpillet/NSLogger for details '       \
                   'about NSLogger.'

  s.source_files = 'LCLNSLogger*.{h,m}'

  s.dependency 'LibComponentLogging-Core', '>= 1.1.6'
  s.dependency 'NSLogger'

  def s.post_install(target)
    if not (config.respond_to? :lcl_config and config.lcl_config) then
      # LibComponentLogging-pods configuration is not available
      puts '[!] LibComponentLogging-NSLogger needs to be configured. '         \
           'See http://0xc0.de/LibComponentLogging#CocoaPods for details.'
      return
    end

    config.lcl_config.configure_logger(
      'NSLogger',
      'LCLNSLogger.h',
      'Headers/LibComponentLogging-NSLogger/LCLNSLoggerConfig.template.h',
      [ 'LibComponentLogging-NSLogger/LCLNSLogger.m' ]
      )
  end

end
