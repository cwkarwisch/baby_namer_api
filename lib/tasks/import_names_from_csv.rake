namespace :csv do

  desc "import names from csv files"
  task import_names: [:environment] do
    require 'csv'

    COUNTRY = 'U.S.A.'
    INDICES = {
      name: 0,
      sex: 1,
      count: 2
    }
    NAME_CAP = 1000

    years = 1880..2019

    years.each do |year|
      csv_file_name = "yob#{year}.txt"
      popularity = 0
      sex_of_previous_row = 'F'

      names = []

      CSV.foreach(Rails.root.join("lib/baby_names/#{csv_file_name}")) do |row|

        if row[INDICES[:sex]] != sex_of_previous_row
          popularity = 1
        else
          popularity += 1;
        end

        if popularity <= NAME_CAP
          name_hash = {
            name: row[INDICES[:name]],
            sex: row[INDICES[:sex]],
            count: row[INDICES[:count]].to_i,
            popularity: popularity,
            year: year,
            country: COUNTRY,
            created_at: Time.now,
            updated_at: Time.now
          }
          names << name_hash
        end

        sex_of_previous_row = row[INDICES[:sex]]

        break if popularity > NAME_CAP && row[INDICES[:sex]] == 'M';
      end

      Name.insert_all(names)

    end
  end

  desc "download and extract names data"
  task download_names: [:environment] do
    system("curl https://www.ssa.gov/oact/babynames/names.zip -o #{Rails.root.join("lib/baby_names.zip")}")
    system("unzip #{Rails.root.join("lib/baby_names.zip")} -d #{Rails.root.join("lib/baby_names")}")
    system("rm #{Rails.root.join("lib/baby_names.zip")}")
  end

  desc "download and import name data"
  task download_and_import_names: [:environment] do
    Rake::Task["csv:download_names"].execute
    Rake::Task["csv:import_names"].execute
    system("rm -r #{Rails.root.join("lib/baby_names")}")
  end
end
