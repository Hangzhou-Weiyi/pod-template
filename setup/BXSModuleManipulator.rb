module Pod

  class BXSModuleManipulator
    attr_reader :configurator, :string_replacements, :prefix

    def self.perform(options)
      new(options).perform
    end

    def initialize(options)  
      @configurator = options.fetch(:configurator)
      @prefix = options.fetch(:prefix)
    end

    def run
      if @configurator.use_bxs_module == :yes
        @string_replacements = {
          "PROJECT_OWNER" => @configurator.user_name,
          "TODAYS_DATE" => @configurator.date,
          "TODAYS_YEAR" => @configurator.year,
          "PROJECT" => @configurator.pod_name,
          "CPD" => @prefix
        }

        replace_internal_project_settings
        rename_header_file
        rename_target_files  

        `mv ./templates/bxs/NAME.podspec ./NAME.podspec`
        `cp -r ./templates/bxs/Pod ./`
        `cp -r ./templates/bxs/Example ./templates/ios/`
      end

      `rm -rf ./templates/bxs`
    end

    def module_folder
      "./templates/bxs/Pod/Classes/"
    end

    def rename_header_file
      file = "/PROJECT.h"
      before = module_folder + file
      return unless File.exists? before

      after = module_folder + file.gsub("PROJECT", @configurator.pod_name)
      File.rename before, after
    end

    def rename_target_files
      target_folder = module_folder + "/Target/"
      ["PROJECTTarget.h", "PROJECTTarget.m", "Target_PROJECT.h", "Target_PROJECT.m"].each do |file|
        before = target_folder + file
        next unless File.exists? before

        after = target_folder + file.gsub("PROJECT", @configurator.pod_name)
        File.rename before, after
      end
    end

    def replace_internal_project_settings
      Dir.glob(module_folder + "/**/**/**/**").each do |name|
        next if Dir.exists? name
        text = File.read(name)

        for find, replace in @string_replacements
            text = text.gsub(find, replace)
        end

        File.open(name, "w") { |file| file.puts text }
      end
    end
  
  end
end