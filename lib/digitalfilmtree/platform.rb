require 'rbconfig'

module Digitalfilmtree
  def self.platform
    @platform ||= Class.new do
      def initialize
        @os = RbConfig::CONFIG['host_os']
      end

      def windows?
        @os =~ /mswin|mingw|cygwin/
      end

      def mac?
        @os =~ /darwin/
      end

      def linux?
        @os =~ /linux/
      end
    end.new
  end
end
