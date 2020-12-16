class Store < ApplicationRecord

  has_many :scripts

  after_create :add_scripts

  def add_scripts
    scripts.create(name: 'Main Script', pages: 'All', location: 'Head', status: false)
    scripts.create(name: 'Conversion Pixel', pages: 'CheckOut', location: 'Footer', status: false)
    scripts.create(name: 'Add to Cart', pages: 'Store Front', location: 'Footer', status: false)
  end
end
