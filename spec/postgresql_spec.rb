require 'spec_helper'
describe Upsert do
  version = Pet.connection.select_value("SHOW server_version")[0..2].split('.').join('').to_i

  let(:upsert) do
    Upsert.new($conn, :pets)
  end

  it "uses the native method if available (#{(UNIQUE_CONSTRAINT && version >= 95).inspect})" do
    Pet.create(:name => 'Jerry', :tag_number => 5)
    upsert.row({ :name => 'Jerry'}, :tag_number => 6 )
    expect(upsert.instance_variable_get(:@merge_function_cache).values.first.use_pg_native?).to(
      UNIQUE_CONSTRAINT && version >= 95 ? be_truthy : be_falsey
    )
  end

  context "When configured to always use the native method" do
    let(:upsert) do
      Upsert.new($conn, :pets, assume_native: true)
    end

    it "uses the native method" do
      Pet.create(:name => 'Jerry', :tag_number => 5)
      upsert.row({ :name => 'Jerry'}, :tag_number => 6 )
      expect(upsert.instance_variable_get(:@merge_function_cache).values.first.use_pg_native?).to be_truthy
    end
  end
end if ENV['DB'] == 'postgresql'
