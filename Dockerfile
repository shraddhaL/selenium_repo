FROM openjdk:8-jre-slim

#A Directory in the base image to copy our depedencies
WORKDIR /usr/share/tag

# Add the project jar & copy dependencies
ADD  target/container-test.jar container-test.jar
ADD  target/libs libs

# Add the suite xmls
ADD suite/test2-module.xml test2-module.xml
ADD suite/test1-module.xml test1-module.xml

# Command line to execute the test
# Expects below ennvironment variables
# BROWSER = chrome / firefox
# MODULE  = test2-module / test1-module
# SELENIUM_HUB = selenium hub hostname / ipaddress

ENTRYPOINT java -cp container-test.jar:libs/* -DseleniumHubHost=$SELENIUM_HUB -Dbrowser=$BROWSER org.testng.TestNG $MODULE
