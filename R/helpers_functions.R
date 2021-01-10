# Simple function to keep the leaflet popups simple
make_map_note <- function(SHIPNAME, LAT,LON,PORT,DATETIME,distance){
  note <- paste('Vessel Name:',SHIPNAME,
        '<br>',
        'Current Point:',
        '<br>',
        '<ul><li>Latitude: ',LAT,
        '</li>',
        '<li>Longitude : ',LON,
        '</li></ul><br>',
        'Port :', PORT,
        '<br>',
        'DateTime: ',as.character(DATETIME),
        '<br>',
        'Longest Distance Travelled:',distance, ' meters')
}