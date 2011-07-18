
Factory.define :creationkey do |creationkey|
  creationkey.key "acode"
end

# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name "Michael Hartl"
  user.email "mhartl@example.com"
  user.password "foobar"
  user.password_confirmation "foobar"
  @access_keys = [] 
  @access_keys.push(Factory(:creationkey))
  user.access_code "acode"
end

Factory.define :ds_module do |ds_module|
  ds_module.name "Test Module"
  ds_module.version "1.0"
  ds_module.documentation "It works."
  ds_module.example "1 + 1 = 2"
  ds_module.files "bundle_tower_07.ds"
  ds_module.category "Library"
  ds_module.ds_attachment File.new(Rails.root + 'spec/fixtures/scripts/hello.ds')
  ds_module.association :user
end

