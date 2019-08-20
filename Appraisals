%w[6.0.0 5.2.0 5.1.0].each do |rails_version|
  appraise "rails_#{rails_version}" do
    gem 'rails', "~> #{rails_version}"
  end
end

%w[5.0.0 4.2.0].each do |rails_version|
  appraise "rails_#{rails_version}" do
    gem 'rails', "~> #{rails_version}"
    gem 'sqlite3', "~> 1.3.9"
  end
end
