#! /bin/bash

input_video="templates/v210_flow.json"
input_audio="templates/audio_flow.json"
domains=("mxl0" "mxl1" "mxl2" "mxl3" "mxl4")
video_rates=(
  ["25"]="25/1"
  ["30"]="30/1"
  ["50"]="50/1"
  ["29"]="30000/1001"
  ["59"]="60000/1001"
)

for vrate in ${!video_rates[@]}; do
  num="$(cut -d'/' -f1 <<<"${video_rates["${vrate}"]}")"
  den="$(cut -d'/' -f2 <<<"${video_rates["${vrate}"]}")"
  for domain in ${domains[@]}; do
    mkdir -vp "${domain}"
    for i in $(seq -f "%02g" 0 11); do
      jq ". | .id = \"$(uuidgen)\"" <"${input_video}" |
        jq ". | .description = \"Test Video Flow ${i}\"" |
        jq ". | .tags.\"urn:x-nmos:tag:grouphint/v1.0\" = [\"Test Flow ${i}:video\"]" |
        jq ". | .label = \"test-video-flow-${i}\"" |
        jq ". | .grain_rate.numerator = ${num}" |
        jq ". | .grain_rate.denominator = ${den}" \
          >"${domain}/video_${vrate}_${i}.json"
      cat <<EOF >video_${domain}_${vrate}_${i}.conf
FLOW_DEF="$(pwd)/${domain}/video_${vrate}_${i}.json"
FLOW_TYPE=video
DOMAIN_DIR=/dev/shm/${domain}
EOF
    done
  done
done

for domain in ${domains[@]}; do
  mkdir -vp "${domain}"
  for i in $(seq -f "%02g" 0 11); do
    jq ". | .id = \"$(uuidgen)\"" <"${input_audio}" |
      jq ". | .description = \"Test Audio Flow ${i}\"" |
      jq ". | .tags.\"urn:x-nmos:tag:grouphint/v1.0\" = [\"Test Flow ${i}:audio\"]" |
      jq ". | .label = \"test-audio-flow-${i}\"" |
      jq ". | .source_id = \"$(uuidgen)\"" |
      jq ". | .device_id = \"$(uuidgen)\"" \
        >"${domain}/audio_${i}.json"
    cat <<EOF >audio_${domain}_${i}.conf
FLOW_DEF="$(pwd)/${domain}/audio_${i}.json"
FLOW_TYPE=audio
DOMAIN_DIR=/dev/shm/${domain}
EOF
  done
done
