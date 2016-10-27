import pandas as pd
from geopy.geocoders import Nominatim
import geocoder
import csv

geolocator = Nominatim()

mydata = pd.read_csv('complaints_with_locations.csv')

mydata = mydata.rename(columns = {"Location (according to buggy OCR)" :"Location"})


locations = mydata['Location'].apply(str)

locations = locations + ", Berkeley" + ", CA"
csvfileobj = open("coordinates.csv" , "w")
writer = csv.writer(csvfileobj)
lat = []
lng = []
writer.writerow(['Latitude' , 'Longitude'])

for location in locations:
	chars = set('/')  				#need this because geolocator doesn't find cross streets denoted by '/'
	if any((c in chars) for c in location):
		geocode = geocoder.google(location)  
		lat.append(geocode.lat)
		lng.append(geocode.lng)
	else:
		try:
			geocode = geolocator.geocode(location , timeout = None)
			lng.append(geocode.longitude)
			lat.append(geocode.latitude)
		except (AttributeError):		#Due to OCR, not all streets are identifiable
			lat.append("")
			lng.append("")

rows = zip(lat, lng)
for row in rows:
	writer.writerow(row)

csvfileobj.close()

