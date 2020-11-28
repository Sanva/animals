NAME=animals

html5:
	node ~/app/Kha/make html5

run-html5:
	npx serve ./build/html5/

android-cpp:
	node ~/app/Kha/make android-native --arch arm8 --debug --compile
	cp ./build/android-native-build/${NAME}/app/build/outputs/apk/debug/app-debug.apk ./${NAME}-debug.apk

android-hl:
	node ~/app/Kha/make android-hl --arch arm8 --debug --compile

linux:
	node ~/app/Kha/make linux-native --compile

linux-debug:
	node ~/app/Kha/make linux-native --debug --compile

linux-armory:
	node ~/app/ArmorySDK-git/Kha/make linux-native --compile

run-linux:
	cd ./build/linux-native && ../linux-native-build/Release/${NAME}

run-linux-debug:
	cd ./build/linux-native && ../linux-native-build/Debug/${NAME}

linux-hl:
	node ~/app/Kha/make linux-hl --compile

linux-hl-armory:
	node ~/app/ArmorySDK-git/Kha/make linux-hl --compile

run-linux-hl:
	cd ./build/linux-hl && ../linux-hl-build/Release/${NAME}

# It looks like compilation must be in pi itself, I don't know how to crosscompile.
pi:
	node ~/app/Kha/make pi --compile