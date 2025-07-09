#!/bin/bash
set -e

# 1. 환경 변수 체크
if [ -z "$SONAR_HOST_URL" ] || [ -z "$SONAR_TOKEN" ]; then
  echo "SonarQube 환경변수가 설정되지 않았습니다."
  exit 1
fi

if [ -z "$REDMINE_API_URL" ] || [ -z "$REDMINE_API_KEY" ] || [ -z "$REDMINE_ISSUE_ID" ]; then
  echo "Redmine 환경변수가 설정되지 않았습니다."
  exit 1
fi

# 2. Sonar Scanner 실행
echo "Sonar Scanner 실행 시작..."
SCAN_OUTPUT=$(sonar-scanner \
  -Dsonar.projectKey=my_project \
  -Dsonar.sources=. \
  -Dsonar.host.url="$SONAR_HOST_URL" \
  -Dsonar.login="$SONAR_TOKEN" \
  2>&1) || true

echo "$SCAN_OUTPUT"

# 3. 품질 게이트 결과 확인
if echo "$SCAN_OUTPUT" | grep -q "QUALITY GATE STATUS: FAILED"; then
  STATUS="실패"
elif echo "$SCAN_OUTPUT" | grep -q "QUALITY GATE STATUS: PASSED"; then
  STATUS="성공"
else
  STATUS="실패"
  echo "품질 게이트 상태를 확인할 수 없습니다. 실패로 처리합니다."
fi

# 4. Redmine 이슈 상태 업데이트
echo "Redmine 상태 업데이트: $STATUS"

if [[ "$STATUS" == "성공" ]]; then
  NEW_STATUS_ID=$REDMINE_SUCCESS_STATUS_ID
elif [[ "$STATUS" == "실패" ]]; then
  NEW_STATUS_ID=$REDMINE_FAIL_STATUS_ID
else
  echo "알 수 없는 상태값입니다: $STATUS"
  exit 1
fi

curl -X PUT "$REDMINE_API_URL/issues/$REDMINE_ISSUE_ID.json" \
  -H "X-Redmine-API-Key: $REDMINE_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"issue\": {\"status_id\": $NEW_STATUS_ID}}"

echo "Redmine 상태 변경 완료 (ID: $NEW_STATUS_ID)"

# 5. 종료 코드 설정
if [[ "$STATUS" == "성공" ]]; then
  exit 0
else
  exit 1
fi
