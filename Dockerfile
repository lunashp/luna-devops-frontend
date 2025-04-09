# 베이스 이미지: pnpm & node 환경 준비
FROM 34.64.84.30:5000/devops-project/frontend-base:node20 AS base

# corepack 및 pnpm 설치
RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /app

# 캐시 최적화를 위해 먼저 deps 복사
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

# 앱 소스 복사 후 빌드
COPY . .
RUN pnpm build

# 실제 서비스용 nginx 이미지 사용
FROM nginx:1.25-alpine AS production

COPY --from=base /app/dist /usr/share/nginx/html

# nginx 커스텀 설정 적용 시
# COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
