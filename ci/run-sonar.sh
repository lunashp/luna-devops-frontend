#!/bin/bash
set -e

echo "✅ SonarScanner 실행"
SCAN_OUTPUT=$(sonar-scanner \
  -Dsonar.host.url="$SONAR_HOST_URL" \
  -Dsonar.login="$SONAR_TOKEN" \
  -X)

echo "📦 분석 완료 후 ceTaskId 추출"
CE_TASK_ID=$(echo "$SCAN_OUTPUT" | grep -oP '"ceTaskId":"\K[^"]+')

if [ -z "$CE_TASK_ID" ]; then
  echo "❌ CE Task ID를 찾을 수 없습니다."
  ./ci/update-redmine.sh "실패"
  exit 1
fi

CE_TASK_URL="${SONAR_HOST_URL}/api/ce/task?id=${CE_TASK_ID}"
echo "📡 CE Task URL: $CE_TASK_URL"

echo "⏳ SonarQube 분석 상태 확인 중..."
for i in {1..60}; do
  RESPONSE=$(curl -s -u "$SONAR_TOKEN:" "$CE_TASK_URL")
  STATUS=$(echo "$RESPONSE" | grep -o '"status":"[^"]*' | cut -d':' -f2 | tr -d '"')

  echo "🔄 현재 상태: $STATUS"

  if [[ "$STATUS" == "SUCCESS" ]]; then
    echo "✅ 분석 성공!"
    ./ci/update-redmine.sh "성공"
    exit 0
  elif [[ "$STATUS" == "FAILED" ]]; then
    echo "❌ 분석 실패!"
    ./ci/update-redmine.sh "실패"
    exit 1
  fi

  sleep 5
done

echo "⏰ 타임아웃: 분석 상태를 5분 내 확인하지 못함"
./ci/update-redmine.sh "실패"
exit 1
