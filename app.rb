require 'rubygems'
require 'active_record'
require 'sqlite3'
require 'rest-client'
require 'logger'

config_path = File.expand_path("../config.yml", __FILE__)
debug_path = File.expand_path("../debug.log", __FILE__)

ActiveRecord::Base.logger = Logger.new(debug_path)
$configuration = YAML::load(IO.read(config_path))
ActiveRecord::Base.establish_connection($configuration['development'])

class BoringImage < ActiveRecord::Base
  validates_uniqueness_of :img_src
  after_create :sendWeibo

  def info
    if self.size
      "#{self.width} * #{self.height} #{sizeFormat}"
    else
      ""
    end
  end

  def isBig?
    if self.height
      return true if self.height > 2000
    end
    false
  end

  def sizeFormat
    if self.size/1000000 == 0
      return "#{self.size/1000}KB"
    else
      return "#{self.size/1000000}MB"
    end
  end

  def sendWeibo
    sleep 5
    content = {
        location: "v6_content_home",
        appkey: "",
        style_type: "1",
        pic_id: pic_ids,
        text: acv_comment + "#{id}",
        pdetail: "",
        rank: "0",
        rankid: "",
        module: "stissue",
        pub_type: "dialog",
        _t: "",
        ajwvr: "6",
        __rnd: "#{(Time.now.to_f.round(3) * 1000).to_i}",
      }
    re = RestClient.post(
      "http://weibo.com/aj/mblog/add",
      content,
      $header
      )
    logger.info(re)
  end

  def self.fetch

    html = open("http://jandan.net").read
    doc = Nokogiri::HTML(html)

    doc.css('.hotcomment')[0].css('.acv_comment').each do |ac|
      width = 0
      height = 0
      size = 0
      pic_ids = ""

      img_src = ac.at_css('img')['src']
      img_src.gsub!('thumbnail', 'mw600')

      next if BoringImage.find_by_img_src(img_src)

      ac.css('img').each do |img|
        src = img['src']
        src.gsub!('thumbnail', 'large')
        src.gsub!('mw600', 'large')
        pic_id = src.split("/").last.split(".").first

        if pic_ids.length > 0
          pic_ids = pic_ids + ' ' + pic_id
        else
          pic_ids = pic_id
        end

        img = MiniMagick::Image.open(src)
        width = img[:width] > width ? img[:width] : width
        height = height + img[:height]
        size = size + img[:size]

      end

      BoringImage.create(
        img_src: img_src,
        acv_comment: ac.content.strip,
        pic_ids: pic_ids,
        width: width,
        height: height,
        size: size
        )

      p "new image!"
    end

  end

end