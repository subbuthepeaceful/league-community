# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Program Breadcrumb
  def program_breadcrumb(program)
    breadcrumb = link_to "Programs", admin_programs_path
    breadcrumb << " > "
    breadcrumb << "#{program.name}"
    breadcrumb
  end
  
  # Program Session Breadcrumb
  def program_session_breadcrumb(program, session)
    breadcrumb = link_to "Programs", admin_programs_path
    breadcrumb << " > "

    program_link = link_to program.name, admin_program_path(program) 

    breadcrumb << program_link
    breadcrumb << " > "
    
    breadcrumb << "#{session.name}"
    breadcrumb
  end
  
  # Team Breadcrumb
  def team_breadcrumb(program, session, division)
    breadcrumb = link_to "Programs", admin_programs_path
    breadcrumb << " > "
    
    program_link = link_to program.name, admin_program_path(program) 

    breadcrumb << program_link
    breadcrumb << " > "
    session_link = link_to session.name, admin_program_session_path(program, session)
    breadcrumb << " #{session_link}"
    breadcrumb << " > "
    division_link = link_to division.name,admin_program_session_division_path(program, session, division)
    breadcrumb << division_link
    breadcrumb  
  end
  
  # Helper function to print phones
  def print_phones(contact)
    phones = ""
    contact.phones.each do |phone|
      if phone.phone_number
        phones << phone_format(phone.phone_number)
      else
        phones << "N/A"
      end
    end
    phones
  end

  def picture_tag(photo)
    photo_link = image_tag(photo.image_url, :height => 400)
    link_to_function(image_tag(photo.image_thumb_url),"showPhotoDialog('#{photo_link}', '#{photo.title}')")
  end

  def random_sponsor_banner1(default_image)
    if @sponsors_enabled
      sponsor = Sponsor.select_random
      sponsor_banner1(sponsor, default_image)
    end
  end

  def sponsor_banner1(sponsor, default_image=nil, width = 300)
    if sponsor
      if (sponsor.banner1? || default_image.nil?)
        link_to(image_tag(sponsor.banner1.url(:medium), :width=> width, :alt=>sponsor.company_name, :title=>sponsor.company_name), sponsor.company_website, :target => 'blank')
      else
        link_to(image_tag(default_image, :width=> width, :alt=>sponsor.company_name, :title=>sponsor.company_name), sponsor.company_website, :target => 'blank')
      end
    elsif default_image
      image_tag(default_image,  :width=> width)
    else
      nil
    end
  end
  
  def singular_circle(circle_name)
    circle_name.split(" ")[1].singularize
  end
  
  def default_roster_photo(program)
    if @hub.has_multiple_programs?
      return "/images/hubs/programs/#{program.id}/user-default-photo-thumb.jpg"
    else
      return "/images/hubs/programs/#{@hub.url_prefix}/user-default-photo-thumb.jpg"
    end
  end
  
  private
  def phone_format(phone_number)
    #plain_number = phone_number.gsub(/[ ]*/,'')
    #formatted_phone_number = "(#{plain_number[0..2]}) #{plain_number[3..5]}-#{plain_number[6..9]}"
    #formatted_phone_number
    formatted_phone_number = phone_number
  end
end
