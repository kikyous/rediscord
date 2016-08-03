require 'minitest/autorun'
require 'rediscord'
require 'config'

class RedisRecordTest < Minitest::Test
  def setup
    Post.levels.each do |k, v|
      REDIS.del "level_#{k}_post_set"
      REDIS.del "level_#{k}_post_zset"
    end
    Post.destroy_all
  end

  def test_update
    Post.create(level: :one)
    post = Post.create(level: :one)
    Post.create(level: :two)
    Post.create(level: :there)
    assert_equal REDIS.scard('level_one_post_set'), 2
    assert_equal REDIS.zcard('level_one_post_zset'), 2

    post.update(level: :two)
    assert_equal REDIS.scard('level_one_post_set'), 1
    assert_equal REDIS.zcard('level_one_post_zset'), 1

    assert_equal REDIS.scard('level_two_post_set'), 2
    assert_equal REDIS.zcard('level_two_post_zset'), 2

    assert_equal REDIS.zscore('level_two_post_zset', post.id.to_s), post.updated_at.to_i

    post.destroy
    assert_equal REDIS.scard('level_two_post_set'), 1
    assert_equal REDIS.zcard('level_two_post_zset'), 1
  end
end
