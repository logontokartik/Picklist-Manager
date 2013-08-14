public class TimezoneManager{

    
    public static Map<String,String> oldNewTimezoneMap = new Map<String,String>{
 '(UTC) Dublin, Edinburgh, Lisbon, London'=>'GMT+00:00 British Summer Time (Europe/London)', 
 '(UTC) Coordinated Universal Time'=>'GMT+00:00 Greenwich Mean Time (GMT)', 
 '(UTC) Dublin, Edinburgh, Lisbon, London'=>'GMT+00:00 Irish Summer Time (Europe/Dublin)', 
 '(UTC) Dublin, Edinburgh, Lisbon, London'=>'GMT+00:00 Western European Summer Time (Europe/Lisbon)', 
 '(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna'=>'GMT+01:00 Central European Time (Europe/Amsterdam)', 
 '(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna'=>'GMT+01:00 Central European Time (Europe/Berlin)', 
 '(UTC+01:00) Brussels, Copenhagen, Madrid, Paris'=>'GMT+01:00 Central European Time (Europe/Brussels)', 
 '(UTC+01:00) Brussels, Copenhagen, Madrid, Paris'=>'GMT+01:00 Central European Time (Europe/Paris)', 
 '(UTC+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague'=>'GMT+01:00 Central European Time (Europe/Prague)', 
 '(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna'=>'GMT+01:00 Central European Time (Europe/Rome)', 
 '(UTC+02:00) Cairo'=>'GMT+02:00 Eastern European Time (Africa/Cairo)', 
 '(UTC+02:00) Athens, Bucharest, Istanbul'=>'GMT+02:00 Eastern European Time (Europe/Athens)', 
 '(UTC+02:00) Athens, Bucharest, Istanbul'=>'GMT+02:00 Eastern European Time (Europe/Bucharest)', 
 '(UTC+02:00) Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius'=>'GMT+02:00 Eastern European Time (Europe/Helsinki)', 
 '(UTC+02:00) Athens, Bucharest, Istanbul'=>'GMT+02:00 Eastern European Time (Europe/Istanbul)', 
 '(UTC+02:00) Minsk'=>'GMT+02:00 Eastern European Time (Europe/Minsk)', 
 '(UTC+02:00) Jerusalem'=>'GMT+02:00 Israel Standard Time (Asia/Jerusalem)', 
 '(UTC+02:00) Harare, Pretoria'=>'GMT+02:00 South Africa Standard Time (Africa/Johannesburg)', 
 '(UTC+03:00) Baghdad'=>'GMT+03:00 Arabia Standard Time (Asia/Baghdad)', 
 '(UTC+03:00) Kuwait, Riyadh'=>'GMT+03:00 Arabia Standard Time (Asia/Kuwait)', 
 '(UTC+03:00) Kuwait, Riyadh'=>'GMT+03:00 Arabia Standard Time (Asia/Riyadh)', 
 '(UTC+03:00) Nairobi'=>'GMT+03:00 Eastern African Time (Africa/Nairobi)', 
 '(UTC+03:00) Moscow, St. Petersburg, Volgograd'=>'GMT+03:00 Moscow Standard Time (Europe/Moscow)', 
 '(UTC+03:30) Tehran'=>'GMT+03:30 Iran Standard Time (Asia/Tehran)', 
 '(UTC+04:00) Tbilisi'=>'GMT+04:00 Georgia Time (Asia/Tbilisi)', 
 '(UTC+04:00) Abu Dhabi, Muscat'=>'GMT+04:00 Gulf Standard Time (Asia/Dubai)', 
 '(UTC+04:30) Kabul'=>'GMT+04:30 Afghanistan Time (Asia/Kabul)', 
 '(UTC+05:00) Islamabad, Karachi'=>'GMT+05:00 Pakistan Summer Time (Asia/Karachi)', 
 '(UTC+05:00) Tashkent'=>'GMT+05:00 Uzbekistan Time (Asia/Tashkent)', 
 '(UTC+05:00) Ekaterinburg'=>'GMT+05:00 Yekaterinburg Time (Asia/Yekaterinburg)', 
 '(UTC+05:30) Chennai, Kolkata, Mumbai, New Delhi'=>'GMT+05:30 India Standard Time (Asia/Calcutta)', 
 '(UTC+05:30) Sri Jayawardenepura'=>'GMT+05:30 India Standard Time (Asia/Colombo)', 
 '(UTC+05:45) Kathmandu'=>'GMT+05:45 Nepal Time (Asia/Katmandu)', 
 '(UTC+06:00) Dhaka'=>'GMT+06:00 Bangladesh Time (Asia/Dacca)', 
 '(UTC+06:30) Yangon (Rangoon)'=>'GMT+06:30 Myanmar Time (Asia/Rangoon)', 
 '(UTC+07:00) Bangkok, Hanoi, Jakarta'=>'GMT+07:00 Indochina Time (Asia/Bangkok)', 
 '(UTC+07:00) Bangkok, Hanoi, Jakarta'=>'GMT+07:00 Indochina Time (Asia/Saigon)', 
 '(UTC+07:00) Bangkok, Hanoi, Jakarta'=>'GMT+07:00 West Indonesia Time (Asia/Jakarta)', 
 '(UTC+08:00) Beijing, Chongqing, Hong Kong, Urumqi'=>'GMT+08:00 China Standard Time (Asia/Shanghai)', 
 '(UTC+08:00) Taipei'=>'GMT+08:00 China Standard Time (Asia/Taipei)', 
 '(UTC+08:00) Beijing, Chongqing, Hong Kong, Urumqi'=>'GMT+08:00 Hong Kong Time (Asia/Hong_Kong)', 
 '(UTC+08:00) Kuala Lumpur, Singapore'=>'GMT+08:00 Malaysia Time (Asia/Kuala_Lumpur)', 
 '(UTC+08:00) Taipei'=>'GMT+08:00 Philippines Time (Asia/Manila)', 
 '(UTC+08:00) Kuala Lumpur, Singapore'=>'GMT+08:00 Singapore Time (Asia/Singapore)', 
 '(UTC+08:00) Perth'=>'GMT+08:00 Western Standard Time (Australia)', 
 '(UTC+09:00) Osaka, Sapporo, Tokyo'=>'GMT+09:00 Japan Standard Time (Asia/Tokyo)', 
 '(UTC+09:00) Seoul'=>'GMT+09:00 Korea Standard Time (Asia/Seoul)', 
 '(UTC+09:30) Darwin'=>'GMT+09:30 Australian Central Standard Time (Australia/Darwin)', 
 '(UTC+09:30) Adelaide'=>'GMT+10:30 Australian Central Daylight Time (Australia/Adelaide)', 
 '(UTC+10:00) Brisbane'=>'GMT+10:00 Australian Eastern Standard Time (Australia/Brisbane)', 
 '(UTC+11:00) Solomon Is., New Caledonia'=>'GMT+11:00 Solomon Is. Time (Pacific/Guadalcanal)', 
 '(UTC+12:00) Fiji'=>'GMT+12:00 Fiji Time (Pacific/Fiji)', 
 '(UTC+12:00) Auckland, Wellington'=>'GMT+12:00 New Zealand Daylight Time (Pacific/Auckland)', 
 '(UTC+12:00) Petropavlovsk-Kamchatsky - Old'=>'GMT+12:00 Petropavlovsk-Kamchatski Time (Asia/Kamchatka)', 
 '(UTC+13:00) Nuku\'alofa'=>'GMT+13:00 Phoenix Is. Time (Pacific/Enderbury)', 
 '(UTC+13:00) Nuku\'alofa'=>'GMT+13:00 Tonga Time (Pacific/Tongatapu)', 
 '(UTC-01:00) Cape Verde Is.'=>'GMT-01:00 Cape Verde Time (Atlantic/Cape_Verde)', 
 '(UTC-02:00) Coordinated Universal Time-02'=>'GMT-02:00 South Georgia Standard Time (Atlantic/South_Georgia)', 
 '(UTC-03:00) Buenos Aires'=>'GMT-03:00 Argentine Summer Time (America/Buenos_Aires)', 
 '(UTC-03:00) Brasilia'=>'GMT-03:00 Brasilia Summer Time (America/Sao_Paulo)', 
 '(UTC-03:30) Newfoundland'=>'GMT-03:30 Newfoundland Daylight Time (America/St_Johns)', 
 '(UTC-04:00) Atlantic Time (Canada)'=>'GMT-04:00 Atlantic Daylight Time (America/Halifax)', 
 '(UTC-04:00) Atlantic Time (Canada)'=>'GMT-04:00 Atlantic Daylight Time (Atlantic/Bermuda)', 
 '(UTC-04:00) Georgetown, La Paz, Manaus, San Juan'=>'GMT-04:00 Atlantic Standard Time (America/Puerto_Rico)', 
 '(UTC-04:00) Santiago'=>'GMT-04:00 Chile Summer Time (America/Santiago)', 
 '(UTC-04:30) Caracas'=>'GMT-04:30 Venezuela Time (America/Caracas)', 
 '(UTC-05:00) Bogota, Lima, Quito'=>'GMT-05:00 Colombia Time (America/Bogota)', 
 '(UTC-05:00) Indiana (East)'=>'GMT-05:00 Eastern Daylight Time (America/Indianapolis)', 
 '(UTC-05:00) Eastern Time (US & Canada)'=>'GMT-05:00 Eastern Daylight Time (America/New_York)', 
 '(UTC-05:00) Bogota, Lima, Quito'=>'GMT-05:00 Eastern Standard Time (America/Panama)', 
 '(UTC-05:00) Bogota, Lima, Quito'=>'GMT-05:00 Peru Time (America/Lima)', 
 '(UTC-06:00) Central Time (US & Canada)'=>'GMT-06:00 Central Daylight Time (America/Chicago)', 
 '(UTC-06:00) Central America'=>'GMT-06:00 Central Standard Time (America/El_Salvador)', 
 '(UTC-06:00) Guadalajara, Mexico City, Monterrey'=>'GMT-06:00 Central Standard Time (America/Mexico_City)', 
 '(UTC-07:00) Mountain Time (US & Canada)'=>'GMT-07:00 Mountain Daylight Time (America/Denver)', 
 '(UTC-07:00) Arizona'=>'GMT-07:00 Mountain Standard Time (America/Phoenix)', 
 '(UTC-08:00) Pacific Time (US & Canada)'=>'GMT-08:00 Pacific Daylight Time (America/Los_Angeles)', 
 '(UTC-08:00) Baja California'=>'GMT-08:00 Pacific Standard Time (America/Tijuana)', 
 '(UTC-09:00) Alaska'=>'GMT-09:00 Alaska Daylight Time (America/Anchorage)', 
 '(UTC-10:00) Hawaii'=>'GMT-10:00 Hawaii Standard Time (Pacific/Honolulu)', 
 '(UTC-11:00) Samoa'=>'GMT-11:00 Niue Time (Pacific/Niue)', 
 '(UTC-11:00) Samoa'=>'GMT-11:00 Samoa Standard Time (Pacific/Pago_Pago)' };
    
    
    public TimezoneManager(){
    	
    }
    
    
    public static String getNewTimezoneValue(String oldTimezone){
    
        String newTimezone = '';
        
        newTimezone = oldNewTimezoneMap.get(oldTimezone);
        
        return newTimezone;
    
    
    }
    
    
}