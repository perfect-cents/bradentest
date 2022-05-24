FROM launcher.gcr.io/google/nodejs

ARG service

RUN install_node v16.13.0

RUN yarn set version 1.22.5

WORKDIR /app

ENV NODE_ENV production

COPY . .

RUN yarn install --frozen-lockfile --production --unsafe-perm

WORKDIR /app

RUN yarn run build

WORKDIR /app/app

CMD ["yarn", "run", "start"]
