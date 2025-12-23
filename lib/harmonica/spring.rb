# frozen_string_literal: true
# rbs_inline: enabled

module Harmonica
  # Spring is a damped harmonic oscillator for smooth, realistic spring-like motion.
  #
  # This is ported from Ryan Juckett's simple damped harmonic motion, originally
  # written in C++. For background on the algorithm see:
  # https://www.ryanjuckett.com/damped-springs/
  #
  # @example
  #   # Initialize once
  #   spring = Harmonica::Spring.new(
  #     delta_time: Harmonica.fps(60),
  #     angular_frequency: 6.0,
  #     damping_ratio: 0.2
  #   )
  #
  #   # Update on every frame
  #   position = 0.0
  #   velocity = 0.0
  #   target = 100.0
  #
  #   loop do
  #     position, velocity = spring.update(position, velocity, target)
  #   end
  class Spring
    EPSILON = Float::EPSILON #: Float

    # @rbs @delta_time: Float
    # @rbs @damping_ratio: Float
    # @rbs @angular_frequency: Float
    # @rbs @position_position_coefficient: Float
    # @rbs @position_velocity_coefficient: Float
    # @rbs @velocity_position_coefficient: Float
    # @rbs @velocity_velocity_coefficient: Float

    attr_reader :position_position_coefficient #: Float
    attr_reader :position_velocity_coefficient #: Float
    attr_reader :velocity_position_coefficient #: Float
    attr_reader :velocity_velocity_coefficient #: Float

    # Create a new Spring with precomputed coefficients.
    #
    # @rbs delta_time: Float -- time step (use Harmonica.fps for frame rate)
    # @rbs angular_frequency: Float -- angular frequency of motion (affects speed)
    # @rbs damping_ratio: Float -- damping ratio (> 1: over-damped, = 1: critical, < 1: under-damped)
    # @rbs return: void
    def initialize(delta_time:, angular_frequency:, damping_ratio:)
      @delta_time = delta_time
      @angular_frequency = [0.0, angular_frequency].max
      @damping_ratio = [0.0, damping_ratio].max

      compute_coefficients
    end

    # Update position and velocity towards equilibrium position.
    #
    # @rbs position: Float -- current position
    # @rbs velocity: Float -- current velocity
    # @rbs equilibrium_position: Float -- target/equilibrium position
    # @rbs return: [Float, Float]
    def update(position, velocity, equilibrium_position)
      old_position = position - equilibrium_position
      old_velocity = velocity

      new_position = (old_position * @position_position_coefficient) +
                     (old_velocity * @position_velocity_coefficient) +
                     equilibrium_position

      new_velocity = (old_position * @velocity_position_coefficient) +
                     (old_velocity * @velocity_velocity_coefficient)

      [new_position, new_velocity]
    end

    private

    #: () -> void
    def compute_coefficients
      if @angular_frequency < EPSILON
        @position_position_coefficient = 1.0
        @position_velocity_coefficient = 0.0
        @velocity_position_coefficient = 0.0
        @velocity_velocity_coefficient = 1.0
        return
      end

      if @damping_ratio > 1.0 + EPSILON
        compute_over_damped
      elsif @damping_ratio < 1.0 - EPSILON
        compute_under_damped
      else
        compute_critically_damped
      end
    end

    #: () -> void
    def compute_over_damped
      za = -@angular_frequency * @damping_ratio
      zb = @angular_frequency * Math.sqrt((@damping_ratio * @damping_ratio) - 1.0)
      z1 = za - zb
      z2 = za + zb

      e1 = Math.exp(z1 * @delta_time)
      e2 = Math.exp(z2 * @delta_time)

      inverse_two_zb = 1.0 / (2.0 * zb)

      e1_over_two_zb = e1 * inverse_two_zb
      e2_over_two_zb = e2 * inverse_two_zb

      z1e1_over_two_zb = z1 * e1_over_two_zb
      z2e2_over_two_zb = z2 * e2_over_two_zb

      @position_position_coefficient = (e1_over_two_zb * z2) - z2e2_over_two_zb + e2
      @position_velocity_coefficient = -e1_over_two_zb + e2_over_two_zb

      @velocity_position_coefficient = (z1e1_over_two_zb - z2e2_over_two_zb + e2) * z2
      @velocity_velocity_coefficient = -z1e1_over_two_zb + z2e2_over_two_zb
    end

    #: () -> void
    def compute_under_damped
      omega_zeta = @angular_frequency * @damping_ratio
      alpha = @angular_frequency * Math.sqrt(1.0 - (@damping_ratio * @damping_ratio))

      exponential_term = Math.exp(-omega_zeta * @delta_time)
      cosine_term = Math.cos(alpha * @delta_time)
      sine_term = Math.sin(alpha * @delta_time)

      inverse_alpha = 1.0 / alpha

      exponential_sine = exponential_term * sine_term
      exponential_cosine = exponential_term * cosine_term
      exponential_omega_zeta_sine_over_alpha = exponential_term * omega_zeta * sine_term * inverse_alpha

      @position_position_coefficient = exponential_cosine + exponential_omega_zeta_sine_over_alpha
      @position_velocity_coefficient = exponential_sine * inverse_alpha

      @velocity_position_coefficient = (-exponential_sine * alpha) - (omega_zeta * exponential_omega_zeta_sine_over_alpha)
      @velocity_velocity_coefficient = exponential_cosine - exponential_omega_zeta_sine_over_alpha
    end

    #: () -> void
    def compute_critically_damped
      exponential_term = Math.exp(-@angular_frequency * @delta_time)
      time_exponential = @delta_time * exponential_term
      time_exponential_frequency = time_exponential * @angular_frequency

      @position_position_coefficient = time_exponential_frequency + exponential_term
      @position_velocity_coefficient = time_exponential

      @velocity_position_coefficient = -@angular_frequency * time_exponential_frequency
      @velocity_velocity_coefficient = -time_exponential_frequency + exponential_term
    end
  end
end
