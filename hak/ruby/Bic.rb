=begin
********************************************************************************
Bic.rb

Provides methods for handling character files. From NWN, the typical usage is
using the static methods.

********************************************************************************
CLASS METHODS

static Bic.change_name(playername, oldname, newname)
static Bic.fix_walk(playername, name)
static Bic.remove(playername, name)
static Bic.strip(name)
public Bic.read()
public Bic.write()
public Bic.save()

ACCESSORS
:file - The path to the bic file in question.
:obj  - The GFF structure of the bic (NWN::Gff), set by read().

********************************************************************************
=end


require 'fileutils'
require 'nwn/all'

class Bic
  attr_accessor :file, :obj

  public
    # Static methods

    # Delete the .bic file for the character belonging to [playername] called [name].
    def Bic.remove(playername, name)
      bic = Bic.new(playername, name)
      result = bic.delete
      if (result != 0)
        puts "Deleting file \"" + bic.file + "\" failed."
      end

      return result
    end

    # Change the name of [oldname] in [playername]'s vault to [newname].
    def Bic.change_name(playername, oldname, newname)
      begin
        bic = Bic.new(playername, oldname)
        raise if (!bic.valid?)

        bic.read
        o = bic.obj
        (o / "FirstName").v[0] = newname
        (o / "LastName").v[0] = ''
        bic.obj = o
        bic.save
        
        newfile = "servervault/" + playername + "/" + Bic.strip(newname.downcase)[0..15] + ".bic";

        FileUtils.mv(bic.file, newfile)
        
        return 0
      rescue
        puts "Changing name: " + playername + "/" + oldname + " --> " + newname + " failed."
        puts $!
        return 1
      end
    end

    # Fix a bug that sometimes seems to permanently break a PC's walk rate.
    def Bic.fix_walk(playername, name)
      begin
        bic = Bic.new(playername, name)
        raise if (!bic.valid?)

        bic.read
        o = bic.obj

        # Make changes.
        if !(o.has_key? "WalkRate")
          o.add_word("WalkRate", 0)
        else
          o["WalkRate"]["value"] = 0
        end

        if !(o.has_key? "MovementRate")
          o.add_word("MovementRate", 0)
        else
          o["MovementRate"]["value"] = 0
        end

        # Write changes.
        bic.obj = o
        bic.save
        return 0
      rescue
        puts "Fixing walk: " + playername + "/" + name + " failed."
        puts $!
        return 1
      end
    end

    # Strip out invalid file characters from name.
    def Bic.strip(name)
      name.downcase.gsub(/[^a-z']/, "")
    end

    # Member methods
    def initialize(playername, name)
      #stripped_name = Bic.strip(name)

      # Find all matching files.
      d = Dir.new("servervault/" + playername)
      #files = []
      #d.each do |filename|
      #  noext = filename[/^[^\.]*/]
      #  files.push(filename) if noext[0..14] == stripped_name[0..14]
      #end

      #if files.empty?
      #  @file = nil
      #  return
      #end

      # Find the file most recently edited.
      latest = Time.mktime(0)
      file   = ''
      d.each do |filename|
        t = File.mtime("servervault/" + playername + "/" + filename)
        if (t > latest and filename[-4..-1] == '.bic')
          latest = t
          file = filename
        end
      end

      if (file == '' or !File.writable?("servervault/" + playername + "/" + file))
        @file = nil
      else
        @file = "servervault/" + playername + "/" + file
      end
    end

    def valid?
      return @file != nil
    end

    # Read the contents of the file and store them in @obj.
    def read
      return nil if !self.valid?

      io = File.new(@file)
      @obj = begin
        NWN::Gff.read(io, :gff)
      ensure
        io.close
      end
    end

    # Save changes in the bic file.
    def save
      return if !self.valid?

      File.open(@file, "w") do |f|
        NWN::Gff.write(f, :gff, @obj)
      end
    end

    # Removes the bic file from visibility (don't actually delete it).
    def delete
      if (!self.valid? or !File.writable?(@file))
        return 1
      else
        FileUtils.mkdir_p("graveyard/" + File.dirname(@file))
        FileUtils.mv(@file, "graveyard/" + @file)
        return 0
      end
    end
end
