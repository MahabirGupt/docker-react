# Wriitng the section that is going to install all of our dependencies and run the  npm run build.
# Tagging this phase with a name
# From this command and everything underneath it, it is all going to be referred to as the builder phase.
# The sole purpose of this phase is to install dependencies and build our application.
FROM node:alpine as builder
# Specifying work directory
WORKDIR '/app'
# copy package.json file to the app directory
COPY package.json .
RUN npm install
# copy over all my source code
COPY . .
# The volume system that we were implementing with Docker compose was only required because we wanted to develop our application and have our changes immediately show up inside the container. When we are running our code in a production environment that is not a concern anymore because we are not changing our code at all.
# So we can just do a straight copy of all of our source codes directly into the container.
# After we copy all of our source code over we will then execute with the run command and run build.
RUN npm run build

# The output will be the build folder. /app/build

# Writing out the configuration for the actual run phase. This is the phase that will use nginx image where we are going to copy over the results of the build and then startup nginx.
FROM nginx
# Write out the command to copy over that build folder into nginx container.
COPY --from=builder /app/build /usr/share/nginx/html
# Staring up the container for nginx will automatically start up nginx.