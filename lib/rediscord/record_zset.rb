module Rediscord
  class RecordZset < RecordSet
    attr_reader :score

    def initialize(options)
      super
      @score = options[:score]
    end

    def score_for(record)
      score.call(record)
    end

    def after_create(record)
      redis.zadd(key_for(record), score_for(record), record.id)
    end

    def after_destroy(record)
      redis.zrem(key_for(record), record.id)
    end

    def after_update(record, prev_record)
      _key_was = key_for(prev_record)
      _key = key_for(record)

      _score = score_for(record)
      _score_was = score_for(prev_record)

      if force_update || _key_was != _key || _score != _score_was
        redis.zrem(_key_was, record.id)
        redis.zadd(_key, score_for(record), record.id)
      end
    end
  end
end
