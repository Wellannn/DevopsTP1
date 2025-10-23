FROM node

WORKDIR /usr/src/app

RUN useradd -m -u 1001 appuser

COPY broken-app/ .

RUN npm install

RUN chown -R appuser:appuser /usr/src/app

USER appuser

EXPOSE 3000

CMD [ "node", "server.js" ]