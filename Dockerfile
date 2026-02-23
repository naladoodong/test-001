FROM node:18-alpine

WORKDIR /app

# 패키지 파일 먼저 복사 (레이어 캐시 최적화)
COPY package*.json ./

RUN npm install

# 나머지 소스 복사
COPY . .

EXPOSE 3000

CMD ["node", "server.js"]

