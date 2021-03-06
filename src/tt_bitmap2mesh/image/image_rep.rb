#-------------------------------------------------------------------------------
#
# Thomas Thomassen
# thomas[at]thomthom[dot]net
#
#-------------------------------------------------------------------------------

require 'tt_bitmap2mesh/image/color'


module TT::Plugins::BitmapToMesh
  # Interface to expose ImageRep functionality in similar fashion to DIB.
  class ImageRep

    class InvalidFileError < StandardError; end

    def initialize(source)
      if source.is_a?(String)
        @image_rep = Sketchup::ImageRep.new(source)
      elsif defined?(Sketchup::ImageRep) && source.is_a?(Sketchup::ImageRep)
        @image_rep = source
      end
      # This can happen when the file type/format/version is not supported or
      # corrupted. (Issue #5)
      if @image_rep.size.zero?
        raise InvalidFileError, 'Unable to load file'
      end
      # The rows from ImageRep needs to be reversed in order to be compatible
      # with DIB.
      rows = @image_rep.colors.each_slice(width).to_a
      rows.reverse!
      rows.flatten!
      rows.map! { |color| Color.new(color) }
      @data = rows
    end

    def pixels
      @image_rep.width * @image_rep.height
    end

    def data
      @data
    end

    def width
      @image_rep.width
    end

    def height
      @image_rep.height
    end

    def save(filename)
      @image_rep.save_file(filename)
    end

  end # class
end # module
