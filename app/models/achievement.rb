class Achievement
  include Mongoid::Document
  include Mongoid::Timestamps

  field :level,         type: Integer
  field :points,        type: Integer,  default: 0
  field :image,         type: String,   default: nil
  field :notified,      type: Boolean,  default: false

  scope :recent,        desc(:created_at)
  scope :not_notified,  where(notified: false)

  belongs_to :user

  validates :user,    presence: true
  validates :level,   presence: true
  validates :image,   presence: true
  validates :points,  numericality: true

  attr_accessible :level, :image, :notified

  def self.levels
    @levels ||= []
  end

  def self.level(*args)
    options = args.extract_options!
    levels << { level: args.first }.merge(options)
  end

  def self.set_thing_to_check(&block)
    @thing_to_check = block
  end

  def self.thing_to_check(object)
    @thing_to_check.call(object)
  end

  def self.select_level(level)
    levels.select { |l| l[:level] == level }.first
  end

  def self.quota_for(level)
    select_level(level)[:quota] if select_level(level)
  end

  def self.has_level?(level)
    select_level(level).present?
  end

  def self.current_level(user)
    current_achievement = user.achievements.where(_type: self.to_s).desc(:level).first ? current_achievement.level : 0
  end

  def self.next_level(user)
    current_level(user) + 1
  end

  def self.current_progress(user)
    thing_to_check(user).to_i
  end

  def self.next_level_quota(user)
    quota_for(next_level(user))
  end

  def self.progress_to_next_level(user)
    return [(current_progress(user) * 100) / next_level_quota(user), 95].min if (has_level?(next_level(user)))
    nil
  end
end