package my_package;
    parameter MY_PARAMETER = 99; // Add this
    function automatic int add(input int a, input int b);
        return a + b;
    endfunction
endpackage
