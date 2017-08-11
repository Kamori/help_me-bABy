OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
verbose=0
number_of_tests=1
number_of_concurrent_tests=5
number_of_requests=20
domain=""

regular_IFS=" \t\n"
#Private Averages
avg_data_transferred=()
avg_median_total_connection_time=()
mean_connection_time=()
total_connection_time=()
average_requests_per_second=()
complete_total_complete=()
complete_total_failed=()


function show_help (){
   echo -e "Use -h for help
   \t -c # number of concurrent tests
   \t -n # numbers of requests
   \t -x # number of time to run the test
   \t -d URL url to test against, Must include protocall and complete URI (ex: http://google.com/)
   \t -v Verbosify, show AB outputs"
}

function run_test() {
    test_output=$(ab -n "${number_of_requests}" -c "${number_of_concurrent_tests}" "${domain}" 2>&1);
    if ((verbose)); then
        echo "${test_output}"
    fi
    _doc_length=$(echo "${test_output}" | grep "Total transferred:"| awk '{print $3}');
    _total_mean_conn_time=$(echo "${test_output}" | grep "Total:" | awk '{print $3}');
    _total_median_conn_time=$(echo "${test_output}" | grep "Total:" | awk '{print $5}');
    _min_conn_time=$(echo "${test_output}" | grep "Total:" | awk '{print $2}')
    _max_conn_time=$(echo "${test_output}" | grep "Total:" | awk '{print $6}')
    _avg_request_per_second=$(echo "${test_output}"| grep "Requests per second:" | awk '{print $4}')
    _total_completed_req=$(echo "${test_output}" | grep "Complete requests:" | awk '{print $3}')
    _total_failed_req=$(echo "${test_output}" | grep "Failed requests:" | awk '{print $3}')

    avg_data_transferred+=(${_doc_length})
    avg_median_total_connection_time+=(${_total_median_conn_time})
    mean_connection_time+=(${_total_mean_conn_time}) 
    total_connection_time+=(${_min_conn_time})
    total_connection_time+=(${_max_conn_time})
    average_requests_per_second+=(${_avg_request_per_second})
    complete_total_complete+=(${_total_completed_req})
    complete_total_failed+=(${_total_failed_req})
}

function do_loop() {
    for (( c=1; c<=${number_of_tests}; c++))
        do
          echo "Running test: ${c}"
          run_test
    done
    t_avg_data_transferred=$(average_array ${avg_data_transferred[*]})
    t_avg_median_total_connection_time=$(average_array ${avg_median_total_connection_time[*]})
    t_mean_connection_time=$(average_array ${mean_connection_time[*]})
    t_total_connection_time=$(min_max_array ${total_connection_time[*]})
    t_average_requests_per_second=$(average_array ${average_requests_per_second[*]})
    t_total_complete=$(total_array ${complete_total_complete[*]})
    t_total_failed=$(total_array ${complete_total_failed[*]})

    calc_totals
}

function average_array() {

   array_o_numbers=${@}
   sum=$(total_array ${array_o_numbers[*]})
   avg=$(echo "${sum}/${number_of_tests}" | bc)   
   echo "${avg}"

}

function total_array() {

   sum=0
   for i in ${@}
   do
      sum=$(echo "${sum}+${i}"| bc)

   done
   echo "${sum}"

}

function min_max_array() {
   arryso=${@}
   _min=
   _max=
   for i in ${arryso[@]}
    do
      if [[ -z "$_min" ]]; then
          _min="$i"
      fi
      if [[ -z "$_max" ]]; then
          _max="$i"
      fi
      if [[ "$i" -gt "$_max" ]]; then
        _max="$i"
      fi

      if [[ "$i" -lt "$_min" ]]; then
        _min="$i"
      fi
    done
   echo "${_min} : ${_max}"

}


function calc_totals(){
    echo -e "
Test averages
 \tDomain: ${domain}
 \tAvg Data transferred: ${t_avg_data_transferred[@]}
 \tAvg Median Total Connection Time: ${t_avg_median_total_connection_time[@]} 
 \tAvg Mean Total Connection Time: ${t_mean_connection_time[@]}
 \tMin : Max Connection Time: ${t_total_connection_time[@]}
 \tAverage Requests per Second: ${t_average_requests_per_second[@]}
 \tTotal Complete: ${t_total_complete[@]}
 \tTotal Failed: ${t_total_failed[@]}
"
}

while getopts "hvc:n:x:d:" opt; do
    case "$opt" in
    h)
        show_help
        exit 0
        ;;
    c)  number_of_concurrent_tests=$OPTARG
        ;;
    x)  number_of_tests=$OPTARG
        ;;
    n)  number_of_requests=$OPTARG
        ;;
    d)  domain=$OPTARG
        ;;
    v)  verbose=1
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift



echo "Running, ${number_of_tests} tests of ${number_of_requests} requests; ${number_of_concurrent_tests} at a time. Against ${domain}."
do_loop
