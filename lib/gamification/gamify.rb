module Gamification
  module Gamify
    extend ActiveSupport::Concern

    included do
      class_eval do
        # points
        has_many :achievements
      end
    end

    module ClassMethods

      def gamify
        include Achievements
        include Gamify::InstanceMethods
      end

    end

    module InstanceMethods

      def include?(*args)
        options = args.extract_options!
        self.class.exists?(conditions: { _type: args.first.to_s }.merge(options))
      end

      def has_achievement?(*args)
        options = args.extract_options!
        conditions = {_type: args.first.to_s, user_id: id}
        conditions[:level] = options[:level] if options[:level]
        achievements.where(conditions).present?
      end

      def award_achievement(*args)
        options = args.extract_options!
        options[:points] = 0

        achievement = args.first
        o = achievement.new(options)
        o.user = self
        # o.points += options[:points]
        o.save!
      end

      def badges
        uniq_achievements.values
      end

      def badges_in_progress
        self.uniq_achievements.values.map do |achievement|
          {
            object:           achievement,
            progress:         achievement.class.progress_to_next_level(self),
            next_level_quota: achievement.class.next_level_quota(self),
            current_progress: achievement.class.current_progress(self),
            next_level:       achievement.class.next_level(self)
          }
        end.sort_by {|achievement| achievement[:progress]}.reverse[0,3]
      end

    private

      def uniq_achievements
        res = {}
        self.achievements.map {|a|
          next if res[a._type].level > a.level unless res[a._type].nil?
          res[a._type] = a
        }

        return res
      end

    end

  end
end