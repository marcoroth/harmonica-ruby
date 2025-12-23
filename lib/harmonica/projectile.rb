# frozen_string_literal: true
# rbs_inline: enabled

module Harmonica
  # Projectile simulates physics projectile motion.
  #
  # @example
  #   projectile = Harmonica::Projectile.new(
  #     delta_time: Harmonica.fps(60),
  #     position: Harmonica::Point.new(0, 100, 0),
  #     velocity: Harmonica::Vector.new(2, 0, 0),
  #     acceleration: Harmonica::GRAVITY
  #   )
  #
  #   loop do
  #     position = projectile.update
  #     break if position.y <= 0
  #   end
  class Projectile
    # @rbs @delta_time: Float
    # @rbs @position: Point
    # @rbs @velocity: Vector
    # @rbs @acceleration: Vector

    attr_reader :position #: Point
    attr_reader :velocity #: Vector
    attr_reader :acceleration #: Vector
    attr_reader :delta_time #: Float

    # Create a new Projectile.
    #
    # @rbs delta_time: Float -- time step per frame (use Harmonica.fps)
    # @rbs position: Point -- initial position
    # @rbs velocity: Vector -- initial velocity
    # @rbs acceleration: Vector -- constant acceleration (e.g., gravity)
    # @rbs return: void
    def initialize(delta_time:, position:, velocity:, acceleration:)
      @delta_time = delta_time.to_f
      @position = position
      @velocity = velocity
      @acceleration = acceleration
    end

    # Update the projectile position and velocity for one time step.
    #
    #: () -> Point
    def update
      @position = Point.new(
        @position.x + (@velocity.x * @delta_time),
        @position.y + (@velocity.y * @delta_time),
        @position.z + (@velocity.z * @delta_time)
      )

      @velocity = Vector.new(
        @velocity.x + (@acceleration.x * @delta_time),
        @velocity.y + (@acceleration.y * @delta_time),
        @velocity.z + (@acceleration.z * @delta_time)
      )

      @position
    end

    # Reset the projectile to a new state.
    #
    # @rbs position: Point -- new position
    # @rbs velocity: Vector -- new velocity
    # @rbs return: void
    def reset(position:, velocity:)
      @position = position
      @velocity = velocity
    end
  end
end
