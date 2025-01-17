require 'xcodeproj'

module Pod

  class ProjectManipulator
    attr_reader :configurator, :xcodeproj_path, :platform, :remove_demo_target, :string_replacements, :prefix , :use_bxs_module, :appul_path

    def self.perform(options)
      new(options).perform
    end

    def initialize(options)
      @xcodeproj_path = options.fetch(:xcodeproj_path)
      @configurator = options.fetch(:configurator)
      @platform = options.fetch(:platform)
      @remove_demo_target = options.fetch(:remove_demo_project)
      @prefix = options.fetch(:prefix)
      @use_bxs_module = options.fetch(:use_bxs_module)
    end

    def run
      @appul_path = @configurator.pod_name.gsub("BXS", "").gsub(@prefix, "").capitalize

      @string_replacements = {
        "APPULPATH" => @appul_path,
        "PROJECT_OWNER" => @configurator.user_name,
        "TODAYS_DATE" => @configurator.date,
        "TODAYS_YEAR" => @configurator.year,
        "PROJECT" => @configurator.pod_name,
        "CPD" => @prefix
      }
      replace_internal_project_settings

      @project = Xcodeproj::Project.open(@xcodeproj_path)
      add_podspec_metadata
      remove_demo_project if @remove_demo_target
      @project.save

      rename_files
      rename_project_folder

      rename_module if @use_bxs_module
    end

    def add_podspec_metadata
      project_metadata_item = @project.root_object.main_group.children.select { |group| group.name == "Podspec Metadata" }.first
      project_metadata_item.new_file "../" + @configurator.pod_name  + ".podspec"
      project_metadata_item.new_file "../README.md"
      project_metadata_item.new_file "../LICENSE"
    end

    def remove_demo_project
      app_project = @project.native_targets.find { |target| target.product_type == "com.apple.product-type.application" }
      test_target = @project.native_targets.find { |target| target.product_type == "com.apple.product-type.bundle.unit-test" }
      test_target.name = @configurator.pod_name + "_Tests"

      # Remove the implicit dependency on the app
      test_dependency = test_target.dependencies.first
      test_dependency.remove_from_project
      app_project.remove_from_project

      # Remove the build target on the unit tests
      test_target.build_configuration_list.build_configurations.each do |build_config|
        build_config.build_settings.delete "BUNDLE_LOADER"
      end

      # Remove the references in xcode
      project_app_group = @project.root_object.main_group.children.select { |group| group.display_name.end_with? @configurator.pod_name }.first
      project_app_group.remove_from_project

      # Remove the product reference
      product = @project.products.select { |product| product.path == @configurator.pod_name + "_Example.app" }.first
      product.remove_from_project

      # Remove the actual folder + files for both projects
      `rm -rf templates/ios/Example/PROJECT`
      `rm -rf templates/swift/Example/PROJECT`

      # Replace the Podfile with a simpler one with only one target
      podfile_path = project_folder + "/Podfile"

      if use_bxs_module == :yes
        podfile_text = <<-RUBY
# use_frameworks!
use_modular_headers!
source 'git@git.winbaoxian.com:wy_ios/Specs.git'
source 'https://github.com/CocoaPods/Specs.git'

target '#{test_target.name}' do
  pod '#{@configurator.pod_name}', :path => '../'
  
  ${INCLUDED_PODS}
end
RUBY

        File.open(podfile_path, "w") { |file| file.puts podfile_text }
      else
        podfile_text = <<-RUBY
use_frameworks!
target '#{test_target.name}' do
  pod '#{@configurator.pod_name}', :path => '../'
  
  ${INCLUDED_PODS}
end
RUBY

        File.open(podfile_path, "w") { |file| file.puts podfile_text }
      end
    end

    def project_folder
      File.dirname @xcodeproj_path
    end

    def rename_files
      # shared schemes have project specific names
      scheme_path = project_folder + "/PROJECT.xcodeproj/xcshareddata/xcschemes/"
      File.rename(scheme_path + "PROJECT.xcscheme", scheme_path +  @configurator.pod_name + "-Example.xcscheme")

      # rename xcproject
      File.rename(project_folder + "/PROJECT.xcodeproj", project_folder + "/" +  @configurator.pod_name + ".xcodeproj")

      unless @remove_demo_target
        # change app file prefixes
        ["CPDAppDelegate.h", "CPDAppDelegate.m", "CPDViewController.h", "CPDViewController.m"].each do |file|
          before = project_folder + "/PROJECT/" + file
          next unless File.exists? before

          after = project_folder + "/PROJECT/" + file.gsub("CPD", prefix)
          File.rename before, after
        end

        # rename project related files
        ["PROJECT-Info.plist", "PROJECT-Prefix.pch", "PROJECT.entitlements"].each do |file|
          before = project_folder + "/PROJECT/" + file
          next unless File.exists? before

          after = project_folder + "/PROJECT/" + file.gsub("PROJECT", @configurator.pod_name)
          File.rename before, after
        end
      end

    end

    def rename_project_folder
      if Dir.exist? project_folder + "/PROJECT"
        File.rename(project_folder + "/PROJECT", project_folder + "/" + @configurator.pod_name)
      end
    end

    def replace_internal_project_settings
      Dir.glob(project_folder + "/**/**/**/**").each do |name|
        next if Dir.exists? name
        text = File.read(name)

        for find, replace in @string_replacements
            text = text.gsub(find, replace)
        end

        File.open(name, "w") { |file| file.puts text }
      end
    end

    
    def rename_module
      pod = "./Pod/Classes"
      rename_module_files(pod)
      replace_module_content(pod)

      ctcg = "./CTMediator_Category"
      rename_module_folder(ctcg)
      rename_module_files(ctcg)
      replace_module_content(ctcg)
    end
    
    def rename_module_folder(dir)
      if Dir.exist? dir + "/PROJECT"
        File.rename(dir + "/PROJECT", dir + "/" + @configurator.pod_name)
      end
    end

    def rename_module_files(dir)
      Dir.glob(dir + "/**/**/**/**").each do |name|
        next if File.directory? name
        before = name 
        after = name.gsub("CPD", prefix).gsub("PROJECT", @configurator.pod_name).gsub("APPULPATH", @appul_path)
        File.rename before, after
      end

    end

    def replace_module_content(dir)
      Dir.glob(dir + "/**/**/**/**").each do |name|
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
