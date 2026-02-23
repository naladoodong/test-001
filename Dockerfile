FROM node:18-alpine
WORKDIR /app

# 패키지 정보 파일을 먼저 복사하고 라이브러리 설치
COPY package*.json ./
RUN npm install

# 나머지 진짜 코드들을 복사
COPY . .

EXPOSE 3000
CMD ["node", "server.js"]
