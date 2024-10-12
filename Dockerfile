# Use Ubuntu as base image
FROM ubuntu

# Install required packages
RUN apt-get update && \
    apt-get install -y curl gnupg lsb-release && \
    rm -rf /var/lib/apt/lists/*

  
WORKDIR /opt/mern-app

# Install Node.js and npm using Nodesource
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install MongoDB
RUN curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
    gpg --dearmor -o /usr/share/keyrings/mongodb-server-8.0.gpg && \
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/8.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-8.0.list && \
    apt-get update && \
    apt-get install -y mongodb-org && \
    rm -rf /var/lib/apt/lists/*

# Clone your repository
ADD https://github.com/MuhammadBilal-Hub771/mern-app.git .
RUN npm install 
WORKDIR /opt/mern-app/frontend
RUN npm install
RUN npm run build
WORKDIR /opt/mern-app
EXPOSE 5000

# Start MongoDB and Nginx
CMD ["sh", "-c", "mongod --bind_ip_all --dbpath /data/db --logpath /var/log/mongodb/mongodb.log --fork && npm run server"]
