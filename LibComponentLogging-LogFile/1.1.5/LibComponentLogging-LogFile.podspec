Pod::Spec.new do |s|

  s.name         = 'LibComponentLogging-LogFile'
  s.version      = '1.1.5'
  s.source       = { :git => 'https://github.com/aharren/LibComponentLogging-LogFile.git',
                     :tag => '1.1.5' }

  s.homepage     = 'http://0xc0.de/LibComponentLogging'
  s.author       = { 'Arne Harren' => 'ah@0xc0.de' }
  s.license      = 'MIT'

  s.summary      = 'LibComponentLogging logging back-end which writes log '    \
                   'messages to an application-specific log file.'
  s.description  = 'LibComponentLogging-LogFile is a logging back-end for '    \
                   'LibComponentLogging which writes log messages to an '      \
                   'application-specific log file.'

  s.source_files = 'LCLLogFile*.{h,m}'

  s.dependency 'LibComponentLogging-Core', '>= 1.1.6'

  def s.post_install(target)
    if not (config.respond_to? :lcl_config and config.lcl_config) then
      # LibComponentLogging-pods configuration is not available
      puts '[!] LibComponentLogging-LogFile needs to be configured. '          \
           'See http://0xc0.de/LibComponentLogging#CocoaPods for details.'
      return
    end

    config.lcl_config.configure_logger(
      'LogFile',
      'LCLLogFile.h',
      'Headers/LibComponentLogging-LogFile/LCLLogFileConfig.template.h',
      [ 'LibComponentLogging-LogFile/LCLLogFile.m' ]
      )
  end

end
