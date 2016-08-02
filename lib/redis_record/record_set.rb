module RedisRecord
  class RecordSet
    attr_reader :key, :redis, :force_update

    def initialize(options)
      @key = options[:key]
      @redis = options[:redis] || REDIS
    end

    def key_for(record)
      key.call(record)
    end

    def after_create(record)
      redis.sadd(key_for(record), record.id)
    end

    def after_destroy(record)
      redis.srem(key_for(record), record.id)
    end

    def after_update(record, prev_record)
      _key_was = key_for(prev_record)
      _key = key_for(prev_record)
      if force_update || _key_was != _key
        redis.srem(_key_was, record.id)
        redis.sadd(_key, record.id)
      end
    end
  end
end
