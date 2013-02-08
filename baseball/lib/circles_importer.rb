module CirclesImporter
  
  IMPORTABLE_PARTICIPANT_COLUMNS = ["name", "first_name", "last_name", "date_of_birth", "gender", "school", "t_shirt_size", "special_request" ]
  IMPORTABLE_PRIMARY_CONTACT_COLUMNS = [ "primary_contact_first_name", "primary_contact_last_name", "primary_contact_street_address", "primary_contact_city", 
                                         "primary_contact_state", "primary_contact_zip_code", "primary_contact_phone", "primary_contact_email" ]
  IMPORTABLE_SECONDARY_CONTACT_COLUMNS = [ "secondary_contact_first_name", "secondary_contact_last_name", "secondary_contact_street_address", "secondary_contact_city", 
                                        "secondary_contact_state", "secondary_contact_zip_code", "secondary_contact_phone", "secondary_contact_email" ]
                                        
  IMPORTABLE_COLUMNS = (IMPORTABLE_PARTICIPANT_COLUMNS + IMPORTABLE_PRIMARY_CONTACT_COLUMNS + IMPORTABLE_SECONDARY_CONTACT_COLUMNS).flatten
                                       
  # Think about this as having Import adapters from various registration systems
  # Participant Import first
  # Contact Import second 
  
  
  def parse_participant_import(csv_file, options, program, session, division)
    
    # This was initially designed to have a previewable import of participants
    # We are bypassing this step and going directly to import
    
    csv_data = FasterCSV.parse(csv_file.read)
    column_indices = map_importable_columns(csv_data[0])
    importable_participants = Array.new
    csv_data[1..csv_data.size-1].each do |csv_data_row|
      importable_participant = Hash.new
      IMPORTABLE_COLUMNS.each_with_index do |column_name, i|
        importable_participant[column_name.to_sym] = csv_data_row[column_indices[i]]
      end
      unless importable_participant[:name].blank?
        unless program.blank?
          importable_participant[:program] = program
        end
        unless session.blank?
          importable_participant[:session] = session
        end
        unless division.blank?
          importable_participant[:division] = division
        end
        importable_participants << importable_participant
        if options == "load"
          imported_participant = Participant.create_from_confirm_import(@hub, importable_participant)
        end
      end
    end
    importable_participants  
  end
  
  def parse_and_load_participant_import(csv_file, program, session, division)
    parse_participant_import(csv_file, "load", program, session, division)
  end
  
  def map_importable_columns(first_row)
    column_indices = Array.new
    IMPORTABLE_COLUMNS.each do |column_name|
      column_index = first_row.index(column_name)
      if column_index
        column_indices << column_index
      else
        raise "Cannot find Column for #{column_name}"
      end
    end
    puts "#{column_indices.join(',')}"
    column_indices
  end
end