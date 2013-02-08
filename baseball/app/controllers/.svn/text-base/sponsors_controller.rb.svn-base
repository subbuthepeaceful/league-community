class SponsorsController < ApplicationController
  before_filter :suppress_header
  
  def index
    redirect_to new_sponsor_path
  end
  
  def new
    get_sponsorship_options
  end
  
  def create
    # Form Validation
    # Create Sponsor Object
    @sponsor = Sponsor.new(params[:sponsor])
    debugger
    if params[:sponsorship_option].nil?
      flash[:error] = "Please select at least one sponsorship option"
      get_sponsorship_options
      render :action => "new"
    elsif !params[:sponsor_variable_amount].blank? 
      if params[:sponsor_variable_amount].gsub(/\$/,'').to_i == 0
        flash[:error] = "Please enter a valid $ amount for the sponsorship"
        get_sponsorship_options
        render :action => "new"
      else
        result = @sponsor.save_with_sponsored_options(params)
        if result && @sponsor.errors.empty?
          redirect_to review_sponsor_url(@sponsor)
        end
      end
    else
      sponsorship_option = SponsorshipOption.find(params[:sponsorship_option])
      if sponsorship_option && sponsorship_option.is_variable_amount?
        flash[:error] = "Please enter a valid $ amount for the sponsorship"
        get_sponsorship_options
        render :action => "new"
      else
        result = @sponsor.save_with_sponsored_options(params)
        if result && @sponsor.errors.empty?
          redirect_to review_sponsor_url(@sponsor)
        else
          get_sponsorship_options
          render :action => "new"
        end
      end
    end
  end
  
  def review
    @sponsor = Sponsor.find(params[:id])
    @sponsored_option = @sponsor.default_sponsored_option
    @sponsorship_option = SponsorshipOption.find(@sponsored_option.sponsorship_option_id)
    
    @generated_invoice_num = "#{@sponsor.id}-#{@sponsored_option.id}"
  end
  
  def thank_you
    
    # THIS PROCESS IS UNFORTUNATELY UNIQUE TO USA ePAY - NEED TO CONSIDER HOW TO MAKE THIS FLEXIBLE
    
    invoice_echo_back = params[:UMinvoice]
    sponsor_id = invoice_echo_back.split("-")[0]
    sponsored_option_id = invoice_echo_back.split("-")[1]
    
    @sponsor = Sponsor.find(sponsor_id)
    @sponsored_option = SponsoredOption.find(sponsored_option_id)
    @sponsorship_option = SponsorshipOption.find(@sponsored_option.sponsorship_option_id)
    
    @sponsored_option.update_with_payment_reference(params)
    
    # Send mail
    begin
      UserMailer.deliver_sponsorship_thank_you_notification(@hub, @sponsor, @sponsored_option, @sponsorship_option, @operating_domain)
      UserMailer.deliver_new_sponsorship_notification(@hub, @sponsor, @sponsored_option, @sponsorship_option, @operating_domain)
    rescue StandardError => e
      #Some rescue action
    end
    
  end
  
  def payment
  end
  
  protected
  def suppress_header
    @suppress_header = true
  end
  
  def get_sponsorship_options
    @primary_options = SponsorshipOption.primary_options(@hub)
    @other_options = SponsorshipOption.other_options(@hub)
  end    
  
end