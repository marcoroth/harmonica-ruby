# frozen_string_literal: true

require_relative "test_helper"

module Harmonica
  class VectorTest < Minitest::Spec
    it "initializes with x, y, z components" do
      vector = Vector.new(1.0, 2.0, 3.0)

      assert_equal 1.0, vector.x
      assert_equal 2.0, vector.y
      assert_equal 3.0, vector.z
    end

    it "defaults to zero vector" do
      vector = Vector.new

      assert_equal 0.0, vector.x
      assert_equal 0.0, vector.y
      assert_equal 0.0, vector.z
    end

    it "adds two vectors" do
      vector1 = Vector.new(1.0, 2.0, 3.0)
      vector2 = Vector.new(4.0, 5.0, 6.0)
      result = vector1 + vector2

      assert_equal 5.0, result.x
      assert_equal 7.0, result.y
      assert_equal 9.0, result.z
    end

    it "subtracts two vectors" do
      vector1 = Vector.new(4.0, 5.0, 6.0)
      vector2 = Vector.new(1.0, 2.0, 3.0)
      result = vector1 - vector2

      assert_equal 3.0, result.x
      assert_equal 3.0, result.y
      assert_equal 3.0, result.z
    end

    it "multiplies by scalar" do
      vector = Vector.new(1.0, 2.0, 3.0)
      result = vector * 2.0

      assert_equal 2.0, result.x
      assert_equal 4.0, result.y
      assert_equal 6.0, result.z
    end

    it "calculates magnitude" do
      vector = Vector.new(3.0, 4.0, 0.0)

      assert_in_delta 5.0, vector.magnitude, 0.0001
    end

    it "normalizes to unit vector" do
      vector = Vector.new(3.0, 4.0, 0.0)
      normalized = vector.normalize

      assert_in_delta 0.6, normalized.x, 0.0001
      assert_in_delta 0.8, normalized.y, 0.0001
      assert_in_delta 0.0, normalized.z, 0.0001
      assert_in_delta 1.0, normalized.magnitude, 0.0001
    end

    it "normalizes zero vector to zero vector" do
      vector = Vector.new(0, 0, 0)
      normalized = vector.normalize

      assert_equal 0.0, normalized.x
      assert_equal 0.0, normalized.y
      assert_equal 0.0, normalized.z
    end

    it "converts to string representation" do
      vector = Vector.new(1.0, 2.0, 3.0)

      assert_equal "Vector(1.0, 2.0, 3.0)", vector.to_s
    end

    it "compares equality by components" do
      vector1 = Vector.new(1.0, 2.0, 3.0)
      vector2 = Vector.new(1.0, 2.0, 3.0)
      vector3 = Vector.new(1.0, 2.0, 4.0)

      assert_equal vector1, vector2
      refute_equal vector1, vector3
    end
  end
end
