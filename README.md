# steps ipa inspector

BITRISE Step to inspect the contents of a generated IPA

## Dependencies

This step uses the following ruby gems included:
* [CFPropertyList](https://github.com/ckruse/CFPropertyList)
* Lagunitas
    * [fork](https://github.com/birmacher/lagunitas)
    * [original](https://github.com/soffes/lagunitas)

## Input Environment Variables

* BITRISE_IPA_PATH (passed automatically)

## Output Environment Variables

* IPA_INSPECTOR_STATUS [success/failed]
* IPA_SIZE
* IPA_IDENTIFIER
* IPA_DISPLAY_NAME
* IPA_VERSION
* IPA_SHORT_VERSION
* IPA_CREATION_DATE
* IPA_EXPIRATION_DATE
* IPA_PROVISION_DEVICES
* IPA_ICON