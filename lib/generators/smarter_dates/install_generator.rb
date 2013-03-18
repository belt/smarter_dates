module SmarterDates
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc 'creates initialization files'

    def generate_configuration_files
      copy_file 'features/smarter_dates.rb', 'config/features/smarter_dates.rb'
    end
  end

end
