# == Schema Information
#
# Table name: ds_modules
#
#  id                            :integer         not null, primary key
#  user_id                       :integer
#  name                          :string(255)
#  version                       :string(255)
#  documentation                 :text
#  example                       :text
#  files                         :text
#  created_at                    :datetime
#  updated_at                    :datetime
#  ds_attachment_file_name       :string(255)
#  ds_attachment_content_type    :string(255)
#  ds_attachment_file_size       :integer
#  ds_attachment_updated_at      :datetime
#  category                      :string(255)
#  ds_attachment_last_updated_at :datetime
#


# N.B. You MUST call "setup" after creating this object

require 'set'

class DsModule < ActiveRecord::Base
  attr_accessible :name, :version, :documentation, :example, :category, :files, :ds_attachment, :ds_attachment_last_updated_at, :tag_list

  has_many :module_files, :dependent => :destroy

  has_attached_file :ds_attachment

  acts_as_taggable

  belongs_to :user

  validates :name, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true
  validates :version, :presence => true, :length => { :maximum => 140 }
  validates :documentation, :presence => true
  # the requirement for an example should be chosen based on Category (tag)
  #validates :example, :presence => true
  # category is now :tag_list
  #validates :category, :presence => true, :length => { :maximum => 200 }

  validates :tag_list, :presence => true

  #validates :files, :presence => true
  validates_attachment_presence :ds_attachment

  validate :has_valid_example

  validate :should_reload_attachment
  
  # I can't do this because parent must be saved before I 
  # save child objects
  #validate :parse_attachment

  default_scope :order => 'ds_modules.created_at DESC'

  # this calls the methods that can only be calle after the object has been created
  def setup
    parse_attachment
  end

  def should_reload_attachment
    if self.ds_attachment_last_updated_at != self.ds_attachment_updated_at
      @reload_attachment = true
    end

    self.ds_attachment_last_updated_at = self.ds_attachment_updated_at
    
    return true
  end

  def has_valid_example
    if is_example?
      return true
    end

    unless self.example.blank?
      return true
    end

    errors.add("Example", "is required.")
    return false
  end

  def parse_attachment
    if attachment_is_ds_file?
      module_files.create(:path => ds_attachment.path)
      return true
    end

    unless attachment_is_zip?
      return false
    end

    unless @reload_attachment
      return true
    end
    
    new_dir = File.dirname(ds_attachment.path) + "/" + get_unique_directory

    # -j flag flattens zip so only the files get unzipped (not the dir structure)
    `unzip -j '#{ds_attachment.path}' -d #{new_dir}`

    files = `ls #{new_dir}`.chomp().split("\n")

    files.each do |file|
      full_path = new_dir + "/" + file      
      self.module_files.create(:path => full_path)
    end

    return true
  end

  def attachment_is_ds_file?
    File.extname(ds_attachment.path) == ".ds"
  end

  def attachment_is_zip?
    File.extname(ds_attachment.path) == ".zip"
  end

  def get_categories
    self.tag_list
  end

  def is_example?
    self.tag_list.find_index("Example") != nil
  end

  def is_library?
    self.tag_list.find_index("Library") != nil
  end

  def get_images
    images = []
    module_files.each do |file|
      if file.is_image?
        images.push(file)
      end
    end
    return images
  end

  def get_images_markdown
    images = get_images
    str = "";

    images.each do |image|
      desc = image.base
      path = image.path.gsub(Rails.root.to_s + "/public", "")
      str += "\n![#{desc}](#{path})"
    end

    return str
  end

  def get_scripts
    scripts = []
    module_files.each do |file|
      if file.is_script?
        scripts.push(file)
      end
    end
    return scripts
  end

  def get_scripts_web_path
    scripts = get_scripts
    scripts_web_path = []
    
    scripts.each do |script|
      scripts_web_path.push(script.path.gsub(Rails.root.to_s + "/public", ""))
    end
    
    return scripts_web_path
  end


  def self.search(search)
    if search
      results = []
      # mit space search example
      # (^mit\s+|\s+mit\s+|\s+mit$|^mit$)
      space_reg = Regexp.new('(^' + search + '\s+|\s+' + 
          search + '\s+|\s+' + search + '$|^' + search + '$)', Regexp::IGNORECASE)
      subword_reg = Regexp.new(search);

      search_using space_reg, results
      search_using subword_reg, results

      return results
    else
      find(:all)
    end
  end

  private

  def get_unique_directory
    ('a'..'z').to_a.shuffle[0...10].join
  end

  def self.search_using(regex, results)
      # search for the string inside of words, but keep these results below the whole word results
      DsModule.all.each do |dsm|
        if regex.match(dsm.name) || regex.match(dsm.example) || regex.match(dsm.documentation) 
          results.push(dsm) unless results.include?(dsm)
        end

        dsm.tag_list.each do |tag|
          if regex.match(tag)
            results.push(dsm) unless results.include?(dsm)
          end
        end
          
        dsm.get_scripts.each do |script|
          IO.readlines(script.path).each do |line|
            if regex.match(line)
              results.push(dsm) unless results.include?(dsm)
            end
          end
        end
        
      end # DSModule.each
  end

end
