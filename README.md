<div align="center">
  <h1>Harmonica for Ruby</h1>
  <h4>A simple, physics-based animation library for Ruby.</h4>

  <p>
    <a href="https://rubygems.org/gems/harmonica"><img alt="Gem Version" src="https://img.shields.io/gem/v/harmonica"></a>
    <a href="https://github.com/marcoroth/harmonica-ruby/blob/main/LICENSE.txt"><img alt="License" src="https://img.shields.io/github/license/marcoroth/harmonica-ruby"></a>
  </p>

  <p>Ruby implementation of <a href="https://github.com/charmbracelet/harmonica">charmbracelet/harmonica</a>.<br/>A simple, efficient spring animation library for smooth, natural motion.</p>
</div>

## Installation

**Add to your Gemfile:**

```ruby
gem "harmonica"
```

**Or install directly:**

```bash
gem install harmonica
```

## Components

| Component | Description |
|-----------|-------------|
| [Spring](#spring) | Damped harmonic oscillator for smooth UI animations |
| [Projectile](#projectile) | Physics projectile motion for particles |
| [Point](#point) | 3D point coordinates |
| [Vector](#vector) | 3D vector with magnitude and direction |

## Usage

### Spring

Spring provides smooth, realistic motion using a damped harmonic oscillator. Perfect for UI animations like scroll positions, element transitions, and interactive feedback.

**Basic usage:**

```ruby
require "harmonica"

spring = Harmonica::Spring.new(
  delta_time: Harmonica.fps(60),   # 60 FPS
  angular_frequency: 6.0,          # Speed of motion
  damping_ratio: 0.5               # Smoothness
)

position = 0.0
velocity = 0.0
target = 100.0

loop do
  position, velocity = spring.update(position, velocity, target)

  break if (position - target).abs < 0.01
end
```

**Damping ratios:**

| Ratio | Behavior |
|-------|----------|
| `< 1.0` | Under-damped: oscillates before settling (bouncy) |
| `= 1.0` | Critically-damped: fastest without oscillation |
| `> 1.0` | Over-damped: slow approach, no oscillation |

**Example with Bubbletea:**

```ruby
class ScrollModel
  def initialize
    @scroll_position = 0.0
    @scroll_velocity = 0.0
    @target_scroll = 0.0

    @spring = Harmonica::Spring.new(
      delta_time: Harmonica.fps(60),
      angular_frequency: 5.0,
      damping_ratio: 0.8
    )
  end

  def update(message)
    case message
    when Bubbletea::KeyMessage
      @target_scroll += 10 if message.to_s == "down"
      @target_scroll -= 10 if message.to_s == "up"
    end

    @scroll_position, @scroll_velocity = @spring.update(
      @scroll_position,
      @scroll_velocity,
      @target_scroll
    )

    [self, nil]
  end
end
```

### Projectile

Projectile simulates physics motion with position, velocity, and acceleration. Great for particles, falling objects, and game physics.

#### Basic usage

```ruby
require "harmonica"

projectile = Harmonica::Projectile.new(
  delta_time: Harmonica.fps(60),
  position: Harmonica::Point.new(0, 100, 0),
  velocity: Harmonica::Vector.new(10, 20, 0),
  acceleration: Harmonica::GRAVITY
)

loop do
  position = projectile.update

  puts "Position: #{position.x}, #{position.y}"
  break if position.y <= 0
end
```

#### Gravity constants

```ruby
Harmonica::GRAVITY           # Vector(0, -9.81, 0) - origin at bottom-left
Harmonica::TERMINAL_GRAVITY  # Vector(0,  9.81, 0) - origin at top-left
```

#### Custom acceleration

**No gravity (space)**

```ruby
projectile = Harmonica::Projectile.new(
  delta_time: Harmonica.fps(60),
  position: Harmonica::Point.new(0, 0, 0),
  velocity: Harmonica::Vector.new(5, 5, 0),
  acceleration: Harmonica::Vector.new(0, 0, 0)
)
```

**Strong gravity**

```ruby
projectile = Harmonica::Projectile.new(
  delta_time: Harmonica.fps(60),
  position: Harmonica::Point.new(0, 100, 0),
  velocity: Harmonica::Vector.new(0, 0, 0),
  acceleration: Harmonica::Vector.new(0, -20, 0)
)
```

### Point

Point represents a position in 3D space.

```ruby
point = Harmonica::Point.new(10.0, 20.0, 30.0)

point.x  # => 10.0
point.y  # => 20.0
point.z  # => 30.0

point.to_a  # => [10.0, 20.0, 30.0]
```

### Vector

Vector represents direction and magnitude in 3D space.

```ruby
vector = Harmonica::Vector.new(3.0, 4.0, 0.0)

vector.magnitude   # => 5.0
vector.normalize   # => Vector(0.6, 0.8, 0.0)

v1 = Harmonica::Vector.new(1, 2, 3)
v2 = Harmonica::Vector.new(4, 5, 6)

v1 + v2   # => Vector(5, 7, 9)
v1 - v2   # => Vector(-3, -3, -3)
v1 * 2    # => Vector(2, 4, 6)
```

## Frame Rate Helper

Use `Harmonica.fps` to calculate the time delta for a given frame rate:

```ruby
Harmonica.fps(60)   # => 0.01666... (1/60 second)
Harmonica.fps(30)   # => 0.03333... (1/30 second)
Harmonica.fps(120)  # => 0.00833... (1/120 second)
```

## Complete Example

Animate a value from 0 to 100 with spring physics:

```ruby
require "harmonica"

spring = Harmonica::Spring.new(
  delta_time: Harmonica.fps(60),
  angular_frequency: 6.0,
  damping_ratio: 0.3  # bouncy
)

position = 0.0
velocity = 0.0
target = 100.0

60.times do |frame|
  position, velocity = spring.update(position, velocity, target)

  bar_length = (position / 2).to_i
  bar = "#" * bar_length

  puts "\r#{bar.ljust(50)} #{position.round(1)}"
  sleep(1.0 / 60)
end
```

## Development

**Requirements:**
- Ruby 3.2+

**Install dependencies:**

```bash
bundle install
```

**Run tests:**

```bash
bundle exec rake test
```

**Run demos:**

```bash
./demo/spring
./demo/damping
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/marcoroth/harmonica-ruby.

## License

The gem is available as open source under the terms of the MIT License.

## Acknowledgments

This gem is a Ruby implementation of [charmbracelet/harmonica](https://github.com/charmbracelet/harmonica), part of the excellent [Charm](https://charm.sh) ecosystem. The spring algorithm is based on Ryan Juckett's [damped springs](https://www.ryanjuckett.com/damped-springs/). Charm Ruby is not affiliated with or endorsed by Charmbracelet, Inc.

---

Part of [Charm Ruby](https://charm-ruby.dev).

<a href="https://charm-ruby.dev"><img alt="Charm Ruby" src="https://marcoroth.dev/images/heros/glamorous-christmas.png" width="400"></a>

[Lipgloss](https://github.com/marcoroth/lipgloss-ruby) • [Bubble Tea](https://github.com/marcoroth/bubbletea-ruby) • [Bubbles](https://github.com/marcoroth/bubbles-ruby) • [Glamour](https://github.com/marcoroth/glamour-ruby) • [Huh?](https://github.com/marcoroth/huh-ruby) • [Harmonica](https://github.com/marcoroth/harmonica-ruby) • [Bubblezone](https://github.com/marcoroth/bubblezone-ruby) • [Gum](https://github.com/marcoroth/gum-ruby) • [ntcharts](https://github.com/marcoroth/ntcharts-ruby)

The terminal doesn't have to be boring.
