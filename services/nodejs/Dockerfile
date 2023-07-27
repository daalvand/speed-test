FROM alpine

WORKDIR /app

RUN apk add --no-cache nodejs
RUN apk add --no-cache npm

COPY . .

RUN npm ci --omit=dev

CMD ["node", "index.js"]
