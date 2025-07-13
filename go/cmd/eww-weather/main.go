package main

import (
	"dotfiles/pkg/log"
	"encoding/json"
	"fmt"
	"log/slog"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/spf13/pflag"
)

type Weather struct {
	Time    time.Time    `json:"time"`
	Units   CurrentUnits `json:"current_units"`
	Current Current      `json:"current"`
}

type Current struct {
	Temperature float64 `json:"temperature_2m"`
	WeatherCode int64   `json:"weather_code"`
}

type CurrentUnits struct {
	Temperature string `json:"temperature_2m"`
	WeatherCode string `json:"weather_code"`
}

var iconMap = map[int64]string{
	// Clear to cloudy (0–3)
	0: "", 1: "",
	// Cloudy
	2: "", 3: "", 80: "",
	// Fog etc.
	45: "", 48: "",
	// Drizzle (light)
	51: "", 53: "", 55: "", 56: "", 57: "",
	// Rain
	61: "", 63: "", 65: "", 66: "", 67: "",
	81: "", 82: "",
	// Snow
	71: "󰖘", 73: "󰖘", 75: "󰖘", 77: "󰖘", 85: "󰖘",
	86: "󰖘",
	// Thunderstorms
	95: "", 96: "", 99: "",
}

func init() {
	quiet := pflag.BoolP("quiet", "q", false, "Suppress all logs")
	pflag.Parse()

	if *quiet {
		log.Setup(slog.LevelError + 1)
	} else {
		log.Setup(slog.LevelDebug)
	}
}

func main() {
	locationPath := os.ExpandEnv("$HOME/.config/.location")

	ticker := time.NewTicker(10 * time.Minute)
	defer ticker.Stop()

	CheckWeather(locationPath)
	for range ticker.C {
		CheckWeather(locationPath)
	}
}

func ReadLocation(path string) (string, string, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return "", "", err
	}

	location := strings.TrimSpace(string(data))
	coords := strings.Split(location, ",")
	if len(coords) != 2 {
		return "", "", fmt.Errorf("invalid location format, expected 'latitude,longitude'")
	}

	return strings.TrimSpace(coords[0]), strings.TrimSpace(coords[1]), nil
}

const CacheFile = "/tmp/weather-cache"

func CachedWeather() (*Weather, error) {
	file, err := os.Open(CacheFile)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var weather Weather
	if err := json.NewDecoder(file).Decode(&weather); err != nil {
		return nil, err
	}
	return &weather, nil
}

const WeatherApi = "https://api.open-meteo.com/v1/forecast?latitude=%s&longitude=%s&current=weather_code,temperature_2m"

func FetchWeather(latitude, longitude string) (*Weather, error) {
	cached, err := CachedWeather()
	if err == nil && time.Since(cached.Time) < 10*time.Minute {
		slog.Info("Using cached weather data")
		return cached, nil
	}

	url := fmt.Sprintf(WeatherApi, latitude, longitude)

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("unexpected status code: %d", resp.StatusCode)
	}

	var weather Weather
	if err := json.NewDecoder(resp.Body).Decode(&weather); err != nil {
		return nil, err
	}

	weather.Time = time.Now()

	file, err := os.Create(CacheFile)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	if err := json.NewEncoder(file).Encode(weather); err != nil {
		slog.Error("Failed to write weather cache", "error", err)
	}

	return &weather, nil
}

func CheckWeather(locationPath string) {
	latitude, longitude, err := ReadLocation(locationPath)
	if err != nil {
		slog.Error("Reading location", "error", err)
		return
	}

	weather, err := FetchWeather(latitude, longitude)
	if err != nil {
		slog.Error("Fetching weather", "error", err)
		return
	}

	slog.Info("Weather", "code", weather.Current.WeatherCode, "temperature", weather.Current.Temperature)
	icon, ok := iconMap[weather.Current.WeatherCode]
	if ok {
		fmt.Printf("%s %.1f%s\n", icon, weather.Current.Temperature, weather.Units.Temperature)
	} else {
		slog.Error("Unknown weather code", "code", weather.Current.WeatherCode)
		fmt.Printf("%.1f%s\n", weather.Current.Temperature, weather.Units.Temperature)
	}
}
