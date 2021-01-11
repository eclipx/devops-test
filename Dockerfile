FROM node:14.3.0 as base-image

COPY ["package.json", "package-lock.json*", "./"]

RUN npm ci --only=production

RUN mkdir /app

RUN groupadd -r lirantal && useradd -r -s /bin/false -g lirantal lirantal

WORKDIR /app

COPY . .

RUN chown -R lirantal:lirantal /app


FROM base-image as final-image

COPY . .

USER lirantal

CMD [ "node", "server.js" ]