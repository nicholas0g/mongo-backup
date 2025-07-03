# Use an official MongoDB image as the base image
FROM mongo:latest

# Get args
ARG MONGO_URI

# Install zip utility, s3cmd e dos2unix
RUN apt-get update && apt-get install -y zip s3cmd dos2unix && rm -rf /var/lib/apt/lists/*

# Set environment variables for MongoDB connection
ENV MONGO_URI=$MONGO_URI

# Create a directory for backups
RUN mkdir -p /backup

# Copy the backup script into the container
COPY backup.sh /usr/local/bin/backup.sh

# Make the script executable e converti in formato Unix
RUN dos2unix /usr/local/bin/backup.sh && chmod +x /usr/local/bin/backup.sh

# Set the script as the container's entrypoint
ENTRYPOINT ["/usr/local/bin/backup.sh"]



