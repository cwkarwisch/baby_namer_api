namespace :csv do

  desc "import names from csv files"
  task import_names: [:environment] do
    require 'csv'

    YEAR = 2019
    SEX = 'm'
    COUNTRY = 'U.S.A.'
    CSV_FILE_NAME = "yob#{YEAR}#{SEX}.txt"

    popularity = 1;

    CSV.foreach(Rails.root.join("lib/#{CSV_FILE_NAME}")) do |row|

      Name.create({
        name: row[0],
        sex: row[1],
        count: row[2].to_i,
        popularity: popularity,
        year: YEAR,
        country: COUNTRY
      })

      popularity += 1;
      break if popularity > 1000;
    end
  end


end
