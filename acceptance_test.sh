#!/bin/bash
set -e

HOST=${1:-localhost:8765}

echo "=== Acceptance Test: Book Library ==="

# Test 1: POST /books - Store a book
echo "[TEST 1] POST /books - Store a book"
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "http://${HOST}/books" \
  -H "Content-Type: application/json" \
  -d '{"title":"The Lord of the Rings","author":"J.R.R. Tolkien","isbn":"0395974682"}')

HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" -eq 201 ]; then
  echo "  PASS - Status: $HTTP_CODE"
  echo "  Response: $BODY"
else
  echo "  FAIL - Expected 201, got $HTTP_CODE"
  echo "  Response: $BODY"
  exit 1
fi

# Test 2: GET /books/0395974682 - Retrieve by ISBN
echo "[TEST 2] GET /books/0395974682 - Retrieve by ISBN"
RESPONSE=$(curl -s -w "\n%{http_code}" "http://${HOST}/books/0395974682")

HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" -eq 200 ]; then
  echo "  PASS - Status: $HTTP_CODE"
  echo "  Response: $BODY"

  # Verify content
  TITLE=$(echo "$BODY" | python3 -c "import sys,json; print(json.load(sys.stdin)['title'])" 2>/dev/null || echo "")
  if [ "$TITLE" = "The Lord of the Rings" ]; then
    echo "  PASS - Title matches"
  else
    echo "  FAIL - Title mismatch: got '$TITLE'"
    exit 1
  fi
else
  echo "  FAIL - Expected 200, got $HTTP_CODE"
  echo "  Response: $BODY"
  exit 1
fi

# Test 3: GET /books (list all)
echo "[TEST 3] GET /books - List all books"
RESPONSE=$(curl -s -w "\n%{http_code}" "http://${HOST}/books")

HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" -eq 200 ]; then
  echo "  PASS - Status: $HTTP_CODE"
  echo "  Response: $BODY"
else
  echo "  FAIL - Expected 200, got $HTTP_CODE"
  exit 1
fi

echo ""
echo "=== All acceptance tests PASSED ==="
