FROM mongo
COPY ./mongo_keyfile /data/mongo_keyfile
RUN chown mongodb:root /data/mongo_keyfile && chmod 400 /data/mongo_keyfile