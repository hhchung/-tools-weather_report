# Tools --Weather Report
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

## Implement
> + Using input string to get `woeid`
> + Using `woeid` to get country weather
>+ [Reference](https://developer.yahoo.com/weather/documentation.html)
