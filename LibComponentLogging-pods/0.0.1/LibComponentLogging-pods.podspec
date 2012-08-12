
class LibComponentLoggingPodsConfig

  def initialize(pods_config)
    # CocoaPods configuration data
    @pods_config = pods_config
    @pods_headers_name = "Headers"
    @pods_buildheaders_name = "BuildHeaders"
    @pods_root_name = File.basename(@pods_config.project_pods_root)

    # status
    @configure_already_prepared = false
    @last_configured_logger_name = ""

    # folders
    @lcl_core_root = @pods_config.project_pods_root + 'LibComponentLogging-Core'
    @lcl_pods_root = @pods_config.project_pods_root + "LibComponentLogging-pods"
    @lcl_pods_headers_root = @pods_config.project_pods_root + (@pods_headers_name + "/LibComponentLogging-pods")
    @lcl_pods_buildheaders_root = @pods_config.project_pods_root + (@pods_buildheaders_name + "/LibComponentLogging-pods")
    @lcl_user_root = @pods_config.project_pods_root + ".."

    # suffixes
    @lcl_pods_config_suffix = ".pods.main"
    @lcl_user_config_suffix = ".pods"
    @lcl_tmp_file_suffix = ".tmp"

    # core files
    @lcl_core_header_file_name = "lcl.h"
    @lcl_core_header_file = @lcl_core_root + @lcl_core_header_file_name
    @lcl_core_implementation_file_name = "lcl.m"
    @lcl_core_implementation_file = @lcl_core_root + @lcl_core_implementation_file_name

    # pods configuration files
    @lcl_pods_config_components_file_name = "lcl_config_components.h" + @lcl_pods_config_suffix
    @lcl_pods_config_logger_file_name = "lcl_config_logger.h" + @lcl_pods_config_suffix
    @lcl_pods_config_extensions_file_name = "lcl_config_extensions.h" + @lcl_pods_config_suffix

    @lcl_pods_config_components_file = @lcl_pods_root + @lcl_pods_config_components_file_name
    @lcl_pods_config_logger_file = @lcl_pods_root + @lcl_pods_config_logger_file_name
    @lcl_pods_config_extensions_file = @lcl_pods_root + @lcl_pods_config_extensions_file_name

    @lcl_pods_headers_config_components_file = @lcl_pods_headers_root + @lcl_pods_config_components_file_name
    @lcl_pods_headers_config_logger_file = @lcl_pods_headers_root + @lcl_pods_config_logger_file_name
    @lcl_pods_headers_config_extensions_file = @lcl_pods_headers_root + @lcl_pods_config_extensions_file_name

    @lcl_pods_buildheaders_config_components_file = @lcl_pods_buildheaders_root + @lcl_pods_config_components_file_name
    @lcl_pods_buildheaders_config_logger_file = @lcl_pods_buildheaders_root + @lcl_pods_config_logger_file_name
    @lcl_pods_buildheaders_config_extensions_file = @lcl_pods_buildheaders_root + @lcl_pods_config_extensions_file_name

    # user configuration files
    @lcl_user_config_components_file_name = "lcl_config_components.h" + @lcl_user_config_suffix
    @lcl_user_config_components_file = @lcl_user_root + @lcl_user_config_components_file_name
    @lcl_user_config_extensions_file_name = "lcl_config_extensions.h" + @lcl_user_config_suffix
    @lcl_user_config_extensions_file = @lcl_user_root + @lcl_user_config_extensions_file_name
  end

  # Creates the default configuration.
  def configure
    prepare_configure()
  end

  # Adds the given logging back-end to the lcl_config_logger.h configuration file.
  def configure_logger(name, header_file_name, config_template_file_name = "", modify_file_names = [])
    prepare_configure()

    info "Configuring LibComponentLogging logging back-end '" + name + "'"

    note "'" + name + "' overrides the previously configured logging back-end '" + @last_configured_logger_name + "'" if @last_configured_logger_name != ""

    # create new logger configuration file
    create_file(@lcl_pods_config_logger_file)
    link_file(@lcl_pods_config_logger_file, @lcl_pods_headers_config_logger_file)
    link_file(@lcl_pods_config_logger_file, @lcl_pods_buildheaders_config_logger_file)

    # add given header file to logger configuration file
    add_include(@lcl_pods_config_logger_file, header_file_name)

    # instantiate given configuration template file
    instantiate_config_template(config_template_file_name)

    # adapt includes
    modify_file_names.each do|file_name|
      add_suffix_to_includes(@pods_config.project_pods_root + file_name, @lcl_pods_config_suffix)
    end

    @last_configured_logger_name = name
  end

  # Adds the given extension to the lcl_config_extension.h configuration file.
  def configure_extension(name, header_file_name, config_template_file_name = "", modify_file_names = [])
    prepare_configure()

    info "Configuring LibComponentLogging extension '" + name + "'"

    # add given header file to extensions configuration file
    add_include(@lcl_pods_config_extensions_file, header_file_name)

    # instantiate given configuration template file
    instantiate_config_template(config_template_file_name)

    # adapt includes
    modify_file_names.each do|file_name|
      add_suffix_to_includes(@pods_config.project_pods_root + file_name, @lcl_pods_config_suffix)
    end
  end

  protected
  def prepare_configure
    return if @configure_already_prepared

    info "Creating LibComponentLogging configuration"

    # create folders
    create_folder(@lcl_pods_root)
    create_folder(@lcl_pods_headers_root)
    create_folder(@lcl_pods_buildheaders_root)

    # rewrite includes in lcl.* core files to include *.podsconfig files instead of plain lcl config files
    add_suffix_to_includes(@lcl_core_header_file, @lcl_pods_config_suffix)
    add_suffix_to_includes(@lcl_core_implementation_file, @lcl_pods_config_suffix)

    # create pods configuration files
    create_file(@lcl_pods_config_components_file)
    link_file(@lcl_pods_config_components_file, @lcl_pods_headers_config_components_file)
    link_file(@lcl_pods_config_components_file, @lcl_pods_buildheaders_config_components_file)
    create_file(@lcl_pods_config_logger_file)
    link_file(@lcl_pods_config_logger_file, @lcl_pods_headers_config_logger_file)
    link_file(@lcl_pods_config_logger_file, @lcl_pods_buildheaders_config_logger_file)
    create_file(@lcl_pods_config_extensions_file)
    link_file(@lcl_pods_config_extensions_file, @lcl_pods_headers_config_extensions_file)
    link_file(@lcl_pods_config_extensions_file, @lcl_pods_buildheaders_config_extensions_file)

    # create user configuration files
    touch_file(@lcl_user_config_components_file)
    touch_file(@lcl_user_config_extensions_file)
    note "Use '" + @lcl_user_config_components_file_name + "' to configure log components"
    note "Use '" + @lcl_user_config_components_file_name + "' to configure additional log extensions"

    # add user configuration files to pods configuration files
    add_include(@lcl_pods_config_components_file, @lcl_user_config_components_file_name)
    add_include(@lcl_pods_config_extensions_file, @lcl_user_config_extensions_file_name)

    # add lcl_config_components.h files from pods' headers to pods configuration files
    Dir.chdir(@pods_config.project_pods_root + @pods_headers_name) do
      Dir.glob('**/lcl_config_components.h').each do|file|
        add_include(@lcl_pods_config_components_file, @pods_root_name + "/" + @pods_headers_name + "/" + file)
      end
    end

    @configure_already_prepared = true
  end

  protected
  def create_folder(path)
    debug "Creating folder '" + path + "'"
    FileUtils.mkdir_p(path) unless File.directory? path
  end

  protected
  def create_file(file)
    debug "Creating file '" + file + "'"
    FileUtils.rm(file) if File.file? file
    FileUtils.touch(file)
  end

  protected
  def touch_file(file)
    debug "Touching file '" + file + "'"
    FileUtils.touch(file)
  end

  protected
  def copy_file(src_file, dst_file)
    debug "Copying file '" + src_file + "' to '" + dst_file + "'"
    FileUtils.cp(src_file, dst_file)
  end

  protected
  def link_file(src_file, dst_file)
    debug "Creating link '" + src_file + "' to '" + dst_file + "'"
    FileUtils.rm(dst_file) if File.file? dst_file
    FileUtils.ln_s(src_file, dst_file)
  end

  protected
  def add_suffix_to_includes(file, suffix)
    debug "Adding suffix '" + suffix + "' to includes in file '" + file + "'"
    text = File.read(file)
    text = text.gsub(/\"lcl_config_components.h\"/, '"lcl_config_components.h' + suffix + '"')
    text = text.gsub(/\"lcl_config_logger.h\"/, '"lcl_config_logger.h' + suffix + '"')
    text = text.gsub(/\"lcl_config_extensions.h\"/, '"lcl_config_extensions.h' + suffix + '"')
    File.open(file, "w") {|f| f.puts text}
  end

  protected
  def add_include(file, include)
    debug "Adding include '" + include + "' to file '" + file + "'"
    file.open('a') do |f|
      f.puts("#include \"" + include + "\"\n")
    end
  end

  protected
  def instantiate_config_template(config_template_file_name)
    return if config_template_file_name == ""

    config_template_path = File.dirname(config_template_file_name)
    config_template_name = File.basename(config_template_file_name)
    config_name = config_template_name.gsub(/\.template/, '')
    config_file = @lcl_user_root + config_name
    if File.file? config_file then
      copy_file(@pods_config.project_pods_root + config_template_path + config_template_name, @lcl_user_root + (config_name + @lcl_tmp_file_suffix))
      note "Configuration file '" + config_name + "' already exists, please merge with '" + config_name + @lcl_tmp_file_suffix + "' manually"
    else
      copy_file(@pods_config.project_pods_root + config_template_path + config_template_name, config_file)
      note "Configuration file '" + config_name + "' needs to be adapted before compiling your project"
    end
  end

  protected
  def info(text)
    if @pods_config.verbose? then
      puts "\n-> " + text
    else
      puts text
    end
  end

  protected
  def note(text)
    puts "[!] " + text
  end

  protected
  def debug(text)
    puts "   " + text if @pods_config.verbose?
  end

end


Pod::Spec.new do |s|
  s.name         = 'LibComponentLogging-pods'
  s.version      = '0.0.1'
  s.source       = { :git => 'https://github.com/aharren/LibComponentLogging-pods.git',
                     :tag => '0.0.1' }

  s.homepage     = 'http://0xc0.de/LibComponentLogging'
  s.author       = { 'Arne Harren' => 'ah@0xc0.de' }
  s.license      = 'MIT'

  s.summary      = 'LibComponentLogging configuration for CocoaPods.'
  s.description  = 'LibComponentLogging-pods provides a configuration '        \
                   'mechanism for LibComponentLogging and CocoaPods which '    \
                   'automatically configures logging back-ends and '           \
                   'extensions based on your project\'s CocoaPods pod file.'

  s.source_files = ''

  # add include path for user configuration files
  s.xcconfig     = { 'PODS_PUBLIC_HEADERS_SEARCH_PATHS' => '"${PODS_ROOT}/.."',
                     'PODS_BUILD_HEADERS_SEARCH_PATHS'  => '"${PODS_ROOT}/.."' }

  # add lcl_config to CocoaPods' config
  class << config
    attr_accessor :lcl_config
  end
  config.lcl_config = LibComponentLoggingPodsConfig.new(config)

  # make sure that we have at least the default configuration
  def s.post_install(target)
    config.lcl_config.configure()
  end

end
