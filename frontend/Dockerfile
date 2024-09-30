FROM node:14

WORKDIR /app/frontend

COPY frontend/package*.json ./

RUN npm install

COPY ./frontend/ ./frontend/

EXPOSE 3000

CMD ["npm", "start"]
