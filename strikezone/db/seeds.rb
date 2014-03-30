# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# League
League.delete_all
lamvpb = League.create(name: 'Los Altos-Mountain View Pony Baseball', url: 'http://www.lamvpb.org')

# Divisions
Division.delete_all
pony = Division.create(name: 'Pony')
bronco = Division.create(name: 'Bronco')
mustang2 = Division.create(name: 'Mustang-2')
mustang1 = Division.create(name: 'Mustang-1')
pinto2 = Division.create(name: 'Pinto-2')

# Admin User
User.delete_all
user = User.create(first_name: 'League', 
                   last_name: 'Administrator', 
                   email: 'admin@lamvpb.org', 
                   password: 'ev1Plays', 
                   password_confirmation: 'ev1Plays',
                   superadmin: true)

