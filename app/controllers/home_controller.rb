class HomeController < ApplicationController
	before_filter :set_ln
	def set_ln
		if params[:l] == "en"
			@current_language = 1
			@i = 1
		else
			@current_language = 0
		end
		#0 = Italian
		#1 = English
	end

	def index
		@feeds = Feed.all
		
		@ln = Array[
			#ITALIAN
			{
				"home_link_1" => "Chi Siamo",
				"home_link_2" => "Feed",
				"home_link_3" => "Accedi",
				"home_link_4" => "Iscriviti",
				"bar_text" => "LA GRANDE GUERRA",
				"first_left_text" => "benvenuti su Ragazzidel99.it",
				"first_left_text_und" => "La Grande Guerra",
				"first_left_text_exp" => "100 anni fa aveva inizio una delle piu' grandi tragedie della Storia. Allo stesso tempo iniziava il processo che porto' alla completa liberazione dell'Italia dalle potenze straniere e che avvenne grazie al sacrificio di una generazione di ragazzi appena maggiorenni.",
				"first_left_text_more" => "SCOPRI DI PIU'",
				"second_text_1" => "La Grande Guerra raccontata giorno per giorno, con notizie e foto.",
				"second_text_2" => "In contemporanea su Twitter e Facebook",
				"second_feed_preview_text" => "Per un'anteprima dei feed:",
				"md-trigger" => "Clicca Qui",
				"who" => "Chi Siamo",
				"coordinator" => "Coordinatore",
				"dev" => "Sviluppatore",
				"sto_f" => "Storica",
				"sto_m" => "Storico",
				"left_ftext_1" => "Ringraziamo:",
				"left_ftext_2" => 'La Biblioteca Provinciale "Melchiorre Dèlfico"',
				"left_ftext_3" => "L'archivio digitale de " + '"La Stampa"',
				"left_ftext_4" => "Il Liceo Scientifico Albert Einstein - (TE) Abruzzo",
				"left_ftext_5" => "2015 - Ragazzi del '99 ",
			},
			#ENGLISH
			{
				"home_link_1" => "Team",
				"home_link_2" => "Feed",
				"home_link_3" => "Sign In",
				"home_link_4" => "Sign On",
				"bar_text" => "THE GREAT WAR",
				"first_left_text" => "welcome on Ragazzidel99.it",
				"first_left_text_und" => "The Great War",
				"first_left_text_exp" => "100 anni fa aveva inizio una delle piu' grandi tragedie della Storia. Allo stesso tempo iniziava il processo che porto' alla completa liberazione dell'Italia dalle potenze straniere e che avvenne grazie al sacrificio di una generazione di ragazzi appena maggiorenni.",
				"first_left_text_more" => "MORE ABOUT US",
				"second_text_1" => "Ragazzidel99 tell day by day about the first great war, with news and picture.",
				"second_text_2" => "Both on Twitter and Facebook",
				"second_feed_preview_text" => "For a preview of Feed:",
				"md-trigger" => "Click Here",
				"who" => "The Team",
				"coordinator" => "Coordinator",
				"dev" => "Developer",
				"sto_f" => "Historian",
				"sto_m" => "Historian",
				"left_ftext_1" => "Thanks to:",
				"left_ftext_2" => 'The provincial library "Melchiorre Dèlfico"',
				"left_ftext_3" => "The online archive of " + '"La Stampa"',
				"left_ftext_4" => "The high school Albert Einstein - (TE) Abruzzo",
				"left_ftext_5" => "2015 - Ragazzi del '99 ",
			}
			]
	end
end
