FROM alpine

WORKDIR /app

RUN apk add --no-cache nodejs
RUN apk add --no-cache npm

COPY . .

RUN npm ci --omit=dev

EXPOSE 80

CMD ["node", "index.js"]
