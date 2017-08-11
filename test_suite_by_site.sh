#!/usr/bin/env bash
domain="${1}"
number_of_requests=(10 25 50 100 500 1000)
number_concurrent=(2 5 10 10 25 50)
number_of_tests=15

suite_count=$((${#number_of_requests[@]} -1 ))

if [[ "${#number_of_requests[@]}" -ne "${#number_concurrent[@]}" ]]; then
    echo "Array lengths don't match"
    exit
fi

for ((i=0; i<=$suite_count; i++))
  do
    ./run_tests.sh -c "${number_concurrent[i]}" -n "${number_of_requests[i]}" -x "${number_of_tests}" -d "${domain}"
done

echo "${domain}"
