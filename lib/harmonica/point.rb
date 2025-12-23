# frozen_string_literal: true
# rbs_inline: enabled

module Harmonica
  # Point represents a point in 3D space.
  #
  # @example
  #   point = Harmonica::Point.new(10.0, 20.0, 0.0)
  #   point.x  # => 10.0
  #   point.y  # => 20.0
  #   point.z  # => 0.0
  class Point
    # @rbs @x: Float
    # @rbs @y: Float
    # @rbs @z: Float

    attr_accessor :x #: Float
    attr_accessor :y #: Float
    attr_accessor :z #: Float

    # @rbs x: Integer | Float -- x coordinate
    # @rbs y: Integer | Float -- y coordinate
    # @rbs z: Integer | Float -- z coordinate
    # @rbs return: void
    def initialize(x = 0.0, y = 0.0, z = 0.0)
      @x = x.to_f
      @y = y.to_f
      @z = z.to_f
    end

    #: () -> Array[Float]
    def to_a
      [@x, @y, @z]
    end

    #: (untyped other) -> bool
    def ==(other)
      return false unless other.is_a?(Point)

      @x == other.x && @y == other.y && @z == other.z
    end

    #: () -> String
    def to_s
      "Point(#{@x}, #{@y}, #{@z})"
    end

    #: () -> String
    def inspect
      to_s
    end
  end
end
