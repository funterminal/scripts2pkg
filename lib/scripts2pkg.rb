require 'fileutils'
require 'thor'

module Scripts2pkg
  class CLI < Thor
    desc "package", "Convert scripts to debian or termux package"
    option :source_files, type: :array, required: false, default: [], desc: "Source filenames (comma-separated)"
    option :package_name, type: :string, required: false, desc: "Package name"
    option :package_version, type: :string, required: false, desc: "Package version"
    option :dependencies, type: :array, required: false, default: [], desc: "Package dependencies (comma-separated)"
    option :architecture, type: :string, required: false, desc: "Package architecture"
    option :termux, type: :boolean, required: false, default: false, desc: "Will this package work on Termux?"
    
    def package
      if interactive_mode?
        interactive_input
      else
        non_interactive_input
      end
    end

    private

    def interactive_mode?
      !options[:source_files].any? || options[:package_name].nil?
    end

    def interactive_input
      puts "Enter source filenames (comma separated, e.g. script1.rb, script2.py):"
      source_files = gets.chomp.split(",").map(&:strip)

      puts "Enter package name:"
      package_name = gets.chomp

      puts "Enter package version:"
      package_version = gets.chomp

      puts "Enter package dependencies (comma separated, e.g. libxyz, libabc):"
      dependencies = gets.chomp.split(",").map(&:strip)

      puts "Enter package architecture (e.g. all, arm64):"
      architecture = gets.chomp

      puts "Will this package work on Termux? (yes/no):"
      termux_package = gets.chomp.downcase == "yes"

      package_dir = create_package(package_name, package_version, dependencies, architecture, termux_package, source_files)
      puts "Package directory created at: #{package_dir}"

      puts "Run the following command to build the package:"
      puts "dpkg-deb --build #{package_dir}"

      FileUtils.chmod("0755", package_dir)
    end

    def non_interactive_input
      source_files = options[:source_files]
      package_name = options[:package_name]
      package_version = options[:package_version]
      dependencies = options[:dependencies]
      architecture = options[:architecture]
      termux_package = options[:termux]

      package_dir = create_package(package_name, package_version, dependencies, architecture, termux_package, source_files)
      puts "Package directory created at: #{package_dir}"

      puts "Run the following command to build the package:"
      puts "dpkg-deb --build #{package_dir}"

      FileUtils.chmod("0755", package_dir)
    end

    def create_package(package_name, package_version, dependencies, architecture, termux_package, source_files)
      base_dir = termux_package ? "/data/data/com.termux/files/usr/bin/#{package_name}" : "/usr/local/bin/#{package_name}"
      target_dir = "#{package_name}_#{package_version}"

      FileUtils.mkdir_p(target_dir)
      FileUtils.mkdir_p("#{target_dir}/DEBIAN")
      FileUtils.mkdir_p("#{target_dir}/#{base_dir}")

      source_files.each do |file|
        FileUtils.cp(file, "#{target_dir}/#{base_dir}/#{File.basename(file, File.extname(file))}")
      end

      create_control_file(target_dir, package_name, package_version, dependencies, architecture)
      target_dir
    end

    def create_control_file(target_dir, package_name, package_version, dependencies, architecture)
      control_file_content = <<~CONTROL
        Package: #{package_name}
        Version: #{package_version}
        Architecture: #{architecture}
        Depends: #{dependencies.join(", ")}
        Maintainer: Your Name <youremail@example.com>
        Description: A brief description of the package
      CONTROL

      File.write("#{target_dir}/DEBIAN/control", control_file_content)
    end
  end
end
