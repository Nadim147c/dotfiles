pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property var location: ({
            valid: false,
            lat: 0,
            lon: 0
        })

    property var data: ({
            uv: 0,
            humidity: 0,
            sunrise: 0,
            sunset: 0,
            windDir: 0,
            wCode: 0,
            city: 0,
            wind: 0,
            precip: 0,
            visib: 0,
            press: 0,
            temp: 0,
            tempFeelsLike: 0
        })

    function refineData(data) {
        let temp = {};
        temp.uv = data?.current?.uvIndex || 0;
        temp.humidity = (data?.current?.humidity || 0) + "%";
        temp.sunrise = data?.astronomy?.sunrise || "0.0";
        temp.sunset = data?.astronomy?.sunset || "0.0";
        temp.windDir = data?.current?.winddir16Point || "N";
        temp.wCode = data?.current?.weatherCode || "113";
        temp.city = data?.location?.areaName[0]?.value || "City";
        temp.temp = "";
        temp.tempFeelsLike = "";
        temp.wind = (data?.current?.windspeedKmph || 0) + " km/h";
        temp.precip = (data?.current?.precipMM || 0) + " mm";
        temp.visib = (data?.current?.visibility || 0) + " km";
        temp.press = (data?.current?.pressure || 0) + " hPa";
        temp.temp += (data?.current?.temp_C || 0);
        temp.tempFeelsLike += (data?.current?.FeelsLikeC || 0);
        temp.temp += "°C";
        temp.tempFeelsLike += "°C";
        root.data = temp;
    }

    function getData() {
        fetcher.running = true;
    }

    function formatCityName(cityName) {
        return cityName.trim().split(/\s+/).join('+');
    }

    Process {
        id: fetcher
        command: ["weather"]
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.length === 0)
                    return;
                try {
                    const parsedData = JSON.parse(text);
                    root.refineData(parsedData);
                    // console.info(`[ data: ${JSON.stringify(parsedData)}`);
                } catch (e) {
                    console.error(`[WeatherService] ${e.message}`);
                }
            }
        }
    }

    Timer {
        running: true
        repeat: true
        interval: 1000 * 10 // 10sec
        triggeredOnStart: true
        onTriggered: root.getData()
    }
}
