FROM node:20-alpine

ENV DATABASE_URL=postgresql://postgres:0796250443emilio@db.pvotaaukwfeabaqtahfu.supabase.co:5432/postgres \
    PORT=3000 
    

RUN npm install -g pnpm

WORKDIR /app

COPY ./backend/ .

RUN pnpm install

RUN pnpm build

EXPOSE 3000

CMD ["pnpm", "start"]

