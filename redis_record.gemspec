Gem::Specification.new do |s|
  s.name        = 'redis_record'
  s.version     = '1.0.0'
  s.summary     = 'keep record id sync with redis set/zset'
  s.description = 'keep record id sync with dynamic redis set or zset'


  s.license = 'MIT'

  s.author   = 'kikyous'
  s.email    = 'kikyous@163.com'
  s.homepage = 'http://rubyonrails.org'

  s.files        = Dir['MIT-LICENSE', 'README.md', 'examples/**/*', 'lib/**/*']
  s.require_path = 'lib'

  s.extra_rdoc_files = %w(README.md)
end
