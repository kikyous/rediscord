require 'active_support/concern'
require 'rediscord/record_set'
require 'rediscord/record_zset'

module Rediscord
  extend ActiveSupport::Concern
  class_methods do
    attr_reader :force_update, :record_sets
    def init_sets
      unless @record_sets
        @record_sets = []

        after_create :_update_ids_after_create
        after_update :_update_ids_after_update
        after_destroy :_update_ids_after_destroy
      end
    end

    def redis_zset(options)
      init_sets
      @record_sets << RecordZset.new(options)
    end

    def redis_set(options)
      init_sets
      @record_sets << RecordSet.new(options)
    end

    def redis_refresh
      @force_update = true
      find_each do |m|
        m.save
      end
    end
    def previous_model(obj)
      prev = obj.dup
      obj.changed_attributes.each do |key, value|
        prev.send("#{key}=", value)
      end
      prev
    end
  end

  def _update_ids_after_create
    self.class.record_sets.each do |s|
      s.after_create(self)
    end
  end

  def _update_ids_after_destroy
    self.class.record_sets.each do |s|
      s.after_destroy(self)
    end
  end

  def _update_ids_after_update
    prev_record = self.class.previous_model(self)
    self.class.record_sets.each do |s|
      s.after_update(self, prev_record)
    end
  end
end
