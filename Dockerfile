# First Stage: Build the application
FROM node:18-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application for production
RUN npm run build

# Second Stage: Serve the built application with a smaller base image
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy only the production build and package files from the build stage
COPY --from=build /app/dist ./dist
COPY --from=build /app/package*.json ./

# Install only production dependencies
RUN npm install --only=production

# Expose the port that the app runs on
EXPOSE 3000

# Command to serve the production build
CMD ["npm", "run", "preview"]
