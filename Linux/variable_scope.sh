#!/bin/bash
# below code shows scope of variable 
myvar=10
myfunc() {
myvar=50
}
myfunc
echo $myvar