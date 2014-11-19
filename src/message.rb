#
# Messages.
#



module Bm
  class Message < Bm::Hub


    def self.help_msg
      ret = <<END
#{"Readme".header}
  #{"bm".syscmd} is a simple tool for saving and retrieving bits of text. You
  could use it to save bookmarks, hard-to-remember commands, complex
  emoticons, stuff like that.

  Say you want to save Wikipedia's page on Tardigrades. You would enter:
    $ bm -n https://en.wikipedia.org/wiki/Tardigrade

  Then, when you want to read about those creepy cool animals again, you
  can type:
    $ bm Tardigrade
  And, assuming you haven't saved anything else that includes the word
  "Tardigrade", #{"bm".syscmd} will copy the URL to your clipboard. Or you can type:
    $ bm -o Tardigrade
  and the URL will be opened in your default browser.

  To help with retrieving things later, you can tag can your saves by
  entering words before the value you want to copy or open. So say you
  want to save Wikipedia's page on the Flammarion Engraving and tag it
  "wiki" and "art":
    $ bm -n wiki art http://en.wikipedia.org/wiki/Flammarion_engraving

  To see all your saves tagged "wiki":
    $ bm wiki

  To see all your saves tagged both "wiki" and "art":
    $ bm wiki art

  If there are more than one saves that match the tags, then you'll be
  shown a numbered list of them and prompted for the one you want. The
  text on the numbered line will be copied to your clipboard. Tags will
  be listed beneath the numbered line. And if there's only one match,
  you'll skip the browsing step.

  #{"bm".syscmd} saves your text in a plain text file at #{Bm::Config.file_name}, so you can add,
  edit, and remove values in your editor of choice. You can also delete
  values with:
    $ bm -d

  To see a list of commands:
    $ bm -c

  And to run a little demo:
    $ bm --demo

END
      return ret
    end



    def self.show_commands
      ret = <<END
#{"Flags".header}
  -a, --all        Show all saves.
  -c, --commands   Show this message.
  -d, --delete     Delete a save.
  -i, --init       Create the #{Bm::Config.file_name} file.
  -l, --loose      Match loosely, rather than strictly.
  -m, --demo       Run the demo.
  -n, --new        Add a new line.
  -o, --open       #{"open".syscmd} the value rather than #{"pbcopy".syscmd} it.
  -p, --copy       #{"pbcopy".syscmd} the value rather than #{"open".syscmd} it.
  -r, --readme,
    -h, --help     Show the readme message.
  -s, --strict     Match strictly rather than loosely.
  -t, --tags       Show all tags.
  -x, --examples   Show some examples.
  -xr, -rx,
    -xh, -hx       Show the readme message with extra details.

END
      return ret
    end



    def self.show_examples
      ret = <<END
#{"Examples".header}
  #{"bm -a".bmcmd}
     See a numbered list of all your saves. You'll be prompted to enter
     the number of the line you want. That line will be piped to #{"pbcopy".syscmd},
     thereby copying it to your clipboard.

  #{"bm -n music \"Nils Frahm\" Screws http://screws.nilsfrahm.com/".bmcmd}
     Save a new line to your #{Bm::Config.file_name}. The URL is the value that will be
     piped to #{"pbcopy".syscmd} or passed to #{"open".syscmd}. The other parts of the line are
     the tags, which will be checked when you run other commands.

  #{"bm music".bmcmd}
     See a numbered list of your saves tagged "music". As with #{"bm -a".bmcmd},
     you'll be prompted to enter the number of the line you want piped
     to #{"pbcopy".syscmd}. If only one value matches, you won't be prompted for a
     line. See the important note before.

  #{"bm weird music".bmcmd}
     Identical to #{"bm music".bmcmd} but the list will show your saves
     tagged both "weird" and "music".

  #{"bm -l weird music".bmcmd}
     Identical to #{"bm music".bmcmd} but the list will show your saves
     tagged either "weird" or "music".

  #{"bm -o music".bmcmd}
     Identical to #{"bm music".bmcmd} but the value on the line you enter will be
     passed to #{"open".syscmd}. So URLs should open in your default browser, files
     and directories should #{"open".syscmd} as expected, etc.

  #{"bm -d music".bmcmd}
     Identical to #{"bm music".bmcmd} but the value on the line you enter will be
     deleted from your #{Bm::Config.file_name}.

END
      return ret + "\n" + Bm::Message.imp_note
    end



    def self.imp_note
      ret = <<END
