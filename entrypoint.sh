#!/bin/bash
# set -e

# host="mysql"
# port="3306"
# user="root"
# password="password"

# >&2 echo "Waiting for MySQL to be available..."

# for i in {1..250}; do
#     if mysqladmin ping -h "$host" -P "$port" -u "$user" -p"$password" &> /dev/null; then
#         >&2 echo "MySQL is available - executing app"
        # flask db init
        # flask db migrate
        # exec flask run
#     else
#         >&2 echo "MySQL is unavailable - sleeping for 10 seconds"
#         sleep 10
#         flask db init
#         flask db migrate
#         exec flask run
#     fi
# done

# >&2 echo "Maximum retries exceeded. Exiting."
# exit 1



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

