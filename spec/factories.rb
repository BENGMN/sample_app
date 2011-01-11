# By using the the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                    "Ben Crudo"
  user.email                   "ben.crudo@gmail.com"
  user.password                "ben000"
  user.password_confirmation   "ben000"
end


