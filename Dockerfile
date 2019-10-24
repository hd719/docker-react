# Build phase

# tagging as builder -> basically calling this phase "builder"
FROM node:alpine as builder
WORKDIR "/app"
COPY package.json .
RUN yarn install
COPY . .
RUN yarn run build

# Run phase

# Second FROM indicates second phase
FROM nginx

# In a development enviroment and actually in most enviroments the expose instruction is really suppose to be the communication between the container and dev
# So by default on our machines, this instruction does nothing automatically
# AWS Elasticbeanstalk is a bit different when it starts up your docker container, its going to look at this production ready docker file
# And its going to look for the expose instruction and whatever port is listed ElasticBeanStalk is going to map that port automatically
EXPOSE 80

# copies over from another phase
# copies over our /app/build directory into the html directory
COPY --from=builder /app/build /usr/share/nginx/html