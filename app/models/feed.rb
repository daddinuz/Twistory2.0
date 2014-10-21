class Feed < ActiveRecord::Base

  mount_uploader :feed_image, ImageUploader

  validate :checking_feed_text
  validate :checking_for_date
  validate :checking_for_image_size
 
  private
 
  def checking_for_image_size
    if feed_image.size > 300.kilobytes
      errors[:base] = "L\'immagine non puo\' superare 300 Kb"
    end 
  end
	
  def checking_feed_text
    if !(feed_text.present?)  
      errors[:base] = "Non puoi pubblicare feed vuoti!"
    elsif feed_image.present? and (feed_text.size > 101 or (feed_text_english.present? and feed_text_english.size > 101))         
      errors[:base] = "I feeds con immagini non possono contenere piu\' di 101 caratteri!"
    
      if feed_text_english.size > 101
        errors[:base] = "La versione Inglese del feed contienete piu\' di 101 caratteri"
      end
    elsif (feed_text.size > 124 or (feed_text_english.present? and feed_text_english.size > 124))
      errors[:base] = "I feeds non possono contenere piu\' di 124 caratteri!"         
    end
  end 
	
  def checking_for_date
    if !(date.present?) 
      errors[:base] = "E\' necessario inserire una data di pubblicazione per il feed!"
    elsif date.utc <= DateTime.now.utc
      errors[:base] = "La data di pubblicazione non puo\' essere nel passato!"
    end
  end
  
end
