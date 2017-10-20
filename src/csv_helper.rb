require 'csv'
require_relative 'random_generator'

class CsvBuilder
  attr_accessor :aRandom

  CONSTITUENT_DIR = './../constituent_data/'
  GIFT_DIR = './../gift_data/'

  CONSTITUENT_IMPORT_HEADERS = ['FIRST_NAME',
                                'LAST_NAME',
                                'PRIMARY_EMAIL',
                                'CONS_GENDER',
                                'HOME_STREET1',
                                'HOME_STREET2',
                                'HOME_CITY',
                                'HOME_STATEPROV',
                                'HOME_ZIP']

  RECURRING_GIFT_IMPORT_HEADERS = ['PROCESSOR_TRANSACTION_ID',
                                   'MERC_ACCT_ID',
                                   'PROCESSOR_REF_ID',
                                   'CONS_ID',
                                   'CAMPAIGN_ID',
                                   'DONATION_LEVEL_ID',
                                   'FREQUENCY',
                                   'DURATION',
                                   'GIFT_DATE',
                                   'VALUE_TRANSACTED',
                                   'TENDER_TYPE',
                                   'TENDER_INSTANCE',
                                   'BOWDLERIZED_CARD_NUMBER',
                                   'CARD_EXP_DATE',
                                   'NEXT_PAYMENT_DATE',
                                   'BILLING_STREET1',
                                   'BILLING_STREET2',
                                   'BILLING_CITY',
                                   'BILLING_STATE',
                                   'BILLING_ZIP']

  SINGLE_GIFT_IMPORT_HEADERS = ['OFFLINE_PAYMENT_METHOD',
                                'CONS_ID',
                                'LEVEL_ID',
                                'DONATION_DATE',
                                'DONATION_AMOUNT',
                                'CARD_TYPE',
                                'CARD_NUMBER',
                                'CARD_EXP_MONTH',
                                'CARD_EXP_YEAR',
                                'BILLING_STREET1',
                                'BILLING_STREET2',
                                'BILLING_CITY',
                                'BILLING_STATE',
                                'BILLING_ZIP']

  def initialize
    @aRandom = RandomGenerator.new
  end

  def create_constituent_csv(name, num_rows)
    CSV.open(CONSTITUENT_DIR + name, 'wb') do |csv|
      csv << CONSTITUENT_IMPORT_HEADERS
      num_rows.times do
        csv << constituent_row
      end
    end
  end

  def create_gift_csv(name, num_rows)
    recurring_gift_csv = CSV.open(GIFT_DIR + 'recurring_' + name, 'wb')
    recurring_gift_csv << RECURRING_GIFT_IMPORT_HEADERS

    gift_csv = CSV.open(GIFT_DIR + name, 'wb')
    gift_csv << SINGLE_GIFT_IMPORT_HEADERS

    num_rows.times do
      if rand(0..1) == 0
        gift_csv << gift_row
      else
        recurring_gift_csv << recurring_gift_row
      end
    end

    gift_csv.close
    recurring_gift_csv.close
  end

  private
  def gift_row
    gift = @aRandom.gift
    [
        'credit',
        gift.cons_id,
        gift.donation_level_id,
        gift.gift_date,
        gift.value,
        gift.tender_instance,
        gift.card_number,
        '10',
        '2020',
        gift.address.street1,
        gift.address.street2,
        gift.address.city,
        gift.address.state,
        gift.address.zip
    ]
  end

  def recurring_gift_row
    gift = @aRandom.recurring_gift
    [
        @aRandom.uuid,
        101,
        @aRandom.uuid,
        gift.cons_id,
        gift.campaign_id,
        gift.donation_level_id,
        gift.frequency,
        gift.duration,
        gift.gift_date,
        gift.value,
        gift.tender_type,
        gift.tender_instance,
        gift.card_number,
        gift.card_exp_date,
        gift.next_payment_date,
        gift.address.street1,
        gift.address.street2,
        gift.address.city,
        gift.address.state,
        gift.address.zip
    ]
  end

  def constituent_row
    constituent = @aRandom.constituent
    [
        constituent.first_name,
        constituent.last_name,
        constituent.email,
        constituent.gender,
        constituent.address.street1,
        constituent.address.street2,
        constituent.address.city,
        constituent.address.state,
        constituent.address.zip
    ]
  end
end