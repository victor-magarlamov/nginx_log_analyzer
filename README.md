# Nginx Log Analyzer

## Analysis of Nginx access logs for a given day

Script **access.sh** analyzes the access log files in the format like:

    %host - - [%time] \"%request\" %status %bytes \"%{Referer}i\" \"%{User-Agent}i\"

and return following information for a given day:

* average number of requests per second
* max number of requests per second
* top of codes
* top 5 of requests frequency per day
* top 5 of referers frequency per day

### Usage 

Given we have access log such as

    168.119.75.136 - - [17/Apr/2016:06:27:04 +0300] "GET /api/friends?uid=1193 HTTP/1.1" 200 39 "https://game.ru/search.php?id=615608" "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36"

and we want get statistics for 17 April 2016.

1. Copy log files (as *.access.log, *.access.log.1) in the directory 'log/'.
2. Edit access.sh - set the DAY variable in line 13 to '17/Apr/2016'.
3. Execute script - bash access.sh

### Output

    ==================================================
    Req / sec AVG :
    14.6588
    ==================================================
    Req / sec peak :
    223
    ==================================================
    Total by codes :
    200 1242719
    304 1317
    400 758
    499 359
    302 108
    401 103
    404 49
    500 2
    ==================================================
    Top of Requests :
    137809 "GET/api/social/has_friends_app_users
    112519 "GET/api/ticket_comments/unread_ticket_comments
    63526 "GET/api/social/groups_is_member
    48488 "GET/api/social/is_liked
    33016 "GET/api/quest_missions
    ==================================================
    Top of Referers :
    765519 "https://vk.com
    437281 "http://vk.com
    9594 "http://www.ok.ru
    3974 "http://ok.ru
    3068 "https://my.mail.ru
    ==================================================
