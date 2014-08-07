#!/bin/bash

formatted_output_file_path="$BITRISE_STEP_FORMATTED_OUTPUT_FILE_PATH"

# Functions

function echo_string_to_formatted_output {
  echo "$1" >> $formatted_output_file_path
}

function write_section_to_formatted_output {
  echo '' >> $formatted_output_file_path
  echo "$1" >> $formatted_output_file_path
  echo '' >> $formatted_output_file_path
}

function echoStatusFailed {
  echo "export IPA_INSPECTOR_STATUS=\"failed\"" >> ~/.bash_profile
  echo
  echo "IPA_INSPECTOR_STATUS: \"failed\""
  echo " --------------"

  write_section_to_formatted_output "## Failed"
  write_section_to_formatted_output "Check the Logs for details."
}

# Script

write_section_to_formatted_output "# IPA Info"

echo "BITRISE_IPA_PATH: $BITRISE_IPA_PATH"

# IPA
if [[ ! -f "$BITRISE_IPA_PATH" ]]; then
  echo
  echo "No IPA found to deploy. Terminating..."
  echo
  echoStatusFailed
  exit 1
fi

echo "$ ruby inspect_ipa.rb \"$BITRISE_IPA_PATH\""
ruby inspect_ipa.rb "$BITRISE_IPA_PATH" "~/.bash_profile" "$formatted_output_file_path"

if [ $? -ne 0 ]; then
  echo
  echo "Failed to inspect IPA"
  echo
  echoStatusFailed
  exit 1
fi

echo "export IPA_INSPECTOR_STATUS=\"success\"" >> ~/.bash_profile
echo
echo "IPA_INSPECTOR_STATUS: \"success\""
echo " --------------"

exit 0