class Information
  Prefix = "information"
  attr_accessor:title

  def initialize(title="")
    @title = title
  end

  def self.page_info(key="default", lang = nil)
    setting = Setting.find_by_key( [key, Prefix, ( lang ? lang.abbreviation : "en")].join("_"))
    setting ? Information.new(setting.value) : nil
  end
end