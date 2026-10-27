#!/usr/bin/env python3

import json
import requests
from datetime import datetime

WEATHER_CODES = {
    '113': '☀️ ',
    '116': '⛅ ',
    '119': '☁️ ',
    '122': '☁️ ',
    '143': '☁️ ',
    '176': '🌧️',
    '179': '🌧️',
    '182': '🌧️',
    '185': '🌧️',
    '200': '⛈️ ',
    '227': '🌨️',
    '230': '🌨️',
    '248': '☁️ ',
    '260': '☁️ ',
    '263': '🌧️',
    '266': '🌧️',
    '281': '🌧️',
    '284': '🌧️',
    '293': '🌧️',
    '296': '🌧️',
    '299': '🌧️',
    '302': '🌧️',
    '305': '🌧️',
    '308': '🌧️',
    '311': '🌧️',
    '314': '🌧️',
    '317': '🌧️',
    '320': '🌨️',
    '323': '🌨️',
    '326': '🌨️',
    '329': '❄️ ',
    '332': '❄️ ',
    '335': '❄️ ',
    '338': '❄️ ',
    '350': '🌧️',
    '353': '🌧️',
    '356': '🌧️',
    '359': '🌧️',
    '362': '🌧️',
    '365': '🌧️',
    '368': '🌧️',
    '371': '❄️ ',
    '374': '🌨️',
    '377': '🌨️',
    '386': '🌨️',
    '389': '🌨️',
    '392': '🌧️',
    '395': '❄️ '
}

data = {}


def format_time(time_str):
    return time_str.replace("00", "").zfill(2)


def format_temp(temp):
    return (str(temp) + "°C").ljust(5)


def format_chances(hour):
    chances = {
        "chanceoffog": "Fog",
        "chanceoffrost": "Frost",
        "chanceofovercast": "Overcast",
        "chanceofrain": "Rain",
        "chanceofsnow": "Snow",
        "chanceofsunshine": "Sunshine",
        "chanceofthunder": "Thunder",
        "chanceofwindy": "Wind"
    }

    conditions = []
    for event, label in chances.items():
        if int(hour.get(event, 0)) > 0:
            conditions.append(f"{label} {hour[event]}%")
    return ", ".join(conditions)


try:
    weather = requests.get("https://wttr.in/Egypt?format=j1", timeout=10).json()

    current = weather['current_condition'][0]
    feels_like_c = current.get('FeelsLikeC', current.get('temp_C', '0'))
    temp_int = int(feels_like_c)
    extrachar = '+' if 0 < temp_int < 10 else ''

    weather_code = current.get('weatherCode', '113')
    icon = WEATHER_CODES.get(weather_code, '☀️ ')

    data['text'] = f" {icon} {extrachar}{feels_like_c}°C"

    area = weather.get('nearest_area', [{}])[0].get('areaName', [{}])[0].get('value', 'Egypt')
    country = weather.get('nearest_area', [{}])[0].get('country', [{}])[0].get('value', 'Egypt')

    data['tooltip'] = f"<b>{country} ({area}): {current['weatherDesc'][0]['value']} {current['temp_C']}°C</b>\n"
    data['tooltip'] += f"Feels like: {feels_like_c}°C\n"
    data['tooltip'] += f"Wind: {current['windspeedKmph']} Km/h\n"
    data['tooltip'] += f"Humidity: {current['humidity']}%\n"

    for i, day in enumerate(weather.get('weather', [])):
        data['tooltip'] += "\n<b>"
        if i == 0:
            data['tooltip'] += "Today, "
        elif i == 1:
            data['tooltip'] += "Tomorrow, "
        data['tooltip'] += f"{day['date']}</b>\n"
        data['tooltip'] += f"⬆️ {day['maxtempC']}°C ⬇️ {day['mintempC']}°C "
        data['tooltip'] += f"🌅 {day['astronomy'][0]['sunrise']} 🌇 {day['astronomy'][0]['sunset']}\n"

        for hour in day.get('hourly', []):
            if i == 0:
                if int(format_time(hour['time'])) < datetime.now().hour - 2:
                    continue
            h_code = hour.get('weatherCode', '113')
            h_icon = WEATHER_CODES.get(h_code, '☀️ ')
            h_feels = hour.get('FeelsLikeC', hour.get('tempC', '0'))
            data['tooltip'] += f"{format_time(hour['time'])} {h_icon} {format_temp(h_feels)} {hour['weatherDesc'][0]['value']}, {format_chances(hour)}\n"

except Exception as e:
    data['text'] = "🌡️ N/A"
    data['tooltip'] = f"Weather unavailable: {e}"

print(json.dumps(data))