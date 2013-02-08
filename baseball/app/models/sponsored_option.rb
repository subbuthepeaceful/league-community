class SponsoredOption < ActiveRecord::Base
  belongs_to :sponsor
  belongs_to :sponsorship_option
  
  def update_with_payment_reference(params)
    # FOR USA EPAY
    self.status = "Approved"
    self.payment_reference = "Auth:#{params[:UMauthCode]}/RefNum:#{params[:UMrefNum]}"
    self.save!
  end
end