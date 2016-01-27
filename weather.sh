#!/bin/sh

#default temperatur type
temp_type="f"
#search_name=""

hint () {
    echo "./weather -l locations [-u unit] [-a| -c | -d day | -s]"
}

getdata () {
#$1:location Name $2:temperature type   $3:number of forecast
    html_woeid=`curl -s  http://woeid.rosselliot.co.nz/lookup/$1`
    woeid=`echo $html_woeid | grep  'woeid_results_table' | awk -F "[<>]" '{ for( i = 1 ; i < NF; i++){ if( $i == "td class='\''woeid'\''"){ i++; print $i;break;}} }'`
#echo "woeid:"$woeid


    html=`curl -s "http://weather.yahooapis.com/forecastrss?w=$woeid&u=$2"`

# echo "$html"   | grep 'astronomy'  $html different from "$html"->reserve new line
    sunrise=`echo "$html" | grep 'astronomy' | awk -F\" '{print $2}'`
    sunset=`echo "$html"  | grep 'astronomy' | awk -F\" '{print $4}'`
    city=`echo "$html" | grep 'location'| awk -F\" '{print $2}'`
    today_weather=`echo "$html"| grep 'yweather:forecast' -m 1 | awk -F\" '{ print $10}'`

    if [ "$2" == "c"  ] ; then
        temp_sign="Celsius degree"
    else
        temp_sign="Fahrenheit degree"
    fi

    today_temp=`echo "$html" | grep 'yweather:condition' | awk -F\" -v SIGN="$temp_sign" '{print $6" "SIGN }'`
    forcast=`echo "$html" | grep 'yweather:forecast' -m $3 | awk -F\"  -v SIGN="$temp_sign"  '{print $4" "$2" "$6" ~ "$8" "SIGN" "$10 }'`

}
#configure file
home_dir=`eval echo "~"`
if [ -f $home_dir/.weather.conf ] ; then
#echo "Default Configuration (~/.weather.conf) exists"
    while read filein ; do
        file="$file\n$filein"
    done < $home_dir/.weather.conf

    #echo -e "$file"
    search_name=`echo -e "$file"|grep 'location'| awk -F= '{printf $2}'`
    temp_type=`echo -e  "$file"  |grep 'unit'| awk -F= '{printf $2}'`
    arr_name=`echo -e "$search_name"  | tr "," "\n"`

else
    :
    #echo "No default ~/.weather.conf file"
fi
valid=true
flag_sun=false


while getopts ":hl:u:acsd": op ; do
    #echo "${OPTIND}-th arg"
    case $op in
        h)
            hint
            report_type="Help"
            valid=true
            exit 0
            ;;
        l)
            #getdata  $OPTARG "f" 3
            search_name=$OPTARG
            arr_name=`echo -e "$search_name"  | tr "," "\n"`
            ;;
        u)
            temp_type=$OPTARG
            if [ "$temp_type" != "c" ] && [ "$temp_type" != "f"  ] ; then
                echo "temperatire unit type:c or f!"
                valie=false
                break
            fi
            ;;
        a)
            report_type="ALL";
            flag_sun=true
            ;;
        c)
            report_type="Current"
            ;;
        d)
            report_type="Future"
            num_forecast=$OPTARG
            if [ $num_forecast -gt 5 ] ||  [ $num_forecast -lt 1 ] ; then
                echo "the day number is between 1 and 5"
                valid=false
            fi
            ;;
        s)
            flag_sun=true
            ;;

        *)
            valid=false
            #echo "Must specify type of information"
            break
            ;;
    esac
done
if [  "$valid" = true  ]; then
    if [ ! "$arr_name"  ]; then
        echo "Must specify location!"
        valid=false
    elif [ -z $report_type ] && [ "$flag_sun" = false ] ; then
        echo "Must specify type of information"
        valid=false
    else
    :
    fi
fi


if [  "$valid" = true ] ; then

    if [ "$report_type" = "ALL" ] ;then
        for name in $arr_name
        do
            getdata $name $temp_type 5
            echo "$city, $today_weather, $today_temp"
            echo "$forcast"
            echo "sunrise: $sunrise, sunset: $sunset"
        done
    elif [ "$report_type" = "Current" ] ;then
        for name in $arr_name
        do
            getdata $name $temp_type 1
            echo "$city, $today_weather, $today_temp"
            if [ "$flag_sun" = true ] ; then
                echo "sunrise: $sunrise, sunset: $sunset"
            fi
        done
    elif [ "$report_type" = "Future" ] ; then
        for name in $arr_name
        do
            getdata $name $temp_type  $num_forecast
            echo "Forecast: $city"
            echo "$forcast"
            if [ "$flag_sun" = true ] ; then
                echo "sunrise: $sunrise, sunset: $sunset"
            fi
        done
    fi

    if [ "$flag_sun" = true ]  && [ -z $report_type ]; then
        for name in  $arr_name ; do
            getdata $name $temp_type  1
            echo "Location: $city"
            echo "sunrise: $sunrise, sunset: $sunset"
        done

    fi
else
    hint
fi
