#!/bin/bash -e
# build.sh


TEXT_COLOR="\033[33m"
WHITE_COLOR="\033[37m"

function c_echo {
	echo -e ${TEXT_COLOR}$1${WHITE_COLOR}
}

############################################################################
############################################################################
############################################################################

c_echo "Setting build parameters..."

# BUILD_CONFIG="Debug"
BUILD_CONFIG="TestFlight"
TARGET_NAME="AfishaLviv"
PRODUCT_NAME="AfishaLviv"

############################################################################
############################################################################
############################################################################

PROJECT_ROOT_DIR="`pwd`"
BUILD_DIR="${PROJECT_ROOT_DIR}/build"
BUILD_CONFIG_DIR="${BUILD_CONFIG}-iphoneos" 
CONFIGURATION_BUILD_DIR="${BUILD_DIR}/Products/${BUILD_CONFIG_DIR}"
CONFIGURATION_TEMP_DIR="${BUILD_DIR}/Intermediates/${TARGET_NAME}.build/${BUILD_CONFIG_DIR}"

BUILD_LOGS_DIR="${BUILD_DIR}/Logs"
CURRENT_TIME="`date '+%Y%m%d%H%M'`"
TARGET_BUILD_LOG="${BUILD_LOGS_DIR}/${TARGET_NAME}_${CURRENT_TIME}.log"

c_echo "Deleting old build dir..."
rm -rf "${BUILD_DIR}" || true

c_echo "Creating logs dir..."
mkdir -p "${BUILD_LOGS_DIR}"

c_echo "Updating version numbers..."
if [ "$#" == 1 ]
then
	BUILD_NUMBER=$1
	agvtool new-version -all ${BUILD_NUMBER} >> ${TARGET_BUILD_LOG}
else 
	agvtool next-version -all >> ${TARGET_BUILD_LOG}
	BUILD_NUMBER=`agvtool vers -terse`	
fi
c_echo "Build version: ${BUILD_NUMBER}"

APP_FILE="${PRODUCT_NAME}.app"
IPA_FILE="${PRODUCT_NAME}_${BUILD_NUMBER}.ipa"
ZIP_FILE="${PRODUCT_NAME}_${BUILD_NUMBER}.zip"
OUTPUT_FOLDER="/Users/${USER}/builds/${TARGET_NAME}/${BUILD_NUMBER}/"

PROFILE_DIR="provisioning_profiles"
PROFILE_NAME="${TARGET_NAME}_AdHoc_Distribution.mobileprovision"
PROFILE_PATH="${PROJECT_ROOT_DIR}/${PROFILE_DIR}/${PROFILE_NAME}"
CODESIGN_IDENTITY="iPhone Distribution: Danylo Kostyshyn"
PROFILES_DIR="/Users/${USER}/Library/MobileDevice/Provisioning Profiles"
USER_KEYCHAIN="/Users/${USER}/Library/Keychains/login.keychain"
# SYSTEM_KEYCHAIN="/Library/Keychains/System.keychain"

############################################################################
############################################################################
############################################################################

c_echo "Installing provision profile..."
UUID=`grep UUID -A1 -a ${PROFILE_PATH} | grep -o "[-A-Z0-9]\{36\}"`
cp -f "${PROFILE_PATH}" "${PROFILES_DIR}/${UUID}.mobileprovision"
security unlock-keychain -p "kostyshyn" >> ${TARGET_BUILD_LOG}

c_echo "Building ${TARGET_NAME}..."
xcodebuild -workspace "${TARGET_NAME}.xcworkspace" \
			-scheme "${TARGET_NAME}" \
			-configuration "${BUILD_CONFIG}" \
			CODE_SIGN_IDENTITY="${CODESIGN_IDENTITY}" \
			PROVISIONING_PROFILE="${UUID}" \
			OTHER_CODE_SIGN_FLAGS="--keychain ${USER_KEYCHAIN}" \
			CONFIGURATION_BUILD_DIR="${CONFIGURATION_BUILD_DIR}" \
			CONFIGURATION_TEMP_DIR="${CONFIGURATION_TEMP_DIR}" \
			SYMROOT="${CONFIGURATION_TEMP_DIR}" \
			>> ${TARGET_BUILD_LOG}

c_echo "Signing and packing: \n\t${CONFIGURATION_BUILD_DIR}/${APP_FILE}"
c_echo "\tto ${CONFIGURATION_BUILD_DIR}/${IPA_FILE}"

xcrun -sdk iphoneos PackageApplication -v "${CONFIGURATION_BUILD_DIR}/${APP_FILE}" \
										-o "${CONFIGURATION_BUILD_DIR}/${IPA_FILE}" >> ${TARGET_BUILD_LOG}

# c_echo "Archiving contents of build dir..."
# zip -r -T -y "${ZIP_FILE}" "${CONFIGURATION_BUILD_DIR}/" "${CONFIGURATION_BUILD_DIR}/" >> ${TARGET_BUILD_LOG}

# c_echo "Deleting old zip..."
# rm *.zip || true

# c_echo "Creating dir: "${OUTPUT_FOLDER}"..."
# mkdir -p "${OUTPUT_FOLDER}"

# c_echo "Copying build to: "${OUTPUT_FOLDER}"..."
# cp "${ZIP_FILE}" "${OUTPUT_FOLDER}"

# Send app to TestFlight
TESTFLIGHT_API_TOKEN=""
TESTFLIGHT_TEAM_TOKEN=""

c_echo "Archiving dSYM..."
zip -v -r -T -y "${CONFIGURATION_BUILD_DIR}/${APP_FILE}.dSYM.zip" "${CONFIGURATION_BUILD_DIR}/${APP_FILE}.dSYM" >> ${TARGET_BUILD_LOG}

c_echo "Uploading to TestFlight..."

curl http://testflightapp.com/api/builds.json -F "file=@${CONFIGURATION_BUILD_DIR}/${IPA_FILE}" \
												-F "dsym=@${CONFIGURATION_BUILD_DIR}/${APP_FILE}.dSym.zip" \
												-F api_token=$TESTFLIGHT_API_TOKEN \
												-F team_token=$TESTFLIGHT_TEAM_TOKEN \
												-F notes='Uploaded by script' \
												-F notify=False \
												-F distribution_lists='Internal' \
												 >> ${TARGET_BUILD_LOG}

c_echo "Deleting build dir..."
rm -rf "${BUILD_DIR}" || true

c_echo "Done."

exit