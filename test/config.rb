require 'redis'
require 'sqlite3'
require 'active_record'

REDIS = Redis.new
db_file = File.join(File.dirname(__FILE__), 'test.sqlite3')

ActiveRecord::Base.establish_connection({
  :adapter  => 'sqlite3',
  :database => db_file
})

ActiveRecord::Schema.define do
  create_table :posts, force: true do |t|
    t.integer :level, default: 0
    t.timestamps
  end
end

class Post < ActiveRecord::Base
  enum level: [ :one, :two, :there ]

  include Rediscord

  redis_set key: ->(m){ "level_#{m.level}_post_set" }, redis: Redis.new
  redis_zset key: ->(m){ "level_#{m.level}_post_zset" }, score: ->(m){ m.updated_at.to_i }, redis: Redis.new
end
