# Use an official MongoDB image as the base image
FROM mongo:latest

# Get args
ARG MONGO_URI

# Install zip utility
RUN apt-get update && apt-get install -y zip && rm -rf /var/lib/apt/lists/*

# Set environment variables for MongoDB connection
ENV MONGO_URI=$MONGO_URI

# Create a directory for backups
RUN mkdir -p /backup

# Copy the backup script into the container
COPY backup.sh /usr/local/bin/backup.sh

# Make the script executable
RUN chmod +x /usr/local/bin/backup.sh

# Set the script as the container's entrypoint
ENTRYPOINT ["/usr/local/bin/backup.sh"]



