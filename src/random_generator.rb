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

  CAMPAIGN_ID = 1990

  BASIC_LEVEL_ID = 8593

  RECURRING_LEVEL_ID = 8592

  def initialize
    @available_addresses = get_some_starbucks_addresses
    @available_cons_ids = get_exported_cons_ids
  end

  def recurring_gift
    gift = Gift.new
    gift.cons_id = random_cons_id
    gift.address = address
    gift.campaign_id = CAMPAIGN_ID
    gift.tender_type = 'Credit Card'
    gift.tender_instance = 'Visa'
    gift.card_number = '************1111'
    gift.card_exp_date = (Date.today + 365).strftime('%m/%Y')
    random_date = random_gift_date
    gift.gift_date = random_date.strftime('%Y/%m/%d')
    gift.value = random_gift_amount
    gift.donation_level_id = RECURRING_LEVEL_ID
    gift.duration = rand(2..8)
    gift.frequency = 'monthly'
    gift.next_payment_date = (random_date + 30).strftime('%Y/%m/%d')

    gift
  end

  def gift
    gift = Gift.new
    gift.cons_id = random_cons_id
    gift.address = address
    gift.campaign_id = CAMPAIGN_ID
    gift.donation_level_id = BASIC_LEVEL_ID
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
    constituent.email = Faker::Internet.email
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

  def get_exported_cons_ids
    exported_files = Dir.entries(EXPORTED_CSV_DIR).select do |file|
      file != '.' && file != '..'
    end

    cons_ids = []
    exported_files.each do |file|
      csv = CSV::parse(File.open(EXPORTED_CSV_DIR + file, 'r') {|f| f.read })
      csv.shift

      cons_ids += csv.collect do |record|
        record[0]
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
      row['city'] == 'Austin'||
          row['city'] == 'Dallas' ||
          row['city'] == 'San Antonio' ||
          row['city'] == 'Los Angeles' ||
          row['city'] == 'New York' ||
          row['city'] == 'San Francisco' ||
          row['city'] == 'Chicago' ||
          row['city'] == 'Boston' ||
          row['city'] == 'Miami' ||
          row['city'] == 'Charleston' ||
          row['city'] == 'Oakland'
    end
  end

  def random_gender
    genders = [nil, 'Male', 'Female']
    genders[rand(0..2)]
  end
end









