require 'spec_helper'

describe Qrcodeable do

  class BaseDummy
    include Qrcodeable::Core
  end

  class Product < BaseDummy
    attr_accessor :key
    qrcodeable
  end

  class User < BaseDummy
    attr_accessor :unique_key
    qrcodeable identifier: :unique_key
  end

  class Project < BaseDummy
    attr_accessor :key
    qrcodeable print_path: "qrcodes/export"
  end

  class AdminUser < BaseDummy
    attr_accessor :key, :expired_date
    qrcodeable expire_mode: true
  end

  class Customer < BaseDummy
    attr_accessor :key, :date_of_expired
    qrcodeable expire_mode: true, expire_column: :date_of_expired
  end
  
  before(:each) do
    @product_one = Product.new
    @product_one.key = "123456"

    @user = User.new
    @user.unique_key = "helloworld"

    @admin1 = AdminUser.new
    @admin1.expired_date = nil

    @admin2 = AdminUser.new
    @admin2.expired_date = (Time.now - 300)

    @admin3 = AdminUser.new
    @admin3.expired_date = (Time.now + 300)

    @customer1 = Customer.new
    @customer1.date_of_expired = (Time.now + 300)
    
  end


  it 'has a version number' do
    expect(Qrcodeable::VERSION).not_to be nil
  end

  it 'using key as an identifier' do
    expect(@product_one.key).to eq("123456")
  end

  it 'using custom identifier' do
    expect(@user.unique_key).to eq("helloworld")
  end

  it 'generate qrcode' do
    expect(@product_one.generate_qrcode.class.to_s).to eq("RQRCode::QRCode")
  end

  it 'print qrcode' do
    # path = @product_one.print_qrcode
    fail "not sure how to test calling Rails.root from here"
  end

  it 'generate qrcode path' do
    fail "not sure how to test calling Rails.root from here"
  end

  it 'generate qrcode path using custom setting' do
    fail "not sure how to test calling Rails.root from here"
  end

  it 'not expireable qrcode' do
    expect(@user.can_expire?).to eq(false)
  end

  it 'expireable qrcode' do
    expect(@admin1.can_expire?).to eq(true)
  end

  it 'expireable qrcode using default column' do
    expect(@admin2.expired_date.to_i).to eq((Time.now - 300).to_i)
  end

  it 'expireable qrcode using custom column' do
    expect(@customer1.date_of_expired.to_i).to eq((Time.now + 300).to_i)
  end

  it 'always return false for non expired qrcode' do
    expect(@product_one.qrcode_expired?).to eq(false)
  end

  it 'return false because unlimited expired_date' do
    expect(@admin1.qrcode_expired?).to eq(false)
  end

  it 'return false because expired_date is in the future date' do
    expect(@admin3.qrcode_expired?).to eq(false)
  end

  it 'return true because expired_date is in the past date' do
    expect(@admin2.qrcode_expired?).to eq(true)
  end

end
