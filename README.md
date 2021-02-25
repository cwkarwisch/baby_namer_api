# Baby Namer API

Baby Namer API acts as the backend for a React application that provides historical data on the popularity of baby names in the United States since 1880. The underlying data source is a set of CSV files made available by the Social Security Administration, which have been parsed and stored in a PostgreSQL database.

# Setup

1. Clone the repo: `git clone https://github.com/cwkarwisch/baby_namer_api.git`
1. Use bundler to install necessary gems: `bundle install`
1. Run `rails db:migrate` to setup the database schema and prepare the database for importing the names from the csv files
1. To populate the database, run the following rake task: `bundle exec rake csv:download_and_import_names`
    - The rake task will download the csv files from https://www.ssa.gov/oact/babynames/names.zip, extract and parse each csv file, populate the `names` table in the database, and delete the csv files

# API

The API exposes a single endpoint `/names` for accessing the names data, but that data can be filtered in a number of ways through query parameters. Data on the names will be returned as an array of JSON objects. If no names match the query parameters passed in through the URL, an empty array will be returned.

## Filter by Historical Popularity of a Single Name

If, for example, the frontend would like to see the historical popularity of the name Camille for females, the frontend should make a request to `/names?name=Camille&sex=F`.

## Filter by Year

To see name data for a specific year, use the format `/names?year=1987`, which would return the top 1000 female and male names for 1987.

## Filter by Year Range

To see data for a range of years, use query parameters for `yearStart` and `yearEnd` such as `/names?yearStart=1880&yearEnd=1885`, which will return name data for the top 1000 female and male names for the years 1880-1885 (inclusive.) If `yearStart` is included as a query parameter but `yearEnd` is not, the API will only return data for the year specified by `yearStart`. Similarly, if `yearEnd` is included without a value for `yearStart`, the API will return data for the year indicated by `yearEnd`.

## Filter by Popularity

To see data on the most popular names for a given period, use a query parameter for `popularity` such as `/names?popularity=10&yearStart=1960&yearEnd=1969`, which will return name data on the 10 most popular names for both females and males between the years 1960 and 1969.

## Filter by Sex

To see data filtered by sex, a query parameter for `sex` must be provided such as `/names?sex=M&popularity=25&year=2019`, which will return data on the 25 most popular male names for 2019.

# Tests

To run the test suite, simply run `rails tests`.
