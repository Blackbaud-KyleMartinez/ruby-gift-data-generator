require_relative 'csv_helper'

@csv_builder = CsvBuilder.new

def create_constituent_uploads
  @csv_builder.create_constituent_csv "constituent_upload1.csv", 100000
  @csv_builder.create_constituent_csv "constituent_upload2.csv", 100000
  @csv_builder.create_constituent_csv "constituent_upload3.csv", 100000
end

def create_gift_uploads
  @csv_builder.create_gift_csv "gift_upload1.csv", 100000
  @csv_builder.create_gift_csv "gift_upload2.csv", 100000
  @csv_builder.create_gift_csv "gift_upload3.csv", 100000
  @csv_builder.create_gift_csv "gift_upload4.csv", 100000
  @csv_builder.create_gift_csv "gift_upload5.csv", 100000
end



#create_constituent_uploads
create_gift_uploads

