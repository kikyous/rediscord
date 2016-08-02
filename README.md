# redis_record
keep record id sync with dynamic redis set or zset

## install

add `gem 'redis_record'` to Gemfile, and run `bundle install`

## Usage

```ruby
class Post < ApplicationRecord
  enum level: [ :one, :two, :there ]

  include RedisRecord
  redis_set key: ->(m){ "#{m.level}_post_ids" }
end
```
```ruby
Post.create(level: :one)
Post.create(level: :one)
Post.create(level: :two)
Post.create(level: :there)
```
