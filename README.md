<p align="center">
<a href="https://public.tableau.com/views/SanFranciscoBikeShare_16783802196730/Dashboard1?:language=en-US&:display_count=n&:origin=viz_share_link">
  <img src="./images/tableau.png" width=400>
<a/>
</p>

In this project, I analyzed the San Francisco bikeshare dataset using BigQuery's geospatial functions to explore and visualize the data in different ways. The dataset includes information on bike trips, stations, and members from 2013 to 2020.

First, I used two queries to extract data to use for a Tableau dashboard using the station location, start/end station name, trip duration, start date, member subscription status, member gender, and member age columns; I joined the bikeshare_trips and bikeshare_station_info tables to get the necessary information.

Next, I used geolocation to group stations based on their proximity to key cities - San Francisco, San Jose, and Oakland. I defined the city centers and their radii and used the ST_DWITHIN and ST_DISTANCE functions to calculate the distance between each station and its respective city center. This allowed me to identify the stations that are closest to each city center and group them accordingly.
