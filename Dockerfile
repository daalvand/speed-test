# Use the official Alpine base image
FROM alpine:latest

# Update package repositories and install required packages
RUN apk update && apk add apache2-utils wrk hey curl

# Set the working directory
WORKDIR /app

CMD ["/bin/sh"]
