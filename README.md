# luna-devops-frontend

GitLab CI → SonarQube 품질 게이트 → Redmine 이슈 갱신 파이프라인을 직접 구성해보기 위한
**학습·검증용 저장소**다. 제품이 아니라 파이프라인의 피사체(subject)로 쓰인 Vite + React +
TypeScript 앱이다.

파이프라인 구축 과정은 블로그에 정리해 두었다 —
[GitLab과 SonarQube 연동하기](https://jiny-log.vercel.app/ko/posts/gitlab-sonarqube-integration)

## 파이프라인

`main` 브랜치에 push 될 때만 돈다 (`.gitlab-ci.yml`).

```
main push
   │
   ▼
sonar-check 스테이지  (image: sonarsource/sonar-scanner-cli, runner tag: sonarqube)
   │
   ├─ ci/scan-and-update.sh
   │     1. 필수 환경변수 검증 — 없으면 즉시 실패
   │     2. sonar-scanner 실행
   │     3. 출력에서 QUALITY GATE STATUS 파싱
   │     4. 결과를 Redmine 이슈 상태로 PUT
   │
   ▼
품질 게이트 실패 → 잡 실패 (exit 1)
```

게이트를 통과 못 하면 스크립트가 `exit 1` 로 끝나므로 파이프라인도 실패한다.
`sonar-project.properties` 의 `sonar.qualitygate.wait=true` 가 스캐너 쪽에서도
게이트 판정을 기다리게 한다.

## 구성

| 파일 | 역할 |
|---|---|
| `.gitlab-ci.yml` | `sonar-check` 단일 스테이지 정의. `main` 브랜치 한정 |
| `ci/scan-and-update.sh` | 실제로 도는 스크립트. 스캔 → 게이트 판정 → Redmine 갱신 |
| `ci/run-sonar.sh` | 이전 시도. ceTaskUrl 폴링 방식이었고 현재는 전체 주석 처리 |
| `ci/update-redmine.sh` | Redmine 갱신을 분리했던 버전. 현재는 전체 주석 처리 |
| `sonar-project.properties` | 분석 대상(`src`)과 lcov 리포트 경로 |
| `Dockerfile` | 사설 Harbor 베이스 이미지에서 시작해 `dist/` 를 nginx 로 서빙 |
| `src`, `vite.config.ts` | 분석 대상 앱 (Vite + React + TypeScript) |

## 환경변수

CI 변수로 주입한다. 저장소에는 값이 없다.

| 이름 | 용도 |
|---|---|
| `SONAR_HOST_URL`, `SONAR_TOKEN` | SonarQube 접속·인증 |
| `REDMINE_API_URL`, `REDMINE_API_KEY`, `REDMINE_ISSUE_ID` | 갱신할 Redmine 이슈 |
| `REDMINE_SUCCESS_STATUS_ID`, `REDMINE_FAIL_STATUS_ID` | 성공/실패 시 설정할 상태 ID |

## 로컬 실행

```bash
pnpm install
pnpm dev
pnpm build      # dist/ 생성 — Dockerfile 이 이 결과물을 복사한다
```
