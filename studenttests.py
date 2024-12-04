from array import array
import sys
import unittest
from framework import AssemblyTest, print_coverage, _venus_default_args
from tools.check_hashes import check_hashes

"""
Coverage tests for project 2 is meant to make sure you understand
how to test RISC-V code based on function descriptions.
Before you attempt to write these tests, it might be helpful to read
unittests.py and framework.py.
Like project 1, you can see your coverage score by submitting to gradescope.
The coverage will be determined by how many lines of code your tests run,
so remember to test for the exceptions!
"""

"""
abs_loss
# =======================================================
# FUNCTION: Get the absolute difference of 2 int arrays,
#   store in the result array and compute the sum
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the length of the arrays
#   a3 (int*) is the pointer to the start of the result array

# Returns:
#   a0 (int)  is the sum of the absolute loss
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# =======================================================
"""


class TestAbsLoss(unittest.TestCase):
    def test_abs_loss(self):
        # load the test for abs_loss.s
        t = AssemblyTest(self, "../coverage-src/abs_loss.s")

        # create array0 in the data section
        arr0 = t.array([1,2,3,4,5,6,7,8,9])
        
        # load address of `array0` into register a0
        t.input_array("a0", arr0)
        
        # create array1 in the data section
        arr1 = t.array([1,6,1,6,1,6,1,6,1])
        
        
        # load address of `array1` into register a1
        t.input_array("a1", arr1)
        
        # set a2 to the length of the array
        t.input_scalar("a2", len(arr1))
        
        # create a result array in the data section (fill values with -1)
        arr2 = t.array([-1,-1,-1,-1,-1,-1,-1,-1,-1])
        
        # load address of `array2` into register a3
        t.input_array("a3", arr2)
        
        # call the `abs_loss` function
        t.call("abs_loss")
        
        # check that the result array contains the correct output
        t.check_array(arr2, [0,4,2,2,4,0,6,2,8])
        
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 28)
        
        # generate the `assembly/TestAbsLoss_test_simple.s` file and run it through venus
        t.execute()
        
    # Add other test cases if neccesary
        t = AssemblyTest(self, "../coverage-src/abs_loss.s")
        t.input_scalar("a2",-1)
        t.call("abs_loss")
        t.execute(code=36)


    @classmethod
    def tearDownClass(cls):
        print_coverage("abs_loss.s", verbose=False)


"""
squared_loss
# =======================================================
# FUNCTION: Get the squared difference of 2 int arrays,
#   store in the result array and compute the sum
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the length of the arrays
#   a3 (int*) is the pointer to the start of the result array

# Returns:
#   a0 (int)  is the sum of the squared loss
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# =======================================================
"""


class TestSquaredLoss(unittest.TestCase):
    def test_square_loss(self):
        # load the test for squared_loss.s
        t = AssemblyTest(self, "../coverage-src/squared_loss.s")
                
        # create input arrays in the data section
        arr0 = t.array([1,6,1,6,1,6,1,6,1])
        arr1 = t.array([1,2,3,4,5,6,7,8,9])
        
        # load array addresses into argument registers
        t.input_array("a0", arr0)
        t.input_array("a1", arr1)
        
        
        # load array length into argument register
        t.input_scalar("a2", len(arr0))
        
        # create a result array in the data section (fill values with -1)
        arr2 = t.array([-1,-1,-1,-1,-1,-1,-1,-1,-1])
        
        # load result array address into argument register
        t.input_array("a3", arr2)
        
        # call the `squared_loss` function
        t.call("squared_loss")
        
        # check that the result array contains the correct output
        t.check_array(arr2,[0,16,4,4,16,0,36,4,64])
        
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 144)
        
        # generate the `assembly/TestSquaredLoss_test_simple.s` file and run it through venus
        t.execute()

    # Add other test cases if neccesary
        t = AssemblyTest(self, "../coverage-src/squared_loss.s")
        t.input_scalar("a2", -1)
        t.call("squared_loss")
        t.execute(code=36)


    @classmethod
    def tearDownClass(cls):
        print_coverage("squared_loss.s", verbose=False)


"""
zero_one_loss
# =======================================================
# FUNCTION: Generates a 0-1 classifer array inplace in the result array,
#  where result[i] = (arr0[i] == arr1[i])
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the length of the arrays
#   a3 (int*) is the pointer to the start of the result array

# Returns:
#   NONE
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# =======================================================
"""


class TestZeroOneLoss(unittest.TestCase):
    def test_one_loss(self):
        # load the test for zero_one_loss.s
        t = AssemblyTest(self, "../coverage-src/zero_one_loss.s")
        
        # create input arrays in the data section
        arr0 = t.array([1,6,1,6,1,6,1,6,1])
        arr1 = t.array([1,2,3,4,5,6,7,8,9])
        
        # load array addresses into argument registers
        t.input_array("a0", arr0)
        t.input_array("a1", arr1)
        
        
        # load array length into argument register
        t.input_scalar("a2", len(arr0))
        
        # create a result array in the data section (fill values with -1)
        arr2 = t.array([-1,-1,-1,-1,-1,-1,-1,-1,-1])
        
        # load result array address into argument register
        t.input_array("a3", arr2)
        
        # call the `zero_one_loss` function
        t.call("zero_one_loss")
        
        # check that the result array contains the correct output
        t.check_array(arr2,[1,0,0,0,0,1,0,0,0])
        
        # generate the `assembly/TestZeroOneLoss_test_simple.s` file and run it through venus
        t.execute()

    # Add other test cases if neccesary
        t = AssemblyTest(self, "../coverage-src/zero_one_loss.s")
        t.input_scalar("a2", -1)
        t.call("zero_one_loss")
        t.execute(code=36)


    @classmethod
    def tearDownClass(cls):
        print_coverage("zero_one_loss.s", verbose=False)


"""
initialize_zero
# =======================================================
# FUNCTION: Initialize a zero array with the given length
# Arguments:
#   a0 (int) size of the array

# Returns:
#   a0 (int*)  is the pointer to the zero array
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# - If malloc fails, this function terminates the program with exit code 26.
# =======================================================
"""


class TestInitializeZero(unittest.TestCase):
    def test_initialize_zero(self):
        t = AssemblyTest(self, "../coverage-src/initialize_zero.s")
        
        # input the length of the desired array
        t.input_scalar("a0", 9)
        
        # call the `initialize_zero` function
        t.call("initialize_zero")
        
        # check that the register a0 contains the correct array (hint: look at the check_array_pointer function in framework.py)
        t.check_array_pointer("a0",[0,0,0,0,0,0,0,0,0])
        
        t.execute()

    # Add other test cases if neccesary
        t = AssemblyTest(self, "../coverage-src/initialize_zero.s")
        t.input_scalar("a0", -1)
        t.call("initialize_zero")
        t.execute(code=36)
        
        t = AssemblyTest(self, "../coverage-src/initialize_zero.s")
        t.input_scalar("a0", 2147483647)
        t.call("initialize_zero")
        t.execute(code=26)

        
    @classmethod
    def tearDownClass(cls):
        print_coverage("initialize_zero.s", verbose=False)


if __name__ == "__main__":
    split_idx = sys.argv.index("--")
    for arg in sys.argv[split_idx + 1 :]:
        _venus_default_args.append(arg)

    check_hashes()

    unittest.main(argv=sys.argv[:split_idx])
