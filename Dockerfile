# frontend-base
FROM 34.64.166.203:5000/devops-project/frontend-base:node20

WORKDIR /app

COPY dist/ /usr/share/nginx/html

# nginx 기반이면 ENTRYPOINT 필요 없음
