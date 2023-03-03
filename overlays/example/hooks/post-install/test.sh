#!/bin/sh

FAVORITE_COLOR=$(echo "$PROMPT_RESPONSE" | grep -E '^prompt/favorite_color:' | sed 's|^prompt/favorite_color:||g')
FAVORITE_COLOR=$(echo "$PROMPT_RESPONSE" | grep -E '^prompt/employee_id:' | sed 's|^prompt/employee_id:||g')
FAVORITE_COLOR=$(echo "$PROMPT_RESPONSE" | grep -E '^prompt/email_id:' | sed 's|^prompt/email_id:||g')
FAVORITE_COLOR=$(echo "$PROMPT_RESPONSE" | grep -E '^prompt/location:' | sed 's|^prompt/location:||g')
FAVORITE_COLOR=$(echo "$PROMPT_RESPONSE" | grep -E '^prompt/role:' | sed 's|^prompt/role:||g')
FAVORITE_COLOR=$(echo "$PROMPT_RESPONSE" | grep -E '^prompt/thank_you:' | sed 's|^prompt/thank_you:||g')

echo --- POST INSTALL ---
echo CWD $(pwd)
echo HOME $HOME
echo USER $USER
echo FAVORITE_COLOR $FAVORITE_COLOR
echo EMPLOYEE_ID $EMPLOYEE_ID
echo EMAIL_ID $EMAIL_ID
echo LOCATION $LOCATION
echo ROLE $ROLE
echo THANK_YOU $THANK_YOU
