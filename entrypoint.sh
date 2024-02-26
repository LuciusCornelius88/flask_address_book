#!/bin/bash

attempts=0
max_attempts=100
sleep_time=5

while [ "$attempts" -lt "$max_attempts" ]; do
  flask db init &> /dev/null

  if [ $? -eq 0 ]; then
    echo "MySQL is available - executing app"
    flask db migrate
    exec flask run
    break
  fi

  attempts=$((attempts + 1))
  echo "MySQL is unavailable - attempt $attempts/$max_attempts, sleeping for $sleep_time seconds"
  sleep $sleep_time
done

echo "Maximum retries exceeded. Exiting."
exit 1

