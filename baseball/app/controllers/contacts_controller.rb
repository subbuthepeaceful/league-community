class ContactsController < ApplicationController
  before_filter :login_required, :set_contact
  
  def index
  end
  
  def show
    if @enable_tabs
      redirect_to @enable_tabs[0][:url]
    end
  end
end