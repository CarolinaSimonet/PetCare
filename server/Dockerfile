# Use the official Node.js image as the base image
FROM node:14

# Create and change to the app directory
WORKDIR /Users/joaohenriquegarcia/Documents/UNIVERSIDADE/4ANO/2SEMESTRE/SCMU/petcare/server/

# Copy package.json and package-lock.json
COPY package*.json ./

# Copy the service account key
COPY serviceAccountKey.json ./serviceAccountKey.json 

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the port the app runs on
EXPOSE 3000

# Start the server
CMD ["node", "index.js"]

