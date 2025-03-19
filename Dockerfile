# Node.js
FROM node:20 AS node

# Install Yarn
RUN corepack enable yarn

# Copy package.json
WORKDIR /usr/src/app
COPY package.json yarn.lock ./

# Install Yarn dependencies
RUN yarn install --frozen-lockfile

# Build Javascript
COPY config/esbuild.config.js config/esbuild.config.js
COPY app/javascript app/javascript
RUN yarn run build

# Build CSS
COPY app/assets/stylesheets app/assets/stylesheets
RUN yarn run build:css

###############
# Final image #
###############
FROM ruby:3.3.5 AS final

# Install dependencies
RUN apt-get update && apt-get install libvips42 imagemagick nodejs -y

# Copy in source
WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock ./

# Install dependencies
RUN bundle install

# Copy in source
COPY . .

# Copy build result from Node
COPY --from=node /usr/src/app/app/assets/builds/ /usr/src/app/app/assets/builds/

ENTRYPOINT [ "/usr/src/app/entrypoint.sh" ]