extends Label
var Sat_URL = null #Sat URL from the UI Scene
var Location = str("") #To be used in the location API

func _ready():
	if Sat_URL == null:
		#Error if Invalid has been put
		self.text = str("Error !")
	else:
		$Timer.start()

#Https request Cript / Webscrape 
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var Output = body.get_string_from_utf8()
	var parse_sat_data = parse_json(Output)
	
	#Sattelite Basic Info
	var Sat_ID = parse_sat_data[0]["id"] #ID
	var Sat_Name = parse_sat_data[0]["name"] #Name
	

	#Sattelite Coordinates Lat / Long
	var Main_Coordinates = parse_sat_data[0]["pos"][-1]["d"]
	var Updated_Coordinates = Main_Coordinates.split('|')
	var Lat = Updated_Coordinates[0]
	var Long = Updated_Coordinates[1]
	Location(Lat, Long) #Add Lat and Long parameters to the location variable
	var Alt = Updated_Coordinates[2]  #Altitude
	
	#Updates
	self.text = str(
		"Sattelite ID: " + Sat_ID + "\n" +
		"Sattelite Name: " + Sat_Name + "\n" +
		"Latitude : " + Lat+ "\n" +
		"Longitude : " + Long+ "\n" +
		"Altitude [km]: " + Alt+ "\n" +
		Location+ "\n" 
	)







#Call API Coordinates
func Location(lat, long):
	var Country_api = "https://nominatim.openstreetmap.org/reverse?lat="+String(lat)+"&lon="+String(long) +"&format=json" #Location api
	$CountryAPi.request(Country_api) 
	

#Getting request from Country API
func _on_CountryAPi_request_completed(result, response_code, headers, body):
	var Get_Country = body.get_string_from_utf8()
	var Country_Data = parse_json(Get_Country)
	var Error_Code = '{"error":"Unable to geocode"}' #Error code if Location is not specfied
	
	#Getting location data
	if Get_Country == Error_Code:
		Location = str( "Location : [NO GEO LOCATION]" +"\n" +"[CURRENTLY ON OCEAN]")
	else:
		Location = str(
			"Location: Found !" + "\n" +
			"Country: " + Country_Data["address"]["country"] +"\n" +
			"Country Code: " + Country_Data["address"]["country_code"] +"\n" +
			"State: " + Country_Data["address"]["state"] +"\n")


#Button close 
func _on_Button_button_down():
	queue_free()


#Timer Start
func _on_Timer_timeout():
	yield(get_tree().create_timer(3.0), "timeout")
	$HTTPRequest.request(Sat_URL)
