# == Schema Information
# Schema version: 20101014010042
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
	attr_accessor :password	
	attr_accessible :name, :email, :password, :password_confirmation

	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i


	validates :name,  :presence => true,
			  :length   => { :maximum => 50 }

	validates :email, :presence   => true,
			  :format     => { :with => email_regex },
			  :uniqueness => { :case_sensitive => false }

	validates :password, :presence      => true,
			     :confirmation  => true,
			     :length        => { :within => 6..40 }

	before_save :encrypt_password

	# Returns true if the user's password matches the stored password
        def has_password?(submitted_password)
	  encrypted_password == encrypt(submitted_password)
        end

	def self.authenticate(email, submitted_password)
	      user = find_by_email(email)
	      return nil if user.nil?
	      return user if user.has_password?(submitted_password)
	end

	def self.authenticate_with_salt(id, cookie_salt)
		user = find_by_id(id)
		# if the user has been assigned a value (located) then test if the users salt matches the cookie salt
		# on true return the user object. on false return nil
		(user && user.salt == cookie_salt) ? user : nil
	end
	private
	
	  # Note that salt is a private attribute of this class

	  def encrypt_password
	    self.salt = make_salt if new_record?
	    self.encrypted_password = encrypt(password)
	  end

	  def encrypt(string)
		secure_hash("#{salt}--#{string}")
	  end
	
	  # Salt is created when a new user record is created. The purpose of salt is to add more complexity to the users password
	  # and to ensure(most likely) that the password for each user is unique.
	  def make_salt
	    secure_hash("#{Time.now.utc}--#{password}")
	  end
	 
	  def secure_hash(string)
	    Digest::SHA2.hexdigest(string)
	  end
end
