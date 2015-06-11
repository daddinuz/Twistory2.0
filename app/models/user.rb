class User < ActiveRecord::Base

  mount_uploader :profile_image, UserImageUploader
  
  validate :checking_for_user_name
  validate :checking_for_image_size
  after_create :send_email
 
  private
  
  def checking_for_user_name
    if !(user_name.present?)
      errors[:base] = "Devi inserire un nome pubblico"
    elsif user_name.size > 15
      errors[:base] = "Il nome non puo' superare i 15 caretteri"
    end
  end 
	
 
  def checking_for_image_size
    errors[:base] = "L'immagine non può superare 300 Kb" if profile_image.size > 300.kilobytes
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
 
 def send_email
 	UserMailer.welcome_email.deliver
 end
end
