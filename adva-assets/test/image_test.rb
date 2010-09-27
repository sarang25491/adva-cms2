require File.expand_path('../test_helper', __FILE__)

Asset.has_many_polymorphs :assetables, :through => :asset_assignments, :from => [:users, :posts]

require 'asset'
require 'image'
require 'carrierwave/test/matchers'

module AdvaAssets
  class ImageTest < Test::Unit::TestCase
    attr_reader :site, :file, :fixtures

    def setup
      super
      @site = Factory(:site)
      @fixtures = Pathname.new(File.expand_path('../fixtures', __FILE__))
      @file = fixtures.join('rails.png')
    end

    def create_image(options = {})
      Image.create(options.reverse_merge(:file => File.open(file), :site => site, :title => "title", :description => 'description'))
    end

    test "creates a valid image" do
      assert create_image.valid?
    end

    test "is not valid with a file w/ invalid file type" do
      file = fixtures.join('test.txt')
      image = create_image(:file => File.open(file))

      assert file.exist?
      assert !image.valid?
      assert_equal image.errors.first[1], "is not an allowed type of file."
    end

    # test "raises an exception for invalid images" do
    #   file = fixtures.join('test.txt.jpg')
    #   assert File.exists?(file)
    #   exception_raised = false
    #   begin
    #     create_image(:file => File.open(file))
    #   rescue
    #     exception_raised = true
    #   end
    #   assert exception_raised
    # end

    test "processes the size of image" do
      image = CarrierWave::Test::Matchers::ImageLoader.load_image(create_image.path)
      assert_equal [470, 600], [image.width, image.height]
    end

    test "processes the size of thumb" do
      image = CarrierWave::Test::Matchers::ImageLoader.load_image(create_image.thumb.path)
      assert_equal [64, 64], [image.width, image.height]
    end

    test "processes the size of small image" do
      image = CarrierWave::Test::Matchers::ImageLoader.load_image(create_image.small.path)
      assert_equal [200, 200], [image.width, image.height]
    end

    test "doesn't stretch medium image to default image size" do
      file = fixtures.join('rails_medium.png')
      image = create_image(:file => File.open(file))

      image = CarrierWave::Test::Matchers::ImageLoader.load_image(image.path)
      assert_equal [446, 316], [image.width, image.height]
    end
  end
end