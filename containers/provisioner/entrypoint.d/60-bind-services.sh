#!/bin/bash

prov_url="http://${EXTERNAL_IP%%/*}:${WEBPORT}"
mgmt_url="http://${EXTERNAL_IP%%/*}:${APIPORT}"

set_service_attrib provisioner-service provisioner-webservers \
 "{\"value\": [{\"url\": \"$prov_url\", \"address\": \"${EXTERNAL_IP%%/*}\", \"port\": $WEBPORT}]}"

set_service_attrib provisioner-service provisioner-management-servers \
 "{\"value\": [{\"url\": \"$mgmt_url\", \"address\": \"${EXTERNAL_IP%%/*}\", \"port\": $APIPORT}]}"
