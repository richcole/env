#!/usr/bin/ruby

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

  def run
    config_path = "env/config"
    for file in Dir.glob(config_path / "*") do
      dot_file = File.basename(file).sub(/^dot_/, '.')
      install(file, dot_file)
    end
    
    bin_path = "env/bin"
    local_bin_dir  = ENV["HOME"] / "bin"
    FileUtils.mkdir_p(local_bin_dir)
    for file in Dir.glob(bin_path / "*") do
      bin_file = local_bin_dir / File.basename(file)
      install(file, bin_file)
    end
  end
end

InstallEnv.new.run
