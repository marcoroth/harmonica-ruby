# frozen_string_literal: true
# rbs_inline: enabled

module Harmonica
  # Vector represents a vector in 3D space with magnitude and direction.
  #
  # @example
  #   velocity = Harmonica::Vector.new(2.0, 0.0, 0.0)
  #   gravity = Harmonica::GRAVITY
  class Vector
    # @rbs @x: Float
    # @rbs @y: Float
    # @rbs @z: Float

    attr_accessor :x #: Float
    attr_accessor :y #: Float
    attr_accessor :z #: Float

    # @rbs x: Integer | Float -- x component
    # @rbs y: Integer | Float -- y component
    # @rbs z: Integer | Float -- z component
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
      return false unless other.is_a?(Vector)

      @x == other.x && @y == other.y && @z == other.z
    end

    #: () -> String
    def to_s
      "Vector(#{@x}, #{@y}, #{@z})"
    end

    #: () -> String
    def inspect
      to_s
    end

    # Vector addition
    #
    #: (Vector other) -> Vector
    def +(other)
      Vector.new(@x + other.x, @y + other.y, @z + other.z)
    end

    # Vector subtraction
    #
    #: (Vector other) -> Vector
    def -(other)
      Vector.new(@x - other.x, @y - other.y, @z - other.z)
    end

    # Scalar multiplication
    #
    #: (Integer | Float other) -> Vector
    def *(other)
      Vector.new(@x * other, @y * other, @z * other)
    end

    # Magnitude (length) of the vector
    #
    #: () -> Float
    def magnitude
      Math.sqrt((@x * @x) + (@y * @y) + (@z * @z))
    end

    # Normalize the vector (unit vector)
    #
    #: () -> Vector
    def normalize
      mag = magnitude
      return Vector.new(0, 0, 0) if mag.zero?

      Vector.new(@x / mag, @y / mag, @z / mag)
    end
  end

  # origin at bottom-left, Y pointing up
  GRAVITY = Vector.new(0, -9.81, 0).freeze #: Vector

  # origin at top-left, Y pointing down
  TERMINAL_GRAVITY = Vector.new(0, 9.81, 0).freeze #: Vector
end
