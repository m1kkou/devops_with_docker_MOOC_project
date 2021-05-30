FROM jekyll/jekyll:3.8.3 as build-stage

WORKDIR /tmp

COPY Gemfile* ./

RUN bundle install

WORKDIR /usr/src/app

COPY . .

RUN chown -R jekyll .

RUN jekyll build

FROM node:ubuntu

ENV PORT 80

RUN npm install -g serve

COPY --from=build-stage /usr/src/app/_site/ /usr/src/html

COPY . .

EXPOSE $PORT

CMD serve -l $PORT /usr/src/html
