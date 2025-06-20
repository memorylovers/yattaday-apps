#\!/bin/bash

# Fix test helper imports
echo "Fixing test helper imports..."
find test/features/record_items -name "*.dart" -type f -exec sed -i '' \
  -e 's < /dev/null | ../../../../test_helpers/record_item_helpers.dart|../../../../../test_helpers/record_item_helpers.dart|g' \
  {} \;

echo "Test imports fixed\!"