#{"Important".header}
  If only one save matches the tags you specify, then you will not be
  shown a numbered list of matches. Instead, that step will be skipped
  and the value will be copied, opened, or deleted accordingly.

  So if only one save is tagged "music", then #{"bm -o music".bmcmd} will pass
  the matching value to #{"open".syscmd}, and #{"bm -d music".bmcmd} will delete the save
  from your #{Bm::Config.file_name}.

END
      return ret
    end



    def self.extra_notes
      ret = <<END
#{"Extra".header}
  If you feel list customizing #{"bm".syscmd}, there are three class methods toward
  the top of the file that you can change:
    1. The file name, #{Bm::Config.file_name}, is specified in Bm::file_name
       If you change this, make sure you have write privileges.
    2. The default filter mode is specified in Bm::filter_mode
       The value should be a symbol, either :strict or :loose
    3. The default system action is specified in Bm::pipe_to
       The value should be a symbol, either :copy or :open

  #{"bm".syscmd} uses the non-printing ASCII record and unit separator characters
  when saving your data. The record separator separates each "line". Each
  line holds the value that will be copied or opened along with any tags.
  If there are tags, they will be separated from the value and from each
  other by the unit separator. The value is the last slot in that line.
  Something like this:
    https://en.wikipedia.org/wiki/Tardigrade
    #{"^^".red}
    music#{"^_".red}Nils Frahm#{"^_".red}Screws#{"^_".red}http://screws.nilsfrahm.com/
    #{"^^".red}
    wiki#{"^_".red}art#{"^_".red}http://en.wikipedia.org/wiki/Flammarion_engraving

  So if you want to edit the file in your editor of choice, beware that
  your editor might not display those characters, or might display them
  weirdly. In #{"emacs".syscmd}, you can enter the record separator with:
    C-q 036 <RET>
  And the unit separator with:
    C-q 037 <RET>

END
      return ret
    end




    #
    # This returns a message according to the given key.
    # The calls to self will return values inherited from Bm::Hub.
    #

    def self.out( x = :bork, v = nil )
      x = :bork if !x.is_a? Symbol

      if (x == :actbad)
        ret = (v.nil?) ? "Invalid action. Strange fire." : "Invalid action: '#{v}'. Strange fire."

      elsif (x == :argsbad)
        ret = "Bad arguments, friendo."
        ret << "\n\n" + Bm::Message.show_commands if v

      elsif (x == :argsno)
        ret = "No arguments. Try something like \"bm good stuff\"."

      elsif (x == :delfail)
        ret = "Something went wrong with deleting the line."
        ret << " A backup file was created at \"#{Bm::Store.backup_file_name}\"." if v

      elsif (x == :delnah)
        ret = "Nevermind? Okay."

      elsif (x == :delok)
        ret = (v.nil?) ? "Consider it gone." : "Deleted \"#{v}\"."

      elsif (x == :demodup)
        ret = "No meta-demos, buster."

      elsif (x == :fileempty)
        ret = "#{Bm::Store.file_name} is empty. You can add lines with \"bm -n what ever\"."

      elsif (x == :fileexists)
        ret = "#{Bm::Store.file_name} already exists."

      elsif (x == :filefail)
        ret = "Failed to create #{Bm::Store.file_name} :("

      elsif (x == :fileno)
        ret = "Can't read #{Bm::Store.file_name} because it doesn't exist. Run \"bm -i\"?"

      elsif (x == :init)
        ret = "Created #{Bm::Store.file_name}."

      elsif (x == :linesno)
        ret = "#{Bm::Store.file_name} has no valid lines."

      elsif (x == :matchno)
        ret = "No lines match."

      elsif (x == :openfail)
        ret = "Failed to open :("

      elsif (x == :openok)
        ret = (v.nil?) ? "Opened it." : "Opened \"#{v}\"."

      elsif (x == :pipefail)
        ret = "Failed to copy value to clipboard. WTF?"

      elsif (x == :pipeok)
        ret = (v.nil?) ? "Good good." : "Copied \"#{v}\"."

      elsif (x == :savefail)
        ret = "Failed to save new line :("

      elsif (x == :saveok)
        ret = "Save new line."

      elsif (x == :valnah)
        ret = "Nothing wanted, nothing copied."

      elsif (x == :valno)
        ret = "Unable to find the value on \"#{v}\"."

      else
        ret = "Error: something unknown is doing we don't know what."
      end

      return ret
    end


  end
end