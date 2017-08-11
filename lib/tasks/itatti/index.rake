require 'rsolr'
require 'json'
include Blacklight
require 'date'

namespace :caselaw do
  desc 'Index the data'
  task index: :environment do


	p "Droping index"
 	solr = RSolr.connect :url => Blacklight.connection_config[:url]
 	solr.delete_by_query '*:*'

 	counter = 0
 	total = 0

	File.open("/Users/thisismattmiller/Downloads/Illcases_solr_docs.ndjson", "r").each_line do |line|


		data  = JSON.parse line

		# p data

		if data['pub_date'].length == 4
			data['pub_date'] = data['pub_date'] + '-01-01'
		end
		if data['pub_date'].length == 7
			data['pub_date'] = data['pub_date'] + '-01'
		end

		


		doc = {}
		doc[:id] = data['id']
		doc[:title_display] = data['tital_display']
		# doc[:pub_date] =  Date.parse(data['pub_date']).to_time.to_i
		doc[:year_facet] = data['pub_date'][0,4]
		doc[:format] = data['format']
		doc[:language_facet] = data['language_facet']
		doc[:wikipedia_t] = data['wikipedia']
		doc[:wikidata_t] = data['wikidata']
		doc[:subject_topic_facet] = data['subject_topic_facet']
		doc[:subject_geo_facet] = data['subject_geo_facet']
		doc[:judge_sex_or_gender_facet] = data["sex_or_gender"]
		doc[:judge_occupation_facet] = data["occupation"]
		doc[:judge_educated_at_facet] = data["educated_at"]
		doc[:judge_place_of_birth_facet] = data["place_of_birth"]
		doc[:judge_place_of_death_facet] = data["place_of_death"]
		doc[:judge_position_held_facet] = data["position_held"]
		doc[:judge_member_of_political_party_facet] = data["member_of_political_party"]
		doc[:judge_conflict_facet] = data["conflict"]
		doc[:judge_member_of_sports_team_facet] = data["member_of_sports_team"]
		doc[:judge_military_branch_facet] = data["military_branch"]
		doc[:judge_medical_condition_facet] = data["medical_condition"]
		doc[:judge_religion_facet] = data["religion"]
		doc[:judge_award_received_facet] = data["award_received"]

		doc[:text_display] = data["text"]

		# doc[:title_display] = data['tital_display']
		# doc[:title_display] = data['tital_display']
		# doc[:title_display] = data['tital_display']

		
		solr.add doc
		counter = counter + 1
		total = total + 1

		if counter > 100
			solr.commit
			p total
			counter = 0
		end

	end
	

	# counter = 0
	# allUris.each do |uri|

	#   	doc = {}
	#   	doc[:id] = uri.rpartition('/').last
	#   	doc[:language_facet] = []
	#   	doc[:edition_facet] = []
	#   	doc[:technique_facet] = objectsTechnique[uri][:allTechniques]
	#   	doc[:technique_recto_t] = objectsTechnique[uri][:rectoTechinque]
	#   	doc[:technique_recto_uri] = objectsTechnique[uri][:rectoTechinqueUri]
	#   	doc[:technique_verso_t] = objectsTechnique[uri][:versoTechinque]
	#   	doc[:technique_verso_uri] = objectsTechnique[uri][:versoTechinqueUri]

	#   	doc[:bcn_t] = []

	#   	counter = counter +1
	#   	p "#{counter}/#{allUris.size}"



	#   	years.each do |year|

	# 	  	# if doc[:id] == "0001491-Berenson"
	# 	  	# 	p objects[year][uri]
	# 	  	# end
	# 	  	if !objects[year][uri][:bcn].blank?
	# 	  		doc[:edition_facet] << "Berenson #{year}"
	# 	  		doc["bnc_#{year}_s"] = objects[year][uri][:bcn]
	# 	  	end

	#   		if objects[year].include? uri
	#   			# doc[:language_facet] << "Berenson #{year}"
	#   			doc["verso_title_#{year}_t"] = objects[year][uri][:title_verso]
	#   			doc["recto_title_#{year}_t"] = objects[year][uri][:title_recto]

	#   			doc["verso_note_#{year}_t"] = objects[year][uri][:note_verso]
	#   			doc["recto_note_#{year}_t"] = objects[year][uri][:note_recto]

	#   			doc["verso_figures_#{year}_t"] = objects[year][uri][:figures_verso]
	#   			doc["recto_figures_#{year}_t"] = objects[year][uri][:figures_recto]

	#   			doc[:bcn_t] << objects[year][uri][:bcn]

	# 		  	authorDisplay = ""
	# 		  	objects[year][uri][:creators].each do |creator|
	# 		  		authorDisplay = authorDisplay + "#{creator[:name]} #{creator[:role]} "
	# 		  		doc[:language_facet] << creator[:role].sub('(','').sub(')','')
	# 		  	end
	# 		  	doc["author_#{year}_display_s"] = authorDisplay.strip


	# 		  	if doc["author_#{year}_display_s"].size == 0; doc["author_#{year}_display_s"] = "--"  end
	#   		end
	#   	end

	#   	# use the 1961 title if it eixsts
	#   	if objects.keys().include? '1961'
	#   		title = ""
	#   		if objects['1961'][uri][:title_recto] != 'N/A'; title = objects['1961'][uri][:title_recto] end
	#   		if objects['1961'][uri][:title_verso] != 'N/A'; title = "#{title} / #{objects['1961'][uri][:title_verso]}".sub('/ --','').strip end
 #  		  	doc[:title_t] = title
 #  			doc[:title_display] = title
 #  		end


 #  		if objects.keys().include? '1961'
	# 	  	authorDisplay = ""
	# 	  	authors = []
	# 	  	objects['1961'][uri][:creators].each do |creator|
	# 	  		doc[:subject_topic_facet] = "#{creator[:name]}"
	# 	  		authorDisplay = authorDisplay + "#{creator[:name]} #{creator[:role]} "
	# 	  		authors << "#{creator[:name]}"
	# 	  	end
	# 	  	doc[:author_display] = authorDisplay.strip
	# 	  	doc[:author_t] = authors
	# 		doc[:authorsuggest] = authorDisplay.strip

	# 	end

	# 	# p doc
	#   	solr.add doc

	#   	# sleep(0.1)

	# end

	solr.commit



	# objects.keys().each do |key|
	#   	# solr.delete_by_id 1

	#   	doc = {}
	#   	doc[:id] = key.rpartition('/').last
	#   	doc[:format] = "Berenson #{objects[key][:year]}"
	#   	if !objects[key][:title_recto].nil?
	#   		doc[:title_t] = objects[key][:title_recto]
	#   		doc[:title_display] = objects[key][:title_recto]
	#   	end
	#   	if !objects[key][:title_verso].nil?
	#   		doc[:subtitle_t] = objects[key][:title_verso]
	#   		doc[:subtitle_display] = objects[key][:title_verso]
	#   	end

	#   	authorDisplay = ""
	#   	authors = []
	#   	objects[key][:creators].each do |creator|
	#   		doc[:subject_topic_facet] = "#{creator[:name]}"
	#   		authorDisplay = authorDisplay + "#{creator[:name]} #{creator[:role]} "
	#   		authors << "#{creator[:name]}"
	#   	end
	#   	doc[:author_display] = authorDisplay.strip
	#   	doc[:author_t] = authors





	#   	count = count + 1
	#   	p count

	#   	# p doc
	#   	solr.add doc
	#   	# solr.add :id=>1, :title_display=>"WHATEVER", :title_t=>"test display",  :more_txt=>"Whatever", subtitle_display:"More stuff"
	#   	# solr.commit
	#   	# response = solr.get 'select', :params => {:q => '*:*'}
	#    #  p Blacklight.connection_config[:url]
	#    #  p response.to_s


	# end
	# solr.commit


  end
end