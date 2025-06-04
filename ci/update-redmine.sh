#!/bin/bash
set -e

STATUS=$1

if [[ "$STATUS" == "성공" ]]; then
  NEW_STATUS_ID=$REDMINE_SUCCESS_STATUS_ID
elif [[ "$STATUS" == "실패" ]]; then
  NEW_STATUS_ID=$REDMINE_FAIL_STATUS_ID
else
  echo "❌ 지원하지 않는 상태값: $STATUS"
  exit 1
fi

echo "📝 Redmine 이슈 상태 업데이트 중..."
curl -X PUT "$REDMINE_API_URL/issues/$REDMINE_ISSUE_ID.json" \
  -H "X-Redmine-API-Key: $REDMINE_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"issue\": {\"status_id\": $NEW_STATUS_ID}}"

echo "✅ Redmine 상태 변경 완료 (ID: $NEW_STATUS_ID)"

