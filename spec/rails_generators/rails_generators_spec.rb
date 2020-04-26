require 'spec_helper'
require 'systemu'

# FIXME: this test might break the others if run before them
# started fixing @nbit001
describe Impressionist, :migration do
  fixtures :articles, :impressions, :posts, :profiles
  it "deletes existing migration and generate the migration file" do
    pending
    migrations_dir = Rails.root.join('db/migrate')
    impressions_migration = Dir.entries(migrations_dir).grep(/impressions/)[0]
    File.delete("#{migrations_dir}/#{impressions_migration}") if impressions_migration.present?
    generator_output = systemu("rails g impressionist")[1]
    migration_name = generator_output.split("migrate/")[1].strip
    Dir.entries(migrations_dir).include?(migration_name).should be_truthy
  end

  it "runs the migration created in the previous spec" do
    pending
    migrate_output = systemu("rake db:migrate RAILS_ENV=test")
    migrate_output[1].include?("CreateImpressionsTable: migrated").should be_truthy
  end
end
