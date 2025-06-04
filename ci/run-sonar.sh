bash
복사편집
#!/bin/bash
set -e

echo "✅ SonarScanner 실행"
SCAN_OUTPUT=$(sonar-scanner \
  -Dsonar.host.url="$SONAR_HOST_URL" \
  -Dsonar.login="$SONAR_TOKEN" \
  -X)

echo "📦 분석 완료 후 ceTaskUrl 추출"
CE_TASK_URL=$(echo "$SCAN_OUTPUT" | grep -o '"ceTaskUrl":"[^"]*' | cut -d'"' -f4)

if [ -z "$CE_TASK_URL" ]; then
  echo "❌ CE Task URL을 찾을 수 없습니다."
  exit 1
fi

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
exit 1

