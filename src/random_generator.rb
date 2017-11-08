require 'csv'
require 'faker'
require 'uuid'
require_relative 'address'
require_relative 'constituent'
require_relative 'gift'

class RandomGenerator
  attr_reader :available_addresses, :available_cons_ids

  STARBUCKS_CSV_FILE_LOCATION = './../starbucks_data/All_Starbucks_locations_in_the_World.csv'
  EXPORTED_CSV_DIR = './../constituent_data/exported/'

  CAMPAIGN_IDS = [1081]

  BASIC_LEVEL_IDS = [1166, 1170]

  RECURRING_LEVEL_IDS = [1170]

  VALID_CITIES = ['Austin', 'Dallas', 'San Antonio', 'Los Angeles', 'New York', 'San Francisco', 'Chicago', 'Boston',
                  'Miami', 'Charleston', 'Denver', 'Seattle', 'Portland', 'St. Louis', 'Indianapolis', 'Detroit',
                  'Minneapolis', 'Phoenix', 'Santa Fe', 'Salt Lake City', 'Houston', 'Atlanta', 'New Orleans',
                  'Nashville', 'Washington', 'Las Vegas', 'Newark', 'Charlotte', 'Philadelphia', 'Spokane', 'San Diego',
                  'Baltimore', 'Orlando', 'Pittsburgh', 'Cincinnati', 'Cleveland', 'Milwaukee', 'Oklahoma City',
                  'Louisville', 'Richmond', 'Birmingham']

  def initialize
    @available_addresses = get_some_starbucks_addresses
    @available_cons_ids = get_exported_cons_ids
  end

  def recurring_gift
    gift = Gift.new
    gift.cons_id = random_cons_id
    gift.address = address
    gift.campaign_id = random_campaign_id
    gift.tender_type = 'Credit Card'
    gift.tender_instance = 'Visa'
    gift.card_number = '************1111'
    gift.card_exp_date = (Date.today + 365).strftime('%m/%Y')
    random_date = random_gift_date
    gift.gift_date = random_date.strftime('%Y/%m/%d')
    gift.value = random_gift_amount
    gift.donation_level_id = random_recurring_level_id
    gift.duration = rand(2..8)
    gift.frequency = 'monthly'
    gift.next_payment_date = (random_date + 30).strftime('%Y/%m/%d')

    gift
  end

  def gift
    gift = Gift.new
    gift.cons_id = random_cons_id
    gift.address = address
    gift.campaign_id = random_campaign_id
    gift.donation_level_id = random_basic_level_id
    gift.tender_type = 'Credit Card'
    gift.tender_instance = 'Visa'
    gift.card_number = '************1111'
    gift.card_exp_date = (Date.today + 365).strftime('%m/%Y')
    gift.gift_date = random_gift_date.strftime('%Y/%m/%d %H:%M')
    gift.value = random_gift_amount

    gift
  end

  def constituent
    constituent = Constituent.new
    constituent.address = address
    constituent.first_name = Faker::Name.first_name
    constituent.last_name = Faker::Name.last_name
    constituent.email = Faker::Internet.email(constituent.first_name[0] + constituent.last_name)
    constituent.gender = random_gender
    constituent
  end

  def address
    items = @available_addresses.size
    starbucks_address = @available_addresses[rand(0..items - 1)]
    address = Address.new
    address.street1 = starbucks_address['street_1']
    address.street2 = starbucks_address['street_2']
    address.city = starbucks_address['city']
    address.zip = starbucks_address['postal_code']
    address.state = starbucks_address['country_subdivision']
    address
  end

  def uuid
    UUID.new.generate(:compact)[0..9].to_s
  end

  private
  def random_gift_date
    Date.today - rand(0..730)
  end

  def random_gift_amount
    rand(5..150)
  end

  def random_cons_id
    num_ids = @available_cons_ids.size
    @available_cons_ids[rand(0..num_ids - 1)]
  end

  def random_campaign_id
    num_ids = CAMPAIGN_IDS.size
    CAMPAIGN_IDS[rand(0..num_ids - 1)]
  end

  def random_basic_level_id
    num_ids = BASIC_LEVEL_IDS.size
    BASIC_LEVEL_IDS[rand(0..num_ids - 1)]
  end

  def random_recurring_level_id
    num_ids = RECURRING_LEVEL_IDS.size
    RECURRING_LEVEL_IDS[rand(0..num_ids - 1)]
  end

  def get_exported_cons_ids
    exported_files = Dir.entries(EXPORTED_CSV_DIR).select do |file|
      file != '.' && file != '..'
    end

    cons_ids = []
    exported_files.each do |file|
      csv = CSV::parse(File.open(EXPORTED_CSV_DIR + file, 'r') {|f| f.read })
      headers = csv.shift

      cons_ids += csv.collect do |record|
        row = CSV::Row.new(headers, record)
        row.field('CONS_ID')
      end
    end

    cons_ids
  end

  def get_some_starbucks_addresses
    csv = CSV::parse(File.open(STARBUCKS_CSV_FILE_LOCATION, 'r') {|f| f.read })
    fields = csv.shift
    fields = fields.map {|f| f.downcase.gsub(" ", "_")}
    list_of_rows = csv.collect { |record| Hash[*fields.zip(record).flatten ] }

    list_of_rows.select do |row|
      VALID_CITIES.include?(row['city'])
    end
  end

  def random_gender
    genders = [nil, 'Male', 'Female']
    genders[rand(0..2)]
  end
end









