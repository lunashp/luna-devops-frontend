frontend-base
FROM luna-harbor.duckdns.org/luna-project/frontend-base:node20

WORKDIR /app


COPY dist/ /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]
