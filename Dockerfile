# Образ Astra для Railway / Render / Fly.io / любого VPS.
#
# Собирается из корня репозитория:
#   docker build -t astra .
#
# Зависимостей нет намеренно — бэкенд работает на стандартной библиотеке Node,
# поэтому образ собирается где угодно без внешних зеркал.
FROM node:20-alpine

WORKDIR /app

COPY server/package.json ./
COPY server/src ./src

ENV PORT=4000
ENV HOST=0.0.0.0
# База — обычный JSON-файл. Без тома она пропадёт при каждом перезапуске,
# поэтому в панели хостинга обязательно подключи постоянный диск.
ENV ASTRA_DATA_DIR=/data
ENV SMS_MODE=dev

VOLUME /data
EXPOSE 4000

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s \
  CMD node -e "fetch('http://127.0.0.1:'+(process.env.PORT||4000)+'/api/health').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"

CMD ["node", "src/index.js"]