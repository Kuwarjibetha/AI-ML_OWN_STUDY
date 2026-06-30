let button = document.getElementById("searchBtn");
let result = document.getElementById("weatherResult");

button.onclick = function () {

  let city = document.getElementById("cityInput").value;

  if (city === "") {
    result.innerHTML = "Please enter city name";
    return;
  }

  result.innerHTML = "Loading...";

  
  fetch("https://geocoding-api.open-meteo.com/v1/search?name=" + city) // get lat and lon
    .then(res => res.json())
    .then(data => {

      if (!data.results) {
        result.innerHTML = "City not found";
        return;
      }

      let lat = data.results[0].latitude;
      let lon = data.results[0].longitude;

      // get whether 
      fetch("https://api.open-meteo.com/v1/forecast?latitude=" + lat + "&longitude=" + lon + "&current_weather=true")
        .then(res => res.json())
        .then(weather => {

          let temp = weather.current_weather.temperature;
          let wind = weather.current_weather.windspeed;

          result.innerHTML =
            "City: " + city + "<br>" +
            "Temperature: " + temp + " °C<br>" +
            "Wind Speed: " + wind + " km/h";
        });
    })
    .catch(() => {
      result.innerHTML = "Something went wrong";
    });

};
