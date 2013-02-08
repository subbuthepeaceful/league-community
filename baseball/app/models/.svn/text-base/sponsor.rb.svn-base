class Sponsor < ActiveRecord::Base
  belongs_to :hub
  has_many :sponsorships, :dependent => :destroy
  has_many :sponsored_options
  
  attr_accessor :sponsorable_name_1, 
                :sponsorable_name_2, 
                :sponsorable_name_3, 
                :sponsorable_division_1, 
                :sponsorable_division_2, 
                :sponsorable_division_3, 
                :sponsorable_addtl_info_1, 
                :sponsorable_addtl_info_2, 
                :sponsorable_addtl_info_3

  has_attached_file :banner1,
                    :styles => { :medium => ["300x100>", :png], :list => ["250x83", :png], :thumb => ["60x20>", :png] }
                    #:storage => :s3,
                    #:s3_credentials => "#{RAILS_ROOT}/config/amazon_s3.yml"

  has_attached_file :banner2,
                    :styles => { :medium => ["250x250>", :png], :thumb => ["50x50>", :png] }
                    #:storage => :s3,
                    #:s3_credentials => "#{RAILS_ROOT}/config/amazon_s3.yml"

  validates_presence_of :company_name, :contact_name, :contact_phone, :contact_email 

  # Instance methods
  def default_sponsored_option
    sponsored_options[0]
  end
  
  def save_with_sponsored_options(params)
    begin
      self.save!
    rescue ActiveRecord::RecordInvalid
      return self
    end
    
    sponsored_option = SponsoredOption.new
    sponsored_option.sponsor = self
  
    # Determine amount
    sponsorship_option = SponsorshipOption.find(params[:sponsorship_option])
    sponsored_option.sponsorship_option_id = sponsorship_option.id
  
    unless sponsorship_option.amount.blank?
      sponsored_option.amount = sponsorship_option.amount.gsub(/\$/, '').to_i
    else
      sponsored_option.amount = params[:sponsor_variable_amount].gsub(/\$/,'').to_i
    end
  
    # Extra Details
    sponsored_option.additional_info = ""
    unless params[:sponsor][:sponsorable_name_1].blank?
      sponsored_option.additional_info += "1:" + params[:sponsor][:sponsorable_name_1] + "/" + params[:sponsor][:sponsorable_division_1] + "/" + params[:sponsor][:sponsorable_addtl_info_1]
    end
    unless params[:sponsor][:sponsorable_name_2].blank?
      sponsored_option.additional_info += "2:" + params[:sponsor][:sponsorable_name_2] + "/" + params[:sponsor][:sponsorable_division_2] + "/" + params[:sponsor][:sponsorable_addtl_info_2]
    end
    unless params[:sponsor][:sponsorable_name_3].blank?
      sponsored_option.additional_info += "3:" + params[:sponsor][:sponsorable_name_3] + "/" + params[:sponsor][:sponsorable_division_3] + "/" + params[:sponsor][:sponsorable_addtl_info_3]
    end
  
    sponsored_option.save!
    self
  end

  def self.select_random
    Sponsor.find(:first, :order => 'rand()')
  end

end