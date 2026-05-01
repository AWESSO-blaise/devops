# Stage 1 - build
FROM node:18-alpine AS builder
WORKDIR /app
COPY package.json .
RUN npm install --only=production

# Stage 2 - image finale légère
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
EXPOSE 3000
USER node
CMD ["node", "server.js"]
