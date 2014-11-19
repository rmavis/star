#
# Methods for the demo.
# To run it, prepend "--demo" to any normal string of arguments.
# Such as "bm --demo -a" or "bm --demo -o book".
#


module Bm
  class Demo < Bm::Hub


    def self.file_path
      Bm::Store.backup_file_path(Bm::Demo.file_ext)
    end

    def self.file_name
      Bm::Store.backup_file_name(Bm::Demo.file_ext)
    end

    def self.file_ext
      ".demo"
    end



    def self.filler_lines
      return [
        ['art', 'NASA', 'space', 'http://settlement.arc.nasa.gov/70sArtHiRes/70sArt/art.html'],
        ['art', 'design', 'https://en.wikipedia.org/wiki/El_Lissitzky'],
        ['awesome', 'book', 'creepy', 'https://en.wikipedia.org/wiki/House_of_Leaves'],
        ['awesome', 'book', 'nerdy', 'https://en.wikipedia.org/wiki/Cryptonomicon'],
        ['book', 'ruby', 'why', 'http://mislav.uniqpath.com/poignant-guide/'],
        ['demo', 'ruby', 'why', 'http://tryruby.org/levels/1/challenges/0'],
        ['design', 'Experimental Jetset', 'web design', 'http://www.experimentaljetset.nl/'],
        ['machinefabriek', 'music', 'web design', 'http://www.machinefabriek.nu/'],
        ['music', 'Nils Frahm', 'Screws', 'http://screws.nilsfrahm.com/'],
        ['OS X', 'utility', 'clipboard', 'Flycut', 'https://github.com/TermiT/Flycut/']
      ]
    end



    def self.run( args = [ ] )
      Bm::Demo.new(args).main
    end




    def initialize(args)
      super(args, true)
    end


    def main
      self.start!

      if self.has_file
        puts "#{Bm::Message.out(:start, Bm.has_file?)}\n\n"

        super
        if self.stop
          ret = Bm::Message.out(:done, Bm.has_file?)
        else
          ret = Bm::Message.out(:delfail)
        end
      else
        ret = Bm::Message.out(:startfail)
      end

      puts "\n#{ret}"
    end


    def start!
      self.make_file
      if self.has_file
        self.write_lines
      end
    end


    def write_lines
      self.lines = [ ]
      Bm::Demo.filler_lines.each do |arr|
        self.lines.push(self.line_from_args!(arr))
      end
      return super
    end


    def stop
      if self.has_file
        File.delete(self.file_path)
        self.check_file!
        ret = (self.has_file) ? nil : true
      else
        ret = true
      end

      return ret
    end



    # Messages unique to the demo.
    def out_msg(x = :bork, v = nil)
      x = :bork if !x.is_a? Symbol

      if (x == :delfail)
        ret = "Failed to delete the demo file, #{self.file_name}. Lame."

      elsif (x == :done)
        if v.nil?
          ret = "And that's how it works! To get started, type \"bm -i\", or add a line with something like \"bm -n what ever\"."
        else
          ret = "Removed the demo file, #{self.file_name}."
        end

      elsif (x == :start)
        ret = "This is a demo of #{"bm".bold}. It is running from a demo file, #{self.file_name}."
        ret << " Your #{Bm::Config.file_name} is safe." if v

      elsif (x == :startfail)
        ret = "Unable to run the demo :("

      else
        ret = super(x, v)
      end

      return ret
    end


  end
end