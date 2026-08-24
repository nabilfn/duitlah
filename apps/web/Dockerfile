# Development image: runs the Next.js dev server against a bind-mounted
# source tree (see docker-compose.yml). Production deploys to Vercel
# (see docs/deployment.md) and do not use this image.
FROM node:22-alpine

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .

EXPOSE 3000
CMD ["npm", "run", "dev"]
