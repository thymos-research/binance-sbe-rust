#!/usr/bin/env bash
set -euo pipefail

CODE_CACHE="target"
SBE_VERSION="1.35.6"

BINANCE_SCHEMA="https://raw.githubusercontent.com/binance/binance-spot-api-docs/refs/heads/master/sbe/schemas/stream_1_0.xml"
SCHEMA_DEST="${CODE_CACHE}/stream_1_0.xml"

#PROTOCOL_SCHEMA_DEST="crates/protocol/protocol_schema.xml"

MAVEN_URL="https://repo1.maven.org/maven2/uk/co/real-logic/sbe-all/${SBE_VERSION}/sbe-all-${SBE_VERSION}.jar"
SBE_JAR_DEST="${CODE_CACHE}/sbe-all.jar"

CODEGEN_OUTPUT="."

command="${1:-generate}"

mkdir -p "${CODE_CACHE}"

if [[ ! -f "${SBE_JAR_DEST}" ]]; then
    wget "${MAVEN_URL}" -O "${SBE_JAR_DEST}"
fi

if [[ ! -f "${SCHEMA_DEST}" ]]; then
    wget "${BINANCE_SCHEMA}" -O "${SCHEMA_DEST}"
fi


java \
    --add-opens java.base/jdk.internal.misc=ALL-UNNAMED \
    -Dsbe.target.language=Rust \
    -Dsbe.output.dir="${CODEGEN_OUTPUT}" \
    -jar "${SBE_JAR_DEST}" "${SCHEMA_DEST}"

# java \
#     --add-opens java.base/jdk.internal.misc=ALL-UNNAMED \
#     -Dsbe.target.language=Rust \
#     -Dsbe.output.dir="${CODEGEN_OUTPUT}" \
#     -jar "${SBE_JAR_DEST}" "${PROTOCOL_SCHEMA_DEST}"
