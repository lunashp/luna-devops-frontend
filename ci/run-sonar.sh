# #!/bin/bash

# # 환경변수 체크
# if [ -z "$SONAR_HOST_URL" ]; then
#     echo "❌ Error: SONAR_HOST_URL 환경변수가 설정되지 않았습니다."
#     ./ci/update-redmine.sh "실패"
#     exit 1
# fi

# if [ -z "$SONAR_TOKEN" ]; then
#     echo "❌ Error: SONAR_TOKEN 환경변수가 설정되지 않았습니다."
#     ./ci/update-redmine.sh "실패"
#     exit 1
# fi

# echo "✅ SonarScanner 실행"
# echo "🔍 SONAR_HOST_URL: $SONAR_HOST_URL"

# # sonar-scanner 명령어가 있는지 확인
# if ! command -v sonar-scanner &> /dev/null; then
#     echo "❌ Error: sonar-scanner command not found"
#     ./ci/update-redmine.sh "실패"
#     exit 1
# fi

# if ! SCAN_OUTPUT=$(sonar-scanner \
#   -Dsonar.host.url="$SONAR_HOST_URL" \
#   -Dsonar.login="$SONAR_TOKEN" \
#   2>&1); then
#     echo "❌ SonarScanner 실행 중 에러 발생"
#     echo "📋 Error output:"
#     echo "$SCAN_OUTPUT"
#     ./ci/update-redmine.sh "실패"
#     exit 1
# fi

# echo "📋 SonarScanner 출력:"
# echo "$SCAN_OUTPUT"

# # Quality Gate 상태 확인
# if echo "$SCAN_OUTPUT" | grep -q "QUALITY GATE STATUS: FAILED"; then
#     echo "❌ Quality Gate 실패"
#     ./ci/update-redmine.sh "실패"
#     exit 1
# elif echo "$SCAN_OUTPUT" | grep -q "QUALITY GATE STATUS: PASSED"; then
#     echo "✅ Quality Gate 통과!"
#     ./ci/update-redmine.sh "성공"
#     exit 0
# fi

# # ceTaskUrl이 있는 경우 상세 분석 진행
# if echo "$SCAN_OUTPUT" | grep -q "ceTaskUrl"; then
#     echo "📦 분석 완료 후 ceTaskUrl 추출"
#     CE_TASK_URL=$(echo "$SCAN_OUTPUT" | grep -o '"ceTaskUrl":"[^"]*' | cut -d'"' -f4)
#     echo "📡 CE Task URL: $CE_TASK_URL"

#     echo "⏳ SonarQube 분석 상태 확인 중..."
#     for i in {1..60}; do
#         RESPONSE=$(curl -s -u "$SONAR_TOKEN:" "$CE_TASK_URL")
#         STATUS=$(echo "$RESPONSE" | grep -o '"status":"[^"]*' | cut -d':' -f2 | tr -d '"')
        
#         echo "🔄 현재 상태: $STATUS"

#         if [[ "$STATUS" == "SUCCESS" ]]; then
#             TASK_ID=$(echo "$CE_TASK_URL" | awk -F'/' '{print $NF}')
#             ANALYSIS_ID=$(curl -s -u "$SONAR_TOKEN:" "$SONAR_HOST_URL/api/ce/task?id=$TASK_ID" | grep -o '"analysisId":"[^"]*' | cut -d'"' -f4)
            
#             if [ -n "$ANALYSIS_ID" ]; then
#                 QUALITY_GATE_STATUS=$(curl -s -u "$SONAR_TOKEN:" "$SONAR_HOST_URL/api/qualitygates/project_status?analysisId=$ANALYSIS_ID" | grep -o '"status":"[^"]*' | cut -d'"' -f4)
#                 echo "🎯 Quality Gate 상태: $QUALITY_GATE_STATUS"
                
#                 if [[ "$QUALITY_GATE_STATUS" == "OK" ]]; then
#                     echo "✅ Quality Gate 통과!"
#                     ./ci/update-redmine.sh "성공"
#                     exit 0
#                 fi
#             fi
#             echo "❌ Quality Gate 검증 실패"
#             ./ci/update-redmine.sh "실패"
#             exit 1
#         elif [[ "$STATUS" == "FAILED" ]]; then
#             echo "❌ 분석 실패"
#             ./ci/update-redmine.sh "실패"
#             exit 1
#         fi

#         sleep 5
#     done

#     echo "⏰ 타임아웃: 분석 상태를 5분 내 확인하지 못함"
#     ./ci/update-redmine.sh "실패"
#     exit 1
# fi

# # SonarScanner 실행 결과 확인
# if echo "$SCAN_OUTPUT" | grep -q "EXECUTION SUCCESS"; then
#     echo "✅ 분석 성공!"
#     ./ci/update-redmine.sh "성공"
#     exit 0
# fi

# # 그 외의 경우는 실패로 처리
# echo "❌ 분석 실패"
# echo "$SCAN_OUTPUT"
# ./ci/update-redmine.sh "실패"
# exit 1

