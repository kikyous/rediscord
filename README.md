# redis_record
keep record id sync with dynamic redis set or zset

## install

add `gem 'redis_record'` to Gemfile, and run `bundle install`

## Usage
* set
```ruby
class Post < ApplicationRecord
  enum level: [ :one, :two, :there ]

  include RedisRecord
  redis_set key: ->(m){ "level_#{m.level}_post_set" }
end
```
```ruby
Post.create(level: :one)   # id: 1
Post.create(level: :one)   # id: 2
Post.create(level: :two)   # id: 3
Post.create(level: :there) # id: 4
```
> post id will sync with redis set

![](http://ww1.sinaimg.cn/large/006tKfTcjw1f6gc1feycqj31hc0vsdix.jpg)

* zset

```ruby
class Post < ApplicationRecord
  enum level: [ :one, :two, :there ]

  include RedisRecord
  redis_zset key: ->(m){ "level_#{m.level}_post_zset" }, score: ->(m){ m.updated_at.to_i }
end
```
```ruby
Post.create(level: :one)
Post.create(level: :one)
Post.create(level: :two)
Post.create(level: :there)
```
![](http://ww1.sinaimg.cn/large/006tKfTcjw1f6gc6mmk9sj31hc0vsgov.jpg)
