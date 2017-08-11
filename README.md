# Please bABy, help me test

I was designed to quickly and easily run a series of ApacheBench tests with fitting criterie. Allowing myself to design a wrapper to create myself a test suite when it comes to benchmarking:

### Usage
```
Use -h for help
   	 -c # number of concurrent tests
   	 -n # numbers of requests
   	 -x # number of time to run the test
   	 -d URL url to test against, Must include protocall and complete URI (ex: http://google.com/)
   	 -v Verbosify, show AB outputs
```

### Example
```
]$ ./run_tests.sh -c 100 -x 25 -n 1000 -d http://www.kamorigoat.com/
Running, 25 tests of 1000 requests; 100 at a time. Against http://www.kamorigoat.com/.
Running test: 1
Running test: 2
Running test: 3
Running test: 4
Running test: 5
Running test: 6
Running test: 7
Running test: 8
Running test: 9
Running test: 10
Running test: 11
Running test: 12
Running test: 13
Running test: 14
Running test: 15
Running test: 16
Running test: 17
Running test: 18
Running test: 19
Running test: 20
Running test: 21
Running test: 22
Running test: 23
Running test: 24
Running test: 25

Test averages
 	Domain: http://www.kamorigoat.com/
 	Avg Data transferred: 744970
 	Avg Median Total Connection Time: 100 
 	Avg Mean Total Connection Time: 107
 	Min : Max Connection Time: 94 : 15026
 	Average Requests per Second: 771
 	Total Complete: 25000
 	Total Failed: 1


```

### Todos
1 Create some data files (?json) that can be used to verify data ran across multiple nodes, this way I can be even lazier

2 Pass params directly to AB

3 Build web tool for the visual peoples

4 Send data to elastic search or something maybe to track over time.



