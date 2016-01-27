# Tools --Weather Report
## Environment
> sh or bash

## Usage
```bash
git clone tools-weather_report
chmod a+x  tools-weather_report/weather.sh
./weather [-h] [-l location] [-u unit] [-a|-c|-d day|-s]
```

>+ -h print help
>+ -l set locations
>+ -u set unit
>+ -a all information(equal -c -d 5 -s)
>+ -c current condition
>+ -d forecast
>+ -s  sunrise/sunset

Configuration File(~/.weather.conf) for default setting
>File position:
>+ ~/.weather.conf

>Content:
>+ location
>+ unit( c or f)

> ex:<br>
> location=hsinchu<br>
> unit=c<br>

## Example
1.
 ```bash
./weather.sh -l hsinchu -c
```
>Taichung City, Mostly Cloudy, 57 Fahrenheit degree

2.
```bash
./weather.sh -l hsinchu -u c -c
```
>Taichung City, Mostly Cloudy, 14 Celsius degree

3.
```bash
./weather.sh -l hsinchu,taipei,tainan -u c -c
```
> Hsinchu City, Showers Late, 16 Celsius degree<br>
> Taipei City, Showers Late, 18 Celsius degree<br>
> Tainan City, Showers Late, 18 Celsius degree<br>

4.
```bash
./weather.sh -l taipei -d 4
```
>Forecast: Taipei City <br>
>27 Jan 2016 Wed 61 ~ 74 Fahrenheit degree Showers Late <br>
>28 Jan 2016 Thu 62 ~ 71 Fahrenheit degree Light Rain <br>
>29 Jan 2016 Fri 60 ~ 68 Fahrenheit degree Rain <br>
>30 Jan 2016 Sat 56 ~ 63 Fahrenheit degree Rain <br>

5.
```bash
./weather.sh -l taipei -a
```
>Taipei City, Showers Late, 64 Fahrenheit degree <br>
>27 Jan 2016 Wed 61 ~ 74 Fahrenheit degree Showers Late <br>
>28 Jan 2016 Thu 62 ~ 71 Fahrenheit degree Light Rain <br>
>29 Jan 2016 Fri 60 ~ 68 Fahrenheit degree Rain <br>
>30 Jan 2016 Sat 56 ~ 63 Fahrenheit degree Rain <br>
>31 Jan 2016 Sun 55 ~ 62 Fahrenheit degree Showers <br>
>sunrise: 6:37 am, sunset: 5:34 pm <br>

## Implement
> + Using input string to get `woeid`
> + Using `woeid` to get country weather
>+ [Reference](https://developer.yahoo.com/weather/documentation.html)
