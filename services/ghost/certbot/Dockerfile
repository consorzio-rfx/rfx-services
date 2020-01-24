FROM certbot/certbot

RUN apk add nginx
RUN pip install certbot-nginx


# Copy hello-cron file to the cron.d directory
COPY certbot-renew /etc/cron.d/certbot-renew

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/certbot-renew

# Apply cron job
RUN crontab /etc/cron.d/certbot-renew

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Run the command on container startup
ENTRYPOINT [ "" ]
CMD crond && tail -f /var/log/cron.log

