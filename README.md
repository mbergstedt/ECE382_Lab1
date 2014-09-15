ECE382_Lab1
===========
##Assembly Language - "A Simple Calculator"
###Purpose
To build a simple calculator using Code Composer Studio.
###Software Flow Chart/Algorithms
The flow chart is:
[!alt text](https://github.com/mbergstedt/ECE382_Lab1/blob/master/Flowchart.JPG?raw=true)

Some pseudocode for the program is:
[!alt text](https://github.com/mbergstedt/ECE382_Lab1/blob/master/Pseudocode.JPG?raw=true)

###Hardware Schematic
The hardware schematic is simply the chip connected to the computer.
###Debugging
After writing each part for the code, I would run the debugger to make sure my code worked.  Upon running the first program, there were no issues. For the second program, I ran the debugger to test if my jumps would work for when the value went over the maximum allowable value or under the minimum allowable value.  On my first attempt at the third program, I discovered that my method of multiplying overshot the result because I was adding the value to itself and was not accounting for the value increasing after each loop through.  I fixed this by using an additional register that held the original value and adding that to the register that I was using to hold the result.
###Testing Methodology/Results
For testing the program, I used the provided test cases so that I had an easy way to check if the test was correct.  I tested each program after completing initial coding and compared it to the results for the provided test cases.  I stored each test case under the label of which program it went with so that I had an easy way to switch between the test cases.
###Observations and Conclusions
For the multiply function, it is like multiplying each of the values of one number by all of the values of the other.  With binary, it is adding a shifted version of the number every time that the multiplier has a one.  To do this, the multiplier should be shifted right with carry, if the carry holds a one, the value should be added and then shifted left.  In this way, you would be able to carry out multiplication in a short length of time.
###Documentation
Dr. York explained how the multiplication in O(log n) steps would have been done.

