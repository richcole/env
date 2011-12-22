#!/usr/bin/ruby1.8

require 'fileutils'
require 'logger'

class String
  def /(other)
    File.join(self, other)
  end
end

class SimpleLogger
  def info(msg)
    STDOUT.puts(msg)
  end
end

class InstallEnv

  attr_accessor :log

  def initialize
    @log = SimpleLogger.new
  end

  def install(file, dest)
    log.info("Installing #{file} at #{dest}")
    FileUtils.rm_f(dest)
    FileUtils.ln_s(file, dest)
  end

  def run(cmd)
    puts "run: " + cmd
    if ! system(cmd) then
      raise "Command failed."
    end
  end

  def install_packages
    run "sudo apt-get install -y git-core emacs23 sudo sun-java6-jdk virtualbox-ose-guest-x11 virtualbox-ose-guest-dkms ruby1.8"
    run "update-java-alternatives -s java-6-sun"
  end

  def install_files
    config_path = Dir.pwd / "env/config"
    for file in Dir.glob(config_path / "*") do
      dot_file = File.basename(file).sub(/^dot_/, '.')
      install(file, dot_file)
    end
    
    bin_path = Dir.pwd / "env/bin"
    local_bin_dir  = ENV["HOME"] / "bin"
    FileUtils.mkdir_p(local_bin_dir)
    for file in Dir.glob(bin_path / "*") do
      bin_file = local_bin_dir / File.basename(file)
      install(file, bin_file)
    end
  end
end

env = InstallEnv.new
env.install_files
env.install_packages
