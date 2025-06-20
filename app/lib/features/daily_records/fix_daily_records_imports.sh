#\!/bin/bash

echo "Fixing daily_records imports..."

# 1_models (旧domain)
find . -name "*.dart" -type f \! -name "*.g.dart" \! -name "*.freezed.dart" -exec sed -i '' \
  -e 's < /dev/null | daily_records/domain/record_item_history|daily_records/1_models/record_item_history|g' \
  {} \;

# 2_repository (旧data/repository)
find . -name "*.dart" -type f \! -name "*.g.dart" \! -name "*.freezed.dart" -exec sed -i '' \
  -e 's|daily_records/data/repository/|daily_records/2_repository/|g' \
  {} \;

# 3_application (旧application)
find . -name "*.dart" -type f \! -name "*.g.dart" \! -name "*.freezed.dart" -exec sed -i '' \
  -e 's|daily_records/application/providers/|daily_records/3_application/providers/|g' \
  -e 's|daily_records/application/use_cases/|daily_records/3_application/use_cases/|g' \
  {} \;

echo "daily_records imports fixed\!"
